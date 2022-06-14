<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="system.db.LangSQL"%>
<%@page import="system.db.RoleSQL"%>
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
<script src="style/md5.js"></script>
<%
		UserBean userBean = (UserBean) session.getAttribute("userBean");
		String pw = null;
		String confirm = null;
		String lang = null;
		String email = null;
		String phone = null;
		String apply = null;
		String success = null;
		String failure = null;
		if(userBean!=null){
			pw = I18N.getString(userBean.language,"item.Password");
			confirm = I18N.getString(userBean.language,"item.Confirm");
			lang = I18N.getString(userBean.language,"item.Language");
			email = I18N.getString(userBean.language,"item.Email");
			phone = I18N.getString(userBean.language,"item.Phone");
			apply = I18N.getString(userBean.language,"Apply");
			success = I18N.getString(userBean.language,"Success");
			failure = I18N.getString(userBean.language,"Failure");
			if(userBean.lang.equals("cht")){
				out.println("<script src=\"style/jqGrid/js/i18n/grid.locale-tw.js\" type=\"text/javascript\"></script>");
			}else if(userBean.lang.equals("chs")){
				out.println("<script src=\"style/jqGrid/js/i18n/grid.locale-cn.js\" type=\"text/javascript\"></script>");
			}else{
				out.println("<script src=\"style/jqGrid/js/i18n/grid.locale-en.js\" type=\"text/javascript\"></script>");
			}
		}else{
			response.sendRedirect("/login.jsp");
		}
	%>
<style type="text/css">
.ui-jqgrid tr.ui-row-ltr td {
text-align: left;
}
.ui-state-highlight,
.ui-widget-content .ui-state-highlight,
.ui-widget-header .ui-state-highlight {
	background: none ;
}
input[type="text"]{
font-size: 14px !important;
}

.ui-widget-content {
padding-top:0px !important;
margin-top:0px !important;
	background: #fbfbf5;
}
</style>
</head>

<body id="page-top">
	<script>
	var lastid;
	var lastrow;
	var lastcell;
		$(document).ready(function() {
			init();
		});
		
		function ajaxError(jqXHR, textStatus, errorThrown){
			showmsg(jqXHR.status+" "+jqXHR.statusText);
		}
		    
		function ajaxComplete(XMLHttpRequest, textStatus) {
			ajaxSuccess(XMLHttpRequest.responseText);
	    }
		
		function ajaxSuccess(response){
			if(response!='Success'){
				showmsg('<%=failure%>');
				grid.trigger("reloadGrid");
			}else{
				showmsg('<%=success%>');
			}
		}
		
		function userapply() {
			var password = $("#password").val();
			var confirm = $("#confirm").val();
			var lang = $("#lang").val();
			var email = $("#email").val();
			var phone = $("#phone").val();
			if(password!=''){
				if(password==confirm){
					$.ajax({type:'post', url:'tableData.jsp?item=usersettings',data:{'oper':'edit','password':hex_md5(password),'lang':lang,'email':email,'phone':phone,'status':'ON'},error:ajaxError,complete :ajaxComplete});
				}else{
					showmsg($.jgrid.edit.msg.confirmmsg);
				}
			}else{
				showmsg('<%=pw%> '+$.jgrid.edit.msg.required);
			}
		}
		
	</script>
	<div id="navbardiv"></div>
	<div class="container-fluid" id="mainFrame" style="position: relative;">
		<div class="row" style="height: 90vh">
			<nav class="col-md-2 bg-light">
				<div id="tree" class="bg-light"></div>
			</nav>
			<div class="col-md-10">
				<div class="container-fluid">
			<div>&nbsp;</div>
		<table>
		<tr><td width='100px'><%=pw %> :</td><td><input class='ui-corner-all' type='password' id='password'></td></tr>
		<tr><td width='100px'><%=confirm %> :</td><td><input class='ui-corner-all' type='password' id='confirm'></td></tr>
		<tr><td width='100px'><%=lang %> :</td><td>
		<%
			if(userBean!=null){
				String language = Encode.forHtml(LangSQL.getLangName());
				if(!language.equals("")){
					String[] lang1 = language.split(";");
					StringBuilder sb = new StringBuilder("<select id='lang' class='ui-corner-all' style='font-size: 14px;'>");
					for(int i=0;i<lang1.length;i++){
						String[] lang2 = lang1[i].split(":");
						if(lang2.length==2){
							sb.append("<option value='");
							sb.append(lang2[0]);
							sb.append("'");
							if(userBean.lang.equals(lang2[0])){
								sb.append(" selected");
							}
							sb.append(">");
							sb.append(lang2[1]);
							sb.append("</option>");
						}
					}
					sb.append("</select>");
					out.print(sb.toString());
				}
			}
		%></td></tr>
		<tr><td width='100px'><%=email %> :</td><td><input class='ui-corner-all' type='text' id='email' size='24' value='<%=Encode.forHtml(userBean.email)%>'></td></tr>
		<tr><td width='100px'><%=phone %> :</td><td><input class='ui-corner-all' type='text' id='phone' size='24' value='<%=Encode.forHtml(userBean.phone)%>'></td></tr>
		<tr><td width='100px'></td><td><input class='ui-corner-all' style='font-size: 14px;' type='button' value='<%=apply%>' onclick='userapply();' /></td></tr>
		</table>
			
			
				</div>
			</div>
		</div>
	</div>
	<div id="dialog_div"></div>
</body>

</html>
