Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2643F21F322B4
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 16:00:27 -0700 (PDT)
Subject: [PATCH 1/3] libnvdimm,
 region : make 'resource' attribute only readable by root
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Sep 2017 15:57:15 -0700
Message-ID: <150646663509.6588.1400157739735618779.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150646662980.6588.6123788075203842948.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150646662980.6588.6123788075203842948.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For the same reason that /proc/iomem returns 0's for non-root readers
and acpi tables are root-only, make the 'resource' attribute for region
devices only readable by root. Otherwise we disclose physical address
information.

Fixes: 802f4be6feee ("libnvdimm: Add 'resource' sysfs attribute to regions")
Cc: <stable@vger.kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 829d760f651c..abaf38c61220 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -562,8 +562,12 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (!is_nd_pmem(dev) && a == &dev_attr_badblocks.attr)
 		return 0;
 
-	if (!is_nd_pmem(dev) && a == &dev_attr_resource.attr)
-		return 0;
+	if (a == &dev_attr_resource.attr) {
+		if (is_nd_pmem(dev))
+			return 0400;
+		else
+			return 0;
+	}
 
 	if (a == &dev_attr_deep_flush.attr) {
 		int has_flush = nvdimm_has_flush(nd_region);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
