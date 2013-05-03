<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Welcome To Human Resource Department</title>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js">
	
</script>
<script type="text/javascript">
	
</script>
</head>
<body>

	<p align="center">
		<b>Create User</b> <input id="create_user_button_id" type="button"
			value="Create User" onclick="createUser();" /><br> <br>
	</p>
	<form name="login_form" action="/project/user/create/" method="POST">
		<div>
			<table width="40%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top">
						<table border="0" cellspacing="0" cellpadding="4" width="40%">
							<tr>
								<td colspan="2">Create User
									<hr width="100%" size="1" noshade align="left">
								</td>
								<td></td>
							</tr>
							<tr>
								<td width="80">Employee Name</td>
								<td valign="top" align="left"><p>
										<b>Employee Name : </b><input type="text" name="employeeName"
											value="" size="35" /></td>
							</tr>
							<tr>
								<td width="80">Employee ID</td>
								<td valign="top" align="left"><p>
										<b>Employee ID : </b><input type="text" name="employeeId"
											value="" size="35" /></td>
							</tr>
							<tr>
								<td width="80">Email ID</td>
								<td valign="top" align="left"><p>
										<b>Email ID : </b><input type="text" name="emailId" value=""
											size="35" /></td>
							</tr>
							<tr>
								<td width="80">Designation</td>
								<td valign="top" align="left"><p>
										<b>Designation : </b><input type="text" name="designation"
											value="" size="35" /></td>
							</tr>
							<tr>
								<td><b>Select Manager : </b><select name="managerId">
										<option>Select</option>
										<option value="Rahul">Rahul</option>
										<option value="Vipul">Vipul</option>
										<option value="Abhijeet">Abhijeet</option>
								</select></td>
							<tr>
								<td><b>Select Role : </b><select name="department">
										<option>Select</option>
										<option value="10">Employee</option>
										<option value="20">Senior Management</option>
										<option value="30">Human Resource</option>
										<option value="40">Training Department</option>
										<option value="50">Appraisal & Compensation</option>
								</select></td>
								<td><input type="submit" value="Submit" /></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
	</form><%String username = (String)request.getAttribute("message");  
	if(username != null) out.print(username);%>

</body>
</html>