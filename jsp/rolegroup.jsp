<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="com.fasterxml.jackson.databind.node.ObjectNode"%>
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
		String roleName = null;
		String roleRule = null;
		String delete = null;
		int value = 0;
		if(userBean!=null){
			for(int i=0;i<b.menu.size();i++){
				ObjectNode obj = (ObjectNode)b.menu.get(i);
				if(obj.get("text").asText().equals("menu.System")){
					value = userBean.roleInt[i];
				}
			}
			if(value>0){
			roleName = I18N.getString(userBean.language,"item.RoleName");
			roleRule = I18N.getString(userBean.language,"item.RoleRule");
			delete = I18N.getString(userBean.language,"del");
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
</style>
</head>

<body id="page-top">
	<script>
		$(document).ready(function() {
			init();
			systemGrid('#jqGrid','tableData.jsp?item=role&NumOfRow='+NumOfRow,'');
			$("#jqGrid").closest(".ui-jqgrid-bdiv").css({ "overflow-x" : "hidden","overflow-y" : "hidden" }); 
		});
		var lastSelection;
		var grid;
		var NumOfRow = Math.floor(($(window).height()-220)/24);
		var del_options = {
				beforeShowForm : function (formid)
				{
				},
				onclickSubmit: function(params,rolename){
	                  return {rolename:rolename};},errorTextFormat : function(data) {
					return 'Error: ' + data.responseText
				},afterComplete: function (response, postdata, formid) {ajaxSuccess(response.responseText);}
			};
			var edit_options = {
					recreateForm : true,
					checkOnUpdate : true,
					checkOnSubmit : true,
					closeAfterEdit : true,
					viewPagerButtons : false,
					errorTextFormat : function(data) {
						return 'Error: ' + data.responseText
					},
					beforeShowForm : function (formid)
					{
						$('#rolename').attr("readonly","readonly");
					}
				};
			
			function deleteRow(cellValue, options, rowObject) {
		    	return "<input style='width:72px;font-size:14px' type='button' value='<%=delete%>' onclick='grid.jqGrid(\"delGridRow\",\""+rowObject.rolename+"\",del_options)' />";	
		    }
			
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
					label : '<%=roleName%>',
					name : 'rolename',
					key : true,
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=roleRule%>',
					name : 'rolerule',
					edittype : 'custom',
					editable : true,
					editoptions: {
						custom_value: getFreightElementValue,
	                    custom_element: createFreightEditElement
	                }
				<%
				if((value&4)>0){
					out.println("},{label : '"+delete+"',name : 'delete',edittype : 'text',formatter :deleteRow");
				}
				%>
				}],
				viewrecords : true,
				height : '100%',
				width : $("#alarmdiv").width()-20,
				top : 100,
				rowNum : NumOfRow,
				cmTemplate: {sortable:false},
				pager : "#jqGridPager",
				onSelectRow: function(id){
					<%
					if((value&2)>0){
					out.println("grid.editGridRow( id, edit_options );");
					}
					%>
				},
				loadComplete: function(){
				}
			});
			
			$('#jqGrid').navGrid('#jqGridPager',
					// the buttons to appear on the toolbar of the grid
					{
				<%
				if(userBean!=null){
					StringBuilder sb = new StringBuilder();
					if((value&1)>0){
						sb.append("add:true,");
					}else{
						sb.append("add:false,");
					}
					out.println(sb.toString());
				}
			%>
						edit:false,
						del:false,
						search : false,
						refresh : false,
						view : false,
						position : "left",
						cloneToTop : false
						
					},
					// options for the Edit Dialog
					{
					},
					// options for the Add Dialog
					{
						closeAfterAdd : true,
						recreateForm : true,
						beforeShowForm : function (formid)
						{
						},
						errorTextFormat : function(data) {
							return 'Error: ' + data.responseText
						},
						afterComplete: function (response, postdata, formid) {
							ajaxSuccess(response.responseText);
						},
						reloadAfterSubmit: true
					},
					// options for the Delete Dailog
					{
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

		
		function createFreightEditElement(value, editOptions) {
			if(value==''){
			<%
				StringBuilder sb2 = new StringBuilder();
				for(int i=0;i<b.menu.size();i++){
					sb2.append("0,");
				}
				if (sb2.length() > 0) {
					sb2.deleteCharAt(sb2.length() - 1);
				}
				out.println("value=\""+sb2.toString()+"\"");
				%>
			}
			var arr = value.split(',');
			var enable = new Array(arr.length);
			for(i=0;i<enable.length;i++){
				enable[i] = new Array(4);
				enable[i][0] = "";
				enable[i][1] = "";
				enable[i][2] = "";
				enable[i][3] = "";
			}
				for(i=0;i<arr.length;i++){
					if(arr[i]&1){
						enable[i][0] = "checked";
					}else{
						enable[i][0] = "";
					}
					if(arr[i]&2){
						enable[i][1] = "checked";
					}else{
						enable[i][1] = "";
					}
					if(arr[i]&4){
						enable[i][2] = "checked";
					}else{
						enable[i][2] = "";
					}
					if(arr[i]&8){
						enable[i][3] = "checked";
					}else{
						enable[i][3] = "";
					}
				}
			//var div = "<input type='checkbox'>?Šè­¦ç®¡ç?<input type='checkbox'>?°å?<br><input type='checkbox'>?Šè­¦ç®¡ç?<input type='checkbox'>?°å?<br>";
			<%
			if(userBean!=null){
				StringBuilder sb = new StringBuilder("var div=\"<div>");
				for(int i=0;i<b.menu.size();i++){
					ObjectNode obj = (ObjectNode)b.menu.get(i);
					JsonNode json = obj.get("text");
					if(json!=null){
						String text = json.asText();
						sb.append(I18N.getString(userBean.language,text));
						sb.append("&nbsp;&nbsp;&nbsp;<input id='");
						sb.append(text);
						sb.append("_add' type='checkbox' \"+enable["+i+"][0]+\">");
						sb.append(I18N.getString(userBean.language,"add"));
						sb.append("&nbsp;&nbsp;&nbsp;<input id='");
						sb.append(text);
						sb.append("_edit' type='checkbox' \"+enable["+i+"][1]+\">");
						sb.append(I18N.getString(userBean.language,"edit"));
						sb.append("&nbsp;&nbsp;&nbsp;<input id='");
						sb.append(text);
						sb.append("_del' type='checkbox' \"+enable["+i+"][2]+\">");
						sb.append(I18N.getString(userBean.language,"del"));
						sb.append("&nbsp;&nbsp;&nbsp;<input id='");
						sb.append(text);
						sb.append("_view' type='checkbox' \"+enable["+i+"][3]+\">");
						sb.append(I18N.getString(userBean.language,"view"));
						sb.append("<br>");
					}
				}
				sb.append("</div>\";");
				out.println(sb.toString());
			}
			%>
	        return div;
	    }
		
	    // The javascript executed specified by JQGridColumn.EditTypeCustomGetValue when EditType = EditType.Custom
	    // One parameter passed - the custom element created in JQGridColumn.EditTypeCustomCreateElement
	    function getFreightElementValue(elem, oper, value) {
			var data = elem.children();
			if (oper == "set") {
					if(value&1){
						data.eq(0).attr('checked', true);
					}else{
						data.eq(0).attr('checked', false);
					}
					if(value&2){
						data.eq(1).attr('checked', true);
					}else{
						data.eq(1).attr('checked', false);
					}
					if(value&4){
						data.eq(2).attr('checked', true);
					}else{
						data.eq(2).attr('checked', false);
					}
					if(value&8){
						data.eq(3).attr('checked', true);
					}else{
						data.eq(3).attr('checked', false);
					}
			}else if (oper == "get") {
	        	var text = "";
	        	for(i=0;i<data.length;i+=5){
	        		var val = 0;
	        		if(data.eq(i).prop("checked")){
	        			val = val+1;
	        		}
	        		if(data.eq(i+1).prop("checked")){
	        			val = val+2;
	        		}
	        		if(data.eq(i+2).prop("checked")){
	        			val = val+4;
	        		}
	        		if(data.eq(i+3).prop("checked")){
	        			val = val+8;
	        		}
	        		if(i>0){
	        			text = text+","+val;
	        		}else{
	        			text = val;
	        		}
	        	}
	        	console.log("text="+text);
	            return text;
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
