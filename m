Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0DE9021A00ACB
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 17:10:40 -0700 (PDT)
Subject: [ndctl PATCH] Documentation: refactor ndctl and daxctl man pages
 into respective sub-directories
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jun 2017 17:05:43 -0700
Message-ID: <149869474308.20678.999370565945664687.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

The manpage template has global references to the base utility name.
This leads to the header for daxctl having the following header and
footer:

    DAXCTL(1)  ndctl Manual  DAXCTL(1)

    ndctl 57.9.g3d9a255  06/28/2017  DAXCTL(1)

The 'ndctl' references should say 'daxctl'.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/asciidoc.conf.in                  |   24 +++++++--------
 Documentation/daxctl/Makefile.am                |   38 +++++++++++++++++++++++
 Documentation/daxctl/daxctl-list.txt            |    0 
 Documentation/daxctl/daxctl.txt                 |    4 +-
 Documentation/ndctl/Makefile.am                 |   14 +++++---
 Documentation/ndctl/dimm-description.txt        |    0 
 Documentation/ndctl/labels-description.txt      |    0 
 Documentation/ndctl/labels-options.txt          |    0 
 Documentation/ndctl/namespace-description.txt   |    0 
 Documentation/ndctl/ndctl-check-labels.txt      |    0 
 Documentation/ndctl/ndctl-check-namespace.txt   |    0 
 Documentation/ndctl/ndctl-create-namespace.txt  |    0 
 Documentation/ndctl/ndctl-destroy-namespace.txt |    0 
 Documentation/ndctl/ndctl-disable-dimm.txt      |    0 
 Documentation/ndctl/ndctl-disable-namespace.txt |    0 
 Documentation/ndctl/ndctl-disable-region.txt    |    0 
 Documentation/ndctl/ndctl-enable-dimm.txt       |    0 
 Documentation/ndctl/ndctl-enable-namespace.txt  |    0 
 Documentation/ndctl/ndctl-enable-region.txt     |    0 
 Documentation/ndctl/ndctl-init-labels.txt       |    0 
 Documentation/ndctl/ndctl-list.txt              |    0 
 Documentation/ndctl/ndctl-read-labels.txt       |    0 
 Documentation/ndctl/ndctl-write-labels.txt      |    0 
 Documentation/ndctl/ndctl-zero-labels.txt       |    0 
 Documentation/ndctl/ndctl.txt                   |    0 
 Documentation/ndctl/region-description.txt      |    0 
 Documentation/ndctl/xable-dimm-options.txt      |    0 
 Documentation/ndctl/xable-namespace-options.txt |    0 
 Documentation/ndctl/xable-region-options.txt    |    0 
 Makefile.am                                     |    2 +
 configure.ac                                    |    3 +-
 31 files changed, 64 insertions(+), 21 deletions(-)
 rename Documentation/{asciidoc.conf => asciidoc.conf.in} (79%)
 create mode 100644 Documentation/daxctl/Makefile.am
 rename Documentation/{daxctl-list.txt => daxctl/daxctl-list.txt} (100%)
 rename Documentation/{daxctl.txt => daxctl/daxctl.txt} (89%)
 rename Documentation/{Makefile.am => ndctl/Makefile.am} (86%)
 rename Documentation/{dimm-description.txt => ndctl/dimm-description.txt} (100%)
 rename Documentation/{labels-description.txt => ndctl/labels-description.txt} (100%)
 rename Documentation/{labels-options.txt => ndctl/labels-options.txt} (100%)
 rename Documentation/{namespace-description.txt => ndctl/namespace-description.txt} (100%)
 rename Documentation/{ndctl-check-labels.txt => ndctl/ndctl-check-labels.txt} (100%)
 rename Documentation/{ndctl-check-namespace.txt => ndctl/ndctl-check-namespace.txt} (100%)
 rename Documentation/{ndctl-create-namespace.txt => ndctl/ndctl-create-namespace.txt} (100%)
 rename Documentation/{ndctl-destroy-namespace.txt => ndctl/ndctl-destroy-namespace.txt} (100%)
 rename Documentation/{ndctl-disable-dimm.txt => ndctl/ndctl-disable-dimm.txt} (100%)
 rename Documentation/{ndctl-disable-namespace.txt => ndctl/ndctl-disable-namespace.txt} (100%)
 rename Documentation/{ndctl-disable-region.txt => ndctl/ndctl-disable-region.txt} (100%)
 rename Documentation/{ndctl-enable-dimm.txt => ndctl/ndctl-enable-dimm.txt} (100%)
 rename Documentation/{ndctl-enable-namespace.txt => ndctl/ndctl-enable-namespace.txt} (100%)
 rename Documentation/{ndctl-enable-region.txt => ndctl/ndctl-enable-region.txt} (100%)
 rename Documentation/{ndctl-init-labels.txt => ndctl/ndctl-init-labels.txt} (100%)
 rename Documentation/{ndctl-list.txt => ndctl/ndctl-list.txt} (100%)
 rename Documentation/{ndctl-read-labels.txt => ndctl/ndctl-read-labels.txt} (100%)
 rename Documentation/{ndctl-write-labels.txt => ndctl/ndctl-write-labels.txt} (100%)
 rename Documentation/{ndctl-zero-labels.txt => ndctl/ndctl-zero-labels.txt} (100%)
 rename Documentation/{ndctl.txt => ndctl/ndctl.txt} (100%)
 rename Documentation/{region-description.txt => ndctl/region-description.txt} (100%)
 rename Documentation/{xable-dimm-options.txt => ndctl/xable-dimm-options.txt} (100%)
 rename Documentation/{xable-namespace-options.txt => ndctl/xable-namespace-options.txt} (100%)
 rename Documentation/{xable-region-options.txt => ndctl/xable-region-options.txt} (100%)

diff --git a/Documentation/asciidoc.conf b/Documentation/asciidoc.conf.in
similarity index 79%
rename from Documentation/asciidoc.conf
rename to Documentation/asciidoc.conf.in
index 8c6ee4672c30..5a1f056761b9 100644
--- a/Documentation/asciidoc.conf
+++ b/Documentation/asciidoc.conf.in
@@ -1,4 +1,4 @@
-## linkndctl: macro
+## linkUTILITY: macro
 #
 # Copyright (c) 2005, Sergey Vlasov
 # Copyright (c) 2005, Jonas Fonseca
@@ -6,7 +6,7 @@
 # Originally copied from GIT source (commit d1c2e113c5b6 "[PATCH]
 # Documentation: Add asciidoc.conf file and gitlink: macro")
 #
-# Usage: linkndctl:command[manpage-section]
+# Usage: linkUTILITY:command[manpage-section]
 #
 # Note, {0} is the manpage section, while {target} is the command.
 #
@@ -14,7 +14,7 @@
 # the command.
 
 [macros]
-(?su)[\\]?(?P<name>linkndctl):(?P<target>\S*?)\[(?P<attrlist>.*?)\]=
+(?su)[\\]?(?P<name>linkUTILITY):(?P<target>\S*?)\[(?P<attrlist>.*?)\]=
 
 [attributes]
 asterisk=&#42;
@@ -25,7 +25,7 @@ endsb=&#93;
 tilde=&#126;
 
 ifdef::backend-docbook[]
-[linkndctl-inlinemacro]
+[linkUTILITY-inlinemacro]
 {0%{target}}
 {0#<citerefentry>}
 {0#<refentrytitle>{target}</refentrytitle><manvolnum>{0}</manvolnum>}
@@ -33,7 +33,7 @@ ifdef::backend-docbook[]
 endif::backend-docbook[]
 
 ifdef::backend-docbook[]
-ifndef::ndctl-asciidoc-no-roff[]
+ifndef::UTILITY-asciidoc-no-roff[]
 # "unbreak" docbook-xsl v1.68 for manpages. v1.69 works with or without this.
 # v1.72 breaks with this because it replaces dots not in roff requests.
 [listingblock]
@@ -48,9 +48,9 @@ ifdef::doctype-manpage[]
 endif::doctype-manpage[]
 </literallayout>
 {title#}</example>
-endif::ndctl-asciidoc-no-roff[]
+endif::UTILITY-asciidoc-no-roff[]
 
-ifdef::ndctl-asciidoc-no-roff[]
+ifdef::UTILITY-asciidoc-no-roff[]
 ifdef::doctype-manpage[]
 # The following two small workarounds insert a simple paragraph after screen
 [listingblock]
@@ -69,7 +69,7 @@ ifdef::doctype-manpage[]
 {title#}</para></formalpara>
 {title%}<simpara></simpara>
 endif::doctype-manpage[]
-endif::ndctl-asciidoc-no-roff[]
+endif::UTILITY-asciidoc-no-roff[]
 endif::backend-docbook[]
 
 ifdef::doctype-manpage[]
@@ -80,9 +80,9 @@ template::[header-declarations]
 <refmeta>
 <refentrytitle>{mantitle}</refentrytitle>
 <manvolnum>{manvolnum}</manvolnum>
-<refmiscinfo class="source">ndctl</refmiscinfo>
-<refmiscinfo class="version">{ndctl_version}</refmiscinfo>
-<refmiscinfo class="manual">ndctl Manual</refmiscinfo>
+<refmiscinfo class="source">UTILITY</refmiscinfo>
+<refmiscinfo class="version">{UTILITY_version}</refmiscinfo>
+<refmiscinfo class="manual">UTILITY Manual</refmiscinfo>
 </refmeta>
 <refnamediv>
   <refname>{manname}</refname>
@@ -92,6 +92,6 @@ endif::backend-docbook[]
 endif::doctype-manpage[]
 
 ifdef::backend-xhtml11[]
-[linkndctl-inlinemacro]
+[linkUTILITY-inlinemacro]
 <a href="{target}.html">{target}{0?({0})}</a>
 endif::backend-xhtml11[]
diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
new file mode 100644
index 000000000000..5913c94ca3be
--- /dev/null
+++ b/Documentation/daxctl/Makefile.am
@@ -0,0 +1,38 @@
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
+do_subst = sed -e 's,UTILITY,daxctl,g'
+
+asciidoc.conf: ../asciidoc.conf.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
+
+man1_MANS = \
+	daxctl.1 \
+	daxctl-list.1
+
+CLEANFILES = $(man1_MANS)
+
+XML_DEPS = \
+	../../version.m4 \
+	Makefile \
+	asciidoc.conf
+
+RM ?= rm -f
+
+%.xml: %.txt $(XML_DEPS)
+	$(AM_V_GEN)$(RM) $@+ $@ && \
+		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
+		--unsafe -adaxctl_version=$(VERSION) -o $@+ $< && \
+		mv $@+ $@
+
+%.1: %.xml
+	$(AM_V_GEN)$(RM) $@ && \
+		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
diff --git a/Documentation/daxctl-list.txt b/Documentation/daxctl/daxctl-list.txt
similarity index 100%
rename from Documentation/daxctl-list.txt
rename to Documentation/daxctl/daxctl-list.txt
diff --git a/Documentation/daxctl.txt b/Documentation/daxctl/daxctl.txt
similarity index 89%
rename from Documentation/daxctl.txt
rename to Documentation/daxctl/daxctl.txt
index 5e81b33fd24f..5da9746ea62a 100644
--- a/Documentation/daxctl.txt
+++ b/Documentation/daxctl/daxctl.txt
@@ -29,5 +29,5 @@ filesystem.
 
 SEE ALSO
 --------
-linkndctl:ndctl-create-namespace[1],
-linkndctl:ndctl-list[1]
+linkdaxctl:ndctl-create-namespace[1],
+linkdaxctl:ndctl-list[1]
diff --git a/Documentation/Makefile.am b/Documentation/ndctl/Makefile.am
similarity index 86%
rename from Documentation/Makefile.am
rename to Documentation/ndctl/Makefile.am
index a56c4f0e8888..229d9087bbd5 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -9,8 +9,12 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+do_subst = sed -e 's,UTILITY,ndctl,g'
+
+asciidoc.conf: ../asciidoc.conf.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
+
 man1_MANS = \
-	daxctl.1 \
 	ndctl.1 \
 	ndctl-zero-labels.1 \
 	ndctl-read-labels.1 \
@@ -26,14 +30,14 @@ man1_MANS = \
 	ndctl-create-namespace.1 \
 	ndctl-destroy-namespace.1 \
 	ndctl-check-namespace.1 \
-	ndctl-list.1 \
-	daxctl-list.1
+	ndctl-list.1
 
 CLEANFILES = $(man1_MANS)
 
 XML_DEPS = \
-	..//version.m4 \
+	../../version.m4 \
 	Makefile \
+	asciidoc.conf \
 	region-description.txt \
 	xable-region-options.txt \
 	dimm-description.txt \
@@ -52,4 +56,4 @@ RM ?= rm -f
 
 %.1: %.xml
 	$(AM_V_GEN)$(RM) $@ && \
-		$(XMLTO) -o . -m manpage-normal.xsl man $<
+		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
diff --git a/Documentation/dimm-description.txt b/Documentation/ndctl/dimm-description.txt
similarity index 100%
rename from Documentation/dimm-description.txt
rename to Documentation/ndctl/dimm-description.txt
diff --git a/Documentation/labels-description.txt b/Documentation/ndctl/labels-description.txt
similarity index 100%
rename from Documentation/labels-description.txt
rename to Documentation/ndctl/labels-description.txt
diff --git a/Documentation/labels-options.txt b/Documentation/ndctl/labels-options.txt
similarity index 100%
rename from Documentation/labels-options.txt
rename to Documentation/ndctl/labels-options.txt
diff --git a/Documentation/namespace-description.txt b/Documentation/ndctl/namespace-description.txt
similarity index 100%
rename from Documentation/namespace-description.txt
rename to Documentation/ndctl/namespace-description.txt
diff --git a/Documentation/ndctl-check-labels.txt b/Documentation/ndctl/ndctl-check-labels.txt
similarity index 100%
rename from Documentation/ndctl-check-labels.txt
rename to Documentation/ndctl/ndctl-check-labels.txt
diff --git a/Documentation/ndctl-check-namespace.txt b/Documentation/ndctl/ndctl-check-namespace.txt
similarity index 100%
rename from Documentation/ndctl-check-namespace.txt
rename to Documentation/ndctl/ndctl-check-namespace.txt
diff --git a/Documentation/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
similarity index 100%
rename from Documentation/ndctl-create-namespace.txt
rename to Documentation/ndctl/ndctl-create-namespace.txt
diff --git a/Documentation/ndctl-destroy-namespace.txt b/Documentation/ndctl/ndctl-destroy-namespace.txt
similarity index 100%
rename from Documentation/ndctl-destroy-namespace.txt
rename to Documentation/ndctl/ndctl-destroy-namespace.txt
diff --git a/Documentation/ndctl-disable-dimm.txt b/Documentation/ndctl/ndctl-disable-dimm.txt
similarity index 100%
rename from Documentation/ndctl-disable-dimm.txt
rename to Documentation/ndctl/ndctl-disable-dimm.txt
diff --git a/Documentation/ndctl-disable-namespace.txt b/Documentation/ndctl/ndctl-disable-namespace.txt
similarity index 100%
rename from Documentation/ndctl-disable-namespace.txt
rename to Documentation/ndctl/ndctl-disable-namespace.txt
diff --git a/Documentation/ndctl-disable-region.txt b/Documentation/ndctl/ndctl-disable-region.txt
similarity index 100%
rename from Documentation/ndctl-disable-region.txt
rename to Documentation/ndctl/ndctl-disable-region.txt
diff --git a/Documentation/ndctl-enable-dimm.txt b/Documentation/ndctl/ndctl-enable-dimm.txt
similarity index 100%
rename from Documentation/ndctl-enable-dimm.txt
rename to Documentation/ndctl/ndctl-enable-dimm.txt
diff --git a/Documentation/ndctl-enable-namespace.txt b/Documentation/ndctl/ndctl-enable-namespace.txt
similarity index 100%
rename from Documentation/ndctl-enable-namespace.txt
rename to Documentation/ndctl/ndctl-enable-namespace.txt
diff --git a/Documentation/ndctl-enable-region.txt b/Documentation/ndctl/ndctl-enable-region.txt
similarity index 100%
rename from Documentation/ndctl-enable-region.txt
rename to Documentation/ndctl/ndctl-enable-region.txt
diff --git a/Documentation/ndctl-init-labels.txt b/Documentation/ndctl/ndctl-init-labels.txt
similarity index 100%
rename from Documentation/ndctl-init-labels.txt
rename to Documentation/ndctl/ndctl-init-labels.txt
diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
similarity index 100%
rename from Documentation/ndctl-list.txt
rename to Documentation/ndctl/ndctl-list.txt
diff --git a/Documentation/ndctl-read-labels.txt b/Documentation/ndctl/ndctl-read-labels.txt
similarity index 100%
rename from Documentation/ndctl-read-labels.txt
rename to Documentation/ndctl/ndctl-read-labels.txt
diff --git a/Documentation/ndctl-write-labels.txt b/Documentation/ndctl/ndctl-write-labels.txt
similarity index 100%
rename from Documentation/ndctl-write-labels.txt
rename to Documentation/ndctl/ndctl-write-labels.txt
diff --git a/Documentation/ndctl-zero-labels.txt b/Documentation/ndctl/ndctl-zero-labels.txt
similarity index 100%
rename from Documentation/ndctl-zero-labels.txt
rename to Documentation/ndctl/ndctl-zero-labels.txt
diff --git a/Documentation/ndctl.txt b/Documentation/ndctl/ndctl.txt
similarity index 100%
rename from Documentation/ndctl.txt
rename to Documentation/ndctl/ndctl.txt
diff --git a/Documentation/region-description.txt b/Documentation/ndctl/region-description.txt
similarity index 100%
rename from Documentation/region-description.txt
rename to Documentation/ndctl/region-description.txt
diff --git a/Documentation/xable-dimm-options.txt b/Documentation/ndctl/xable-dimm-options.txt
similarity index 100%
rename from Documentation/xable-dimm-options.txt
rename to Documentation/ndctl/xable-dimm-options.txt
diff --git a/Documentation/xable-namespace-options.txt b/Documentation/ndctl/xable-namespace-options.txt
similarity index 100%
rename from Documentation/xable-namespace-options.txt
rename to Documentation/ndctl/xable-namespace-options.txt
diff --git a/Documentation/xable-region-options.txt b/Documentation/ndctl/xable-region-options.txt
similarity index 100%
rename from Documentation/xable-region-options.txt
rename to Documentation/ndctl/xable-region-options.txt
diff --git a/Makefile.am b/Makefile.am
index 2b467362f55c..ba81e8c3d5bb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,7 +3,7 @@ include Makefile.am.in
 ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
 SUBDIRS = . daxctl/lib ndctl/lib ndctl daxctl
 if ENABLE_DOCS
-SUBDIRS += Documentation
+SUBDIRS += Documentation/ndctl Documentation/daxctl
 endif
 SUBDIRS += test
 
diff --git a/configure.ac b/configure.ac
index e79623ac1d82..316f5b7c8b75 100644
--- a/configure.ac
+++ b/configure.ac
@@ -265,7 +265,8 @@ AC_CONFIG_FILES([
         ndctl/Makefile
         daxctl/Makefile
         test/Makefile
-        Documentation/Makefile
+        Documentation/ndctl/Makefile
+        Documentation/daxctl/Makefile
 ])
 
 AC_OUTPUT

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
