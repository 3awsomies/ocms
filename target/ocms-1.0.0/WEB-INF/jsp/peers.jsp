<%@page import="com.cms.models.Employee"%>
<%@page import="com.cms.dao.impl.EmployeeDaoImpl"%>
<%@page import="com.cms.dao.EmployeeDao"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.cms.models.Skill"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%
/* String managerId = null;
String userId = null;
Cookie[] cookies = request.getCookies();
for (Cookie cookie : cookies) {
	if (cookie.getName().equals("manager_id"))
		managerId = cookie.getValue();
	if (cookie.getName().equals("userid"))
		userId = cookie.getValue();
} */Employee employee = (Employee)request.getAttribute("employee_details");
	//String userId = request.getCookies();
	
	EmployeeDao dao = new EmployeeDaoImpl();
	List<Employee> peers = dao.getTeamMembers(employee.getManagerId());;
	int selected = -1;
%>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js">
</script>
<script type="text/javascript">

var employeePeersSkillData;

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

function getPeersSkillData(){
	var userid = $("#peerNameID").val();
	var url = location.protocol + "//" + location.host
			+ "/ocms/employee/skills/" + "10000";
	$.ajax({
		url : url,
		contentType : 'application/json',
		dataType : 'json',
		converters : {
			'json' : jQuery.parseJSON
		},
		success : function(data) {
			employeePeersSkillData = data;
			populatePeerSkillTableDiv();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert(textStatus + ':' + errorThrown);
		}
	});
}

function populatePeerSkillTableDiv(){
	
	var skills = $.parseJSON(employeePeersSkillData);
	$.each(skills, function(index, item){
		addRows(item);
	});
	
}

function addSkillRow(skill){
	var el = $("#peer_skill_table_id");
	row = document.createElement("TR");
	skillCell = document.createElement("TD");
	skillCell.innerHTML=skill.skill_Name;
	row.appendChild(skillCell);
	
	ratingCell = document.createElement("TD");
	var selectEl1 = document.createElement("select");
	selectEl1.setAttribute("name", "Ratings");
	selectEl1.setAttribute("value", ratingId);
	selectEl1.setAttribute("style", "width: 170px");
	$.each(allRatingsArr, function(index, item) {
		var optionEl = document.createElement("option");
		optionEl.setAttribute("value", allRatingsArr[index]);
		var ratingTextNode = document.createTextNode(allRatingsArr[index]);
		optionEl.appendChild(ratingTextNode);
		selectEl1.appendChild(optionEl);
	});
	ratingCell.appendChild(selectEl1);

	row.appendChild(ratingCell);
	el.appendChild(row);
}
function populateSkillTable() {

	//var userid = getCookie("userid");
	var userid = $("#peerNameID").val();
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

function sendRatings() {
	var givenBy = getCookie("userid");
	//var userid = $("#peerNameID").val();
	var payload = new Object();
	payload.userId = $("#peerNameID").val();
	var skillSetArr = [];
	var skillNameArr = [];
	var ratingArr = [];

	var el = document.getElementById("peer_skill_table_id");
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


<select name="peerName" id="peerNameID" onchange="populateSkillTable()" style="width: 170px">
	<option value="" selected>Select</option>
	<%
		Iterator<Employee> it1 = peers.iterator();
		String selectedText="";
		while (it1.hasNext()) {
			Employee ski = it1.next();
	%>
	<option <%=selectedText%> value="<%=ski.getEmployeeId()%>"><%=ski.getEmployeeName()%></option>
	<%
		}
	%>
</select>