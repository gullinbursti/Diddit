<?php

	class Offers {	
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
	
		
		
		function getAll() {

			$query = 'SELECT * FROM `tblOffers`;';
			$res = mysql_query($query);
			
			// Return data, as JSON
			$result = array();
				
			// error performing query
			if (mysql_num_rows($res) > 0) {
				
				while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
					
					$query = 'SELECT `tblImages`.`type_id`, `tblImages`.`url` FROM `tblImages` INNER JOIN `tblOffersImages` ON `tblImages`.`id` = `tblOffersImages`.`image_id` WHERE `tblOffersImages`.`offer_id` ='. $row['id'] .';';
					$img_res = mysql_query($query);
					$img_result = array();
			
					while ($img_row = mysql_fetch_array($img_res, MYSQL_BOTH)) {
						array_push($img_result, array(
							"type" => $img_row[0],
							"url" => $img_row[1]
						));
					}
				
				
					array_push($result, array(
						"id" => $row['id'], 
						"title" => $row['title'],
						"name" => $row['app_name'], 
						"info" => $row['info'], 
						"itunes_id" => $row['itunes_id'], 
						"points" => $row['points'],
						"ico_url" => $row['ico_url'], 
						"img_url" => $row['img_url'], 
						"video_url" => $row['video_url'],
						"score" => $row['score'], 
						"images" => $img_result
					));
				}
			}
			
			$this->sendResponse(200, json_encode($result));
			return (true);  
		}
		
		function complete($user_id, $offer_id) {
            
			$query = 'SELECT `points` FROM `tblOffers` WHERE `id` = "'. $offer_id .'";';
			$row = mysql_fetch_row(mysql_query($query));
			$offer_points = $row[0];
            
			$query = 'SELECT `device_id`, `email`, `pin`, `points` FROM `tblUsers` WHERE `id` = "'. $user_id .'";';
			$row = mysql_fetch_row(mysql_query($query));
			$user_points = $row[3] + $offer_points;
			
			$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $user_id .'" AND `status_id` =4;';
			$tot_res = mysql_query($query);				
			$tot = mysql_num_rows($tot_res);
			
			$query = 'UPDATE `tblUsers` SET `points` ='. $user_points .' WHERE `id` ='. $user_id .';';
			$result = mysql_query($query);
			
			$query = 'INSERT INTO `tblOffersCompleted` (';
			$query .= '`id`, `user_id`, `offer_id`, `added`) ';
			$query .= 'VALUES (NULL, "'. $user_id .'", "'. $offer_id .'", CURRENT_TIMESTAMP);';
			$result = mysql_query($query);
			$chore_id = mysql_insert_id();
			
			// Return data, as JSON
			$result = array(
				"id" => $user_id, 
				"device_id" => $row[0], 
				"username" => "", 
				"email" => $row[1], 
				"pin" => $row[2],
				"points" => $user_points, 
				"finished" => $tot 
			);

			$this->sendResponse(200, json_encode($result));
		}
	}
	
	$offers = new Offers;
	
	if (isset($_POST["action"])) {
		switch ($_POST["action"]) {
			case "1":
				$offers_json = $offers->getAll();
				break;
				
			case "2":
				if (isset($_POST['userID']) && isset($_POST['offerID']))
				$offers_json = $offers->complete($_POST['userID'], $_POST['offerID']);
				break;
		}
	}   
?>