Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2A562195406C
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 15:23:17 -0700 (PDT)
Subject: [PATCH v5] libnvdimm, region: sysfs trigger for nvdimm_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Apr 2017 15:17:25 -0700
Message-ID: <149333144522.4906.620839784941994429.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149324959589.17912.8116722315071483296.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149324959589.17912.8116722315071483296.stgit@dwillia2-desk3.amr.corp.intel.com>
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
request. These requests are typically associated with filesystem
metadata updates. However, when a namespace is in device-dax mode,
userspace (think database metadata) needs another path to perform the
same flushing. In other words this is not required to make data
persistent, but in the case of metadata it allows for a smaller failure
domain in the unlikely event of an ADR failure.

The new 'deep_flush' attribute is visible when the individual DIMMs
backing a given interleave-set are described by platform firmware. In
ACPI terms this is "NVDIMM Region Mapping Structures" and associated
"Flush Hint Address Structures". Reads return "1" if the region supports
triggering WPQ flushes on all DIMMs. Reads return "0" the flush
operation is a platform nop, and in that case the attribute is
read-only.

Why sysfs and not an ioctl? An ioctl requires establishing a new
ioctl function number space for device-dax. Given that this would be
called on a device-dax fd an application could be forgiven for
accidentally calling this on a filesystem-dax fd. Placing this interface
in libnvdimm sysfs removes that potential for collision with a
filesystem ioctl, and it keeps ioctls out of the generic device-dax
implementation.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 24abceda986a..53d1ba4e6d99 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -255,6 +255,35 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(size);
 
+static ssize_t deep_flush_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	/*
+	 * NOTE: in the nvdimm_has_flush() error case this attribute is
+	 * not visible.
+	 */
+	return sprintf(buf, "%d\n", nvdimm_has_flush(nd_region));
+}
+
+static ssize_t deep_flush_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t len)
+{
+	bool flush;
+	int rc = strtobool(buf, &flush);
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	if (rc)
+		return rc;
+	if (!flush)
+		return -EINVAL;
+	nvdimm_flush(nd_region);
+
+	return len;
+}
+static DEVICE_ATTR_RW(deep_flush);
+
 static ssize_t mappings_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -479,6 +508,7 @@ static struct attribute *nd_region_attributes[] = {
 	&dev_attr_btt_seed.attr,
 	&dev_attr_pfn_seed.attr,
 	&dev_attr_dax_seed.attr,
+	&dev_attr_deep_flush.attr,
 	&dev_attr_read_only.attr,
 	&dev_attr_set_cookie.attr,
 	&dev_attr_available_size.attr,
@@ -508,6 +538,17 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (!is_nd_pmem(dev) && a == &dev_attr_resource.attr)
 		return 0;
 
+	if (a == &dev_attr_deep_flush.attr) {
+		int has_flush = nvdimm_has_flush(nd_region);
+
+		if (has_flush == 1)
+			return a->mode;
+		else if (has_flush == 0)
+			return 0444;
+		else
+			return 0;
+	}
+
 	if (a != &dev_attr_set_cookie.attr
 			&& a != &dev_attr_available_size.attr)
 		return a->mode;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
