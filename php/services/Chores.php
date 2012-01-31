<?php

	class Chores {	
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
	
		
		
		function activeByUserID($user_id, $sub_id) {
            
			if ($sub_id == "0") {

				$query = 'SELECT `tblChores`.`id`, `tblChores`.`title`, `tblChores`.`info`, `tblChores`.`ico_path`, `tblChores`.`img_path`, `tblChores`.`expires`, `tblRewardTypes`.`points`, `tblRewardTypes`.`cost`, `tblChores`.`type_id` FROM `tblChores` INNER JOIN `tblRewardTypes` ON `tblChores`.`iap_id` = `tblRewardTypes`.`id` INNER JOIN `tblUsersChores` ON `tblUsersChores`.`chore_id` = `tblChores`.`id` WHERE `tblUsersChores`.`user_id` ='. $user_id .' AND `tblChores`.`status_id` =2 ORDER BY `tblChores`.`added` DESC;';
				$res = mysql_query($query);
			
				// Return data, as JSON
				$result = array();
				
				// error performing query
				if (mysql_num_rows($res) > 0) {
				
					while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
						array_push($result, array(
							"id" => $row[0], 
							"title" => $row[1], 
							"info" => $row[2], 
							"icoPath" => $row[3], 
							"imgPath" => $row[4],
							"expires" => $row[5], 
							"points" => $row[6], 
							"cost" => $row[7], 
							"type_id" => $row[8]
						));
					}
				}
			
			} else {
				$query = 'SELECT `tblChores`.`id`, `tblChores`.`title`, `tblChores`.`info`, `tblChores`.`ico_path`, `tblChores`.`img_path`, `tblChores`.`expires`, `tblRewardTypes`.`points`, `tblRewardTypes`.`cost`, `tblChores`.`type_id` FROM `tblChores` INNER JOIN `tblRewardTypes` ON `tblChores`.`iap_id` = `tblRewardTypes`.`id` INNER JOIN `tblUsersChores` ON `tblUsersChores`.`chore_id` = `tblChores`.`id` WHERE `tblUsersChores`.`sub_id` = "'. $sub_id .'" AND `tblUsersChores`.`user_id` ='. $user_id .' AND `tblChores`.`status_id` =2 ORDER BY `tblChores`.`added` DESC;';
				$res = mysql_query($query);
			
				// Return data, as JSON
				$result = array();
				
				// error performing query
				if (mysql_num_rows($res) > 0) {
				
					while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
						array_push($result, array(
							"id" => $row[0], 
							"title" => $row[1], 
							"info" => $row[2], 
							"icoPath" => $row[3], 
							"imgPath" => $row[4],
							"expires" => $row[5], 
							"points" => $row[6], 
							"cost" => $row[7], 
							"type_id" => $row[8]
						));
					}
				}
			}
			
			$this->sendResponse(200, json_encode($result));
			return (true);  
		}
		
		
		
		function finishedByUserID($user_id) {

			$query = 'SELECT * FROM `tblChores` INNER JOIN `tblUsersChores` ON `tblChores`.`id` = `tblUsersChores`.`chore_id` WHERE `tblUsersChores`.`user_id` = "'. $user_id .'" AND `tblUsersChores`.`status_id` = "4" ORDER BY `tblUsersChores`.`added`;';
			$res = mysql_query($query);
			
			// Return data, as JSON
			$result = array(); 
				
			// error performing query
			if (mysql_num_rows($res) > 0) {
			    while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
					array_push($result, array(
						"id" => $row['id'], 
						"title" => $row['title'], 
						"info" => $row['info'], 
						"icoPath" => $row['ico_path'], 
						"imgPath" => $row['img_path'], 
						"finished" => "Y"
					));
				} 
			}
			
			$this->sendResponse(200, json_encode($result));
			return (true);   
		}
		
		function updStatusByUserID($user_id, $chore_id, $status_id) {
			
			$query = 'UPDATE `tblChores` SET `status_id` ='. $status_id .' WHERE `id` = "'. $chore_id .'";';
			$result = mysql_query($query);
			
			
			if ($status_id == 4) {
				$query = 'SELECT `tblDevices`.`ua_id` FROM `tblDevices` INNER JOIN `tblUsersDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblDevices`.`master` = "Y" AND `tblUsersDevices`.`user_id`='. $user_id .'';
				$row = mysql_fetch_row(mysql_query($query));
				
				$ch = curl_init();
				curl_setopt($ch, CURLOPT_URL, 'https://go.urbanairship.com/api/push/');
				curl_setopt($ch, CURLOPT_USERPWD, "s12VbppFR2yIXDrIFAZegg:lC1GUQYQTxG141PZ1L4f6A");
				curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
				curl_setopt($ch, CURLOPT_POST, 1);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
				//curl_setopt($ch, CURLOPT_POSTFIELDS, '{"device_tokens": ["'. $device_id .'"], "type": "'. $type_id .'", "aps": {"alert": { "body": "'. $msg .'", "action-loc-key": "UA_PUSH"}, "badge": "+1"}}');
				curl_setopt($ch, CURLOPT_POSTFIELDS, '{"device_tokens": ["'. $row[0] .'"], "type": "2", "aps": {"alert": { "body": "Chore Added ('. $chore_title .')"}, "badge": "+1"}}');				
			}
			
			
			return (true);
		}
		
		
		function addNew($user_id, $subs_id, $iap_id, $chore_title, $chore_info, $cost, $expires, $image, $type_id) {
			//echo ("user_id:[". $user_id ."] subs_ID:[". $subs_ID ."] iap_id:[". $iap_id ."] chore_title:[". $chore_title ." chore_info:[". $chore_info ."] cost:[". $cost ."] expires:[". $expires ."] image:[". $image ."] type_id:[". $type_id ."]");
			
			$query = 'SELECT `id`, `points` FROM `tblRewardTypes` WHERE `cost` = "'. $cost .'";';
			$row = mysql_fetch_row(mysql_query($query));

			// has entry
			if ($row) {
                $iap_id = $row[0];
				$points = $row[1];
			
			} else {
				$iap_id = 0;
				$points = 0;
			}
			
			
			$query = 'INSERT INTO `tblChores` (';
			$query .= '`id`, `iap_id`, `title`, `info`, `ico_path`, `img_path`, `type_id`, `status_id`, `expires`, `added`, `modified`) ';
			$query .= 'VALUES (NULL, "'. $iap_id .'", "'. $chore_title .'", "'. $chore_info .'", "", "'. $image .'", "'. $type_id .'", "2", "'. $expires .'", NOW(), CURRENT_TIMESTAMP);';
			$result = mysql_query($query); 
			$chore_id = mysql_insert_id();
			
			$device_tokens = '[';
			foreach (explode("|", $subs_id) as $sub_id) {
				
				$query = 'INSERT INTO `tblUsersChores` (';
				$query .= '`user_id`, `sub_id`, `chore_id`) ';
				$query .= 'VALUES ("'. $user_id .'", "'. $sub_id .'", "'. $chore_id .'");';
				$result = mysql_query($query);
				
				$query = 'SELECT `tblDevices`.`ua_id` FROM `tblDevices` INNER JOIN `tblUsersDevices` ON `tblUsersDevices`.`device_id` = `tblDevices`.`id` WHERE `tblDevices`.`master` = "N" AND `tblUsersDevices`.`user_id` ='. $user_id .' AND `tblDevices`.`id` ='. $sub_id .';';
				$dev_row = mysql_fetch_row(mysql_query($query));
				$device_tokens .= '"'. $dev_row[0] .'", ';
			}
				
			$device_tokens = substr($device_tokens, 0, -2) .']';
			
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, 'https://go.urbanairship.com/api/push/');
			curl_setopt($ch, CURLOPT_USERPWD, "s12VbppFR2yIXDrIFAZegg:lC1GUQYQTxG141PZ1L4f6A");
			curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
			curl_setopt($ch, CURLOPT_POST, 1);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			//curl_setopt($ch, CURLOPT_POSTFIELDS, '{"device_tokens": ["'. $device_id .'"], "type": "'. $type_id .'", "aps": {"alert": { "body": "'. $msg .'", "action-loc-key": "UA_PUSH"}, "badge": "+1"}}');
			curl_setopt($ch, CURLOPT_POSTFIELDS, '{"device_tokens": '. $device_tokens .', "type": "1", "aps": {"alert": { "body": "Chore Added ('. $chore_title .')"}, "badge": "+1"}}');
			
			//$ch = curl_init();
			//curl_setopt($ch, CURLOPT_URL, 'https://go.urbanairship.com/api/push/');
			//curl_setopt($ch, CURLOPT_USERPWD, "s12VbppFR2yIXDrIFAZegg:lC1GUQYQTxG141PZ1L4f6A");
			//curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
			//curl_setopt($ch, CURLOPT_POST, 1);
			//curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			//curl_setopt($ch, CURLOPT_POSTFIELDS, '{"device_tokens": ["'. $device_id .'"], "type": "'. $type_id .'", "aps": {"alert": { "body": "'. $msg .'", "action-loc-key": "UA_PUSH"}, "badge": "+1"}}');
			//curl_setopt($ch, CURLOPT_POSTFIELDS, '{"device_tokens": ["'. $device_id .'"], "type": "'. $type_id .'", "aps": {"alert": { "body": "'. $msg .'"}, "badge": "+1"}}');
		                                               
			$res = curl_exec($ch);
			$err_no = curl_errno($ch);
			$err_msg = curl_error($ch);
			$header = curl_getinfo($ch);
			curl_close($ch);
			
			
			$this->sendResponse(200, json_encode(array(
				"id" => $chore_id, 
				"title" => $chore_title, 
				"info" => $chore_info, 
				"icoPath" => "", 
				"imgPath" => $image,
				"expires" => $expires, 
				"points" => $points, 
				"cost" => $cost, 
				"type_id" => $type_id
			)));
			
			return (true);
		}
	}
	
	$chores = new Chores;
	
	//$user_id= "2";
	//$chores->availByUserID($user_id);
	
	if (isset($_POST["action"])) {
		switch ($_POST["action"]) {
			case "1":
				if (isset($_POST["userID"]) && isset($_POST['subID']))
					 $chores_json = $chores->activeByUserID($_POST["userID"], $_POST['subID']);
				break;
				
			case "2":
				if (isset($_POST["userID"]))
					 $chores_json = $chores->finishedByUserID($_POST["userID"]);
				break;
				
			case "3":
				if (isset($_POST["userID"]) && isset($_POST['choreID']))
					 $chores_json = $chores->updStatusByUserID($_POST["userID"], $_POST['choreID'], 1);
				break;
				
			case "4":
				if (isset($_POST["userID"]) && isset($_POST['choreID']))
					 $chores_json = $chores->updStatusByUserID($_POST["userID"], $_POST['choreID'], 2);
				break;
				
			case "5":
				if (isset($_POST["userID"]) && isset($_POST['choreID']))
					 $chores_json = $chores->updStatusByUserID($_POST["userID"], $_POST['choreID'], 3);
				break;
				
			case "6":
				if (isset($_POST["userID"]) && isset($_POST['choreID']))
					 $chores_json = $chores->updStatusByUserID($_POST["userID"], $_POST['choreID'], 4);
				break;
				
		   case "7":
				if (isset($_POST["userID"]) && isset($_POST['subIDs']) && isset($_POST['iapID']) && isset($_POST['choreTitle']) && isset($_POST['choreInfo']) && isset($_POST['cost']) && isset($_POST['expires']) && isset($_POST['image']) && isset($_POST['type_id']))
					 $chores_json = $chores->addNew($_POST['userID'], $_POST['subIDs'], $_POST['iapID'], $_POST['choreTitle'], $_POST['choreInfo'], $_POST['cost'], $_POST['expires'], $_POST['image'], $_POST['type_id']);
				break;
		}
	}   
	
	//if (isset($_POST["fbid"])) {
	//    $fb_id = $_POST["fbid"];
	//	$userInfo_arr = $jobs->jobSearch($fb_id);
	//}
?>