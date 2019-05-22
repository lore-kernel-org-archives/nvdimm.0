Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [RFC PATCH V2 1/3] mm/nvdimm: Add PFN_MIN_VERSION support
Date: Wed, 22 May 2019 13:56:59 +0530
Message-Id: <20190522082701.6817-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

This allows us to make changes in a backward incompatible way. I have
kept the PFN_MIN_VERSION in this patch '0' because we are not introducing
any incompatible changes in this patch. We also may want to backport this
to older kernels.

The error looks like

  dax0.1: init failed, superblock min version 1, kernel support version 0

and the namespace is marked disabled

$ndctl list -Ni
[
  {
    "dev":"namespace0.0",
    "mode":"fsdax",
    "map":"mem",
    "size":10737418240,
    "uuid":"9605de6d-cefa-4a87-99cd-dec28b02cffe",
    "state":"disabled"
  }
]

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/pfn.h      |  9 ++++++++-
 drivers/nvdimm/pfn_devs.c |  8 ++++++++
 drivers/nvdimm/pmem.c     | 26 ++++++++++++++++++++++----
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
index dde9853453d3..5fd29242745a 100644
--- a/drivers/nvdimm/pfn.h
+++ b/drivers/nvdimm/pfn.h
@@ -20,6 +20,12 @@
 #define PFN_SIG_LEN 16
 #define PFN_SIG "NVDIMM_PFN_INFO\0"
 #define DAX_SIG "NVDIMM_DAX_INFO\0"
+/*
+ * increment this when we are making changes such that older
+ * kernel should fail to initialize that namespace.
+ */
+
+#define PFN_MIN_VERSION 0
 
 struct nd_pfn_sb {
 	u8 signature[PFN_SIG_LEN];
@@ -36,7 +42,8 @@ struct nd_pfn_sb {
 	__le32 end_trunc;
 	/* minor-version-2 record the base alignment of the mapping */
 	__le32 align;
-	u8 padding[4000];
+	__le16 min_version;
+	u8 padding[3998];
 	__le64 checksum;
 };
 
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 01f40672507f..a2268cf262f5 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -439,6 +439,13 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb), 0))
 		return -ENXIO;
 
+	if (le16_to_cpu(pfn_sb->min_version) > PFN_MIN_VERSION) {
+		dev_err(&nd_pfn->dev,
+			"init failed, superblock min version %ld kernel support version %ld\n",
+			le16_to_cpu(pfn_sb->min_version), PFN_MIN_VERSION);
+		return -EOPNOTSUPP;
+	}
+
 	if (memcmp(pfn_sb->signature, sig, PFN_SIG_LEN) != 0)
 		return -ENODEV;
 
@@ -769,6 +776,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major = cpu_to_le16(1);
 	pfn_sb->version_minor = cpu_to_le16(2);
+	pfn_sb->min_version = cpu_to_le16(PFN_MIN_VERSION);
 	pfn_sb->start_pad = cpu_to_le32(start_pad);
 	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
 	pfn_sb->align = cpu_to_le32(nd_pfn->align);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 845c5b430cdd..406427c064d9 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -490,6 +490,7 @@ static int pmem_attach_disk(struct device *dev,
 
 static int nd_pmem_probe(struct device *dev)
 {
+	int ret;
 	struct nd_namespace_common *ndns;
 
 	ndns = nvdimm_namespace_common_probe(dev);
@@ -505,12 +506,29 @@ static int nd_pmem_probe(struct device *dev)
 	if (is_nd_pfn(dev))
 		return pmem_attach_disk(dev, ndns);
 
-	/* if we find a valid info-block we'll come back as that personality */
-	if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0
-			|| nd_dax_probe(dev, ndns) == 0)
+	ret = nd_btt_probe(dev, ndns);
+	if (ret == 0)
 		return -ENXIO;
+	else if (ret == -EOPNOTSUPP)
+		return ret;
 
-	/* ...otherwise we're just a raw pmem device */
+	ret = nd_pfn_probe(dev, ndns);
+	if (ret == 0)
+		return -ENXIO;
+	else if (ret == -EOPNOTSUPP)
+		return ret;
+
+	ret = nd_dax_probe(dev, ndns);
+	if (ret == 0)
+		return -ENXIO;
+	else if (ret == -EOPNOTSUPP)
+		return ret;
+	/*
+	 * We have two failure conditions here, there is no
+	 * info reserver block or we found a valid info reserve block
+	 * but failed to initialize the pfn superblock.
+	 * Don't create a raw pmem disk for the second case.
+	 */
 	return pmem_attach_disk(dev, ndns);
 }
 
-- 
2.21.0
