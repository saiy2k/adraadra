<?php

/*
	Adra Adra - A simple flash facebook game based on OpenGraph API
    Copyright (C) 2010 Author: Saiyasodharan, JyothiSwaroop

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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