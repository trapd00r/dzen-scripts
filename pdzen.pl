#!/usr/bin/perl
use strict;
use String::Utils 'longest';

#my $i_music = "/home/scp1/devel/dzen-scripts/bitmaps/musicS.xbm";
my $i_music = "/home/scp1/devel/dzen-scripts/bitmaps/music.xbm";
my $i_mail  = "/home/scp1/devel/dzen-scripts/bitmaps/mail.xbm";
my $i_bat   = "/home/scp1/devel/dzen-scripts/bitmaps/battery.xbm";

sub date {
  my @date  = localtime(time);
  my $fdate = sprintf("%02s:%02s", $date[2], $date[1]);
  return $fdate;
}

sub uptime {
  chomp(my $up = `uptime`);
  my ($_1,$_5,$_15) = $up =~ /average: (.+),(.+),(.+)$/;
  $_1 =~ s/\s+//;
  $_5 =~ s/\s+//;
  $_15 =~ s/\s+//;

  $_1 = load($_1);
  $_5 = load($_5);
  $_15 = load($_15);

  return sprintf("^fg(#5bde58)india^fg(): $_1^fg(#999999),^fg() $_5^fg(#999999),^fg() $_15");
}

sub shiva_uptime {
  open(my $fh, 'ssh -p 19216 scp1@192.168.1.101 "uptime"|') or return("shiva: down");
  chomp(my $up = <$fh>);
  my ($_1,$_5,$_15) = $up =~ /average: (.+),(.+),(.+)$/;
  $_1 =~ s/\s+//;
  $_5 =~ s/\s+//;
  $_15 =~ s/\s+//;

  $_1 = load($_1);
  $_5 = load($_5);
  $_15 = load($_15);

  return sprintf("^fg(#588dde)shiva^fg(): $_1^fg(#999999),^fg() $_5^fg(#999999),^fg() $_15");
}

sub dvdc_uptime {
  open(my $fh, 'ssh -p 19216 scp1@192.168.1.100 "uptime"|') or return("dvdc: down");
  chomp(my $up = <$fh>);
  my ($_1,$_5,$_15) = $up =~ /average: (.+),(.+),(.+)$/;
  $_1 =~ s/\s+//;
  $_5 =~ s/\s+//;
  $_15 =~ s/\s+//;

  $_1 = load($_1);
  $_5 = load($_5);
  $_15 = load($_15);

  return sprintf("^fg(#de5860)dvdc^fg(): $_1^fg(#999999),^fg() $_5^fg(#999999),^fg() $_15");
}

sub n900_uptime {
  open(my $fh, 'ssh -p 19216 user@192.168.1.112 "uptime" 2> /dev/null|') or return("n900: down");
  chomp(my $up = <$fh>);
  my ($_1,$_5,$_15) = $up =~ /average: (.+),(.+),(.+)$/;
  $_1 =~ s/\s+//;
  $_5 =~ s/\s+//;
  $_15 =~ s/\s+//;

  $_1 = load($_1);
  $_5 = load($_5);
  $_15 = load($_15);

  return sprintf("^fg(#f6f409)n900^fg(): $_1^fg(#999999),^fg() $_5^fg(#999999),^fg() $_15");
}


sub load {
  chomp(my $load = shift);
  if($load < 0.10) {
    $load = "^fg(#09ff00)$load^fg()";
  }
  if($load >= 0.10 and $load <= 0.20) {
    $load = "^fg(#28f809)$load^fg()";
  }
  elsif($load >= 0.21 and $load <= 0.30) {
    $load = "^fg(#f2b30e)$load^fg()";
  }
  elsif($load >= 0.31 and $load <= 0.40) {
    $load = "^fg(#f8d509)$load^fg()";
  }
  elsif($load >= 0.41 and $load <= 0.50) {
    $load = "^fg(#f8b009)$load^fg()";
  }
  elsif($load >= 0.51 and $load <= 0.60) {
    $load = "^fg(#f88e09)$load^fg()";
  }
  elsif($load >= 0.61 and $load <= 0.70) {
    $load = "^fg(#f87209)$load^fg()";
  }
  elsif($load >= 0.71 and $load <= 0.80) {
    $load = "^fg(#f85e09)$load^fg()";
  }
  elsif($load >= 0.81 and $load <= 0.90) {
    $load = "^fg(#f84709)$load^fg()";
  }
  elsif($load >= 0.91 and $load <= 1.00) {
    $load = "^fg(#f82409)$load^fg()";
  }
  elsif($load >= 1.01 and $load <= 1.10) {
    $load = "^fg(#f81609)$load^fg()";
  }
  elsif($load >= 1.11 and $load <= 1.20) {
    $load = "^fg(#ff0003)$load^fg()";
  }
  else {
    $load = "^fg(#ff0000)$load^fg()";
  }
  return($load);
}

sub mail {
  open(my $fh, 'ssh -p 19216 scp1@192.168.1.101 "ls /mnt/Docs/Mail/inbox/new"|') or die($!);
  chomp(my @new = <$fh>);
  close($fh);
  my $count = scalar(@new);

  $count = ($count > 0) ? "^fg(#f50208)$count^fg()" : $count;
  return("^i($i_mail) " . $count);
}

sub battery {
  open(my $fh, 'ibam --percentbattery|head -1|') or die($!);
  chomp(my $bat = <$fh>);
  close($fh);

  $bat =~ s/Battery percentage:\s+(\d+).+/$1/;
  return("^i($i_bat) $bat%");

}


my $mpd_len_leftover = 0;
sub mpd {
  use Audio::MPD;
  my $mpd = Audio::MPD->new(
    host => '192.168.1.101',
  );

  my $current = $mpd->current;
  if(!defined($current)) {
    return(' MPD: ^fg(#ff0000)Stopped^fg()');
  }

  my $status = "/home/scp1/devel/dzen-scripts/bitmaps/" . $mpd->status->state . '.xbm';

  my $artist = $current->artist // 'undef';
  my $album  = $current->album  // 'undef';
  my $title  = $current->title  // 'undef';
  my $year   = $current->date   // 0;

  my $art_len = longest($artist);
  my $alb_len = longest($album);
  my $tit_len = longest($title);

  my $spacing = 9;

  if($art_len > 30) {
    $artist = substr($artist, 0, 37) . '^fg(#999999)...^fg()';
  }
  else {
    for($art_len .. 30) {
      $mpd_len_leftover++;
    }
  }
  if($alb_len > 30) {
    $album = substr($album, 0, 37) . '^fg(#999999)...^fg()';
  }
  else {
    for($alb_len .. 30) {
      $mpd_len_leftover++;
    }
  }
  if($tit_len > 30) {
    $title = substr($title, 0, 37) . '^fg(#999999)...^fg()';
  }
  else {
    for($tit_len .. 30) {
      $mpd_len_leftover++;
    }
  }

  my $pl = "^i($i_music) ^fg(#6be603)$title^fg(#999999) by ^fg(#ff8700)$artist^fg(#999999) from^fg() ^fg(#f8072e)$album^fg()";

  return($pl);
}

sub newtv {
  use Flexget::Parse 'flexparse';
  use Flexget::PatternMatch 'patternmatch';
  use Media::Sort 'getmedia';
  mpd(); # uh, uh

  my $file = "$ENV{HOME}/.flexget.log";
  open(my $fh, '<', $file) or die($!);
  chomp(my @r = <$fh>);
  close($fh);

  @r = getmedia('tv', flexparse(@r));

  my $wanted = $r[$#r];

  if($wanted =~ m/(History|Discovery)\.(Channel)(?:The)?(.+)\.(.+)-(.+)/) {
    $wanted = "^fg(#484848)$1.$2^fg(#6be603)$3^fg().$4";

  }


  my $len = longest($wanted);
  my $allowed_len = $mpd_len_leftover;

  #return("%-${allowed_len}s", $wanted);
  return(sprintf("^fg(#ff8700)TV^fg(): ^bg(#141414)%.${allowed_len}s^bg()", $wanted));
}

my $output = newtv()
  . "^fg(#484848) | ^fg()" . mpd()
  . "^fg(#484848) | ^fg()" . uptime()
  . "^fg(#484848) | ^fg()" . shiva_uptime()
  . "^fg(#484848) | ^fg()" . dvdc_uptime()
#  . "^fg(#484848) | ^fg()" . n900_uptime()
  . "^fg(#484848) | ^fg()" . mail()
  . "^fg(#484848) | ^fg()" . battery()
  . "^fg(#484848) | ^fg()";

print $output;

# vim: set tw=99999:
