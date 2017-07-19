Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31F5821D0B67E
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 11:37:32 -0700 (PDT)
Subject: [ndctl PATCH 1/6] ndctl,
 daxctl: propagate loglevel to internal libdaxctl instance
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jul 2017 11:33:01 -0700
Message-ID: <150048918187.12895.1688931392526619513.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If someone turns on libndctl debug they automatically get libdaxctl
debug output from the internal library instance.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 6607b68d4dd2..68d806444589 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -704,6 +704,8 @@ NDCTL_EXPORT int ndctl_get_log_priority(struct ndctl_ctx *ctx)
 NDCTL_EXPORT void ndctl_set_log_priority(struct ndctl_ctx *ctx, int priority)
 {
 	ctx->ctx.log_priority = priority;
+	/* forward the debug level to our internal libdaxctl instance */
+	daxctl_set_log_priority(ctx->daxctl_ctx, priority);
 }
 
 static char *__dev_path(char *type, int major, int minor, int parent)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
