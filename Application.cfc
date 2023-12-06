<cfcomponent output="false">

    <cfinclude template="config.cfm">

    <cffunction name="generateAccessToken" access="public" returntype="struct">  <!-- Define a function named "generateAccessToken" with public access and a return type of struct -->
        <!-- Declare a variable named "result" and initialize it as an empty struct -->
        <cfset var result = {}>

        <!-- Send an HTTP POST request to the Microsoft Azure AD token endpoint to obtain an access token -->
        <cfhttp url="https://login.microsoftonline.com/34c5eebd-ed96-4f9e-a78a-c68158fbf4fe/oauth2/v2.0/token" method="post" result="result">
            <!-- Set the Content-Type header to indicate the form-urlencoded data -->
            <cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded">

            <!-- Specify the grant type as "client_credentials" for client credentials flow -->
            <cfhttpparam type="formfield" name="grant_type" value="client_credentials">

            <!-- Define the scope for the requested access token (here, it's for Business Central API) -->
            <cfhttpparam type="formfield" name="scope" value="https://api.businesscentral.dynamics.com/.default">

            <!-- Provide the client ID associated with the application registering for the access token -->
            <cfhttpparam type="formfield" name="client_id" value="b0ba116f-9070-43bd-9d61-9b240494d89a">

            <!-- Include the client secret for authentication during the token request -->
            <cfhttpparam type="formfield" name="client_secret" value="bhJ8Q~apTDMlnSdm4MwPPD.YF.yutAuIctAQ1cS5">
        </cfhttp>

        <!-- Deserialize the JSON response from the HTTP request and store it in the "result" variable -->
        <cfset result = deserializeJSON(result.fileContent)>

        <!-- Construct a new struct with the access token extracted from the JSON response -->
        <cfset result = {
            "access_token": result.access_token
        }>

        <!-- Return the struct containing the access token -->
        <cfreturn result>
    </cffunction>



<cffunction name="fetchTaxAreasId" access="remote" returntype="array">
    <!-- Define a function to fetch and populate tax area dropdown -->
    <cftry>
        <cfset var apiEndpoint="#apiBaseUrl#taxareas">

        <!-- Invoke the "generateAccessToken" method from the "Application" component to obtain an access token -->
        <cfinvoke component="Application" method="generateAccessToken" returnvariable="tokenData"></cfinvoke>

        <!-- Set up headers for the HTTP request -->
        <cfset myHeaders = {}>
        <cfset myHeaders["Content-Type"] = "application/json">
        <cfset myHeaders["Authorization"] = "Bearer " & tokenData.access_token>

        <!-- Make an HTTP GET request to the specified API endpoint -->
        <cfhttp url="#apiEndpoint#" method="GET">
            <cfhttpparam type="header" name="Content-Type" value="#myHeaders['Content-Type']#">
            <cfhttpparam type="header" name="Authorization" value="#myHeaders['Authorization']#">
        </cfhttp>

        <!-- Deserialize the JSON response from the API -->
        <cfset responseData = deserializeJSON(cfhttp.filecontent)>
         <cfdump var="#responseData#">


        <!-- Return the tax areas as an array or structure -->
        <cfreturn responseData.id>
    <cfcatch type="any">
        <cfreturn []>
    </cfcatch>
    </cftry>
</cffunction>








    <cffunction name="postCustomer" access="remote">
    <!-- Accepts a JSON string as an argument named "jsonData" -->
    <cfargument name="jsonData" type="string" required="true">

    <!-- Define the API endpoint for posting customer data -->
    <cfset var apiEndpoint = "#apiBaseUrl#customers"> 

    <!-- Invoke the "generateAccessToken" method from the "Application" component to obtain an access token -->
    <cfinvoke component="Application" method="generateAccessToken" returnvariable="tokenData"></cfinvoke>
        
    <!-- Set up headers for the HTTP request -->
    <cfset myHeaders = {}>
    <cfset myHeaders["Content-Type"] = "application/json">
    <cfset myHeaders["Authorization"] = "Bearer " & tokenData.access_token>

    <!-- Make an HTTP POST request to the specified API endpoint -->
    <cfhttp url="#apiEndpoint#" method="POST">
        <cfhttpparam type="header" name="Content-Type" value="#myHeaders['Content-Type']#">
        <cfhttpparam type="header" name="Authorization" value="#myHeaders['Authorization']#">
        <cfhttpparam type="body" value="#jsonData#">
    </cfhttp>

    <!-- Deserialize the JSON response from the API -->
    <cfset responseData = deserializeJSON(cfhttp.filecontent)>

    <!-- Check if the API request was successful (HTTP status codes 200 or 201) -->
    <cfif cfhttp.responseHeader.Status_Code eq 200 || cfhttp.responseHeader.Status_Code eq 201>
        <cftry>
            <!-- Define default values for some columns -->
            <cfset defaultLeadID = 1001>
            <cfset defaultBCTask = "postCustomer">
            <cfset defaultBCRequest = serializeJSON(jsonData)>
            <cfset defaultBCResponse = serializeJSON(responseData)>
            <cfset defaultBCHttpResponse = cfhttp.responseHeader.Status_Code>
            <cfset defaultBCRequestDate = now()>

            <!-- Store response data in the database -->
            <cfquery datasource="cpldev" name="insertCustomer">
                INSERT INTO bcrequests (Lead_ID, bc_Task, bc_Request, bc_Response, bc_httpResponse, bc_RequestDate)
                VALUES (
                    <cfqueryparam value="#defaultLeadID#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#defaultBCTask#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#defaultBCRequest#" cfsqltype="CF_SQL_LONGVARCHAR">,
                    <cfqueryparam value="#defaultBCResponse#" cfsqltype="CF_SQL_LONGVARCHAR">,
                    <cfqueryparam value="#defaultBCHttpResponse#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#defaultBCRequestDate#" cfsqltype="CF_SQL_TIMESTAMP">
                )
            </cfquery>
            
            <!-- Return the API response data -->
            <cfreturn "#responseData#">
        <cfcatch type="any">
            <!-- Handle JSON parsing errors -->
            <cfreturn "JSON parsing error: #cfcatch.message#">
        </cfcatch>
    </cftry>
    <cfelse>
        <!-- Return the HTTP status code if the API request was not successful -->
        <cfreturn cfhttp.responseHeader.Status_Code>
    </cfif>
</cffunction>







<cffunction name="postJob" access="remote">
    <!-- Accepts a JSON string as an argument named "jsonData" -->
    <cfargument name="jsonData" type="string" required="true">

    <!-- Dynamics 365 Business Central API endpoint for posting jobs -->
    <cfset apiEndpoint = "#apiBaseUrl#jobs">

    <!-- Invoke the "generateAccessToken" method from the "Application" component to obtain an access token -->
    <cfinvoke component="Application" method="generateAccessToken" returnvariable="tokenData"></cfinvoke>

    
    <!-- Set up headers for the HTTP request -->
    <cfset myHeaders = {}>
    <cfset myHeaders["Content-Type"] = "application/json">
    <cfset myHeaders["Authorization"] = "Bearer " & tokenData.access_token>

    <!-- Use a try-catch block to handle exceptions -->
    <cftry>
        <!-- Perform an API request using cfhttp with the method "POST" -->
        <cfhttp url="#apiEndpoint#" method="POST">
            <cfhttpparam type="header" name="Content-Type" value="#myHeaders['Content-Type']#">
            <cfhttpparam type="header" name="Authorization" value="#myHeaders['Authorization']#">
            <cfhttpparam type="body" value="#jsonData#">
        </cfhttp>

        <!-- Deserialize the JSON response from the API -->
        <cfset responseData = deserializeJSON(cfhttp.filecontent)>

        <!-- Check if the API request was successful (HTTP status codes 200 or 201) -->
        <cfif cfhttp.responseHeader.Status_Code eq 200 || cfhttp.responseHeader.Status_Code eq 201>
            <cftry>
                <!-- Define default values for some columns -->
                <cfset defaultLeadID = 1001>
                <cfset defaultBCTask = "postJob">
                <cfset defaultBCRequest = serializeJSON(jsonData)>
                <cfset defaultBCResponse = serializeJSON(responseData)>
                <cfset defaultBCHttpResponse = cfhttp.responseHeader.Status_Code>
                <cfset defaultBCRequestDate = now()>

                <!-- Store response data in the database -->
                <cfquery datasource="cpldev" name="insertJob">
                    INSERT INTO bcrequests (Lead_ID, bc_Task, bc_Request, bc_Response, bc_httpResponse, bc_RequestDate)
                    VALUES (
                        <cfqueryparam value="#defaultLeadID#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#defaultBCTask#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#defaultBCRequest#" cfsqltype="CF_SQL_LONGVARCHAR">,
                        <cfqueryparam value="#defaultBCResponse#" cfsqltype="CF_SQL_LONGVARCHAR">,
                        <cfqueryparam value="#defaultBCHttpResponse#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#defaultBCRequestDate#" cfsqltype="CF_SQL_TIMESTAMP">
                    )
                </cfquery>
                
                <!-- Return the API response data -->
                <cfreturn "#responseData#">
            <cfcatch type="any">
                <!-- Handle JSON parsing errors -->
                <cfreturn "JSON parsing error: #cfcatch.message#">
            </cfcatch>
        </cftry>
        <cfelse>
            <!-- Return the API response data if the request was not successful -->
            <cfreturn responseData>
        </cfif>

    <!-- Handle any exceptions that may occur during the process -->
    <cfcatch type="any">
        <!-- Create a structured error response -->
        <cfset responseData = {
            "error": "An error occurred while processing the request",
            "errorMessage": cfcatch.message
        }>
        <!-- Return the error response -->
        <cfreturn responseData>
    </cfcatch>
    </cftry>
</cffunction>






<cffunction name="postTask" access="remote">
    <!-- Accepts a JSON string as an argument named "jsonData" -->
    <cfargument name="jsonData" type="string" required="true">
    
    <!-- Dynamics 365 Business Central API endpoint for posting tasks -->
    <cfset apiEndpoint = "#apiBaseUrl#jobTaskLines">

    <!-- Set up headers for the API request -->
    <cfset myHeaders = {}>
    <cfset myHeaders["Content-Type"] = "application/json">

    <!-- Use a try-catch block to handle exceptions -->
    <cftry>
        <!-- Fetch access token by invoking the "generateAccessToken" method from the "Application" component -->
        <cfinvoke component="Application" method="generateAccessToken" returnvariable="tokenData"></cfinvoke>

        <!-- Perform an API request using cfhttp with the method "POST" -->
        <cfhttp url="#apiEndpoint#" method="POST">
            <cfhttpparam type="header" name="Content-Type" value="#myHeaders['Content-Type']#">
            <cfhttpparam type="header" name="Authorization" value="Bearer #tokenData.access_token#">
            <cfhttpparam type="body" value="#jsonData#">
        </cfhttp>

        <!-- Deserialize the JSON response from the API -->
        <cfset responseData = deserializeJSON(cfhttp.filecontent)>

        <!-- Check if the API request was successful (HTTP status codes 200 or 201) -->
        <cfif cfhttp.responseHeader.Status_Code eq 200 || cfhttp.responseHeader.Status_Code eq 201>
            <cftry>
                <!-- Define default values for some columns -->
                <cfset defaultLeadID = 1001>
                <cfset defaultBCTask = "postTask">
                <cfset defaultBCRequest = serializeJSON(jsonData)>
                <cfset defaultBCResponse = serializeJSON(responseData)>
                <cfset defaultBCHttpResponse = cfhttp.responseHeader.Status_Code>
                <cfset defaultBCRequestDate = now()>

                <!-- Store response data in the database -->
                <cfquery datasource="cpldev" name="insertTask">
                    INSERT INTO bcrequests (Lead_ID, bc_Task, bc_Request, bc_Response, bc_httpResponse, bc_RequestDate)
                    VALUES (
                        <cfqueryparam value="#defaultLeadID#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#defaultBCTask#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#defaultBCRequest#" cfsqltype="CF_SQL_LONGVARCHAR">,
                        <cfqueryparam value="#defaultBCResponse#" cfsqltype="CF_SQL_LONGVARCHAR">,
                        <cfqueryparam value="#defaultBCHttpResponse#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#defaultBCRequestDate#" cfsqltype="CF_SQL_TIMESTAMP">
                    )
                </cfquery>
                
                <!-- Return the API response data -->
                <cfreturn "#responseData#">
            <cfcatch type="any">
                <!-- Handle JSON parsing errors -->
                <cfreturn "JSON parsing error: #cfcatch.message#">
            </cfcatch>
        </cftry>
        <cfelse>
            <!-- Return the HTTP status code if the API request was not successful -->
            <cfreturn cfhttp.responseHeader.Status_Code>
        </cfif>

    <!-- Handle any exceptions that may occur during the process -->
    <cfcatch type="any">
        <!-- Create a structured error response -->
        <cfset responseData = {
            "error": "An error occurred while processing the request",
            "errorMessage": cfcatch.message
        }>
        <!-- Return the error response -->
        <cfreturn responseData>
    </cfcatch>
    </cftry>
</cffunction>



<cffunction name="postJobPlanningLines" access="remote">
<!-- Accepts a JSON string as an argument named "jsonData" -->
    <cfargument name="jsonData" type="string" required="true">
    
    <!-- Dynamics 365 Business Central API endpoint for posting tasks -->
    <cfset apiEndpoint = "#apiBaseUrl#jobPlanningLines">

    <!-- API request headers -->
    <cfset myHeaders = {}>
    <cfset myHeaders["Content-Type"] = "application/json">

    <!-- Use try-catch block to handle exceptions -->
    <cftry>
        <!-- Fetch access token -->
        <cfinvoke component="Application" method="generateAccessToken" returnvariable="tokenData"></cfinvoke>
        
        <!-- Perform API request using cfhttp with method "POST" -->
        <cfhttp url="#apiEndpoint#" method="POST">
            <cfhttpparam type="header" name="Content-Type" value="#myHeaders['Content-Type']#">
            <cfhttpparam type="header" name="Authorization" value="Bearer #tokenData.access_token#">
            <cfhttpparam type="body" value="#jsonData#">
        </cfhttp>
        

        <cfset responseData = deserializeJSON(cfhttp.filecontent)>
        <cfdump var="#responseData#">

        <cfif cfhttp.responseHeader.Status_Code eq 200 || cfhttp.responseHeader.Status_Code eq 201>
            <cftry>
                <!-- Define default values for some columns -->
                <cfset defaultLeadID = 1001>
                <cfset defaultBCTask = "postJobPlanningLines">
                <cfset defaultBCRequest = serializeJSON(jsonData)>
                <cfset defaultBCResponse = serializeJSON(responseData)>
                <cfset defaultBCHttpResponse = cfhttp.responseHeader.Status_Code>
                <cfset defaultBCRequestDate = now()>

                <!-- Store response data in the database -->
                <cfquery datasource="cpldev" name="insertTask">
                    INSERT INTO bcrequests (Lead_ID, bc_Task, bc_Request, bc_Response, bc_httpResponse, bc_RequestDate)
                    VALUES (
                        <cfqueryparam value="#defaultLeadID#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#defaultBCTask#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#defaultBCRequest#" cfsqltype="CF_SQL_LONGVARCHAR">,
                        <cfqueryparam value="#defaultBCResponse#" cfsqltype="CF_SQL_LONGVARCHAR">,
                        <cfqueryparam value="#defaultBCHttpResponse#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#defaultBCRequestDate#" cfsqltype="CF_SQL_TIMESTAMP">
                    )
                </cfquery>
                <cfreturn "#responseData#">
            <cfcatch type="any">
                <!-- Handle JSON parsing errors -->
                <cfreturn "JSON parsing error: #cfcatch.message#">
            </cfcatch>
        </cftry>
        <cfelse>
            <!-- Handle other status codes or errors here -->
            <cfreturn cfhttp.responseHeader.Status_Code>
        </cfif>

        <cfcatch type="any">
            <!-- Handle exceptions here -->
            <cfset responseData = {
                "error": "An error occurred while processing the request",
                "errorMessage": cfcatch.message
            }>
            <cfreturn responseData>
        </cfcatch>
    </cftry>
</cffunction>



</cfcomponent>
