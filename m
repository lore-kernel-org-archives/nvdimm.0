Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D2ECA21952CD7
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 14:55:50 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, log: save errno over calls to emit log messages
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Jun 2017 14:50:33 -0700
Message-ID: <149704503297.35935.12657932919759124474.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Some ndctl routines return errno after logging a result. Given the log
message may have updated errno save and restore it over calls to
->log_fn().

Suggested-by: Andy Rudoff <andy.rudoff@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/log.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/util/log.c b/util/log.c
index 8ecaf11d3d64..cc4d7d8aad7c 100644
--- a/util/log.c
+++ b/util/log.c
@@ -14,16 +14,19 @@
 #include <stdlib.h>
 #include <ctype.h>
 #include <string.h>
+#include <errno.h>
 #include <util/log.h>
 
 void do_log(struct log_ctx *ctx, int priority, const char *file,
 		int line, const char *fn, const char *format, ...)
 {
 	va_list args;
+	int errno_save = errno;
 
 	va_start(args, format);
 	ctx->log_fn(ctx, priority, file, line, fn, format, args);
 	va_end(args);
+	errno = errno_save;
 }
 
 static void log_stderr(struct log_ctx *ctx, int priority, const char *file,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
