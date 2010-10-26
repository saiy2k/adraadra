<?php

require 'facebook.php';

//Set the FaceBook Application settings from the developer Application.
$fbconfig['appid' ]  = "";
$fbconfig['api'   ]  = "";
$fbconfig['secret']  = "";

//Initiate Facebook object with the app settings
$facebook = new Facebook(array(
  'appId'  => $fbconfig['appid' ],
  'secret' => $fbconfig['secret'],
  'cookie' => true,
));

//Get the FaceBook session. This might sometimes end up with NULL, be careful.
$session = $facebook->getSession();

$fbme = null;

if ($session)	//Try to get User details if the session is valid.
{
	try
	{
		$uid = $facebook->getUser();		//get the unique FB UID
		$fbme = $facebook->api('/me');		//get the facebook User Object
	}
	catch (FacebookApiException $e)
	{
		print_r($e);
		exit('Error getting details from FB');
	}
}
else		//If Session is not valid, provide the user with Login URL to create a valid session
{
	$url = $facebook->getLoginUrl(array('canvas'=>1,'fbconnect'=>0, 'req_perms' => 'publish_stream'));
	echo "<h3><a href=\"javascript:void(0)\" onclick=\"top.location.href = '".$url."'\">SignUp</a></h3>";
	exit('not yet signed up for the App');
}

//Establish connection to database
$conn = mysql_connect("localhost", "", "");

//Set current Database
mysql_select_db("", $conn);

//Try to retrieve the user data
$result = mysql_query("select * from userscore where user = " . $uid, $conn);

//If the user data is not available, add a row with his user id. (For new users)
if (mysql_num_rows($result) == 0)
{
	mysql_query("insert into userscore values('" . $uid. "', '0')");	
}

//Close the sql connection
mysql_close($conn);

//Get the friends UIDs who uses this application
$param  =   array(
	'method'  => 'friends.getappusers',
	'uids'    => $fbme['id'],
	'callback'=> ''
);

//Get the details of friends
$appusers = $facebook->api($param);

$frndname_arr = array();
$frnduid_arr  = array();

//Fill the Name and UID array with friends name and UID
foreach ($appusers  as &$value)
{
	$usr = $facebook->api('/'.$value);
	array_push($frndname_arr, $usr['name']);
	array_push($frnduid_arr, $value);
}

//Join the Name and UID array into a string, in which individual names and UID's are separated with ','
$frndname = implode(",", $frndname_arr);
$frnduid= implode(",", $frnduid_arr);
?>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
<div id="fb-root"></div>
<script type="text/javascript">
//The following code snippet is to include Facebook Javascript SDK into the current page,
//so as to access the features of Graph API via javascript. Also event handlers for a few
//events like login() and logout() are written.

	window.fbAsyncInit = function() {
		FB.init({appId: '', status: true, cookie: true, xfbml: true});

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

	}

	function logout()
	{

	}

	//this function is to post on to the user;s wall
	//this is called from within flash, once the game is over.
	function saysomething(tMessage, tName, tTime, tStat) {
		var actionLinks = [{ "text": "Compete!!!", "href": 'http://apps.facebook.com/adraadra'}];
		var attachment;
		if(tStat)
		{
			attachment =
			{
				'name': 'hi',
				'caption': tName + ' finished the game in ' + tTime + ' seconds and holds the TOP TIMING among his friends',
				'href': 'http://apps.facebook.com/adraadra'
			};
		}
		else
		{
			attachment =
			{
				'name': 'hi',
				'caption': tName + ' finished the game in ' + tTime + ' seconds',
				'href': 'http://apps.facebook.com/adraadra'
			};
		}
		photoUrl = 'http://aagntzee.facebook.joyent.us/AdraAdra/AdraAdraLogo.png';
		var media=
		[
			{
			'type': 'image',
			'src': photoUrl,
			'href': 'http://apps.facebook.com/adraadra'
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

UNDER MAINTENANCE

	<!--including SWF Object (http://code.google.com/p/swfobject/) -->
	<script type="text/javascript" src="swfobject.js"></script>

	<script type="text/javascript">

	<!--append all the details necessary to display the scoreboard in flash vars.-->
	var flashvars = {};
	flashvars.playername = "<?php echo($fbme['name']); ?>";
	flashvars.playeruid  = "<?php echo($uid); ?>";
	flashvars.frndsname  = "<?php echo($frndname); ?>";
	flashvars.frndsuid   = "<?php echo($frnduid); ?>";

	var params = {wmode:'transparent'};
	var attributes = false;

	<!--embed the SWF file and pass the flashvars along with-->
	swfobject.embedSWF("AdraAdraFLA.swf", "myContent", "600", "400", "9.0.0", "expressInstall.swf", flashvars, params, attributes);
	</script>

	<!--simple test function (will be removed in the future)-->
	<script type="text/javascript"> 
	function SetData(val){
		saysomething(val);
	}
	</script>

	<!--this tag will be loaded with the SWF file by the SWFObject-->
	<div id="myContent"> </div>

</body>
</html>