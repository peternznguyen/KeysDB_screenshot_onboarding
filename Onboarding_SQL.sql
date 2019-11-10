
Use Keys
Go
--1.a.Display a list of all property names and their property id’s for Owner Id: 1426
SELECT P.Name AS PropertyName, P.Id AS PropertyID
FROM dbo.Property P 
	INNER JOIN dbo.OwnerProperty OP	ON P.id=OP.PropertyId
WHERE OP.OwnerId=1426
ORDER BY PropertyName
--********************


--1.b. Display the current home value for each property in question a).
SELECT P.Name AS PropertyName, OP.OwnerId, OP.PropertyId, PHV.Value
FROM dbo.Property P 
	INNER JOIN dbo.OwnerProperty OP	ON P.id=OP.PropertyId
	INNER JOIN dbo.PropertyHomeValue PHV ON P.ID=PHV.PropertyId AND PHV.IsActive=1
WHERE OP.OwnerId=1426
ORDER BY PropertyName

--********************

--1.c.i.For each property in question a), return the following:
--Using rental payment amount, rental payment frequency, tenant start date and
--tenant end date to write a query that returns the sum of all payments from start date to end date.
SELECT 
	P.Name PropertyName, 
	TPF.Name FrequencyPay, 
	TP.PaymentAmount Payment,
	TP.StartDate, 
	TP.EndDate, 
	CASE WHEN TP.PaymentFrequencyId=1 THEN DATEDIFF(WEEK, TP.StartDate,tp.EndDate)*TP.PaymentAmount
		 WHEN TP.PaymentFrequencyId=2 THEN (DATEDIFF(WEEK, TP.StartDate,tp.EndDate)/2)*TP.PaymentAmount
		 WHEN TP.PaymentFrequencyId=3 THEN DATEDIFF(MONTH, TP.StartDate,tp.EndDate)*TP.PaymentAmount
	END SumOfAllPayment
FROM dbo.Property P 
	INNER JOIN dbo.OwnerProperty OP ON P.id=OP.PropertyId
	INNER JOIN dbo.TenantProperty TP ON OP.PropertyId=TP.PropertyId
	INNER JOIN dbo.TenantPaymentFrequencies TPF ON TP.PaymentFrequencyId=TPF.Id
WHERE OP.OwnerId=1426
ORDER BY PropertyName

--********************


--1.c.ii. Display the yield
SELECT P.Name PropertyName, OP.OwnerId, PS.FirstName+'  '+PS.LastName AS OwnerName, PF.Yield
FROM Property P
	INNER JOIN OwnerProperty OP ON P.ID=OP.PropertyId
	INNER JOIN Person PS ON PS.Id=OP.OwnerId
	INNER JOIN PropertyFinance PF ON P.Id=PF.PropertyId
WHERE OP.OwnerId=1426
ORDER BY PropertyName
--********************

--1.d Display all the jobs available in the marketplace (jobs that owners have advertised for service suppliers). 


SELECT DISTINCT P.Name PropertyName,PS.FirstName+' '+PS.LastName PropertyOwnerName, C.Name ServiceSupplierName, C.Website ServiceSupplierWebsite, JQ.Status JobAdvertisedStatus
FROM dbo.Property P 
	INNER JOIN dbo.OwnerProperty OP ON P.id=OP.PropertyId
	INNER JOIN dbo.Person PS ON OP.OwnerId=PS.Id
	INNER JOIN dbo.ServiceProvider SP on PS.ID=SP.ID
	INNER JOIN dbo.Company C ON SP.CompanyID=C.ID
	INNER JOIN dbo.JobQuote JQ on SP.Id=JQ.ProviderID
WHERE JQ.Status IN ('Opening')
ORDER BY PropertyOwnerName



--********************

--e. Display all property names, current tenants first and last names and rental payments
--per week/ fortnight/month for the properties in question a).
SELECT 
	P.Name PropertyName
	, OP.OwnerId
	, OP.PropertyId
	, PS.FirstName,PS.LastName
	, TPF.Name FrequencyPay
	, TP.PaymentAmount
FROM dbo.Property P 
	INNER JOIN dbo.OwnerProperty OP ON P.ID=OP.PropertyId
	INNER JOIN dbo.TenantProperty TP ON OP.PropertyId=TP.PropertyId
	INNER JOIN dbo.TenantPaymentFrequencies TPF ON TP.PaymentFrequencyId=TPF.Id
	INNER JOIN dbo.Person PS ON TP.TenantId=PS.ID
WHERE OP.OwnerId=1426
ORDER BY PropertyName

--********************
