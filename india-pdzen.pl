#!/usr/bin/perl
use strict;
use utf8;
use String::Utils 'longest';
use Flexget::PatternMatch;
use Flexget::Parse;
use Media::Sort;

#my $i_music = "/home/scp1/devel/dzen-scripts/bitmaps/musicS.xbm";
my $i_music = "/home/scp1/devel/dzen-scripts/bitmaps/music.xbm";
my $i_mail  = "/home/scp1/devel/dzen-scripts/bitmaps/mail.xbm";
my $i_bat   = "/home/scp1/devel/dzen-scripts/bitmaps/bat_full_01.xbm";

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

  if($count == 0) {
    return("^i($i_mail) $count");
  }

  open(my $fh, "ssh -p 19216 scp1\@192.168.1.101 \"/bin/cat /mnt/Docs/Mail/inbox/new/$new[$#new]\"|") or return;
  my $subject = 'NULL';
  while(<$fh>) {
    if($_ =~ m;^Subject: (.+);) {
      $subject = $1;
    }
  }
  $subject =~ s;=\?ISO-8859-1\?.+ ;;; # stupid crap
  if(length($subject) > 20) {
    $subject = substr($subject, 0, 20) . "^fg(#484848)...^fg()";
  }
  if($subject =~ m;^(Re):(.+);) {
    $subject = "^fg(#484848)(^fg(#ff3101)$1^fg(#484848):^fg(#ffff00)$2^fg(#484848))^fg()";
  }
  else {
    $subject = "^fg(#484848)(^fg(#f6ee0e)$subject^fg(484848))^fg()";
  }

  $count = ($count > 0) ? "^fg(#f50208)$count $subject" : $count;
  return("^i($i_mail) " . $count);
}

sub battery {
  open(my $fh, 'ibam --percentbattery|head -1|') or die($!);
  chomp(my $bat = <$fh>);
  close($fh);

  $bat =~ s/Battery percentage:\s+(\d+).+/$1/;

  ($bat > 50) ? ($bat = "^fg(#a2ee13)^i($i_bat) ^fg(#44ee13)$bat^fg()") : ($bat = "^fg(#3be70a)^i($i_bat)^fg(#e7120a)$bat^fg()");
  return("$bat%");

}


my $mpd_len_leftover = 0;
my $mpd_max_len = 0;
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

  # dzen doesnt handle unicode
  $artist =~ s/ö/o/g;
  $artist =~ s/[åä]/a/g;
  $album  =~ s/ö/o/g;
  $album  =~ s/[åä]/a/g;
  $title  =~ s/ö/o/g;
  $title  =~ s/[åä]/a/g;

  my $art_len = longest($artist);
  my $alb_len = longest($album);
  my $tit_len = longest($title);

  $mpd_max_len = $art_len + $alb_len + $tit_len;

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

sub newrel {
  my $l = "/mnt/shiva/.flexget.log";
  open(my $fh, '<', $l) or die($!);
  my @r = <$fh>;
  close($fh);

  mpd(); # he-hu

  my $len = 0;
  my($release, $rel_info);
  my $output = undef;

  my $foo = patternmatch('dzen', flexparse(@r));

  use Data::Dumper;
  for my $n(sort(keys(%{$foo}))) {
    for my $show(keys(%{$foo->{$n}})) {
      # lolol.
      $release = $show;
      $rel_info = $foo->{$n}{$show};

      $len = $mpd_len_leftover;
      if(length($release) + length($rel_info) > 40) {
        $release = substr($release, 0, 20) . "^fg(#484848)..^fg()";
      }

      if($release =~ m/(house)\.(.*)/igp) {
        $release = "${^PREMATCH}^fg(#71f802)$1.^fg()$2";
      }
      $output = sprintf("%s: %s", $rel_info, $release);
      return($output);
    }
  }
}


my $output = newrel()
  . "^fg(#484848) | ^fg()" . mpd()
  . "^fg(#484848) | ^fg()" . uptime()
  . "^fg(#484848) | ^fg()" . shiva_uptime()
  . "^fg(#484848) | ^fg()" . dvdc_uptime()
  #. "^fg(#484848) | ^fg()" . n900_uptime()
  . "^fg(#484848) | ^fg()" . mail()
  . "^fg(#484848) | ^fg()" . battery()
  . "^fg(#484848) | ^fg()";

print $output;

# vim: set tw=99999:
