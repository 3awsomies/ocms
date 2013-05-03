<%@page import="java.util.Iterator"%>
<%@page import="com.cms.models.Position"%>
<%@page import="java.util.List"%>
<%@page import="com.cms.dao.impl.EmployeeDaoImpl"%>
<%@page import="com.cms.dao.EmployeeDao"%>
<%@page import="com.cms.models.Employee"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Welcome <%
	Cookie[] cookies = request.getCookies();
	String userName = null;
	for (Cookie cookie : cookies) {
		if (cookie.getName() == "user_name")
			userName = cookie.getValue();
	}
%><%=userName%> !!
</title>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js">
	
</script>
<script type="text/javascript">
	
	function saveRecommendation(el) {
		//alert(el.id);
		var str=el.id;
		var rowposition = parseInt(str.charAt(str.length-1))+1;
		var table = document.getElementById("project_details_table_id");
		var allRows = table.rows;
		var reco_row = allRows[rowposition];
		var reco_cell = reco_row.cells[4];
		var text = reco_cell.childNodes[0].value;
		var positionId = reco_row.cells[0].textContent;
		alert(text +":::: "+positionId);
		var url = location.protocol + "//" + location.host
		+ "/ocms/manager/save/recommendation/"+text+"/"+positionId;
		$.ajax({
			url : url,
			type : "POST",
			contentType : 'application/json',
			dataType : 'json',
			converters : {
				'json' : jQuery.parseJSON
			},
			success : function(data) {
				localdata = data;
				alert("success");
			},
			error : function(jqXHR, textStatus, errorThrown) {
				//alert(textStatus + ':' + errorThrown);
			}
		});
	}
</script>
</head>
<body>

	<p align="center">
		<b>Create User</b> <input id="create_user_button_id" type="button"
			value="Create User" onclick="createUser();" /><br> <br>
	</p>
	<div id="create_employee_id">
		<form name="login_form" action="/ocms/create/employee/" method="POST">
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
		</form>
	</div>

	<div>
		<table id="project_details_table_id" cellpadding="1" cellspacing="1"
			border="1">
			<tr>
				<td>Project ID</td>
				<td>Project Name</td>
				<td>Created By</td>
				<td>Status</td>
				<td>View Details</td>
				<td>Recommendations</td>
				<td>Action</td>
			</tr>
			<%
				EmployeeDao employeeDao = new EmployeeDaoImpl();
				List<Position> positions = employeeDao.getListOfPositions();
				Iterator<Position> iterator = positions.iterator();
				int counter = 0;
				while (iterator.hasNext()) {
					Position position = iterator.next();
			%>
			<tr>
				<td><%=position.getPositionId()%></td>
				<td><%=position.getPositionName()%></td>
				<td><%=position.getCreatedBy()%></td>
				<td><%=position.getStatus()%></td>
				<td><textarea rows="5" cols="100"><%=position.getRecommendation()%></textarea>
				</td>
				<td><input type="button" value="Save Recommendation"
					id=<%="recommendation"+counter %> onclick="saveRecommendation(this)"></td>
			</tr>
			<%
				}
			%>
		</table>
	</div>

</body>
</html>