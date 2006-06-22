#!/usr/bin/perl
#

use strict;

my $file;
my $extnext;
my @texfiles;

foreach my $name (@ARGV) {
  my @files;
  my $basename = $name;
  $basename =~ s/\.tex$//;
  open FH, "<$basename.log";
  while (<FH>) {
    $file = $1 if (m/^! LaTeX Error: File `(.+)' not found.$/);
    if (m/^I could not locate the file with any of these extensions:$/) {
      $extnext = 1;
      next;
    }

    if ($extnext == 1) {
      $extnext = 0;
      $file .= (split /,/)[0];
      push @files, $file;
      $file = undef;
    }
  }
  close FH;

  open FH, "<$basename.fls";
  while (<FH>) {
    if (m/^INPUT \.\/(.+\.tex)$/) {
        push @files, $1 unless ($1 eq $name);
        push @texfiles, $1;
    }
  }

  $"=" ";

  print "$basename.dvi: @files\n";
}

print ".depends: @texfiles\n";
