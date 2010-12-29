#!/usr/bin/perl
# The LEFT bar
use strict;
use lib '/home/scp1/devel/utils/lib/';
use Trapd00r::Linux;
use Trapd00r::Linux::Mail;


my %dzen_icons  = (
  mail            => '^i(/home/scp1/devel/dzen-scripts/bitmaps/envelope.xbm)',
  arch            => '^i(/home/scp1/devel/dzen-scripts/bitmaps/xbm8x8/arch.xbm)',
);
my %dzen_colors = (
  yellow_mail     => "^fg(#e2ffa8)$dzen_icons{mail}^fg()",
  red_mail_count  => '^fg(#ff0000)',
  gray_delimiter  => '^fg(#484848)',
  yellow_subject  => '^fg(#b8cca5)',

  irc_chan_prefix => '^fg(#484848)',
  irc_chan        => '^fg(#737373)',
  irc_nick        => '^fg(#ff1e00)',
  irc_msg         => '^fg(#888888)',

  blue_temp       => "^fg(#15c8ec)$dzen_icons{arch}^fg()",

  artist          => '^fg(#ffff00)',
  album           => '^fg(#ff0000)',
  title           => '^fg(#ccafff)',
  year            => '^fg(#facedd)',

  default_fg      => '^fg()',
  default_bg      => '^bg()',
);


sub _irc_hilight {
  my $latest = irc_msgs();

  my($channel, $who, $msg) = $latest =~ m/^(?:#|&)(\S+)\s+(\S+)\s+(.+)/;

  $msg =~ s/>> scp1:?//;

  if( (!$msg) or (!defined($msg)) or ($msg =~ /^\s+$/) ) {
    $msg = '^fg(#484848)highlight^fg()';
  }

  my $output = sprintf("%s%s %s %s",
    $dzen_colors{irc_chan_prefix} . '#',

    $dzen_colors{irc_chan} . $channel . $dzen_colors{default_fg} .'>',
    $dzen_colors{irc_nick} . $who     . $dzen_colors{default_fg} .':',
    $dzen_colors{irc_msg}  . len_mod($msg, 30, '...'),
  );

  return $output;
}

sub _im_hilight {
  my $latest = im_msgs();
  my($channel, $who, $msg) = $latest =~ m/^(?:#|&)(\S+)\s+(\S+)\s+(.+)/;

  $msg =~ s/>> scp1> //;

  my $output = sprintf("%s%s %s %s",
    $dzen_colors{irc_chan_prefix} . '&' . $dzen_colors{default_fg},

    $dzen_colors{irc_chan} . $channel . $dzen_colors{default_fg} . '>',
    $dzen_colors{irc_nick} . $who . $dzen_colors{default_fg}     . ':',
  );

  $msg = $dzen_colors{irc_msg}
    . len_mod($msg, 30, '...')
    . $dzen_colors{default_fg};

  $output .= $msg;
  return $output;
}


sub _temp {
  my $temp = sprintf("%s %s %s",
    $dzen_colors{blue_temp},
    temp(),
    "°C",
  );

  return $temp;
}


sub _mail {
  my $output_to = shift // 'dzen2';

  my @new_mail  = new_mail();
  my $new_count = scalar(@new_mail);
  my $subject = 'NULL';

  $subject   = get_subject($new_mail[scalar(@new_mail) - 1])
    unless scalar(@new_mail) < 1;

  my $output;
  if($output_to eq 'dzen2') {
    $output = sprintf("%s %s %s%s%s",
      $dzen_colors{yellow_mail},
      $dzen_colors{red_mail_count} . $new_count . $dzen_colors{default_fg},
      $dzen_colors{gray_delimiter} . '(' . $dzen_colors{default_fg},
      $dzen_colors{yellow_subject}. $subject . $dzen_colors{default_fg},
      $dzen_colors{gray_delimiter} . ')' . $dzen_colors{default_fg},
    );
  }
  return $output;
}

sub _time {
  my($time) = scalar(localtime(time)) =~ m/(\d+:\d+:\d+)/g; # I know

  my($s, $m, $h) = localtime(time);

  return sprintf("^fg(#ff2b00)%2d^fg(#888888):^fg(#908365)%02d^fg(#888888):%02d",
    $h, $m, $s);
}

my $d = '^fg(#484848) | ^fg()';

printf(
  "%s $d %s $d %s $d %s $d %s\n",
  _irc_hilight,
  _im_hilight,
  _mail(),
  _temp(),
  _time(),
);


