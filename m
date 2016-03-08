Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 7E7A71A1ED0
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:37:13 -0800 (PST)
Subject: [ndctl PATCH 1/8] ndctl: make --enable-local the default
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 15:36:33 -0800
Message-ID: <20160308233633.18628.65570.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
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

Using the kernel provided header is only useful when you want to
de-feature ndctl at compile-time.  Otherwise, ndctl is responsible for
failing gracefully when it finds it is running against an older kernel
that is missing newer capabilities.  The kernel is responsible for
making sure that old ndctl binaries continue to operate on newer
kernels.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3f61b6de250e..9506e8e7dd25 100644
--- a/configure.ac
+++ b/configure.ac
@@ -85,8 +85,8 @@ PKG_CHECK_MODULES([UUID], [uuid])
 PKG_CHECK_MODULES([JSON], [json-c])
 
 AC_ARG_ENABLE([local],
-        AS_HELP_STRING([--enable-local], [build with local ndctl.h @<:@default=system@:>@]),
-        [], [enable_local=no])
+        AS_HELP_STRING([--disable-local], [build against kernel ndctl.h @<:@default=system@:>@]),
+        [], [enable_local=yes])
 
 AS_IF([test "x$enable_local" = "xyes"], [], [
 	AC_CHECK_HEADER([linux/ndctl.h], [

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
