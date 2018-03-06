# Datasets

Click on the title links to download the data. Unzip the folder and place it on your desktop.

### [Download: Data analysis in R](data/r-analysis.zip)

Contains the following files:

- `ca_discipline.csv` Disciplinary alerts and actions issued by the Medical Board of California from 2008 to 2017. Processed from downloads available [here](http://www.mbc.ca.gov/Publications/Disciplinary_Actions/). Contains the following variables:

	- `alert_date` Date alert issued.
	- `last_name` Last name of doctor/health care provider.
	- `first_name` First name of doctor/health care provider.
	- `middle_name` Middle/other names.
	- `name_suffix` Name suffix (Jr., II etc)
	- `city` City of practive location.
	- `state` State of practice location.
	- `license` California medical license number.
	- `action_type` Type of action.
	- `action_date` Date of action.


- `ca_medicare_opioids.csv` Data on prescriptions of opioid drugs under the Medicare Part D Prescription Drug Program by doctors in California, from 2013 to 2015. Filtered from the national data downloads available [here](https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Part-D-Prescriber.html). It contains many variables, including:
  - `npi` [National Provider Identifier](https://npiregistry.cms.hhs.gov/) (NPI) for the doctor/organization making the claim. This is a unique code for each health care provider.
  - `nppes_provider_last_org_name` For individual doctors, their last name. For organizations, the organziation name.
  - `nppes_provider_first_name` First name for individual doctors, blank for organizations.
  - `nppes_provider_city` City where the provider is located.
  - `nppes_provider_state` State where the provider is located; "CA" for all of these records.
  - `specialty_description` Provider's medical speciality, reported on their medicare claims. For providers that have more than one Medicare specialty code reported on their claims, the code associated with the largest number of services.
  - `drug_name` Includes both brand names (drugs that have a trademarked name) and generic names (drugs that do not have a trademarked name).
  - `generic_name` The chemical ingredient of a drug rather than the trademarked brand name under which the drug is sold.
  - `bene_count` Total number of unique Medicare Part D beneficiaries (i.e. patients) with at least one claim for the drug. Counts fewer than 11 are suppressed and are indicated by a blank.
  - `total_claim_count` Number of Medicare Part D claims; includes original prescriptions and refills. If less than 11, counts are not included in the data file.
  - `total_drug_cost` Total cost paid for all associated claims; includes ingredient cost, dispensing fee, sales tax, and any applicable fees.
  - `year` 2013, 2014, or 2015.

- `npi_license.csv` Crosswalk file to join NPI identifiers to state license numbers, processed from the download available [here](http://www.nber.org/data/npi-state-license-crosswalk.html) to include license numbers potentially matching California doctors. This will provide one way of joining the precription data to the medical board disciplinary data. As we shall see, problems with the data mean that it is not infallible. Contains the following variables:
 - `npi` National Provider Identifier, as described above.
 - `plicnum` State license number, from the original file.
 - `license` Processed from `pclicnum` to conform to the format of California medical license numbers.


