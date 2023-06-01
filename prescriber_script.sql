SELECT *
FROM cbsa;
SELECT *
FROM drug;
SELECT * 
FROM fips_county;
SELECT *
FROM overdose_deaths;
SELECT *
FROM population;
SELECT * 
FROM prescriber;
SELECT * 
FROM prescription;
SELECT * 
FROM zip_fips;

--Q1A:David Coffey, claim:4538, npi: 19120117912
SELECT DISTINCT(npi),nppes_provider_first_name, nppes_provider_last_org_name, total_claim_count
FROM prescriber
INNER JOIN prescription
USING(NPI)
ORDER BY total_claim_count DESC;


--Q1B:David Coffey, Family Practice, npi:1912011792, claim:4538
SELECT DISTINCT(npi),nppes_provider_first_name, nppes_provider_last_org_name, total_claim_count,specialty_description
FROM prescriber
INNER JOIN prescription
USING(NPI)
ORDER BY total_claim_count DESC;


--Q2A:
SELECT specialty_description, SUM(total_claim_count) AS total_claim_count
FROM prescriber
INNER JOIN prescription
USING (NPI)
GROUP BY specialty_description
ORDER BY total_claim_count DESC;


--Q2B:FAMILY PRACTICE
SELECT specialty_description, total_claim_count,drug_name,opioid_drug_flag
FROM prescriber
INNER JOIN prescription
USING (NPI) 
INNER JOIN drug
USING (drug_name)
WHERE opioid_drug_flag = 'Y'
ORDER BY total_claim_count DESC;

--Q2C:
SELECT specialty_description, drug


--Q3A:PIRFENIDONE
SELECT drug_name, total_drug_cost, generic_name
FROM prescription
INNER JOIN drug
USING (drug_name)
ORDER BY total_drug_cost DESC;


--Q3B:C1 ESTERASE INHIBITOR
SELECT ROUND(SUM(total_drug_cost)/SUM(total_day_supply), 2) AS total_cost_per_day, generic_name
FROM prescription
INNER JOIN drug
USING (drug_name)
GROUP BY generic_name
ORDER BY total_cost_per_day DESC;


--Q4A:
SELECT drug_name, opioid_drug_flag, antibiotic_drug_flag,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
     WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	 ELSE 'neither' END AS drug_type
FROM drug;


--Q4B:opioids
SELECT SUM(total_drug_cost)::MONEY AS total_drug_cost,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
     WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	 ELSE 'neither' END AS drug_type
FROM drug
INNER JOIN prescription
USING (drug_name)
GROUP BY drug_type
ORDER BY total_drug_cost DESC;

--Q5A:10
SELECT COUNT (DISTINCT cbsa)
FROM cbsa AS c
INNER JOIN fips_county AS f
USING (fipscounty)
WHERE f.state = 'TN';

--Q5B:Nashville-Davidson--Murfreesboro--Franklin, TN 8773/Memphis TN-MS-AR 937847
SELECT cbsa.cbsaname, SUM(population.population)
FROM cbsa
JOIN population
USING (fipscounty)
GROUP BY cbsa.cbsaname, population.population
ORDER BY population.population DESC NULLS LAST;

--Q5C:Shelby, 937847
SELECT f.county, p.population
FROM fips_county AS f
JOIN population AS p 
USING (fipscounty)
GROUP BY f.county, p.population
ORDER BY p.population DESC;


--Q6A:
SELECT drug_name, total_claim_count
FROM prescription
where total_claim_count > 3000;

--Q6B:
SELECT drug_name, total_claim_count, opioid_drug_flag
FROM prescription
INNER JOIN drug
USING (drug_name)
WHERE total_claim_count > 3000;

--Q6C:
SELECT drug_name, total_claim_count, opioid_drug_flag, nppes_provider_first_name, nppes_provider_last_org_name
FROM prescription
INNER JOIN drug
USING (drug_name)
INNER JOIN prescriber
USING(npi)
WHERE total_claim_count > 3000;

--Q7A:
SELECT npi, drug_name, specialty_description
FROM prescriber
CROSS JOIN drug
WHERE specialty_description = 'Pain Management' 
AND nppes_provider_city = 'NASHVILLE' 
AND opioid_drug_flag = 'Y';

--Q7B:
SELECT npi, drug.drug_name, SUM(total_claim_count)
FROM prescriber
CROSS JOIN drug
INNER JOIN prescription USING (npi)
WHERE specialty_description = 'Pain Management' 
AND nppes_provider_city = 'NASHVILLE' 
AND opioid_drug_flag = 'Y'
GROUP BY npi, drug.drug_name;

--Q7C:
SELECT npi, drug.drug_name, SUM(total_claim_count)
FROM prescriber
CROSS JOIN drug
INNER JOIN prescription USING (npi)
WHERE specialty_description = 'Pain Management' 
AND nppes_provider_city = 'NASHVILLE' 
AND opioid_drug_flag = 'Y'
GROUP BY npi, drug.drug_name;