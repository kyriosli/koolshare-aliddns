<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>Aliddns</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/js/jquery.js"></script>
<script src="/state.js"></script>
<script src="/help.js"></script>
</head>
<body>
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
            <div style="background-color: #4D595D">
                <div class="formfonttitle" style="padding-top: 12px">Aliddns - 设置</div>
                <table class="FormTable">
                    <tr>
                        <th>上次运行</th>
                        <td>
                            <% dbus_get_def("aliddns_last_time", "--"); %> (<% dbus_get_def("aliddns_last_act", "--"); %>)
                        </td>
                    </tr>
                    <tr>
                        <th>app key</th>
                        <td>
                            <input type="text" id="aliddns_ak" value="<% dbus_get_def("aliddns_ak", ""); %>" class="input_ss_table">
                            <label><input type="checkbox" id="aliddns_enable"> 启用</label>
                        </td>
                    </tr>
                    <tr>
                        <th>app secret</th>
                        <td><input type="password" id="aliddns_sk" value="<% dbus_get_def("aliddns_sk", ""); %>" class="input_ss_table"></td>
                    </tr>
                    <tr>
                        <th>检查周期</th>
                        <td><input type="text" style="width: 2.5em" id="aliddns_interval" value="<% dbus_get_def("aliddns_interval", "120"); %>" class="input_ss_table">s</td>
                    </tr>
                    <tr>
                        <th>域名</th>
                        <td>
                            <input type="text" style="width: 4em" id="aliddns_name" placeholder="子域名" value="<% dbus_get_def("aliddns_name", "home"); %>" class="input_ss_table"
                            >.<input type="text"  id="aliddns_domain" placeholder="主域名" value="<% dbus_get_def("aliddns_domain", "example.com"); %>" class="input_ss_table">
                        </td>
                    </tr>
                </table>
                <div>
                    <input class="button_gen" type="button" value="提交">
                </div>
            </div>
            
        </td>
    </tr>
</table>
<div id="footer"></div>
<script>
$(function () {
    show_menu(function(title, tab) {
        tabtitle[17] = ['Aliddns'];
        tablink[17] = ['Module_aliddns.asp']
    });
    var enable = "<% dbus_get_def("aliddns_enable", "0"); %>";
    $('#aliddns_enable').prop('checked', enable === "1");
    var posting = false;
    $('.button_gen').click(function () {
        if(posting) return;
        posting = true; // save
        $.ajax({
            type: 'POST',
            url: 'applydb.cgi?p=aliddns_',
            data: $.param({
                aliddns_enable: $('#aliddns_enable').prop('checked') | 0,
                aliddns_ak: $('#aliddns_ak').val(),
                aliddns_sk: $('#aliddns_sk').val(),
                aliddns_name: $('#aliddns_name').val(),
                aliddns_domain: $('#aliddns_domain').val(),
                aliddns_interval: $('#aliddns_interval').val(),
                action_mode: ' Refresh ',
                current_page: 'Module_aliddns.asp',
                next_page: 'Module_aliddns.asp',
                SystemCmd: 'aliddns_config.sh'
            })
        }).then(function () {
            posting = false;
            alert('saved');
        }, function () {
            posting = false;
           alert('failed'); 
        })
    })
})
</script>
</body>
</html>

