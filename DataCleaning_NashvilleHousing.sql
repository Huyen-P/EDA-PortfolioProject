/* 

Cleaning Data in SQL Queries 

*/

SELECT *
FROM DataCleaning_PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDateConverted , CONVERT(Date,SaleDate)
FROM DataCleaning_PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date; 

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-----------------------------------------------------------------------------------------------------

-- Populate Property Address Data

Select *
From DataCleaning_PortfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress is null
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From DataCleaning_PortfolioProject.dbo.NashvilleHousing a
JOIN DataCleaning_PortfolioProject.dbo.NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From DataCleaning_PortfolioProject.dbo.NashvilleHousing a
JOIN DataCleaning_PortfolioProject.dbo.NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From DataCleaning_PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

From DataCleaning_PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255); 

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD  PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select*
From DataCleaning_PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
From DataCleaning_PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME (REPLACE(OwnerAddress,',','.'),1)
,PARSENAME (REPLACE(OwnerAddress,',','.'),2)
,PARSENAME (REPLACE(OwnerAddress,',','.'),3)
From DataCleaning_PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255); 

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD  OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity  = PARSENAME (REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD  OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState  = PARSENAME (REPLACE(OwnerAddress,',','.'),1)

Select *


--------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From DataCleaning_PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
	   When SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   End
From DataCleaning_PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
						When SoldAsVacant = 'N' THEN 'NO'
						Else SoldAsVacant
						End
----------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE As (
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num

From DataCleaning_PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)
--DELETE 
--FROM RowNumCTE
--Where row_num > 1
----Order By PropertyAddress

SELECT *
FROM RowNumCTE
Where row_num > 1
Order By PropertyAddress

--------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM DataCleaning_PortfolioProject.dbo.NashvilleHousing

ALTER TABLE DataCleaning_PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAdress, TaxDistrict, PropertyAddress

ALTER TABLE DataCleaning_PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

-------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO