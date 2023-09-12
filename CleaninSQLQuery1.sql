SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [Portfolio Project].[dbo].[NashvilleHousing]


  USE [Portfolio Project]

  Select SaleDate,
  CONVERT(Date,SaleDate)
  From NashvilleHousing

  ALTER TABLE NashvilleHousing
  ALTER COLUMN SaleDate Date

  BEGIN TRANSACTION
	UPDATE NashvilleHousing
	SET SaleDate = CAST(SaleDate AS DATE)
  COMMIT TRANSACTION

  Select SaleDate
  From NashvilleHousing

  Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM NashvilleHousing a
  JOIN NashvilleHousing b
  ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  UPDATE a
  SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM NashvilleHousing a
  JOIN NashvilleHousing b
  ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  SELECT PropertyAddress, 
  SUBSTRING(propertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1),
  SUBSTRING(propertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyAddress))
  FROM NashvilleHousing

  AlTER TABLE NashvilleHousing
  ADD StreetAddress nchar(255)

  AlTER TABLE NashvilleHousing
  ADD City nchar(255)

  UPDATE NashvilleHousing
  SET StreetAddress = SUBSTRING(propertyAddress, 1 , CHARINDEX(',',PropertyAddress)-1)

  UPDATE NashvilleHousing
  SET City = SUBSTRING(propertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyAddress))


  SELECT StreetAddress, City
  From NashvilleHousing

  AlTER TABLE NashvilleHousing
  ADD OwnStreetAddress nchar(255)

  AlTER TABLE NashvilleHousing
  ADD OwnCity nchar(255)

  AlTER TABLE NashvilleHousing
  ADD OwnState nchar(255)

  Update NashvilleHousing
  SET OwnStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

  Update NashvilleHousing
  SET OwnCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
  
  Update NashvilleHousing
  SET OwnState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

  Select OwnStreetAddress,OwnCity,OwnState
  From NashvilleHousing

  Select DISTINCT(SoldAsvacant), COUNT(SoldAsvacant)
  From NashvilleHousing
  Group By SoldAsVacant

  Update NashvilleHousing
  SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END
		FROM NashvilleHousing

  Select DISTINCT(SoldAsvacant), COUNT(SoldAsvacant)
  From NashvilleHousing
  Group By SoldAsVacant

  Select * 
  From NashvilleHousing

  With RowNumCTE As(
  Select *, 
  ROW_NUMBER() Over(Partition By ParcelId,LegalReference Order By UniqueId) row_num
  From NashvilleHousing
  )
  DELETE
  From rowNumCTE
  where row_num > 1


  