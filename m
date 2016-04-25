Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 0E5011A1E58
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 12:51:00 -0700 (PDT)
Subject: [ndctl PATCH 4/7] ndctl: drop asciidocs and xmlto requirement for
 --disable-docs
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2016 12:50:10 -0700
Message-ID: <146161381045.21779.4730246280477763860.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The --disable-docs option added the ability to skip building the
Documentation directory, however configure.ac was still checking
needlessly for the support packages.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/configure.ac b/configure.ac
index 01f347a7f137..c50ba3dfc1d9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -32,13 +32,23 @@ AC_PREFIX_DEFAULT([/usr])
 
 AC_PROG_SED
 AC_PROG_MKDIR_P
+
+AC_ARG_ENABLE([docs],
+        AS_HELP_STRING([--disable-docs],
+	[disable documentation build @<:@default=enabled@:>@]),
+        [], enable_docs=yes)
+AS_IF([test "x$enable_docs" = "xyes"], [
+        AC_DEFINE(ENABLE_DOCS, [1], [Documentation / man pages.])
+])
+AM_CONDITIONAL([ENABLE_DOCS], [test "x$enable_docs" = "xyes"])
+
 AC_CHECK_PROG(ASCIIDOC, [asciidoc], [$(which asciidoc)], [missing])
-if test "x$ASCIIDOC" = xmissing; then
+if test "x$ASCIIDOC" = xmissing -a "x$enable_docs" = "xyes"; then
        AC_MSG_ERROR([asciidoc needed to build documentation])
 fi
 AC_SUBST([ASCIIDOC])
 AC_CHECK_PROG(XMLTO, [xmlto], [$(which xmlto)], [missing])
-if test "x$XMLTO" = xmissing; then
+if test "x$XMLTO" = xmissing -a "x$enable_docs" = "xyes"; then
        AC_MSG_ERROR([xmlto needed to build documentation])
 fi
 AC_SUBST([XMLTO])
@@ -58,15 +68,6 @@ AS_IF([test "x$enable_logging" = "xyes"], [
         AC_DEFINE(ENABLE_LOGGING, [1], [System logging.])
 ])
 
-AC_ARG_ENABLE([docs],
-        AS_HELP_STRING([--disable-docs],
-	[disable documentation build @<:@default=enabled@:>@]),
-        [], enable_docs=yes)
-AS_IF([test "x$enable_docs" = "xyes"], [
-        AC_DEFINE(ENABLE_DOCS, [1], [Documentation / man pages.])
-])
-AM_CONDITIONAL([ENABLE_DOCS], [test "x$enable_docs" = "xyes"])
-
 AC_ARG_ENABLE([debug],
         AS_HELP_STRING([--enable-debug], [enable debug messages @<:@default=disabled@:>@]),
         [], [enable_debug=no])

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
