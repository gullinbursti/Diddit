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
	
		
		function addNew($device_id, $email, $pin) {

			$query = 'SELECT `id`, `device_id`, `username`, `email`, `pin`, `points` FROM `tblUsers` WHERE `device_id` = "'. $device_id .'";';
			$res = mysql_fetch_row(mysql_query($query));

			// doesn't exists
			if (!$res) {
				$query = 'INSERT INTO `tblUsers` (';
				$query .= '`id`, `device_id`, `username`, `email`, `pin`, `points`, `added`, `modified`) ';
				$query .= 'VALUES (NULL, "'. $device_id .'", "", "'. $email .'", "'. $pin .'", 0, NOW(), CURRENT_TIMESTAMP);';
				$result = mysql_query($query);
			    $user_id = mysql_insert_id();
				
				// Return data, as JSON
				$result = array(
					"id" => $user_id, 
					"device_id" => $device_id, 
					"username" => "", 
					"email" => $email, 
					"pin" => $pin,
					"points" => 0, 
					"finished" => 0 
				);

				$this->sendResponse(200, json_encode($result));

			} else {
				$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $user_id .'" AND `status_id` = "4" ORDER BY `added`;';
				$tot_res = mysql_query($query);				
				$tot = mysql_num_rows($tot_res);
				
				$this->sendResponse(200, json_encode(array(
					"id" => $res[0], 
					"device_id" => $res[1], 
					"username" => $res[2],
					"email" => $res[3],
					"pin" => $res[4],
					"points" => $res[5], 
					"finished" => $tot
				)));
			}
			
			return (true);
		}
		
		
		
		function getByID($id) {

			$query = 'SELECT * FROM `tblUsers` WHERE `id` = "'. $id .'";';
			$row = mysql_fetch_row(mysql_query($query));

			// has user
			if ($row) {
                
				$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $id .'" AND `status_id` = "4" ORDER BY `added`;';
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
					"finished" => $tot
				);

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
                
				$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $id .'" AND `status_id` = "4" ORDER BY `added`;';
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
	}
	
	
	$users = new Users;
	
	
	//$device_id = '58fd9edd83341c29f1aebba81c31e25758fd9edd83341c29f1aebba81c31e257';	
	//$users->addNew($device_id);
	
	
	if (isset($_POST['action'])) {
		switch ($_POST['action']) {
			case "0":
				if (isset($_POST["deviceID"]) && isset($_POST['email']) && isset($_POST['pin']))
					$users->addNew($_POST['deviceID'], $_POST['email'], $_POST['pin']);
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
					$users->addPoints($_POST["userID"], $_POST["points"]);
				break; 
		}
	}
	//$userInfo_arr = $users->userInfoByFacebookID($fb_id);
?>