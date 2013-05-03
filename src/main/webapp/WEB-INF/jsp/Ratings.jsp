<%@page import="java.util.Set"%>
<%@page import="com.cms.util.CommonUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.cms.models.Rating"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>

<%
    //String userId = request.getCookies()
    Set<Integer> allRatings = CommonUtil.getAllRatings();
    
    
    int selected = -1;
    if(request.getParameter("selected") != null && !request.getParameter("selected").equals("")){
        selected = Integer.parseInt(request.getParameter("selected"));    
    }
    
%>


<select name="ratingName" id="ratingName" onchange="" style="width:100px">
	<option value="" selected>Select</option>
	<%
	    Iterator<Integer> it2 = allRatings.iterator();
	    String selectedText1;
	    while (it2.hasNext()) {
	        int rat = it2.next();
	        if (rat == selected) {
	            selectedText1 = "selected";
	        } else {
	            selectedText1 = "";
	        }
	%>
	<option <%=selectedText1%> value="<%=rat%>"><%=rat%></option>
	<%
	    }
	%>
</select>