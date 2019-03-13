dnl $Id: entry.concl.m4,v 1.17 2009/02/04 14:44:15 black Exp $
dnl
dnl *created  "Wed May 30 21:35:10 2001" *by "Paul E. Black"
dnl *modified "Wed Mar 13 12:29:14 2019" *by "Paul E. Black"
dnl
dnl This is run through m4.  It is then used as the conclusion of
dnl every entry to make a complete entry page.
dnl
dnl $Log: entry.concl.m4,v $
dnl Wed Mar 13 12:41:59 2019  Paul E. Black
dnl Remove Vreda as editor.
dnl 
dnl Revision 2.0  Fri Jul 13 11:11:32 SAST 2012  vreda
dnl
dnl Revision 1.17  2009/02/04 14:44:15  black
dnl Replace hardcoded DADS URL root with an included file.  Change from
dnl regular file to m4 source so it can be run through m4 to include the
dnl file.  Add RCS keywords and created and modified dates as m4 "comments".
dnl
dnl
<hr>

Go to the
<a href="$ROOTDIR/">Dictionary of Algorithms and Data
Structures</a> home page.

<hr>

<p>
include(`Pages/bitsFixDefn.m4')
</p>

<p>
Entry modified $MODDATE.<br>
HTML page formatted $RUNDATE.
</p>

<p>
Cite this as:<br>
$AUTHORS"$DNAME", in
<a href="$ROOTDIR/"><em>Dictionary of Algorithms and Data Structures</em></a> [online], Paul E. Black, ed. $MODDATE. (accessed TODAY)
Available from: <a href="$URL">$URL</a>
</p>

</body>
</html>

