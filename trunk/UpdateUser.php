<?php
	$conn = mysql_connect("localhost", "", "");

	mysql_select_db("", $conn);

try{
	$result = mysql_query("select * from userscore where user = " . $_POST['uid'], $conn);

	$row = mysql_fetch_array($result);
	
	if($row['score'] < $_POST['score'])
	{
		mysql_query("update userscore set score='" . $_POST['score'] . "' where user='" . $_POST['uid'] . "'");
	}
}
catch (Exception $e)
{
	echo($e);
}
		
	mysql_close($conn);
?>