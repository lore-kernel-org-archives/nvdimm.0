Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 5A4381A1E1A
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 16:44:54 -0700 (PDT)
Subject: [PATCH 1/2] libnvdimm, dax: autodetect support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 May 2016 16:44:02 -0700
Message-ID: <146361504214.37798.10838875364637518905.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146361503689.37798.44566892348278285.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146361503689.37798.44566892348278285.stgit@dwillia2-desk3.amr.corp.intel.com>
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

For autodetecting a previously established dax configuration we need the
info block to indicate block-device vs device-dax mode, and we need to
have the default namespace probe hand-off the configuration to the
dax_pmem driver.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dax_devs.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd.h       |   11 +++++++++--
 drivers/nvdimm/pfn.h      |    1 +
 drivers/nvdimm/pfn_devs.c |   15 ++++++++++-----
 drivers/nvdimm/pmem.c     |    3 ++-
 5 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index f90f7549e7f4..45fa82cae87c 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include "nd-core.h"
+#include "pfn.h"
 #include "nd.h"
 
 static void nd_dax_release(struct device *dev)
@@ -97,3 +98,37 @@ struct device *nd_dax_create(struct nd_region *nd_region)
 	__nd_device_register(dev);
 	return dev;
 }
+
+int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
+{
+	int rc;
+	struct nd_dax *nd_dax;
+	struct device *dax_dev;
+	struct nd_pfn *nd_pfn;
+	struct nd_pfn_sb *pfn_sb;
+	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
+
+	if (ndns->force_raw)
+		return -ENODEV;
+
+	nvdimm_bus_lock(&ndns->dev);
+	nd_dax = nd_dax_alloc(nd_region);
+	nd_pfn = &nd_dax->nd_pfn;
+	dax_dev = nd_pfn_devinit(nd_pfn, ndns);
+	nvdimm_bus_unlock(&ndns->dev);
+	if (!dax_dev)
+		return -ENOMEM;
+	pfn_sb = devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	nd_pfn->pfn_sb = pfn_sb;
+	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
+	dev_dbg(dev, "%s: dax: %s\n", __func__,
+			rc == 0 ? dev_name(dax_dev) : "<none>");
+	if (rc < 0) {
+		__nd_detach_ndns(dax_dev, &nd_pfn->ndns);
+		put_device(dax_dev);
+	} else
+		__nd_device_register(dax_dev);
+
+	return rc;
+}
+EXPORT_SYMBOL(nd_dax_probe);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 46910b8f32b1..d0ac93c31dda 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -232,7 +232,7 @@ bool is_nd_pfn(struct device *dev);
 struct device *nd_pfn_create(struct nd_region *nd_region);
 struct device *nd_pfn_devinit(struct nd_pfn *nd_pfn,
 		struct nd_namespace_common *ndns);
-int nd_pfn_validate(struct nd_pfn *nd_pfn);
+int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig);
 extern struct attribute_group nd_pfn_attribute_group;
 #else
 static inline int nd_pfn_probe(struct device *dev,
@@ -251,7 +251,7 @@ static inline struct device *nd_pfn_create(struct nd_region *nd_region)
 	return NULL;
 }
 
-static inline int nd_pfn_validate(struct nd_pfn *nd_pfn)
+static inline int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
 	return -ENODEV;
 }
@@ -259,9 +259,16 @@ static inline int nd_pfn_validate(struct nd_pfn *nd_pfn)
 
 struct nd_dax *to_nd_dax(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_DAX)
+int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_dax(struct device *dev);
 struct device *nd_dax_create(struct nd_region *nd_region);
 #else
+static inline int nd_dax_probe(struct device *dev,
+		struct nd_namespace_common *ndns)
+{
+	return -ENODEV;
+}
+
 static inline bool is_nd_dax(struct device *dev)
 {
 	return false;
diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
index 9d2704c83fa7..dde9853453d3 100644
--- a/drivers/nvdimm/pfn.h
+++ b/drivers/nvdimm/pfn.h
@@ -19,6 +19,7 @@
 
 #define PFN_SIG_LEN 16
 #define PFN_SIG "NVDIMM_PFN_INFO\0"
+#define DAX_SIG "NVDIMM_DAX_INFO\0"
 
 struct nd_pfn_sb {
 	u8 signature[PFN_SIG_LEN];
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 58740d7ce81b..816cd9828ca5 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -360,7 +360,7 @@ struct device *nd_pfn_create(struct nd_region *nd_region)
 	return dev;
 }
 
-int nd_pfn_validate(struct nd_pfn *nd_pfn)
+int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
 	u64 checksum, offset;
 	struct nd_namespace_io *nsio;
@@ -377,7 +377,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 	if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb)))
 		return -ENXIO;
 
-	if (memcmp(pfn_sb->signature, PFN_SIG, PFN_SIG_LEN) != 0)
+	if (memcmp(pfn_sb->signature, sig, PFN_SIG_LEN) != 0)
 		return -ENODEV;
 
 	checksum = le64_to_cpu(pfn_sb->checksum);
@@ -467,7 +467,7 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 	pfn_sb = devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn = to_nd_pfn(pfn_dev);
 	nd_pfn->pfn_sb = pfn_sb;
-	rc = nd_pfn_validate(nd_pfn);
+	rc = nd_pfn_validate(nd_pfn, PFN_SIG);
 	dev_dbg(dev, "%s: pfn: %s\n", __func__,
 			rc == 0 ? dev_name(pfn_dev) : "<none>");
 	if (rc < 0) {
@@ -552,6 +552,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	struct nd_pfn_sb *pfn_sb;
 	unsigned long npfns;
 	phys_addr_t offset;
+	const char *sig;
 	u64 checksum;
 	int rc;
 
@@ -560,7 +561,11 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		return -ENOMEM;
 
 	nd_pfn->pfn_sb = pfn_sb;
-	rc = nd_pfn_validate(nd_pfn);
+	if (is_nd_dax(&nd_pfn->dev))
+		sig = DAX_SIG;
+	else
+		sig = PFN_SIG;
+	rc = nd_pfn_validate(nd_pfn, sig);
 	if (rc != -ENODEV)
 		return rc;
 
@@ -628,7 +633,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	pfn_sb->mode = cpu_to_le32(nd_pfn->mode);
 	pfn_sb->dataoff = cpu_to_le64(offset);
 	pfn_sb->npfns = cpu_to_le64(npfns);
-	memcpy(pfn_sb->signature, PFN_SIG, PFN_SIG_LEN);
+	memcpy(pfn_sb->signature, sig, PFN_SIG_LEN);
 	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
 	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major = cpu_to_le16(1);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index d9a0dbc2d023..042baec56931 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -320,7 +320,8 @@ static int nd_pmem_probe(struct device *dev)
 		return pmem_attach_disk(dev, ndns);
 
 	/* if we find a valid info-block we'll come back as that personality */
-	if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0)
+	if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0
+			|| nd_dax_probe(dev, ndns) == 0)
 		return -ENXIO;
 
 	/* ...otherwise we're just a raw pmem device */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
