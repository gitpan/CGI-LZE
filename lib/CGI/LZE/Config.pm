package CGI::LZE::Config;

# use strict;
# use warnings;
require Exporter;
use vars qw($config $DefaultClass @EXPORT  @ISA $defaultconfig);
@CGI::LZE::Config::EXPORT  = qw(loadConfig saveConfig $config);
@ISA                       = qw(Exporter);
$CGI::LZE::Config::VERSION = '0.25';
$DefaultClass              = 'CGI::LZE::Config' unless defined $CGI::LZE::Config::DefaultClass;
$defaultconfig             = '%CONFIG%';

=head1 NAME

CGI::LZE::Config

=head1 SYNOPSIS


=head1 DESCRIPTION

Config for LZE.

=head2 EXPORT

loadConfig() saveConfig() $config

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

=head2 loadConfig()

=cut

sub loadConfig {
        my ($self, @p) = getSelf(@_);
        my $do = (defined $p[0]) ? $p[0] : $defaultconfig;
        if(-e $do) {
                do $do;
        }
}

=head2 saveConfig()

=cut

sub saveConfig {
        my ($self, @p) = getSelf(@_);
        my $saveAs = defined $p[0] ? $p[0] : $defaultconfig;
        $config = defined $p[1] ? $p[1] : $config;
        my $var = defined $p[2] ? $p[2] : 'config';
        use Data::Dumper;
        my $content = Dumper($config);
        $content .= "\$$var =\$VAR1;";
        use Fcntl qw(:flock);
        use Symbol;
        my $fh = gensym();
        my $rsas = $saveAs =~ /^(\S+)$/ ? $1 : 0;

        if($rsas) {
                open $fh, ">$rsas.bak" or warn "$/CGI::LZE::Config::saveConfig$/ $! $/ File: $rsas $/Caller: " . caller() . $/;
                flock $fh, 2;
                seek $fh, 0, 0;
                truncate $fh, 0;
                print $fh $content;
                close $fh;
        }
        if(-e "$rsas.bak") {
                rename "$rsas.bak", $rsas or warn "$/CGI::LZE::Config::saveConfig$/ $! $/ File: $rsas $/Caller: " . caller() . $/;
                do $rsas;
        }
}

=head1 Private

=head2 getSelf()

=cut

sub getSelf {
        return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'CGI::LZE::Config');
        return (defined($_[0]) && (ref($_[0]) eq 'CGI::LZE::Config' || UNIVERSAL::isa($_[0], 'CGI::LZE::Config'))) ? @_ : ($CGI::LZE::Config::DefaultClass->new, @_);
}

1;
