Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A72721BADAB6
 for <linux-nvdimm@lists.01.org>; Fri,  1 Jun 2018 16:28:27 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, ars: don't invalidate the user-provided command
Date: Fri,  1 Jun 2018 17:28:14 -0600
Message-Id: <20180601232814.27865-1-vishal.l.verma@intel.com>
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

In ndctl_cmd_ars_in_progress, which expects a successfully completed
ars_status command, we used to invalidate the command by setting its
status to '1', so that the user has to provide a fresh ars_status
command the next time this check is performed.

In hindsight, this is needless and violates the principle of least
surprise. We shouldn't be touching the user's data (command), so remove
this invalidation. If the user uses the same ars_status command again,
we will simply report that ARS is still in progress.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/ars.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
index b199646..48a9819 100644
--- a/ndctl/lib/ars.c
+++ b/ndctl/lib/ars.c
@@ -224,16 +224,7 @@ NDCTL_EXPORT int ndctl_cmd_ars_in_progress(struct ndctl_cmd *cmd)
 	if (!validate_ars_stat(ctx, cmd))
 		return 0;
 
-	if (ndctl_cmd_get_firmware_status(cmd) == 1 << 16) {
-		/*
-		 * If in-progress, invalidate the ndctl_cmd, so
-		 * that if we're called again without a fresh
-		 * ars_status command, we fail.
-		 */
-		cmd->status = 1;
-		return 1;
-	}
-	return 0;
+	return (ndctl_cmd_get_firmware_status(cmd) == 1 << 16);
 }
 
 NDCTL_EXPORT unsigned int ndctl_cmd_ars_num_records(struct ndctl_cmd *ars_stat)
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
