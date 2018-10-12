Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D5242116DF85
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 11:24:15 -0700 (PDT)
Subject: [PATCH 5/5] libnvdimm: address state where dimm is unlocked in preOS
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 11:24:14 -0700
Message-ID: <153936865468.55836.4349279559484495728.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153936863308.55836.2972520178944977338.stgit@djiang5-desk3.ch.intel.com>
References: <153936863308.55836.2972520178944977338.stgit@djiang5-desk3.ch.intel.com>
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

When the nvdimm security state is unlocked during unlock, we skip the
operation. In this state, we are not able to fetch a key for verification
and at the same time the dimm is unlocked. This prevents us from doing
any security operations. We will send the freeze security DSM to make the
state consistent.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/security.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 7b5d7c77514d..6c5423228b31 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -250,8 +250,19 @@ int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
 	if (!nvdimm->security_ops)
 		return 0;
 
-	if (nvdimm->state == NVDIMM_SECURITY_UNLOCKED ||
-			nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED ||
+	/*
+	 * If the pre-OS has unlocked the DIMM, we will not be able to
+	 * verify the key against the hardware. Therefore we will not
+	 * retrieve the key and will freeze the security config. This will
+	 * prevent any other security operations.
+	 */
+	if (nvdimm->state == NVDIMM_SECURITY_UNLOCKED) {
+		rc = nvdimm_security_freeze_lock(nvdimm);
+		if (rc < 0)
+			return rc;
+	}
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED ||
 			nvdimm->state == NVDIMM_SECURITY_DISABLED)
 		return 0;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
