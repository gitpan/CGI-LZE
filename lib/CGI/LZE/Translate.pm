package CGI::LZE::Translate;
use strict;
use warnings;
require Exporter;
use vars qw($ACCEPT_LANGUAGE $lang $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::LZE::Translate::EXPORT = qw(loadTranslate saveTranslate $lang);
use CGI::LZE::Config;
@ISA                          = qw(Exporter CGI::LZE::Config);
$CGI::LZE::Translate::VERSION = '0.26';
$DefaultClass                 = 'CGI::LZE::Translate' unless defined $CGI::LZE::Translate::DefaultClass;
$defaultconfig                = '%CONFIG%';

=head1 NAME

CGI::LZE::Translate

=head1 SYNOPSIS

        use CGI::LZE::Translate;

        use vars qw($lang);

        loadTranslate("/srv/www/cgi-bin/config/translate.pl");

        *lang = \$CGI::LZE::Translate::lang;

        print $lang->{de}{firstname};  #'Vorname'

=head1 DESCRIPTION

Translations for CGI::LZE.

=head2 EXPORT

loadTranslate() saveTranslate() $lang

=head1 Public

=head2 new()

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 loadTranslate()

=cut

sub loadTranslate {
        my ($self, @p) = getSelf(@_);
        my $do = (defined $p[0]) ? $p[0] : $defaultconfig;
        if(-e $do) {
                do $do;
        }
}

=head2  saveTranslate()

=cut

sub saveTranslate {
        my ($self, @p) = getSelf(@_);
        my $l = defined $p[0] ? $p[0] : $defaultconfig;
        $self->SUPER::saveConfig($l, $lang, 'lang');
}

=head1 Private

=head2 getSelf()

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::LZE::Translate');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::LZE::Translate' || UNIVERSAL::isa($_[0], 'CGI::LZE::Translate'))) ? @_ : ($CGI::LZE::Translate::DefaultClass->new, @_);
}

=head2 see Also

L<CGI> L<CGI::LZE> L<CGI::LZE::Actions> L<CGI::LZE::Translate> L<CGI::LZE::Settings> L<CGI::LZE::Config>

=head1 AUTHOR

Dirk Lindner <lindnerei@o2online.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Hr. Dirk Lindner

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public License
as published by the Free Software Foundation; 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

=cut

1;
