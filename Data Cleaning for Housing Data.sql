-- Cleaning Data

Select *
From PortfolioProject..dbo.HousingData



--Standard Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.HousingData


Update HousingData
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE HousingData
Add SaleDateConverted Date;

Update HousingData
SET SaleDateConverted = CONVERT(Date,SaleDate)





--Property Address Data

Select *
From PortfolioProject.dbo.HousingData
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.HousingData a
JOIN PortfolioProject.dbo.HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.HousingData a
JOIN PortfolioProject.dbo.HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null










--Separate Address (Address,City,State)


Select PropertyAddress
From PortfolioProject.dbo.HousingData

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City

From PortfolioProject.dbo.HousingData


ALTER TABLE HousingData
Add PropertySplitAddress Nvarchar(255);

Update HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE HousingData
Add PropertySplitCity Nvarchar(255);

Update HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject.dbo.HousingData





Select OwnerAddress
From PortfolioProject.dbo.HousingData


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.HousingData



ALTER TABLE HousingData
Add OwnerSplitAddress Nvarchar(255);

Update HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE HousingData
Add OwnerSplitCity Nvarchar(255);

Update HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE HousingData
Add OwnerSplitState Nvarchar(255);

Update HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.HousingData







--Change Status "Y" and "N" to Yes and No in "Sold as Vacant" Field

Select Distinct (SoldAsVacant) , Count(SoldAsVacant)
From PortfolioProject.dbo.HousingData
Group by SoldAsVacant
Order by 2




Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant= 'N' Then 'No'
		End
From PortfolioProject.dbo.HousingData


Update HousingData
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
				When SoldAsVacant = 'N' Then 'No'
				Else SoldAsVacant
				End








-- Remove Duplicates



With RowNumCTE AS(

Select*,

		ROW_NUMBER() Over(Partition by ParcelId,PropertyAddress,SalePrice,SaleDate,LegalReference
		Order By UniqueID) row_num

From PortfolioProject.dbo.HousingData
)

Select *

From RowNumCTE
Where Row_num>1
Order by PropertyAddress




Select *

From PortfolioProject.dbo.HousingData








--Remove Unused Columns


Select *

From PortfolioProject .dbo.HousingData

Alter Table PortfolioProject.dbo.HousingData

Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




