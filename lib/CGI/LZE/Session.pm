package CGI::LZE::Session;
use strict;
use warnings;
require Exporter;
use vars qw( $session $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::LZE::Session::EXPORT = qw(loadSession saveSession $session);
use CGI::LZE::Config;
@CGI::LZE::Session::ISA     = qw(Exporter CGI::LZE::Config);
$CGI::LZE::Session::VERSION = '0.25';
$DefaultClass               = 'CGI::LZE::Session' unless defined $CGI::LZE::Session::DefaultClass;
$defaultconfig              = '%CONFIG%';

=head1 NAME

CGI::LZE::Session

=head1 SYNOPSIS


=head1 DESCRIPTION

session for CGI::LZE.

=head2 EXPORT

loadConfig() saveSession() $session

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

sub loadSession {
        my ($self, @p) = getSelf(@_);
        my $do = (defined $p[0]) ? $p[0] : $defaultconfig;
        if(-e $do) {
                do $do;
        }
}

=head2 saveSession

=cut

sub saveSession {
        my ($self, @p) = getSelf(@_);
        my $l = defined $p[0] ? $p[0] : $defaultconfig;
        $self->SUPER::saveConfig($l, $session, 'session');
}

=head1 Private

=head2 getSelf

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::LZE::Session');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::LZE::Session' || UNIVERSAL::isa($_[0], 'CGI::LZE::Session'))) ? @_ : ($CGI::LZE::Session::DefaultClass->new, @_);
}

1;
