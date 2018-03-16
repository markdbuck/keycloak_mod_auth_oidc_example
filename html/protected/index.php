<html>
  <body>
    <h1>Hello, <?php echo($_SERVER['REMOTE_USER']) ?></h1>
    <pre><?php print_r(apache_request_headers()); ?></pre>
    <a href="restricted/index.php">Access mod_oidc restricted page</a><br/>
    <a href="../">back to index</a>
    <a href="/protected/redirect_uri?logout=<?php echo ("http" . (isset($_SERVER['HTTPS']) ? 's' : '') . "://". $_SERVER['HTTP_HOST'] . "/") ?>">Logout</a>
  </body>
</html>
~
