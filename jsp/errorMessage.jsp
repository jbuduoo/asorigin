<%@page import="org.owasp.encoder.Encode"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Error</title>
</head>
<body>
	<%
		String errorCode = (request.getAttribute("errorCode") == null) ? ""
				: request.getAttribute("errorCode").toString();
	if (errorCode.length() > 0) {
		StringBuilder sb = new StringBuilder();
		sb.append("<script type=\"text/javascript\">alert('");
		sb.append(Encode.forHtml(errorCode));
		sb.append("');window.location = '");
		sb.append(Encode.forHtml(request.getParameter("forwardPage")));
		sb.append("';</script>");
		out.println(sb.toString());
	}
	%>
</body>
</html>
