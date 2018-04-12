Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2BE03226EAC8C
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 04:08:06 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
 by mx2.suse.de (Postfix) with ESMTP id A865DACE0
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 11:08:03 +0000 (UTC)
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH ndctl 2/2] Documentation: Add the support for asciidoctor
Date: Thu, 12 Apr 2018 13:07:55 +0200
Message-Id: <20180412110755.31644-3-tiwai@suse.de>
In-Reply-To: <20180412110755.31644-1-tiwai@suse.de>
References: <20180412110755.31644-1-tiwai@suse.de>
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

Signed-off-by: Takashi Iwai <tiwai@suse.de>

---
 Documentation/asciidoctor-extensions.rb.in |   28 ++++++++++++++++++++++++++++
 Documentation/daxctl/Makefile.am           |   23 ++++++++++++++++++++---
 Documentation/ndctl/Makefile.am            |   23 ++++++++++++++++++++---
 configure.ac                               |   14 ++++++++++++--
 4 files changed, 80 insertions(+), 8 deletions(-)

--- /dev/null
+++ b/Documentation/asciidoctor-extensions.rb.in
@@ -0,0 +1,28 @@
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
--- a/Documentation/daxctl/Makefile.am
+++ b/Documentation/daxctl/Makefile.am
@@ -9,11 +9,28 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+if USE_ASCIIDOCTOR
+
+do_subst = sed -e 's,@Utility@,Daxctl,g' -e's,@utility@,daxctl,g'
+do_asciidoc = $(ASCIIDOC) -acompat-mode \
+	-amansource=daxctl -amanmanual="daxctl Manual"
+
+XMLTO += --skip-validation
+CONFFILE = asciidoctor-extensions.rb
+asciidoctor-extensions.rb: ../asciidoctor-extensions.rb.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
+
+else
+
 do_subst = sed -e 's,UTILITY,daxctl,g'
+do_asciidoc = $(ASCIIDOC) -f asciidoc.conf --unsafe
 
+CONFFILE = asciidoc.conf
 asciidoc.conf: ../asciidoc.conf.in
 	$(AM_V_GEN) $(do_subst) < $< > $@
 
+endif
+
 man1_MANS = \
 	daxctl.1 \
 	daxctl-list.1 \
@@ -24,14 +41,14 @@ CLEANFILES = $(man1_MANS)
 XML_DEPS = \
 	../../version.m4 \
 	Makefile \
-	asciidoc.conf
+	$(CONFFILE)
 
 RM ?= rm -f
 
 %.xml: %.txt $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
-		--unsafe -adaxctl_version=$(VERSION) -o $@+ $< && \
+		$(do_asciidoc) -b docbook -d manpage \
+		-adaxctl_version=$(VERSION) -o $@+ $< && \
 		mv $@+ $@
 
 %.1: %.xml
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -9,11 +9,28 @@
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 # General Public License for more details.
 
+if USE_ASCIIDOCTOR
+
+do_subst = sed -e 's,@Utility@,Ndctl,g' -e's,@utility@,ndctl,g'
+do_asciidoc = $(ASCIIDOC) -acompat-mode \
+	-amansource=ndctl -amanmanual="ndctl Manual"
+
+XMLTO += --skip-validation
+CONFFILE = asciidoctor-extensions.rb
+asciidoctor-extensions.rb: ../asciidoctor-extensions.rb.in
+	$(AM_V_GEN) $(do_subst) < $< > $@
+
+else
+
 do_subst = sed -e 's,UTILITY,ndctl,g'
+do_asciidoc = $(ASCIIDOC) -f asciidoc.conf --unsafe
 
+CONFFILE = asciidoc.conf
 asciidoc.conf: ../asciidoc.conf.in
 	$(AM_V_GEN) $(do_subst) < $< > $@
 
+endif
+
 man1_MANS = \
 	ndctl.1 \
 	ndctl-zero-labels.1 \
@@ -39,7 +56,7 @@ CLEANFILES = $(man1_MANS)
 XML_DEPS = \
 	../../version.m4 \
 	Makefile \
-	asciidoc.conf \
+	$(CONFFILE) \
 	region-description.txt \
 	xable-region-options.txt \
 	dimm-description.txt \
@@ -52,8 +69,8 @@ RM ?= rm -f
 
 %.xml: %.txt $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@+ $@ && \
-		$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
-		--unsafe -andctl_version=$(VERSION) -o $@+ $< && \
+		$(ASCIIDOC) -b docbook -d manpage \
+		-andctl_version=$(VERSION) -o $@+ $< && \
 		mv $@+ $@
 
 %.1: %.xml
--- a/configure.ac
+++ b/configure.ac
@@ -42,9 +42,19 @@ AS_IF([test "x$enable_docs" = "xyes"], [
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
 AC_CHECK_PROG(XMLTO, [xmlto], [$(which xmlto)], [missing])
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
