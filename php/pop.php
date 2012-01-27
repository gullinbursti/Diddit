<?php                                                   

$db_conn = mysql_connect('internal-db.s41232.gridserver.com', 'db41232_di_usr', 'dope911t') or die("Could not connect to database.");
mysql_select_db('db41232_diddit') or die("Could not select database.");


for ($i=0; $i<1000; $i++) {
	$len = strlen(strval($i));
	
	$val = "";
	for ($j=0; $j<3-$len; $j++)
		$val .= "0";
		
	$val .= strval($i);
	$query = 'INSERT INTO `tblSyncCodes` (';
	$query .= '`id`, `value`, `user_id`) ';
	$query .= 'VALUES (NULL, "'. $val .'", 0);';
	$result = mysql_query($query);
	$code_id = mysql_insert_id();
	
	//echo ($val ."<br />");
} 


/*
$token_arr = array(
	"1234567890", 
	"0987654321"
);

$query = 'SELECT `tblDevices`.`ua_id` FROM `tblDevices` INNER JOIN `tblUsersDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblDevices`.`master` = "N" AND `tblUsersDevices`.`user_id`='. $user_id .'';
$dev_res = mysql_query($query);

$device_tokens = '[';
while ($dev_row = mysql_fetch_array($dev_res, MYSQL_BOTH))
	$device_tokens .= '"'. $row[0] .'", ';
	
$device_tokens = substr($device_tokens, 0, -2) .']';

echo ($device_tokens);
*/

if ($db_conn) {
	mysql_close($db_conn);
	$db_conn = null;
} 

?>