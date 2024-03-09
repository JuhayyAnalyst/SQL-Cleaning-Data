/* 

Data cleaning in SQL 
Using Nashville housing data

*/ 

  

--Extracting Raw Data 

SELECT* 

FROM Project..NashvilleHousing 

---------------------------------------------
--Populate Property Address.

SELECT *
FROM Project..NashvilleHousing 
WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, A.PropertyAddress,
 ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM Project..NashvilleHousing AS A
JOIN Project..NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
WHERE A.PropertyAddress IS NULL
ORDER BY ParcelID

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM Project..NashvilleHousing AS A
JOIN Project..NashvilleHousing AS B
ON A.ParcelID = B.ParcelID
WHERE A.PropertyAddress IS NULL;


---------------------------------------------
  

--Breaking out property address into different column (Address, City and State) 

  

SELECT PropertyAddress 
FROM Project..NashvilleHousing 

  
SELECT  
SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) AS Address, 
SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City 
FROM Project..NashvilleHousing 

  
ALTER TABLE Project..NashvilleHousing 
ADD Address Nvarchar (50) 

  
UPDATE Project..NashvilleHousing
SET Address = SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) 

  

ALTER TABLE Project..NashvilleHousing 
ADD City Nvarchar (50) 


UPDATE Project..NashvilleHousing
SET City = SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) + 1, LEN(PropertyAddress)) 

  
SELECT Address, City 
FROM Project..NashvilleHousing 

  

SELECT OwnerAddress, OwnerName, 
RIGHT(OwnerAddress, 2) AS State 
FROM Project..NashvilleHousing 
WHERE OwnerAddress IS NOT NULL 
ORDER BY OwnerName 

  
ALTER TABLE Project..NashvilleHousing
ADD State Nvarchar (50) 

  

UPDATE Project..NashvilleHousing 
SET State = RIGHT(OwnerAddress, 2) 

  

  

---------------------------------------------------------------------- 

  

--Standardizing the date format 

  
SELECT CONVERT(date, SaleDate) AS Date 
FROM Project..NashvilleHousing 
  

ALTER TABLE Project..NashvilleHousing 
ADD Date Date 

UPDATE Project..NashvilleHousing
SET Date = CONVERT(date, SaleDate) 

SELECT Date
FROM Project..NashvilleHousing 



----------------------------------------------------------------------------- 

 --Populating Owners name

 SELECT ParcelID, OwnerName
 FROM  Project..NashvilleHousing 
WHERE OwnerName IS NULL

SELECT A.ParcelID, A.OwnerName, B.ParcelID, B.OwnerName,
ISNULL(A.OwnerName,B.OwnerName)
 FROM  Project..NashvilleHousing AS A
 JOIN Project..NashvilleHousing AS B
 ON A.ParcelID = B.ParcelID
 WHERE A.OwnerName IS NULL

 UPDATE A 
 SET OwnerName = ISNULL(A.OwnerName,B.OwnerName)
 FROM  Project..NashvilleHousing AS A
 JOIN Project..NashvilleHousing AS B
 ON A.ParcelID = B.ParcelID

--------------------------------------------------------

--Remove duplicates
WITH RN AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress ORDER BY ParcelID) AS RN
FROM  Project..NashvilleHousing
)
DELETE RN
WHERE RN > 1


--------------------------------------------------------

--DELETE UNUSED COLUMN

SELECT * ---PropertyAddress, SaleDate, TaxDistrict, HalfBath, FullBath.
FROM Project..NashvilleHousing

ALTER TABLE Project..NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate, TaxDistrict, HalfBath, FullBath

ALTER TABLE Project..NashvilleHousing
DROP COLUMN OwnerAddress

 /* Some of the code in here was inspired by Alex The Analyst. This project is for his bootcamp project. */
