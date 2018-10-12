Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 989CD2116DF86
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 11:24:04 -0700 (PDT)
Subject: [PATCH 3/5] libnvdimm: remove driver attached check for secure erase
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 11:24:03 -0700
Message-ID: <153936864380.55836.1354884792663339045.stgit@djiang5-desk3.ch.intel.com>
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

We should be able to do secure erase when dimm is idle but not disabled.
Remove check for driver attachment.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/security.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index cf934c6025d9..f9ca1575012e 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -148,12 +148,6 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 		goto out;
 	}
 
-	if (dev_get_drvdata(dev)) {
-		dev_warn(dev, "Unable to secure erase while DIMM enabled.\n");
-		rc = -EBUSY;
-		goto out;
-	}
-
 	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED) {
 		dev_warn(dev, "Attempt to secure erase in wrong state.\n");
 		rc = -EOPNOTSUPP;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
