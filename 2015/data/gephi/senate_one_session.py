# script adapted by Peter Aldhous from http://nbviewer.ipython.org/urls/gist.github.com/rlucioni/1ef3c5c9412569b4c82d/raw/22bbb04b1ac700fd79c57379ad93c2fe6fc254d5/senate-voting-relationships

import json
import networkx as nx
from networkx.readwrite import json_graph
import requests
from itertools import combinations, permutations

# choose session and year

congress = 113
year = 2014

# scrapes a single JSON page for a particular Senate vote, given by the vote number

def get_senate_vote(vote):
    url = 'https://www.govtrack.us/data/congress/'+str(congress)+'/votes/'+str(year)+'/s{}/data.json'.format(vote)
    page = requests.get(url).text
    try:
        data = json.loads(page)
        return data
    except ValueError:
        raise Exception('Not a valid vote number')

# scrapes all the Senate votes from the same session/year, and returns a list of dicts

def get_all_votes():
    vote_num = 1
    vote_dicts = []
    while True:
        try:
            vote_dict = get_senate_vote(vote_num)
            vote_dicts.append(vote_dict)
            vote_num += 1
        except Exception:
            break
	print 'Processing vote '+str(vote_num)
    return vote_dicts

vote_data = get_all_votes()

# Function
# --------
# vote_graph
# 
# Parameters
# ----------
# data : list of dicts
#     The vote database returned from get_all_votes
# 
# Returns
# -------
# graph : NetworkX Graph object, with the following properties
#     1. Each node in the graph is labeled using the `display_name` of a Senator (e.g., 'Lee (R-UT)')
#     2. Each node has a `color` attribute set to 'r' for Republicans, 
#        'b' for Democrats, and 'k' for Independent/other parties.
#     3. The edges can be weighted by 'votes_agree,' the number of 
#        times two senators have cast the same Yea or Nay vote
#     4. The edges can also be weighted by 'percent_agree,' the previous attribute divided by the total number of votes in the session.
# 
# Examples
# --------
# >>> graph = vote_graph(vote_data)
# >>> graph.node['Lee (R-UT)']
# {'color': 'r'}  # attributes for this senator
# >>> len(graph['Lee (R-UT)']) # connections to other senators
# 101
# >>> graph['Lee (R-UT)']['Baldwin (D-WI)']  # edge relationship between Lee and Baldwin
# {'percent_agree': 0.19587628866, 'votes_agree': 57}


def vote_graph(data):
    graph = nx.Graph()
    
    # set for all senator display names - these will be our nodes
    all_senators = set()
    # list for roll_call dicts, one for each vote
    roll_calls = []
    for vote in data:
        # dict with keys for each vote class; values are lists of senator display names
        roll_call = {}
        for key, value in vote['votes'].iteritems():
            senators = []
            for senator in value:
                if senator == 'VP':
                    continue
                senators.append(senator['display_name'])
            roll_call[key] = senators
            # add any new senators to the set
            all_senators.update(senators)
        roll_calls.append(roll_call)
    
    # total number of votes, needed later to normalize edge attributes
    total_votes=float(len(roll_calls))    
    
    # all combinations of 2 senator display names
    all_senator_pairs = combinations(all_senators, 2)
    common_votes = {}
    for pair in all_senator_pairs:
        common_votes[pair] = 0
        
    for vote in roll_calls:
        yea_pairs = combinations(vote['Yea'], 2)
        for pair in yea_pairs:
            try:
                common_votes[pair] += 1
            except KeyError:
                # flip senator names so we can find the pair in the common_votes db
                common_votes[(pair[1],pair[0])] += 1
            
        nay_pairs = combinations(vote['Nay'], 2)
        for pair in nay_pairs:
            try:
                common_votes[pair] += 1
            except KeyError:
                common_votes[(pair[1],pair[0])] += 1
    
    for senator in all_senators:
        party = senator.split()[1][1]
        # node attributes
        if party == 'D':
            graph.add_node(senator, color='blue', party='D')
        elif party == 'R':
            graph.add_node(senator, color='red', party='R')
        else:
            graph.add_node(senator, color='green', party='I')
            
    for pair, votes in common_votes.iteritems():
        # don't draw an edge for senators with 0 votes in common
        if votes == 0:
            continue
        graph.add_edge(pair[0], pair[1], votes_agree=votes, percent_agree=votes/total_votes)
                
    return graph

# export network graph data in common formats    

votes = vote_graph(vote_data)
votes_json = json_graph.node_link_data(votes)

json.dump(votes_json, open('senate-'+str(congress)+'-'+str(year)+'.json','w'))
nx.write_gexf(votes, 'senate-'+str(congress)+'-'+str(year)+'.gexf')
nx.write_graphml(votes, 'senate-'+str(congress)+'-'+str(year)+'.graphml')
nx.write_pajek(votes, 'senate-'+str(congress)+'-'+str(year)+'.NET')


print 'Done!'



