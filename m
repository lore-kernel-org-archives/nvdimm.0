Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CEC15225E9658
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 21:25:57 -0700 (PDT)
Subject: [PATCH] libnvdimm, region: hide persistence_domain when unknown
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 20 Mar 2018 21:23:21 -0700
Message-ID: <152160620119.29833.14356675736401790361.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Similar to other region attributes, do not emit the persistence_domain
attribute if its contents are empty.

Fixes: 96c3a239054a ("libnvdimm: expose platform persistence attr...")
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e6d01911e092..a8e9d428c0a5 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -593,6 +593,13 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 			return 0;
 	}
 
+	if (a == &dev_attr_persistence_domain.attr) {
+		if ((nd_region->flags & (BIT(ND_REGION_PERSIST_CACHE)
+					| BIT(ND_REGION_PERSIST_MEMCTRL))) == 0)
+			return 0;
+		return a->mode;
+	}
+
 	if (a != &dev_attr_set_cookie.attr
 			&& a != &dev_attr_available_size.attr)
 		return a->mode;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
