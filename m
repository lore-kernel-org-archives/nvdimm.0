Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [RFC PATCH V2 2/3] mm/nvdimm: Add page size and struct page size to pfn superblock
Date: Wed, 22 May 2019 13:57:00 +0530
In-Reply-To: <20190522082701.6817-1-aneesh.kumar@linux.ibm.com>
References: <20190522082701.6817-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20190522082701.6817-2-aneesh.kumar@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

This is needed so that we don't wrongly initialize a namespace
which doesn't have enough space reserved for holding struct pages
with the current kernel.

We also increment PFN_MIN_VERSION to make sure that older kernel
won't initialize namespace created with newer kernel.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/pfn.h      |  7 +++++--
 drivers/nvdimm/pfn_devs.c | 19 ++++++++++++++++++-
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
index 5fd29242745a..ba11738ca8a2 100644
--- a/drivers/nvdimm/pfn.h
+++ b/drivers/nvdimm/pfn.h
@@ -25,7 +25,7 @@
  * kernel should fail to initialize that namespace.
  */
 
-#define PFN_MIN_VERSION 0
+#define PFN_MIN_VERSION 1
 
 struct nd_pfn_sb {
 	u8 signature[PFN_SIG_LEN];
@@ -43,7 +43,10 @@ struct nd_pfn_sb {
 	/* minor-version-2 record the base alignment of the mapping */
 	__le32 align;
 	__le16 min_version;
-	u8 padding[3998];
+	/* minor-version-3 record the page size and struct page size */
+	__le16 page_struct_size;
+	__le32 page_size;
+	u8 padding[3992];
 	__le64 checksum;
 };
 
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index a2268cf262f5..39fa8cf8ef58 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -466,6 +466,15 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	if (__le16_to_cpu(pfn_sb->version_minor) < 2)
 		pfn_sb->align = 0;
 
+	if (__le16_to_cpu(pfn_sb->version_minor) < 3) {
+		/*
+		 * For a large part we use PAGE_SIZE. But we
+		 * do have some accounting code using SZ_4K.
+		 */
+		pfn_sb->page_struct_size = cpu_to_le16(64);
+		pfn_sb->page_size = cpu_to_le32(SZ_4K);
+	}
+
 	switch (le32_to_cpu(pfn_sb->mode)) {
 	case PFN_MODE_RAM:
 	case PFN_MODE_PMEM:
@@ -481,6 +490,12 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		align = 1UL << ilog2(offset);
 	mode = le32_to_cpu(pfn_sb->mode);
 
+	if (le32_to_cpu(pfn_sb->page_size) != PAGE_SIZE)
+		return -EOPNOTSUPP;
+
+	if (le16_to_cpu(pfn_sb->page_struct_size) != sizeof(struct page))
+		return -EOPNOTSUPP;
+
 	if (!nd_pfn->uuid) {
 		/*
 		 * When probing a namepace via nd_pfn_probe() the uuid
@@ -775,11 +790,13 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
 	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major = cpu_to_le16(1);
-	pfn_sb->version_minor = cpu_to_le16(2);
+	pfn_sb->version_minor = cpu_to_le16(3);
 	pfn_sb->min_version = cpu_to_le16(PFN_MIN_VERSION);
 	pfn_sb->start_pad = cpu_to_le32(start_pad);
 	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
 	pfn_sb->align = cpu_to_le32(nd_pfn->align);
+	pfn_sb->page_struct_size = cpu_to_le16(sizeof(struct page));
+	pfn_sb->page_size = cpu_to_le32(PAGE_SIZE);
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);
 
-- 
2.21.0
