<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="com.fasterxml.jackson.databind.node.ObjectNode"%>
<%@page import="system.common.Configurator"%>
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
<%
		UserBean userBean = (UserBean) session.getAttribute("userBean");
		String pass1 = null;
		String pass2 = null;
		String success = null;
		String failure = null;
		String test = null;
		int value = 0;
		if(userBean!=null){
			for(int i=0;i<b.menu.size();i++){
				ObjectNode obj = (ObjectNode)b.menu.get(i);
				if(obj.get("text").asText().equals("menu.System")){
					value = userBean.roleInt[i];
				}
			}
			if(value>0){
				pass1 = I18N.getString(userBean.language,"item.PWRule1");
				pass2 = I18N.getString(userBean.language,"item.PWRule2");
				success = I18N.getString(userBean.language,"Success");
				failure = I18N.getString(userBean.language,"Failure");
				test = I18N.getString(userBean.language,"Test");
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
		}else{
			response.sendRedirect("/login.jsp");
		}
	%>
<style type="text/css">
.ui-jqgrid-hdiv{
	display: none;
}
</style>
</head>

<body id="page-top">
	<script>
	var isLoadComplete = false;
	$(document).ready(function() {
		init();
		systemGrid('#jqGrid','../../testData','../../testData','Base',12,'cleanDB','id',4);
	});
	var mydata = [
		      		{id:28,Name:"Current Version",Value:"<%=Configurator.systemVersion+Configurator.serviceVersion%>"},
		      		{id:29,Name:"File",Value:"<form name=\"systemUpgradeForm\" id=\"systemUpgradeForm\" enctype=\"multipart/form-data\" method=\"post\" action=\"../../systemUpgradeAction.jsp\"><input id=\"upgradeFile\" name=\"upgradeFile\" type=\"file\"/></form>"},
		      		{id:30,Name:"",Value:"<input type=\"button\" name=\"apply\"	value=\"Apply\"	onclick=\"javascript:if(confirm('Upgrade File. Continue?')){document.systemUpgradeForm.submit();}\" />"}
		      		];
	
	function systemGrid(jqGridDiv,urlValue,cellurlValue,captionValue,btnIndex,btnfun,hidecol,selIndex){
		var NumOfRow = Math.floor(($(window).height() - 120) / 24);
		var grid = jQuery(jqGridDiv);
		$(jqGridDiv).jqGrid({
			data: mydata,
			datatype: "local",
			mtype : 'POST',
			colModel : [ {
				label : 'id',
				name : 'id',
				width : 1,
				key : true,
				edittype : 'text',
				editable : false,
				editrules : {
					required : true
				},
				editoptions: {size:10, maxlength: 15} 
			},{
				label : 'Name',
				name : 'Name',
				width : 100,
				edittype : 'text',
				editable : false,
				editrules : {
					required : true
				},
				editoptions: {size:10, maxlength: 15} 
			}, {
				label : 'Value',
				name : 'Value',
				width : 200,
				edittype : 'text',
				editrules : {
					required : true
				},
				editable : true

			}],
			loadonce : true,
			viewrecords : true,
			height : '100%',
			width : 60,
			top : 100,
			cellEdit: true,
			cellsubmit: "clientArray",
			rowNum : NumOfRow,
			cmTemplate: {sortable:false},
			loadonce: true,
            loadComplete: function(){
			        grid.jqGrid('setCell',28,'Value','','not-editable-cell');
			        grid.jqGrid('setCell',29,'Value','','not-editable-cell');
			        grid.jqGrid('setCell',30,'Value','','not-editable-cell');
				var arr = hidecol.split(',');
				for(var i=0;i<arr.length;i++){
					grid.hideCol(arr[i]);	
				}
				isLoadComplete = true;
			}
		}
		);
	}
	</script>
	<div id="navbardiv"></div>
	<div class="container-fluid" id="mainFrame" style="position: relative;">
		<div class="row" style="height: 90vh">
			<nav class="col-md-2 bg-light">
				<div id="tree" class="bg-light"></div>
			</nav>
			<div class="col-md-10">
				<div id="alarmdiv"></div>
				<div class="container-fluid">
					<table id="jqGrid"></table>
					<div id="jqGridPager"></div>
				</div>
			</div>
		</div>
	</div>
	<div id="dialog_div"></div>
</body>

</html>
