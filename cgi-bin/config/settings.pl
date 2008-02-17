$VAR1 = {
          'admin' => {
                       'firstname' => 'Dirk',
                       'email' => 'lindnerei@o2online.de',
                       'street' => 'example 33',
                       'name' => 'Lindner',
                       'town' => 'Berlin'
                     },
          'actions' => '/srv/www/cgi-bin//config/actions.pl',
          'tree' => {
                      'navigation' => '/srv/www/cgi-bin//config/tree.pl',
                      'links' => '/srv/www/cgi-bin//config/links.pl'
                    },
          'defaultAction' => 'news',
          'language' => 'en',
          'version' => '0.24',
          'cgi' => {
                     'bin' => '/srv/www/cgi-bin/',
                     'style' => 'Crystal',
                     'serverName' => 'http://localhost',
                     'cookiePath' => '/',
                     'title' => 'CGI::LZE',
                     'mod_rewrite' => '1',
                     'alias' => 'cgi-bin',
                     'DocumentRoot' => '/srv/www/htdocs',
                     'expires' => '+1y'
                   },
          'uploads' => {
                         'maxlength' => 2003153,
                         'path' => '/srv/www/htdocs/downloads/',
                         'chmod' => 420,
                         'enabled' => 1
                       },
          'translate' => '/srv/www/cgi-bin//config/translate.pl',
          'session' => '/srv/www/cgi-bin//config/session.pl',
          'config' => '/srv/www/cgi-bin//config/settings.pl',
          'scriptAlias' => 'cgi-bin'
        };
$settings =$VAR1;