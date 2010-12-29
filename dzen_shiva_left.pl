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

  irc_chan_prefix => '^fg(#4a3e29)',
  irc_chan        => '^fg(#ff6600)',
  irc_nick        => '^fg(#76ff00)',
  irc_msg         => '^fg(#654041)',

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


  my $output = sprintf("%s%s %s %s",
    $dzen_colors{irc_chan_prefix} . '#',

    $dzen_colors{irc_chan} . $channel . $dzen_colors{default_fg} .'>',
    $dzen_colors{irc_nick} . $who     . $dzen_colors{default_fg} .':',
    $dzen_colors{irc_msg}  . (length($msg) >= 30)
      ? sprintf("%.27s$dzen_colors{gray_delimiter}...", $msg)
      : $msg
      . $dzen_colors{default_fg}
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

  if(length($msg) >= 30) {
    $msg = sprintf(
      "%.27s$dzen_colors{gray_delimiter}...$dzen_colors{default_fg}", $msg
    );
  }
  $output .= $msg;
  return $output;
}


sub _temp {
  my $temp = sprintf("%s %s %s\n",
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
  my $subject;

  if($new_count == 0) {
    $subject = 'NULL';
  }
  else {
   $subject   = get_subject($new_mail[scalar(@new_mail) - 1]);
 }



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
  my($time) = scalar(localtime(time)) =~ m/(\d+:\d+:\d+)/g;
  return "[$time]";
}

my $d = '^fg(#484848) | ^fg()';

printf(
  "%s $d %s $d %s $d %s $d %s",
  _irc_hilight,
  _im_hilight,
  _temp(),
  _mail(),
  _time(),
);


