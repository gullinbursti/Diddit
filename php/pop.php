<?php                                                   

$db_conn = mysql_connect('internal-db.s41232.gridserver.com', 'db41232_di_usr', 'dope911t') or die("Could not connect to database.");
mysql_select_db('db41232_diddit') or die("Could not select database.");


for ($i=0; $i<65536; $i++) {
	$len = strlen(dechex($i));
	
	for ($j=0; $j<4-$len; $j++)
		$hex .= "0";
		
	$hex .= dechex($i);
	$query = 'INSERT INTO `tblSyncCodes` (';
	$query .= '`id`, `value`, `user_id`) ';
	$query .= 'VALUES (NULL, "'. strtoupper($hex) .'", 0);';
	$result = mysql_query($query);
	$code_id = mysql_insert_id();
	
	$hex = "";
} 


if ($db_conn) {
	mysql_close($db_conn);
	$db_conn = null;
} 

?>