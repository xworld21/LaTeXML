#!/usr/bin/env perl

use XML::LibXSLT;
use XML::LibXML;

sub process_entity {
  my ($code) = @_;
  if ($code == 13) {
    return "\n"; }
  else {
    return sprintf("&#x%0" . ($code > 255 ? "4" : "2") . "X;", $code); } }

XML::LibXSLT->max_depth(3000);

my $parser = XML::LibXML->new();
my $xslt = XML::LibXSLT->new();

my $transform = $xslt->parse_stylesheet_file($ARGV[0]);
my $results = $transform->transform_file($ARGV[1]);
my $output = $transform->output_as_bytes($results);

$output =~ s/&#([0-9]*);/process_entity($1)/ge;

foreach $line (split(/^/, $output)) {
  if ($line =~ m/^( *)<xsl:(?:stylesheet|output)/) {
    my $indent = $1;
    $line =~ s/(<xsl:(?:stylesheet|output)|") /$1\n$indent  /g; }
  print($line);
}
