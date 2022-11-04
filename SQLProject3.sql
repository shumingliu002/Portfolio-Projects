/*

Cleaning Data in SQL Queries

*/
SELECT *

FROM PortfolioProject2.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted
FROM PortfolioProject2.dbo.NashvilleHousing

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data, where address is NULL


---identify NULL entries
SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL


--assume ParcelID is linked to PropertyAddress, if ParcelID a is same as ParcelID b, and b does not have address, populate b with address of a
--Find Null entries, join a copy of the table

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]!=b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--update table
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)--if a.PropertyAddress is null, then populate with b.PropertyAddress
FROM PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]!=b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Null entries are now populated
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject2.dbo.NashvilleHousing

--query returns string until first comma as address
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address
FROM PortfolioProject2.dbo.NashvilleHousing

--query returns string until first comma as address, removes the comma
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
FROM PortfolioProject2.dbo.NashvilleHousing

--query returns City, by removing address
SELECT
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1 , LEN(PropertyAddress)) AS City
FROM PortfolioProject2.dbo.NashvilleHousing


--update tables
ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing 
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------












