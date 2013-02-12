<?php
/** www/default/htdocs/markdown.php
 *
 * F.2013-02-11 Mon.
 *
 * Adapted from Michel Fortin's Readme.php
 * @See https://github.com/michelf/php-markdown/blob/lib/Readme.php
 *
 * todo: Silex it ?
 *
 * @See http://michelf.ca/projects/php-markdown/
 * @See http://michelf.ca/projects/php-markdown/extra/
 */

# Install PSR-0-compatible class autoloader
//spl_autoload_register(function($class) {
//    require preg_replace('{\\\\|_(?!.*\\\\)}', DIRECTORY_SEPARATOR, ltrim($class, '\\')).'.php';
//});
// FIXME: temp.
require_once getenv('StandingBear') . "/local/php-markdown/Michelf/Markdown.php";
require_once getenv('StandingBear') . "/local/php-markdown/Michelf/MarkdownExtra.php";

# Get Markdown class
use \Michelf\Markdown;
use \Michelf\MarkdownExtra;

$file = $_GET['file'];
$theme = isset($_GET['theme']) ? $_GET['theme'] : '';

$theme = $theme ?: 'markdown6';

$cssBase = "/css/jasonm23-markdown-css-themes/";
$cssUri  = $cssBase . $theme . ".css";

/* todo: readdir... + impl.
$themeList = Array(
    'foghorn', 'markdark', 'swiss', 'markdown-alt', 'markdown',
    'markdown1', 'markdown2', 'markdown3', 'markdown4', 'markdown5', 'markdown6');
 */

# Read file and pass content through the Markdown parser
$text = file_get_contents($file);
$html = MarkdownExtra::defaultTransform($text);

$pageTitle = htmlentities(basename($file))
    . " [" . htmlentities(dirname($file)) . "]"
    . " | Markdown filtered (StandingBear)";
?>
<!DOCTYPE html>
<html>
<head>
    <title><?php echo $pageTitle?></title>
    <style type='text/css'>
    .sb_heading {
        font-size: .8em;
        border-bottom: 1px dashed darkgrey;
        background-color: #d0e0ff;
    }
    dt { font-weight: bold; }
    </style>
    <link href="<?php echo $cssUri?>" rel="stylesheet"></link>
</head>
<body>
    <div class='sb_heading'>
    This is the Markdown-filtered rendering of :
    <?php echo htmlentities(realpath($file))?>
    </div>

    <!-- BEGIN: Generated Markdown -->
    <?php echo $html; ?>
    <!-- END: Generated Markdown -->
</body>
</html>
