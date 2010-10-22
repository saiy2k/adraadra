<?php
	$conn = mysql_connect("localhost", "", "");

	mysql_select_db("", $conn);

	$stri = explode(',', $_POST['uids']); 

	$querystring = "select * from userscore where user in (";
	for($i=0; $i< count($stri)-1; $i++)
	{
		$querystring = $querystring . $stri[$i] . ",";
	}

	$querystring = $querystring . $stri[count($stri)-1] . ")";


	$result = mysql_query($querystring, $conn);

	echo("<?xml version='1.0'?><xml>");
	while($row = mysql_fetch_array($result))
	{
		echo("<user id='" . $row['user'] . "' score='" . $row['score'] . "'>user</user>"); 
	}
	echo("</xml>");

	mysql_close($conn);
?>