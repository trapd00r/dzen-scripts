#!/usr/bin/perl
use strict;

sub getdf {
  chomp(my @mounted = `mount`);
  my $output;
  for(@mounted) {
    next if(/!Filesystem/);
    if($_ =~ m;(^/dev/sd.+) on;) {
      my $df = `df -h $1|tail -1`;
      my ($dev, $size, $used, $avail, $percent, $mountp) = split(/\s+/, $df);
      $output .= "^fg(#ff0000)$mountp^fg(): ^fg(#ffff00)$avail^fg()/^fg(#cc0acd)$size^fg()^fg(#484848) | ";
    }
  }
  return("$output\n");
}



print getdf();

# vim: set tw=99999:
