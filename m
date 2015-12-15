Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 9/9] libnvdimm, pfn: move 'memory mode' indication to sysfs
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Dec 2015 18:15:16 -0800
Message-ID: <20151215021516.37090.8022.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
References: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

'Memory mode' is defined as the capability of a DAX mapping to be the
source/target of DMA and other "direct I/O" scenarios.  While it
currently requires allocating 'struct page' for each page frame of
persistent memory in the namespace it will not always be the case.  Work
continues on reducing the kernel's dependency on 'struct page'.

Let's not maintain a suffix that is expected to lose meaning over time.
In other words a future 'raw mode' pmem namespace may be as capable as
today's 'memory mode' namespace.  Undo the encoding of the mode in the
device name and leave it to other tooling to determine the mode of the
namespace from its attributes.

Reported-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   41 +++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index ea8dd0cb28ca..ee6dee41155a 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -104,20 +104,10 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
 	const char *suffix = NULL;
 
-	if (ndns->claim) {
-		if (is_nd_btt(ndns->claim))
-			suffix = "s";
-		else if (is_nd_pfn(ndns->claim))
-			suffix = "m";
-		else
-			dev_WARN_ONCE(&ndns->dev, 1,
-					"unknown claim type by %s\n",
-					dev_name(ndns->claim));
-	}
+	if (ndns->claim && is_nd_btt(ndns->claim))
+		suffix = "s";
 
 	if (is_namespace_pmem(&ndns->dev) || is_namespace_io(&ndns->dev)) {
-		if (!suffix && pmem_should_map_pages(&ndns->dev))
-			suffix = "m";
 		sprintf(name, "pmem%d%s", nd_region->id, suffix ? suffix : "");
 	} else if (is_namespace_blk(&ndns->dev)) {
 		struct nd_namespace_blk *nsblk;
@@ -1224,6 +1214,29 @@ static ssize_t holder_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(holder);
 
+static ssize_t mode_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_namespace_common *ndns = to_ndns(dev);
+	struct device *claim;
+	char *mode;
+	ssize_t rc;
+
+	device_lock(dev);
+	claim = ndns->claim;
+	if (pmem_should_map_pages(dev) || (claim && is_nd_pfn(claim)))
+		mode = "memory";
+	else if (claim && is_nd_btt(claim))
+		mode = "safe";
+	else
+		mode = "raw";
+	rc = sprintf(buf, "%s\n", mode);
+	device_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(mode);
+
 static ssize_t force_raw_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -1247,6 +1260,7 @@ static DEVICE_ATTR_RW(force_raw);
 static struct attribute *nd_namespace_attributes[] = {
 	&dev_attr_nstype.attr,
 	&dev_attr_size.attr,
+	&dev_attr_mode.attr,
 	&dev_attr_uuid.attr,
 	&dev_attr_holder.attr,
 	&dev_attr_resource.attr,
@@ -1280,7 +1294,8 @@ static umode_t namespace_visible(struct kobject *kobj,
 
 	if (a == &dev_attr_nstype.attr || a == &dev_attr_size.attr
 			|| a == &dev_attr_holder.attr
-			|| a == &dev_attr_force_raw.attr)
+			|| a == &dev_attr_force_raw.attr
+			|| a == &dev_attr_mode.attr)
 		return a->mode;
 
 	return 0;

