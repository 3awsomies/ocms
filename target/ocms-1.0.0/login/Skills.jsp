<%@page import="com.cms.util.CommonUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.cms.models.Skill"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>

<%
    //String userId = request.getCookies()
    List<String> allSkills = CommonUtil.getAllSkills();
    
    int selected = -1;
    if(request.getParameter("selected") != null && !request.getParameter("selected").equals("")){
        selected = Integer.parseInt(request.getParameter("selected"));    
    }
%>


<select name="skillName" id="skillName" onchange="" style="width: 170px">
	<option value="" selected>Select</option>
	<%
	    Iterator<String> it1 = allSkills.iterator();
	    String selectedText;
	    while (it1.hasNext()) {
	    	String ski = it1.next();
	        if (ski.equals(selected)) {
	            selectedText = "selected";
	        } else {
	            selectedText = "";
	        }
	%>
	<option <%=selectedText%> value="<%=ski%>"><%=ski%></option>
	<%
	    }
	%>
</select>