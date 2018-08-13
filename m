Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E13AB210DBE6E
 for <linux-nvdimm@lists.01.org>; Sun, 12 Aug 2018 20:24:09 -0700 (PDT)
From: Zhang Yi <yi.z.zhang@linux.intel.com>
Subject: [PATCH V2 1/1] device-dax: check for vma range while dax_mmap.
Date: Mon, 13 Aug 2018 20:02:56 +0800
Message-Id: <46441800c43f029757c70d8386e3112701081503.1534160958.git.yi.z.zhang@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, jack@suse.cz, zwisler@kernel.org, dave.jiang@intel.com, yu.c.zhang@intel.com
Cc: yi.z.zhang@intel.com
List-ID: <linux-nvdimm@lists.01.org>

This patch prevents a user mapping an illegal vma range that is larger
than a dax device physical resource.

When qemu maps the dax device for virtual nvdimm's backend device, the
v-nvdimm label area is defined at the end of mapped range. By using an
illegal size that exceeds the range of the device dax, it will trigger a
fault with qemu.

Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
---
 drivers/dax/device.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 108c37f..6fe8c30 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -177,6 +177,33 @@ static const struct attribute_group *dax_attribute_groups[] = {
 	NULL,
 };
 
+static int check_vma_range(struct dev_dax *dev_dax, struct vm_area_struct *vma,
+		const char *func)
+{
+	struct device *dev = &dev_dax->dev;
+	struct resource *res;
+	unsigned long size;
+	int ret, i;
+
+	if (!dax_alive(dev_dax->dax_dev))
+		return -ENXIO;
+
+	size = vma->vm_end - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);
+	ret = -EINVAL;
+	for (i = 0; i < dev_dax->num_resources; i++) {
+		res = &dev_dax->res[i];
+		if (size > resource_size(res)) {
+			dev_info_ratelimited(dev,
+				"%s: %s: fail, vma range overflow\n",
+				current->comm, func);
+			ret = -EINVAL;
+			continue;
+		} else
+			return 0;
+	}
+	return ret;
+}
+
 static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 		const char *func)
 {
@@ -469,6 +496,8 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 	 */
 	id = dax_read_lock();
 	rc = check_vma(dev_dax, vma, __func__);
+	if (!rc)
+		rc = check_vma_range(dev_dax, vma, __func__);
 	dax_read_unlock(id);
 	if (rc)
 		return rc;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
