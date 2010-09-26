#!/usr/bin/perl
use strict;

sub mail {
  my $i_mail = "/home/scp1/devel/dzen-scripts/bitmaps/envelope.xbm";
  my @mail  = glob("/mnt/Docs/Mail/inbox/new/*");
  my $count = scalar(@mail);

  return("^i($i_mail) ^fg(#242424)0^fg()") if($count < 1);

  my $subject = 'NULL';

  open(my $fh, '<', $mail[$#mail]) or die($!);
  while(<$fh>) {
    if($_ =~ m;^Subject: (.+);) {
      $subject = $1;
    }
  }
  $subject = sprintf("%.40s", $subject);

  $subject =~ s/(Re):(.+)/^fg(#c12c00)$1^fg():^fg(#c18400)$2^fg()/;
  return("^i($i_mail) ^fg(#ff0000)$count^fg(#484848) (^fg(#b8cca5)$subject^fg(#484848))^fg()");
}

sub clock {
  my(undef,$m,$h) = localtime(time);

  return(sprintf("%02d:%02d:%02d", $h, $m));
}

print "^fg(#ffffff)"
  . mail()
  . "^fg(#789afa) | ^fg(#888888)"
  . clock()

  . "\n";

# vim: set tw=99999:
