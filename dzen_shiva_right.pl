#!/usr/bin/perl
# The RIGHT bar
use strict;
use lib '/home/scp1/devel/utils/lib/';
use Trapd00r::Linux;
use Trapd00r::Linux::Mail;
use Flexget::Parse;
use Flexget::PatternMatch;


my %dzen_icons  = (
  mail => '^i(/home/scp1/devel/dzen-scripts/bitmaps/envelope.xbm)',
  arch => '^i(/home/scp1/devel/dzen-scripts/bitmaps/xbm8x8/arch.xbm)',
);
my %dzen_colors = (
  yellow_mail     => "^fg(#e2ffa8)$dzen_icons{mail}^fg()",
  red_mail_count  => '^fg(#ff0000)',
  gray_delimiter  => '^fg(#484848)',
  yellow_subject  => '^fg(#b8cca5)',

  irc_chan_prefix => '^fg(#4a3e29)',
  irc_chan        => '^fg(#ff6600)',
  irc_nick        => '^fg(#76ff00)',
  irc_msg         => '^fg(#654041)',

  blue_temp       => "^fg(#15c8ec)$dzen_icons{arch}^fg()",

  artist          => '^fg(#ffff00)',
  album           => '^fg(#ff0000)',
  title           => '^fg(#ccafff)',
  year            => '^fg(#facedd)',

  host            => '^fg(#caddda)',

  default_fg      => '^fg()',
  default_bg      => '^bg()',
);

sub _new_rel {
  my $log = "$ENV{XDG_DATA_HOME}/flexget/flexget.log";

  if(! -f $log) {
    return 'NULL';
  }

  open(my $fh, '<', $log) or return 'NULL';
  chomp(my @new = <$fh>);

  @new = flexparse(@new);

  my $rel = patternmatch('dzen', $new[-1]);

  my $output = sprintf("%s: %s",
    values %{$rel->{0}}, keys %{$rel->{0}}, # yes, cheating!
  );
  return $output;
}

sub _get_load {
  my($host, $user, $port) = @_;
  not defined $host and $host = 'shiva';
  not defined $user and $user = 'scp1';
  not defined $port and $port = 19216;

  if($host eq 'n900') {
    $user = 'user';
    $port = 22;
  }
  elsif($host eq 'wrt') {
    $user = 'root';
    $port = 22;
  }

  my $uptime = get_remote_load($host, $user, $port);

  return sprintf("$dzen_colors{host}%s$dzen_colors{default_fg}: %s",
    $host, $uptime,
  );
}


sub _current_song {
  my $current = np();

  $current->{artist} = $dzen_colors{artist}
    . $current->{artist}
    . $dzen_colors{default_fg};

  $current->{album} = $dzen_colors{album}
    . $current->{album}
    . $dzen_colors{default_fg};

  $current->{title} = $dzen_colors{title}
    . $current->{title}
    . $dzen_colors{default_fg};

  $current->{year} = $dzen_colors{year}
    . $current->{year}
    . $dzen_colors{default_fg};

  return sprintf("%s by %s on %s from %s",
    $current->{title},
    $current->{artist},
    $current->{album},
    $current->{year},
  );
}


my $d = '^fg(#484848) | ^fg()';
printf(
  "%s $d %s $d %s $d %s $d %s $d %s\n",
  _new_rel(),
  _current_song(),
  _get_load('shiva'),
  _get_load('dvdc'),
  get_mem(),
  get_proc(),
  #_get_load('n900'),
  #_get_load('wrt'),
);


