Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D794880352
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 13:06:43 -0800 (PST)
Subject: [PATCH v2 2/5] libnvdimm: Add resource sysfs attrib to nd region
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 07 Mar 2017 14:06:43 -0700
Message-ID: <148892080294.46486.10193714287914679165.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148892068983.46486.5008198419806159468.stgit@djiang5-desk3.ch.intel.com>
References: <148892068983.46486.5008198419806159468.stgit@djiang5-desk3.ch.intel.com>
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
ND region. This is for supporting of user app poison clear via
device dax.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
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
