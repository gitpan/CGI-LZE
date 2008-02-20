use strict;
use Module::Build;
use vars qw($settings $cgi $htd $server $mod_rewrite  $alias $skip $prefix);
use Cwd;
my $cwd = cwd;
my $class = Module::Build->subclass(class => "Module::Build::Custom", code => <<'SUBCLASS' );
my $release = 'blib/perl/';
my $dir     = 'cgi-bin/';
my $path    = '.';
use lib("lib");
use vars qw($settings);
use CGI::LZE::Settings qw(loadSettings);
*settings = \$CGI::LZE::Settings::settings;
use Cwd;
my $cwd = cwd;
loadSettings("$cwd/cgi-bin/config/settings.pl");

sub ACTION_build {
        my $self = shift;
        &change($dir);
        &replace('%CONFIG%', $settings->{cgi}{bin} . '/config/config.pl',    'blib/lib/CGI/LZE/Config.pm');
        &replace('%CONFIG%', $settings->{cgi}{bin} . '/config/translate.pl', 'blib/lib/CGI/LZE/Translate.pm');
        &replace('%CONFIG%', $settings->{cgi}{bin} . '/config/settings.pl',  'blib/lib/CGI/LZE/Settings.pm');
        &replace('%CONFIG%', $settings->{cgi}{bin} . '/config/session.pl',   'blib/lib/CGI/LZE/Session.pm');
        &replace('%CONFIG%', $settings->{cgi}{bin} . '/config/actions.pl',   'blib/lib/CGI/LZE/Actions.pm');
        &replace('%CONFIG%', $settings->{cgi}{bin} . '/config/settings.pl',  'blib/lib/CGI/LZE.pm');
        if($settings->{cgi}{mod_rewrite}) {
                system(" cp extra/.htaccess  blib/bin/");
                &replace('%ALIAS%', $settings->{cgi}{alias}, 'blib/bin/.htaccess');
        }
        $self->SUPER::ACTION_build;
}

sub change {
        my $d = shift;
        chomp($d);
        opendir(IN, $d) or die "cant open $d $!:$/";
        my @files = readdir(IN);
        closedir(IN);
        for(my $i = 0 ; $i <= $#files ; $i++) {
                unless ($files[$i] =~ /^\./) {
                        my $c = $d . $files[$i];
                        my $e = $c;
                        $e =~ s/^$dir(.*)/$1/;
                        unless (-d $d . $files[$i]) {
                                system(" cp " . $c . " $release/$e") unless (-e $release . "/" . $e && $files[$i] =~ /\~$/);
                        } else {
                                system("mkdir -p $release/$e") unless (-e $release . "/" . $e);
                                &change($d . $files[$i] . "/");
                        }
                }
        }
}

sub replace {
        my $replace = shift;
        my $with    = shift;
        my $f       = shift;
        chmod 0644, $f;
        open(EDIT, "+<$f") or warn "$!,$/ $f $/";
        my $file = '';
        while(<EDIT>) {
                s/$replace/$with/;
                $file .= $_;
        }
        seek(EDIT, 0, 0);
        print EDIT $file;
        truncate(EDIT, tell(EDIT));
        close(EDIT);
        chmod 0755, $f if($f =~ /\.pl$/);
}
SUBCLASS

my $inctance = $class->new(
        get_options => {skip => {store => \$skip},},
        module_name => 'CGI::LZE',
        requires => {'CGI' => ">=3.29", 'Test::More' => ">=0.7", 'Module::Build' => ">=0.2808", 'Test::Pod' => ">=1.26", 'Test::Pod::Coverage' => ">=0.55", 'MD5' => ">=2.03",},
        ($] >= 5.005 ? (AUTHOR => 'Dirk Lindner <lindnerei@o2online.de>') : ()),
        dist_abstract      => "A simple CGI subclass",
        license            => "lgpl",
        create_makefile_pl => 'passthrough',

        #             sign               => 1,
);
$prefix = $inctance->{phash}{runtime_params}{disk}{prefix};
eval 'use CGI::LZE::Settings qw(loadSettings saveSettings)';
unless ($@) {
        loadSettings();
        loadSettings("cgi-bin/config/config.pl") unless -e $settings->{cgi}{bin};
        *settings    = \$CGI::LZE::Settings::settings;
        $htd         = $settings->{cgi}{DocumentRoot} if -e $settings->{cgi}{DocumentRoot};
        $cgi         = $settings->{cgi}{bin} if -e $settings->{cgi}{bin};
        $server      = $settings->{cgi}{serverName};
        $alias       = $settings->{cgi}{alias};
        $mod_rewrite = $settings->{cgi}{mod_rewrite};
} else {
        eval 'use lib("./lib");';
        eval 'use CGI::LZE::Settings qw(saveSettings)';
}
$cgi         = $inctance->args('cgi')         if $inctance->args('cgi');
$htd         = $inctance->args('htd')         if $inctance->args('htd');
$alias       = $inctance->args('alias')       if $inctance->args('alias');
$server      = $inctance->args('server')      if $inctance->args('server');
$mod_rewrite = $inctance->args('mod_rewrite') if $inctance->args('mod_rewrite');
$inctance->{properties}{install_path}{perl} = $prefix . $cgi;

unless ($skip) {
        my $an = Module::Build->prompt("Should i use settings from previous previous version $/ Document root: $htd $/ cgi-bin directory: $cgi $/ Server Name:$server $/ Script Alias $alias $/ mod_rewrite: $mod_rewrite $/", 'yes');
        $skip = $an eq 'yes' ? 1 : 0;
}
unless ($skip) {
        $cgi = $cgi ? $cgi : "/srv/www/cgi-bin";
        $htd = $htd ? $htd : "/srv/www/htdocs";
        $htd = Module::Build->prompt("Where is your Document root ?",     $htd);
        $cgi = Module::Build->prompt("Where is your cgi-bin directory ?", $cgi);
        $server = $server ? $server : "http://localhost";
        $server = Module::Build->prompt("Enter your Server Name", $server);
        $mod_rewrite = $mod_rewrite ? $mod_rewrite : 0;
        $mod_rewrite = Module::Build->prompt("Should i use mod_rewrite (0 or 1)? default is 0 type 1 to enable make sure  that mod_rewrite is installed and enabled if you set this to 1!", $mod_rewrite);
        $alias = $alias ? $alias : "cgi-bin";
        $alias = Module::Build->prompt("Enter your Script Alias", $alias);

}
$settings = {
             config        => "$cgi/config/settings.pl",
             admin         => {email => 'lindnerei@o2online.de', firstname => 'Dirk', name => 'Lindner', street => 'example 33', town => 'Berlin',},
             cgi           => {expires => '+1y', cookiePath => '/', serverName => $server, DocumentRoot => $htd, bin => $cgi, title => 'CGI::LZE', style => 'Crystal', mod_rewrite => $mod_rewrite, alias => $alias,},
             language      => 'en',
             defaultAction => 'news',
             scriptAlias   => $alias,
             uploads   => {maxlength  => 2003153,               path  => "$htd/downloads/", chmod => 0644, enabled => 1},
             tree      => {navigation => "$cgi/config/tree.pl", links => "$cgi/config/links.pl"},
             version   => '0.26',
             session   => "$cgi/config/session.pl",
             actions   => "$cgi/config/actions.pl",
             translate => "$cgi/config/translate.pl",
};

saveSettings("$cwd/cgi-bin/config/settings.pl");

$inctance->create_build_script;
