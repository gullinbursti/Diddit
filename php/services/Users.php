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
	
		
		
		
		function addNew($device_id) {

			$query = 'SELECT `id` FROM `tblUsers` WHERE `device_id` = "'. $device_id .'";';
			$res = mysql_fetch_row(mysql_query($query));

			// doesn't exists
			if (!$res) {
				$query = 'INSERT INTO `tblUsers` (';
				$query .= '`id`, `device_id`, `username`, `email`, `pin`, `points`, `added`, `modified`) ';
				$query .= 'VALUES (NULL, "'. $device_id .'", "", "", "0000", 0, NOW(), CURRENT_TIMESTAMP);';
				$result = mysql_query($query);
			    $user_id = mysql_insert_id();
			
				$query = 'SELECT * FROM `tblChores` ORDER BY `id`;';
				$res = mysql_query($query);
				
				while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
					$query = 'INSERT INTO `tblUsersChores` (';
					$query .= '`user_id`, `chore_id`, `isCustom`, `status_id`, `added`) ';
					$query .= 'VALUES ("'. $user_id .'", "'. $row['id'] .'", "N", "1", CURRENT_TIMESTAMP);';
					$result = mysql_query($query);
					$chore_id = mysql_insert_id();
				}
				
				// Return data, as JSON
				$result = array(
					"id" => $user_id 
				);

				$this->sendResponse(200, json_encode($result));
				return (true);

			} else {
				$this->sendResponse(200, json_encode(array()));
				return (true);
			}
		}
		
		
		
		function getByID($id) {

			$query = 'SELECT * FROM `tblUsers` WHERE `id` = "'. $id .'";';
			$row = mysql_fetch_row(mysql_query($query));

			// has user
			if ($row) {

				// Return data, as JSON
				$result = array(
					"id" => $row[0], 
					"device_id" => $row[1], 
					"username" => $row[2], 
					"email" => $row[3], 
					"pin" => $row[4], 
					"points" => $row[5]
				);

				$this->sendResponse(200, json_encode($result));
				return (true);

			} else {
				$this->sendResponse(200, json_encode(array()));
				return (true);
			}
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
		
		function updatePoints($id, $amt) {
			
			$query = 'SELECT `points` FROM `tblUsers` WHERE `id` = "'. $id .'";';
			$row = mysql_fetch_row(mysql_query($query));
			$points = $row[0] + $amt;
			
			$query = 'UPDATE `tblUsers` SET `points` ='. $points .' WHERE `id` ='. $id .';';
			$result = mysql_query($query);
			
			$query = 'SELECT `worth` FROM `tblUsers` WHERE `id` = "'. $id .'";';
			$row = mysql_fetch_row(mysql_query($query));
			$worth = $row[0] - ($amt * 0.01);
			
			$query = 'UPDATE `tblUsers` SET `worth` ='. $worth .' WHERE `id` ='. $id .';';
			$result = mysql_query($query); 
			
			return (true);
		}
	}
	
	
	$users = new Users;
	
	
	//$device_id = '58fd9edd83341c29f1aebba81c31e25758fd9edd83341c29f1aebba81c31e257';	
	//$users->addNew($device_id);
	
	
	if (isset($_POST['action'])) {
		switch ($_POST['action']) {
			case "0":
				if (isset($_POST["deviceID"]))
					$users->addNew($_POST['deviceID']);
				break;
				
			case "1":
				if (isset($_POST["userID"]))
					$users->getByID($_POST["userID"]);
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
					$users->updatePoints($_POST["userID"], $_POST["points"]);
				break; 
		}
	}
	//$userInfo_arr = $users->userInfoByFacebookID($fb_id);
?>