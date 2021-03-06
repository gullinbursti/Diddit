<?php

	class Achievements {	
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
	
		
		function addAchievement($user_id, $type_id, $chore_id) {

			$query = 'INSERT INTO `tblPurchases` (';
			$query .= '`id`, `user_id`, `type_id`, `chore_id`, `added`) ';
			$query .= 'VALUES (NULL, "'. $user_id .'", "'. $type_id .'", "'. $chore_id .'", CURRENT_TIMESTAMP);';
			$result = mysql_query($query);
			$chore_id = mysql_insert_id();
		}
		
		
		function achievementsByUserID($user_id) {

			$query = 'SELECT `tblAchievements`.`id`, `tblAchievementTypes`.`title`, `tblAchievementTypes`.`ico_path`, `tblAchievementTypes`.`img_path` FROM `tblAchievements` INNER JOIN `tblAchievementTypes` ON `tblAchievements`.`type_id` = `tblAchievementTypes`.`id` WHERE `tblAchievements`.`user_id` = "'. $user_id .'";';
			$res = mysql_query($query);
			
			// error performing query
			if (mysql_num_rows($res) > 0) {
					
				// Return data, as JSON
				$result = array();
			
				while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
					array_push($result, array(
						"id" => $row['id'], 
						"title" => $row['title'], 
						"icoPath" => $row['ico_path'], 
						"imgPath" => $row['img_path']  
					));
				}
			
				$this->sendResponse(200, json_encode($result));
				return (true);
			
			} else {
				$this->sendResponse(200, json_encode(array()));
				return (true);
			}
		}
	}
	
	$achievements = new Achievements;
	
	//$user_id= "2";
	//$chores->availByUserID($user_id);
	
	if (isset($_POST["action"])) {
		switch ($_POST["action"]) {
			case "0": 
				if (isset($_POST["userID"]))
					 $achievements_json = $achievements->achievementsByUserID($_POST["userID"]);
				break;
				
			case "1":
				if (isset($_POST["userID"]) && isset($_POST['typeID']) && isset($_POST['choreID']))
					 $achievements_json = $achievements->addAchievement($_POST["userID"], $_POST['typeID'], $_POST['choreID']);
				break;
		}
	}   
	
	//if (isset($_POST["fbid"])) {
	//    $fb_id = $_POST["fbid"];
	//	$userInfo_arr = $jobs->jobSearch($fb_id);
	//}
?>