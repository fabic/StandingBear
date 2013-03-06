<?php
/** www/default/htdocs/src/highlight.php
 *
 * F.2013-02-11 Mon.
 *
 */


$file = $_GET['file'];

# Read file and pass content through the Markdown parser
$text = file_get_contents($file);
$html = htmlentities($text);

$pageTitle = htmlentities(basename($file))
    . " [" . htmlentities(dirname($file)) . "]"
    . " | source code highlight filter (StandingBear)";
?>
<!DOCTYPE html>
<html>
<head>
    <title><?php echo $pageTitle?></title>
    <link rel="stylesheet" title="Default" href="/css/highlight.js/default.css">
    <style type='text/css'>
    .sb_heading {
        font-size: .8em;
        border-bottom: 1px dashed darkgrey;
        background-color: #d0e0ff;
    }
    </style>
    <script src="/js/highlight.pack.js"></script>
    <script type="text/javascript">
    //<![CDATA[
    hljs.tabReplace = '   ';
    hljs.initHighlightingOnLoad();
    //]]>
    </script>
</head>
<body>
<div class='sb_heading'>
    This is the source code highlighted rendering of :
    <?php echo htmlentities(realpath($file))?>
</div>

<!-- BEGIN: File content. -->
<pre><code><?php echo $html?></code></pre>
<!-- END: File content. -->
</body>
</html>
