#!/usr/bin/perl
use strict;
use String::Utils 'longest';
use Flexget::PatternMatch;
use Flexget::Parse;
use Media::Sort;

#my $i_music = "/home/scp1/devel/dzen-scripts/bitmaps/musicS.xbm";
my $i_music = "/home/scp1/devel/dzen-scripts/bitmaps/music.xbm";
my $i_mail  = "/home/scp1/devel/dzen-scripts/bitmaps/mail.xbm";


sub uptime {
 chomp(my $up = `uptime`);
  my ($_1,$_5,$_15) = $up =~ /average: (.+),(.+),(.+)$/;
  $_1 =~ s/\s+//;
  $_5 =~ s/\s+//;
  $_15 =~ s/\s+//;

  $_1 = load($_1);
  $_5 = load($_5);
  $_15 = load($_15);

  return sprintf("^fg(#888888)shiva^fg(): $_1^fg(#888888),^fg() $_5^fg(#888888),^fg() $_15");
}

sub india_uptime {
  open(my $fh, 'ssh -p 19216 scp1@192.168.1.102 "uptime" &>/dev/null|') or return("shiva: down");
  chomp(my $up = <$fh>);
  if(!defined($up)) {
    return("^fg(#888888)india^fg(): ^fg(#ff0000)down^fg(#f8072e)!^fg()");
  }
  my ($_1,$_5,$_15) = $up =~ /average: (.+),(.+),(.+)$/;
  $_1 =~ s/\s+//;
  $_5 =~ s/\s+//;
  $_15 =~ s/\s+//;

  $_1 = load($_1);
  $_5 = load($_5);
  $_15 = load($_15);

  return sprintf("^fg(#888888)india^fg(): $_1^fg(#888888),^fg() $_5^fg(#888888),^fg() $_15");
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

  return sprintf("^fg(#888888)dvdc^fg(): $_1^fg(#888888),^fg() $_5^fg(#888888),^fg() $_15");
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

  return sprintf("^fg(#888888)n900^fg(): $_1^fg(#888888),^fg() $_5^fg(#888888),^fg() $_15");
}


sub load {
  chomp(my $load = shift);
  if($load < 0.10) {
    $load = "^fg(#33b02e)$load^fg()";
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
  my $genre  = $current->genre  // 'undef';

  my $art_len = longest($artist);
  my $alb_len = longest($album);
  my $tit_len = longest($title);

  my $spacing = 9;

  if($art_len > 30) {
    $artist = substr($artist, 0, 37) . '^fg(#888888)...^fg()';
  }
  else {
    for($art_len .. 30) {
      $mpd_len_leftover++;
    }
  }
  if($alb_len > 30) {
    $album = substr($album, 0, 37) . '^fg(#888888)...^fg()';
  }
  else {
    for($alb_len .. 30) {
      $mpd_len_leftover++;
    }
  }
  if($tit_len > 30) {
    $title = substr($title, 0, 37) . '^fg(#888888)...^fg()';
  }
  else {
    for($tit_len .. 30) {
      $mpd_len_leftover++;
    }
  }

  my $pl = "^i($i_music) ^fg(#6be603)$title^fg(#888888) by "
    . "^fg(#ff8700)$artist^fg(#888888) on"
    . " ^fg(#f8072e)$album"
    . " ^fg(#888888)from ^fg(#5496ff)$year^fg()";

  return($pl);
}

sub newmusic {
  my $l = '/mnt/shiva/.flexget.log';
  open(my $fh, '<', $l) or die($!);
  my @r = <$fh>;
  close($fh);
  mpd(); # he-hu

  my $len = 0;
  my $output = undef;

  my $foo = patternmatch('dzen', getmedia('music', flexparse(@r)));
  for(keys(%$foo)) {
    next if /(?:DVDRip|x265)/;
    if($foo->{$_} =~ m;(?:hip-hip|psy|v/a|hardstyle|rock);i) {
      my $match = undef;
      if($_ =~ /(psy)(.*)/gpi) {
        $match = sprintf("${^PREMATCH}^fg(#cc11ab)$1^fg()$2");
      }
      $len = $mpd_len_leftover + 20;
      $output = sprintf("%s: %.${len}s", $foo->{$_}, $match);
      return($output);
    }
  }
}

sub newrel {
  mpd(); # uh, uh

  my $file = "$ENV{HOME}/.flexget.log";
  open(my $fh, '<', $file) or die($!);
  chomp(my @r = <$fh>);
  close($fh);


  my $f = patternmatch('dzen', flexparse(@r));
  my $release  = undef;
  my $output   = undef;
  my $rel_info = undef;

  for my $n(sort(keys(%{$f}))) {
    for my $rel(keys(%{$f->{$n}})) {
      $release = $rel;
      $rel_info = $f->{$n}{$rel};
      $release = sprintf("%.50s", $release);


      $output = sprintf("%s^fg(#ffd7ab): ^fg(#ffffff)%s^fg()", $rel_info, $release);
      return($output);
    }
  }
}

sub date {
  my(undef, undef, undef, $mday, $mon, $year) = localtime(time);
  $mon += 1;
  $year += 1900;

  return(sprintf("%04d-%02d-%02d", $year, $mon, $mday));
}


sub get_no_proc {
  opendir(my $dh, '/proc') or warn($!);
  my @processes = grep{/^[0-9]+/} readdir($dh); # PIDs
  return("^fg(#959595)Processes^fg():^fg(#ff0000) " . scalar(@processes));
}

sub get_mem {
  open(my $fh, '<', '/proc/meminfo') or warn($!);
  my ($total,$free,$buffers,$cached) = undef;
  while(<$fh>) {
    if(/^MemTotal:\s+([0-9]+)\s+/) {
      $total = to_mb($1);
    }
    elsif(/^MemFree:\s+([0-9]+)\s+/) {
      $free = to_mb($1);
    }
    elsif(/^Buffers:\s+([0-9]+)\s+/) {
      $buffers = to_mb($1);
    }
    elsif(/^Cached:\s+([0-9]+)/) {
      $cached = to_mb($1);
    }
  }
  my $avail = $free + ($buffers + $cached);
  my $used  = $total - $avail;

  my $mem = $used / $total;
  $mem =~ s/..(..).+/$1/; # :D

  if($mem  >= 5 and $mem <= 10) {
    $used = "^fg(#15e100)$used^fg()";
  }
  elsif($mem  >= 11 and $mem <= 15) {
    $used = "^fg(#5ee100)$used^fg()";
  }
  elsif($mem  >= 16 and $mem <= 20) {
    $used = "^fg(#8ce100)$used^fg()";
  }
  elsif($mem  >= 21 and $mem <= 25) {
    $used = "^fg(#bee100)$used^fg()";
  }
  elsif($mem  >= 26 and $mem <= 30) {
    $used = "^fg(#eid300)$used^fg()";
  }
  elsif($mem  >= 31 and $mem <= 40) {
    $used = "^fg(#e1a100)$used^fg()";
  }
  elsif($mem  >= 41 and $mem <= 50) {
    $used = "^fg(#e17c00)$used^fg()";
  }
  elsif($mem  >= 51 and $mem <= 60) {
    $used = "^fg(#e15800)$used^fg()";
  }
  elsif($mem  >= 61 and $mem <= 70) {
    $used = "^fg(#e13400)$used^fg()";
  }
  elsif($mem  >= 71 and $mem <= 80) {
    $used = "^fg(#e11800)$used^fg()";
  }
  elsif($mem  >= 81 and $mem <= 90) {
    $used = "^fg(#e10013)$used^fg()";
  }
  else {
    $used = "^fg(#ff0000)$used^fg()";
  }
  my $out = sprintf("^fg(#959595)Mem^fg(): %s^fg(#b8e4dd)MB^fg()/^fg(#a7a7a7)%s^fg(#b8e4dd)MB^fg()",
    $used,  $total);
}

sub to_mb {
  my $kb = shift;
  return(sprintf("%d",$kb/1024));
}

my $output =
  date()
  . "^fg(#5d5d5d) | ^fg()" . newrel()
  . "^fg(#5d5d5d) | ^fg()" . mpd()
  . "^fg(#5d5d5d) | ^fg()" . uptime()
  . "^fg(#5d5d5d) | ^fg()" . india_uptime()
  . "^fg(#5d5d5d) | ^fg()" . dvdc_uptime()
  . "^fg(#5d5d5d) | ^fg()" . get_no_proc()
  . "^fg(#5d5d5d) | ^fg()" . get_mem()
  #. "^fg(#5d5d5d) | ^fg()" . n900_uptime()
  #. "^fg(#5d5d5d) | ^fg()" . "\n";


  . "\n";
  ;

print $output;

# vim: set tw=99999:
