<%@page import="java.util.Iterator"%>
<%@page import="com.cms.dao.impl.EmployeeDaoImpl"%>
<%@page import="com.cms.dao.EmployeeDao"%>
<%@page import="com.cms.models.Employee"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>
	<%
		String managerName = null;
		String managerId = null;
		Cookie[] cookies = request.getCookies();
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals("user_name"))
				managerName = cookie.getValue();
			if (cookie.getName().equals("userid"))
				managerId = cookie.getValue();
		}
	%><%=managerName%>'s Home Page
</title>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js">
	
</script>
<script type="text/javascript">
	var skillCount = 0;

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

	function createSkillRatingRow() {
		var table = $("#create_position_skills_table_id");
		var row = document.createElement("TR");
		var skillCell = document.createElement("TD");
		row.appendChild(skillCell);
		$(skillCell).load("default_skills.jsp");
		var ratingCell = document.createElement("TD");
		row.appendChild(ratingCell);
		$(ratingCell).load("default_ratings.jsp");
		table.append(row)
	}

	function populateSkillTable() {

		//var userid = getCookie("userid");
		var userid = "10000";
		getSkillData(userid)

	}

	function getSkillData(userid) {
		var localdata;
		var url = location.protocol + "//" + location.host
				+ "/ocms/employee/skills/" + userid;
		$.ajax({
			url : url,
			contentType : 'application/json',
			dataType : 'json',
			converters : {
				'json' : jQuery.parseJSON
			},
			success : function(data) {
				localdata = data;
				constructEmployeeTable(localdata);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(textStatus + ':' + errorThrown);
			}
		});
	}

	function constructEmployeeTable(data) {
		var skilldata = data.skills;
		var skillDataJson = $.parseJSON(skilldata);
		var skillarr = [];
		$.each(skillDataJson, function() {
			skillarr.push(this['skillName']);
		});

		$.each(skillarr, function(index, item) {
			createSkillRow(skillarr[index]);
		});
	}

	function createSkillRow(skillName) {
		var table = $("#rating_skill_table_id");
		var row = document.createElement("TR");
		var skillCell = document.createElement("TD");
		var skillTextNode = document.createTextNode(skillName);
		skillCell.appendChild(skillTextNode);
		row.appendChild(skillCell);
		var ratingCell = document.createElement("TD");
		row.appendChild(ratingCell);
		$(ratingCell).load("default_ratings.jsp");
		table.append(row)
	}

	function populateCompleteSkillSet() {
		var userid = "10000";
		getCompleteSkillSet(userid)
	}

	function getCompleteSkillSet(userid) {
		var localdata;
		var url = location.protocol + "//" + location.host
				+ "/ocms/employee/skillset/" + userid;
		$.ajax({
			url : url,
			contentType : 'application/json',
			dataType : 'json',
			converters : {
				'json' : jQuery.parseJSON
			},
			success : function(data) {
				localdata = data;
				constructEmployeeSkillSetTable(localdata);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(textStatus + ':' + errorThrown);
			}
		});
	}

	function constructEmployeeSkillSetTable(data) {
		var el = document.getElementById("skill_set_table_id");
		var skillsetdata = data.skillset;
		var skillsetJson = $.parseJSON(skillsetdata);
		var skillsArr = [];
		var givenByArr = [];
		var ratingsArr = [];
		$.each(skillsetJson, function() {
			if (($.inArray(this['skillName'], skillsArr)) == -1)
				skillsArr.push(this['skillName']);
			ratingsArr.push(this['ratingId']);
		});

		$.each(skillsetJson, function() {
			if (($.inArray(this['givenBy'], givenByArr)) == -1)
				givenByArr.push(this['givenBy']);
		});
		row = document.createElement("TR");

		skillCell = document.createElement("TD");
		var skillTextNode = document.createTextNode("skills");
		skillCell.appendChild(skillTextNode);
		row.appendChild(skillCell);

		$.each(skillsArr, function(index, item) {
			skillCell = document.createElement("TD");
			var skillTextNode = document.createTextNode(skillsArr[index]);
			skillCell.appendChild(skillTextNode);
			row.appendChild(skillCell);
		});
		el.appendChild(row);

		var ratingCount = 0;
		$.each(givenByArr, function(index, item) {
			row1 = document.createElement("TR");
			skillCell = document.createElement("TD");
			var skillTextNode = document.createTextNode(givenByArr[index]);
			skillCell.appendChild(skillTextNode);
			row1.appendChild(skillCell);
			for ( var i = 0; i < skillsArr.length; i++) {
				skillCell = document.createElement("TD");
				var skillTextNode = document
						.createTextNode(ratingsArr[ratingCount]);
				skillCell.appendChild(skillTextNode);
				row1.appendChild(skillCell);
				ratingCount++;
			}
			el.appendChild(row1);
		});
	}

	function collectSkillData() {

	}

	function sendRatings() {
		var givenBy = getCookie("userid");
		var userid = "10000";
		var payload = new Object();
		payload.userId = userid;
		var skillSetArr = [];
		var skillNameArr = [];
		var ratingArr = [];

		var el = document.getElementById("rating_skill_table_id");
		for ( var i = 0, row; row = el.rows[i + 1]; i++) {
			var skill = row.cells[0];
			var rating = row.cells[1];
			skillNameArr.push(skill.textContent);
			ratingArr.push(rating.children[0].selectedIndex)
		}

		for ( var i = 0; i < skillNameArr.length; i++) {
			var skillRatingObj = new Object();
			skillRatingObj.skillId = 0;
			skillRatingObj.ratingId = ratingArr[i];
			skillRatingObj.skillName = skillNameArr[i];
			skillRatingObj.givenBy = givenBy;
			skillSetArr.push(skillRatingObj);
		}
		payload.skills = skillSetArr;
		var jsonString = JSON.stringify(payload);
		//alert(jsonString)
		var url = location.protocol + "//" + location.host
				+ "/ocms/store/employee/skills/";
		$.ajax({
			url : url,
			type : "POST",
			data : jsonString,
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
				alert(textStatus + ':' + errorThrown);
			}
		});
	}
	
	function sendPositionData(){
		var positionId = $('input[name=positionId]').val();
		var positionName = $('input[name=positionName]').val();
		var table=document.getElementById("create_position_skills_table_id");
		var skillNameArr = [];
		var ratingArr = [];
		var obj= new Object();
		obj.positionId = positionId;
		obj.positionName = positionName;
		obj.createdBy = getCookie("userid")
		obj.status = "OPEN";

		var el = document.getElementById("create_position_skills_table_id");
		for ( var i = 0, row; row = el.rows[i]; i++) {
			var skill = row.cells[0];
			var rating = row.cells[1];
			skillNameArr.push(skill.childNodes[1].value);
			ratingArr.push(rating.childNodes[1].value)
		}
		
		var skillSetArr = [];
		$.each(skillNameArr, function(index,item){
			var skillsetobj = new Object();
			skillsetobj.skillId=0;
			skillsetobj.skillName=skillNameArr[index];
			skillsetobj.ratingId=ratingArr[index];
			skillsetobj.givenBy="dummy";
			skillSetArr.push(skillsetobj);
		});
		obj.requiredSkillRatings=skillSetArr;
		var jsonString = JSON.stringify(obj);
		//alert(jsonString)
		var url = location.protocol + "//" + location.host
				+ "/ocms/manager/create/position";
		$.ajax({
			url : url,
			type : "POST",
			data : jsonString,
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

	<div id="create_position_id">
		<form name="position_form" action="/ocms/create/position/"
			method="POST">
			<div>
				<table width="40%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<table border="0" cellspacing="0" cellpadding="4" width="40%">
								<tr>
									<td colspan="2">Create Position
										<hr width="100%" size="1" noshade align="left">
									</td>
									<td></td>
								</tr>
								<tr>
									<td width="80">Position ID</td>
									<td valign="top" align="left"><p>
											<b>Position ID : </b><input type="text" name="positionId"
												value="" size="35" /></td>
								</tr>
								<tr>
									<td width="80">Position Name</td>
									<td valign="top" align="left"><p>
											<b>Position Name : </b><input type="text" name="positionName"
												value="" size="35" /></td>
								</tr>
								<tr>
									<td width="80">Add Necessary Skills</td>
									<td valign="top" align="left"><p>
											<b>Skill : </b><input type="button" name="skills" value="Add"
												id="add_skill_position_button_id" size="35"
												onclick="createSkillRatingRow()" />
										<table id="create_position_skills_table_id"></table></td>
								</tr>


								<td><input type="button" value="Submit" onclick="sendPositionData()" /></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>

	<div>
		Rate Team Members Skills<%
		EmployeeDao employeeDao = new EmployeeDaoImpl();
		List<Employee> team = employeeDao.getTeamMembers(managerId);
		Iterator<Employee> teamIterator = team.iterator();
	%>
		<select name="skillName" id="select_employee_for_rating_id"
			onchange="populateSkillTable()" style="width: 170px">
			<option value="" selected>Select</option>
			<%
				String selectedText = "";
				while (teamIterator.hasNext()) {
					Employee employee = teamIterator.next();
					String employeeName = employee.getEmployeeName();
					String employeeId = employee.getEmployeeId();
			%>
			<option <%=selectedText%> value="<%=employeeId%>"><%=employeeName%></option>
			<%
				}
			%>
		</select>

		<table id="rating_skill_table_id" border="0" cellspacing="0"
			cellpadding="4" width="40%">
			<tr>
				<td colspan="2">Skill Name
					<hr width="100%" size="1" noshade align="left">
				</td>
				<td colspan="2">Rating
					<hr width="100%" size="1" noshade align="left">
				</td>
			</tr>
		</table>
		<input type="button" value="Submit" onclick="sendRatings()" />

	</div>
	<div>
		View Team Members Skill Ratings <select name="skillName"
			onchange="populateCompleteSkillSet()"
			id="
			select_employee_for_view_rating_id" style="width: 170px">
			<option value="" selected>Select</option>
			<%
				Iterator<Employee> teamIterator1 = team.iterator();
				String selectedText1 = "";
				while (teamIterator1.hasNext()) {
					Employee employee = teamIterator1.next();
					String employeeName = employee.getEmployeeName();
					String employeeId = employee.getEmployeeId();
			%>
			<option <%=selectedText1%> value="<%=employeeId%>"><%=employeeName%></option>
			<%
				}
			%>
		</select>
		<table id="skill_set_table_id" border="0" cellspacing="0"
			cellpadding="4" width="40%">
		</table>
	</div>

</body>
</html>