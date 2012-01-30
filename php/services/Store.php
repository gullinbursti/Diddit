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
					"itunes_id" => $row['itunes_id'], 
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
					"itunes_id" => $row['itunes_id'],  
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
					"itunes_id" => $row['itunes_id'], 
					"description" => $row['description'],
					"images" => $img_result
				));
			}
		}
		
		$this->sendResponse(200, json_encode($result));
		return (true);   
	}
	
	
	
	
	/**
	 * This service returns all jobs available
	 * @returns recordset
	 */
	function makePurchase($user_id, $sub_id, $store_id) {
           
		$query = 'SELECT `title`, `info`, `points`, `type_id` FROM `tblStore` WHERE `id` = "'. $store_id .'";';
		$row = mysql_fetch_row(mysql_query($query));
		$store_title = $row[0];
		$store_info = $row[1];
		$store_points = $row[2];
		$type_id = $row[3];
           
		$query = 'SELECT `device_id`, `email`, `pin`, `points` FROM `tblUsers` WHERE `id` = "'. $user_id .'";';
		$row = mysql_fetch_row(mysql_query($query));
		$user_points = $row[3] - $store_points;
		$device_id = $row[0];
		
		$query = 'SELECT * FROM `tblChores` WHERE `user_id` = "'. $user_id .'" AND `status_id` =4;';
		$tot_res = mysql_query($query);				
		$tot = mysql_num_rows($tot_res);
		
		$query = 'UPDATE `tblUsers` SET `points` ='. $user_points .' WHERE `id` ='. $user_id .';';
		$result = mysql_query($query);
		
		$query = 'INSERT INTO `tblStorePurchases` (';
		$query .= '`id`, `user_id`, `sub_id`, `store_id`, `added`) ';
		$query .= 'VALUES (NULL, "'. $user_id .'", "'. $sub_id .'", "'. $store_id .'", CURRENT_TIMESTAMP);';
		$result = mysql_query($query);
		$chore_id = mysql_insert_id();
		
		
		
		// Return data, as JSON
		$result = array(
			"id" => $user_id, 
			"device_id" => $device_id, 
			"username" => "", 
			"email" => $row[1], 
			"pin" => $row[2],
			"points" => $user_points, 
			"finished" => $tot 
		);
		
		//$d_id = '44a83c991875a327456f4c1a33622bd6d5a0cdb6d9b76289d60e8be131c95502';
		
		if ($type_id == 1)
			$msg = 'Your in-app good ('. $store_info . ') is available inside '. $store_name .'';
			
		else
			$msg = 'Your '. $store_info .' is now available';
		                  
		/*
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, 'https://go.urbanairship.com/api/push/');
		curl_setopt($ch, CURLOPT_USERPWD, "s12VbppFR2yIXDrIFAZegg:lC1GUQYQTxG141PZ1L4f6A");
		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_POSTFIELDS, '{"device_tokens": ["'. $device_id .'"], "type": "'. $type_id .'", "aps": {"alert": { "body": "'. $msg .'", "action-loc-key": "UA_PUSH"}, "badge": "+1"}}');
		                                               
		$res = curl_exec($ch);
		$err_no = curl_errno($ch);
		$err_msg = curl_error($ch);
		$header = curl_getinfo($ch);
		curl_close($ch);
		*/

		$this->sendResponse(200, json_encode($result));
	}
	
	
	function allPurchases($user_id, $sub_id) {
        
		if ($sub_id == "0") {
			$query = 'SELECT `tblStore`.`id`, `tblStore`.`title`, `tblStore`.`info`, `tblStore`.`dev_id`, `tblStore`.`points`, `tblStore`.`ico_url`, `tblStore`.`score`, `tblStore`.`itunes_id` FROM `tblStore` INNER JOIN `tblStorePurchases` ON `tblStore`.`id` = `tblStorePurchases`.`store_id` WHERE `tblStorePurchases`.`user_id` = "'. $user_id .'";';
			$res = mysql_query($query);
		
			// error performing query
			if (mysql_num_rows($res) > 0) {
				
				// Return data, as JSON
				$result = array();
		
				while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
					array_push($result, array(
						"id" => $row[0], 
						"title" => $row[1], 
						"info" => $row[2], 
						"dev_id" => $row[3], 
						"points" => $row[4], 
						"ico_url" => $row[5], 
						"score" => $row[6], 
						"itunes_id" => $row[7], 
						"description" => "",
						"images" => array()
					));
				}
		
				$this->sendResponse(200, json_encode($result));
				return (true);
		
			} else {
				$this->sendResponse(200, json_encode(array()));
				return (true);
			}
		
		} else {
			$query = 'SELECT `tblStore`.`id`, `tblStore`.`title`, `tblStore`.`info`, `tblStore`.`dev_id`, `tblStore`.`points`, `tblStore`.`ico_url`, `tblStore`.`score`, `tblStore`.`itunes_id` FROM `tblStore` INNER JOIN `tblStorePurchases` ON `tblStore`.`id` = `tblStorePurchases`.`store_id` WHERE `tblStorePurchases`.`user_id` = "'. $user_id .'" AND `tblStorePurchases`.`sub_id` = "'. $sub_id .'";';
			$res = mysql_query($query);
		
			// error performing query
			if (mysql_num_rows($res) > 0) {
				
				// Return data, as JSON
				$result = array();
		
				while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
					array_push($result, array(
						"id" => $row[0], 
						"title" => $row[1], 
						"info" => $row[2], 
						"dev_id" => $row[3], 
						"points" => $row[4], 
						"ico_url" => $row[5], 
						"score" => $row[6], 
						"itunes_id" => $row[7], 
						"description" => "",
						"images" => array()
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
	
	
	
	function creditPurchases($user_id) {

		$query = 'SELECT `tblStore`.`id`, `tblStore`.`title`, `tblStore`.`info`, `tblStore`.`dev_id`, `tblStore`.`points`, `tblStore`.`ico_url`, `tblStore`.`score`, `tblStore`.`itunes_id` FROM `tblStore` INNER JOIN `tblStorePurchases` ON `tblStore`.`id` = `tblStorePurchases`.`store_id` WHERE `tblStorePurchases`.`user_id` = "'. $user_id .'" AND `tblStore`.`type_id` =2;';
		$res = mysql_query($query);
		
		// error performing query
		if (mysql_num_rows($res) > 0) {
				
			// Return data, as JSON
			$result = array();
		
			while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
				array_push($result, array(
					"id" => $row[0], 
					"title" => $row[1], 
					"info" => $row[2], 
					"dev_id" => $row[3], 
					"points" => $row[4], 
					"ico_url" => $row[5], 
					"score" => $row[6], 
					"itunes_id" => $row[7], 
					"description" => "",
					"images" => array()
				));
			}
		
			$this->sendResponse(200, json_encode($result));
			return (true);
		
		} else {
			$this->sendResponse(200, json_encode(array()));
			return (true);
		}
	}
	
	
	
	function inAppPurchases($user_id) {

		$query = 'SELECT `tblStore`.`id`, `tblStore`.`title`, `tblStore`.`info`, `tblStore`.`dev_id`, `tblStore`.`points`, `tblStore`.`ico_url`, `tblStore`.`score`, `tblStore`.`itunes_id` FROM `tblStore` INNER JOIN `tblStorePurchases` ON `tblStore`.`id` = `tblStorePurchases`.`store_id` WHERE `tblStorePurchases`.`user_id` = "'. $user_id .'" AND `tblStore`.`type_id` =1;';
		$res = mysql_query($query);
		
		// error performing query
		if (mysql_num_rows($res) > 0) {
				
			// Return data, as JSON
			$result = array();
		
			while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
				array_push($result, array(
					"id" => $row[0], 
					"title" => $row[1], 
					"info" => $row[2], 
					"dev_id" => $row[3], 
					"points" => $row[4], 
					"ico_url" => $row[5], 
					"score" => $row[6], 
					"itunes_id" => $row[7], 
					"description" => "",
					"images" => array()
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
			if (isset($_POST['userID']) && isset($_POST['sub_id']) && isset($_POST['appID']))
				$store_json = $store->makePurchase($_POST['userID'], $_POST['sub_id'], $_POST['appID']);
			break;
			
		case 4:   
			if (isset($_POST['userID']) && isset($_POST['subID']))
				$store_json = $store->allPurchases($_POST['userID'], $_POST['subID']);
			break;
			
		case 5:
			if (isset($_POST['userID']))
				$store_json = $store->creditPurchases($_POST['userID']);
			break;
			
		case 6:
			if (isset($_POST['userID']))
				$store_json = $store->inAppPurchases($_POST['userID']);
			break;
	}
}
	
?>