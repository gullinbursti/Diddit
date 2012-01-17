<?php

class Store {
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
		
	function partnerApps($user_id) {   
		
		$query = 'SELECT * FROM `tblStore` WHERE `feature` ="N" ORDER BY `points`;';
		$res = mysql_query($query);
		
		// Return data, as JSON
		$result = array(); 
			
		// error performing query
		if (mysql_num_rows($res) > 0) {
			
			while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
				$query = 'SELECT `tblImages`.`type_id`, `tblImages`.`url` FROM `tblImages` INNER JOIN `tblStoreImages` ON `tblImages`.`id` = `tblStoreImages`.`image_id` WHERE `tblStoreImages`.`store_id` ='. $row['id'] .';';
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
					"info" => $row['info'], 
					"dev_id" => $row['dev_id'],
					"type_id" => $row['type_id'], 
					"points" => $row['points'], 
					"ico_url" => $row['ico_url'],
					"img_url" => "", 
					"score" => $row['score'],
					"description" => $row['description'],
					"images" => $img_result
				));
			}
		}
		
		$this->sendResponse(200, json_encode($result));
		return (true);   
	}
	
	
	function featureApps($user_id) {
		$query = 'SELECT * FROM `tblStore` WHERE `feature` ="Y" ORDER BY `points`;';
		$res = mysql_query($query);
		
		// Return data, as JSON
		$result = array(); 
			
		// error performing query
		if (mysql_num_rows($res) > 0) {
			
			while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {				
				$query = 'SELECT `tblImages`.`type_id`, `tblImages`.`url` FROM `tblImages` INNER JOIN `tblStoreImages` ON `tblImages`.`id` = `tblStoreImages`.`image_id` WHERE `tblStoreImages`.`store_id` ='. $row['id'] .';';
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
					"info" => $row['info'], 
					"dev_id" => $row['dev_id'], 
					"type_id" => $row['type_id'], 
					"points" => $row['points'], 
					"ico_url" => $row['ico_url'],
					"img_url" => $row['img_url'], 
					"score" => $row['score'], 
					"description" => $row['description'], 
					"images" => $img_result
				));
			}
		}
		
		$this->sendResponse(200, json_encode($result));
		return (true);
	}
	
	function giftCards() {   
		
		$query = 'SELECT * FROM `tblStore` WHERE `type_id` =2 ORDER BY `points`;';
		$res = mysql_query($query);
		
		// Return data, as JSON
		$result = array(); 
			
		// error performing query
		if (mysql_num_rows($res) > 0) {
			
			while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
				$query = 'SELECT `tblImages`.`type_id`, `tblImages`.`url` FROM `tblImages` INNER JOIN `tblStoreImages` ON `tblImages`.`id` = `tblStoreImages`.`image_id` WHERE `tblStoreImages`.`store_id` ='. $row['id'] .';';
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
					"info" => $row['info'], 
					"dev_id" => $row['dev_id'], 
					"points" => $row['points'], 
					"ico_url" => $row['ico_url'], 
					"score" => $row['score'],
					"description" => $row['description'],
					"images" => $img_result
				));
			}
		}
		
		$this->sendResponse(200, json_encode($result));
		return (true);   
	} 
	
	function purchaseApp($user_id, $app_id, $points) {
		$query = 'SELECT `points` FROM `tblUsers` WHERE `id` = "'. $user_id .'";';
		$row = mysql_fetch_row(mysql_query($query));
		$points = $row[0] - $points;
			
		$query = 'UPDATE `tblUsers` SET `points` ='. $points .' WHERE `id` ='. $user_id .';';
		$result = mysql_query($query);
		
		
		// Return data, as JSON
		$result = array(
			"success" => "true" 
		);

		$this->sendResponse(200, json_encode($result));
		return (true);
	}
}

	
$store = new Store;

if (isset($_POST["action"])) {
	switch ($_POST["action"]) {
		case 0:
			if (isset($_POST['userID']))
				$store_json = $store->partnerApps($_POST['userID']);
			break;
		
		case 1:
		   if (isset($_POST['userID']))
				$store_json = $store->featureApps($_POST['userID']);
			break;
			
		case 2:   
			$store_json = $store->giftCards();
			break;
				
	    case 3:
			if (isset($_POST['userID']) && isset($_POST['appID']) && isset($_POST['points']))
			$store_json = $store->purchaseApp($_POST['userID'], $_POST['appID'], $_POST['points']);
			break;
	}
}
	
?>