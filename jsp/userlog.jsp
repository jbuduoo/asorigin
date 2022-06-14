<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
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
		String time = null;
		String user = null;
		String ip = null;
		String item = null;
		String type = null;
		String result = null;
		String description = null;
		String language = null;
		String search = null;
		String all = null;
		String login = null;
		String logout = null;
		String export = null;
		int value = 0;
		if(userBean!=null){
			for(int i=0;i<b.menu.size();i++){
				ObjectNode obj = (ObjectNode)b.menu.get(i);
				if(obj.get("text").asText().equals("menu.System")){
					value = userBean.roleInt[i];
				}
			}
			if(value>0){
			time = I18N.getString(userBean.language,"item.Time");
			user = I18N.getString(userBean.language,"item.User");
			item = I18N.getString(userBean.language,"item.Item");
			ip = I18N.getString(userBean.language,"item.IP");
			result = I18N.getString(userBean.language,"item.Result");
			type = I18N.getString(userBean.language,"item.UpdateType");
			description = I18N.getString(userBean.language,"item.Description");
			search = I18N.getString(userBean.language,"item.Search");
			all = I18N.getString(userBean.language,"item.All");
			login = I18N.getString(userBean.language,"Login");
			logout = I18N.getString(userBean.language,"Logout");
			export = I18N.getString(userBean.language,"Export");
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
			}else{
				response.sendRedirect("/login.jsp");
			}
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
			systemGrid('#jqGrid','tableData.jsp?item=userlog&NumOfRow='+NumOfRow+'&from='+(date.getTime()-3600000)+'&to='+date.getTime()+'&value='+$('#filteritem').val()+'&user=','');
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
					label : '<%=time%>',
					name : 'time',
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=user%>',
					name : 'user',
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=ip%>',
					name : 'ip',
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=item%>',
					name : 'item',
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=type%>',
					name : 'type',
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=result%>',
					name : 'result',
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=description%>',
					name : 'description',
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
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
		
		function formatDate(dateObj)
		{
		    var curr_date = dateObj.getDate();
		    var curr_month = dateObj.getMonth();
		    curr_month = curr_month + 1;
		    var curr_year = dateObj.getFullYear();
		    var curr_min = dateObj.getMinutes();
		    var curr_hr= dateObj.getHours();
		    var curr_sc= dateObj.getSeconds();
		    if(curr_month.toString().length == 1)
		    curr_month = '0' + curr_month;      
		    if(curr_date.toString().length == 1)
		    curr_date = '0' + curr_date;
		    if(curr_hr.toString().length == 1)
		    curr_hr = '0' + curr_hr;
		    if(curr_min.toString().length == 1)
		    curr_min = '0' + curr_min;
		    if(curr_sc.toString().length == 1)
		    	curr_sc = '0' + curr_sc;
		    return curr_year+"-"+curr_month+"-"+curr_date+ " "+curr_hr+":"+curr_min;       
		}
		
		function logapply(){
			var from = new Date($("#fromtime").val());
			var to = new Date($("#totime").val());
			//alert($("#filteritem").val());
			$("#jqGrid").setGridParam({url:'tableData.jsp?item=userlog&from='+from.getTime()+'&to='+to.getTime()+'&NumOfRow='+NumOfRow+"&value="+$("#filteritem").val()+"&user="+$("#usertext").val(),page:1});
		    $("#jqGrid").trigger("reloadGrid");
		}
		
		function exportapply(){
			var from = new Date($("#fromtime").val());
			var to = new Date($("#totime").val());
		    $('#userlogexport').attr("href",'downloadData.jsp?item=userlog&from='+from.getTime()+'&to='+to.getTime()+'&value='+$("#filteritem").val()+'&user='+$("#usertext").val());
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
		<div>&nbsp;</div>
		
		
		<div style="margin-bottom: 10px">
	<div class="input-append date form_datetime" style="display:inline !important;">
    <input id="fromtime" class="ui-corner-all btn-sm" size="16" type="text" value="">
    <span class="add-on"><i class='fas fa-calendar'></i></span>
    </div>
    &nbsp;&nbsp;
    <div class="input-append date form_datetime" style="display:inline !important;">
    <input id="totime" class="ui-corner-all btn-sm" size="16" type="text" value="">
    <span class="add-on"><i class='fas fa-calendar'></i></span>
    </div>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <label style="font-weight:bold;"><%=item%>&nbsp;&nbsp;:&nbsp;&nbsp;</label>
    <select class="ui-corner-all btn-sm" id="filteritem">
      <%
      if (userBean != null) {
			StringBuilder sb = new StringBuilder();
			sb.append("<option value=''>");
			sb.append(all);
			sb.append("</option>");
			sb.append("<option value='Login'>");
			sb.append(login);
			sb.append("</option>");
			sb.append("<option value='Logout'>");
			sb.append(logout);
			sb.append("</option>");
			for (int i = 0; i < b.menu.size(); i++) {
				ObjectNode obj = (ObjectNode)b.menu.get(i);
				ArrayNode menu = (ArrayNode)obj.get("nodes");
				if(menu!=null){
					for (int j = 0; j < menu.size(); j ++) {
						ObjectNode node = (ObjectNode)menu.get(j);
						JsonNode json = node.get("text");
						if(json!=null){
							String text = json.asText();
							sb.append("<option value='");
							sb.append(text);
							sb.append("'>");
							sb.append(I18N.getString(userBean.language, text));
							sb.append("</option>");
						}
					}
				}else{
					JsonNode json = obj.get("text");
					if(json!=null){
						String text = json.asText();
						sb.append("<option value='");
						sb.append(text);
						sb.append("'>");
						sb.append(I18N.getString(userBean.language, text));
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
    <a href='' id='userlogexport' ><button id="exportbtn" type="button" class="btn btn-outline-secondary btn-sm" style="margin-bottom: 4px" onclick="exportapply();"><%=export %></button></a>
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
