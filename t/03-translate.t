use lib qw(lib/);
use strict;
use vars qw($lang);
use Test::More tests => 2;
use CGI::LZE::Translate;
loadTranslate("cgi-bin/config/translate.pl");
*lang = \$CGI::LZE::Translate::lang;
ok($lang->{de}{firstname} eq 'Vorname');
ok($lang->{en}{username}  eq 'User');
