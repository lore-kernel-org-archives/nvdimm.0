Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2418210E0FA5
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 13:19:47 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 2/2] libnvdimm: Export max available extent
Date: Thu,  5 Jul 2018 14:17:26 -0600
Message-Id: <20180705201726.512-2-keith.busch@intel.com>
In-Reply-To: <20180705201726.512-1-keith.busch@intel.com>
References: <20180705201726.512-1-keith.busch@intel.com>
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
To: linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The 'available_size' attribute showing the combined total of all
unallocated space isn't always useful to know how large of a namespace
a user may be able to allocate if the region is fragmented. This patch
will export the largest extent of contiguous unallocated space that may
be allocated to create a new namespace.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/nvdimm/region_devs.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 8af483d7ef57..82aaf7d6488d 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -433,6 +433,21 @@ static ssize_t available_size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_size);
 
+static ssize_t max_available_extent_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	unsigned long long available = 0;
+
+	nvdimm_bus_lock(dev);
+	wait_nvdimm_bus_probe_idle(dev);
+	available = nd_region_contiguous_max(nd_region);
+	nvdimm_bus_unlock(dev);
+
+	return sprintf(buf, "%llu\n", available);
+}
+static DEVICE_ATTR_RO(max_available_extent);
+
 static ssize_t init_namespaces_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -584,6 +599,7 @@ static struct attribute *nd_region_attributes[] = {
 	&dev_attr_read_only.attr,
 	&dev_attr_set_cookie.attr,
 	&dev_attr_available_size.attr,
+	&dev_attr_max_available_extent.attr,
 	&dev_attr_namespace_seed.attr,
 	&dev_attr_init_namespaces.attr,
 	&dev_attr_badblocks.attr,
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
