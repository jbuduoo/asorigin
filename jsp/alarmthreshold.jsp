<%@page import="b.b.b"%>
<%@page import="asorigin.db.bean.AlarmThreshold"%>
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
		String alarmName = null;
		String alarmType = null;
		String alarmCategory = null;
		String alarmThreshold = null;
		String alarmCount = null;
		String alarmLevel = null;
		String operator = null;
		String thStatus = null;
		String on = null;
		String off = null;
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
				alarmName = I18N.getString(userBean.language,"alarm.Name");
				alarmType = I18N.getString(userBean.language,"alarm.Type");
				alarmCategory = I18N.getString(userBean.language,"alarm.Category");
				alarmThreshold = I18N.getString(userBean.language,"alarm.Threshold");
				alarmCount = I18N.getString(userBean.language,"alarm.Count");
				alarmLevel = I18N.getString(userBean.language,"alarm.Level");
				operator = I18N.getString(userBean.language,"alarm.Operator");
				thStatus = I18N.getString(userBean.language,"item.Status");
				on = I18N.getString(userBean.language,"item.ON");
				off = I18N.getString(userBean.language,"item.OFF");
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
	<%
	out.println("var alarmType="+AlarmThreshold.getAlarmType(userBean));
	%>
		$(document).ready(function() {
			init();
			systemGrid('#jqGrid','tableData2.jsp?item=alarmthreshold&NumOfRow='+NumOfRow,'thID');
			$("#jqGrid").closest(".ui-jqgrid-bdiv").css({ "overflow-x" : "hidden","overflow-y" : "hidden" }); 
		});
		var lastSelection;
		var grid;
		var NumOfRow = Math.floor(($(window).height()-220)/24);
		var del_options = {
			beforeShowForm : function (formid)
			{
			},
			onclickSubmit: function(params,thID){
				var thName = grid.jqGrid('getCell',thID,'thName');
                  return {thID:thID,thName:thName};},errorTextFormat : function(data) {
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
				$('#thType').attr("disabled","disabled");
				$('#thCategory').attr("disabled","disabled");
				$('#thLevel').attr("disabled","disabled");
			},beforeSubmit:function (postdata, formid) {
				var selrow = grid.jqGrid('getGridParam','selrow');
				postdata.thID = grid.jqGrid('getCell',selrow,'thID');
				//alert(postdata.annPath);
				return [true,''];
			}
		};
		
		function deleteRow(cellValue, options, rowObject) {
	    	return "<input style='width:72px;font-size:14px' type='button' value='<%=delete%>' onclick='grid.jqGrid(\"delGridRow\","+rowObject.thID+",del_options)' />";	
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
					label : '',
					name : 'thID',
					width : 1,
					key : true,
					edittype : 'text',
					editable : false,
					editrules : {
						required : true
					}
				},{
					label : '<%=alarmName%>',
					name : 'thName',
					edittype: 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=alarmLevel%>',
					name : 'thLevel',
					edittype: 'select',
					editable : true,
					editrules : {
						required : true
					}
					,editoptions: {value:'<%=AlarmThreshold.getAlarmLevel(userBean)%>'}
				},{
					label : '<%=alarmType%>',
					name : 'thType',
					edittype : 'custom',
					editable : true,
					editoptions: {
						custom_value: getFreightElementValue,
	                    custom_element: createFreightEditElement
	                }
				},{
					label : '<%=alarmCategory%>',
					name : 'thCategory',
					edittype : 'custom',
					editable : true,
					editoptions: {
						custom_value: getFreightElementValue2,
	                    custom_element: createFreightEditElement2
	                }
				},{
					label : '<%=operator%>',
					name : 'operator',
					edittype: 'select',
					editable : true,
					editrules : {
						required : true
					}
					,editoptions: {value:">:>;<:<;==:==;!=:!="}
				},{
					label : '<%=alarmThreshold%>',
					name : 'thValue',
					edittype: 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=alarmCount%>',
					name : 'thCount',
					edittype: 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=thStatus%>',
					name : 'thStatus',
					edittype: 'select',
					editable : true,
					editrules : {
						required : true
					}
					,editoptions: {value:"ON:<%=on%>;OFF:<%=off%>"}
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
					//var ids = grid.jqGrid('getDataIDs');
					//for(var i=0;i < ids.length;i++){
					//	console.log(ids[i]);
					//	var value = grid.jqGrid('getCell',ids[i],'operator');
					//	value = grid.jqGrid('getCell',ids[i],'thStatus');
					//	switch(value){
					//		case 'ON':
					//			grid.jqGrid('setCell',ids[i],'thStatus','<%=on%>')
					//			break;
					//		case 'OFF':
					//			grid.jqGrid('setCell',ids[i],'thStatus','<%=off%>')
					//			break;
					//	}
					//}
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
						,beforeSubmit:function (postdata, formid) {
							postdata.thID='0';
							return [true,''];
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
		
		function typeChange(thType) {
			for(i=0;i<alarmType.length;i++){
				if(alarmType[i].type==thType){
					$("#thCategory option").remove();
					for(j=0;j<alarmType[i].category_array.length;j++){
						$("#thCategory").append($("<option></option>").attr("value", alarmType[i].category_array[j].category).text(alarmType[i].category_array[j].category+"("+alarmType[i].category_array[j].unit+")"));
					}
				}
			}
		}
		
		function createFreightEditElement(value, editOptions) {
			var div = "<select class='FormElement ui-widget-content ui-corner-all' onchange='typeChange(this.options[this.options.selectedIndex].value)'>";
			for(i=0;i<alarmType.length;i++){
				div=div+"<option";
				if(alarmType[i].type==value){
					div=div+" selected='selected'";
				}
				div=div+" value='"+alarmType[i].type+"'>"+alarmType[i].type+"</option>";
			}
			div= div+"</select>";
	        return div;
	    }
		
	    function getFreightElementValue(elem, oper, value) {
	        if (oper == "get") {
	            return $("#thType").find(":selected").val();
	        }
	    }
	    
	    function createFreightEditElement2(value, editOptions) {
            var div = "<select class='FormElement ui-widget-content ui-corner-all'>";
	    	if(editOptions.rowId!='_empty'){
	    		var selrow = grid.jqGrid('getGridParam','selrow');
	            var thType = grid.jqGrid('getCell',selrow,'thType');
	    		for(i=0;i<alarmType.length;i++){
	    			if(alarmType[i].type==thType){
		    			for(j=0;j<alarmType[i].category_array.length;j++){
							div=div+"<option";
							if(alarmType[i].category_array[j].category==value){
								div=div+" selected='selected'";
							}
							div=div+" value='"+alarmType[i].category_array[j].category+"'>"+alarmType[i].category_array[j].category+"("+alarmType[i].category_array[j].unit+")"+"</option>";
		    			}
		    			break;
	    			}
				}
	    	}else{
	    		for(i=0;i<alarmType.length;i++){
	    			for(j=0;j<alarmType[i].category_array.length;j++){
					div=div+"<option";
					div=div+" value='"+alarmType[i].category_array[j].category+"'>"+alarmType[i].category_array[j].category+"("+alarmType[i].category_array[j].unit+")"+"</option>";
	    			}
	    			break;
				}
	    	}
			
			
			div= div+"</select>";
	        return div;
	    }
		
	    function getFreightElementValue2(elem, oper, value) {
	        if (oper == "get") {
	            return $("#thCategory").find(":selected").val();
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
