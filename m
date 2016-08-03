Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id B3DF61A1E00
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 15:58:25 -0700 (PDT)
Subject: [4.6 stable PATCH 1/2] libnvdimm,
 dax: record the specified alignment of a dax-device instance
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 03 Aug 2016 15:55:31 -0700
Message-ID: <147026493144.9715.5809217045641715960.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147026492600.9715.5445676747822316537.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147026492600.9715.5445676747822316537.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: stable@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

commit 45a0dac0451136fa7ae34a6fea53ef6a136287ce upstream.

We want to use the alignment as the allocation and mapping unit.
Previously this information was only useful for establishing the data
offset, but now it is important to remember the granularity for the
later use.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn.h      |    4 +++-
 drivers/nvdimm/pfn_devs.c |    5 ++++-
 drivers/nvdimm/pmem.c     |    3 ++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
index 8e343a3ca873..9d2704c83fa7 100644
--- a/drivers/nvdimm/pfn.h
+++ b/drivers/nvdimm/pfn.h
@@ -33,7 +33,9 @@ struct nd_pfn_sb {
 	/* minor-version-1 additions for section alignment */
 	__le32 start_pad;
 	__le32 end_trunc;
-	u8 padding[4004];
+	/* minor-version-2 record the base alignment of the mapping */
+	__le32 align;
+	u8 padding[4000];
 	__le64 checksum;
 };
 
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index e071e214feba..58bf68c9c414 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -360,6 +360,9 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 		pfn_sb->end_trunc = 0;
 	}
 
+	if (__le16_to_cpu(pfn_sb->version_minor) < 2)
+		pfn_sb->align = 0;
+
 	switch (le32_to_cpu(pfn_sb->mode)) {
 	case PFN_MODE_RAM:
 	case PFN_MODE_PMEM:
@@ -399,7 +402,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 		return -EBUSY;
 	}
 
-	nd_pfn->align = 1UL << ilog2(offset);
+	nd_pfn->align = le32_to_cpu(pfn_sb->align);
 	if (!is_power_of_2(offset) || offset < PAGE_SIZE) {
 		dev_err(&nd_pfn->dev, "bad offset: %#llx dax disabled\n",
 				offset);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 92f536596b24..58ad81dcd1a5 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -426,9 +426,10 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
 	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major = cpu_to_le16(1);
-	pfn_sb->version_minor = cpu_to_le16(1);
+	pfn_sb->version_minor = cpu_to_le16(2);
 	pfn_sb->start_pad = cpu_to_le32(start_pad);
 	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
+	pfn_sb->align = cpu_to_le32(nd_pfn->align);
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
