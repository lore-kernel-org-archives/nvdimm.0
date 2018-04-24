Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94B582041B28B
 for <linux-nvdimm@lists.01.org>; Tue, 24 Apr 2018 03:17:36 -0700 (PDT)
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH ndctl v3 2/3] Documentation: Add the support for asciidoctor
Date: Tue, 24 Apr 2018 12:17:32 +0200
Message-Id: <20180424101733.17233-3-tiwai@suse.de>
In-Reply-To: <20180424101733.17233-1-tiwai@suse.de>
References: <20180424101733.17233-1-tiwai@suse.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch adds the support for asciidoctor to be used for generating
documents instead of asciidoc.  It's enabled via --enable-asciidoctor
configure option while asciidoc is used still as default.

In addition to the configure option, a few other changes were needed:
* some asciidoc.conf python stuff has to be replaced with asciidoctor
  ruby extension; copied mostly from git
* asciidoctor requires slightly different options
* the man pages are generated directly via asciidoctor without xmlto
  processing; less package dependency

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 Documentation/asciidoctor-extensions.rb.in | 30 ++++++++++++++++++++++++++++++
 Documentation/daxctl/Makefile.am           | 29 +++++++++++++++++++++++++++--
 Documentation/ndctl/Makefile.am            | 29 +++++++++++++++++++++++++++--
 configure.ac                               | 17 +++++++++++++++--
 4 files changed, 99 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/asciidoctor-extensions.rb.in

diff --git a/Documentation/asciidoctor-extensions.rb.in b/Documentation/asciidoctor-extensions.rb.in
new file mode 100644
index 000000000000..a0307d0cacef
--- /dev/null
+++ b/Documentation/asciidoctor-extensions.rb.in
@@ -0,0 +1,30 @@
+require 'asciidoctor'
+require 'asciidoctor/extensions'
+
+module @Utility@
+  module Documentation
+    class Link@Utility@Processor < Asciidoctor::Extensions::InlineMacroProcessor
+      use_dsl
+
+      named :chrome
+
+      def process(parent, target, attrs)
+        if parent.document.basebackend? 'html'
+          prefix = parent.document.attr('@utility@-relative-html-prefix')
+          %(<a href="#{prefix}#{target}.html">#{target}(#{attrs[1]})</a>\n)
+        elsif parent.document.basebackend? 'manpage'
+          "#{target}(#{attrs[1]})"
+        elsif parent.document.basebackend? 'docbook'
+          "<citerefentry>\n" \
+            "<refentrytitle>#{target}</refentrytitle>" \
+            "<manvolnum>#{attrs[1]}</manvolnum>\n" \
+          "</citerefentry>\n"
+        end
+      end
+    end
+  end
+end
+
+Asciidoctor::Extensions.register do
+  inline_macro @Utility@::Documentation::Link@Utility@Processor, :link@utility@
+end
diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
index 259dafd18e5e..fc0fbe138d93 100644
--- a/Documentation/daxctl/Makefile.am
+++ b/Documentation/daxctl/Makefile.am
@@ -9,11 +9,22 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
-do_subst = sed -e 's,UTILITY,daxctl,g'
+if USE_ASCIIDOCTOR
+
+do_subst = sed -e 's,@Utility@,Daxctl,g' -e's,@utility@,daxctl,g'
+CONFFILE = asciidoctor-extensions.rb
+asciidoctor-extensions.rb: ../asciidoctor-extensions.rb.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
 
+else
+
+do_subst = sed -e 's,UTILITY,daxctl,g'
+CONFFILE = asciidoc.conf
 asciidoc.conf: ../asciidoc.conf.in
 	$(AM_V_GEN) $(do_subst) < $< > $@
 
+endif
+
 man1_MANS = \
 	daxctl.1 \
 	daxctl-list.1
@@ -24,10 +35,22 @@ XML_DEPS = \
 	../../version.m4 \
 	../copyright.txt \
 	Makefile \
-	asciidoc.conf
+	$(CONFFILE)
 
 RM ?= rm -f
 
+if USE_ASCIIDOCTOR
+
+%.1: %.txt $(XML_DEPS)
+	$(AM_V_GEN)$(RM) $@+ $@ && \
+		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
+		-I. -rasciidoctor-extensions \
+		-amansource=daxctl -amanmanual="daxctl Manual" \
+		-andctl_version=$(VERSION) -o $@+ $< && \
+		mv $@+ $@
+
+else
+
 %.xml: %.txt $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@+ $@ && \
 		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
@@ -37,3 +60,5 @@ RM ?= rm -f
 %.1: %.xml $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@ && \
 		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
+
+endif
diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index fab05b91b23a..4fd9636faa0f 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -9,11 +9,22 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
-do_subst = sed -e 's,UTILITY,ndctl,g'
+if USE_ASCIIDOCTOR
+
+do_subst = sed -e 's,@Utility@,Ndctl,g' -e's,@utility@,ndctl,g'
+CONFFILE = asciidoctor-extensions.rb
+asciidoctor-extensions.rb: ../asciidoctor-extensions.rb.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
 
+else
+
+do_subst = sed -e 's,UTILITY,ndctl,g'
+CONFFILE = asciidoc.conf
 asciidoc.conf: ../asciidoc.conf.in
 	$(AM_V_GEN) $(do_subst) < $< > $@
 
+endif
+
 man1_MANS = \
 	ndctl.1 \
 	ndctl-wait-scrub.1 \
@@ -42,7 +53,7 @@ CLEANFILES = $(man1_MANS)
 XML_DEPS = \
 	../../version.m4 \
 	Makefile \
-	asciidoc.conf \
+	$(CONFFILE) \
 	../copyright.txt \
 	region-description.txt \
 	xable-region-options.txt \
@@ -55,6 +66,18 @@ XML_DEPS = \
 
 RM ?= rm -f
 
+if USE_ASCIIDOCTOR
+
+%.1: %.txt $(XML_DEPS)
+	$(AM_V_GEN)$(RM) $@+ $@ && \
+		$(ASCIIDOC) -b manpage -d manpage -acompat-mode \
+		-I. -rasciidoctor-extensions \
+		-amansource=ndctl -amanmanual="ndctl Manual" \
+		-andctl_version=$(VERSION) -o $@+ $< && \
+		mv $@+ $@
+
+else
+
 %.xml: %.txt $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@+ $@ && \
 		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
@@ -64,3 +87,5 @@ RM ?= rm -f
 %.1: %.xml $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@ && \
 		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
+
+endif
diff --git a/configure.ac b/configure.ac
index 3eaac32feb80..cddad16925f8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -42,16 +42,29 @@ AS_IF([test "x$enable_docs" = "xyes"], [
 ])
 AM_CONDITIONAL([ENABLE_DOCS], [test "x$enable_docs" = "xyes"])
 
-AC_CHECK_PROG(ASCIIDOC, [asciidoc], [$(which asciidoc)], [missing])
+AC_ARG_ENABLE([asciidoctor],
+	AS_HELP_STRING([--enable-asciidoctor],
+	[use asciidoctor for documentation build]),
+	[], enable_asciidoctor=no)
+AM_CONDITIONAL([USE_ASCIIDOCTOR], [test "x$enable_asciidoctor" = "xyes"])
+if test "x$enable_asciidoctor" = "xyes"; then
+	asciidoc="asciidoctor"
+else
+	asciidoc="asciidoc"
+fi
+AC_CHECK_PROG(ASCIIDOC, [$asciidoc], [$(which $asciidoc)], [missing])
 if test "x$ASCIIDOC" = xmissing -a "x$enable_docs" = "xyes"; then
-       AC_MSG_ERROR([asciidoc needed to build documentation])
+	AC_MSG_ERROR([$asciidoc needed to build documentation])
 fi
 AC_SUBST([ASCIIDOC])
+
+if test x"$asciidoc" = x"asciidoc"; then
 AC_CHECK_PROG(XMLTO, [xmlto], [$(which xmlto)], [missing])
 if test "x$XMLTO" = xmissing -a "x$enable_docs" = "xyes"; then
        AC_MSG_ERROR([xmlto needed to build documentation])
 fi
 AC_SUBST([XMLTO])
+fi
 
 AC_C_TYPEOF
 AC_DEFINE([HAVE_STATEMENT_EXPR], 1, [Define to 1 if you have statement expressions.])
-- 
2.16.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
