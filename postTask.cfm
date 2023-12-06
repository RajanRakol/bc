<!DOCTYPE html>
<html>
<head>
    <title>Task Management</title>
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
        .buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        input {
            height: 30px;
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
    <h1>Task Management</h1>
    <div class="container">
        
        <form action="postTask.cfm" method="post" id="postTaskForm">
           
            <textarea name="jsonData" id="jsonData" placeholder="Enter JSON data">{
"jobNo": "23081238",
"jobTaskNo": "40010",
"description": "CONTRACT",
"jobTaskType": "Posting",
"territoryCode": "AUSTIN",
"jobTypeCode": "RES. NEW CON."
}</textarea>
            <input type="submit" name="postTask" value="Submit Task">
        </form>
        
        <cfif isDefined("form.postTask")>
            <!-- Include the CFML code for interacting with the Dynamics 365 Business Central API to post a task -->
            <cfinvoke component="Application" method="postTask" jsonData="#jsonData#" returnvariable="taskResult"></cfinvoke>
            <h3>Task Data</h3>
            <cfdump var="#taskResult#">
        </cfif>
    </div>
</body>
</html>

