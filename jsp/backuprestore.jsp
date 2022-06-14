<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="system.db.LangSQL"%>
<%@page import="system.db.RoleSQL"%>
<%@page import="system.db.SystemSQL"%>
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

<script src="style/Chart.js/Chart.bundle.js"></script>
<script src="style/Chart.js/hammer/hammer.min.js"></script>
<script src="style/Chart.js/zoom/chartjs-plugin-zoom.min.js"></script>

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
		String importStr = null;
		String apply = null;
		String language = null;
		String success = null;
		String failure = null;
		String fileName = null;
		String download = null;
		String backup = null;
		String restore = null;
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
			importStr = I18N.getString(userBean.language,"Import");
			apply = I18N.getString(userBean.language,"Apply");
			success = I18N.getString(userBean.language,"Success");
			failure = I18N.getString(userBean.language,"Failure");
			fileName = I18N.getString(userBean.language,"item.FileName");
			download = I18N.getString(userBean.language,"item.Download");
			backup = I18N.getString(userBean.language,"Backup");
			restore = I18N.getString(userBean.language,"Restore");
			delete = I18N.getString(userBean.language,"del");
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
</style>
</head>

<body id="page-top">
	<script>
	var lastpassword;
		$(document).ready(function() {
			init();
			$('.form_datetime').datetimepicker({
				format: 'yyyy-mm-dd hh:ii',
		        autoclose: true,
		        todayBtn: true,
		        minuteStep: 1,
		        language: '<%=language%>',
		        pickerPosition: "bottom-left"
		      })
			var date = new Date();
			$("#fromtime").val(formatDate(new Date(date.getTime()-60000)));
			systemGrid('#jqGrid','tableData.jsp?item=dbbackup&NumOfRow='+NumOfRow,'');
			$("#jqGrid").closest(".ui-jqgrid-bdiv").css({ "overflow-x" : "hidden","overflow-y" : "hidden" }); 
			$('#fileUploadId').hide();
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
					label : '<%=fileName%>',
					name : 'fileName',
					edittype : 'text'
				},{
					label : '<%=download%>',
					name : 'download',
					edittype : 'text',
					formatter :systemformat
				},{
					label : '<%=restore%>',
					name : 'restore',
					edittype : 'text',
					formatter :systemformat2
				},{
					label : '<%=delete%>',
					name : 'delete',
					edittype : 'text',
					formatter :systemformat3
				}],
				viewrecords : true,
				height : '100%',
				width : $("#alarmdiv").width()-20,
				top : 100,
				rowNum : NumOfRow,
				rownumbers: false,
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
					},
					// options for the Add Dialog
					{
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
				showmsg('<%=failure%>');
				$("#jqGrid").trigger("reloadGrid");
			}else{
				showmsg('<%=success%>');
			}
		}
		function ajaxError(jqXHR, textStatus, errorThrown){
			showmsg('<%=failure%>');
			$("#jqGrid").trigger("reloadGrid");
		}
		    
		function ajaxComplete(XMLHttpRequest, textStatus) {
			ajaxSuccess(XMLHttpRequest.responseText);
			$("#jqGrid").trigger("reloadGrid");
	    }
		
		function backupapply(){
		    //$('#backupexport').attr("href",'downloadData.jsp?item=dbbackup');
			$.ajax({type:'post', url:'tableData.jsp?item=dbbackup',data:{'oper':'Backup'},error:ajaxError,complete :ajaxComplete});
		}
		function systemformat(cellValue, options, rowObject) {
			//alert(rowObject.langcode);
			return "<a href='' id='"+rowObject.fileName+"' ><input style='width:72px;font-size:14px' type='button' value='<%=download%>' onclick='exportfun(\""+rowObject.fileName+"\");' /></a>";
		}
		function exportfun(id){
			//alert(lang.href+' '+code+" "+langcode);
			document.getElementById(id).href = "downloadData.jsp?item=dbbackup&value="+id;
		}
		function systemformat2(cellValue, options, rowObject) {
			//alert(rowObject.langcode);
			return "<input style='width:72px;font-size:14px' type='button' value='<%=restore%>' onclick='restore(\""+rowObject.fileName+"\");' />";
		}
		function restore(id){
			if(confirm($.jgrid.edit.msg.restore)){
				$.ajax({type:'post', url:'tableData.jsp?item=dbbackup',data:{'oper':'Restore','name':id},error:ajaxError,complete :ajaxComplete});
			}
		}
		function systemformat3(cellValue, options, rowObject) {
			//alert(rowObject.langcode);
			return "<input style='width:72px;font-size:14px' type='button' value='<%=delete%>' onclick='del(\""+rowObject.fileName+"\");' />";
		}
		function del(id){
			if(confirm($.jgrid.del.msg)){
				$.ajax({type:'post', url:'tableData.jsp?item=dbbackup',data:{'oper':'del','name':id},error:ajaxError,complete :ajaxComplete});
			}
		}
		
		function upload(){
			console.log("upload");					
			var formData = new FormData(); 
			var fileSelect = document.getElementById('fileUploadId');
			var files = fileSelect.files;
			var file = files[0]; 
			formData.append(file.name, file);
			
			$.ajax({
				type : "POST",
				url : "fileUpload3.jsp",
				data : formData,
				cache : false, // 不需要cache
				processData : false, 
				contentType : false,
				//dataType: 'text',
				success : function(data) {
					alert(data);
					location.reload();  //頁面重新整理
				},
				error : function(data) {
					alert(data.exception);
				}
			});
			
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
				<div style="margin-bottom: 10px;margin-top: 10px">
    
    &nbsp;&nbsp;
    <button id="backupbtn" type="button" class="btn btn-outline-secondary btn-sm" onclick="backupapply();"><%=backup %></button>
    &nbsp;&nbsp;&nbsp;&nbsp;
	<input type="file" id="fileUploadId" accept=".sql" class="ui-corner-all btn-sm" style="margin-bottom: 4px" onchange="upload()"/>
	<input type='button' value='上傳' class="btn btn-outline-secondary btn-sm" onclick='javascript:$("#fileUploadId").click();'/>
    
    </div>
					<table id="jqGrid"></table>
					<div id="jqGridPager"></div>
					<div style="padding-left: 22%;padding-top: 10px">
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="dialog_div"></div>
</body>

</html>
