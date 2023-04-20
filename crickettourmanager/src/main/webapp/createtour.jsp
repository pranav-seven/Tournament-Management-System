<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
		if(session.getAttribute("username")==null) response.sendRedirect("login.jsp"); %>
		<title>Tournament Manager</title>
		<link rel="stylesheet" href="body.css">
		<style>
			body {
				padding: 50px;
			}

			table {
				position: relative;
				margin: auto;
				width: 60%;
				border: 2px solid #404040;
				border-radius: 15px;
				font-size: 22px;
				color: #fff;
				background-color: rgba(255, 255, 255, .2);
			}

			tr {
				height: 50px;
			}

			input[type=text] {
				width: 70%;
				padding: 10px 10px;
				margin: 15px 0;
				opacity: 0.7;
				border: 1px solid #404040;
				border-radius: 10px;
				font-family: "Calibri";
				font-size: 15px;
			}

			select {
				font-size: 16px;
				font-family: "Calibri";
				background-color: rgb(255, 255, 255, 0.7);
				border: 1px solid #404040;
				border-radius: 10px;
				height: 36px;
				width: 20%;
			}

			button {
				width: 20%;
				border: 1px solid #404040;
				border-radius: 15px;
				font-family: "Calibri";
				font-size: 22px;
				padding: 10px 10px;
				margin: auto;
				cursor: pointer;
				font-size: 16px;
			}
		</style>
		<script>
			xmlReq = new XMLHttpRequest();
			function checkTour() {
				tourName = document.getElementById("tourname").value;
				if (tourName == "")
					alert("Tournament name cannot be empty");
				else {
					xmlReq.onreadystatechange = function () {
						if (xmlReq.readyState == 4 && xmlReq.status == 200) {
							exists = xmlReq.responseText;
							if (exists == '1')
								alert("Tournament already exists!");
							else {
								document.getElementById("tourdetails").style.display = "none";
								table = document.getElementById("teams");
								table.style.display = "table";
								for (let i = 1, n = document.getElementById("teamcount").value; i <= n; i++) {
									let row = table.insertRow(i - 1);
									cell1 = row.insertCell(0);
									cell1.innerHTML = "Team " + (i);
									cell1.style.textAlign = "right";
									cell2 = row.insertCell(1);
									cell2.innerHTML = `<input type="text" id="team">`;
								}
							}
						}
					}
					url = "http://localhost:8080/crickettourmanager/ManagerServlet";
					query = "?action=checktour&tourName=" + tourName;
					xmlReq.open("GET", url + query);
					xmlReq.send();
				}
			}
			function addTour() {
				teamList = document.getElementById("teams").querySelectorAll("#team");
				teamListVal = [];
				tourName = document.getElementById("tourname").value;
				n = document.getElementById("teamcount").value;
				for (let i = 0; i < n; i++) {
					if (teamList[i].value == "") {
						alert("Team " + (i + 1) + " name is empty!");
						return;
					}
					else
						teamListVal.push(teamList[i].value);
				}
				teamString = teamListVal.join(",");
				xmlReq.onreadystatechange = function () {
					if (xmlReq.readyState == 4 && xmlReq.status == 200) {
						alert("Tournament added!")
						window.location.href = "main.jsp";
					}
				}
				xmlReq.open("POST", "http://localhost:8080/crickettourmanager/ManagerServlet");
				xmlReq.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
				xmlReq.send("action=addtour&tourName=" + tourName + "&teamlist=" + teamString);
			}
			function cancel() {
				document.getElementById("tourdetails").style.display = "table";
				table = document.getElementById("teams");
				for (let i = 0, n = document.getElementById("teamcount").value; i < n; i++)
					table.deleteRow(0);
				table.style.display = "none";
			}
		</script>
</head>

<body>
	<p style="text-align: right; color: white;">
		<%out.println(session.getAttribute("username")); %>
	</p>
	<table id="tourdetails">
		<tr>
			<td style="text-align:right;">Tournament name:</td>
			<td><input type="text" id="tourname"></td>
		<tr>
			<td style="text-align:right;">Number of teams:</td>
			<td>
				<select id="teamcount">
					<option value="2">2</option>
					<option value="4">4</option>
					<option value="8">8</option>
					<option value="16">16</option>
					<option value="32">32</option>
				</select>
			</td>
		</tr>
		<tr style="text-align: center;">
			<td colspan=2>
				<button type="button" id="enter" style="background-color: #ddffdd;" onclick="checkTour()">Enter</button>
				<button type="button" style="background-color: #ffdddd;" onclick="history.back()">Cancel</button>
			</td>
		</tr>
	</table>
	<!-- ----------
add teams table
----------- -->
	<table id="teams" style="display: none;">
		<tr style="text-align: center;">
			<td colspan="2">
				<button type="button" id="add" style="background-color: #ddffdd;" onclick="addTour()">Add</button>
				<button type="button" id="cancel" style="background-color: #ffdddd;" onclick="cancel()">Cancel</button>
			</td>
		</tr>
	</table>
</body>

</html>