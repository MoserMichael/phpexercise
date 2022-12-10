<?php

require_once __DIR__ . "/../vendor/autoload.php";
require_once __DIR__  . "/DockerRest/DockerRest.php";

$image_id = $_GET['id'] ?? "";
$json = file_get_contents('php://input');
$json_data = json_decode($json, true);

fwrite(STDERR,"image: {$image_id} json: {$json}ֿ\n");

$api = new DockerRest\DockerEngineApi();
$stat = true;

list ($res, $body) = $api->containerCreate($json_data);
if ($res) {
    $create_resp = json_decode($body,JSON_OBJECT_AS_ARRAY);

    $container_id = $create_resp["Id"] ?? "";

    if ($container_id != "") {
        list ($res, $body) = $api->containerStart($container_id);
        if (!$res) {
            $body = "Can't start container. error: {$body}";
            $stat = false;
        }
    } else {
        $body = "No container id received. error: {$body}";
        $stat = false;
    }
} else {
    $body = "Can't create container error: {$body}";
    $stat = false;
}

$api->close();

if (!$stat) {
    http_response_code(501);
}
echo "$body";



