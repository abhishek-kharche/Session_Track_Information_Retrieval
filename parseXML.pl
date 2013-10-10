use strict;
use warnings;

use XML::Simple;															# XML parser for Perl
use Data::Dumper;
use Text::ParseWords;

my $filename = shift;
my $sessionNum = shift;

my $wB = qr/ |^|$/;
###STOPWORD File List
my $STOP_WORD_TEXT = "./stopWord.txt";										# Stop words for stemming

open STOP_WORD, "$STOP_WORD_TEXT" or die "Error opening $STOP_WORD_TEXT\n";
chomp(my @STOP_WORD = <STOP_WORD>);
close STOP_WORD;

### Concatenating all the stop words in the file
### seperated by spaces and forming a string

my $stopWordsString = join(" ",@STOP_WORD);									# Separating stop words by space
$stopWordsString = " ".$stopWordsString." ";


sub removeStopWords {
    my $entity = shift;
    $entity =~ s/^ +| +$//;
    $entity =~ s/ +/ /g;													# Removing extra spaces
    chomp $entity;
    my @tokens = split (" ",$entity);
    chomp @tokens;
    foreach my $token (@tokens)
    {
        my $lowerCaseToken = lc($token);

        if($stopWordsString =~ m/ $lowerCaseToken /)
        {
            $entity =~ s/($wB)$token($wB)/ /g;
            $entity =~ s/^ +| +$//;
            $entity =~ s/ +/ /g;
        }
    }
    $entity =~ s/^ +| +$//;
    $entity =~ s/ +/ /g;
    return $entity;
}

$sessionNum = $sessionNum - 1;
sub getTimeDiff {
    my $sTime = shift;
    my $eTime = shift;
}

sub mySort {
      my $aSTime = $a->{starttime};
      my $bSTime = $b->{starttime};
      my $aETime = $a->{endtime};
      my $bETime = $b->{endtime};
}

# Subroutine to get most dwell time clicked rank
sub getMostDwelledClickRank {
    my $clicked = shift;
    my @clickeds = @{$clicked};
    if($#clickeds == 0)
    {
        return $clickeds[0]->{rank};
    }
    else
    {
        my @sortedClicks = sort mySort @clickeds;
        return $sortedClicks[0]->{rank};
    }
}

# XML parser usage
my $xml = new XML::Simple;
my $ref = $xml->XMLin($filename);

my $session = $ref->{session}->[$sessionNum];
my @interactions;
if (ref ($session->{interaction}) eq 'ARRAY')
{
     @interactions = @{$session->{interaction}};							# Typecasting to an array
}
else
{
    push @interactions,$session->{interaction};
}

my $sNum = $sessionNum+1;
print "$sNum\n";
my $highestInteraction = 0;
foreach my $interaction (@interactions)
{
    my $clicked = $interaction->{clicked}->{click};
    my $interNum = $interaction->{num};
    my $query = $interaction->{query};

    my @lines = `java demo $sNum $interNum 2>/dev/null`;

    my $mostDwelledTitle ="";												# We are interested in only Title from XML file
    if (@lines and $#lines == 1)
    {
        $mostDwelledTitle = $lines[1];
        $mostDwelledTitle =~ s/\|//g;
        $mostDwelledTitle =~ s/\.\.\.//g;
        $mostDwelledTitle = removeStopWords($mostDwelledTitle);				# Will remove the stop words from the title extracted.
        ##print "\nInteraction Num: $interNum Title: $mostDwelledTitle \n";
    }
    $query =~ s|'|\\'|g;
    my @terms = parse_line('\s+',0,$query);
    foreach my $term (@terms)
    {
        $term =~ s|\\'|'|g;
        print  "\"$term\"^$interNum ";
    }
    if ($mostDwelledTitle ne "")
    {
         $mostDwelledTitle =~ s|'|\\'|g;
         my @terms1 = parse_line('\s+',0,$mostDwelledTitle);
         foreach my $term1 (@terms1)
         {
            $term1 =~ s|\\'|'|g;
            my $dwellWt = $interNum/2;
            print  "\"$term1\"^$dwellWt ";
         }
    }
    $highestInteraction = $interNum;

}


my $currentQuery = $session->{currentquery}->{query};
$currentQuery =~ s|'|\\'|g;
$highestInteraction = $highestInteraction + 1;
my @terms = parse_line('\s+',0,$currentQuery);
foreach my $term (@terms)
{
    $term =~ s|\\'|'|g;
    print  "\"$term\"^$highestInteraction ";
}
print  "\n";
