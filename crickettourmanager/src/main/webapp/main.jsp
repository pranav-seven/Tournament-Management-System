<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
		if(session.getAttribute("username")==null)
			response.sendRedirect("login.jsp"); %>
	<title>Tournament Manager</title>
	<link rel="stylesheet" href="body.css">
	<style>
		table {
			top: 100px;
			position: relative;
			margin: auto;
			width: 30%;
			border: 2px solid #404040;
			border-radius: 15px;
			font-size: 22px;
			color: #fff;
			background-color: rgba(255, 255, 255, .2);
		}

		tr {
			height: 50px;
		}

		td {
			text-align: center;
			color: #fff;
		}

		a {
			text-decoration: none;
			color: #fff;
			cursor: pointer;
		}
	</style>
	<script>
		function logout() {
			xmlReq = new XMLHttpRequest();
			xmlReq.onreadystatechange = function () {
				if (xmlReq.readyState == 4 && xmlReq.status == 200) {
					window.location.href = xmlReq.responseText;
				}
			}
			xmlReq.open("GET", "http://localhost:8080/crickettourmanager/LoginServlet?action=logout");
			xmlReq.send();
		}
	</script>
</head>

<body>
	<p style="text-align: right; color: white;">
		<%out.println(session.getAttribute("username")); %>
	</p>
	<table>
		<tr>
			<td><a href="createtour.jsp">Create Tournament</a></td>
		</tr>
		<tr>
			<td><a href="viewall-copy.jsp">View Tournaments</a></td>
		</tr>
		<!-- <tr>
			<td><a href="delete.html">Delete tournament</a></td>
		</tr> -->
		<tr>
			<td>
				<div onclick="logout()" style="cursor: pointer">Log out</div>
			</td>
		</tr>
	</table>
</body>

</html>