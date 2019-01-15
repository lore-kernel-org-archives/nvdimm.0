Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A39A121197374
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 10:26:22 -0800 (PST)
Subject: [PATCH] libnvdimm/security: fix nvdimm_security_state() state
 request selection
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 15 Jan 2019 11:26:21 -0700
Message-ID: <154757678148.35482.4492154450935271566.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The input parameter should be enum nvdimm_passphrase_type instead of bool
for selection of master/user for selection of extended master passphrase
state or the regular user passphrase state.

Fixes: 89fa9d8ea7bdf ("acpi/nfit, libnvdimm/security: add Intel DSM 1.8 master passphrase support")

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/nd-core.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 2b2cf4e554d3..e5ffd5733540 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -54,12 +54,12 @@ struct nvdimm {
 };
 
 static inline enum nvdimm_security_state nvdimm_security_state(
-		struct nvdimm *nvdimm, bool master)
+		struct nvdimm *nvdimm, enum nvdimm_passphrase_type ptype)
 {
 	if (!nvdimm->sec.ops)
 		return -ENXIO;
 
-	return nvdimm->sec.ops->state(nvdimm, master);
+	return nvdimm->sec.ops->state(nvdimm, ptype);
 }
 int nvdimm_security_freeze(struct nvdimm *nvdimm);
 #if IS_ENABLED(CONFIG_NVDIMM_KEYS)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
