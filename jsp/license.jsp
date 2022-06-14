<!DOCTYPE html>
<%@page import="b.b.b"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script>
	function copyKey() {
		var a = document.getElementById('copyInput');
		var range = document.createRange();
		window.getSelection().removeAllRanges();
		range.selectNode(a);
		window.getSelection().addRange(range);
		document.execCommand('copy');
		window.getSelection().removeAllRanges();
	}
</script>
</head>
<body>
	<div style="text-align: center;">
		<img src='/img/logo_en_small.gif'> <br>
		<table style="margin: auto;">
			<tr>
				<td align="right"><font color="#FF0000">Hardware ID： </font></td>
				<td id="copyInput"><font color="#FF0000"><%=b.hwID%></font>
					<input type="button" name="copy" value="copy to clipboard" onclick="copyKey();" />
				</td>
			</tr>

		</table>
		<br>
		<!--
		<form method="post" name="uploadForm" enctype="multipart/form-data">

			<input type="file" name="File1" accept=".lic"
				onchange="form.submit();" />
		</form>
		-->
		<form id="licenseForm" name="licenseForm" enctype="multipart/form-data" method="post" action="systemUpgradeAction.jsp"><input id="license" name="license" type="file"/><input style='width:52px;' type='button' value='Apply' onclick="javascript:if(confirm('Upload License. Continue?')){if(license.value.endsWith('lic')){document.licenseForm.submit();}}" /></form>
		<br />
		<table style="margin: auto;">
			<tr>
				<td colspan="2" align="right"><font color="#FF0000">To apply for a certificate, please copy the Hardware ID and contact the manufacturer</font>
				</td>
			</tr>
		</table>
		<table  style="margin: auto;">
			<tr>
				<td align="right"><font color="#FF0000">Tel : </font></td>
				<td><font color="#FF0000">+886-7-398-1000</font></td>
			</tr>
			<tr>
				<td align="right"><font color="#FF0000">EMail : </font></td>
				<td><font color="#FF0000">allen.lin@ascentac.com</font></td>
			</tr>
		</table>
	</div>
</body>
</html>
