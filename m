Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B892920082F11
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 16:54:50 -0700 (PDT)
Subject: [PATCH] libnvdimm, region: sysfs trigger for nvdimm_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Apr 2017 16:48:57 -0700
Message-ID: <149281853758.22910.2919981036906495309.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The nvdimm_flush() mechanism helps to reduce the impact of an ADR
(asynchronous-dimm-refresh) failure. The ADR mechanism handles flushing
platform WPQ (write-pending-queue) buffers when power is removed. The
nvdimm_flush() mechanism performs that same function on-demand.

When a pmem namespace is associated with a block device, an
nvdimm_flush() is triggered with every block-layer REQ_FUA, or REQ_FLUSH
request. However, when a namespace is in device-dax mode, or namespaces
are disabled, userspace needs another path.

The new 'flush' attribute is visible when it can be determined that the
interleave-set either does, or does not have DIMMs that expose WPQ-flush
addresses, "flush-hints" in ACPI NFIT terminology. It returns "1" and
flushes DIMMs, or returns "0" the flush operation is a platform nop.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 8de5a04644a1..3495b4c23941 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -255,6 +255,19 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(size);
 
+static ssize_t flush_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	if (nvdimm_has_flush(nd_region)) {
+		nvdimm_flush(nd_region);
+		return sprintf(buf, "1\n");
+	}
+	return sprintf(buf, "0\n");
+}
+static DEVICE_ATTR_RO(flush);
+
 static ssize_t mappings_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -474,6 +487,7 @@ static DEVICE_ATTR_RO(resource);
 
 static struct attribute *nd_region_attributes[] = {
 	&dev_attr_size.attr,
+	&dev_attr_flush.attr,
 	&dev_attr_nstype.attr,
 	&dev_attr_mappings.attr,
 	&dev_attr_btt_seed.attr,
@@ -508,6 +522,9 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (!is_nd_pmem(dev) && a == &dev_attr_resource.attr)
 		return 0;
 
+	if (a == &dev_attr_flush.attr && nvdimm_has_flush(nd_region) < 0)
+		return 0;
+
 	if (a != &dev_attr_set_cookie.attr
 			&& a != &dev_attr_available_size.attr)
 		return a->mode;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
