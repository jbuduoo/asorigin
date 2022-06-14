<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="com.fasterxml.jackson.databind.node.ObjectNode"%>
<%@page import="asorigin.servlet.TableData2"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Hashtable"%>
<%@page import="asorigin.db.bean.AlarmThreshold"%>
<%@page import="asorigin.db.AlarmThresholdSQL"%>
<%@page import="system.db.UserSQL"%>
<%@page import="org.owasp.encoder.Encode"%>
!DOCTYPE html>
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
		String forName = null;
		String forUser = null;
		String forCategory = null;
		String forMethod = null;
		String forTime = null;
		String thresholdList = "";
		String thresholdList2 = "";
		String [] weeks = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
		List<String> weekList = new ArrayList<String>();
		String selectAll = null;
		String forStatus = null;
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
				forName = I18N.getString(userBean.language,"item.ForwardName");
				forUser = I18N.getString(userBean.language,"item.ForwardUser");
				forCategory = I18N.getString(userBean.language,"item.ForwardCategory");
				forMethod = I18N.getString(userBean.language,"item.ForwardMethod");
				forTime = I18N.getString(userBean.language,"item.ForwardTime");
				forStatus = I18N.getString(userBean.language,"item.Status");
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
				
				// 讀取alarmThreshold內的alarm.thCategory
				Hashtable<String, AlarmThreshold> alarmThreadhold = AlarmThresholdSQL.loadData();
				Enumeration<AlarmThreshold> enume2 = alarmThreadhold.elements();
				int count = 0;
				while (enume2.hasMoreElements()) {
					count++;
					AlarmThreshold alarm = enume2.nextElement();
					//String threshold = I18N.getString(userBean.language,alarm.thCategory);
					thresholdList += alarm.thName + ",";
					thresholdList2 += alarm.thID + ",";
				}
				if(thresholdList.length() > 0) {
					thresholdList = thresholdList.substring(0, thresholdList.length()-1);
					thresholdList2 = thresholdList2.substring(0, thresholdList2.length()-1);
				}
				
				// 處理一週七天名稱的多國語系
				selectAll = I18N.getString(userBean.language,"item.All");
				for(int i=0; i<weeks.length; i++) {
					weekList.add(I18N.getString(userBean.language, weeks[i]));
				}
			}else{
				response.sendRedirect("/login.jsp");
			}
		}else{
			response.sendRedirect("/login.jsp");
		}
	%>
<style type="text/css">
.ui-jqdialog {
    width: 700px !important;
}

</style>
</head>

<body id="page-top">
	<script>
	var methodList = "Email,LINE,SMS";
	var dialogWidth = $(window).width()-300;
	dialogWidth = 700;
		$(document).ready(function() {
			init();
			systemGrid('#jqGrid','tableData2.jsp?item=alarmforward&NumOfRow='+NumOfRow,'forID,forTime'); //web.xml define
			$("#jqGrid").closest(".ui-jqgrid-bdiv").css({ "overflow-x" : "hidden","overflow-y" : "hidden" }); 
		});
		var lastSelection;
		var grid;
		var NumOfRow = Math.floor(($(window).height()-220)/24);
		var del_options = {
			beforeShowForm : function (formid)
			{
			},
			onclickSubmit: function(params,forID){
                return {forID:forID};},errorTextFormat : function(data) {
               	return 'Error: ' + data.responseText
   			},afterComplete: function (response, postdata, formid) {ajaxSuccess(response.responseText);}
		};
		var edit_options = {
			recreateForm : true,
			checkOnUpdate : true,
			checkOnSubmit : true,
			closeAfterEdit : true,
			viewPagerButtons : false,
			focusField: false,
			width : dialogWidth,
			errorTextFormat : function(data) {
				return 'Error: ' + data.responseText
			},
			beforeShowForm : function (formid)
			{
				$('#forName').attr("disabled","disabled");
			},
			afterShowForm : function (formid)
			{
			}
			,beforeSubmit:function (postdata, formid) {
				var selrow = grid.jqGrid('getGridParam','selrow');
				postdata.forID = grid.jqGrid('getCell',selrow,'forID');
				//alert(postdata.annPath);
				return [true,''];
			}
		};
		
		function deleteRow(cellValue, options, rowObject) {
	    	return "<input style='width:72px;font-size:14px' type='button' value='<%=delete%>' onclick='grid.jqGrid(\"delGridRow\","+rowObject.forID+",del_options)' />";	
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
					label : 'ID',
					name : 'forID',
					width : 1,
					key : true,
					edittype : 'text',
					editable : false,
					editrules : {
						required : true
					}
				},{
					label : '<%=forName%>',
					name : 'forName',
					edittype : 'text',
					editable : true,
					editrules : {
						required : true
					}
				},{
					label : '<%=forUser%>',
					name : 'forUser',
					edittype : 'custom',
					editable : true,
					editoptions: {
						custom_value: getFreightElementValue,
						custom_element: createFreightEditElement
	                },
					editrules : {
						required : true
					}
				},{
					label : '<%=forCategory%>',
					name : 'forCategory',
					edittype : 'custom',
					editable : true,
					editoptions: {
						custom_value: getFreightElementValue2,
						custom_element: createFreightEditElement2
	                },
					editrules : {
						required : true
					}
				},{
					label : '<%=forMethod%>',
					name : 'forMethod',
					edittype : 'custom',
					editable : true,
					editoptions: {
						custom_value: getFreightElementValue3,
						custom_element: createFreightEditElement3
	                },
					editrules : {
						required : false
					}
				},{
					// https://drive.google.com/file/d/1XlShwS5cJLqYjX9PETVzsuIccI7Nfpwr/view?usp=sharing
					label : '<%=forTime%>',
					name : 'forTime',
					edittype : 'custom',
					editable : true,
					width : 1,
					editoptions: {
						custom_value: getFreightElementValue4,
						custom_element: createFreightEditElement4
	                },
					editrules : {
						required : false
					}
				},{
					label : '<%=forStatus%>',
					name : 'forStatus',
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
						width : dialogWidth,
						afterShowForm : function (formid)
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
							postdata.forID='0';
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
		
		function createTdLine8(user1, user2, user3, user4, user5, user6, user7, user8, user9, user10, user11, user12, user13, user14, user15, user16, user17, user18, user19, user20, user21, user22, user23, user24) {
			//alert("tmp[0] = "+tmp[0]);
			//console.log("tmp[0] = "+tmp[0]);
			
			var trhead ='<tr style="line-height: 12px;">';
			var tdhead = '<td>';
			var td = trhead + tdhead + user1 + '</td>';
			    td =     td + tdhead + user2 + '</td>';
			    td =     td + tdhead + user3 + '</td>';
			    td =     td + tdhead + user4 + '</td>';
			    td =     td + tdhead + user5 + '</td>';
			    td =     td + tdhead + user6 + '</td>';
			    td =     td + tdhead + user7 + '</td>';
			    td =     td + tdhead + user8 + '</td>';
			    td =     td + tdhead + user9 + '</td>';
			    td =     td + tdhead + user10 + '</td>';
			    td =     td + tdhead + user11 + '</td>';
			    td =     td + tdhead + user12 + '</td>';
			    td =     td + tdhead + user13 + '</td>';
			    td =     td + tdhead + user14 + '</td>';
			    td =     td + tdhead + user15 + '</td>';
			    td =     td + tdhead + user16 + '</td>';
			    td =     td + tdhead + user17 + '</td>';
			    td =     td + tdhead + user18 + '</td>';
			    td =     td + tdhead + user19 + '</td>';
			    td =     td + tdhead + user20 + '</td>';
			    td =     td + tdhead + user21 + '</td>';
			    td =     td + tdhead + user22 + '</td>';
			    td =     td + tdhead + user23 + '</td>';
			    td =     td + tdhead + user24 + '</td></tr>';
			
			return td;
		}
		
		function createTdLine3(user1, user2, user3) {
			//alert("tmp[0] = "+tmp[0]);
			//console.log("tmp[0] = "+tmp[0]);
			
			var trhead = '<tr style="line-height: 12px;">';
			var tdhead = '<td>';
			//var inputchk = '<input type="checkbox" />';
			var td = trhead + tdhead + user1 + '</td>';
			    td =     td + tdhead + user2 + '</td>';
			    td =     td + tdhead + user3 + '</td></tr>';
			
			return td;
		}
		
		/*
		 * 此為forUser的Add/Edit項目的顯示
		 */
		function createFreightEditElement(value, editOptions) {
			//alert("editOptions.id = "+editOptions.id);
			
			//alert("value.length = "+value.length);
			//var tmp = value.split(',');			
			<%			
				String userListAll = Encode.forHtml(UserSQL.getUser());
			%>
			// 預備相關字串常數
			var inputchk = '<label><input type="checkbox" value="123"/>';
			var inputchecked = '<label><input type="checkbox" checked/>';
			
			// 陣列初始化旗標
			var table, tmp;
			table = '<table class="scroll" style="border-spacing: 0;border: 2px solid #ccc;" >';
			tmp = '<%=userListAll%>'.split(',');
			table = table + '<tbody style="display: block; width: '+(dialogWidth-100)+'px; height: 100px; overflow-y: auto; overflow-x: hidden;">';
			
			var checked = [];
			for(i=0; i<tmp.length; i++) {
				checked.push(0);
			}			
			
			// 實際資料初始化旗標
			var tmp2 = value.split(',');
			for(i=0; i<tmp2.length; i++) {
				for(j=0; j<tmp.length; j++) {
					if(tmp2[i] == tmp[j]) {						 
						checked[j] = 1;			// 設定旗標
					}
				}				
			}
			
			// 根據旗標初始checkbox
			var tds = [];
			for(i=0; i<tmp.length; i++) {
				if(checked[i]==0) 
					tds.push(inputchk + tmp[i] + '</label>');
				else if(checked[i]==1) 
					tds.push(inputchecked + tmp[i] + '</label>');
			}
			
			var tdRow = [];
			var i;			
			
			// 每列最多三筆，並留下最後一列另作判斷
			for(i=0; i<tds.length-3; i+=3) {
				tdRow.push(createTdLine3(tds[i], tds[i+1], tds[i+2]));
			}
			if(i+3==tds.length) { // three thing left
				tdRow.push(createTdLine3(tds[tds.length-3], tds[tds.length-2], tds[tds.length-1]));
			}
			else if(i+2==tds.length) { // two thing left
				tdRow.push(createTdLine3(tds[tds.length-2], tds[tds.length-1],""));
			}
			else if(i+1==tds.length) { // one thing left
				tdRow.push(createTdLine3(tds[tds.length-1], "",""));
			} 
			
			// 加入每一列
			for(i=0; i<tdRow.length; i++) {
				table = table + tdRow[i];
			}
			table = table + '</tbody></table>';
			
	        return table;
	    }
		
		/*
		 * 此為forCategory的Add/Edit項目的顯示
		 */
		function createFreightEditElement2(value, editOptions) {
			//alert("editOptions.id = "+editOptions.id);
			
			//alert("value.length = "+value.length);
			//var tmp = value.split(',');			
			// 預備相關字串常數
			var inputchk = '<label><input type="checkbox" value="';
			var inputchecked = '<label><input type="checkbox" checked value="';
			
			// 陣列初始化旗標
			var table, tmp, tmp3;
			table = '<table class="scroll" style="border-spacing: 0;border: 2px solid #ccc;" >';
			tmp = '<%=thresholdList%>'.split(',');
			tmp3 = '<%=thresholdList2%>'.split(',');
			table = table + '<tbody style="display: block; width: '+(dialogWidth-100)+'px; height: 100px; overflow-y: auto; overflow-x: hidden;">';
			table = table+'<tr><td><label><input type="checkbox" id="9" onchange="handleChange(this,20);"/><%=selectAll%></td></tr>';
			var checked = [];
			for(i=0; i<tmp.length; i++) {
				checked.push(0);
			}			
			
			// 實際資料初始化旗標
			var tmp2 = value.split(',');
			for(i=0; i<tmp2.length; i++) {
				for(j=0; j<tmp.length; j++) {
					if(tmp2[i] == tmp3[j]) {						 
						checked[j] = 1;			// 設定旗標
					}
				}				
			}
			
			// 根據旗標初始checkbox
			var tds = [];
			for(i=0; i<tmp.length; i++) {
				var lab = "";
				if(checked[i]==0) 
					lab = inputchk;
				else if(checked[i]==1) 
					lab = inputchecked;
				lab = lab +tmp3[i]+'"'+' id="9_'+(i+1)+'"'+'/>'+tmp[i]+ '</label>';
				tds.push(lab);
			}
			
			var tdRow = [];
			var i;			
			
			// 每列最多三筆，並留下最後一列另作判斷
			for(i=0; i<tds.length-3; i+=3) {
				tdRow.push(createTdLine3(tds[i], tds[i+1], tds[i+2]));
			}
			if(i+3==tds.length) { // three thing left
				tdRow.push(createTdLine3(tds[tds.length-3], tds[tds.length-2], tds[tds.length-1]));
			}
			else if(i+2==tds.length) { // two thing left
				tdRow.push(createTdLine3(tds[tds.length-2], tds[tds.length-1],""));
			}
			else if(i+1==tds.length) { // one thing left
				tdRow.push(createTdLine3(tds[tds.length-1], "",""));
			} 
			
			// 加入每一列
			for(i=0; i<tdRow.length; i++) {
				table = table + tdRow[i];
			}
			table = table + '</tbody></table>';
			
	        return table;
	    }
		
		function createFreightEditElement3(value, editOptions) {
			//alert("editOptions.id = "+editOptions.id);
			
			//alert("value.length = "+value.length);
			//var tmp = value.split(',');			
			
			// 預備相關字串常數
			var inputchk = '<label><input type="checkbox" />';
			var inputchecked = '<label><input type="checkbox" checked/>';
			//var inputcheckeddisabled = '<label><input type="checkbox" checked disabled/>'; // 20191114 暫時先用checked disabled
			
			// 陣列初始化旗標
			var table, tmp;
			if(editOptions.id == 'forMethod') {
				table = '<table class="scroll" style="border-spacing: 0;" >';
				tmp = methodList.split(',');
				//alert("tmp.length = "+tmp.length + ", tmp[0] = " + tmp[0] );
			} 
			table = table + '<tbody style="display: block; width: '+(dialogWidth-100)+'px; height: 33px; overflow-x: hidden;">';
			
			var checked = [];
			for(i=0; i<tmp.length; i++) {
				checked.push(0);
			}			
			
			// 實際資料初始化旗標
			var tmp2 = value.split(',');
			for(i=0; i<tmp2.length; i++) {
				for(j=0; j<tmp.length; j++) {
					//20191114
					//目前只有"電子郵件"項目, 所以先預設為true
					//且暫時先用checked disabled
					if(tmp2[i] == tmp[j]) {						 
						checked[j] = 1;			// 設定旗標
					}
				}				
			}
			
			// 根據旗標初始checkbox
			var tds = [];
			for(i=0; i<tmp.length; i++) {
				if(checked[i]==0) 
					tds.push(inputchk + tmp[i] + '</label>');
				else if(checked[i]==1) {
					tds.push(inputchecked + tmp[i] + '</label>'); 
					//tds.push(inputcheckeddisabled + tmp[i] + '</label>'); // 20191114 暫時先用checked disabled
				}
			}
			
			var tdRow = [];
			var i;			
			
			// 每列最多三筆，並留下最後一列另作判斷
			for(i=0; i<tds.length-3; i+=3) {
				tdRow.push(createTdLine3(tds[i], tds[i+1], tds[i+2]));
			}
			if(i+3==tds.length) { // three thing left
				tdRow.push(createTdLine3(tds[tds.length-3], tds[tds.length-2], tds[tds.length-1]));
			}
			else if(i+2==tds.length) { // two thing left
				tdRow.push(createTdLine3(tds[tds.length-2], tds[tds.length-1],""));
			}
			else if(i+1==tds.length) { // one thing left
				tdRow.push(createTdLine3(tds[tds.length-1], "",""));
			} 
			
			// 加入每一列
			for(i=0; i<tdRow.length; i++) {
				table = table + tdRow[i];
			}
			table = table + '</tbody></table>';
			
	        return table;
	    }
		
		/*
		 * 此為forTime的Add/Edit項目的顯示
		 * 與forUser和forCategory一樣用table的方式顯示，但不同的是:
		 * 1) forTime為8個column, forUser和forCategory為3個column
		 * 2) forTime的height為125px, forUser和forCategory的height為100px
		 */
		function createFreightEditElement4(value, editOptions) {
			var table = '<table class="scroll" style="border-spacing: 0;border: 2px solid #ccc;" >';
			table = table + '<tbody style="display: block; width: '+(dialogWidth-100)+'px; height: 125px; overflow-y: auto; overflow-x: hidden;">';
			
			if(value==''){
				<%
				StringBuilder sb2 = new StringBuilder();
				for(int i=0;i<7;i++){ // 7:Monday~Sunday
					sb2.append("0,");
				}
				if (sb2.length() > 0) {
					sb2.deleteCharAt(sb2.length() - 1);
				}
				out.println("value=\""+sb2.toString()+"\"");
				%>
			}
			var arr = value.split(',');
			//alert(value);
			
			var enable = new Array(arr.length);
			var tds = new Array(arr.length);
			for(i=0;i<enable.length;i++){
				enable[i] = new Array(24);
				tds[i] = new Array(24);
				for(j=0;j<enable[i].length;j++){
					enable[i][j] = "";
				}
			}
			
			decode(arr, enable);
			
			// 預備相關字串常數
			var inputchk = '<label><input type="checkbox" name />';
			var inputchecked = '<label><input type="checkbox" name checked/>';
			
			// 根據旗標初始checkbox
			for(i=0; i<enable.length; i++) {
				for(j=0;j<enable[i].length;j++){					
					if(enable[i][j] != "checked") 
						tds[i][j] = inputchk.replace(/name/, 'id='+(i+1)+'_'+(j+1) ) + (j+1) + '</label>';
					else if(enable[i][j] == "checked") 
						tds[i][j] = inputchecked.replace(/name/, 'id='+(i+1)+'_'+(j+1) ) + (j+1) + '</label>';
				}				
			}
			//alert("tds = "+tds);
			
			var tdRow = [];
			var n, i;
			
			// 每列最多8筆，並留下最後一列另作判斷
			var week = [];
			
			// 以多國語言的內容存到week去
			<% for (int i=0; i<weekList.size(); i++) { %>
			week.push("<%= weekList.get(i) %>");
			<% } %>
			
			// inputchkall是給Monday~Sunday的全選功能所使用
			// 所以會將id替換成1~7
			var inputchkall = '<label><input type="checkbox" id value="x" onchange="handleChange(this,24);"/>';
			
			for(n=0; n<week.length; n++) {
				
				var trweek = '<tr style="line-height: 12px;"><td colspan="24">' + week[n] + '&nbsp;&nbsp;&nbsp;' 
							 + inputchkall.replace(/id/, 'id='+(n+1) ) + '<%=selectAll%></label></td></tr>';
				tdRow.push(trweek);
				//alert("trweek = "+trweek);	
				
				for(i=0; i<tds[n].length; i+=24) {
					tdRow.push(createTdLine8(tds[n][i], tds[n][i+1], tds[n][i+2], tds[n][i+3], tds[n][i+4], tds[n][i+5], tds[n][i+6], tds[n][i+7], tds[n][i+8], tds[n][i+9], tds[n][i+10], tds[n][i+11], tds[n][i+12], tds[n][i+13], tds[n][i+14], tds[n][i+15], tds[n][i+16], tds[n][i+17], tds[n][i+18], tds[n][i+19], tds[n][i+20], tds[n][i+21], tds[n][i+22], tds[n][i+23]));
				}
			}
			
			// 加入每一列
			for(i=0; i<tdRow.length; i++) {
				table = table + tdRow[i];
			}
			table = table + '</tbody></table>';
			
	        return table;
	    }
		
		/*
		 * 此為forTime的SelectAll按鈕監聽功能製作
		 * 若selectAll的checkbox的id是1
		 * 則它控制24組的checkbox的id是1_X, X=1~24
		 * 若selectAll的checkbox的id是2
		 * 則它控制24組的checkbox的id是2_X, X=1~24
		 * 以此類推
		 */
		function handleChange(checkbox,size) {
			for(var i=0; i<size; i++) {
    			document.getElementById(checkbox.id +'_'+(i+1)).checked = checkbox.checked;
			}
		}
		
		/*
		 * 此為forTime的解碼程式
		 * 若value=1, 則編號X_1的checkbox設為checked
		 * 若value=15, 則編號X_1,X_2,X_3,X_4的checkbox設為checked
		 * 若value=8388608, 則編號X_24的checkbox設為checked
		 * 若value=16777215, 則全部的checkbox設為checked
		 */
		function decode(arr, enable) {
			var flag=1;
			for(i=0;i<arr.length;i++){
				//alert(i+" "+(arr[i]&1)+" "+(arr[i]&2)+" "+(arr[i]&4)+" "+(arr[i]&8));
				for(j=0;j<24;j++){
					if(arr[i]&(flag<<j)){
						enable[i][j] = "checked";
					}
				}
			}
		}  
	    
		/*
		 * 此為forTime的編碼程式
		 * 若編號X_1的checkbox設為checked, 則value=1
		 * 若編號X_1,X_2,X_3,X_4的checkbox設為checked, 則value=15
		 * 若編號X_24的checkbox設為checked, 則value=8388608
		 * 若全部的checkbox設為checked, 則value=16777215
		 */
		function getFreightElementValue4(elem, oper, value) {
			
			if (oper == "get") {	
	        		  
				var text = "";
				for(var i=0; i<7; i++) {
					var binary = "";
					for(var j=0; j<24; j++) {
						if ( document.getElementById((i+1)+"_"+(j+1)).checked==true ) {
							binary = "1" + binary;
					    }
						else {
							binary = "0" + binary;
						}
					}
					text = text + parseInt(binary, 2) + ",";
				}
				text = text.substr(0, text.length-1);
				
	        	return text;
	        }
	    }
		
	    // The javascript executed specified by JQGridColumn.EditTypeCustomGetValue when EditType = EditType.Custom
	    // One parameter passed - the custom element created in JQGridColumn.EditTypeCustomCreateElement
	    function getFreightElementValue(elem, oper, value) {
			
			if (oper == "get") {				
	        	
	        	// TableSection => TableCell => Label => Input
	        	var valueRow = $("#forUser :input");
	        	//alert("valueRow.length = "+valueRow.length);
        		
        		var text = "";
	        	for(j=0;j<valueRow.length;j++){
        			if(valueRow.eq(j).prop("checked"))
        				text = text + valueRow.eq(j).parent().text() + ',';
        		}        		
	        	if(text.length>0) text = text.substr(0, text.length-1);  
        		//alert("text = "+text);
        		
	        	return text;
	        }
	    }
	    
	    function getFreightElementValue2(elem, oper, value) {
			
			if (oper == "get") {	
	        		        	
	        	// TableSection => TableCell => Label => Input
	        	var valueRow = $("#forCategory :input");
	        	//alert("valueRow.length = "+valueRow.length);
        		
        		var text = "";
        		for(j=1;j<valueRow.length;j++){
        			if(valueRow.eq(j).prop("checked"))
        				text = text + valueRow.eq(j).val() + ',';
        		}        		
        		if(text.length>0) text = text.substr(0, text.length-1);  
        		//alert("text = "+text);
        		
	        	return text;
	        }
	    }
	    
		function getFreightElementValue3(elem, oper, value) {
			
			if (oper == "get") {	
	        		        	
	        	// TableSection => TableCell => Label => Input
	        	var valueRow = $("#forMethod :input");
	        	//alert("valueRow.length = "+valueRow.length);
        		
        		var text = "";
        		for(j=0;j<valueRow.length;j++){
        			
        			if(valueRow.eq(j).prop("checked"))
        				text = text + valueRow.eq(j).parent().text() + ',';
        		}        		
        		if(text.length>0) text = text.substr(0, text.length-1);  
        		//alert("text = "+text);
        		
	        	return text;
	        }
	    }
	    
		function ajaxSuccess(response){
			//console.log("alarmforward.jsp: response = " + response);
			if(response!='Success'){
				alert(response);
				grid.trigger("reloadGrid");
			}
		}
		
		function ajaxError(jqXHR, textStatus, errorThrown){
			showmsg(jqXHR.status+" "+jqXHR.statusText);
		}
		
		function ajaxComplete(XMLHttpRequest, textStatus) {
			showmsg(XMLHttpRequest.responseText);
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