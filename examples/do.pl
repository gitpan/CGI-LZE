#!/usr/bin/perl -w
use CGI::LZE;
use strict;
my $cgi = CGI::LZE->new();
$cgi->init("/srv/www/cgi-bin/config/settings.pl");
print $cgi->header;
if(param('include')) {
        $cgi->include();
        print $cgi->a({href => "$ENV{SCRIPT_NAME}"}, 'next');
        $cgi->clearSession();
} else {
        my %vars = (user => 'guest', action => 'main', file => "/srv/www/cgi-bin/examples/content.pl", sub => 'main');
        my $qstring = $cgi->createSession(\%vars);
        print qq(Action wurde erzeugt.);
        print $cgi->br(), $cgi->a({href => "$ENV{SCRIPT_NAME}?include=$qstring"}, 'next');
}

