Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 4/9] libnvdimm, pfn: add parent uuid validation
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Dec 2015 18:14:49 -0800
Message-ID: <20151215021449.37090.17888.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
References: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Track and check the uuid of the namespace hosting a pfn instance.  This
forces the pfn info block to be invalidated if the namespace is
re-configured with a different uuid.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |   10 +++++++---
 drivers/nvdimm/pmem.c     |    1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 95ecd7b0fab3..f9b674bc49db 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -273,10 +273,11 @@ struct device *nd_pfn_create(struct nd_region *nd_region)
 
 int nd_pfn_validate(struct nd_pfn *nd_pfn)
 {
-	struct nd_namespace_common *ndns = nd_pfn->ndns;
-	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
-	struct nd_namespace_io *nsio;
 	u64 checksum, offset;
+	struct nd_namespace_io *nsio;
+	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
+	struct nd_namespace_common *ndns = nd_pfn->ndns;
+	const u8 *parent_uuid = nd_dev_to_uuid(&ndns->dev);
 
 	if (!pfn_sb || !ndns)
 		return -ENODEV;
@@ -296,6 +297,9 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 		return -ENODEV;
 	pfn_sb->checksum = cpu_to_le64(checksum);
 
+	if (memcmp(pfn_sb->parent_uuid, parent_uuid, 16) != 0)
+		return -ENODEV;
+
 	switch (le32_to_cpu(pfn_sb->mode)) {
 	case PFN_MODE_RAM:
 		break;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 5ba351e4f26a..dc6866734f70 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -270,6 +270,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	pfn_sb->npfns = cpu_to_le64(npfns);
 	memcpy(pfn_sb->signature, PFN_SIG, PFN_SIG_LEN);
 	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
+	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major = cpu_to_le16(1);
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);

