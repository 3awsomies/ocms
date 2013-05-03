<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>
	<%
		String userName = null;
		String userId = null;
		Cookie[] cookies = request.getCookies();
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals("user_name"))
				userName = cookie.getValue();
			if (cookie.getName().equals("userid"))
				userId = cookie.getValue();
		}
	%><%=userName%>'s Home Page
</title>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js">
	
</script>

<script type="text/javascript">
	function setCookie(c_name, value, exdays) {
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + exdays);
		var c_value = escape(value)
				+ ((exdays == null) ? "" : "; expires=" + exdate.toUTCString());
		document.cookie = c_name + "=" + c_value;
	}

	function getCookie(c_name) {
		var c_value = document.cookie;
		var c_start = c_value.indexOf(" " + c_name + "=");
		if (c_start == -1) {
			c_start = c_value.indexOf(c_name + "=");
		}
		if (c_start == -1) {
			c_value = null;
		} else {
			c_start = c_value.indexOf("=", c_start) + 1;
			var c_end = c_value.indexOf(";", c_start);
			if (c_end == -1) {
				c_end = c_value.length;
			}
			c_value = unescape(c_value.substring(c_start, c_end));
		}
		return c_value;
	}

	
</script>
</head>
<body>
	<div id="create_training_id">
		<form name="login_form" action="/ocms/create/employee/" method="POST">
			<div>
				<table width="40%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<table border="0" cellspacing="0" cellpadding="4" width="40%">
								<tr>
									<td colspan="2">Create Training Material
										<hr width="100%" size="1" noshade align="left">
									</td>
									<td></td>
								</tr>
								<tr>
									<td width="80">Training Name</td>
									<td valign="top" align="left"><p>
											<b>Training Name : </b><input type="text" name="trainingName"
												value="" size="35" /></td>
								</tr>
								<tr>
									<td valign="top" align="left"><b>Select Rating : </b><select
										name="ratingId">
											<jsp:include page="default_ratings.jsp">

											</jsp:include>
									</select></td>
								</tr>
								<tr>
									<td valign="top" align="left"><b>Select Skill : </b><select
										name="skillName">
											<jsp:include page="default_skills.jsp">

											</jsp:include>
									</select></td>
								<tr>
									<td><input type="submit" value="Submit" /></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
	<a href="http://localhost:8080/ocms">logout</a>
</body>
</html>