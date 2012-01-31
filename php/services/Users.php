<?php

	class Users {
	
		private $db_conn;
		
	
	  	function __construct() {
			
			// make the connection
			$this->db_conn = mysql_connect('internal-db.s41232.gridserver.com', 'db41232_di_usr', 'dope911t') or die("Could not connect to database.");
			
			// select the proper db
			mysql_select_db('db41232_diddit') or die("Could not select database.");
		}
	
	
		function __destruct() {
		
			if ($this->db_conn) {
				mysql_close($this->db_conn);
				$this->db_conn = null;
			}
		}
		
		
		/**
		 * Helper method to get a string description for an HTTP status code
		 * http://www.gen-x-design.com/archives/create-a-rest-api-with-php/ 
		 * @returns status
		 */
		function getStatusCodeMessage($status) {
			
			$codes = Array(
				100 => 'Continue',
				101 => 'Switching Protocols',
				200 => 'OK',
				201 => 'Created',
				202 => 'Accepted',
				203 => 'Non-Authoritative Information',
				204 => 'No Content',
				205 => 'Reset Content',
				206 => 'Partial Content',
				300 => 'Multiple Choices',
				301 => 'Moved Permanently',
				302 => 'Found',
				303 => 'See Other',
				304 => 'Not Modified',
				305 => 'Use Proxy',
				306 => '(Unused)',
				307 => 'Temporary Redirect',
				400 => 'Bad Request',
				401 => 'Unauthorized',
				402 => 'Payment Required',
				403 => 'Forbidden',
				404 => 'Not Found',
				405 => 'Method Not Allowed',
				406 => 'Not Acceptable',
				407 => 'Proxy Authentication Required',
				408 => 'Request Timeout',
				409 => 'Conflict',
				410 => 'Gone',
				411 => 'Length Required',
				412 => 'Precondition Failed',
				413 => 'Request Entity Too Large',
				414 => 'Request-URI Too Long',
				415 => 'Unsupported Media Type',
				416 => 'Requested Range Not Satisfiable',
				417 => 'Expectation Failed',
				500 => 'Internal Server Error',
				501 => 'Not Implemented',
				502 => 'Bad Gateway',
				503 => 'Service Unavailable',
				504 => 'Gateway Timeout',
				505 => 'HTTP Version Not Supported');

			return (isset($codes[$status])) ? $codes[$status] : '';
		}
		
		
		/**
		 * Helper method to send a HTTP response code/message
		 * @returns body
		 */
		function sendResponse($status=200, $body='', $content_type='text/html') {
			
			$status_header = "HTTP/1.1 ". $status ." ". $this->getStatusCodeMessage($status);
			header($status_header);
			header("Content-type: ". $content_type);
			echo $body;
		}
	
		
		function addNew($ua_id, $username, $pin, $uu_id, $os, $model, $device_name) {
            
			$query = 'SELECT `ua_id` FROM `tblDevices` WHERE `ua_id` = "'. $ua_id .'";';
			$device_res = mysql_fetch_row(mysql_query($query));


			//$query = 'SELECT `id`, `device_id`, `username`, `email`, `pin`, `points` FROM `tblUsers` WHERE `device_id` = "'. $ua_id .'";';
			//$res = mysql_fetch_row(mysql_query($query));

			// doesn't exists
			if (!$device_res) {
				
				$query = 'SELECT `id` FROM `tblDeviceTypes` WHERE `title` = "'. $model .'";';
				$type_res = mysql_fetch_row(mysql_query($query));
				$type_id = $type_res[0];
				
				
				$query = 'INSERT INTO `tblUsers` (';
				$query .= '`id`, `username`, `email`, `pin`, `points`, `added`, `modified`) ';
				$query .= 'VALUES (NULL, "", "'. $username .'", "'. $pin .'", 0, NOW(), CURRENT_TIMESTAMP);';
				$result = mysql_query($query);
			    $user_id = mysql_insert_id();
			    

				$query = 'INSERT INTO `tblDevices` (';
				$query .= '`id`, `uuid`, `ua_id`, `type_id`, `os`, `name`, `master`, `added`, `modified`) ';
				$query .= 'VALUES (NULL, "'. $uu_id .'", "'. $ua_id .'", "'. $type_id .'", "'. $os .'", "'. $device_name .'", "Y", NOW(), CURRENT_TIMESTAMP);';
				$result = mysql_query($query);
			    $device_id = mysql_insert_id();
			
				$query = 'INSERT INTO `tblUsersDevices` (';
				$query .= '`user_id`, `device_id`) ';
				$query .= 'VALUES ('. $user_id .', '. $device_id .';';
				$result = mysql_query($query);
				
				
				//$query = 'INSERT INTO `tblUsers` (';
				//$query .= '`id`, `device_id`, `username`, `email`, `pin`, `points`, `added`, `modified`) ';
				//$query .= 'VALUES (NULL, "'. $ua_id .'", "", "'. $username .'", "'. $pin .'", 0, NOW(), CURRENT_TIMESTAMP);';
				//$result = mysql_query($query);
			    //$user_id = mysql_insert_id();
				
				// Return data, as JSON
				$result = array(
					"id" => $user_id, 
					"device_id" => $ua_id, 
					"username" => $username, 
					"email" => "", 
					"pin" => $pin,
					"points" => 0, 
					"finished" => 0,
					"app_type" => "master" 
				);

				$this->sendResponse(200, json_encode($result));

			} else {
				$query = 'SELECT `tblUsers`.`id`, `tblUsers`.`username`, `tblUsers`.`email`, `tblUsers`.`pin`, `tblUsers`.`points` FROM `tblUsers` INNER JOIN `tblUsersDevices` ON `tblUsers`.`id` = `tblUsersDevices`.`user_id` INNER JOIN `tblDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblDevices`.`ua_id` = "'. $ua_id .'";';
				$user_res = mysql_fetch_row(mysql_query($query));
			
				$query = 'SELECT * FROM `tblUsersChores` INNER JOIN `tblChores` ON `tblUsersChores`.`chore_id` = `tblChores`.`id` WHERE `tblUsersChores`.`user_id` = "'. $user_res[0] .'" AND `tblChores`.`status_id` =4;';
				$tot_res = mysql_query($query);				
				$tot = mysql_num_rows($tot_res);
				
				$this->sendResponse(200, json_encode(array(
					"id" => $user_res[0], 
					"device_id" => $device_res[0], 
					"username" => $user_res[1],
					"email" => $user_res[2],
					"pin" => $user_res[3],
					"points" => $user_res[4], 
					"finished" => $tot, 
					"app_type" => "master"
				)));
			}
			
			return (true);
		}
		
		
		function addNewDevice($uuid, $ua_id, $device_name, $model, $os, $hex) {
			
			$query = 'SELECT `id` FROM `tblDevices` WHERE `ua_id` = "'. $ua_id .'"';
			$dev_row = mysql_fetch_row(mysql_query($query));
			
			if (!$dev_row) {
				$query = 'SELECT `user_id` FROM `tblSyncCodes` WHERE `value` = "'. $hex .'"';
				$hex_row = mysql_fetch_row(mysql_query($query));
				
				if ($hex_row) {				
					$user_id = $hex_row[0];
				    
					$query = 'SELECT `id` FROM `tblDeviceTypes` WHERE `title` = "'. $model .'";';
					$type_res = mysql_fetch_row(mysql_query($query));
					$type_id = $type_res[0];
				    
					$query = 'INSERT INTO `tblDevices` (';
					$query .= '`id`, `uuid`, `ua_id`, `type_id`, `os`, `name`, `master`, `added`, `modified`) ';
					$query .= 'VALUES (NULL, "'. $uu_id .'", "'. $ua_id .'", "'. $type_id .'", "'. $os .'", "'. $device_name .'", "N", NOW(), CURRENT_TIMESTAMP);';
					$result = mysql_query($query);
				    $device_id = mysql_insert_id();
			
					$query = 'INSERT INTO `tblUsersDevices` (';
					$query .= '`user_id`, `device_id`) ';
					$query .= 'VALUES ('. $user_id .', '. $device_id .');';
					$result = mysql_query($query);
					
					$query = 'UPDATE `tblSyncCodes` SET `user_id` =0 WHERE `value` ="'. $hex .'";';
			    	$result = mysql_query($query);
			
					$query = 'SELECT `tblUsers`.`id`, `tblUsers`.`username`, `tblUsers`.`email`, `tblUsers`.`pin`, `tblUsers`.`points` FROM `tblUsers` INNER JOIN `tblUsersDevices` ON `tblUsers`.`id` = `tblUsersDevices`.`user_id` INNER JOIN `tblDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblDevices`.`ua_id` = "'. $ua_id .'";';
					$user_res = mysql_fetch_row(mysql_query($query));
					
					$query = 'SELECT * FROM `tblUsersChores` INNER JOIN `tblChores` ON `tblUsersChores`.`chore_id` = `tblChores`.`id` WHERE `tblUsersChores`.`user_id` = "'. $user_res[0] .'" AND `tblChores`.`status_id` =4;';
					//$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $user_res[0] .'" AND `status_id` = "4" ORDER BY `added`;';
					$tot_res = mysql_query($query);				
					$tot = mysql_num_rows($tot_res);
					
					$this->sendResponse(200, json_encode(array(
						"id" => $user_res[0], 
						"device_id" => $ua_id, 
						"username" => $user_res[1],
						"email" => $user_res[2],
						"pin" => $user_res[3],
						"points" => $user_res[4], 
						"finished" => $tot, 
						"app_type" => "sub"
					)));
				
				} else {
					$this->sendResponse(200, json_encode(array(
						"result" => "code not found"
					)));	
				}
			
			} else {
				$query = 'UPDATE `tblSyncCodes` SET `user_id` =0 WHERE `value` ="'. $hex .'";';
			    $result = mysql_query($query);
			
			 	$query = 'SELECT `tblUsers`.`id`, `tblUsers`.`username`, `tblUsers`.`email`, `tblUsers`.`pin`, `tblUsers`.`points` FROM `tblUsers` INNER JOIN `tblUsersDevices` ON `tblUsers`.`id` = `tblUsersDevices`.`user_id` INNER JOIN `tblDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblDevices`.`ua_id` = "'. $ua_id .'";';
				$user_res = mysql_fetch_row(mysql_query($query));
				
				//$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $user_res[0] .'" AND `status_id` = "4" ORDER BY `added`;';
				$query = 'SELECT * FROM `tblUsersChores` INNER JOIN `tblChores` ON `tblUsersChores`.`chore_id` = `tblChores`.`id` WHERE `tblUsersChores`.`user_id` = "'. $user_res[0] .'" AND `tblChores`.`status_id` =4;';
				$tot_res = mysql_query($query);				
				$tot = mysql_num_rows($tot_res);
				
				$this->sendResponse(200, json_encode(array(
					"id" => $user_res[0], 
					"device_id" => $ua_id, 
					"username" => $user_res[1],
					"email" => $user_res[2],
					"pin" => $user_res[3],
					"points" => $user_res[4], 
					"finished" => $tot,
					"app_type" => "sub"
				)));	
			}
		}
		
		function nextSyncCode($user_id) {
			/*
			$query = 'SELECT `value` FROM `tblSyncCodes` WHERE `user_id` ='. $user_id .';';
			$user_res = mysql_query($query);
			
			if ($user_res) {
				$user_row = mysql_fetch_row($user_res);
				
				$this->sendResponse(200, json_encode(array(
					"pin_code" => $user_row[0]
				)));
			
			} else {*/
				$query = 'SELECT `value` FROM `tblSyncCodes` WHERE `user_id` =0 ORDER BY RAND() LIMIT 1;';
				$row = mysql_fetch_row(mysql_query($query));
			
				if ($row) {
					$pin_code = $row[0];
				    $query = 'UPDATE `tblSyncCodes` SET `user_id` ='. $user_id .' WHERE `value` ="'. $pin_code .'";';
				    $result = mysql_query($query);
			
					$this->sendResponse(200, json_encode(array(
						"pin_code" => $pin_code
					)));
				} 
			//}
			
			return (true);
		}
		
		function getByID($id, $ua_id) {

			$query = 'SELECT * FROM `tblUsers` WHERE `id` = "'. $id .'";';
			$row = mysql_fetch_row(mysql_query($query));

			// has user
			if ($row) {
                
				$query = 'SELECT `id`, `master` FROM `tblDevices` WHERE `ua_id` = "'. $ua_id .'";';
                $dev_row = mysql_fetch_row(mysql_query($query));

				if ($dev_row[1] == "Y")
					$app_type = "master";
					
				else
			    	$app_type = "sub";
                
                
				$dev_arr = array();
				if ($app_type == "master") {
					$query = 'SELECT `tblDevices`.`id`, `tblDevices`.`ua_id` FROM `tblDevices` INNER JOIN `tblUsersDevices` ON `tblDevices`.`id` = `tblUsersDevices`.`device_id` WHERE `tblUsersDevices`.`user_id` = "'. $row[0] .'" AND `tblDevices`.`ua_id` != "'. $ua_id .'";';
					$dev_res = mysql_query($query);
				
					while ($dev_row = mysql_fetch_array($dev_res, MYSQL_BOTH)) {
						array_push($dev_arr, array(
							"id" => $dev_row[0], 
							"ua_id" => $dev_row[1]
						));
			    	}
			
					$query = 'SELECT * FROM `tblUsersChores` INNER JOIN `tblChores` ON `tblUsersChores`.`chore_id` = `tblChores`.`id` WHERE `tblUsersChores`.`user_id` = "'. $id .'" AND `tblChores`.`status_id` =4;';
					//$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $id .'" AND `status_id` = "4" ORDER BY `added`;';
					$tot_res = mysql_query($query);				
					$tot = mysql_num_rows($tot_res);

					// Return data, as JSON
					$result = array(
						"id" => $row[0], 
						"device_id" => $ua_id, 
						"sub_id" => "0", 
						"username" => $row[2], 
						"email" => $row[3], 
						"pin" => $row[4], 
						"points" => $row[5], 
						"finished" => $tot, 
						"app_type" => $app_type,
						"devices" => $dev_arr
					);
				
				} else {
                    
					$query = 'SELECT * FROM `tblUsersChores` INNER JOIN `tblChores` ON `tblChores`.`id` = `tblUsersChores`.`chore_id` WHERE `tblUsersChores`.`sub_id` = "'. $dev_row[0] .'" AND `tblUsersChores`.`user_id` = "'. $id .'" AND `tblChores`.`status_id` = "4" ORDER BY `tblChores`.`added`;';
					$tot_res = mysql_query($query);				
					$tot = mysql_num_rows($tot_res);

					// Return data, as JSON
					$result = array(
						"id" => $row[0], 
						"device_id" => $ua_id, 
						"sub_id" => $dev_row[0], 
						"username" => $row[2], 
						"email" => $row[3], 
						"pin" => $row[4], 
						"points" => $row[5], 
						"finished" => $tot, 
						"app_type" => $app_type,
						"devices" => $dev_arr
					);
				}

				$this->sendResponse(200, json_encode($result));

			} else
				$this->sendResponse(200, json_encode(array()));
			
			return (true);
		}


		
		
		function updateUsername($id, $username) {
			
			$query = 'UPDATE `tblUsers` SET `username` ='. $username .' WHERE `id` ='. $id .';';
			$result = mysql_query($query);
			
			return (true);
		}
		
		function updatePin($id, $pin) {
			
			$query = 'UPDATE `tblUsers` SET `pin` ='. $pin .' WHERE `id` ='. $id .';';
			$result = mysql_query($query);
			
			return (true);
		}
		
		function addPoints($id, $amt) {
			
			$query = 'SELECT `points` FROM `tblUsers` WHERE `id` = "'. $id .'";';
			$row = mysql_fetch_row(mysql_query($query));
			$points = $row[0] + $amt;
			
			$query = 'UPDATE `tblUsers` SET `points` ='. $points .' WHERE `id` ='. $id .';';
			$result = mysql_query($query);
			
			
			$query = 'SELECT * FROM `tblUsers` WHERE `id` = "'. $id .'";';
			$row = mysql_fetch_row(mysql_query($query));

			// has user
			if ($row) {
                
				$query = 'SELECT * FROM `tblUsersChores` INNER JOIN `tblChores` ON `tblUsersChores`.`chore_id` = `tblChores`.`id` WHERE `tblUsersChores`.`user_id` = "'. $id .'" AND `tblChores`.`status_id` =4;';
				//$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $id .'" AND `status_id` = "4" ORDER BY `added`;';
				$tot_res = mysql_query($query);				
				$tot = mysql_num_rows($tot_res);

				// Return data, as JSON
				$result = array(
					"id" => $row[0], 
					"device_id" => $row[1], 
					"username" => $row[2], 
					"email" => $row[3], 
					"pin" => $row[4], 
					"points" => $row[5], 
					"finished" => $tot + 1
				);

				$this->sendResponse(200, json_encode($result));

			} else
				$this->sendResponse(200, json_encode(array()));
			
			return (true);
		}
		
		function getDevices($user_id) {
			
			$query = 'SELECT * FROM `tblDevices` INNER JOIN `tblUsersDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblUsersDevices`.`user_id` = "'. $user_id .'" AND `tblDevices`.`master` = "N"';
			$dev_res = mysql_query($query);
			$dev_arr = array();
				
			while ($dev_row = mysql_fetch_array($dev_res, MYSQL_BOTH)) {
				array_push($dev_arr, array(
					"id" => $dev_row['id'],
					"uuid" => $dev_row['uuid'], 
					"ua_id" => $dev_row['ua_id'], 
					"type_id" => $dev_row['type_id'], 
					"os" => $dev_row['os'], 
					"name" => $dev_row['name'], 
					"master" => $dev_row['master'], 
					"locked" => $dev_row['locked']
				));
			}
			$this->sendResponse(200, json_encode($dev_arr));
		
			return (true);
		}
	}
	
	
	$users = new Users;
	
	
	//$device_id = '58fd9edd83341c29f1aebba81c31e25758fd9edd83341c29f1aebba81c31e257';	
	//$users->addNew($device_id);
	                                
	
	if (isset($_POST['action'])) {
		switch ($_POST['action']) {
			case "0":
				if (isset($_POST["uaID"]) && isset($_POST['username']) && isset($_POST['pin']) && isset($_POST['uuID']) && isset($_POST['os']) && isset($_POST['model']) && isset($_POST['deviceName']))
					$users->addNew($_POST['uaID'], $_POST['username'], $_POST['pin'], $_POST['uuID'], $_POST['os'], $_POST['model'], $_POST['deviceName']);
				break;
				
			case "1":
				if (isset($_POST["userID"]) && isset($_POST['uaID']))
					$users->getByID($_POST["userID"], $_POST['uaID']);
				break;
				
			case "2":
				if (isset($_POST["userID"]) && isset($_POST['username']))
					$users->updateUsername($_POST["userID"], $_POST["username"]);
				break; 
				
			case "3":
				if (isset($_POST["userID"]) && isset($_POST['pin']))
					$users->updatePin($_POST["userID"], $_POST["pin"]);
				break; 
				
			case "4":
				if (isset($_POST["userID"]) && isset($_POST['points']))
					$users->addPoints($_POST["userID"], $_POST["points"]);
				break;
				
			case "5":
			 	if (isset($_POST['userID']))
					$users->nextSyncCode($_POST['userID']);
				break;
				
		   case "6":
				if (isset($_POST['uuID']) && isset($_POST['uaID']) && isset($_POST['deviceName']) && isset($_POST['model']) && isset($_POST['os']) && isset($_POST['pinCode']))
					$users->addNewDevice($_POST['uuID'], $_POST['uaID'], $_POST['deviceName'], $_POST['model'], $_POST['os'], $_POST['pinCode']);
				break;
		   
		   case "7":
				if (isset($_POST['userID']))
					$users->getDevices($_POST['userID']);
				break;
		}
	}
	//$userInfo_arr = $users->userInfoByFacebookID($fb_id);
?>