<?php

require 'facebook.php';

$fbconfig['appid' ]  = "153141878045256";
$fbconfig['api'   ]  = "b6f4ed57a6921b31b49ff7253ed16c94";
$fbconfig['secret']  = "1441365d1f4bd2c4a9d21ca45d66da2a";
$config['baseurl']  =   "http://apps.facebook.com/adraadra/";

$facebook = new Facebook(array(
  'appId'  => $fbconfig['appid' ],
  'secret' => $fbconfig['secret'],
  'cookie' => true,
));

$session = $facebook->getSession();

$fbme = null;
if ($session)
{
	try
	{
		$uid = $facebook->getUser();
		$fbme = $facebook->api('/me');
	}
	catch (FacebookApiException $e)
	{
		$url = $facebook->getLoginUrl(array('canvas'=>1,'fbconnect'=>0, 'req_perms' => 'publish_stream'));
		echo "<h3><a href=\"javascript:void(0)\" onclick=\"top.location.href = '".$url."'\">SignUp</a></h3>";
		exit('not yet signed up for the App');
	}
}
else
{
	$url = $facebook->getLoginUrl(array('canvas'=>1,'fbconnect'=>0, 'req_perms' => 'publish_stream'));
	echo "<h3><a href=\"javascript:void(0)\" onclick=\"top.location.href = '".$url."'\">SignUp</a></h3>";
	exit('not yet signed up for the App');
}
 
function d($d)
{
	echo '<pre>';
	print_r($d);
	echo '</pre>';
}

if ($fbme)
{
	$conn = mysql_connect("localhost", "aagntzee", "xvruwwizixwl");

	mysql_select_db("aagntzee_userscore", $conn);

try
{	
	$result = mysql_query("select * from userscore where user = " . $uid, $conn);

	if (mysql_num_rows($result) == 0)
	{
		mysql_query("insert into userscore values('" . $uid. "', '0')");	
	}
}
catch (Exception $e)
{
	echo($e);
}

	mysql_close($conn);

	$param  =   array(
		'method'  => 'friends.getappusers',
		'uids'    => $fbme['id'],
		'callback'=> ''
	);
	$appusers = $facebook->api($param);

	$frndname_arr = array();
	$frnduid_arr  = array();

	foreach ($appusers  as &$value)
	{
		$usr = $facebook->api('/'.$value);
		array_push($frndname_arr, $usr['name']);
		array_push($frnduid_arr, $value);
	}
	$frndname = implode(",", $frndname_arr);
	$frnduid= implode(",", $frnduid_arr);

	echo($frndname);
	echo('<br>');
	echo($frnduid);
}
?>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
<div id="fb-root"></div>
<script type="text/javascript">
            window.fbAsyncInit = function() {
                FB.init({appId: '153141878045256', status: true, cookie: true, xfbml: true});

                /* All the events registered */
                FB.Event.subscribe('auth.login', function(response) {
                    // do something with response
                    login();
                });
                FB.Event.subscribe('auth.logout', function(response) {
                    // do something with response
                    logout();
                });

                FB.getLoginStatus(function(response) {
                    if (response.session) {
                        // logged in and connected user, someone you know
                        login();
                    }
                });
            };
            (function() {
                var e = document.createElement('script');
                e.type = 'text/javascript';
                e.src = document.location.protocol +
                    '//connect.facebook.net/en_US/all.js';
                e.async = true;
                document.getElementById('fb-root').appendChild(e);
            }());

function login()
{
	FB.api('/me', function(response) {
		document.getElementById('login').style.display = "block";
		document.getElementById('login').innerHTML = response.name + " succsessfully logged in!";
	});
}

function logout()
{
	document.getElementById('login').style.display = "none";
}

function saysomething(tMessage, tName, tTime, tStat) {
	var actionLinks = [{ "text": "Read CaringBridge Journal", "href": 'http://www.google.com'}];
	var attachment =
	{
		'name': 'hi',
		'caption': tName + ' finished the game in ' + tTime + ' seconds and is better than ' + tStat + '% of his friends in Pumping',
		'href': 'http://www.google.com'
	};
	photoUrl = 'http://aagntzee.facebook.joyent.us/AdraAdra/AdraAdraLogo.png';
	var media=
	[
		{
		'type': 'image',
		'src': photoUrl,
		'href': 'http://www.google.com'
		}
	];
	attachment.media = media;

	FB.ui(
	{
		method: 'stream.publish',
		display: 'dialog',
		attachment: attachment,
		action_links: actionLinks
	},
	function(response)
	{
		if (response && response.post_id) {
			alert('Post was published.');
		} else {
			alert('Post was not published.');
		}
	}
	);
}
</script>

JS API TEST

<div id="login">a </div>

	<script type="text/javascript" src="swfobject.js"></script>

	<script type="text/javascript">

	var flashvars = {};
	flashvars.playername = "<?php echo($fbme['name']); ?>";
	flashvars.playeruid  = "<?php echo($uid); ?>";
	flashvars.frndsname  = "<?php echo($frndname); ?>";
	flashvars.frndsuid   = "<?php echo($frnduid); ?>";

	var params = {wmode:'transparent'};
	var attributes = false;

	swfobject.embedSWF("AdraAdraFLA.swf", "myContent", "600", "400", "9.0.0", "expressInstall.swf", flashvars, params, attributes);
	</script>

	<script type="text/javascript"> 
	function SetData(val){
		saysomething(val);
	}
	</script>

<div id="myContent"> </div>

<p>
	<a href="javascript:void(0);" onclick="saysomething('hi', 0, 0, 0); return false;">Post Chke</a> |
</p>
</body>
</html>