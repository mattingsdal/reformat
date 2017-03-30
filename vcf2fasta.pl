#!/bin/perl
#This script takes a vcf file phased by beagle, and outputs a vcf, by windows
use strict;
use warnings;

my $tag = $ARGV[0]; #Thing to stick on fasta names

my(%table) = (
        'AC' => 'M',
        'CA' => 'M',
        'AG' => 'R',
        'GA' => 'R',
        'AT' => 'W',
        'TA' => 'W',
        'CG' => 'S',
        'GC' => 'S',
        'CT' => 'Y',
        'TC' => 'Y',
        'TG' => 'K',
        'GT' => 'K',
        'AA' => 'A',
        'CC' => 'C',
        'GG' => 'G',
        'TT' => 'T',
        'NN' => 'N',
);

my %ind;
my %sites;
while(<STDIN>){
  chomp;
  if ($_ =~ m/^##/){next;}
  my @a = split(/\t/,$_);
  if ($_ =~ m/^#/){
    foreach my $i (9..$#a){
      $ind{$i} = $a[$i];
    }
  }else{
    my $chr = $a[0];
    my $pos = $a[1];
    my $ref = $a[3];
    my $alt = $a[4];
    foreach my $i(9..$#a){
      my @tmp = split(/:/,$a[$i]);
      my $call = $tmp[0];
      my @bases = split(/\//,$call);
      my $current_call;
      foreach my $j (0..1){
        if ($bases[$j] eq "0"){
          $current_call .= $ref;
        }elsif($bases[$j] eq "1"){
          $current_call .= $alt;
        }elsif($bases[$j] eq '.'){
	  $current_call .= "N";
	}
       
      }
      my $code = $table{$current_call};
      $sites{$ind{$i}} .= $code;
    }
  }
}
&print_fasta;

sub print_fasta {
  my @a = sort values %ind;
  foreach my $i (0..$#a){
    print  ">$a[$i]\n";
    print  "$sites{$a[$i]}\n";
  }
}

