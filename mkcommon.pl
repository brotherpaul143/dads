# $Id: mkcommon.pl,v 1.5 2001/11/30 18:26:18 black Exp $
# *created  "Tue Apr  3 15:51:02 2001" *by "Paul E. Black"
# *modified "Fri Nov 30 13:15:50 2001" *by "Paul E. Black"
#
# Common definitions and routines for format and indexing terms.
#
# This software was developed at the National Institute of Standards 
# and Technology by employees of the Federal Government in the course 
# of their official duties.  Pursuant to title 17 Section 105 of the 
# United States Code this software is not subject to copyright 
# protection and is in the public domain. 
# 
# We would appreciate acknowledgement if the software is used.
#
# Paul E. Black <paul.black@nist.gov> or <p.black@acm.org>
# http://hissa.nist.gov/~black/
#
#------------------------------------------------------------------------

# CONFIGURATION SECTION:
# set the following appropriately

# - The file system path of the web pages.
$WEB_DIR	="Target";
#$WEB_DIR	="TargetExt";
# - The URL to the main directory, that is,
#	$URL_DIR/$WEBPAGE.html is the URL for the main page and
#	$URL_DIR/$OUT_DIR/termFile.html is the URL for termFile.trm
#$URL_DIR	="http://hissa.nist.gov/dads";
$URL_DIR	="http://www.nist.gov/dads";

# Note: the *name=\value is a Perl 5.0-ism which says name refers to 
# value, and the reference cannot be changed.  Equivalent to declaring
# the name to be a constant or immutable.

# - The path of the directory which has term files.
*TERMS_DIR=\"Terms";
# - The extension of term files (.trm for now).
*TERM_EXT =\"trm";
# - The (path) name of file with the authors' initials, name, ref., etc. file
*AUTHORS  =\"authors.data";
# - The (path) name of file with the areas into which entries are classified
*AREAS	  =\"areas.data";
# - The (path) name of file with the admissible types of the entries
*TYPES	  =\"types.data";
# - The (path) name of the file with PERL substitutions to change LaTeX 
#	to the target language, e.g., HTML
*LATEXREWRITES = \"latex2html.data";
# - The path of the directory where term pages go, that is,
#	$WEB_DIR/$OUT_DIR/termFile.html is the path for termFile.trm
*OUT_DIR  =\"HTML";
# - The name of final (combined or main) web page, less extension 
#	(.html).  The page is written to $WEB_DIR/$WEBPAGE.html
*WEBPAGE  =\"terms";
# - Name of the main web page with extension
*MAINPAGE =\"$WEBPAGE.html";

#------------------------------------------------------------------------
#
# you should not have to edit anything below this
#
#------------------------------------------------------------------------

# defined entry properties
%properties = (
	NAME	=> 1,
	TYPE	=> 1,
	AREA	=> 1,
	DEFN	=> 1,
	FORML	=> 1,
	AKA	=> 1,
	WEB	=> 1,
	XREFS	=> 1,
	BIB	=> 1,
	NOTES	=> 1,
	AUTHOR	=> 1,
	IMPL	=> 1,
	LINKS	=> 1
);

# rename the existing page (topage) to be a backup, and rename the 
# new page (frompage) to be the existing page.  For instance, if
# there is page.html and newpage.html and we invoke
#	&backupMove("newpage.html", "page.html");
# we get page.html~ and page.html.
sub backupMove {
    my $frompage = $_[0];
    my $topage = $_[1];
    my $backuppage = "$topage~";

    # backup the existing page
    if (-e $topage) {
	unlink($backuppage);
	link($topage, $backuppage)
	    || print STDERR "Warning: cannot create backup page $backuppage\n";
	unlink($topage)
	    || print STDERR "Warning: cannot unlink page $topage\n";
    }

    # rename the temporary file
    link($frompage, $topage)
	|| die("Cannot link temporary file $frompage to $topage, stopped");
    unlink($frompage);
}

# "quote" characters which are special in regular expression patterns
sub quoteREpatterns ($) {
    my $expr = shift;

    $expr =~ s|\\|\\\\|g;
    $expr =~ s/\|/\\\|/g;
    $expr =~ s|\(|\\(|g;
    $expr =~ s|\)|\\)|g;
    $expr =~ s|\[|\\[|g;
    $expr =~ s|\{|\\{|g;
    $expr =~ s|\^|\\^|g;
    $expr =~ s|\$|\\\$|g;
    $expr =~ s|\*|\\*|g;
    $expr =~ s|\+|\\+|g;
    $expr =~ s|\?|\\?|g;
    $expr =~ s|\.|\\.|g;
    # we'll use / as separator, so it is special for us, too
    $expr =~ s|/|\\/|g;

    $expr;
}

# Rewrite any LaTeX expressions with those in latexRewrites
sub rewriteLatex ($) {
    if ($_[0] =~ /\$/) {
	# it has a dollar sign, so it is probably a LaTeX expression
	# print "Start : $_[0]\n";
	for $onesubs (@latexRewrites) {
	    #do {print "Before: $_[0]\n";}
	    1 while eval "\$_[0] =~ $onesubs";
	    # print "After : $_[0]\n";
	}

	# remove all $...$ brackets
	$_[0] =~ s/\$(.*?[^\\])\$/$1/g;
	# print "Final : $_[0]\n";
    }
}

#------------------------------------------------------------------------
#
# Step I: read initialization and config files
#
#------------------------------------------------------------------------

sub readConfigFiles {
    # Step Ia: read areas
    open(AREASFH, "< $AREAS")
	|| die("Cannot open areas file, $AREAS\n");

    while (<AREASFH>) {
	next if (/^ *\#/o); # skip comment lines
	chop;

	# get abbreviation and print name
	local ($abbrev, $areaPrintName) = split /\t+/;
	$areas{$abbrev} = $areaPrintName;
    }

    close AREASFH;

    # Step Ib: read types
    open(TYPESFH, "< $TYPES")
	|| die("Cannot open types file, $TYPES\n");

    while (<TYPESFH>) {
	next if (/^ *\#/o); # skip comment lines
	chop;

	# get abbreviation and print name
	local ($abbrev, $areaPrintName) = split /\t+/;
	$types{$abbrev} = $areaPrintName;
    }

    close TYPESFH;

    # Step Ic: read authors and their initials
    open(AUTHRS, "< $AUTHORS")
	|| die("Cannot open authors file, $AUTHORS\n");

    while (<AUTHRS>) {
	next if (/^ *\#/o);
	# get initials ($1), name ($2), and optional e-mail, url, etc. ($3)
	/^([^\t]*)\t([^\t]*)\t?(.*)?/o;
	$authors{$1} = $2;
	$authemail{$1} = $3;
    }

    close AUTHRS;

    # Step Id: read LaTeX rewrite expressions
    open(REWRTS, "< $LATEXREWRITES")
	|| die("Cannot open LaTeX rewrites file, $LATEXREWRITES\n");

    while (<REWRTS>) {
	my ($pat, $replace);
	next if /^\s*\#/o || /^\s*$/o; # skip comment and blank lines
	SWITCH: {
	    if (/^(\S*\{.*)\$(.*\}\S*\{.*)\$(\S*\})\s+(.*)\$(.*)\$(.*)/o) {
		# replace $...$lpat{$mid1}$cpat{$mid2}$rpat...$
		# with    $...$lrepl$mid1$crepl$mid2$rrepl...$
		my ($leftpat, $centerpat, $rightpat,
				$leftreplace, $centerreplace, $rightreplace);
		$leftpat  = quoteREpatterns($1);
		$centerpat= quoteREpatterns($2);
		$rightpat = quoteREpatterns($3);
		$pat = "$leftpat(.*?)$centerpat(.*?)$rightpat";
		$leftreplace  = quoteREpatterns($4);
		$centerreplace= quoteREpatterns($5);
		$rightreplace = quoteREpatterns($6);
		$replace = " $leftreplace\$2$centerreplace\$3$rightreplace";
		# print "REPLACE $pat\n";
		# print "with    $replace\n";
		last SWITCH;
	    }
	    if (/^(\S*\{.*)\$(\S*\})\s+(.*)\$(.*)/o) {
		# replace $...$lpat{$mid$rpat}...$
		# with    $...$lrepl$mid$rrepl...$
		my ($leftpat, $rightpat, $leftreplace, $rightreplace);
		$leftpat  = quoteREpatterns($1);
		$rightpat = quoteREpatterns($2);
		$pat = "$leftpat(.*?)$rightpat";
		$leftreplace  = quoteREpatterns($3);
		$rightreplace = quoteREpatterns($4);
		$replace = " $leftreplace\$2$rightreplace";
		# print "REPLACE $pat\n";
		# print "with    $replace\n";
		last SWITCH;
	    }
	    if (/^(\S*\{.*)\$(\S*\})\s+(.*)/o) {
		# replace $...$lpat{$mid$rpat}...$
		# with    $...$replace...$
		my ($leftpat, $rightpat);
		$leftpat  = quoteREpatterns($1);
		$rightpat = quoteREpatterns($2);
		$pat = "$leftpat(.*?)$rightpat";
		$replace  = quoteREpatterns($3);
		$replace = " $replace";
		# print "REPLACE $pat\n";
		# print "with    $replace\n";
		last SWITCH;
	    }
	    if (/^(\S+)\s*(.*)/o) {
		$pat = quoteREpatterns($1);
		$replace = $2;
		if (!($replace eq '"' || $replace eq ')' || $replace eq '}')) {
		    # pad everything but left-closers with a space so
		    # things like $s\in T$ look right
		    # HTML compresses spaces, so $s \in T$ looks right, too
		    $replace = " $replace";
		}
		$replace = quoteREpatterns($replace);
		last SWITCH;
	    }
	    {
		print "latex rewrite line ignored: $_";
		next;
	    }
	}

	# rewrite as a substitution within $'s
	# this means: replace $...$pat...$ with $...$replace...$
	push @latexRewrites,
		"s/(\\\$[^\\\$]*)$pat(?=.*?\\\$)/\$1$replace/g";
	# print "full: $latexRewrites[-1]\n";
    }

    close REWRTS;
}


#------------------------------------------------------------------------
#
# Step II: read term entries
#
#------------------------------------------------------------------------

sub addToDictionary (\%) {
    undef %entry; # make sure nothing is left over
    my(%entry, $entryRef);
    $entryRef = shift;
    %entry = %$entryRef;

    #for $fld (keys %entry) {
    #	print "\$entry\{$fld} = $entry{$fld}\n";
    #}

    # audit the entry
    if ($entry{NAME} =~ / $/) {
	print "NAME <<$entry{NAME}>> has a trailing blank in $entryFile\n";
    }
    if (defined $entry{TYPE}) {
	my($etype) = $entry{TYPE};
	if (! defined $types{$etype}) {
	    print "Unknown TYPE $etype in $entryFile\n";
	}
    }
    if (defined $entry{AREA}) {
	my($earea) = $entry{AREA};
	if (! defined $areas{$earea}) {
	    print "Unknown AREA $earea in $entryFile\n";
	}
    }
    if (defined $entry{AUTHOR}) {
	foreach $initials (split / *, */, $entry{AUTHOR}) {
	    if (! defined $authors{$initials}) {
		print "Unknown AUTHOR $initials in $entryFile\n";
	    }
	}
    }

    # NAME (ename in other places) is original name, e.g.,
    #		BB$\alpha<sub>2</sub>$ tree
    # XNAME is name without LaTeX markers to lookup cross references.
    #		BB\alpha<sub>2</sub> tree
    # DNAME is display name, e.g.,
    #		BB<src img="alpha.gif"><sub>2</sub> tree
    # TNAME is plain-text name, e.g., without HTML or LaTeX markers.
    #		BBalpha2 tree
    # alphname HERE is name used to alphabetize, e.g.,
    #		BBALPHATWOTREE
    #		bTHETA (where b is a blank)

    # save a version of the entry name without LaTeX markers for lookup
    ($entry{XNAME} = $entry{NAME}) =~ s/\$([^\$]*)\$/$1/go;

    # save a rich display version of the entry name
    rewriteLatex($entry{DNAME} = $entry{NAME});

    # save a plain text version of the entry name, i.e., without HTML
    my $tname;
    ($tname = $entry{NAME}) =~ s/<[^>]*>//go;
    $tname =~ s/\$([^\$]*)\$/$1/go;
    $tname =~ s/\\//go;
    ($entry{TNAME}) = $tname;

    # figure out the name to alphabetize this with
    my $alphaName = $entry{NAME};
    print STDERR "." if ($verbose); # progress indicator
    # index some numbers and symbols as words
    $alphaName =~ s/\b0\b/zero/g;
    $alphaName =~ s/\b1\b/one/g;
    $alphaName =~ s/\b2\b/two/g;
    $alphaName =~ s/\b3\b/three/g;
    $alphaName =~ s/\b4\b/four/g;
    $alphaName =~ s/[*]/star/go;
    $alphaName =~ s/[+]/plus/go;
    # remove any embedded html
    $alphaName =~ s/<[^>]*>//go;
    $startsWithSpecial = ($alphaName =~ /^\$\\/);
    # make all letters upper case and remove any remaining non-letter
    $alphaName =~ tr/A-Za-z\0-\377/A-ZA-Z/d;
    if ($startsWithSpecial) {
	# prepend a space so names with special characters come first
	$alphaName = " $alphaName";
    }
    # make sure entry name is unique
    while (defined $entries{$alphaName}) {
	$alphaName .= "Z";
    }

    #print "NAME is $entry{NAME}\n"
    #print "XNAME is $entry{XNAME}\n";
    #print "DNAME is $entry{DNAME}\n";
    #print "TNAME is $entry{TNAME}\n";
    #print "alphaName is $alphaName\n";

    # assign a file name if necessary (for AKA and WEB)
    if (! defined $entry{FILENM}) {
	$entry{FILENM} = $tname;

	# change all-caps words to all-lower case
	if ($entry{FILENM} =~ /^[A-Z]+$/) {
	    $entry{FILENM} =~ tr/A-Z/a-z/;
	}

	# capitalize words following spaces (change "..se na.." to "..seNa..")
	while ($entry{FILENM} =~ /( [a-z])/) {
	    my $patrn = $1;
	    (my $subst = $patrn) =~ tr/a-z/A-Z/;
	    $subst =~ s/ //;
	    #print "\n$entry{FILENM}\n";	# before
	    $entry{FILENM} =~ s/$patrn/$subst/g;
	    #print "$entry{FILENM}\n";		# after
	}

	# remove dashes and remaining spaces
	$entry{FILENM} =~ s/[- ]//go;
    }

    # remember this entry to find cross references
    $entriesForXref{$entry{XNAME}} = $alphaName;

    # save as a hash-of-hashes
    for $fld (keys %entry) {
	$entries{$alphaName}{$fld} = $entry{$fld};
    }

    $numEntriesInIndex++;
}

sub readTermEntries {
    print STDERR "Reading terms" if ($verbose);

    # Step IIa: get a list of all term entry files
    @entries=`ls $TERMS_DIR/[A-Za-z]*.$TERM_EXT`;

    #print @entries;

    # count the number of entries read
    my $numEntriesRead = 0;
    # count the entries in the index.  This adds AKA's
    $numEntriesInIndex = 0;

    # Step IIb: read each entry file and save the properties
    while ($entryFile = shift @entries) {
	undef %thisEntry; # make sure nothing is left over
	my($thisEntry) = {};

	chop $entryFile;

	open(ENTRY, "< $entryFile")
		|| print STDERR "Cannot open $entryFile\n" && next;

	while (<ENTRY>) {
	    if (/modified "([^"]+)"/) {
		$thisEntry{MODIFIED} = $1;
	    }

	    next if (/^ *\#/o); # skip comments

	    # look for property headers
	    if (s/^@([^=]*)=//o) {
		$prop=$1;
	    }
	    chop;
	    next if /^$/; # ignore empty lines
	    if (! defined $properties{$prop}) {
		print "Unknown property $prop in $entryFile\n";
	    }
	    if (defined $thisEntry{$prop}) {
		$thisEntry{$prop} .= " "; # space after existing stuff
	    }
	    $thisEntry{$prop} .= $_; # save the info
	}

	close ENTRY;

	$numEntriesRead++;

	# save the base of the file name (FILENM is used to create an HTML 
	# page, and SRCFILE is used to check for modification)
	($thisEntry{FILENM}) = ($entryFile =~ m|.*/([^.]*)|o);
	$thisEntry{SRCFILE} = $thisEntry{FILENM};

	# if no NAME given, make one from the file name
	if (! defined $thisEntry{NAME}) {
	    print "No entry NAME given in $entryFile\n";
	    # assign a default
	    ($thisEntry{NAME}) = ($thisEntry{FILENM});
	}

	# add entries for AKA (Also Known As) names
	if (defined $thisEntry{AKA}) {

	    my($ealiases) = $thisEntry{AKA};
	    #print "$thisEntry{NAME} is also known as";
	    foreach $aka (split /^ *{?|}?, *{?|}? *$/, $ealiases) {
		next if ($aka eq ""); # above RE may start with a null split

		#
		# create entry in database for this
		#

		my $akaEntry = {};
		$akaEntry{NAME} = $aka;
		$akaEntry{DEFN} = "See \{$thisEntry{NAME}}.";
		$akaEntry{SRCFILE} = $thisEntry{SRCFILE};
		if (defined $thisEntry{TYPE}) {
		    $akaEntry{TYPE} = $thisEntry{TYPE};
		}
		if (defined $thisEntry{AREA}) {
		    $akaEntry{AREA} = $thisEntry{AREA};
		}
		if (defined $thisEntry{IMPL}) {
		    $akaEntry{IMPL} = $thisEntry{IMPL};
		}
		if (defined $thisEntry{MODIFIED}) {
		    $akaEntry{MODIFIED} = $thisEntry{MODIFIED};
		}
		if (defined $thisEntry{AUTHOR}) {
		    $akaEntry{AUTHOR} = $thisEntry{AUTHOR};
		}

		addToDictionary %akaEntry;
	    }
	    #print "\n";
	}

	# add entries for WEB variants
	if (defined $thisEntry{WEB}) {
	    my($webaliases) = $thisEntry{WEB};
	    #print "$thisEntry{NAME} has variant(s) for web of";
	    foreach $webvar (split /^ *{?|}?, *{?|}? *$/, $webaliases) {
		next if ($webvar eq ""); # above RE may start with a null split
		#print " '$webvar'"; # for debugging
		# SKIMP create entry in database for this
	    }
	    #print "\n";
	}

	addToDictionary %thisEntry;
    }
    print STDERR "\n" if ($verbose);

    print "Read $numEntriesRead terms.  $numEntriesInIndex terms in index.\n";
}

# end of $Source: /home/black/DADS/dads/RCS/mkcommon.pl,v $
