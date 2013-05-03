<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="com.cms.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<select name="ratingID" id="ratingID" onchange="" style="width: 170px">
	<option value="" selected>Select</option>
	<%
	Set<Integer> allRatingValues = CommonUtil.getAllRatings();
		Iterator<Integer> allRatingValuesIterator = allRatingValues.iterator();
		String selectedText="";
		while (allRatingValuesIterator.hasNext()) {
			int ratingId = allRatingValuesIterator.next();
	%>
	<option <%=selectedText%> value="<%=ratingId%>"><%=ratingId%></option>
	<%
		}
	%>
</select>