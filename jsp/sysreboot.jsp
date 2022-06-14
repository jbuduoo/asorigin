<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Upgrade</title>
<script language="javascript">
	window.onload = function (){
		var count = <%=request.getParameter("count")%>;
		var text = weltext.innerText;
		var redirectURL = function(){
			if( count > 1){
				weltext.innerText = text + count--;
			}else{
				parent.location.href = '<%=request.getParameter("forwardPage")%>';
				 window.clearInterval(intervalID); 
			}
		}
		if(count!=0)
			intervalID=window.setInterval( redirectURL,1000); 
		else
			redirectURL();
	};

</script>
<style type="text/css">
.style {
	color: #008800;
	font-size: 20pt;
	line-height: 22pt;
	letter-spacing: 2pt;
	position: absolute;
	text-align: center;
	top: 50%;
	left: 50%;
	width: 550px;
	height: 300px;
	margin-top: -150px;
	margin-left: -275px;
}
</style>
</head>
<body>
<div id="weltext" class="style">System Reboot<br>
Please wait...</div>
</body>
</html>