Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C92FC22551BBC
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 11:19:32 -0700 (PDT)
Subject: [PATCH] ndctl: fix input/output size for Intel firmware update DSM
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 22 Mar 2018 11:26:04 -0700
Message-ID: <152174316397.12504.9225022827981437244.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The FW_START DSM should have input/out of 0/8, the code incorrectly
is passing in 4/4. This is causing failure with newer BIOS that check
the input/output parameters more strictly.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/lib/intel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 3c4509e4..ba210e1c 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -449,8 +449,8 @@ static struct ndctl_cmd *intel_dimm_cmd_new_fw_start(struct ndctl_dimm *dimm)
 
 	BUILD_ASSERT(sizeof(struct nd_intel_fw_start) == 8);
 
-	cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_START_UPDATE,
-			sizeof(cmd->intel->start) - 4, 4);
+	cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_START_UPDATE, 0,
+			sizeof(cmd->intel->start));
 	if (!cmd)
 		return NULL;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
