<%@page import="com.cms.models.Employee"%>
<%@page import="com.cms.models.Rating"%>
<%@page import="com.cms.models.Skill"%>
<%@page import="com.cms.models.SkillRating"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.cms.models.UserSkillSet"%>
<%@page import="com.cms.dao.impl.EmployeeDaoImpl"%>
<%@page import="com.cms.dao.EmployeeDao"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>
	<%
		String employeeName = null;
		String employeeId = null;

		Cookie[] cookies = request.getCookies();
		for (Cookie cookie : cookies) {

			if (cookie.getName().equals("user_name"))
				employeeName = cookie.getValue();
			if (cookie.getName().equals("userid"))
				employeeId = cookie.getValue();
		}
	%><%=employeeName%>'s Home Page
</title>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js">
	
</script>
<script type="text/javascript">
	var employeeData;
	var skillNameArr = [];
	var ratingIdArr = [];
	var allSkillsNameArr = [];
	var allRatingsArr = [];
	var newSkill;
	var newRating;

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

	function loadEmployeeData() {
		var userid = getCookie("userId");
		var url = location.protocol + "//" + location.host
				+ "/project/user/details/" + userid;
		$.ajax({
			url : url,
			contentType : 'application/json',
			dataType : 'json',
			converters : {
				'json' : jQuery.parseJSON
			},
			success : function(data) {
				employeeData = data;
				initialize();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(textStatus + ':' + errorThrown);
			}
		});
	}

	function initialize() {
		var allSkill = employeeData.details.available_skills;
		var allRatings = employeeData.details.available_ratings;
		var allRatingsJson = $.parseJSON(allRatings);
		var allSkillJson = $.parseJSON(allSkill);
		$.each(allSkillJson, function() {
			allSkillsNameArr.push(this['skillName']);
		});
		$.each(allRatingsJson, function() {
			allRatingsArr.push(this['ratingId']);
		});
	}

	function getSkillData() {
		var rawSkillData = employeeData.details.skill_set;
		var json = $.parseJSON(rawSkillData);
		var allSkill = employeeData.details.available_skills;
		var allSkillJson = $.parseJSON(allSkill);
		var skillsIdArr = [];

		$.each(json, function() {
			skillsIdArr.push(this['skillId']);
			ratingIdArr.push(this['ratingId']);
		});

		$.each(skillsIdArr, function(index, item) {
			var s = item;
			$.each(allSkillJson, function() {
				var s1 = this['skillId'];
				if (s == s1) {
					skillNameArr.push(this['skillName']);
				}
			});
		});

	}

	function createSkillDiv() {
		var skillEl = document.getElementById("dataContainer");
		var divTag = document.createElement("div");
		divTag.id = "skill_table_div_id";
		divTag.setAttribute("align", "center");
		divTag.style.margin = "0px auto";
		divTag.className = "dynamicDiv";
		skillEl.appendChild(divTag);
	}

	function createSkillTable() {
		getSkillData();
		createSkillDiv();
		var el = document.getElementById("skill_table_div_id");
		var tableEl = document.createElement("table");
		tableEl.id = "skill_table_id";
		tableEl.setAttribute("width", "400px");
		tableEl.setAttribute("border", "1");
		el.appendChild(tableEl);
		$.each(skillNameArr, function(index, item) {
			addRows(skillNameArr[index], ratingIdArr[index]);
		});

		var skillTableEl = document.getElementById("skill_table_id");

		var editSkillTableButton = document.createElement("input");
		editSkillTableButton.setAttribute("type", "button");
		editSkillTableButton.setAttribute("value", "Edit");
		editSkillTableButton.setAttribute("id", "edit_skill_table_id");
		skillTableEl.appendChild(editSkillTableButton);
		$("#edit_skill_table_id").click(function() {
			editSkillTable();
		});

		var addSkillButton = document.createElement("input");
		addSkillButton.setAttribute("type", "button");
		addSkillButton.setAttribute("value", "Add More Skill");
		addSkillButton.setAttribute("id", "add_skill_table_id");
		addSkillButton.disabled = true;
		skillTableEl.appendChild(addSkillButton);
		$("#add_skill_table_id").click(function() {
			addMoreSkill();
		});

		var saveSkillButton = document.createElement("input");
		saveSkillButton.setAttribute("type", "button");
		saveSkillButton.setAttribute("value", "Save Skill");
		saveSkillButton.setAttribute("id", "save_skill_table_id");
		saveSkillButton.disabled = true;
		skillTableEl.appendChild(saveSkillButton);
		$("#save_skill_table_id").click(function() {
			saveAddedSkill();
		});

		var cancelSkillTableChangesButton = document.createElement("input");
		cancelSkillTableChangesButton.setAttribute("type", "button");
		cancelSkillTableChangesButton.setAttribute("value", "Cancel");
		cancelSkillTableChangesButton.setAttribute("id",
				"cancel_skill_table_id");
		cancelSkillTableChangesButton.disabled = true;
		skillTableEl.appendChild(cancelSkillTableChangesButton);

		var closeSkillDivButton = document.createElement("input");
		closeSkillDivButton.setAttribute("type", "button");
		closeSkillDivButton.setAttribute("value", "Close");
		closeSkillDivButton.setAttribute("id", "close_skill_div_id");

		el.appendChild(closeSkillDivButton);

		document.getElementById("skill_button_id").disabled = "true";
		$("#close_skill_div_id").click(function() {
			closeSelfSkillDiv();
		});

	}

	function saveAddedSkill() {
		var check = $.inArray(newSkill, skillNameArr);
		if (check != -1) {
			alert("choose some other skill");
			return;
		}

		var userid = getCookie("userId");
		var url = location.protocol + "//" + location.host
				+ "/project/user/add/skill/" + userid + "/" + newSkill + "/"
				+ newRating + "/" + userid;
		$.ajax({
			url : url,
			contentType : 'application/json',
			dataType : 'json',
			converters : {
				'json' : jQuery.parseJSON
			},
			success : function(data) {
				var v = data.response;
				if (v == "SUCCESS") {
					var skillTableEl = $("#skill_table_id");
					var skills = skillTableEl.find("select");
					$.each(skills, function(index, item) {
						item.disabled = true;
					});
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(textStatus + ':' + errorThrown);
			}
		});
		newSkill = null;
		newRating = null;
	}

	function addMoreSkill() {
		addSingleRow();
	}

	function addSingleRow() {
		var el = $("#skill_table_id tr:last");
		var row = "<tr><td></td><td></td></tr>";
		el.after(row);
		var skills = $("#skill_table_id tr:last td:first");
		var ratings = $("#skill_table_id tr:last td:last");
		skills.load("Skills.jsp");
		ratings.load("Ratings.jsp");
	}

	function editSkillTable() {
		var skillTableEl = $("#skill_table_id");
		var skills = skillTableEl.find("select");
		$.each(skills, function(index, item) {
			item.disabled = false;
		});

		var addSkillButton = document.getElementById("add_skill_table_id");
		addSkillButton.disabled = false;
		var saveSkillButton = document.getElementById("save_skill_table_id");
		saveSkillButton.disabled = false;
	}

	function closeSelfSkillDiv() {

		var skillButton = document.getElementById("skill_button_id");
		skillButton.disabled = false;
		var el = document.getElementById("dataContainer");
		clearSkillTableContent();
		el.removeChild(document.getElementById("skill_table_div_id"));
	}

	function addRows(skillName, ratingId) {
		el = document.getElementById("skill_table_id");
		row = document.createElement("TR");

		skillCell = document.createElement("TD");
		//skillTextNode = document.createTextNode(skillName);
		var selectEl = document.createElement("select");
		selectEl.setAttribute("name", "Skills");
		selectEl.setAttribute("value", skillName);
		selectEl.setAttribute("style", "width: 170px");
		selectEl.setAttribute("disabled", "true");
		$.each(allSkillsNameArr, function(index, item) {
			var optionEl = document.createElement("option");
			optionEl.setAttribute("value", allSkillsNameArr[index]);
			if (skillName == allSkillsNameArr[index]) {
				optionEl.setAttribute("selected", "selected");
			}
			var skillTextNode = document
					.createTextNode(allSkillsNameArr[index]);
			optionEl.appendChild(skillTextNode);
			selectEl.appendChild(optionEl);
		});
		skillCell.appendChild(selectEl);

		row.appendChild(skillCell);

		ratingCell = document.createElement("TD");
		var selectEl1 = document.createElement("select");
		selectEl1.setAttribute("name", "Ratings");
		selectEl1.setAttribute("value", ratingId);
		selectEl1.setAttribute("style", "width: 170px");
		selectEl1.setAttribute("disabled", "true");
		$.each(allRatingsArr, function(index, item) {
			var optionEl = document.createElement("option");
			optionEl.setAttribute("value", allRatingsArr[index]);
			if (ratingId == allRatingsArr[index]) {
				optionEl.setAttribute("selected", "selected");
			}
			var ratingTextNode = document.createTextNode(allRatingsArr[index]);
			optionEl.appendChild(ratingTextNode);
			selectEl1.appendChild(optionEl);
		});
		ratingCell.appendChild(selectEl1);

		row.appendChild(ratingCell);
		el.appendChild(row);
	}

	function clearSkillTableContent() {
		skillNameArr.length = 0;
		ratingIdArr.length = 0;
	}

	function createPeerRatingSystem() {
		var peerData = employeeData.details;
	}

	function createPeersDiv() {
		var skillEl = document.getElementById("dataContainer");
		var divTag = document.createElement("div");
		divTag.id = "peers_div_id";
		divTag.setAttribute("align", "center");
		divTag.style.margin = "0px auto";
		divTag.className = "dynamicDiv";
		skillEl.appendChild(divTag);
	}

	submitForm = function() {
		//form.target = '';
		form.action = 'index.jsp';
		form.method = 'POST';
		form.submit();
	}

	CancelIt = function() {
		form.reset();
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
		var table = $("#peer_skill_table_id");
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

	var originalSkillNameArr = [];
	var originalRatingArr = [];

	function storeOriginalSkillRatings() {

		var el = document.getElementById("skill_table_id");
		for ( var i = 0, row; row = el.rows[i + 1]; i++) {
			var skill = row.cells[0];
			var rating = row.cells[1];
			originalSkillNameArr.push(skill.childNodes[0].nextSibling.value);
			originalRatingArr.push(rating.children[0].selectedIndex)
		}
	}

	function updateMyRatings() {
		var givenBy = getCookie("userid");
		var userid = givenBy;
		var payload = new Object();
		payload.userId = userid;
		var skillSetArr = [];
		var skillNameArr = [];
		var ratingArr = [];
		var updatedData = [];
		var el = document.getElementById("skill_table_id");
		for ( var i = 0, row; row = el.rows[i + 1]; i++) {
			var skill = row.cells[0];
			var rating = row.cells[1];
			skillNameArr.push(skill.childNodes[0].nextSibling.value);
			ratingArr.push(rating.children[0].selectedIndex)
		}

		$.each(skillNameArr, function(index, item) {
			if (ratingArr[index] != originalRatingArr[index]) {
				var obj = new Object();
				obj.skillName = skillNameArr[index];
				obj.ratingId = ratingArr[index];
				obj.skillId = 0;
				obj.givenBy = givenBy;
				updatedData.push(obj);
			}
		});
		payload.skills = updatedData;
		var jsonString = JSON.stringify(payload);
		var url = location.protocol + "//" + location.host
				+ "/ocms/edit/employee/skills/";
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
				alert(success);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(textStatus + ':' + errorThrown);
			}
		});
	}

	function sendMyRatings() {
		var givenBy = getCookie("userid");
		var userid = givenBy;
		var payload = new Object();
		payload.userId = userid;
		var skillSetArr = [];
		var skillNameArr = [];
		var ratingArr = [];
		var el = document.getElementById("skill_table_id");
		userid = givenBy;

		for ( var i = 0, row; row = el.rows[i + 1]; i++) {
			var skill = row.cells[0];
			var rating = row.cells[1];
			if ($.inArray(skill.childNodes[0].nextSibling.value,
					originalSkillNameArr) == -1) {
				skillNameArr.push(skill.childNodes[0].nextSibling.value);
				originalSkillNameArr
						.push(skill.childNodes[0].nextSibling.value);
				originalRatingArr.push(rating.children[0].selectedIndex)
				ratingArr.push(rating.children[0].selectedIndex)
			}
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
				alert(success);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(textStatus + ':' + errorThrown);
			}
		});
	}

	function sendPeerRatings() {
		var givenBy = getCookie("userid");
		var userid;
		var payload = new Object();
		payload.userId = userid;
		var skillSetArr = [];
		var skillNameArr = [];
		var ratingArr = [];
		var el = document.getElementById("peer_skill_table_id");
		userid = $("#peerNameID").val();

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
				alert(success);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				//alert(textStatus + ':' + errorThrown);
			}
		});
	}
</script>

</head>
<body onload="storeOriginalSkillRatings()">

	<%
		//String userId = request.getCookies()
		EmployeeDao dao = new EmployeeDaoImpl();
		List<SkillRating> skills = dao.employeeSkills(employeeId);
	%>

	<p align="center">
	<div id="skill_table_div_id" class="dynamicDiv" align="center"
		style="margin: 0px auto;">
		<table id="skill_table_id">

			<tr>
				<b><td>SKILL NAME</td>
					<td>RATING</td></b>
			</tr>
			<%
				Iterator<SkillRating> it = skills.iterator();
				while (it.hasNext()) {
					SkillRating skill = it.next();
			%>
			<tr>
				<td><jsp:include page="Skills.jsp">
						<jsp:param name="selected" value="<%=skill.getSkillId()%>" />
					</jsp:include></td>
				<td><jsp:include page="Ratings.jsp">
						<jsp:param name="selected" value="<%=skill.getRatingId()%>" />
					</jsp:include></td>
			</tr>

			<%
				}
			%>
		</table>
		<input type="button" value="Add Skill" onclick="addSingleRow()">
		<input type="button" value="Submit" onclick="sendMyRatings()">
		<input type="button" value="Edit" onclick="updateMyRatings()">
		<input type="button" value="Cancel" onclick="cancelIt();">
	</div>


	<div id="peer_skill_table_div_id" class="dynamicDiv" align="center"
		style="margin: 0px auto;">

		<jsp:include page="peers.jsp">
			<jsp:param name="selected" value="-1" />
		</jsp:include>
		<br> <br>Skill Table For

		<table id="peer_skill_table_id" border="0" cellspacing="0"
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
		<input type="button" value="Submit" onclick="sendPeerRatings()" />

	</div>
	<b>My Skills</b>
	<input id="skill_button_id" type="button" value="My Skills" onclick="" />
	<br>
	<br>
	<b>Rate My Peers</b>
	<input id="rate_peer_button_id" type="button" value="Rate My Peers"
		onclick="createPeerRatingSystem();" />
	<br>
	<br>
	</p>
	<div id="dataContainer"></div>
</body>
</html>