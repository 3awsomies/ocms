<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Welcome to Competency Management System</title>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js">
	
</script>
<script type="text/javascript">
	function setCookie(c_name, value, exdays) {
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + exdays);
		var c_value = escape(value)
				+ ((exdays == null) ? "" : "; expires=" + exdate.toUTCString());
		document.cookie = c_name + "=" + c_value;
	}
	function login(code) {
		var el = document.getElementById('userid').value;
		var password = document.getElementById('password').value;
		var department = document.getElementById('department').value;
		var forward;
		if (department == "Employee")
			forward = "employee";
		if (department == "Senior Management")
			forward = "manager";
		if (department == "Human Resource")
			forward = "hrdepartment";
		var decodedCode = decode(code);
		var str = password + decodedCode;
		var encodedPswd = encode(str);
		var url = location.protocol + "//" + location.host + "/project/login/"
				+ department + "/" + el + "/" + encodedPswd;
		$.ajax({
			type : "GET",
			url : url,
			success : function(data) {
				var url = "http://localhost:8080/project/" + forward + ".jsp";
				setCookie("userId", el, 5);
				$(location).attr('href', url);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(textStatus + ':' + errorThrown);
			}
		});
	}

	function validate() {
		var el = document.getElementById('userid').value;
		var url = location.protocol + "//" + location.host
				+ "/project/login/validate/" + el;
		$.ajax({
			url : url,
			contentType : 'application/json',
			dataType : 'json',
			converters : {
				'json' : jQuery.parseJSON
			},
			success : function(data) {
				var result = data.response;
				if (result == "SUCCESS")
					login(data.code);
				else
					alert("string does not match");
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(textStatus + ':' + errorThrown);
			}
		});
	}

	var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

	function encode(input) {
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;

		input = utf8_encode(input);

		while (i < input.length) {

			chr1 = input.charCodeAt(i++);
			chr2 = input.charCodeAt(i++);
			chr3 = input.charCodeAt(i++);

			enc1 = chr1 >> 2;
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
			enc4 = chr3 & 63;

			if (isNaN(chr2)) {
				enc3 = enc4 = 64;
			} else if (isNaN(chr3)) {
				enc4 = 64;
			}

			output = output + this._keyStr.charAt(enc1)
					+ this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3)
					+ this._keyStr.charAt(enc4);

		}

		return output;
	}

	// public method for decoding
	function decode(input) {
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;

		input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

		while (i < input.length) {

			enc1 = this._keyStr.indexOf(input.charAt(i++));
			enc2 = this._keyStr.indexOf(input.charAt(i++));
			enc3 = this._keyStr.indexOf(input.charAt(i++));
			enc4 = this._keyStr.indexOf(input.charAt(i++));

			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;

			output = output + String.fromCharCode(chr1);

			if (enc3 != 64) {
				output = output + String.fromCharCode(chr2);
			}
			if (enc4 != 64) {
				output = output + String.fromCharCode(chr3);
			}

		}

		output = utf8_decode(output);

		return output;

	}

	// private method for UTF-8 encoding
	function utf8_encode(string) {
		string = string.replace(/\r\n/g, "\n");
		var utftext = "";

		for ( var n = 0; n < string.length; n++) {

			var c = string.charCodeAt(n);

			if (c < 128) {
				utftext += String.fromCharCode(c);
			} else if ((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			} else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}

		}

		return utftext;
	}

	// private method for UTF-8 decoding
	function utf8_decode(utftext) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;

		while (i < utftext.length) {

			c = utftext.charCodeAt(i);

			if (c < 128) {
				string += String.fromCharCode(c);
				i++;
			} else if ((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i + 1);
				string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			} else {
				c2 = utftext.charCodeAt(i + 1);
				c3 = utftext.charCodeAt(i + 2);
				string += String.fromCharCode(((c & 15) << 12)
						| ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}

		}

		return string;
	}
</script>


</head>
<body>
	<div>
		<form name="login_form" action="/ocms/login/" method="POST">
			<div>
				<table width="40%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top">
							<table border="0" cellspacing="0" cellpadding="4" width="40%">
								<tr>
									<td colspan="2">Login
										<hr width="100%" size="1" noshade align="left">
									</td>
									<td></td>
								</tr>
								<tr>
									<td width="80">Username</td>
									<td valign="top" align="left"><p>
											<b>Username : </b><input type="text" name="userId" value=""
												size="35" /></td>
								</tr>
								<tr>
									<td width="80">Password</td>
									<td valign="top" align="left"><input type="password"
										name="password" value="" size="35" /></td>
								</tr>
								<tr>
									<td><b>Select Role : </b><select name="department">
											<option>Select</option>
											<option value="10">Employee</option>
											<option value="20">Senior Management</option>
											<option value="30">Human Resource</option>
											<option value="40">Training Department</option>
											<option value="50">Appraisal & Compensation</option>
									</select></td>
									<td><input type="submit" value="Submit" /></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</body>
</html>