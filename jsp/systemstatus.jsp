<%@page import="b.b.b"%>
<%@page import="system.db.bean.UserBean"%>
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
	
	<%
		UserBean userBean = (UserBean) session.getAttribute("userBean");
		int value = 0;
		if(userBean!=null){
			for(int i=0;i<b.menu.size();i++){
				ObjectNode obj = (ObjectNode)b.menu.get(i);
				if(obj.get("text").asText().equals("menu.System")){
					value = userBean.roleInt[i];
				}
			}
			if(value>0){
			}else{
				response.sendRedirect("/login.jsp");
			}
		}else{
			response.sendRedirect("/login.jsp");
		}
	%>
	
<script src="style/my.js" type="text/javascript"></script>
<link href="style/my.css" rel="stylesheet">
</head>

<body id="page-top">
	<script>
	var ismouseover = false;
	var myCanvas;
	var myCanvas2;
	var myCanvas3;
	var myCanvas4;
	var myCanvas5;
		$(document).ready(function() {
			init();
			<%
			String msg = (String)request.getAttribute("msg");
			if((msg!=null)&&(!msg.equals(""))){
				request.removeAttribute("msg");
				out.println("showmsg('"+msg+"');");
			}
		%>
		var load= {"datasets":[]};
		var cpu= {"datasets":[]};
		var mem= {"datasets":[]};
		var disk= {"datasets":[]};
		var network= {"datasets":[]};
		chart_opt1.title.display=true;
		chart_opt1.title.text='CPU Load';
		myCanvas = new Chart('myCanvas', {
			type : 'line',
			data : load,
			options : chart_opt1
		});
		
		chart_opt1.title.text='CPU';
		chart_opt1.pan.onPan=showZoom2;
		chart_opt1.zoom.onZoom=showZoom2;
		myCanvas2 = new Chart('myCanvas2', {
			type : 'line',
			data : cpu,
			options : chart_opt1
		});
		
		chart_opt1.title.text='Memory';
		chart_opt1.pan.onPan=showZoom3;
		chart_opt1.zoom.onZoom=showZoom3;
		chart_opt1.elements.line.fill='-1';
		chart_opt1.scales.yAxes[0].stacked=true;
		myCanvas3 = new Chart('myCanvas3', {
			type : 'line',
			data : mem,
			options : chart_opt1
		});
		
		chart_opt1.title.text='Disk';
		chart_opt1.pan.onPan=showZoom4;
		chart_opt1.zoom.onZoom=showZoom4;
		myCanvas4 = new Chart('myCanvas4', {
			type : 'line',
			data : disk,
			options : chart_opt1
		});
		
		chart_opt1.title.text='Network';
		chart_opt1.pan.onPan=showZoom5;
		chart_opt1.zoom.onZoom=showZoom5;
		chart_opt1.elements.line.tension=0;
		myCanvas5 = new Chart('myCanvas5', {
			type : 'line',
			data : network,
			options : chart_opt1
		});
		
		updateload();
		updatecpu();
		updatemem();
		updatedisk();
		updatenetwork();
		window.setInterval(update, 60000);
		});
		function update() {
			updateload();
			updatecpu();
			updatemem();
			updatedisk();
			updatenetwork();
		}
		
		function updateload() {
			$.ajax({type:'get', url:'/sysData.jsp?item=load',data:{},error:ajaxError,success :function(data){
				console.log(data.code);
				myCanvas.data.datasets = data.datasets ;
				myCanvas.update();
			}});
		}
		function updatecpu() {
			$.ajax({type:'get', url:'/sysData.jsp?item=cpu',data:{},error:ajaxError,success :function(data){
				//console.log(data);
				myCanvas2.data.datasets = data.datasets ;
				myCanvas2.update();
			}});
		}
		function updatemem() {
			$.ajax({type:'get', url:'/sysData.jsp?item=mem',data:{},error:ajaxError,success :function(data){
				console.log(data);
				myCanvas3.data.datasets = data.datasets ;
				myCanvas3.update();
			}});
		}
		function updatedisk() {
			$.ajax({type:'get', url:'/sysData.jsp?item=disk',data:{},error:ajaxError,success :function(data){
				//console.log(data);
				myCanvas4.data.datasets = data.datasets ;
				myCanvas4.update();
			}});
		}
		function updatenetwork() {
			$.ajax({type:'get', url:'/sysData.jsp?item=network',data:{},error:ajaxError,success :function(data){
				//console.log(data);
				myCanvas5.data.datasets = data.datasets ;
				myCanvas5.update();
			}});
		}
		
		function ajaxError(jqXHR, textStatus, errorThrown){
			showmsg(jqXHR.status+" "+jqXHR.statusText);
		}
		
		function resetZoom2() {
			myCanvas2.resetZoom();
			$('#reset_zoom2').hide();
		}
		function showZoom2() {
			$('#reset_zoom2').show();
		}
		
		function resetZoom3() {
			myCanvas3.resetZoom();
			$('#reset_zoom3').hide();
		}
		function showZoom3() {
			$('#reset_zoom3').show();
		}
		
		function resetZoom4() {
			myCanvas4.resetZoom();
			$('#reset_zoom4').hide();
		}
		function showZoom4() {
			$('#reset_zoom4').show();
		}
		
		function resetZoom5() {
			myCanvas5.resetZoom();
			$('#reset_zoom5').hide();
		}
		function showZoom5() {
			$('#reset_zoom5').show();
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
			
			
			
			
			
			<div style="margin: 20px 80px 0px 20px">
			<canvas id="myCanvas" style="height:50vh;"></canvas>
			<button onclick="resetZoom()" id="reset_zoom" class='ui-corner-all' style="display: none;">Reset zoom</button>
			</div>
			<div style="margin: 20px 80px 0px 20px">
			<canvas id="myCanvas2" style="height:50vh;"></canvas>
			<button onclick="resetZoom2()" id="reset_zoom2" class='ui-corner-all' style="display: none;">Reset zoom</button>
			</div>
			<div style="margin: 20px 80px 0px 20px">
			<canvas id="myCanvas3" style="height:50vh;"></canvas>
			<button onclick="resetZoom3()" id="reset_zoom3" class='ui-corner-all' style="display: none;">Reset zoom</button>
			</div>
			<div style="margin: 20px 80px 0px 20px">
			<canvas id="myCanvas4" style="height:50vh;"></canvas>
			<button onclick="resetZoom4()" id="reset_zoom4" class='ui-corner-all' style="display: none;">Reset zoom</button>
			</div>
			<div style="margin: 20px 80px 0px 20px">
			<canvas id="myCanvas5" style="height:50vh;"></canvas>
			<button onclick="resetZoom5()" id="reset_zoom5" class='ui-corner-all' style="display: none;">Reset zoom</button>
			</div>
			
			
			</div>
			</div>
        </div>
    </div>

	<div id="dialog_div"></div>
</body>

</html>
