Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 30756202E5318
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:37:40 -0800 (PST)
Subject: [PATCH 4/7] libnvdimm/pfn: Introduce super-block minimum version
 requirements
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:25:01 -0800
Message-ID: <155000670159.348031.17631616775326330606.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In support of fixing a pfn info-block interpretation problem that
requires a backwards incompatible format change introduce a mechanism to
indicate a minimum support level to the parsing agent. Hopefully this
mechanism never needs to be used, but it otherwise prevents the need to
hunt for a state that causes old implementations to bail out.

For now, the method chosen to make implementations prior to this
introduction fail is to use new PFN3_MODE_* values. The use of 'mode'
ensures that older Linux fails, but agents like the EFI driver that only
care about 'data_offset' can continue to ignore the requirement. That is
to say 'data_offset' should always be valid, but the interpretation of
values that older Linux kernels use to setup the dev_pagemap and perform
sector-to-pfn translations is going to change.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn.h      |    4 +++-
 drivers/nvdimm/pfn_devs.c |    7 +++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
index dde9853453d3..710cb743fad6 100644
--- a/drivers/nvdimm/pfn.h
+++ b/drivers/nvdimm/pfn.h
@@ -20,6 +20,7 @@
 #define PFN_SIG_LEN 16
 #define PFN_SIG "NVDIMM_PFN_INFO\0"
 #define DAX_SIG "NVDIMM_DAX_INFO\0"
+#define PFN_VERSION_SUPPORT 2
 
 struct nd_pfn_sb {
 	u8 signature[PFN_SIG_LEN];
@@ -36,7 +37,8 @@ struct nd_pfn_sb {
 	__le32 end_trunc;
 	/* minor-version-2 record the base alignment of the mapping */
 	__le32 align;
-	u8 padding[4000];
+	__le16 min_version;
+	u8 padding[3998];
 	__le64 checksum;
 };
 
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index ba74a341da5d..108f9f7ed064 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -459,6 +459,12 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	if (__le16_to_cpu(pfn_sb->version_minor) < 2)
 		pfn_sb->align = 0;
 
+	if (__le16_to_cpu(pfn_sb->version_major) != 1)
+		return -EINVAL;
+
+	if (__le16_to_cpu(pfn_sb->min_version) > PFN_VERSION_SUPPORT)
+		return -EINVAL;
+
 	switch (le32_to_cpu(pfn_sb->mode)) {
 	case PFN_MODE_RAM:
 	case PFN_MODE_PMEM:
@@ -771,6 +777,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
 	pfn_sb->version_major = cpu_to_le16(1);
 	pfn_sb->version_minor = cpu_to_le16(2);
+	pfn_sb->min_version = cpu_to_le16(2);
 	pfn_sb->start_pad = cpu_to_le32(start_pad);
 	pfn_sb->end_trunc = cpu_to_le32(end_trunc);
 	pfn_sb->align = cpu_to_le32(nd_pfn->align);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
