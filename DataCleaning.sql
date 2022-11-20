--Standardize Date Format

SELECT SaleDate
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)

SELECT SaleDateConverted
FROM PortfolioProject..NashvilleHousing


--Populate property address data

Select ParcelID, PropertyAddress
From PortfolioProject..NashvilleHousing 
Where PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM PortfolioProject..NashvilleHousing as a
JOIN PortfolioProject..NashvilleHousing as b
    on a.ParcelID = b.ParcelID
    and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL
and b.PropertyAddress is not NULL

UPDATE a
SET a.PropertyAddress = b.PropertyAddress
FROM PortfolioProject..NashvilleHousing as a
JOIN PortfolioProject..NashvilleHousing as b
    on a.ParcelID = b.ParcelID
    and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL
and b.PropertyAddress is not NULL


--Breaking out address into individual columns (Address, City, State)

SELECT   
SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySpilitAddress NVARCHAR(255)

UPDATE NashvilleHousing
Set PropertySpilitAddress = SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySpilitCity NVARCHAR(255)

UPDATE NashvilleHousing
Set PropertySpilitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSpilitAddress NVARCHAR(255)

ALTER TABLE NashvilleHousing
Add OwnerSpilitCity NVARCHAR(255)

ALTER TABLE NashvilleHousing
Add OwnerSpilitState NVARCHAR(255)

UPDATE NashvilleHousing
Set OwnerSpilitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE NashvilleHousing
Set OwnerSpilitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE NashvilleHousing
Set OwnerSpilitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT * 
From NashvilleHousing


--Changing 'N' to 'No' and 'Y' to 'Yes' in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
From NashvilleHousing
GROUP by SoldAsVacant

SELECT SoldAsVacant,
Case When SoldAsVacant = 'N' Then 'No'
     When SoldAsVacant = 'Y' Then 'Yes'
     Else SoldAsVacant
     End
From NashvilleHousing

UPDATE NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'N' Then 'No'
     When SoldAsVacant = 'Y' Then 'Yes'
     Else SoldAsVacant
     End


--Delete Duplicate
 

With RowNumCTE as (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID,
                                PropertyAddress,
                                SaleDate,
                                LegalReference
                                 ORDER BY ParcelID) as RowNumber
From NashvilleHousing
)
Select *
FROM RowNumCTE
Where RowNumber>1
order by ParcelID


--Delete unused columns

ALTER TABLE NashvilleHousing
Drop COLUMN SaleDate, PropertyAddress, OwnerAddress, TaxDistrict

