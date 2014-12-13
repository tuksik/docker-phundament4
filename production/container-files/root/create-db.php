<?php
/**
 * @link http://www.diemeisterei.de/
 * @copyright Copyright (c) 2014 diemeisterei GmbH, Stuttgart
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

$host = getenv("DB_PORT_3306_TCP_ADDR");
$port = getenv("DB_PORT_3306_TCP_PORT");

$root          = 'root';
$root_password = getenv("DB_ENV_MYSQL_ROOT_PASSWORD");

$user = getenv("DB_ENV_MYSQL_USER");
$pass = getenv("DB_ENV_MYSQL_PASSWORD");
$db   = getenv("DB_ENV_MYSQL_DATABASE");

try {
    $dbh = new PDO("mysql:host=$host;port=$port", $root, $root_password);

    $dbh->exec(
        "CREATE DATABASE IF NOT EXISTS `$db`;
         GRANT ALL ON `$db`.* TO '$user'@'%' IDENTIFIED BY '$pass';
         FLUSH PRIVILEGES;"
    )
    or die(print_r($dbh->errorInfo(), true));

} catch (PDOException $e) {
    die("DB ERROR: " . $e->getMessage());
}
?>