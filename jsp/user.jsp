<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="system.db.LangSQL"%>
<%@page import="system.db.RoleSQL"%>
<%@page import="system.db.SystemSQL"%>
<%@page import="com.fasterxml.jackson.databind.node.ObjectNode"%>
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
		String userNameStr = null;
		String pw = null;
		String confirm = null;
		String email = null;
		String phone = null;
		//String pwtime = null;
		//String pwhistory = null;
		String role = null;
		String lang = null;
		String status = null;
		String on = null;
		String off = null;
		String note = null;
		String delete = null;
		String lineID = null;
		String lineToken = null;
		int value = 0;
		if(userBean!=null){
			for(int i=0;i<b.menu.size();i++){
				ObjectNode obj = (ObjectNode)b.menu.get(i);
				if(obj.get("text").asText().equals("menu.System")){
					value = userBean.roleInt[i];
				}
			}
			if(value>0){
			userNameStr = I18N.getString(userBean.language,"item.UserName");
			pw = I18N.getString(userBean.language,"item.Password");
			confirm = I18N.getString(userBean.language,"item.Confirm");
			email = I18N.getString(userBean.language,"item.Email");
			phone = I18N.getString(userBean.language,"item.Phone");
			//pwtime = I18N.getString(userBean.language,"item.PWtime");
			//pwhistory = I18N.getString(userBean.language,"item.PWhistory");
			role = I18N.getString(userBean.language,"item.Role");
			lang = I18N.getString(userBean.language,"item.Language");
			status = I18N.getString(userBean.language,"item.UpStatus");
			on = I18N.getString(userBean.language,"item.ON");
			off = I18N.getString(userBean.language,"item.OFF");
			note = I18N.getString(userBean.language,"item.Note");
			delete = I18N.getString(userBean.language,"del");
			lineID = I18N.getString(userBean.language,"item.LINEID");
			lineToken = I18N.getString(userBean.language,"item.LINEToken");
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
	var lastpassword;
		$(document).ready(function() {
			init();
			systemGrid('#jqGrid','tableData.jsp?item=user&NumOfRow='+NumOfRow,'pwhistory');
			$("#jqGrid").closest(".ui-jqgrid-bdiv").css({ "overflow-x" : "hidden","overflow-y" : "hidden" }); 
		});
		var lastSelection;
		var grid;
		var NumOfRow = Math.floor(($(window).height()-220)/24);
		var del_options = {
			onclickSubmit: function(params,userName){
                  return {userName:userName};},errorTextFormat : function(data) {
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
				$('#userName').attr("readonly","readonly");
				lastpassword = $('#password').val();
			}
			,onclickSubmit: function(options, postData){
				if(postData.password!=lastpassword){
					postData.password=hex_md5(postData.password);
				}
				return postData;
			}
		};
		
		function deleteRow(cellValue, options, rowObject) {
	    	return "<input style='width:72px;font-size:14px' type='button' value='<%=delete%>' onclick='if(\""+rowObject.userName+"\"!=\"<%=b.rootUser%>\"){grid.jqGrid(\"delGridRow\",\""+rowObject.userName+"\",del_options);}else{alert($.jgrid.del.rootmsg);}' />";	
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
					label : '<%=userNameStr%>',
					name : 'userName',
					key : true,
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=pw%>',
					name : 'password',
					edittype : 'password',
					editable : true,
					editrules : {
						required : true
						,custom:true, custom_func:customChk
					}
				},{
					label : '<%=confirm%>',
					name : 'confirm',
					edittype : 'password',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=email%>',
					name : 'email',
					edittype : 'text',
					editable : true,
					editrules : {
						required : false
						,email: true
					}
				},{
					label : '<%=phone%>',
					name : 'phone',
					edittype : 'text',
					editable : true,
					editrules : {
						required : false
						,number:true
					}
				},{
					label : '<%=lineID%>',
					name : 'lineID',
					edittype : 'text',
					editable : true,
					editrules : {
						required : false
					}
				},{
					label : '<%=lineToken%>',
					name : 'lineToken',
					edittype : 'text',
					editable : true,
					editrules : {
						required : false
					}
				},{
					label : 'pwhistory',
					name : 'pwhistory',
					edittype : 'text',
					editable : false,
					width : 1,
					editrules : {
						required : false
					}
				},{
					label : '<%=role%>',
					name : 'role',
					edittype : 'select',
					editable : true,
					editrules : {
						required : true
					}
					,editoptions: {value:'<%=Encode.forHtml(RoleSQL.getRoleName())%>'}
				},{
					label : '<%=lang%>',
					name : 'lang',
					edittype : 'select',
					editable : true,
					editrules : {
						required : true
					}
					,editoptions: {value:'<%=Encode.forHtml(LangSQL.getLangName())%>'}
				},{
					label : '<%=status%>',
					name : 'status',
					edittype : 'select',
					editable : true,
					editrules : {
						required : true
					}
					,editoptions: {value:"ON:<%=on%>;OFF:<%=off%>"}
				},{
					label : '<%=note%>',
					name : 'note',
					edittype : 'text',
					editable : true,
					editrules : {
						required : false
					}
				<%
				if((value&4)>0){
					out.println("},{label : '"+delete+"',name : 'delete',edittype : 'text',formatter :deleteRow");
				}
				%>
				}
				],
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
						,onclickSubmit: function(options, postData){
							if(postData.password!=lastpassword){
								postData.password=hex_md5(postData.password);
							}
							return postData;
						}
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
		
		function customChk(value, colname) {
			//alert(value+" "+$('#password').val());
				if(value!=$('#confirm').val()){
					return [false,$.jgrid.edit.msg.confirmmsg];
			    	//alert(row.password);
				}
				if(value==$('#userName').val()){
					return [false,$.jgrid.edit.msg.userpasssame];
			    	//alert(row.password);
				}
				<%
				if(userBean!=null){
					int[] rule = SystemSQL.getPWRule();
					out.println("var rule=["+rule[0]+","+rule[1]+","+rule[2]+"];");
				}
				%>
				if(rule[1]!=0){
					if(value.length<rule[1]){
						return [false,colname+$.jgrid.edit.msg.minlen+rule[1]];
					}
				}
				if(rule[2]!=0){
					if(rule[2]==1){
						if(!isPassword1(value)){
							return [false,$.jgrid.edit.msg.passfail];
						}
					}else if(rule[2]==2){
						if(!isPassword2(value)){
							return [false,$.jgrid.edit.msg.passfail];
						}
					}
				}
				if(value!=lastpassword){
					if(rule[0]!=0){
						var selrow = grid.jqGrid('getGridParam','selrow');
						if(selrow){
							var pwhistory = grid.jqGrid('getCell',selrow,'pwhistory');
							var history = pwhistory.split(",");
							var password = hex_md5(value);
							for(i=0;i<history.length;i++){
								//alert(i+" "+value+" "+history[i]);
								if(password==history[i]){
									return [false,$.jgrid.edit.msg.historyfail];
								}
							}
						}
					}
				}
				
			return [true,''];
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
