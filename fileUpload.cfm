<!--- 
	##
	## I love params ;). 
	## These are just here to set some defaults in the event that something goes awry or you don't 
	## pass in what you need from Flex. They shouldn't be needed
	##
--->
<cfparam name="form.uploadDir" type="string" default="/path/to/default/upload/directory/"/>
<cfparam name="form.fileType" type="string" default="jpg"/>
<!--- 
	## I 'love' wrapping everything in a try/catch...this is just a safety move to ensure the system doesn't choke on the user and 
	## that we (the developers) can get some details as to what happened. On a live site, I typically use cfmail to send myself the error. 
--->
<cftry>
	<cfscript>
		// Just setting the upload directory to the local (variables) scope
		variables.uploadDir = form.uploadDir;
	</cfscript>
	<!--- 
		## once we have the directory and form details, we can simply use CFFILE to upload to our spot on the server 
		## NOTE: When you use the upload() method of Flex's FileReference class, Flex automatically assigns the file data to a field called, 
		## wait for it...filedata!
		## Flex also automatically sends the data as multipart/form-data (so CF or PHP or whatever knows what type of data the form will carry)
	--->
	<cffile action="upload"
		filefield="filedata"
		destination="#variables.uploadDir#"
		nameconflict="overwrite"
		accept="application/octet-stream"
	/>
<!--- catch any error that may occur and then record it somewhere (this example writes a file to the server with error details) --->
<cfcatch type="any">
	<!--- you can build up the error string however you like. I decided to get both the cfcatch data AND the form data --->
	<cfset allErrors = cfcatch & "<br />" />
	<cfsavecontent variable="dumpContent">
		<cfdump var="#form#">
	</cfsavecontent>
	<cfset allErrors = allErrors & dumpContent/>
	<!--- Typically I'll use CFMAIL here to send myself the error message --->
	<cffile action="write" file="/path/to/error/logs/uploadError#Now()#.htm" output="#allErrors#" />
</cfcatch>
</cftry>