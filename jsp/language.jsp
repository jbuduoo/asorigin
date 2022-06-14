<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="com.fasterxml.jackson.databind.node.ObjectNode"%>
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
		String langCode = null;
		String langName = null;
		String importStr = null;
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
				langCode = I18N.getString(userBean.language,"item.LangCode");
				langName = I18N.getString(userBean.language,"item.LangName");
				importStr = I18N.getString(userBean.language,"Import");
				export = I18N.getString(userBean.language,"Export");
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
			systemGrid('#jqGrid','tableData.jsp?item=lang&NumOfRow='+NumOfRow,'');
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
					label : '<%=langCode%>',
					name : 'langcode',
					key : true,
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=langName%>',
					name : 'langname',
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=importStr%>',
					name : 'import',
					edittype : 'text',
					editable : false,
					formatter :systemformat2
				},{
					label : '<%=export%>',
					name : 'export',
					edittype : 'text',
					editable : false,
					formatter :systemformat
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
						edit : false,
						add : false,
						del : false,
						search : false,
						refresh : false,
						view : false,
						position : "left",
						cloneToTop : false
						
					},
					// options for the Edit Dialog
					{
						recreateForm : true,
						checkOnUpdate : true,
						checkOnSubmit : true,
						closeAfterEdit : true,
						errorTextFormat : function(data) {
							return 'Error: ' + data.responseText
						},
						beforeShowForm : function (formid)
						{
							$('#langcode').attr("readonly","readonly");
						}
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
						beforeShowForm : function (formid)
						{
						},
						onclickSubmit: function(params){
			                  var selrow = grid.jqGrid('getGridParam','selrow');
			                  var langcode = grid.jqGrid('getCell',selrow,'langcode');
			                  return {langcode:langcode};},errorTextFormat : function(data) {
							return 'Error: ' + data.responseText
						}
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
		
		function systemformat(cellValue, options, rowObject) {
			//alert(rowObject.langcode);
			return "<a href='' id='langexport_"+rowObject.langcode+"' ><input style='width:72px;font-size:14px' type='button' value='<%=export%>' onclick='exportfun(\""+rowObject.langcode+"\");' /></a>";
		}
		
		function systemformat2(cellValue, options, rowObject) {
			//alert(rowObject.langcode);
			return "<input style='width:72px;font-size:14px' id=\""+"lang_"+rowObject.langcode+"_"+rowObject.langname+"_file\" name=\""+"lang_"+rowObject.langcode+"_"+rowObject.langname+"\" type=\"file\" onchange=\"javascript:uploadFile(this.name,this.id);\"/>";
		}
		
		function exportfun(langcode){
			//alert(lang.href+' '+code+" "+langcode);
			document.getElementById('langexport_'+langcode).href = "downloadData.jsp?item=langexport&value="+langcode;
		}
		
		function uploadFile(id,fileid){
			var responseText;
			var formData = new FormData();
			var fileSelect = document.getElementById(fileid);
			var files = fileSelect.files;
			var file = files[0]; 
			if(file){
				formData.append(id, file);
				var xmlhttp;
				if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
					xmlhttp = new XMLHttpRequest();
				} else {// code for IE6, IE5
					xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
				}
				xmlhttp.open('POST', '/fileUpload.jsp', false);
				xmlhttp.onload = function () {
				
				};
				xmlhttp.send(formData);
				if (xmlhttp.status == 200) {
				  if(xmlhttp.responseText=='Success'){
					  return;
				  }
				}
				alert($.jgrid.edit.msg.uploadfail);
			}else{
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
