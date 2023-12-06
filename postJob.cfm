<!DOCTYPE html>
<html>
<head>
    <title>Job Management</title>
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
        .job-data {
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
    <h1>Job Management</h1>
    <div class="container">
        <div class="buttons">
            <!-- HTML form to post a job -->
            <form action="postJob.cfm" method="post" id="postJobForm">
                <textarea name="jsonData" id="jsonData" placeholder="Enter JSON data">{
                   
                "sellToCustomerNo": "54781",
                "description": "Eye, Andrew & Sara"

}
                </textarea>
                <input type="submit" name="postJob" value="Post Job">
            </form>
        </div>
        <cfif isDefined("form.postJob")>
            <!-- Include the CFML code for interacting with the Dynamics 365 Business Central API -->
            <cfinvoke component="Application" method="postJob" jsonData="#jsonData#" returnvariable="jobData"></cfinvoke>
            <h3>Job Data</h3>
            <cfdump var="#jobData#">
        </cfif>
    </div>
</body>
</html>
