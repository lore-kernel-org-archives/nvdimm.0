Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8573A21A16EC6
 for <linux-nvdimm@lists.01.org>; Sat, 27 May 2017 12:10:22 -0700 (PDT)
Subject: [ndctl PATCH] clarify copyright and license information
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 May 2017 12:05:27 -0700
Message-ID: <149591192758.5065.18101733194684737455.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Breno Leitao <breno.leitao@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

The utility infrastructure copied from perf (which was copied from git)
is GPLv2. Files copied from perf / git have a "/* originally copied from
perf and git */" comment. All tests and documentation are also GPLv2.
The libraries (libndctl and libdaxctl) are LGPLv2.1.

Link: https://github.com/pmem/ndctl/issues/12
Reported-by: Breno Leitao <breno.leitao@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/COPYING                     |  345 +++++++++++++++++++++++++++++
 Documentation/Makefile.am                 |   11 +
 Documentation/asciidoc.conf               |    6 +
 Documentation/daxctl-list.txt             |    7 +
 Documentation/manpage-base.xsl            |    8 +
 Documentation/manpage-normal.xsl          |    8 +
 Documentation/ndctl-check-labels.txt      |    7 +
 Documentation/ndctl-check-namespace.txt   |    7 +
 Documentation/ndctl-create-namespace.txt  |    7 +
 Documentation/ndctl-destroy-namespace.txt |    7 +
 Documentation/ndctl-disable-dimm.txt      |    7 +
 Documentation/ndctl-disable-namespace.txt |    7 +
 Documentation/ndctl-disable-region.txt    |    7 +
 Documentation/ndctl-enable-dimm.txt       |    7 +
 Documentation/ndctl-enable-namespace.txt  |    7 +
 Documentation/ndctl-enable-region.txt     |    7 +
 Documentation/ndctl-init-labels.txt       |    7 +
 Documentation/ndctl-list.txt              |    6 +
 Documentation/ndctl-read-labels.txt       |    7 +
 Documentation/ndctl-zero-labels.txt       |    7 +
 Documentation/ndctl.txt                   |    7 +
 builtin.h                                 |   12 +
 daxctl/daxctl.c                           |   16 +
 daxctl/list.c                             |   12 +
 ndctl/bat.c                               |   12 +
 ndctl/create-nfit.c                       |   12 +
 ndctl/list.c                              |   12 +
 ndctl/namespace.c                         |    2 
 ndctl/ndctl.c                             |   16 +
 ndctl/region.c                            |   12 +
 ndctl/test.c                              |   12 +
 ndctl/util/json-smart.c                   |   12 +
 test.h                                    |   12 +
 test/blk-exhaust.sh                       |   12 +
 test/btt-check.sh                         |   11 +
 test/clear.sh                             |   12 +
 test/core.c                               |   12 +
 test/create.sh                            |   12 +
 test/dax-errors.c                         |   12 +
 test/dax-errors.sh                        |   11 +
 test/dax-pmd.c                            |   12 +
 test/dax.sh                               |   12 +
 test/daxdev-errors.c                      |   12 +
 test/daxdev-errors.sh                     |   11 +
 test/device-dax-fio.sh                    |   12 +
 test/device-dax.c                         |   12 +
 test/label-compat.sh                      |   12 +
 test/mmap.c                               |   12 +
 test/mmap.sh                              |   12 +
 test/multi-pmem.c                         |   12 +
 util/bitmap.c                             |   16 +
 util/bitmap.h                             |   12 +
 util/filter.c                             |   12 +
 util/filter.h                             |   12 +
 util/fletcher.c                           |   12 +
 util/help.c                               |   17 +
 util/json.c                               |   12 +
 util/json.h                               |   12 +
 util/main.c                               |   16 +
 util/main.h                               |   16 +
 util/parse-options.c                      |   15 +
 util/parse-options.h                      |   15 +
 util/size.c                               |   12 +
 util/size.h                               |   13 +
 util/strbuf.c                             |   15 +
 util/strbuf.h                             |   15 +
 util/usage.c                              |   15 +
 util/util.h                               |   16 +
 util/wrapper.c                            |   16 +
 69 files changed, 1096 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/COPYING

diff --git a/Documentation/COPYING b/Documentation/COPYING
new file mode 100644
index 000000000000..629351b0c631
--- /dev/null
+++ b/Documentation/COPYING
@@ -0,0 +1,345 @@
+All files in this directory (Documentation/) unless otherwise noted in
+the file itself are licensed under the GPLv2.
+
+---------
+
+		    GNU GENERAL PUBLIC LICENSE
+		       Version 2, June 1991
+
+ Copyright (C) 1989, 1991 Free Software Foundation, Inc.
+                       51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ Everyone is permitted to copy and distribute verbatim copies
+ of this license document, but changing it is not allowed.
+
+			    Preamble
+
+  The licenses for most software are designed to take away your
+freedom to share and change it.  By contrast, the GNU General Public
+License is intended to guarantee your freedom to share and change free
+software--to make sure the software is free for all its users.  This
+General Public License applies to most of the Free Software
+Foundation's software and to any other program whose authors commit to
+using it.  (Some other Free Software Foundation software is covered by
+the GNU Library General Public License instead.)  You can apply it to
+your programs, too.
+
+  When we speak of free software, we are referring to freedom, not
+price.  Our General Public Licenses are designed to make sure that you
+have the freedom to distribute copies of free software (and charge for
+this service if you wish), that you receive source code or can get it
+if you want it, that you can change the software or use pieces of it
+in new free programs; and that you know you can do these things.
+
+  To protect your rights, we need to make restrictions that forbid
+anyone to deny you these rights or to ask you to surrender the rights.
+These restrictions translate to certain responsibilities for you if you
+distribute copies of the software, or if you modify it.
+
+  For example, if you distribute copies of such a program, whether
+gratis or for a fee, you must give the recipients all the rights that
+you have.  You must make sure that they, too, receive or can get the
+source code.  And you must show them these terms so they know their
+rights.
+
+  We protect your rights with two steps: (1) copyright the software, and
+(2) offer you this license which gives you legal permission to copy,
+distribute and/or modify the software.
+
+  Also, for each author's protection and ours, we want to make certain
+that everyone understands that there is no warranty for this free
+software.  If the software is modified by someone else and passed on, we
+want its recipients to know that what they have is not the original, so
+that any problems introduced by others will not reflect on the original
+authors' reputations.
+
+  Finally, any free program is threatened constantly by software
+patents.  We wish to avoid the danger that redistributors of a free
+program will individually obtain patent licenses, in effect making the
+program proprietary.  To prevent this, we have made it clear that any
+patent must be licensed for everyone's free use or not licensed at all.
+
+  The precise terms and conditions for copying, distribution and
+modification follow.
+

+		    GNU GENERAL PUBLIC LICENSE
+   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
+
+  0. This License applies to any program or other work which contains
+a notice placed by the copyright holder saying it may be distributed
+under the terms of this General Public License.  The "Program", below,
+refers to any such program or work, and a "work based on the Program"
+means either the Program or any derivative work under copyright law:
+that is to say, a work containing the Program or a portion of it,
+either verbatim or with modifications and/or translated into another
+language.  (Hereinafter, translation is included without limitation in
+the term "modification".)  Each licensee is addressed as "you".
+
+Activities other than copying, distribution and modification are not
+covered by this License; they are outside its scope.  The act of
+running the Program is not restricted, and the output from the Program
+is covered only if its contents constitute a work based on the
+Program (independent of having been made by running the Program).
+Whether that is true depends on what the Program does.
+
+  1. You may copy and distribute verbatim copies of the Program's
+source code as you receive it, in any medium, provided that you
+conspicuously and appropriately publish on each copy an appropriate
+copyright notice and disclaimer of warranty; keep intact all the
+notices that refer to this License and to the absence of any warranty;
+and give any other recipients of the Program a copy of this License
+along with the Program.
+
+You may charge a fee for the physical act of transferring a copy, and
+you may at your option offer warranty protection in exchange for a fee.
+
+  2. You may modify your copy or copies of the Program or any portion
+of it, thus forming a work based on the Program, and copy and
+distribute such modifications or work under the terms of Section 1
+above, provided that you also meet all of these conditions:
+
+    a) You must cause the modified files to carry prominent notices
+    stating that you changed the files and the date of any change.
+
+    b) You must cause any work that you distribute or publish, that in
+    whole or in part contains or is derived from the Program or any
+    part thereof, to be licensed as a whole at no charge to all third
+    parties under the terms of this License.
+
+    c) If the modified program normally reads commands interactively
+    when run, you must cause it, when started running for such
+    interactive use in the most ordinary way, to print or display an
+    announcement including an appropriate copyright notice and a
+    notice that there is no warranty (or else, saying that you provide
+    a warranty) and that users may redistribute the program under
+    these conditions, and telling the user how to view a copy of this
+    License.  (Exception: if the Program itself is interactive but
+    does not normally print such an announcement, your work based on
+    the Program is not required to print an announcement.)
+

+These requirements apply to the modified work as a whole.  If
+identifiable sections of that work are not derived from the Program,
+and can be reasonably considered independent and separate works in
+themselves, then this License, and its terms, do not apply to those
+sections when you distribute them as separate works.  But when you
+distribute the same sections as part of a whole which is a work based
+on the Program, the distribution of the whole must be on the terms of
+this License, whose permissions for other licensees extend to the
+entire whole, and thus to each and every part regardless of who wrote it.
+
+Thus, it is not the intent of this section to claim rights or contest
+your rights to work written entirely by you; rather, the intent is to
+exercise the right to control the distribution of derivative or
+collective works based on the Program.
+
+In addition, mere aggregation of another work not based on the Program
+with the Program (or with a work based on the Program) on a volume of
+a storage or distribution medium does not bring the other work under
+the scope of this License.
+
+  3. You may copy and distribute the Program (or a work based on it,
+under Section 2) in object code or executable form under the terms of
+Sections 1 and 2 above provided that you also do one of the following:
+
+    a) Accompany it with the complete corresponding machine-readable
+    source code, which must be distributed under the terms of Sections
+    1 and 2 above on a medium customarily used for software interchange; or,
+
+    b) Accompany it with a written offer, valid for at least three
+    years, to give any third party, for a charge no more than your
+    cost of physically performing source distribution, a complete
+    machine-readable copy of the corresponding source code, to be
+    distributed under the terms of Sections 1 and 2 above on a medium
+    customarily used for software interchange; or,
+
+    c) Accompany it with the information you received as to the offer
+    to distribute corresponding source code.  (This alternative is
+    allowed only for noncommercial distribution and only if you
+    received the program in object code or executable form with such
+    an offer, in accord with Subsection b above.)
+
+The source code for a work means the preferred form of the work for
+making modifications to it.  For an executable work, complete source
+code means all the source code for all modules it contains, plus any
+associated interface definition files, plus the scripts used to
+control compilation and installation of the executable.  However, as a
+special exception, the source code distributed need not include
+anything that is normally distributed (in either source or binary
+form) with the major components (compiler, kernel, and so on) of the
+operating system on which the executable runs, unless that component
+itself accompanies the executable.
+
+If distribution of executable or object code is made by offering
+access to copy from a designated place, then offering equivalent
+access to copy the source code from the same place counts as
+distribution of the source code, even though third parties are not
+compelled to copy the source along with the object code.
+

+  4. You may not copy, modify, sublicense, or distribute the Program
+except as expressly provided under this License.  Any attempt
+otherwise to copy, modify, sublicense or distribute the Program is
+void, and will automatically terminate your rights under this License.
+However, parties who have received copies, or rights, from you under
+this License will not have their licenses terminated so long as such
+parties remain in full compliance.
+
+  5. You are not required to accept this License, since you have not
+signed it.  However, nothing else grants you permission to modify or
+distribute the Program or its derivative works.  These actions are
+prohibited by law if you do not accept this License.  Therefore, by
+modifying or distributing the Program (or any work based on the
+Program), you indicate your acceptance of this License to do so, and
+all its terms and conditions for copying, distributing or modifying
+the Program or works based on it.
+
+  6. Each time you redistribute the Program (or any work based on the
+Program), the recipient automatically receives a license from the
+original licensor to copy, distribute or modify the Program subject to
+these terms and conditions.  You may not impose any further
+restrictions on the recipients' exercise of the rights granted herein.
+You are not responsible for enforcing compliance by third parties to
+this License.
+
+  7. If, as a consequence of a court judgment or allegation of patent
+infringement or for any other reason (not limited to patent issues),
+conditions are imposed on you (whether by court order, agreement or
+otherwise) that contradict the conditions of this License, they do not
+excuse you from the conditions of this License.  If you cannot
+distribute so as to satisfy simultaneously your obligations under this
+License and any other pertinent obligations, then as a consequence you
+may not distribute the Program at all.  For example, if a patent
+license would not permit royalty-free redistribution of the Program by
+all those who receive copies directly or indirectly through you, then
+the only way you could satisfy both it and this License would be to
+refrain entirely from distribution of the Program.
+
+If any portion of this section is held invalid or unenforceable under
+any particular circumstance, the balance of the section is intended to
+apply and the section as a whole is intended to apply in other
+circumstances.
+
+It is not the purpose of this section to induce you to infringe any
+patents or other property right claims or to contest validity of any
+such claims; this section has the sole purpose of protecting the
+integrity of the free software distribution system, which is
+implemented by public license practices.  Many people have made
+generous contributions to the wide range of software distributed
+through that system in reliance on consistent application of that
+system; it is up to the author/donor to decide if he or she is willing
+to distribute software through any other system and a licensee cannot
+impose that choice.
+
+This section is intended to make thoroughly clear what is believed to
+be a consequence of the rest of this License.
+

+  8. If the distribution and/or use of the Program is restricted in
+certain countries either by patents or by copyrighted interfaces, the
+original copyright holder who places the Program under this License
+may add an explicit geographical distribution limitation excluding
+those countries, so that distribution is permitted only in or among
+countries not thus excluded.  In such case, this License incorporates
+the limitation as if written in the body of this License.
+
+  9. The Free Software Foundation may publish revised and/or new versions
+of the General Public License from time to time.  Such new versions will
+be similar in spirit to the present version, but may differ in detail to
+address new problems or concerns.
+
+Each version is given a distinguishing version number.  If the Program
+specifies a version number of this License which applies to it and "any
+later version", you have the option of following the terms and conditions
+either of that version or of any later version published by the Free
+Software Foundation.  If the Program does not specify a version number of
+this License, you may choose any version ever published by the Free Software
+Foundation.
+
+  10. If you wish to incorporate parts of the Program into other free
+programs whose distribution conditions are different, write to the author
+to ask for permission.  For software which is copyrighted by the Free
+Software Foundation, write to the Free Software Foundation; we sometimes
+make exceptions for this.  Our decision will be guided by the two goals
+of preserving the free status of all derivatives of our free software and
+of promoting the sharing and reuse of software generally.
+
+			    NO WARRANTY
+
+  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
+FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
+OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
+PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
+OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
+TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
+PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
+REPAIR OR CORRECTION.
+
+  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
+WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
+REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
+INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
+OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
+TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
+YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
+PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
+POSSIBILITY OF SUCH DAMAGES.
+
+		     END OF TERMS AND CONDITIONS
+

+	    How to Apply These Terms to Your New Programs
+
+  If you develop a new program, and you want it to be of the greatest
+possible use to the public, the best way to achieve this is to make it
+free software which everyone can redistribute and change under these terms.
+
+  To do so, attach the following notices to the program.  It is safest
+to attach them to the start of each source file to most effectively
+convey the exclusion of warranty; and each file should have at least
+the "copyright" line and a pointer to where the full notice is found.
+
+    <one line to give the program's name and a brief idea of what it does.>
+    Copyright (C) <year>  <name of author>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+
+
+Also add information on how to contact you by electronic and paper mail.
+
+If the program is interactive, make it output a short notice like this
+when it starts in an interactive mode:
+
+    Gnomovision version 69, Copyright (C) year name of author
+    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
+    This is free software, and you are welcome to redistribute it
+    under certain conditions; type `show c' for details.
+
+The hypothetical commands `show w' and `show c' should show the appropriate
+parts of the General Public License.  Of course, the commands you use may
+be called something other than `show w' and `show c'; they could even be
+mouse-clicks or menu items--whatever suits your program.
+
+You should also get your employer (if you work as a programmer) or your
+school, if any, to sign a "copyright disclaimer" for the program, if
+necessary.  Here is a sample; alter the names:
+
+  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
+  `Gnomovision' (which makes passes at compilers) written by James Hacker.
+
+  <signature of Ty Coon>, 1 April 1989
+  Ty Coon, President of Vice
+
+This General Public License does not permit incorporating your program into
+proprietary programs.  If your program is a subroutine library, you may
+consider it more useful to permit linking proprietary applications with the
+library.  If this is what you want to do, use the GNU Library General
+Public License instead of this License.
diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index d72085df4845..c7e0758c39df 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -1,3 +1,14 @@
+# Copyright(c) 2015-2017 Intel Corporation.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 man1_MANS = \
 	ndctl.1 \
 	ndctl-zero-labels.1 \
diff --git a/Documentation/asciidoc.conf b/Documentation/asciidoc.conf
index 26a822a17b7b..8c6ee4672c30 100644
--- a/Documentation/asciidoc.conf
+++ b/Documentation/asciidoc.conf
@@ -1,5 +1,11 @@
 ## linkndctl: macro
 #
+# Copyright (c) 2005, Sergey Vlasov
+# Copyright (c) 2005, Jonas Fonseca
+#
+# Originally copied from GIT source (commit d1c2e113c5b6 "[PATCH]
+# Documentation: Add asciidoc.conf file and gitlink: macro")
+#
 # Usage: linkndctl:command[manpage-section]
 #
 # Note, {0} is the manpage section, while {target} is the command.
diff --git a/Documentation/daxctl-list.txt b/Documentation/daxctl-list.txt
index 3e559e5de957..6de8d828de27 100644
--- a/Documentation/daxctl-list.txt
+++ b/Documentation/daxctl-list.txt
@@ -72,3 +72,10 @@ OPTIONS
 -i::
 --idle::
 	Include idle (not enabled / zero-sized) devices in the listing
+
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
diff --git a/Documentation/manpage-base.xsl b/Documentation/manpage-base.xsl
index a264fa616093..7bf007c332ce 100644
--- a/Documentation/manpage-base.xsl
+++ b/Documentation/manpage-base.xsl
@@ -1,3 +1,11 @@
+<!--
+Copyright (c) 2006, Sean Estabrooks
+Copyright (c) 2009, Chris Johnsen
+
+Originally copied from GIT source (commits 775e994af5b8 "Properly render
+asciidoc "callouts" in git man pages." and c30e9485238b "Documentation:
+move callouts.xsl to manpage-{base,normal}.xsl")
+-->
 <!-- manpage-base.xsl:
      special formatting for manpages rendered from asciidoc+docbook -->
 <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
diff --git a/Documentation/manpage-normal.xsl b/Documentation/manpage-normal.xsl
index a48f5b11f3dc..538cf609aedf 100644
--- a/Documentation/manpage-normal.xsl
+++ b/Documentation/manpage-normal.xsl
@@ -1,3 +1,11 @@
+<!--
+Copyright (c) 2006, Sean Estabrooks
+Copyright (c) 2009, Chris Johnsen
+
+Originally copied from GIT source (commits 775e994af5b8 "Properly render
+asciidoc "callouts" in git man pages." and c30e9485238b "Documentation:
+move callouts.xsl to manpage-{base,normal}.xsl")
+-->
 <!-- manpage-normal.xsl:
      special settings for manpages rendered from asciidoc+docbook
      handles anything we want to keep away from docbook-xsl 1.72.0 -->
diff --git a/Documentation/ndctl-check-labels.txt b/Documentation/ndctl-check-labels.txt
index 22d219cc9afd..210eb23caf66 100644
--- a/Documentation/ndctl-check-labels.txt
+++ b/Documentation/ndctl-check-labels.txt
@@ -19,6 +19,13 @@ OPTIONS
 -------
 include::labels-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
diff --git a/Documentation/ndctl-check-namespace.txt b/Documentation/ndctl-check-namespace.txt
index 232f22d7f774..07fe15ac5485 100644
--- a/Documentation/ndctl-check-namespace.txt
+++ b/Documentation/ndctl-check-namespace.txt
@@ -56,6 +56,13 @@ OPTIONS
 --region=::
 include::xable-region-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-disable-namespace[1],
diff --git a/Documentation/ndctl-create-namespace.txt b/Documentation/ndctl-create-namespace.txt
index 6007214658b6..85d1f8db792f 100644
--- a/Documentation/ndctl-create-namespace.txt
+++ b/Documentation/ndctl-create-namespace.txt
@@ -146,6 +146,13 @@ OPTIONS
 --region=::
 include::xable-region-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-zero-labels[1],
diff --git a/Documentation/ndctl-destroy-namespace.txt b/Documentation/ndctl-destroy-namespace.txt
index 623820533cec..8130b2156452 100644
--- a/Documentation/ndctl-destroy-namespace.txt
+++ b/Documentation/ndctl-destroy-namespace.txt
@@ -22,6 +22,13 @@ include::xable-namespace-options.txt[]
 	Specifying --force causes the namespace to be disabled before
 	the operation is attempted.
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-create-namespace[1]
diff --git a/Documentation/ndctl-disable-dimm.txt b/Documentation/ndctl-disable-dimm.txt
index b87314ffd197..b767402e93b8 100644
--- a/Documentation/ndctl-disable-dimm.txt
+++ b/Documentation/ndctl-disable-dimm.txt
@@ -17,6 +17,13 @@ OPTIONS
 <dimm>::
 include::xable-dimm-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-enable-dimm[1]
diff --git a/Documentation/ndctl-disable-namespace.txt b/Documentation/ndctl-disable-namespace.txt
index 067bc76f9148..5304ff97b900 100644
--- a/Documentation/ndctl-disable-namespace.txt
+++ b/Documentation/ndctl-disable-namespace.txt
@@ -16,6 +16,13 @@ OPTIONS
 -------
 include::xable-namespace-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-disable-namespace[1]
diff --git a/Documentation/ndctl-disable-region.txt b/Documentation/ndctl-disable-region.txt
index 812a00d096f0..5871ebe09650 100644
--- a/Documentation/ndctl-disable-region.txt
+++ b/Documentation/ndctl-disable-region.txt
@@ -17,6 +17,13 @@ OPTIONS
 <region>::
 include::xable-region-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-enable-region[1]
diff --git a/Documentation/ndctl-enable-dimm.txt b/Documentation/ndctl-enable-dimm.txt
index 0b0c6e0c965e..5b399c20bd15 100644
--- a/Documentation/ndctl-enable-dimm.txt
+++ b/Documentation/ndctl-enable-dimm.txt
@@ -17,6 +17,13 @@ OPTIONS
 <dimm>::
 include::xable-dimm-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-disable-dimm[1]
diff --git a/Documentation/ndctl-enable-namespace.txt b/Documentation/ndctl-enable-namespace.txt
index ece7b7e803e3..69971a0f68a1 100644
--- a/Documentation/ndctl-enable-namespace.txt
+++ b/Documentation/ndctl-enable-namespace.txt
@@ -16,6 +16,13 @@ OPTIONS
 -------
 include::xable-namespace-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-disable-namespace[1]
diff --git a/Documentation/ndctl-enable-region.txt b/Documentation/ndctl-enable-region.txt
index cd425aa286f2..c4939e0f7caa 100644
--- a/Documentation/ndctl-enable-region.txt
+++ b/Documentation/ndctl-enable-region.txt
@@ -17,6 +17,13 @@ OPTIONS
 <region>::
 include::xable-region-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-disable-region[1]
diff --git a/Documentation/ndctl-init-labels.txt b/Documentation/ndctl-init-labels.txt
index 6e5cc3578efa..a5c0c127e279 100644
--- a/Documentation/ndctl-init-labels.txt
+++ b/Documentation/ndctl-init-labels.txt
@@ -76,6 +76,13 @@ include::labels-options.txt[]
 	be an existing / valid namespace index.  Warning, this will
 	destroy all defined namespaces on the dimm.
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index da90860e061f..fd67d2b3e0ba 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -180,6 +180,12 @@ include::xable-region-options.txt[]
   ]
 }
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl-read-labels.txt b/Documentation/ndctl-read-labels.txt
index ecef164c3283..a1640d6ff566 100644
--- a/Documentation/ndctl-read-labels.txt
+++ b/Documentation/ndctl-read-labels.txt
@@ -25,6 +25,13 @@ include::labels-options.txt[]
 	parse the label data into json assuming the 'NVDIMM Namespace
 	Specification' format.
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
diff --git a/Documentation/ndctl-zero-labels.txt b/Documentation/ndctl-zero-labels.txt
index 0fb832b02219..56dacf1c1714 100644
--- a/Documentation/ndctl-zero-labels.txt
+++ b/Documentation/ndctl-zero-labels.txt
@@ -18,6 +18,13 @@ OPTIONS
 -------
 include::labels-options.txt[]
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
diff --git a/Documentation/ndctl.txt b/Documentation/ndctl.txt
index c26cc2fa9318..b02f613f5030 100644
--- a/Documentation/ndctl.txt
+++ b/Documentation/ndctl.txt
@@ -30,6 +30,13 @@ supported by the tool include, provisioning capacity (namespaces), as
 well as enumerating/enabling/disabling the devices (dimms, regions,
 namspaces) associated with an NVDIMM bus.
 
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
+
 SEE ALSO
 --------
 linkndctl:ndctl-create-namespace[1],
diff --git a/builtin.h b/builtin.h
index a8bc848614f2..5c8b611b2ded 100644
--- a/builtin.h
+++ b/builtin.h
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #ifndef _NDCTL_BUILTIN_H_
 #define _NDCTL_BUILTIN_H_
 extern const char ndctl_usage_string[];
diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index 31d230a68756..91a4600e262f 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -1,3 +1,19 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 Andreas Ericsson. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
 #include <stdio.h>
 #include <errno.h>
 #include <string.h>
diff --git a/daxctl/list.c b/daxctl/list.c
index 9a48ad7477ff..3e3f822b0ea1 100644
--- a/daxctl/list.c
+++ b/daxctl/list.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
diff --git a/ndctl/bat.c b/ndctl/bat.c
index 5e14d39cfac5..5e84f6459890 100644
--- a/ndctl/bat.c
+++ b/ndctl/bat.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2014 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <syslog.h>
 #include <test.h>
diff --git a/ndctl/create-nfit.c b/ndctl/create-nfit.c
index ebcd7446d14f..6adfae7af014 100644
--- a/ndctl/create-nfit.c
+++ b/ndctl/create-nfit.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2014 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
diff --git a/ndctl/list.c b/ndctl/list.c
index befb3cfc6ffd..4d5050cb85e5 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 6e150b102dc3..895e39bb8c7d 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015-2016 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 4b08c9b2a8ff..d10718e5d9c7 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -1,3 +1,19 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 Andreas Ericsson. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
 #include <stdio.h>
 #include <errno.h>
 #include <string.h>
diff --git a/ndctl/region.c b/ndctl/region.c
index 0d46192fe6a4..cc3c133c3190 100644
--- a/ndctl/region.c
+++ b/ndctl/region.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
diff --git a/ndctl/test.c b/ndctl/test.c
index 01ff981749fc..285594f09cf2 100644
--- a/ndctl/test.c
+++ b/ndctl/test.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <limits.h>
 #include <syslog.h>
diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 94519da4678d..aaaa0de6a72b 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <limits.h>
 #include <util/json.h>
 #include <uuid/uuid.h>
diff --git a/test.h b/test.h
index 8abe13dd410c..1ff350a9c1ba 100644
--- a/test.h
+++ b/test.h
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #ifndef __TEST_H__
 #define __TEST_H__
 struct ndctl_test;
diff --git a/test/blk-exhaust.sh b/test/blk-exhaust.sh
index 24a1ec216767..b6991f6e120d 100755
--- a/test/blk-exhaust.sh
+++ b/test/blk-exhaust.sh
@@ -1,4 +1,16 @@
 #!/bin/bash -x
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
 BUS1="-b nfit_test.1"
diff --git a/test/btt-check.sh b/test/btt-check.sh
index 4c328fecbe88..5ec224b1d582 100755
--- a/test/btt-check.sh
+++ b/test/btt-check.sh
@@ -1,5 +1,16 @@
 #!/bin/bash -E
 
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 [ -f "../ndctl/ndctl" ] && [ -x "../ndctl/ndctl" ] && ndctl="../ndctl/ndctl"
 [ -f "./ndctl/ndctl" ] && [ -x "./ndctl/ndctl" ] && ndctl="./ndctl/ndctl"
 [ -z "$ndctl" ] && echo "Couldn't find an ndctl binary" && exit 1
diff --git a/test/clear.sh b/test/clear.sh
index 1af3789cc35b..a60c3d9264db 100755
--- a/test/clear.sh
+++ b/test/clear.sh
@@ -1,4 +1,16 @@
 #!/bin/bash -x
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 DEV=""
 NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
diff --git a/test/core.c b/test/core.c
index 1f6dd5966404..e0806ed24058 100644
--- a/test/core.c
+++ b/test/core.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <linux/version.h>
 #include <sys/utsname.h>
 #include <libkmod.h>
diff --git a/test/create.sh b/test/create.sh
index 992f2ff48ad0..4eea78a2e4fa 100755
--- a/test/create.sh
+++ b/test/create.sh
@@ -1,4 +1,16 @@
 #!/bin/bash -x
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 DEV=""
 NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
diff --git a/test/dax-errors.c b/test/dax-errors.c
index 9ea5c9146dd6..fde3ba03546f 100644
--- a/test/dax-errors.c
+++ b/test/dax-errors.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
diff --git a/test/dax-errors.sh b/test/dax-errors.sh
index 25615df44180..5af38592e336 100755
--- a/test/dax-errors.sh
+++ b/test/dax-errors.sh
@@ -1,5 +1,16 @@
 #!/bin/bash -x
 
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 DEV=""
 NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index a422e999896a..6276913a0fda 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
diff --git a/test/dax.sh b/test/dax.sh
index ae63f89b8e6b..e1f3c8f6ff79 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -1,4 +1,16 @@
 #!/bin/bash
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 MNT=test_dax_mnt
 FILE=image
 NDCTL="../ndctl/ndctl"
diff --git a/test/daxdev-errors.c b/test/daxdev-errors.c
index 321f942251b3..ba89b0c047a7 100644
--- a/test/daxdev-errors.c
+++ b/test/daxdev-errors.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <stdint.h>
 #include <stdbool.h>
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 143c834f1af8..4818a4a1efcf 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -1,5 +1,16 @@
 #!/bin/bash -x
 
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 DEV=""
 NDCTL="../ndctl/ndctl"
 DAXCTL="../daxctl/daxctl"
diff --git a/test/device-dax-fio.sh b/test/device-dax-fio.sh
index ab620b67027f..f2cbd4dc5a01 100755
--- a/test/device-dax-fio.sh
+++ b/test/device-dax-fio.sh
@@ -1,4 +1,16 @@
 #!/bin/bash
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 NDCTL="../ndctl/ndctl"
 rc=77
 
diff --git a/test/device-dax.c b/test/device-dax.c
index 7f19311f07b7..d9196a760cea 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <fcntl.h>
 #include <stdio.h>
 #include <errno.h>
diff --git a/test/label-compat.sh b/test/label-compat.sh
index ed26a583a320..8c9ee63ec8dc 100755
--- a/test/label-compat.sh
+++ b/test/label-compat.sh
@@ -1,4 +1,16 @@
 #!/bin/bash -x
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 NDCTL="../ndctl/ndctl"
 BUS="-b nfit_test.0"
 BUS1="-b nfit_test.1"
diff --git a/test/mmap.c b/test/mmap.c
index 1294af0a6863..b087ba872ba9 100644
--- a/test/mmap.c
+++ b/test/mmap.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015 Toshi Kani, Hewlett Packard Enterprise. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
diff --git a/test/mmap.sh b/test/mmap.sh
index fa2658a6c57c..f84012bc815f 100755
--- a/test/mmap.sh
+++ b/test/mmap.sh
@@ -1,4 +1,16 @@
 #!/bin/bash
+
+# Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+# 
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of version 2 of the GNU General Public License as
+# published by the Free Software Foundation.
+# 
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+
 MNT=test_mmap_mnt
 FILE=image
 DEV=""
diff --git a/test/multi-pmem.c b/test/multi-pmem.c
index abd5f3657eed..3e3c1037e016 100644
--- a/test/multi-pmem.c
+++ b/test/multi-pmem.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <errno.h>
 #include <unistd.h>
diff --git a/util/bitmap.c b/util/bitmap.c
index 31e8c3a8512c..8df8a3253f10 100644
--- a/util/bitmap.c
+++ b/util/bitmap.c
@@ -1,3 +1,19 @@
+/*
+ * Copyright(c) 2017 Intel Corporation. All rights reserved.
+ * Copyright(c) 2009 Akinobu Mita. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from the Linux kernel bitmap implementation */
+
 #include <stdlib.h>
 #include <util/size.h>
 #include <util/util.h>
diff --git a/util/bitmap.h b/util/bitmap.h
index 826ae28a64f7..11ef22cc657b 100644
--- a/util/bitmap.h
+++ b/util/bitmap.h
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #ifndef _NDCTL_BITMAP_H_
 #define _NDCTL_BITMAP_H_
 
diff --git a/util/filter.c b/util/filter.c
index 9e2133430433..74ab3535c98e 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
diff --git a/util/filter.h b/util/filter.h
index cc23bfd7bfc8..dcc537caaaf9 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #ifndef _UTIL_FILTER_H_
 #define _UTIL_FILTER_H_
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
diff --git a/util/fletcher.c b/util/fletcher.c
index cee2fc3cd5da..29778db833f5 100644
--- a/util/fletcher.c
+++ b/util/fletcher.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdlib.h>
 #include <stdbool.h>
 #include <util/fletcher.h>
diff --git a/util/help.c b/util/help.c
index 310a40bd83e8..8b8f9510407f 100644
--- a/util/help.c
+++ b/util/help.c
@@ -1,4 +1,21 @@
 /*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 Miklos Vajna. All rights reserved.
+ * Copyright(c) 2006 Linus Torvalds. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
+/*
  * builtin-help.c
  *
  * Builtin help command
diff --git a/util/json.c b/util/json.c
index 4ca33a628381..b718d747c285 100644
--- a/util/json.c
+++ b/util/json.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <limits.h>
 #include <util/json.h>
 #include <util/filter.h>
diff --git a/util/json.h b/util/json.h
index 1a6caeeb6e9e..966478466313 100644
--- a/util/json.h
+++ b/util/json.h
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #ifndef __NDCTL_JSON_H__
 #define __NDCTL_JSON_H__
 #include <stdio.h>
diff --git a/util/main.c b/util/main.c
index cb3c634e93f5..5f35dd9d1c3e 100644
--- a/util/main.c
+++ b/util/main.c
@@ -1,3 +1,19 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ * Copyright(c) 2006 Linus Torvalds. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
 #include <stdio.h>
 #include <errno.h>
 #include <string.h>
diff --git a/util/main.h b/util/main.h
index bdd4f701665c..bcfe9f304d6b 100644
--- a/util/main.h
+++ b/util/main.h
@@ -1,3 +1,19 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ * Copyright(c) 2006 Linus Torvalds. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
 #ifndef __MAIN_H__
 #define __MAIN_H__
 struct cmd_struct;
diff --git a/util/parse-options.c b/util/parse-options.c
index 387eecd6db73..751c0916d3d3 100644
--- a/util/parse-options.c
+++ b/util/parse-options.c
@@ -1,3 +1,18 @@
+/*
+ * Copyright(c) 2007 Pierre Habouzit. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
 #include <stdio.h>
 #include <string.h>
 #include <sys/types.h>
diff --git a/util/parse-options.h b/util/parse-options.h
index 8826d3afe99f..6fd6b2418296 100644
--- a/util/parse-options.h
+++ b/util/parse-options.h
@@ -1,3 +1,18 @@
+/*
+ * Copyright(c) 2007 Pierre Habouzit. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
 #ifndef __NDCTL_PARSE_OPTIONS_H
 #define __NDCTL_PARSE_OPTIONS_H
 
diff --git a/util/size.c b/util/size.c
index da76bd94aebd..f54ae5b870b8 100644
--- a/util/size.c
+++ b/util/size.c
@@ -1,3 +1,15 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
 #include <stdlib.h>
 #include <limits.h>
 #include <util/size.h>
diff --git a/util/size.h b/util/size.h
index 4af14eb7d150..3c27079fc2b8 100644
--- a/util/size.h
+++ b/util/size.h
@@ -1,3 +1,16 @@
+/*
+ * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
 #ifndef _NDCTL_SIZE_H_
 #define _NDCTL_SIZE_H_
 
diff --git a/util/strbuf.c b/util/strbuf.c
index d4642516d338..eaa5bedf7e60 100644
--- a/util/strbuf.c
+++ b/util/strbuf.c
@@ -1,3 +1,18 @@
+/*
+ * Copyright(c) 2005 Junio C Hamano. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/types.h>
diff --git a/util/strbuf.h b/util/strbuf.h
index 4eb341a50e76..21bb7c446aab 100644
--- a/util/strbuf.h
+++ b/util/strbuf.h
@@ -1,3 +1,18 @@
+/*
+ * Copyright(c) 2005 Junio C Hamano. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
 #ifndef __NDCTL_STRBUF_H
 #define __NDCTL_STRBUF_H
 #include <string.h>
diff --git a/util/usage.c b/util/usage.c
index 9e0da8ab4551..0896955c7f52 100644
--- a/util/usage.c
+++ b/util/usage.c
@@ -1,11 +1,18 @@
 /*
- * usage.c
+ * Copyright(c) 2005 Linus Torvalds. All rights reserved.
  *
- * Various reporting routines.
- * Originally copied from GIT source.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
  *
- * Copyright (C) Linus Torvalds, 2005
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
  */
+
+/* originally copied from perf and git */
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
diff --git a/util/util.h b/util/util.h
index 04103cee2752..162aade1817d 100644
--- a/util/util.h
+++ b/util/util.h
@@ -1,3 +1,19 @@
+/*
+ * Copyright(c) 2005 Junio C Hamano. All rights reserved.
+ * Copyright(c) 2005 Linus Torvalds. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
 #ifndef __UTIL_H__
 #define __UTIL_H__
 #include <stdarg.h>
diff --git a/util/wrapper.c b/util/wrapper.c
index 21be2304fd90..b0de7bc92bb1 100644
--- a/util/wrapper.c
+++ b/util/wrapper.c
@@ -1,4 +1,20 @@
 /*
+ * Copyright(c) 2005 Junio C Hamano. All rights reserved.
+ * Copyright(c) 2005 Linus Torvalds. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+/* originally copied from perf and git */
+
+/*
  * Various trivial helper wrappers around standard functions
  */
 #include <string.h>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
