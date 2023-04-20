<% int n = Integer.parseInt(request.getParameter("count")); int i;%>
<html>
<head>
<meta charset="UTF-8">
<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
out.println("addteams - "+session.getAttribute("username"));
	if(session.getAttribute("username")==null)
		response.sendRedirect("login.jsp");
%>
<title>Tournament Manager</title>
<script>
function addTeams(){
	teamList = document.getElementById("teams").querySelectorAll("#team");
	teamListVal = [];
	for(let i=0; i<<%=n%>; i++)
	{
		if(teamList[i].value=="")
		{
			alert("Team "+(i+1)+" name is empty!");
			return;
		}
		else
			teamListVal.push(teamList[i].value);
	}
	teamString=teamListVal.join(",");
	xmlReq = new XMLHttpRequest();
	xmlReq.onreadystatechange = function()
	{
		if(xmlReq.readyState==4 && xmlReq.status==200)
		{
			alert("Tournament added!")
			window.location.href = "main.html";
		}
	}
	xmlReq.open("POST", "http://localhost:8080/crickettourmanager/ManagerServlet");
	xmlReq.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlReq.send("action=addteams&teamlist="+teamString);
}
</script>
<link rel="stylesheet" href="body.css"></link>
<style>
	table {
		top: 70px;
		position: relative;
		margin: auto;
		align-items: center;
		justify-content: center;
		width: 40%;
		border: 2px solid #404040;
		border-radius: 15px;
		font-size: 22px;
		background-color: rgba(255, 255, 255, .4);
	}
	tr {
		height: 30px;
	}
	#inputbox {
		width: 70%;
	}
	input[type=text]{
		border: 1px solid #404040;
		border-radius: 15px;
		font-family: "Calibri";
		font-size: 20px;
		width: 85%;
		padding: 7px 10px;
	}
	#enter {
		border: 1px solid #404040;
		border-radius: 15px;
		width: 100%;
		background-color: #fff;
		padding: 10px 10px;
	}
</style>
</head>
<body>
<table id="teams">
<% for(i=0; i<n; i++){ %>
<tr>
<td style="text-align:right;">Team <%out.print(i+1);%>:</td>
<!----------------------
		<td id="inputbox"><input type="text" id="<%="team"+i%>"></td>
---------------------- -->
<td id="inputbox"><input type="text" id="team"></td>
<tr>
<%}%>
<tr>
<td colspan=2><button id="enter" onclick="addTeams()" style="margin: 0;left:50%;">Add</button></td>
</tr>
</table>
</body>
</html>