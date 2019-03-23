Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com
 [IPv6:2607:f8b0:4864:20::842])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADE04211E95B2
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:26:46 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h39so4910672qte.2
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:26:46 -0700 (PDT)
From: Dexuan Cui <dexuan.cui@gmail.com>
Subject: [ndctl PATCH v3 5/5] libndctl: Implement the "cmd_is_supported"
 dimm-op for Hyper-V
Date: Sat, 23 Mar 2019 04:26:37 +0000
Message-Id: <20190323042637.4544-1-decui@microsoft.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com, dave.jiang@intel.com, linux-nvdimm@lists.01.org, mikelley@microsoft.com
Cc: qi.fuli@fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

Currently "ndctl monitor" fails for Hyper-V virtual NVDIMM due to
"no smart support".

According to http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901"),
Hyper-V doesn't really support ND_CMD_SMART, but it supports
"Get Health Information (Function Index 1)" and
"Get Unsafe Shutdown Count (Function Index 2)", which is basically
a "weak" variant of ND_CMD_SMART.

Implement the dimm-ops to allow "ndctl monitor" to work with Hyper-V
NVDIMM. Now when an error happens, "ndctl monitor" can show such a
line:

{"timestamp":"1550547497.431731497","pid":1571,"event":
{"dimm-health-state":true},"dimm":{"dev":"nmem1",
"id":"04d5-01-1701-01000000","handle":1,"phys_id":0,
"health":{"health_state":"fatal","shutdown_count":8}}}

Here the meaningful info is:
"health":{"health_state":"fatal","shutdown_count":8}

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 ndctl/lib/hyperv.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/ndctl/lib/hyperv.c b/ndctl/lib/hyperv.c
index efd8b03..9b4fe12 100644
--- a/ndctl/lib/hyperv.c
+++ b/ndctl/lib/hyperv.c
@@ -9,6 +9,19 @@
 #include "private.h"
 #include "hyperv.h"
 
+static bool hyperv_cmd_is_supported(struct ndctl_dimm *dimm, int cmd)
+{
+	/*
+	 * "ndctl monitor" requires ND_CMD_SMART, which is not really supported
+	 * by Hyper-V virtual NVDIMM. Nevertheless, ND_CMD_SMART can be emulated
+	 * by ND_HYPERV_CMD_GET_HEALTH_INFO and ND_HYPERV_CMD_GET_SHUTDOWN_INFO.
+	 */
+	if (cmd == ND_CMD_SMART )
+		return true;
+
+	return !!(dimm->cmd_mask & (1ULL << cmd));
+}
+
 static struct ndctl_cmd *alloc_hyperv_cmd(struct ndctl_dimm *dimm,
 		unsigned int command)
 {
@@ -161,6 +174,7 @@ static int hyperv_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
 }
 
 struct ndctl_dimm_ops * const hyperv_dimm_ops = &(struct ndctl_dimm_ops) {
+	.cmd_is_supported = hyperv_cmd_is_supported,
 	.new_smart = hyperv_dimm_cmd_new_smart,
 	.smart_get_flags = hyperv_cmd_get_flags,
 	.smart_get_health = hyperv_cmd_get_health,
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
