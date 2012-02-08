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
	
		
		function addNew($ua_id, $username, $pin, $uu_id, $os, $model, $device_name, $master) {
            
			$query = 'SELECT `ua_id` FROM `tblDevices` WHERE `ua_id` = "'. $ua_id .'";';
			$device_res = mysql_fetch_row(mysql_query($query));


			//$query = 'SELECT `id`, `device_id`, `username`, `email`, `pin`, `points` FROM `tblUsers` WHERE `device_id` = "'. $ua_id .'";';
			//$res = mysql_fetch_row(mysql_query($query));
            
			if ($master == "Y")
				$userType_id = 1;
					
			else
				$userType_id = 3;
					
			// doesn't exists
			if (!$device_res) {
				
				$query = 'SELECT `id` FROM `tblDeviceTypes` WHERE `title` = "'. $model .'";';
				$type_res = mysql_fetch_row(mysql_query($query));
				$type_id = $type_res[0];
				
				$query = 'INSERT INTO `tblUsers` (';
				$query .= '`id`, `type_id`, `username`, `email`, `pin`, `points`, `added`, `modified`) ';
				$query .= 'VALUES (NULL, "'. $userType_id .'", "'. $username .'", "", "'. $pin .'", 0, NOW(), CURRENT_TIMESTAMP);';
				$result = mysql_query($query);
			    $user_id = mysql_insert_id();

				$query = 'INSERT INTO `tblDevices` (';
				$query .= '`id`, `uuid`, `ua_id`, `type_id`, `os`, `name`, `added`, `modified`) ';
				$query .= 'VALUES (NULL, "'. $uu_id .'", "'. $ua_id .'", "'. $type_id .'", "'. $os .'", "'. $device_name .'", NOW(), CURRENT_TIMESTAMP);';
				$result = mysql_query($query);
			    $device_id = mysql_insert_id();
			
				$query = 'INSERT INTO `tblUsersDevices` (';
				$query .= '`user_id`, `device_id`) ';
				$query .= 'VALUES ("'. $user_id .'", "'. $device_id .'");';
				$result = mysql_query($query);
				
				
				/*
				if ($master == "N") {
					$query = 'SELECT `user_id` FROM `tblSyncCodes` WHERE `value` = "'. $pin .'"';
					$sync_row = mysql_fetch_row(mysql_query($query));
					
					if ($sync_row) {				
						$master_id = $sync_row[0];
						$query = 'UPDATE `tblSyncCodes` SET `user_id` =0 WHERE `value` ="'. $pin .'";';
			    		$result = mysql_query($query);
			
						$query = 'INSERT INTO `tblGiversRecievers` (';
						$query .= '`giver_id`, `reciever_id`) ';
						$query .= 'VALUES ('. $master_id .', '. $user_id .');';
						$result = mysql_query($query);
						
						$query = 'SELECT `tblDevices`.`ua_id` FROM `tblDevices` INNER JOIN `tblUsersDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblUsersDevices`.`user_id` = "'. $master_id .'";';
						$master_row = mysql_fetch_row(mysql_query($query));
						
						$ch = curl_init();
						curl_setopt($ch, CURLOPT_URL, 'https://go.urbanairship.com/api/push/');
						curl_setopt($ch, CURLOPT_USERPWD, "s12VbppFR2yIXDrIFAZegg:lC1GUQYQTxG141PZ1L4f6A");
						curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
						curl_setopt($ch, CURLOPT_POST, 1);
						curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
						//curl_setopt($ch, CURLOPT_POSTFIELDS, '{"device_tokens": ["'. $device_id .'"], "type": "'. $type_id .'", "aps": {"alert": { "body": "'. $msg .'", "action-loc-key": "UA_PUSH"}, "badge": "+1"}}');
						curl_setopt($ch, CURLOPT_POSTFIELDS, '{"device_tokens": ['. $mater_row[0] .'], "type": "3", "aps": {"alert": { "body": "Chore Added ('. $chore_title .')"}, "badge": "+1"}}');
			
					}
				}
				*/
					
				if ($master == "Y") {
					$query = 'SELECT `id` FROM `tblUsers` WHERE `username` = "'. $username .'";';
					$user_row = mysql_fetch_row(mysql_query($query));
					
					if ($user_row) {
						$query = 'INSERT INTO `tblGiversRecievers` (';
						$query .= '`giver_id`, `reciever_id`) ';
						$query .= 'VALUES ('. $user_id .', '. $user_row[0] .');';
						$result = mysql_query($query);
					}
				}
				
				// Return data, as JSON
				$result = array(
					"id" => $user_id, 
					"device_id" => $ua_id, 
					"username" => $username, 
					"email" => "", 
					"pin" => $pin,
					"points" => 0, 
					"type_id" => $userType_id 
				);

				$this->sendResponse(200, json_encode($result));

			} else {
				$query = 'SELECT `tblUsers`.`id`, `tblUsers`.`username`, `tblUsers`.`email`, `tblUsers`.`pin`, `tblUsers`.`points`, `tblUsers`.`type_id` FROM `tblUsers` INNER JOIN `tblUsersDevices` ON `tblUsers`.`id` = `tblUsersDevices`.`user_id` INNER JOIN `tblDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblDevices`.`ua_id` = "'. $ua_id .'";';
				$user_res = mysql_fetch_row(mysql_query($query));
			
				//$query = 'SELECT * FROM `tblUsersChores` INNER JOIN `tblChores` ON `tblUsersChores`.`chore_id` = `tblChores`.`id` WHERE `tblUsersChores`.`user_id` = "'. $user_res[0] .'" AND `tblChores`.`status_id` =4;';
				//$tot_res = mysql_query($query);				
				//$tot = mysql_num_rows($tot_res);
				
				$this->sendResponse(200, json_encode(array(
					"id" => $user_res[0], 
					"device_id" => $ua_id, 
					"username" => $user_res[1],
					"email" => $user_res[2],
					"pin" => $user_res[3],
					"points" => $user_res[4], 
					"type_id" => $user_res[5]
				)));
			}
			
			return (true);
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
				$query = 'SELECT `value` FROM `tblSyncCodes` WHERE `user_id` =0 ORDER BY RAND() LIMIT 0,1;';
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
                
				//$query = 'SELECT `id`, `master` FROM `tblDevices` WHERE `ua_id` = "'. $ua_id .'";';
                //$dev_row = mysql_fetch_row(mysql_query($query));
				$type_id = $row[1];
                
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
			
					//$query = 'SELECT * FROM `tblUsersRewards` INNER JOIN `tblRewards` ON `tblUsersRewards`.`reward_id` = `tblRewards`.`id` WHERE (`tblUsersRewards`.`giver_id` = "'. $id .'" OR `tblUsersRewards`.`reciever`.`id` = "'. $id .'") AND `tblRewards`.`status_id` =4;';
					//$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $id .'" AND `status_id` = "4" ORDER BY `added`;';
					//$tot_res = mysql_query($query);				
					//$tot mysql_num_rows($tot_res);

					// Return data, as JSON
					$result = array(
						"id" => $row[0], 
						"device_id" => $ua_id, 
						"sub_id" => "0", 
						"username" => $row[2], 
						"email" => $row[3], 
						"pin" => $row[4], 
						"points" => $row[5], 
						"type_id" => $type_id,
						"devices" => $dev_arr
					);
				
				} else {
                    
					//$query = 'SELECT * FROM `tblUsersChores` INNER JOIN `tblChores` ON `tblChores`.`id` = `tblUsersChores`.`chore_id` WHERE `tblUsersChores`.`sub_id` = "'. $dev_row[0] .'" AND `tblUsersChores`.`user_id` = "'. $id .'" AND `tblChores`.`status_id` = "4" ORDER BY `tblChores`.`added`;';
					//$tot_res = mysql_query($query);				
					//$tot = mysql_num_rows($tot_res);

					// Return data, as JSON
					$result = array(
						"id" => $row[0], 
						"device_id" => $ua_id, 
						"sub_id" => "", 
						"username" => $row[2], 
						"email" => $row[3], 
						"pin" => $row[4], 
						"points" => $row[5], 
						"type_id" => $type_id,
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
				
				$query = 'SELECT `tblDevices`.`ua_id` FROM `tblDevices` INNER JOIN `tblUsersDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblUsersDevices`.`user_id` = "'. $id .'";';
				$dev_row = mysql_fetch_row(mysql_query($query));
				
				
				
				$result = array(
					"id" => $row[0], 
					"device_id" => $dev_row[0], 
					"sub_id" => "", 
					"username" => $row[2], 
					"email" => $row[3], 
					"pin" => $row[4], 
					"points" => $row[5], 
					"type_id" => $row[1],
					"devices" => array()
				);

                $this->sendResponse(200, json_encode($result));

			} else
				$this->sendResponse(200, json_encode(array()));
			
			return (true);
		}
		
		function getDevices($user_id) {
			
			$query = 'SELECT `reciever_id` FROM `tblGiversRecievers` WHERE `giver_id` ="'. $user_id .'"';
			$reciever_res = mysql_query($query);
			$dev_arr = array();
			
			while ($reciever_row = mysql_fetch_array($reciever_res, MYSQL_BOTH)) {
				$query = 'SELECT * FROM `tblDevices` INNER JOIN `tblUsersDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblUsersDevices`.`user_id` = "'. $reciever_row[0] .'";';
				$dev_row = mysql_fetch_row(mysql_query($query));

				array_push($dev_arr, array(
					"id" => $dev_row[0],
					"uuid" => $dev_row[1], 
					"ua_id" => $dev_row[2], 
					"type_id" => $dev_row[3], 
					"os" => $dev_row[4], 
					"name" => $dev_row[5]
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
				if (isset($_POST["uaID"]) && isset($_POST['username']) && isset($_POST['pin']) && isset($_POST['uuID']) && isset($_POST['os']) && isset($_POST['model']) && isset($_POST['deviceName']) && isset($_POST['master']))
					$users->addNew($_POST['uaID'], $_POST['username'], $_POST['pin'], $_POST['uuID'], $_POST['os'], $_POST['model'], $_POST['deviceName'], $_POST['master']);
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
				
		   case "7":
				if (isset($_POST['userID']))
					$users->getDevices($_POST['userID']);
				break;
		}
	}
	//$userInfo_arr = $users->userInfoByFacebookID($fb_id);
?>