<?php

	class Sponsorships {	
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

			$query = 'SELECT * FROM `tblSponsorships` where `active` = "Y";';
			$res = mysql_query($query);
			
			// Return data, as JSON
			$result = array();
				
			// error performing query
			if (mysql_num_rows($res) > 0) {
				while ($row = mysql_fetch_array($res, MYSQL_BOTH)) {
					switch ($row['type_id']) {
						case "1":
						
							$query = 'SELECT * FROM `tblOffers` WHERE `id` ='. $row['ref_id'] .';';
							$offer_row = mysql_fetch_row(mysql_query($query));
						
							$query = 'SELECT `tblImages`.`type_id`, `tblImages`.`url` FROM `tblImages` INNER JOIN `tblOffersImages` ON `tblImages`.`id` = `tblOffersImages`.`image_id` WHERE `tblOffersImages`.`offer_id` ='. $offer_row[0] .';';
							$img_res = mysql_query($query);
							$img_result = array();
			
							while ($img_row = mysql_fetch_array($img_res, MYSQL_BOTH)) {
								array_push($img_result, array(
									"type" => $img_row[0],
									"url" => $img_row[1]
								));
							}
						
							array_push($result, array(
								"sponsorship_id" => $row['id'], 
								"sponsorship_img" => $row['img_url'], 
								"type_id" => $row['type_id'], 
								"offer" => array(
									"id" => $offer_row[0], 
									"title" => $offer_row[1],
									"name" => $offer_row[3], 
									"info" => $offer_row[2], 
									"itunes_id" => $offer_row[4], 
									"points" => $offer_row[8],
									"ico_url" => $offer_row[5], 
									"img_url" => $offer_row[6], 
									"video_url" => $offer_row[7],
									"images" => $img_result)
							));
							break;
							
						case "2":
							$query = 'SELECT * FROM `tblStore` WHERE `id` ='. $row['ref_id'] .';';
							$store_row = mysql_fetch_row(mysql_query($query));
						
							$query = 'SELECT `tblImages`.`type_id`, `tblImages`.`url` FROM `tblImages` INNER JOIN `tblStoreImages` ON `tblImages`.`id` = `tblStoreImages`.`image_id` WHERE `tblStoreImages`.`store_id` ='. $store_row[0] .';';
							$img_res = mysql_query($query);
							$img_result = array();
			
							while ($img_row = mysql_fetch_array($img_res, MYSQL_BOTH)) {
								array_push($img_result, array(
									"type" => $img_row[0],
									"url" => $img_row[1]
								));
							}
						
							array_push($result, array(
								"sponsorship_id" => $row['id'], 
								"sponsorship_img" => $row['img_url'], 
								"type_id" => $row['type_id'], 
								"store" => array(
									"id" => $store_row[0], 
									"title" => $store_row[1], 
									"info" => $store_row[2], 
									"dev_id" => $store_row[3],
									"type_id" => $store_row[4], 
									"points" => $store_row[6], 
									"ico_url" => $store_row[8],
									"img_url" => $store_row[9], 
									"itunes_id" => $store_row[7], 
									"score" => $store_row[10],
									"description" => $store_row[11],
									"images" => $img_result)
							));
							break;
					}
				}
			}
			
			$this->sendResponse(200, json_encode($result));
			return (true);  
		}
	}
	
	$sponsorships = new Sponsorships;
	
	if (isset($_POST["action"])) {
		switch ($_POST["action"]) {
			case "1":
				$sponsorships_json = $sponsorships->getAll();
				break;
		}
	}   
?>