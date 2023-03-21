
select * from nashvillehousing

--Cleaning Data in SQL Queries

select * from nashvillehousing

--Standardize Date Format

select saledateconverted, convert(date, saledate) from nashvillehousing

update nashvillehousing
set saledate= CONVERT(date,saledate)

alter table nashvillehousing
add saleDateConverted date;

update nashvillehousing
set saledateconverted= convert(date,saledate)


--Populate Property Address Date

select *from nashvillehousing
where propertyaddress is null
order by 2

select a.parcelid, a.propertyaddress,b.parcelid,b.propertyaddress, ISNULL(a.propertyaddress,b.propertyaddress)
from  nashvillehousing a
join nashvillehousing b
	on a.parcelid=b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null




update a
set propertyaddress=ISNULL(a.propertyaddress,b.propertyaddress)
from  nashvillehousing a
join nashvillehousing b
	on a.parcelid=b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

--Breaking Out Address into Individual Column( Address, City, State)

select propertyaddress from nashvillehousing

select 
substring(propertyaddress, 1,CHARINDEX(',', propertyaddress) -1) as Address,
substring(propertyaddress,CHARINDEX(',', propertyaddress) +1, len(propertyaddress)) as address
from nashvillehousing

alter table nashvillehousing
add PropertySplitAddress nvarchar(255)

alter table nashvillehousing
add PropertySplitcity nvarchar(255)


update nashvillehousing
set propertysplitaddress=substring(propertyaddress, 1,CHARINDEX(',', propertyaddress) -1)

update nashvillehousing 
set propertysplitcity=
substring(propertyaddress,CHARINDEX(',', propertyaddress) +1, len(propertyaddress))

select * from nashvillehousing



select owneraddress from nashvillehousing

select
PARSENAME(replace(owneraddress, ',', '.'),3)
,PARSENAME(replace(owneraddress, ',', '.'),2)
,PARSENAME(replace(owneraddress, ',', '.'),1)from nashvillehousing

--Change Y and N to Yes and No

select distinct(SoldAsVacant), count(SoldAsVacant) from NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
	when SoldAsVacant ='N' then 'No'
	else SoldAsVacant
	end
from NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant='Y' then 'Yes'
						when SoldAsVacant= 'N' then 'No'
						else SoldAsVacant
						end

select distinct(SoldAsVacant)  from NashvilleHousing

--Remove Duplicate



select *,
ROW_NUMBER() over(
partition by parcelID,
propertyaddress, saleprice, saledate, legalreference
order by uniqueid)row_num
from  NashvilleHousing
order by ParcelID


--Delete un-used columns

alter table nashvillehousing
drop column owneraddress, taxdistrict,propertyaddress

alter table nashvillehousing
drop column saledate

select * from NashvilleHousing