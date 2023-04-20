<html>

<head>
    <meta charset="UTF-8">
    <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
        if(session.getAttribute("username")==null)
        	response.sendRedirect("login.jsp"); %>
        <title>Tournament Manager</title>
        <link rel="stylesheet" href="body.css">
        <style>
            body {
                padding: 50px;
            }

            #tourListTable {
                width: 70%;
                position: relative;
                margin: auto;
                text-align: left;
                border: 2px solid #404040;
                border-radius: 15px;
                font-size: 22px;
                background-color: rgba(255, 255, 255, .7);
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

            #edit {
                cursor: pointer;
            }
        </style>

</head>

<body style="padding: 50px;" onload="getList()">
    <p style="text-align: right; color: white;">
        <%out.println(session.getAttribute("username")); %>
    </p>
    <table id="tourListTable">
        <tr>
            <th style="width: 15%;">No.</th>
            <th style="width: 70%;">Name</th>
            <th style="width: 15%;">Edit</th>
        </tr>
    </table>
    <table id="tourBracket" style="display: none; text-align: center;">
        <tr>
            <td colspan="3">
                <button type="button" id="save" style="background-color: #ddffdd;"
                    onclick="alert('well...')">Save</button>
                <button type="button" id="cancel" style="background-color: #ffdddd;" onclick="cancel()">Cancel</button>
            </td>
        </tr>
    </table>
</body>
<script>
    var tourList;
    xmlReq = new XMLHttpRequest();
    function getList() {
        xmlReq.onreadystatechange = function () {
            if (xmlReq.readyState == 4 && xmlReq.status == 200) {
                tourList = JSON.parse(xmlReq.responseText);
                if (tourList.length == 0) {
                    let row = table.insertRow(1);
                    row.style.textalign = "center";
                    let cell = row.insertCell(0);
                    cell.setAttribute("colspan", "3");
                    cell.innerHTML = "No tournaments available";
                }
                else
                    for (let i = 0; i < tourList.length; i++) {
                        let row = table.insertRow(i + 1);
                        cell1 = row.insertCell(0);
                        cell1.innerHTML = i + 1;
                        cell2 = row.insertCell(1);
                        cell2.id = "tour" + i;
                        cell2.innerHTML = tourList[i];
                        cell3 = row.insertCell(2);
                        cell3.innerHTML = `<img id="edit" src="6324968.png" height=50 onclick="openEditor(` + i + `)"></img>`;
                    }
            }
        }
        xmlReq.open("GET", "http://localhost:8080/crickettourmanager/ManagerServlet?action=viewall");
        xmlReq.send();
        table = document.getElementById("tourListTable");
    }
    function openEditor(i) {
        var name = document.getElementById("tour" + i).innerHTML;
        xmlReq.onreadystatechange = function () {
            if (xmlReq.readyState == 4 && xmlReq.status == 200) {
                tourJson = JSON.parse(xmlReq.responseText);
                showBracket(tourJson);
            }
        }
        xmlReq.open("GET", "http://localhost:8080/crickettourmanager/ManagerServlet?action=edittour&tourname=" + name);
        xmlReq.send();
        //   	window.location.href = "edittour.jsp?tourName="+name+"&tourId="+i;
    }
    rowIndex = 0;
    function showBracket(tourJson) {
    	let changed = false;
        document.getElementById("tourListTable").style.display = "none";
        bracket = document.getElementById("tourBracket");
        bracket.style.display = "table";
        for (let roundNo = 0; roundNo < tourJson.length; roundNo++) {
            let roundObject = tourJson[roundNo];
            let roundRow = bracket.insertRow(rowIndex++);
            let roundName = Object.keys(roundObject)[0];
            let cell = roundRow.insertCell(0);
            cell.colSpan = "3";
            cell.innerHTML = `<b>`+roundName+`</b>`;
            matches = roundObject[roundName];
            for (let matchNo = 0; matchNo < matches.length; matchNo++) {
                let matchRow = bracket.insertRow(rowIndex++);
                home = matchRow.insertCell(0);
                home.style.textAlign = "right";
                home.style.width = "45%";
                home.innerHTML = (matches[matchNo]["Home"] != null ? matches[matchNo]["Home"] : "TBD") + `<br>` +
                    (matches[matchNo]["Home-score"] == -1 ? "---" : matches[matchNo]["Home-score"]);
                vs = matchRow.insertCell(1);
                vs.innerHTML = "vs";
             //   vs.onClick = "editMatch(this)";
            //    vs.onclick = "alert('this')";
                away = matchRow.insertCell(2);
                away.style.textAlign = "left";
                away.style.width = "45%";
                away.innerHTML = (matches[matchNo]["Away"] != null ? matches[matchNo]["Away"] : "TBD") + `<br>` +
                    (matches[matchNo]["Away-score"] == -1 ? "---" : matches[matchNo]["Away-score"]);
                if (matches[matchNo]["Home"] != null && matches[matchNo]["Away"] != null &&
                    	matches[matchNo]["Home-score"] == -1) {
                    vs.innerHTML += `<br><img id="edit" src="6324968.png" height=30 onclick="editMatch(this)"></img>`;
                }
            }
        }
    }
    function cancel() {
        document.getElementById("tourListTable").style.display = "table";
        table = document.getElementById("tourBracket");
        for (let i = 0; i < rowIndex; i++)
            table.deleteRow(0);
        rowIndex = 0;
        table.style.display = "none";
    }
    function editMatch(obj)
    {
    	alert(obj.closest('tr').rowIndex);
    }
</script>

</html>