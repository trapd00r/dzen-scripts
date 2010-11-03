#!/usr/bin/perl
use strict;

my $i_mail = "/home/scp1/devel/dzen-scripts/bitmaps/envelope.xbm";
my $i_temp = "/home/scp1/devel/dzen-scripts/bitmaps/xbm8x8/arch.xbm";

sub mail {
  my @mail  = glob("/mnt/Docs/Mail/inbox/new/*");
  my $count = scalar(@mail);

  return("^i($i_mail) ^fg(#242424)0^fg()") if($count < 1);

  my $subject = 'NULL';

  open(my $fh, '<', $mail[$#mail]) or die($!);
  my @c = <$fh>;

  for(@c) {
    if($_ =~ m;^Subject: (.+);) {
      $subject = $1;
    }
  }
  if($subject =~ /UTF-8/) {
    for(@c) {
      if($_ =~ /^From: .* <(.+)>/) {
        $subject = $1;
      }
    }
  }
  $subject = sprintf("%.70s", $subject);

  $subject =~ s/(Re):(.+)/^fg(#c12c00)$1^fg():^fg(#c18400)$2^fg()/;
  $subject =~ s/(\[)(.+)(\])/^fg(#ffffff)$1^fg(#80c100)$2^fg(#ffffff)$3^fg()/g;
  $subject =~ s/=\?ISO-8859-1\?q\?//;
  $subject =~ s/=E5/a/;
  return("^fg(#e2ffa8)^i($i_mail) ^fg(#ff0000)$count^fg(#484848) (^fg(#b8cca5)$subject^fg(#484848))^fg()");
}

sub clock {
  my(undef,$m,$h) = localtime(time);

  return(sprintf("%02d:%02d:%02d", $h, $m));
}

sub temp {
  chomp(my $temp = `curl -s http://www.temperatur.nu/termo/norrkoping/temp.txt`);
  if($temp <= 0 and $temp <= 5) {
    $temp = "^fg(#hcb1f3)$temp^fg()";
  }
  elsif($temp <= 6 and $temp <= 10) {
    $temp = "^fg(#37a2f5)$temp^fg()";
  }
  elsif($temp <= 11 and $temp <= 15) {
    $temp = "^fg(#37f56e)$temp^fg()";
  }
  elsif($temp <= 16 and $temp <= 20) {
    $temp = "^fg(#f5a737)$temp^fg()";
  }
  elsif($temp <= 21 and $temp <= 25) {
    $temp = "^fg(#f55c37)$temp^fg()";
  }
  elsif($temp <= 26 and $temp <= 30) {
    $temp = "^fg(#ec2615)$temp^fg()";
  }
  else {
    $temp = "^fg(#ff0000)$temp^fg()"; # works until -1°C
  }
  $temp = sprintf(" %s", $temp);
  return("^fg(#15c8ec)^i($i_temp) $temp^fg(#999999)°C^fg()");
}

sub im {
  open(my $ssh, '-|', "ssh -p 19216 scp1\@192.168.1.100 'cat /home/scp1/irclogs/192/bitlbee_current.log'") or die($!);
  my @want = grep{/>> scp1/} <$ssh>;

  my($who,$msg) = $want[scalar(@want)-1] =~ m/\S+\s+(.+) >> scp1> (.+)/;

  return("^fg(#78ae00) $who^fg(#ffffff)~ ^fg(#888888)'^fg(#abaca7)$msg^fg(#888888)'^fg() ");
}

print
  im()
  .
  "^fg(#ffffff)"
  . temp()
  . "^fg(#789afa) | ^fg(#888888)"
  . mail()
  . "^fg(#789afa) | ^fg(#888888)"
  . clock()

  . "\n";

# vim: set tw=99999:
