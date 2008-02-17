package CGI::LZE::Settings;
use strict;
use warnings;
require Exporter;
use vars qw($settings $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::LZE::Settings::EXPORT = qw(loadSettings saveSettings $settings);
use CGI::LZE::Config;
@ISA                         = qw(Exporter CGI::LZE::Config);
$CGI::LZE::Settings::VERSION = '0.25';
$DefaultClass                = 'CGI::LZE::Settings' unless defined $CGI::LZE::Settings::DefaultClass;
$defaultconfig               = '%CONFIG%';

=head1 NAME

CGI::LZE::Settings

=head1 SYNOPSIS


=head1 DESCRIPTION

settings for CGI::LZE.

=head2 EXPORT

loadSettings() saveSettings() $settings

=head2

required Modules

Data::Dumper

=head1 Public

=head2 new()

=cut

sub new {
        my ($class, @initializer) = @_;
        my $self = {};
        bless $self, ref $class || $class || $DefaultClass;
        return $self;
}

=head2 loadSettings()

=cut

sub loadSettings {
        my ($self, @p) = getSelf(@_);
        my $do = (defined $p[0]) ? $p[0] : $defaultconfig;
        if(-e $do) {
                do $do;
        }
}

=head2 saveSettings()

=cut

sub saveSettings {
        my ($self, @p) = getSelf(@_);
        my $l = defined $p[0] ? $p[0] : $defaultconfig;
        $self->SUPER::saveConfig($l, $settings, 'settings');
}

=head1 Private

=head2 getSelf()

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::LZE::Settings');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::LZE::Settings' || UNIVERSAL::isa($_[0], 'CGI::LZE::Settings'))) ? @_ : ($CGI::LZE::Settings::DefaultClass->new, @_);
}

1;
