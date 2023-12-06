<!DOCTYPE html>
<html>
<head>
    <title>Customer Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        h1 {
            background-color: #333;
            color: #fff;
            padding: 10px;
            text-align: center;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        button {
            background-color: #007BFF;
            color: #fff;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .customer-data {
            flex: 1;
        }
        .buttons {
            display: flex;
            gap: 10px;
        }
        input {
            height: 30px;
            margin-top: 10px;
        }
        #jsonData {
            margin-top: 20px;
            height: 300px;
            width: 500px;
            background-color: #f0f0f0;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <h1>Customer Management</h1>
    <div class="container">
        <div class="buttons">
            <!-- HTML form to add a customer -->
            <form action="postCustomer.cfm" method="post" id="addCustomerForm">
    <textarea name="jsonData" id="jsonData" placeholder="Enter JSON data">{
        "displayName": "display name",
        "addressLine1": "address line 1",
        "addressLine2": "address line 2",
        "city": "AL",
        "country": "US",
        "state": "state",
        "postalCode": "12345",
        "phoneNumber": "1234567898",
        "email": "email@email.com",
        "taxAreaId": "a7481e22-20f1-ed11-a886-4ccc6a42c9c8"
    }</textarea>

   
    <cfinvoke component="Application" method="fetchTaxAreasId" returnVariable="taxAreas">

<!-- Use cfloop> to iterate through the outer array -->
<cfloop array="#taxAreas#" index="innerArray">
    <!-- Use cfloop again to iterate through the inner array -->
    <cfloop array="#innerArray#" index="arrayValue">
        <cfoutput>#arrayValue.id#<br></cfoutput>
    </cfloop>
</cfloop>

    <input type="submit" name="postCustomer" value="Add Customer">
</form>

<cfif isDefined("form.postCustomer")>
    <h3>Customers Data</h3>
    <cfinvoke component="Application" method="postCustomer" jsonData="#form.jsonData#" returnvariable="Result">
        <cfdump var="#Result#">
</cfif>
    </div>

   
</body>
</html>
