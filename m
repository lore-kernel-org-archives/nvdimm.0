Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 7374A1A1F64
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 16:46:00 -0800 (PST)
Subject: [ndctl PATCH 1/3] ndctl: fix ndctl_bus_cmd_new_ars_status() input
 validation
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Mar 2016 16:45:16 -0800
Message-ID: <20160311004516.27582.37530.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160311004511.27582.63304.stgit@dwillia2-desk3.jf.intel.com>
References: <20160311004511.27582.63304.stgit@dwillia2-desk3.jf.intel.com>
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

Check that ars_status, rather than ars_cap, commands are supported and
validate that the reference ars_cap passed in is indeed and ars_cap
command.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl-ars.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/libndctl-ars.c b/lib/libndctl-ars.c
index ad85191898d4..63d0e5544a36 100644
--- a/lib/libndctl-ars.c
+++ b/lib/libndctl-ars.c
@@ -55,7 +55,7 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_start(struct ndctl_cmd *ars
 		dbg(ctx, "unsupported cmd\n");
 		return NULL;
 	}
-	if (ars_cap->status != 0) {
+	if (ars_cap->type != ND_CMD_ARS_CAP || ars_cap->status != 0) {
 		dbg(ctx, "expected sucessfully completed ars_cap command\n");
 		return NULL;
 	}
@@ -94,11 +94,11 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_status(struct ndctl_cmd *ar
 	struct ndctl_cmd *cmd;
 	size_t size;
 
-	if (!ndctl_bus_is_cmd_supported(bus, ND_CMD_ARS_CAP)) {
+	if (!ndctl_bus_is_cmd_supported(bus, ND_CMD_ARS_STATUS)) {
 		dbg(ctx, "unsupported cmd\n");
 		return NULL;
 	}
-	if (ars_cap->status != 0) {
+	if (ars_cap->type != ND_CMD_ARS_CAP || ars_cap->status != 0) {
 		dbg(ctx, "expected sucessfully completed ars_cap command\n");
 		return NULL;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
