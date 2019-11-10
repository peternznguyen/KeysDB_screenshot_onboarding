
--2. SSRS Report 

--*Key_Prop_DataSet: query for report fields
SELECT P.Name AS PropertyName, PS.FirstName+' '+PS.LastName OwnerName,A.Number+' '+A.Street AS PropertyAddress, 
  	CAST(P.Bedroom  AS nvarchar(20))+' Bedrooms,'+' '+CAST(P.Bathroom  AS nvarchar(20))+' Bathrooms' Rooms,
 	'$'+CAST(FORMAT(PRP.Amount,'#,#') AS varchar(20)) +
	CASE PRP.FrequencyType  WHEN 1 THEN ' per week'
							WHEN 2 THEN ' per fortnight'
							WHEN 3 THEN ' per month'
	 END RentalPayment,
	 PE.Description AS ExpenseForWhat, PE.Amount AS AmountExpense, PE.Date AS DateExpense
FROM dbo.Property P
	LEFT JOIN dbo.OwnerProperty OP ON P.Id=OP.PropertyId
	RIGHT JOIN dbo.Person PS ON OP.OwnerId=PS.Id
	INNER JOIN dbo.Address A ON P.AddressId=A.AddressId
	LEFT JOIN dbo.PropertyRentalPayment PRP ON P.Id=PRP.PropertyId
	LEFT JOIN dbo.PropertyExpense PE on P.Id=PE.PropertyID
WHERE PE.Date IS NOT NULL AND (P.Name+' - '+A.Number+' '+A.Street)=@PropertyNameAddress



--*PropertyNameAddress_DataSet: For paraneter in the report to choose Property Name and Address
SELECT DISTINCT P.Name+' - '+A.Number+' '+A.Street AS PropertyNameAddress
FROM dbo.Property P 
	INNER JOIN dbo.Address A ON P.AddressId=A.AddressId
	LEFT JOIN PropertyExpense EP on P.Id=EP.PropertyId
WHERE EP.Date IS NOT NULL
ORDER BY PropertyNameAddress ASC
