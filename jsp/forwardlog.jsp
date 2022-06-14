<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="asorigin.db.bean.AlarmThreshold"%>
<%@page import="com.fasterxml.jackson.databind.node.ObjectNode"%>
<%@page import="com.fasterxml.jackson.databind.node.ArrayNode"%>
<%@page import="com.fasterxml.jackson.databind.JsonNode"%>
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
		
		String alarmDevice=null;
		String alarmType=null;
		String alarmCategory=null;
		String alarmLevel=null;
		
		String language = null;
		String search = null;
		String all = null;
		
		String method = null;
		String user = null;
		String logTime = null;
		String forwardDetail=null;
		
		if(userBean!=null){
			
			alarmDevice = I18N.getString(userBean.language,"alarm.Source");
			alarmType = I18N.getString(userBean.language,"alarm.Type");
			alarmCategory = I18N.getString(userBean.language,"alarm.Category");
			alarmLevel = I18N.getString(userBean.language,"alarm.Level");
			
			search = I18N.getString(userBean.language,"item.Search");
			all = I18N.getString(userBean.language,"item.All");
			if(userBean.lang.equals("cht")){
				out.println("<script src=\"style/jqGrid/js/i18n/grid.locale-tw.js\" type=\"text/javascript\"></script>");
				out.println("<script type=\"text/javascript\" src=\"style/bootstrap/datetimepicker/locales/bootstrap-datetimepicker.zh-TW.js\" charset=\"UTF-8\"></script>");
				language = "zh-TW";
			}else if(userBean.lang.equals("chs")){
				out.println("<script src=\"style/jqGrid/js/i18n/grid.locale-cn.js\" type=\"text/javascript\"></script>");
				out.println("<script type=\"text/javascript\" src=\"style/bootstrap/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js\" charset=\"UTF-8\"></script>");
				language = "zh-CN";
			}else{
				out.println("<script src=\"style/jqGrid/js/i18n/grid.locale-en.js\" type=\"text/javascript\"></script>");
				language = "en";
			}
			
			method = I18N.getString(userBean.language,"item.ForwardMethod");
			user = I18N.getString(userBean.language,"item.User");
			logTime = I18N.getString(userBean.language,"item.ForwardTime");
			forwardDetail = I18N.getString(userBean.language,"item.ForwardDetail");
			
		}else{
			response.sendRedirect("/login.jsp");
		}
	%>
<style type="text/css">
select:focus,
input:focus { 
    outline: none !important;
}
</style>
</head>

<body id="page-top">
	<script>
		$(document).ready(function() {
			init();
			$('.form_datetime').datetimepicker({
				format: 'yyyy-mm-dd hh:ii',
		        autoclose: true,
		        todayBtn: true,
		        language: '<%=language%>',
		        pickerPosition: "bottom-left"
		      })
			
			var date = new Date();
			$("#fromtime").val(formatDate(new Date(date.getTime()-3600000)));
			$("#totime").val(formatDate(date));
			systemGrid('#jqGrid','tableData2.jsp?item=forwardlog&NumOfRow='+NumOfRow+'&from='+(date.getTime()-3600000)+'&to='+date.getTime()+'&alarmLevel=&alarmType=&alarmCategory=','');
			$("#jqGrid").closest(".ui-jqgrid-bdiv").css({ "overflow-x" : "hidden","overflow-y" : "hidden" }); 
		});
		var lastSelection;
		var grid;
		var NumOfRow = Math.floor(($(window).height()-220)/24);
		function systemGrid(jqGridDiv,urlValue,hidecol){
			grid = jQuery(jqGridDiv);
			//alert(1);
			$(jqGridDiv).jqGrid({
				url : urlValue,
				// we set the changes to be made at client side using predefined word clientArray
				editurl : urlValue,
				datatype : "json",
				mtype : 'POST',
				colModel : [ {
					label : '<%=alarmDevice%>',
					name : 'alarmDevice',
					edittype : 'text'
				},{
					label : '<%=alarmLevel%>',
					name : 'alarmLevel',
					edittype : 'text'
				},{
					label : '<%=alarmType%>',
					name : 'alarmType',
					edittype : 'text'
				},{
					label : '<%=alarmCategory%>',
					name : 'alarmCategory',
					edittype : 'text'
				},{
					label : '<%=method%>',
					name : 'method',
					edittype : 'text'
				},{
					label : '<%=user%>',
					name : 'user',
					edittype : 'text'
				},{
					label : '<%=forwardDetail%>',
					name : 'forwardDetail',
					edittype : 'text'
				},{
					label : '<%=logTime%>',
					name : 'logTime',
					edittype : 'text'
				}],
				viewrecords : true,
				height : '100%',
				width : $("#alarmdiv").width()-20,
				top : 100,
				rowNum : NumOfRow,
				cmTemplate: {sortable:false},
				pager : "#jqGridPager",
				loadComplete: function(){
				}
			});
			
			$('#jqGrid').navGrid('#jqGridPager',
					// the buttons to appear on the toolbar of the grid
					{
						add:false,
						edit:false,
						del:false,
						search : false,
						refresh : false,
						view : false,
						position : "left",
						cloneToTop : false
						
					});
			var arr = hidecol.split(',');
			for(var i=0;i<arr.length;i++){
				grid.hideCol(arr[i]);	
			}

		}
		
		function ajaxSuccess(response){
			if(response!='Success'){
				alert(response);
				grid.trigger("reloadGrid");
			}
		}
		
		function logapply(){
			var from = new Date($("#fromtime").val());
			var to = new Date($("#totime").val());
			$("#jqGrid").setGridParam({url:'tableData2.jsp?item=forwardlog&from='+from.getTime()+'&to='+to.getTime()+'&NumOfRow='+NumOfRow+"&alarmLevel="+$("#alarmLevel").val()+"&alarmType="+$("#alarmType").val()+"&alarmCategory="+$("#alarmCategory").val()+"&user="+$("#usertext").val(),page:1});
		    $("#jqGrid").trigger("reloadGrid");
		}

	</script>
	<div id="navbardiv"></div>
	<div class="container-fluid" id="mainFrame" style="position: relative;">
		<div class="row"  style="height: 90vh">
			<nav class="col-md-2 bg-light">
				<div id="tree" class="bg-light"></div>
			</nav>
			<div class="col-md-10">
				<div id="alarmdiv"></div>
				<div class="container-fluid">
		<div>&nbsp;</div>
		
		
		<div style="margin-bottom: 10px">
	<div class="input-append date form_datetime" style="display:inline !important;">
    <input id="fromtime" class="ui-corner-all btn-sm" size="16" type="text" value="">
    <span class="add-on"><i class='fas fa-calendar'></i></span>
    </div>
    &nbsp;~&nbsp;
    <div class="input-append date form_datetime" style="display:inline !important;">
    <input id="totime" class="ui-corner-all btn-sm" size="16" type="text" value="">
    <span class="add-on"><i class='fas fa-calendar'></i></span>
    </div>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <label style="font-weight:bold;"><%=alarmLevel%>&nbsp;&nbsp;:&nbsp;&nbsp;</label>
    <select class="ui-corner-all btn-sm" id="alarmLevel">
    <%
      if (userBean != null) {
			StringBuilder sb = new StringBuilder();
			sb.append("<option value=''>");
			sb.append(all);
			sb.append("</option>");
			for (int i = 0; i < AlarmThreshold.alarmLevel.length; i++) {
				sb.append("<option value='");
				sb.append(AlarmThreshold.alarmLevel[i]);
				sb.append("'>");
				sb.append(I18N.getString(userBean.language, AlarmThreshold.alarmLevel[i]));
				sb.append("</option>");
			}
			out.print(sb.toString());
		}
      %>
    </select>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <label style="font-weight:bold;"><%=alarmType%>&nbsp;&nbsp;:&nbsp;&nbsp;</label>
    <select class="ui-corner-all btn-sm" id="alarmType">
      <%
      if (userBean != null) {
			StringBuilder sb = new StringBuilder();
			sb.append("<option value=''>");
			sb.append(all);
			sb.append("</option>");
			for (int i = 0; i < AlarmThreshold.alarmType.size(); i++) {
				ObjectNode obj = (ObjectNode) AlarmThreshold.alarmType.get(i);
				JsonNode tmp = obj.get("type");
				if (tmp != null) {
					String type = tmp.asText();
					sb.append("<option value='");
					sb.append(type);
					sb.append("'>");
					sb.append(I18N.getString(userBean.language, type));
					sb.append("</option>");
				}
			}
			out.print(sb.toString());
		}
      %>
    </select>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <label style="font-weight:bold;"><%=alarmCategory%>&nbsp;&nbsp;:&nbsp;&nbsp;</label>
    <select class="ui-corner-all btn-sm" id="alarmCategory">
      <%
      if (userBean != null) {
			StringBuilder sb = new StringBuilder();
			sb.append("<option value=''>");
			sb.append(all);
			sb.append("</option>");
			for (int i = 0; i < AlarmThreshold.alarmType.size(); i++) {
				ObjectNode obj = (ObjectNode) AlarmThreshold.alarmType.get(i);
				ArrayNode category_array = (ArrayNode) obj.get("category_array");
				for (int j = 0; j < category_array.size(); j++) {
					ObjectNode obj2 = (ObjectNode) category_array.get(j);
					JsonNode tmp2 = obj2.get("category");
					if (tmp2 != null) {
						String str = tmp2.asText();
						sb.append("<option value='");
						sb.append(str);
						sb.append("'>");
						sb.append(I18N.getString(userBean.language, str));
						sb.append("</option>");
					}
				}
			}
			out.print(sb.toString());
		}
      %>
    </select>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <label style="font-weight:bold;"><%=user%>&nbsp;&nbsp;:&nbsp;&nbsp;</label>
    <input id="usertext" type="text" class="ui-corner-all btn-sm" style="margin-bottom: 4px">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <button id="searchbtn" type="button" class="btn btn-outline-secondary btn-sm" style="margin-bottom: 4px" onclick="logapply();"><%=search %></button>
    &nbsp;&nbsp;&nbsp;&nbsp;
    </div>
		<table id="jqGrid"></table>
		<div id="jqGridPager"></div>
			
				</div>
			</div>
		</div>
	</div>
	<div id="dialog_div"></div>
</body>

</html>
