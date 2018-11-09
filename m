Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED8C421184E66
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 14:14:02 -0800 (PST)
Subject: [PATCH 03/11] libnvdimm/security: add override module param for key
 self verification
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Nov 2018 15:14:02 -0700
Message-ID: <154180164225.70506.5284765160410580627.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, zohar@linux.vnet.ibm.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Provide the user an override via kernel module parameter for security key
self verification. no_key_self_verify parameter is being added to bypass
security key verify against the hardware during nvdimm unlock path.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/security.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index ee741199d623..d2831e61f3d8 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2018 Intel Corporation. All rights reserved. */
 
+#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/ndctl.h>
 #include <linux/slab.h>
@@ -14,6 +15,10 @@
 #include "nd-core.h"
 #include "nd.h"
 
+static bool no_key_self_verify;
+module_param(no_key_self_verify, bool, 0644);
+MODULE_PARM_DESC(no_key_self_verify, "Bypass security key self verify");
+
 /*
  * Retrieve user injected key
  */
@@ -235,6 +240,12 @@ int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
 	 * other security operations.
 	 */
 	if (nvdimm->state == NVDIMM_SECURITY_UNLOCKED) {
+		/* bypass if user override */
+		if (no_key_self_verify) {
+			mutex_unlock(&nvdimm->sec_mutex);
+			return 0;
+		}
+
 		key = nvdimm_self_verify_key(nvdimm);
 		if (!key) {
 			rc = nvdimm_security_freeze_lock(nvdimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
