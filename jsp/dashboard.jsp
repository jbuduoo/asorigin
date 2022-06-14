<%@page import="com.fasterxml.jackson.databind.JsonNode"%>
<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
<%@page import="system.common.I18N"%>
<%@page import="com.fasterxml.jackson.databind.node.ObjectNode"%>
<%@page import="com.fasterxml.jackson.databind.node.ArrayNode"%>
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
	
<script type="text/javascript" src="../../style/loader.js"></script>
	
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
				if(obj.get("text").asText().equals("menu.dashboard")){
					value = userBean.roleInt[i];
				}
			}
			if(value>0){

				if(userBean.lang.equals("cht")){
					out.println("<script src=\"style/jqGrid/js/i18n/grid.locale-tw.js\" type=\"text/javascript\"></script>");
				}else if(userBean.lang.equals("chs")){
					out.println("<script src=\"style/jqGrid/js/i18n/grid.locale-cn.js\" type=\"text/javascript\"></script>");
				}else{
					out.println("<script src=\"style/jqGrid/js/i18n/grid.locale-en.js\" type=\"text/javascript\"></script>");
				}
			}else{
				String redirect = "/login.jsp";
				for(int i=0;i<userBean.roleInt.length;i++){
					if((userBean.roleInt[i]&8)==8) {
						if(b.menu.get(i)!=null){
							JsonNode href = b.menu.get(i).get("href");
							if(href!=null){
								redirect = href.asText();
							}else{
								ArrayNode arrayNode = (ArrayNode)b.menu.get(i).get("nodes");
								if(arrayNode!=null){
									href = arrayNode.get(0).get("href");
									if(href!=null){
										redirect = href.asText();
									}
								}
							}
						}
						break;
					}
				}
				response.sendRedirect(redirect);
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
	var isLoadComplete = false;
	$(document).ready(function() {
		init();
		errorGrid('#errorGrid', '../../dashBoardData.jsp?type=1', 'Error',
				$(window).width() - 620);
		cacheGrid('#cacheGrid', '../../dashBoardData.jsp?type=2',
				'Cache Status', $(window).width() - 620);
		systemGrid('#systemGrid', '../../dashBoardData.jsp?type=3',
				'System Status', 310);
		networkGrid('#networkGrid', '../../dashBoardData.jsp?type=4',
				'Networkk Status', 310);
		google.charts.load('current', {
			'packages' : [ 'corechart','gauge' ]
		});
		google.charts.setOnLoadCallback(drawChart);
		google.charts.setOnLoadCallback(drawChart2);
	});
	
	function myrefresh() {
		jQuery('#errorGrid').trigger("reloadGrid");
		jQuery('#systemGrid').trigger("reloadGrid");
		jQuery('#cacheGrid').trigger("reloadGrid");
		jQuery('#networkGrid').trigger("reloadGrid");
		drawChart();
		drawChart2();
	}
	intervalID = window.setInterval(myrefresh,60000);
	
	function errorGrid(jqGridDiv, urlValue, captionValue, gridWidth) {
		var grid = jQuery(jqGridDiv);
		$(jqGridDiv).jqGrid({
			url : urlValue,
			// we set the changes to be made at client side using predefined word clientArray
			//editurl : urlValue,
			datatype : "json",
			mtype : 'POST',
			colModel : [ {
				label : 'Time',
				name : 'time',
				width : 60,
				key : true
			},{
				label : 'Error Code',
				name : 'code',
				width : 30
			}, {
				label : 'Client IP',
				name : 'client',
				width : 50
			}, {
				label : 'UserAgent',
				name : 'userAgent',
				width : 50
			}, {
				label : 'Referer',
				name : 'referer',
				width : 50
			}, {
				label : 'Url',
				name : 'url'
			} ],
			viewrecords : true,
			height : '100%',
			width : gridWidth,
			//top : 100,
			//rowNum : NumOfRow,
			//loadonce : true,
			//sortname : 'time',
			//sortorder : 'desc',
			//gridview: true, 
			//autoencode: true,
			//rowList: [5, 10, 20, 50],
			cmTemplate: {sortable:false},
			caption : captionValue
		});
	}
	
	function cacheGrid(jqGridDiv, urlValue, captionValue, gridWidth) {
		var grid = jQuery(jqGridDiv);
		$(jqGridDiv).jqGrid({
			url : urlValue,
			// we set the changes to be made at client side using predefined word clientArray
			//editurl : urlValue,
			datatype : "json",
			mtype : 'POST',
			colModel : [{
				label : 'Access',
				name : 'access'
			}, {
				label : '1xx',
				name : 'http1xx'
			}, {
				label : '2xx',
				name : 'http2xx'
			}, {
				label : '3xx',
				name : 'http3xx'
			}, {
				label : '4xx',
				name : 'http4xx'
			}, {
				label : '5xx',
				name : 'http5xx'
			}, {
				label : 'Send Bytes',
				name : 'send'
			}, {
				label : 'Recv Bytes',
				name : 'recv'
			}, {
				label : 'CCU',
				name : 'ccu'
			}],
			viewrecords : true,
			height : '100%',
			width : gridWidth,
			//top : 100,
			rowNum : 100,
			//loadonce : true,
			//sortname : 'time',
			//sortorder : 'desc',
			//gridview: true, 
			//autoencode: true,
			//rowList: [5, 10, 20, 50],
			cmTemplate: {sortable:false},
			caption : captionValue
		});
	}
	function systemGrid(jqGridDiv, urlValue, captionValue, gridWidth) {
		var grid = jQuery(jqGridDiv);
		$(jqGridDiv).jqGrid({
			url : urlValue,
			// we set the changes to be made at client side using predefined word clientArray
			//editurl : urlValue,
			datatype : "json",
			mtype : 'POST',
			colModel : [ {
				label : '',
				name : 'name',
				width : 70,
				key : true
			},{
				label : 'Total',
				name : 'total',
				width : 70
			}, {
				label : 'Usage',
				name : 'usage',
				width : 50
			}, {
				label : 'Capacity',
				name : 'capacity',
				width : 50
			}],
			viewrecords : true,
			height : '100%',
			width : gridWidth,
			//top : 100,
			//rowNum : NumOfRow,
			//loadonce : true,
			//sortname : 'time',
			//sortorder : 'desc',
			//gridview: true, 
			//autoencode: true,
			//rowList: [5, 10, 20, 50],
			cmTemplate: {sortable:false},
			caption : captionValue
		});
	}
	function networkGrid(jqGridDiv, urlValue, captionValue, gridWidth) {
		var grid = jQuery(jqGridDiv);
		$(jqGridDiv).jqGrid({
			url : urlValue,
			// we set the changes to be made at client side using predefined word clientArray
			//editurl : urlValue,
			datatype : "json",
			mtype : 'POST',
			colModel : [ {
				label : '',
				name : 'name',
				width : 70,
				key : true
			},{
				label : 'In',
				name : 'in',
				width : 70
			}, {
				label : 'Out',
				name : 'out',
				width : 50
			}],
			viewrecords : true,
			height : '100%',
			width : gridWidth,
			//top : 100,
			//rowNum : NumOfRow,
			//loadonce : true,
			//sortname : 'time',
			//sortorder : 'desc',
			//gridview: true, 
			//autoencode: true,
			//rowList: [5, 10, 20, 50],
			cmTemplate: {sortable:false},
			caption : captionValue
		});
	}
	
	
	
	function drawChart() {
		$.ajax({
		    type: "GET",
		    url: "/sysData.jsp?item=output",
		    dataType: "json",
		    success: function (response) {
		    	//console.log(response);
		    	var data = google.visualization.arrayToDataTable(response);
		    	var chart = new google.visualization.AreaChart(document
						.getElementById('statusdiv'));
				chart.draw(data, {isStacked: 'false',height : 300,
					legend: {position: 'none'},
			          //title: 'Company Performance',
			          //hAxis: {title: 'Year',  titleTextStyle: {color: '#333'}},
			          vAxis: {minValue: 0 ,format:'#,###.##M'},
			          chartArea: {backgroundColor: {
			              stroke: '#000000',
			              strokeWidth: 1
			          },right: 20,width: '90%', height: '80%'},
			          hAxis: {
			              format: 'MM/dd HH:mm'
			            },
			          series: {0:{color: 'green', visibleInLegend: false},1:{color: 'blue', visibleInLegend: false}}
			    });
		 },
		    error: function (thrownError) {
		      alert("drawChart error");
		    }
		  });
	}
	
	function drawChart2() {
		$.ajax({
		    type: "GET",
		    url: "/dashboardDataSource.jsp?type=connection",
		    dataType: "json",
		    success: function (response) {
		    	var options = {
				          redFrom: 2000,
				          redTo: 2500,
				          min: 0,
				          max: 2500,
				          width: 300,
				          height: 300,
				          majorTicks: ["0","500","1000", "1500", "2000", "2500"],
				          minorTicks: 5
				        };
		    	//console.log(response);
				//var ay = JSON.parse(response);
				//console.log(response);
				var data = google.visualization.arrayToDataTable(response);
				var chart = new google.visualization.Gauge(document.getElementById('connectiondiv'));
				chart.draw(data, options);
		    },
		    error: function (thrownError) {
		      alert("drawChart2 error");
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
					<table>
	<tr>
	<td>
	<div id="statusdiv" style="margin-right: 0px;padding-right: 0px"></div>
	</td>
	<td>
	<div id="connectiondiv" ></div>
	</td>
	</tr>
		<tr>
			<td valign="top">
				<div align="center" style="margin-top: 10px">
					<table id="errorGrid"></table>
				</div>
			</td>
			<td valign="top"><div align="center" style="margin-top: 10px">
					<table id="systemGrid"></table>
				</div></td>
		</tr>
		<tr>
			<td valign="top">
				<div align="center" style="margin-top: 10px">
					<table id="cacheGrid"></table>
				</div>
			</td>
			<td valign="top"><div align="center" style="margin-top: 10px">
					<table id="networkGrid"></table>
				</div></td>
		</tr>
	</table>
				</div>
			</div>
		</div>
	</div>
	<div id="dialog_div"></div>
</body>

</html>
