SELECT * FROM Nashvillehousing;

----------------------------------------------------------------------------------------------------
--standarize date format

ALTER TABLE Nashvillehousing
ALTER COLUMN Saledate date;

select SaleDate from Nashvillehousing;

--------------------------------------------------------------------------------------------
--populate property address data

select UniqueID, ParcelID, PropertyAddress
from nashvillehousing;


select a.ParcelID,  a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject.dbo.Nashvillehousing a 
JOIN PortfolioProject.dbo.Nashvillehousing b
on a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

select a.ParcelID,  a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Nashvillehousing a 
JOIN PortfolioProject.dbo.Nashvillehousing b
on a.ParcelID = b.ParcelID
AND a. [UniqueID] <> b. [UniqueID]
where a.PropertyAddress is null

update a
set Propertyaddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.Nashvillehousing a 
JOIN PortfolioProject.dbo.Nashvillehousing b
on a.ParcelID = b.ParcelID
AND a. [UniqueID] <> b. [UniqueID]
where a.PropertyAddress is null
	
-------------------------------------------------------------------------------------------------------
--Breaking out address into (address, city, state)

select PropertyAddress
from nashvillehousing;

select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address
, substring(Propertyaddress, charindex(',', PropertyAddress) + 1, len(PropertyAddress)) as s_Address
from PortfolioProject.dbo.Nashvillehousing

--select charindex(',', propertyAddress) from Nashvillehousing;----

alter table nashvillehousing 
add PropertysplittAdress nvarchar(255);

update Nashvillehousing 
set PropertysplittAdress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1);

alter table nashvillehousing 
add PropertysplitCity nvarchar(255);

update Nashvillehousing 
set PropertysplitCity =
substring(Propertyaddress, charindex(',', PropertyAddress) + 1, len(PropertyAddress));

select * from Nashvillehousing;

alter table Nashvillehousing 
drop column PropertysplityCity;

-------------------------------------------------------------------------------------------------------------------------------
--splitt owner adress

select 
parsename(replace(Owneraddress, ',', '.'), 3)
,parsename(replace(Owneraddress, ',', '.'), 2)
,parsename(replace(Owneraddress, ',', '.'), 1)
from  Nashvillehousing;

alter table nashvillehousing 
add Ownersplitaddress nvarchar(255);

update Nashvillehousing 
set Ownersplitaddress =parsename(replace(Owneraddress, ',', '.'), 3);

alter table Nashvillehousing 
add Ownersplitcity nvarchar(255);

update Nashvillehousing 
set Ownersplitcity =parsename(replace(Owneraddress, ',', '.'), 2);

alter table Nashvillehousing 
add OwnersplitState nvarchar(255);

update Nashvillehousing 
set OwnersplitState =parsename(replace(Owneraddress, ',', '.'), 1);

----------------------------------------------------------------------------------------------------------------------------
----change Y and N in "sold" and "vacant" field 

select Distinct(SoldAsVacant), count(SoldAsVacant)
from Nashvillehousing
group by SoldAsVacant
order by 2;

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from nashvillehousing; 

update nashvillehousing
set SoldAsVacant =
case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from nashvillehousing; 

-------------------------------------------------------------------------------------------------------------------------
--remove duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
delete
From RowNumCTE
Where row_num > 1


Select *
From PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From PortfolioProject.dbo.NashvilleHousing


