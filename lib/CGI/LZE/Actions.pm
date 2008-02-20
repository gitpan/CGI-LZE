package CGI::LZE::Actions;
use strict;
use warnings;
require Exporter;
use vars qw($actions $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::LZE::Actions::EXPORT = qw(loadActions saveActions $actions);
use CGI::LZE::Config;
@CGI::LZE::Actions::ISA     = qw( Exporter CGI::LZE::Config);
$CGI::LZE::Actions::VERSION = '0.26';
$DefaultClass               = 'CGI::LZE::Actions' unless defined $CGI::LZE::Actions::DefaultClass;
$defaultconfig              = '%CONFIG%';

=head1 NAME

CGI::LZE::Actions

=head1 SYNOPSIS


=head1 DESCRIPTION

Actions for CGI::LZE.

=head2 EXPORT

loadActions() saveActions() $actions

=head1 Public

=head2 new

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 loadActions

=cut

sub loadActions {
        my ($self, @p) = getSelf(@_);
        my $do = (defined $p[0]) ? $p[0] : $defaultconfig;
        if(-e $do) {
                do $do;
        }
}

=head2 saveActions

=cut

sub saveActions {
        my ($self, @p) = getSelf(@_);
        $self->SUPER::saveConfig(@p, $actions, 'actions');
}

=head1 Private

=head2 getSelf

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::LZE::Actions');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::LZE::Actions' || UNIVERSAL::isa($_[0], 'CGI::LZE::Actions'))) ? @_ : ($CGI::LZE::Actions::DefaultClass->new, @_);
}

=head2 see Also

L<CGI> L<CGI::LZE::Actions> L<CGI::LZE::Translate> L<CGI::LZE::Settings> L<CGI::LZE::Config>

=head1 AUTHOR

Dirk Lindner <lindnerei@o2online.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005-2008 by Hr. Dirk Lindner

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public License
as published by the Free Software Foundation; 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

=cut

1;
