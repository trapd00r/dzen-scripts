#!/usr/bin/perl
use strict;

my $circle  = "^co(2)";
my $square  = "^r(2x2)";
my $i_music = "/home/scp1/devel/dzen-scripts/bitmaps/musicS.xbm";
my $i_mail  = "/home/scp1/devel/dzen-scripts/bitmaps/mail.xbm";
my $i_bat   = "/home/scp1/devel/dzen-scripts/bitmaps/battery.xbm";

sub date {
  my @date  = localtime(time);
  my $fdate = sprintf("%02s:%02s", $date[2], $date[1]);
  return $fdate;
}

#TODO

sub uptime {
  chomp(my $up = `uptime`);
  my ($_1,$_5,$_15) = $up =~ /average: (.+),(.+),(.+)$/;
  $_1 =~ s/\s+//;
  $_5 =~ s/\s+//;
  $_15 =~ s/\s+//;

  $_1 = load($_1);
  $_5 = load($_5);
  $_15 = load($_15);

  return sprintf("$_1, $_5, $_15");

}

sub load {
  my $load = shift;
  if($load >= 0.30 and $load < 0.50) {
    $load = "^fg(#03ab4a)$load^fg()";
  }
  elsif($load >= 0.75 and $load < 1.00) {
    $load = "^fg(#f2b30e)$load^fg()";
  }
  elsif($load >= 1.00) {
    $load = "^fg(#ff0000)$load^fg()";
  }
  else {
    $load = "^fg(#15f20e)$load^fg()";
  }
  return($load);
}

sub mail {
  open(my $fh, 'ssh -p 19216 scp1@192.168.1.101 "ls /mnt/Docs/Mail/inbox/new"|') or die($!);
  my @new = <$fh>;
  close($fh);
  my $count = scalar(@new);

  $count = ($count > 0) ? "^fg(#f50208)$count^fg()" : $count;
  return("^i($i_mail) " . $count);
}

sub battery {
  open(my $fh, 'acpi|') or die($!);
  chomp(my $bat = <$fh>);
  close($fh);

  $bat =~ s/: (.+), ([0-9]+)%,.+/$1 $2/;
  my $status = $1;
  my $percent = $2;
  $status = ($status eq 'Full') ? 'Charging' : $status;
  $percent = ($percent < 50) ? "^fg(#ff0000)$percent^fg()" : "^fg(#13c40f)$percent^fg()";

  return("^i($i_bat) $status: $percent%");

}


sub mpd {
  use Audio::MPD;
  my $mpd = Audio::MPD->new(
    host => '192.168.1.101',
  );
  my $status = "/home/scp1/devel/dzen-scripts/bitmaps/" . $mpd->status->state . '.xbm';
  my $artist = $mpd->current->artist // 'undef';
  my $album  = $mpd->current->album  // 'undef';
  my $title  = $mpd->current->title  // 'undef';
  my $year   = $mpd->current->date   // 0;
  my $playing = sprintf("^fg(#87d53c)%.50s ^fg()- ^fg(#03ab4a)%.50s^fg() (^fg(#3cd56c)%.50s^fg()) [^fg(#88eebd)%d^fg()]",
    $artist, $title, $album, $year);
  my $trunc = sprintf("%s ^i($status)", $playing);

  return $trunc;
}

my $output = "^i($i_music)" . mpd()
  . "^fg(#484848) | ^fg()" . uptime()
  . "^fg(#484848) | ^fg()" . mail()
  . "^fg(#484848) | ^fg()" . battery()
  . "^fg(#484848) | ^fg()";

print $output;

# vim: set tw=99999:
