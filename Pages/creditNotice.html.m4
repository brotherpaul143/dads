dnl $Id: creditNotice.html.m4,v 1.14 2011/12/06 20:58:45 black Exp $
dnl
dnl *created  "Thu Jun  2 11:17:54 2005" *by "Paul E. Black"
dnl *modified "Wed Oct 16 12:54:15 2013" *by "Paul E. Black"
dnl
dnl Revision 2.0  Fri Jul 13 11:11:32 SAST 2012  vreda
dnl Remove NIST exit script bit and used bits for top image and people
dnl
dnl Revision 1.14  2011/12/06 20:58:45  black
dnl Include new NIST exit script bit, instead of hardcoding the URL
dnl
dnl Revision 1.13  2010/05/03 16:42:20  black
dnl "How to Cite Online Documents" is no longer online, that I can find.
dnl
dnl Revision 1.12  2009/04/27 20:16:58  black
dnl update CRC Press permission page.
dnl
dnl Revision 1.11  2009/02/04 14:48:30  black
dnl Replace hardcoded DADS URL root with included file.  Make created and
dnl modified lines m4 comments, instead of HTML comments, so they don't
dnl appear in the final HTML.
dnl
dnl Revision 1.10  2008/10/06 14:43:52  black
dnl Update reference - Collections Canada no longer has excerpts on-line,
dnl only a citation guide "based on the International Standard IO 690-2".
dnl Add RCS Log keyword
dnl
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en-US">
<head>
<title>citing and crediting DADS</title>
<!-- turn off Microsoft's added smart tags -->
<meta name="MSSmartTagsPreventParsing" content="TRUE">
<link rel="stylesheet" type="text/css" href="$ROOTDIR/dads.css">
</head>
<body>
include(`Pages/bitsImageLogos.m4')
<center><h2>Dictionary of Algorithms and Data Structures</h2></center>
<center><h1>Citation and Credit Notice</h1></center>

<p>
Some definitions are copyright CRC Press, such as
<a href="$ROOTDIR/HTML/depoissonization.html">depoissonization</a>.
You must get 
<a href="http://www.crcpress.com/managed_content/corporate/page.jsf?contentPath=/home/contact/04Rights.html">CRC Press
permission</a>
for those.  All others are public domain.
</p>

<p>
Many of the definitions, as well as the site itself, were originally developed at
the National Institute of Standards and Technology by employees of the
Federal Government in the course of their official duties.  Pursuant
to title 17 Section 105 of the United States Code these are not
subject to copyright protection and are in the public domain.
</p>

<p>
If you use definitions from the Dictionary, we would appreciate
acknowledgment.  If this site or the definitions are helpful, we would
appreciate a note expressing how valuable it is.
</p>

<H3>Citing the Dictionary</H3>

<p>
Here is a print citation.
<pre>
    Dictionary of Algorithms and Data Structures, Vreda Pieterse and Paul E. 
    Black eds., FASTAR and U.S. National Institute of Standards and 
    Technology, $ROOTDIR/, (ACCESS DATE).
</pre>
Put the latest date you accessed DADS in parentheses, for instance, 
2 July 2012.
</p>


<p>
Here is an HTML citation.
<pre>
In &lt;a href="$ROOTDIR/"&gt;Dictionary of 
Algorithms and Data Structures&lt;/a&gt; hosted by
&lt;a href="http://www.fastar.org/"&gt;FASTAR&lt;/a&gt;.
</pre>
</p>

<H3>Citing an Entry</H3>

<p>
Here is a bibtex citation for 
<a href="$ROOTDIR/HTML/rootedtree.html">rooted tree</a>.
<pre>
@Misc{dads:rt,
  author = {Paul M. Sant},
  title = {"rooted tree"},
  howpublished = {in \emph{Dictionary of Algorithms and Data Structures} [online], Vreda Pieterse and Paul E. Black eds.},
  month = {17 December}, % ENTRY MODIFIED DATE
  year = {2004},
  note =  {Available from: $ROOTDIR/HTML/rootedtree.html (accessed 19 April 2006)}, % LAST ACCESS DATE 
</pre>
The result should be something like this:<br><br>
Sant, Paul M. rooted tree. In <em>Dictionary of Algorithms and Data Structures</em> [online], Paul E. Black and Vreda Pieterse eds. 17 December 2004. Available from: $ROOTDIR/HTML/rootedtree.html. (accessed 19 April 2006)
</p>

<H3>Citation References</H3>

<p>
These try to follow ISO 690-2 Information and documentation -- Bibliographic references -- Part 2: Electronic documents or parts thereof, upon which
"How to Cite Online Documents" is based.
</p>

<hr>

Go to the
<a href="$ROOTDIR/">Dictionary of Algorithms and Data
Structures</a> home page.

<hr>

<em>Created
Thu Jun  2 11:21:13 2005
</em>
include(`Pages/bitsPaul.m4')
dnl following lines updated by emacs macros
<em>Updated
Wed Oct 16 12:54:15 2013
</em>
by <a href="http://hissa.nist.gov/~black/">Paul E. Black
</a>

<p>
This page's URL is
<a href="$ROOTDIR/Other/creditNotice.html">$ROOTDIR/Other/creditNotice.html</a>
</p>

<center>
<p>
include(`Pages/bitsHOSTis.m4')
</p>
</center>

</body>
</html>