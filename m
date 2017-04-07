Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7915F21A0480F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 15:33:26 -0700 (PDT)
Subject: [PATCH v6 2/4] libnvdimm: Add 'resource' sysfs attribute to regions
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 07 Apr 2017 15:33:25 -0700
Message-ID: <149160440581.52935.15449870620368830816.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149160440045.52935.12075328472007815165.stgit@djiang5-desk3.ch.intel.com>
References: <149160440045.52935.12075328472007815165.stgit@djiang5-desk3.ch.intel.com>
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

Adding sysfs attribute in order to export the physical address of the
region. This is for supporting of user app poison clear via
ND_IOCTL_CLEAR_ERROR.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 3500fc8..8de5a04 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -463,6 +463,15 @@ static struct device_attribute dev_attr_nd_badblocks = {
 	.show = nd_badblocks_show,
 };
 
+static ssize_t resource_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	return sprintf(buf, "%#llx\n", nd_region->ndr_start);
+}
+static DEVICE_ATTR_RO(resource);
+
 static struct attribute *nd_region_attributes[] = {
 	&dev_attr_size.attr,
 	&dev_attr_nstype.attr,
@@ -476,6 +485,7 @@ static struct attribute *nd_region_attributes[] = {
 	&dev_attr_namespace_seed.attr,
 	&dev_attr_init_namespaces.attr,
 	&dev_attr_nd_badblocks.attr,
+	&dev_attr_resource.attr,
 	NULL,
 };
 
@@ -495,6 +505,9 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (!is_nd_pmem(dev) && a == &dev_attr_nd_badblocks.attr)
 		return 0;
 
+	if (!is_nd_pmem(dev) && a == &dev_attr_resource.attr)
+		return 0;
+
 	if (a != &dev_attr_set_cookie.attr
 			&& a != &dev_attr_available_size.attr)
 		return a->mode;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
