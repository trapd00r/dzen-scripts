#!/usr/bin/perl
use strict;
# The main perl to dzen2
# trapd00r © 2010

my $circle  = "^co(2)";
my $square  = "^r(2x2)";
my $i_music = "/home/scp1/devel/dzen2/bitmaps/music.xbm";

sub newtv {
  my $flexlog = "/home/scp1/.flexget.log";
  my @tv;
  open(LOG,$flexlog) or die "$!";
  while(<LOG>) {
    next unless(/Downloading:/);
    s/\w+\s+\w+\s+\w+: //;
    if($_ =~ /(S[0-9]+)?(E[0-9]+)?(.*TV)/) {
      push(@tv, $_);
    }
  }
  close(LOG);
  return $tv[@tv-1];
}

sub date {
  my @date  = localtime(time);
  my $fdate = sprintf("%02s:%02s", $date[2], $date[1]);
  return $fdate;
}

sub mpd {
  use Audio::MPD;
  my $mpd = Audio::MPD->new;
  my $artist = $mpd->current->artist // 'undef';
  my $album  = $mpd->current->album  // 'undef';
  my $title  = $mpd->current->title  // 'undef';
  my $playing = sprintf("%.20s - %.20s (%.10s)", $artist, $title, $album);
  my $trunc = sprintf("%.50s", $playing);
  return $trunc;
}

sub bg {
  my $color = shift;
  return "^bg($color)";
}

sub weather {
  use Weather::Google;
  my $town = "Norrköping";
  my $gw = Weather::Google->new($town);
  my @gwdata = $gw->current('temp_c', 'humidity', 'wind_condition');

  my $data = sprintf("%s %s", $gwdata[0], $gwdata[1], $gwdata[2]);
  return $data;
  sleep 300;
}

print "^bg()";
print("^i($i_music)", &mpd, "  ", "^bg(#901D1D)", &newtv, "^bg(4D4C4C)");
print "^bg()";
