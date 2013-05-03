<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.cms.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<select name="skillName" id="skillNameID" onchange="" style="width: 170px">
	<option value="" selected>Select</option>
	<%
	List<String> allSkillNames = CommonUtil.getAllSkills();
		Iterator<String> allSkillNamesIterator = allSkillNames.iterator();
		String selectedText="";
		while (allSkillNamesIterator.hasNext()) {
			String skillName = allSkillNamesIterator.next();
	%>
	<option <%=selectedText%> value="<%=skillName%>"><%=skillName%></option>
	<%
		}
	%>
</select>