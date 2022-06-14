<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="com.fasterxml.jackson.databind.node.ObjectNode"%>
<%@page import="com.fasterxml.jackson.databind.node.ArrayNode"%>
<%@page import="com.fasterxml.jackson.databind.JsonNode"%>
<%@page import="system.common.Configurator"%>
<%@page import="org.owasp.encoder.Encode"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title><%=b.systemName %></title>
<script src="style/jquery/jquery.min.js"></script>

<link href="style/fontawesome-free/css/all.min.css" rel="stylesheet"
	type="text/css">
	
<script src="style/bootstrap/js/bootstrap.bundle.min.js"></script>
<link href="style/bootstrap/css/bootstrap.min.css" rel="stylesheet"	type="text/css">

<link href="style/bootstrap/datetimepicker/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
<script type="text/javascript" src="style/bootstrap/datetimepicker/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>

<link href="style/bootstrap/treeview/bootstrap-treeview.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="style/bootstrap/treeview/bootstrap-treeview.min.js" charset="UTF-8"></script>

<link rel="stylesheet" type="text/css" media="screen"
	href="style/jquery/ui/jquery-ui.css" />
<script src="style/jquery/ui/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" media="screen"
	href="style/jqGrid/css/ui.jqgrid.css" />
<script src="style/jqGrid/js/minified/jquery.jqGrid.min.js"
	type="text/javascript"></script>
	
<script src="style/my.js" type="text/javascript"></script>
<link href="style/my.css" rel="stylesheet">
</head>

<body id="page-top">
<nav id="navbar" class="navbar navbar-expand-xs navbar-light bg-light">
  <a class="navbar-brand col-md-2 h1" href="index.jsp"><%=b.systemName %></a>
  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
    <%
		UserBean userBean = (UserBean) session.getAttribute("userBean");
		String logout = null;
		String logout1 = null;
		String cancel = null;
		String settings = null;
		String userName = "";
		String lang = null;
		String role = null;
		if (userBean != null) {
			userName = Encode.forHtml(userBean.userName);
			logout = Encode.forHtml(I18N.getString(userBean.language, "Logout"));
			logout1 = Encode.forHtml(I18N.getString(userBean.language, "Logout1"));
			cancel = Encode.forHtml(I18N.getString(userBean.language, "Cancel"));
			settings = Encode.forHtml(I18N.getString(userBean.language, "item.UserSettings"));
			lang = Encode.forHtml(userBean.lang);
			role = Encode.forHtml(userBean.role);
		}else{
			response.sendRedirect("/login.jsp");
		}
	%>
    </ul>
    <ul class="navbar-nav ml-auto ml-md-0">
    <li class="nav-item dropdown">
                <a class="nav-link nav-link-icon" href="#" id="navbar_1_dropdown_2" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fas fa-bell"></i><span id="alarmCount" class="badge badge-danger badge-counter"></span></a>
                <div class="dropdown-menu dropdown-menu-right p-0" style="width: 300px;border:0;">
                    <div id="alarmList" class="list-group m-0 p-0">
                    </div>
                </div>
            </li>
      </ul>
    
			<nav class="navbar navbar-light bg-light">
				<span class="navbar-text"> <%=Configurator.systemVersion+Configurator.serviceVersion%>
				</span>
			</nav>
			<ul class="navbar-nav ml-auto ml-md-0">
			<li class="nav-item dropdown no-arrow"><a
				class="nav-link dropdown-toggle" href="#" id="userDropdown"
				role="button" data-toggle="dropdown" aria-haspopup="true"
				aria-expanded="false"> <i class="fas fa-user-circle fa-fw"></i>
			</a>
				<div class="dropdown-menu dropdown-menu-right"
					aria-labelledby="userDropdown">
					<h1 class="dropdown-header"><%=userName%></h1>
					<h1 id="user_role" class="dropdown-header d-none"><%=role%></h1>
					<h1 id="user_lang" class="dropdown-header d-none"><%=lang%></h1>
					<a class="dropdown-item" href="usersettings.jsp"><%=settings%></a>
					<a class="dropdown-item" href="#" data-toggle="modal"
						data-target="#logoutModal"><%=logout%></a>
				</div></li>
		</ul>
		
		<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog"
			aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel"><%=logout1%></h5>
						<button class="close" type="button" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">x</span>
						</button>
					</div>
					<div class="modal-footer">
						<button class="btn btn-secondary" type="button"
							data-dismiss="modal"><%=cancel%></button>
						<a class="btn btn-primary" href="logout.jsp?redirect=login.jsp"><%=logout%></a>
					</div>
				</div>
			</div>
		</div>
  </div>
</nav>
</body>

</html>
