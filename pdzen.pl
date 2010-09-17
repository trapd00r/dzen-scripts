#!/usr/bin/perl
use strict;

my $circle  = "^co(2)";
my $square  = "^r(2x2)";
my $i_music = "/home/scp1/devel/dzen-scripts/bitmaps/music.xbm";

sub date {
  my @date  = localtime(time);
  my $fdate = sprintf("%02s:%02s", $date[2], $date[1]);
  return $fdate;
}

sub mpd {
  use Audio::MPD;
  my $mpd = Audio::MPD->new(
    host => '192.168.1.101',
  );
  my $artist = $mpd->current->artist // 'undef';
  my $album  = $mpd->current->album  // 'undef';
  my $title  = $mpd->current->title  // 'undef';
  my $year   = $mpd->current->date   // 0;
  my $playing = sprintf("^fg(#87d53c)%.50s ^fg()- ^fg(#03ab4a)%.50s^fg() (^fg(#3cd56c)%.30s^fg()) [^fg(#88eebd)%d^fg()]",
    $artist, $title, $album, $year);
  my $trunc = sprintf("%.300s", $playing);

  return $trunc;
}

sub bg {
  my $color = shift;
  return "^bg($color)";
}


print "^bg()";
print("^i($i_music)",mpd(), "  ", "^bg(#901D1D)", "^bg(4D4C4C)");
print "^bg()";

# vim: set tw=99999:
