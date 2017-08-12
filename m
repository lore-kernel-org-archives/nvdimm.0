Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 660C62007D094
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 22:16:36 -0700 (PDT)
Subject: [PATCH 3/3] libnvdimm, pfn,
 dax: limit namespace alignments to the supported set
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Aug 2017 22:12:33 -0700
Message-ID: <150251475321.11236.8796257867011123157.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150251473716.11236.9462897790331942583.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150251473716.11236.9462897790331942583.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that we properly advertise the supported pte, pmd, and pud sizes,
restrict the supported alignments that can be set on a namespace. This
assumes that userspace was not previously relying on the ability to set
odd alignments. At least ndctl only ever supported setting the namespace
alignment to 4K, 2M, or 1G.

Cc: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 610dd17a17f6..f447a1eb919d 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -131,26 +131,6 @@ static const unsigned long *nd_pfn_supported_alignments(void)
 	return supported_alignments;
 }
 
-static ssize_t __align_store(struct nd_pfn *nd_pfn, const char *buf)
-{
-	unsigned long val;
-	int rc;
-
-	rc = kstrtoul(buf, 0, &val);
-	if (rc)
-		return rc;
-
-	if (!is_power_of_2(val) || val < PAGE_SIZE || val > SZ_1G)
-		return -EINVAL;
-
-	if (nd_pfn->dev.driver)
-		return -EBUSY;
-	else
-		nd_pfn->align = val;
-
-	return 0;
-}
-
 static ssize_t align_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -159,7 +139,8 @@ static ssize_t align_store(struct device *dev,
 
 	device_lock(dev);
 	nvdimm_bus_lock(dev);
-	rc = __align_store(nd_pfn, buf);
+	rc = nd_size_select_store(dev, buf, &nd_pfn->align,
+			nd_pfn_supported_alignments());
 	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
 			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
 	nvdimm_bus_unlock(dev);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
