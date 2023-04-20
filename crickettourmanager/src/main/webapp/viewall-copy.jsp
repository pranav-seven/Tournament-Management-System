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
                width: 70%;
                position: relative;
                padding: 0px 5px;
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
                padding: 10px 10px;
                margin: auto;
                cursor: pointer;
                font-size: 16px;
            }

            #edit {
                cursor: pointer;
            }

            #savescore,
            #cancelscore {
                font-size: 14px;
                border-radius: 7px;
                padding: 4px 4px;
            }

            #homescore,
            #awayscore {
                width: 20%;
                border: 2px solid #404040;
                border-radius: 10px;
                font-size: 16px;
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
                <button type="button" id="save" style="background-color: #ddffdd;" onclick="saveTour()">Save</button>
                <button type="button" id="cancel" style="background-color: #ffdddd;" onclick="cancel()">Cancel</button>
            </td>
        </tr>
    </table>
</body>
<script>
    var tourList;
    var tourJson;
    var table = document.getElementById("tourListTable");
    var bracket = document.getElementById("tourBracket");
    var jsonupdate = false;
    var name; //tour name
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
    }
    function openEditor(i) {
        name = document.getElementById("tour" + i).innerHTML;
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
        table.style.display = "none";
        bracket.style.display = "table";
        for (let roundNo = 0; roundNo < tourJson.length; roundNo++) {
            let roundObject = tourJson[roundNo];
            let roundRow = bracket.insertRow(rowIndex++);
            let roundName = Object.keys(roundObject)[0];
            let cell = roundRow.insertCell(0);
            cell.colSpan = "3";
            cell.innerHTML = `<b>` + roundName + `</b>`;
            matches = roundObject[roundName];
            for (let matchNo = 0; matchNo < matches.length; matchNo++) {
                let matchRow = bracket.insertRow(rowIndex++);
                matchRow.id = roundNo + "_" + roundName + "_" + matchNo;
                home = matchRow.insertCell(0);
                home.style.textAlign = "right";
                home.style.width = "45%";
                home.innerHTML = (matches[matchNo]["Home"] != null ? matches[matchNo]["Home"] : "TBD") + `<br>` +
                    (matches[matchNo]["Home-score"] == -1 ? "---" : matches[matchNo]["Home-score"]);
                vs = matchRow.insertCell(1);
                vs.innerHTML = "vs";
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
        bracket.style.display = "none";
        for (let i = 0; i < rowIndex; i++)
            bracket.deleteRow(0);
        rowIndex = 0;
        table.style.display = "table";
        tourJson = null;
        jsonupdate = false;
    }
    function editMatch(obj) {
        rowInd = obj.closest('tr').rowIndex;
        home = bracket.rows[rowInd].cells[0].innerHTML.split(`<br>`)[0];
        away = bracket.rows[rowInd].cells[2].innerHTML.split(`<br>`)[0];
        bracket.rows[rowInd].cells[0].innerHTML =
            home + `<br><input type="text" id="homeScore" class="score" onkeydown="return isDigit(event)"><br>
            <button type="button" id="savescore" style="background-color: #ddffdd; " onclick="saveUpdate(home, away, bracket.rows[rowInd].id)">Save</button>`;
        bracket.rows[rowInd].cells[2].innerHTML =
            away + `<br><input type="text" id="awayScore" class="score" onkeydown="return isDigit(event)"><br>
            <button type="button" id="cancelscore" style="background-color: #ffdddd;" onclick="cancelUpdate(home, away, rowInd)">Cancel</button>`;
    }
    function cancelUpdate(home, away, rowInd) {
        bracket.rows[rowInd].cells[0].innerHTML = home + `<br>---`;
        bracket.rows[rowInd].cells[2].innerHTML = away + `<br>---`;
    }
    function saveUpdate(home, away, id) {
        jsonupdate = true;
        homeScore = document.getElementById("homeScore").value;
        awayScore = document.getElementById("awayScore").value;
        if (homeScore == "" || awayScore == "") {
            alert("Score fields cannot be empty!");
            return;
        }
        bracket.rows[rowInd].cells[0].innerHTML = home + `<br>` + homeScore;
        bracket.rows[rowInd].cells[2].innerHTML = away + `<br>` + awayScore;
        bracket.rows[rowInd].cells[1].innerHTML = "vs";
        id = id.split('_');
        winner = homeScore >= awayScore ? home : away;
        /*******************
        ********************
        ********************
        ********************/
 /*       if(winner==null)
        {
        	winner = function(){
        		alert("Enter tiebreaker scores!");
        		document.getElementById("homeScore").value = "";
        		document.getElementById("awayScore").value = "";
        		return 0;
        	}
        } */
        roundNo = id[0];
        roundName = id[1];
        matchNo = id[2];
        tourJson[roundNo][roundName][matchNo]['Home-score'] = homeScore;
        tourJson[roundNo][roundName][matchNo]['Away-score'] = awayScore;
        tourJson[roundNo][roundName][matchNo]['Winner'] = winner;
        if (roundName != 'Final') {
            roundNo++;
            roundName = Object.keys(tourJson[roundNo])[0];
            venue = matchNo % 2 == 0 ? 'Home' : 'Away';
            matchNo = matchNo >> 1;
            tourJson[roundNo][roundName][matchNo][venue] = winner;
            nextMatch = document.getElementById(roundNo + "_" + roundName + "_" + matchNo);
            cellNo = venue == 'Home' ? 0 : 2;
            nextMatch.cells[cellNo].innerHTML = winner + `<br>---`;
            if (nextMatch.cells[2 - cellNo].innerHTML != 'TBD<br>---') {
                nextMatch.cells[1].innerHTML = 'vs' + `<br><img id="edit" src="6324968.png" height=30 onclick="editMatch(this)"></img>`;
            }
        }
    }
    function isDigit(event) {
        event = (event) ? event : window.event;
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;
        return true;
    }
    function tiebreak() {

    }
    function saveTour() {
        if (jsonupdate) {
            xmlReq.onreadystatechange = function () {
                if (xmlReq.readyState == 4 && xmlReq.status == 200);
            }
            xmlReq.open("POST", "http://localhost:8080/crickettourmanager/ManagerServlet");
            xmlReq.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlReq.send("action=savetour&tourName=" + name + "&json=" + JSON.stringify(tourJson));
        }
        cancel();
    }
</script>

</html>