Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1A6120971740
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 10:57:40 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: warn on variables declared after statement
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 May 2018 10:47:43 -0700
Message-ID: <152606086348.37490.2328471829579138286.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Similar to the kernel, require all variables to be declared before
statements.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac |    1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index 6dbfcee88f7d..da56c413bffd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -148,6 +148,7 @@ my_CFLAGS="\
 -Wstrict-prototypes \
 -Wtype-limits \
 -Wmaybe-uninitialized \
+-Wdeclaration-after-statement \
 -Wunused-result \
 -D_FORTIFY_SOURCE=2
 "

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
