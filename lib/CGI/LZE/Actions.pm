package CGI::LZE::Actions;
# use strict;
# use warnings;
require Exporter;
use vars qw($actions $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::LZE::Actions::EXPORT = qw(loadActions saveActions $actions);
use CGI::LZE::Config;
@CGI::LZE::Actions::ISA     = qw( Exporter CGI::LZE::Config);
$CGI::LZE::Actions::VERSION = '0.24';
$DefaultClass               = 'CGI::LZE::Actions' unless defined $CGI::LZE::Actions::DefaultClass;
$defaultconfig              = '%CONFIG%';

=head1 NAME

CGI::LZE::Actions

=head1 SYNOPSIS


=head1 DESCRIPTION

Config for CGI::LZE.

=head2 EXPORT

loadActions() saveActions() $actions

=head2

required Modules

Data::Dumper

=head1 Public

=head2 new

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 loadConfig

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

1;
