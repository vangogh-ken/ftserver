 
<%@page contentType="text/html" pageEncoding="UTF-8" session="false" %>

<%
    final String queryString = request.getQueryString();
    String name = java.net.URLDecoder.decode(queryString, "UTF-8");
    name = name.trim();
    name = name.substring(2);
    name = name.trim();
%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
    <head>        
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <meta name="description" content="<%=name%> what is? iBoxDB NoSQL Document Database Full Text Search FTS">
        <title><%=name%>, what is? iBoxDB NoSQL Document Database Full Text Search</title>

        <link rel="stylesheet" type="text/css" href="css/semantic.min.css"> 

        <style>
            body {
                margin-top: 10px;
                margin-left: 10px;
                font-weight:lighter;
                overflow-x: hidden;
            }
            .stext{

            }
            .rt{
                color: red;
            }
            .gt{
                color: green;
            }
        </style> 
        <script>
            function highlight(loadedDivId) {

                var txt = document.title.substr(0, document.title.indexOf(','));

                var div = document.getElementById(loadedDivId);
                var ts = div.getElementsByClassName("stext");

                var kws = txt.split(/[ 　]/);
                for (var i = 0; i < kws.length; i++) {
                    var kw = String(kws[i]).trim();
                    if (kw.length < 1) {
                        continue;
                    }
                    var fontText = "<font class='rt'>";
                    if (fontText.indexOf(kw.toLowerCase()) > -1) {
                        continue;
                    }
                    if ("</font>".indexOf(kw.toLowerCase()) > -1) {
                        continue;
                    }
                    for (var j = 0; j < ts.length; j++) {
                        var html = ts[j].innerHTML;
                        ts[j].innerHTML =
                                html.replace(new RegExp(kw, 'gi'),
                                        fontText + kw + "</font>");
                    }
                }
            }
        </script>
        <script>
            var div_load = null;
            document.addEventListener("scroll", function () {
                scroll_event();
            });
            function onscroll_loaddiv(divid, startId) {
                div_load = document.getElementById(divid);
                div_load.startId = startId;
                scroll_event();
            }
            function scroll_event() {
                if (div_load !== null) {
                    var top = div_load.getBoundingClientRect().top;
                    var se = document.documentElement.clientHeight;
                    if (top <= se) {
                        var startId = div_load.startId;
                        div_load = null;
                        var xhr = new XMLHttpRequest();
                        xhr.onreadystatechange = function () {
                            if (xhr.readyState == XMLHttpRequest.DONE) {
                                var html = xhr.responseText;

                                var frag = document.createElement("div");
                                frag.innerHTML = html;
                                var maindiv = document.getElementById('maindiv');
                                maindiv.appendChild(frag);

                                var ss = frag.getElementsByTagName("script");
                                for (var i = 0; i < ss.length; i++) {
                                    eval(ss[i].innerHTML);
                                }
                            }
                        }
                        var url = "spart.jsp?<%= queryString%>" + "&s=" + startId;
                        xhr.open('GET', url, true);
                        xhr.send(null);
                    }
                }
            }
        </script>
    </head>
    <body > 
        <div class="ui left aligned grid">
            <div class="column"  style="max-width: 600px;"> 
                <form class="ui large form"  action="s" onsubmit="formsubmit()">
                    <div class="ui label input">

                        <div class="ui action input">
                            <a href="./"><i class="teal disk outline icon" style="font-size:42px"></i> </a>
                            <input name="q"  value="<%=name%>" required onfocus="formfocus()" />
                            <input id="btnsearch" type="submit"  class="ui teal right button" value="Search" /> 
                        </div>
                    </div>
                </form> 
                <script>
                    function formsubmit() {
                        btnsearch.disabled = "disabled";
                    }
                    function formfocus() {
                        btnsearch.disabled = undefined;
                    }
                </script>
            </div>
        </div>

        <div class="ui grid">
            <div class="ten wide column" style="max-width: 600px;" id="maindiv">
                <jsp:include page="spart.jsp?<%= queryString%>" ></jsp:include>

            </div>
            <div class="six wide column" style="max-width: 200px;">

                <div class="ui segment">
                    <h4><a href="http://www.iboxdb.com" target="_blank">iBoxDB</a></h4> 
                    Fast NoSQL Document Database
                </div>

                <div class="ui segment">
                    <h4>Full Text Search</h4> 
                </div> 


            </div>
        </div>

    </body>
</html>

