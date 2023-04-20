<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
		if(session.getAttribute("username")!=null) response.sendRedirect("main.jsp"); %>
	<title>Tournament Manager</title>
	<link rel="stylesheet" href="body.css">
	<style>
		input[type=text],
		input[type=email],
		input[type=password] {
			width: 90%;
			padding: 10px 10px;
			margin: 15px 0;
			opacity: 0.7;
			border: 1px solid #404040;
			border-radius: 10px;
			font-family: "Calibri";
			font-size: 16px;
		}

		table {
			position: relative;
			margin: auto;
			width: 30%;
			padding: 10px 10px;
			border: 2px solid #404040;
			border-radius: 15px;
			font-size: 22px;
			background-color: rgba(255, 255, 255, .6);
		}

		tr {
			height: 50px;
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
		input[type=submit] {
			width: 50%;
			border: 1px solid #404040;
			border-radius: 15px;
			padding: 10px 10px;
			margin: auto;
			cursor: pointer;
		}

		#error {
			position: relative;
			font-size: 20px;
			padding: 8px 5px;
			display: flex;
			align-items: center;
			justify-content: center;
			margin: auto;
		}
	</style>
	<script>
		function clearText() {
			document.getElementById("error").innerHTML = "";
		}
		function login() {
			let username = document.getElementById("username").value.trim();
			let password = document.getElementById("password").value;
			if (username == "") changeText("Username cannot be empty!");
			else if (password == "") changeText("Password cannot be empty!");
			else {
				xmlReq = new XMLHttpRequest();
				xmlReq.onreadystatechange = function () {
					if (xmlReq.readyState == 4 && xmlReq.status == 200) {
						loginVal = xmlReq.responseText;
						if (loginVal == 'a')
							window.location.href = "main.jsp";
						else
							changeText("Username/password invalid");
					}
				}
				xmlReq.open("POST", "http://localhost:8080/crickettourmanager/LoginServlet");
				xmlReq.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
				xmlReq.send("username=" + username + "&password=" + password);
			}
		}
		function changeText(text) {
			let div = document.getElementById("error");
			let obj = document.getElementById("login");
			div.style.top = obj.offsetTop + "px";
			div.style.border = "1px solid #ff8080";
			div.style.width = "25%";
			div.style.borderRadius = "5px";
			div.style.backgroundColor = "#ffd0d0";
			div.innerHTML = text;
		}
	</script>
</head>

<body style="padding: 100px;">
	<p style="text-align: right; color: white;">
	<a href="signup.jsp">Sign up</a>
	</p>
	<!-- form action="login" method="post">
	Username: <input type="text" name="username" onclick="clearText()">
	Password: <input type="password" name="password onclick="clearText()">
	<input type="submit" name="Login">
</form-->
	<table id="emailid" style="top: 50px;">
		<tr>
		<td>Enter emailid:</td>
		</tr>
		<tr>
			<td><input type="email" id="emailid" required></td>
		</tr>
		<tr>
		<td style="text-align:center;">
				<button type="button" id="proceed" onclick="alert('clicked')">Proceed</button>
				<button type="button" onclick="window.location.href='login.jsp'">Cancel</button>
			</td>
		</tr>
	</table>
	<table id="signup">
		<tr>
			<td>Username:*<br><input type="text" id="username" required></td>
		</tr>
		<tr>
			<td>Password:<br><input type="password" id="password"><br>
		<ul style="font-size: 15px;">
		<li>Password must contain atleast 8 characters</li>
		<li>Password must have atleast one uppercase letter, one lowercase letter and one digit</li>
		</ul>
		</td>
		<tr>
			<td>Re-enter password:<br>
			<input type="password" id="password"></td>
		</tr>
		<tr style="height:100px;">
			<td style="text-align: center;"><input type="submit" onclick="signup()"></td>
		</tr>
		<tr>
		<td style="text-align: center; font-size: 18px;">Already have an account? <a href="login.jsp">Log in</a></td>
	</table>
	<div id="error"></div>
</body>

</html>