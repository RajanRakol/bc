<!DOCTYPE html>
<html>
<head>
    <title>Job Planning Lines Management</title>
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
        
        .buttons {
            display: flex;
            gap: 10px;
        }
        
        #jsonData {
             margin-top: 20px;
            height: 400px;
            width: 500px;
            background-color: #f0f0f0;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <h1>Job Planning Lines Management</h1>
    <div class="container">
        <div class="buttons">
            <!-- HTML form to add a customer -->
            <form action="postJobPlanningLines.cfm" method="post" id="postJobPlanningLinesForm">
                <textarea name="jsonData" id="jsonData" placeholder="Enter JSON data">
               {
"jobNo": "23081238",
"jobTaskNo": "40010",
"lineType": "Billable",
"planningDate": "2014-01-02",
"PlannedDeliveryDate": "2014-01-02",
"documentNo": "EXCAVATION",
"type": "G/L Account",
"number": "4010",
"description": "EXCAVATION",
"description2": "",
"locationCode": "",
"variantCode": "",
"binCode": "",
"workTypeCode": "",
"unitOfMeasureCode": "EA",
"quantity": 1,
"unitCost": 0,
"unitPrice": 0,
"lineAmount": 0,
"qtyToTransferToJournal": 0
}
</textarea>
                <input type="submit" name="postJobPlanningLines" value="Add Job Planning Lines">
            </form>
        </div> 
        <cfif isDefined("form.postJobPlanningLines")>
            <h3>Customers Data</h3>
            <cfinvoke component="Application" method="postJobPlanningLines" jsonData="#jsonData#" returnvariable="Result">
            <cfdump var="#Result#">
        </cfif>
        
    </div>
</body>
</html>



