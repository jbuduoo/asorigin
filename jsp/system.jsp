<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="system.db.LangSQL"%>
<%@page import="system.db.RoleSQL"%>
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
		String pass1 = null;
		String pass2 = null;
		String success = null;
		String failure = null;
		String test = null;
		String on = null;
		String off = null;
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
				on = I18N.getString(userBean.language,"item.ON");
				off = I18N.getString(userBean.language,"item.OFF");
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
			systemGrid('#jqGrid','tableData.jsp?item=system&NumOfRow='+NumOfRow,'id,Type');
			$("#jqGrid").closest(".ui-jqgrid-bdiv").css({ "overflow-x" : "hidden","overflow-y" : "hidden" });
		});
		var lastSelection;
		var grid;
		var NumOfRow = 255;
		function systemGrid(jqGridDiv,urlValue,hidecol){
			grid = jQuery(jqGridDiv);
			$(jqGridDiv).jqGrid({
				url : urlValue,
				datatype : "json",
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
					label : 'Type',
					name : 'Type',
					width : 1,
					edittype : 'text',
					editable : false,
					editrules : {
						required : true
					},
					editoptions: {size:10, maxlength: 15} 
				},{
					label : 'Name',
					name : 'Name',
					width : 150,
					edittype : 'text',
					editable : false,
					editrules : {
						required : true
					},
					editoptions: {size:10, maxlength: 15} 
				}, {
					label : 'Value',
					name : 'Value',
					width : 150,
					//edittype : 'text',
					editrules : {
						//custom: true, custom_func: validation,
						required : false
					},
					formatter :systemformat,
					editable : true

				// must set editable to true if you want to make the field editable
				}],
				//sortname : 'Name',
				//sortorder : 'asc',
				loadonce : false,
				viewrecords : false,
				height : '100%',
				width : 600,
				top : 100,
				afterSubmitCell:function(serverresponse, rowid, cellname, value, iRow, iCol){
					//var responseText = serverresponse.responseText;
					//ajaxSuccess(responseText);
					//if(responseText!='Success'){
					//	return [false,responseText];
					//}
					return [true,""];
				}, 
				cellEdit: true,
				cellsubmit: 'clientArray',
				rowNum : NumOfRow,
				cmTemplate: {sortable:false},
				//onSelectRow: editRow,
				//caption:captionValue,
				//pager : "#jqGridPager",
				//inlineEditing: { keys: true, defaultFocusField: "Value", focusField: "Value" },
				grouping: true,
	            groupingView: {
	                groupField: ["Type"],
	                groupColumnShow: [true],
	                groupText: ["<b>{0}</b>"],
	                //groupOrder: ["asc"],
	                groupSummary: [false],
	                groupCollapse: false
	                
	            },
	            loadComplete: function(){
	            	grid.jqGrid('setCell',7,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',15,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',16,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',21,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',22,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',29,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',30,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',6,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',18,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',20,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',28,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',32,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',33,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',34,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',41,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',50,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',52,'Value','','not-editable-cell');
	            	grid.jqGrid('setCell',110,'Value','','not-editable-cell');
					var arr = hidecol.split(',');
					for(var i=0;i<arr.length;i++){
						grid.hideCol(arr[i]);	
					}
				}
				,beforeEditCell:function(rowid,cellname,v,iRow,iCol){
					lastid = rowid;
				    lastrow = iRow;
				    lastcell = iCol;
				}

			});
			$(".ui-jqgrid-hdiv").css("display","none");
			//$(".ui-jqgrid-titlebar").hide();
		}
		
		function ajaxSuccess(response){
			if(response!='Success'){
				showmsg('<%=failure%>');
				grid.trigger("reloadGrid");
			}else{
				showmsg('<%=success%>');
			}
		}
		
		function systemformat(cellValue, options, rowObject) {
			var id = parseInt(options.rowId);
			switch(id){
				case 7:
				case 16:
				case 22:
				case 30:
				case 32:
				case 41:
				case 50:
				case 110:
					<%
					if(userBean!=null){
						if((value&2)>0){
							out.println("return \"<input class='ui-corner-all' style='width:52px;font-size: 14px;' type='button' value='\"+cellValue+\"' onclick=\\\"ajaxactive(\"+id+\",'')\\\" />\"");
						}else{
							out.println("return \"\";");
						}
					}
				%>
					
					break;
				case 15:
					return "<input class='ui-corner-all' type='text' id='emailTest' size='24' value=''><input class='ui-corner-all' style='width:52px;font-size: 14px;' type='button' value='<%=test%>' onclick='ajaxactive("+id+")' />";
					break;
				case 21:
					return "<input class='ui-corner-all' type='text' id='smsTest' size='24' value=''><input class='ui-corner-all' style='width:52px;font-size: 14px;' type='button' value='<%=test%>' onclick='ajaxactive("+id+")' />";
					break;
				case 29:
					return "<input class='ui-corner-all' type='text' id='smppTest' size='24' value=''><input class='ui-corner-all' style='width:52px;font-size: 14px;' type='button' value='<%=test%>' onclick='ajaxactive("+id+")' />";
					break;
				case 18:
					var text = "<select id='smsBR' style='font-size: 14px;'>";
					var sel = "";
					if(cellValue==110)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='110'"+sel+">110</option>";
					if(cellValue==300)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='300'"+sel+">300</option>";
					if(cellValue==600)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='600'"+sel+">600</option>";
					if(cellValue==1200)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='1200'"+sel+">1200</option>";
					if(cellValue==2400)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='2400'"+sel+">2400</option>";
					if(cellValue==4800)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='4800'"+sel+">4800</option>";
					if(cellValue==9600)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='9600'"+sel+">9600</option>";
					if(cellValue==14400)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='14400'"+sel+">14400</option>";
					if(cellValue==19200)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='19200'"+sel+">19200</option>";
					if(cellValue==38400)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='38400'"+sel+">38400</option>";
					if(cellValue==56000)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='56000'"+sel+">56000</option>";
					if(cellValue==57600)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='57600'"+sel+">57600</option>";
					if(cellValue==115200)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='115200'"+sel+">115200</option>";
					if(cellValue==128000)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='128000'"+sel+">128000</option>";
					if(cellValue==256000)
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='256000'"+sel+">256000</option>";
					return text;
					break;
				case 20:
					var text = "<select id='smsEncode' style='font-size: 14px;'>";
					var sel = "";
					if(cellValue=='UCS2')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='UCS2'"+sel+">UCS2</option>";
					if(cellValue=='7BIT')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='7BIT'"+sel+">7BIT</option>";
					if(cellValue=='8BIT')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='8BIT'"+sel+">8BIT</option>";
					if(cellValue=='CUSTOM')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='CUSTOM'"+sel+">CUSTOM</option>";
					return text;
					break;
				case 28:
					var text = "<select id='smppEncode' style='font-size: 14px;'>";
					var sel = "";
					if(cellValue=='UCS2')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='UCS2'"+sel+">UCS2</option>";
					if(cellValue=='7BIT')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='7BIT'"+sel+">7BIT</option>";
					if(cellValue=='8BIT')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='8BIT'"+sel+">8BIT</option>";
					if(cellValue=='CUSTOM')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='CUSTOM'"+sel+">CUSTOM</option>";
					return text;
					break;
				case 6:
					var text = "<select id='pwrule' style='font-size: 14px;'>";
					var sel = "";
					if(cellValue=='1')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='1'"+sel+"><%=pass1%></option>";
					if(cellValue=='2')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='2'"+sel+"><%=pass2%></option>";
					return text;
					break;
				case 33:
					var text = "<select id='snmpEnable' style='font-size: 14px;'>";
					var sel = "";
					if(cellValue=='0')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='0'"+sel+"><%=off%></option>";
					if(cellValue=='1')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='1'"+sel+"><%=on%></option>";
					return text;
					break;
				case 34:
					var text = "<select id='snmpVersion' style='font-size: 14px;'>";
					var sel = "";
					if(cellValue=='1')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='1'"+sel+">1</option>";
					if(cellValue=='2')
						sel = " selected";
					else
						sel = "";
					text = text+"<option value='2'"+sel+">2</option>";
					return text;
					break;
			}
			return cellValue;
		}
		
		function ajaxactive(id,value){
			try{
			if($("#jqGrid").jqGrid('getCell',lastid,'Value').search('input')>0){
				$("#jqGrid").jqGrid("saveCell", lastrow, lastcell);
				
				//alert($("#jqGrid").jqGrid('getCell',lastid,'Value'));
				//ajaxactive(lastid,$("#jqGrid").jqGrid('getCell',lastid,'Value'));
			}
			}catch (e) {}
			
			if(id==7){
				var param1 = $("#jqGrid").jqGrid('getCell',1,'Value');
				var param2 = $("#jqGrid").jqGrid('getCell',2,'Value');
				var param3 = $("#jqGrid").jqGrid('getCell',3,'Value');
				var param4 = $("#jqGrid").jqGrid('getCell',4,'Value');
				var param5 = $("#jqGrid").jqGrid('getCell',5,'Value');
				var param6 = $("#pwrule").val();
				if(!isInteger(param1)){
					myalert('<%if(userBean!=null)out.print("\""+I18N.getString(userBean.language,"item.PWExpire")+"\" "+I18N.getString(userBean.language,"FormatError"));%>');
					return;
				}
				if(!isInteger(param2)){
					myalert('<%if(userBean!=null)out.print("\""+I18N.getString(userBean.language,"item.PWNotify")+"\" "+I18N.getString(userBean.language,"FormatError"));%>');
					return;
				}
				if(!isInteger(param3)){
					myalert('<%if(userBean!=null)out.print("\""+I18N.getString(userBean.language,"item.PWHistory")+"\" "+I18N.getString(userBean.language,"FormatError"));%>');
					return;
				}
				if(!isInteger(param4)){
					myalert('<%if(userBean!=null)out.print("\""+I18N.getString(userBean.language,"item.PWminlen")+"\" "+I18N.getString(userBean.language,"FormatError"));%>');
					return;
				}
				if(!isInteger(param5)){
					myalert('<%if(userBean!=null)out.print("\""+I18N.getString(userBean.language,"item.PWerrcnt")+"\" "+I18N.getString(userBean.language,"FormatError"));%>');
					return;
				}
				//if(!isInteger(param6)){
				//	myalert('<%if(userBean!=null)out.print("\""+I18N.getString(userBean.language,"item.PWRule")+"\" "+I18N.getString(userBean.language,"FormatError"));%>');
				//	return;
				//}
				$.ajax({type:'post', url:'tableData.jsp?item=system',data:{'oper':'edit','id':id,'param1':param1,'param2':param2,'param3':param3,'param4':param4,'param5':param5,'param6':param6},error:ajaxError,complete :ajaxComplete});
			}else if(id==16){
				var param1 = $("#jqGrid").jqGrid('getCell',8,'Value');
				var param2 = $("#jqGrid").jqGrid('getCell',9,'Value');
				var param3 = $("#jqGrid").jqGrid('getCell',10,'Value');
				var param4 = $("#jqGrid").jqGrid('getCell',11,'Value');
				var param5 = $("#jqGrid").jqGrid('getCell',12,'Value');
				var param6 = $("#jqGrid").jqGrid('getCell',13,'Value');
				var param7 = $("#jqGrid").jqGrid('getCell',14,'Value');
				if(param2!=''){
					if(!isInteger(param2)){
						myalert('<%if(userBean!=null)out.print("\""+I18N.getString(userBean.language,"item.MailPort")+"\" "+I18N.getString(userBean.language,"FormatError"));%>');
						return;
					}
				}
				$.ajax({type:'post', url:'tableData.jsp?item=system',data:{'oper':'edit','id':id,'param1':param1,'param2':param2,'param3':param3,'param4':param4,'param5':param5,'param6':param6,'param7':param7},error:ajaxError,complete :ajaxComplete});
			}else if(id==22){
				var param1 = $("#jqGrid").jqGrid('getCell',17,'Value');
				var param2 = $("#smsBR").val();
				var param3 = $("#jqGrid").jqGrid('getCell',19,'Value');
				var param4 = $("#smsEncode").val();
				$.ajax({type:'post', url:'tableData.jsp?item=system',data:{'oper':'edit','id':id,'param1':param1,'param2':param2,'param3':param3,'param4':param4},error:ajaxError,complete :ajaxComplete});
			}else if(id==30){
				var param1 = $("#jqGrid").jqGrid('getCell',23,'Value');
				var param2 = $("#jqGrid").jqGrid('getCell',24,'Value');
				var param3 = $("#jqGrid").jqGrid('getCell',25,'Value');
				var param4 = $("#jqGrid").jqGrid('getCell',26,'Value');
				var param5 = $("#jqGrid").jqGrid('getCell',27,'Value');
				var param6 = $("#smppEncode").val();
				$.ajax({type:'post', url:'tableData.jsp?item=system',data:{'oper':'edit','id':id,'param1':param1,'param2':param2,'param3':param3,'param4':param4,'param5':param5,'param6':param6},error:ajaxError,complete :ajaxComplete});
			}else if(id==32){
				var param1 = $("#jqGrid").jqGrid('getCell',31,'Value');
				$.ajax({type:'post', url:'tableData.jsp?item=system',data:{'oper':'edit','id':id,'param1':param1},error:ajaxError,complete :ajaxComplete});
			}else if(id==15){
				var param1 = $("#emailTest").val();
				$.ajax({type:'post', url:'tableData.jsp?item=system',data:{'oper':'edit','id':id,'param1':param1},error:ajaxError,complete :ajaxComplete});
			}else if(id==41){
				var param1 = $("#snmpEnable").val();
				var param2 = $("#snmpVersion").val();
				var param3 = $("#jqGrid").jqGrid('getCell',35,'Value');
				var param4 = $("#jqGrid").jqGrid('getCell',36,'Value');
				var param5 = $("#jqGrid").jqGrid('getCell',37,'Value');
				var param6 = $("#jqGrid").jqGrid('getCell',38,'Value');
				var param7 = $("#jqGrid").jqGrid('getCell',39,'Value');
				var param8 = $("#jqGrid").jqGrid('getCell',40,'Value');
				$.ajax({type:'post', url:'tableData.jsp?item=system',data:{'oper':'edit','id':id,'param1':param1,'param2':param2,'param3':param3,'param4':param4,'param5':param5,'param6':param6,'param7':param7,'param8':param8},error:ajaxError,complete :ajaxComplete});
			}else if(id==50){
				var param1 = $("#jqGrid").jqGrid('getCell',46,'Value');
				var param2 = $("#jqGrid").jqGrid('getCell',47,'Value');
				$.ajax({type:'post', url:'tableData.jsp?item=system',data:{'oper':'edit','id':id,'param1':param1,'param2':param2},error:ajaxError,complete :ajaxComplete});
			}
			
		}
		
		function ajaxError(jqXHR, textStatus, errorThrown){
			alert(jqXHR.status+" "+jqXHR.statusText);
		}
		    
		function ajaxComplete(XMLHttpRequest, textStatus) {
			ajaxSuccess(XMLHttpRequest.responseText);
	    }
		
		function myalert(value) {
			$("#dialog_div").html(value);
			$("#dialog_div").dialog({
				closeText: "",
				modal: true
			});
			grid.trigger("reloadGrid");
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
					<table id="jqGrid"></table>
					<div id="jqGridPager"></div>
				</div>
			</div>
		</div>
	</div>
	<div id="dialog_div"></div>
</body>

</html>
