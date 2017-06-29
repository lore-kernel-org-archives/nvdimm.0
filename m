Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6ED8A21B02B9D
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 10:58:50 -0700 (PDT)
Subject: [PATCH v4 11/16] libnvdimm, pmem: fix persistence warning
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 10:53:56 -0700
Message-ID: <149875883642.10031.1077982680312378809.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The pmem driver assumes if platform firmware describes the memory
devices associated with a persistent memory range and
CONFIG_ARCH_HAS_PMEM_API=y that it has all the mechanism necessary to
flush data to a power-fail safe zone. We warn if the firmware does not
describe memory devices, but we also need to warn if the architecture
does not claim pmem support.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 3c06a6ea6958..41b4cdf5dea8 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1037,8 +1037,9 @@ int nvdimm_has_flush(struct nd_region *nd_region)
 {
 	int i;
 
-	/* no nvdimm == flushing capability unknown */
-	if (nd_region->ndr_mappings == 0)
+	/* no nvdimm or pmem api == flushing capability unknown */
+	if (nd_region->ndr_mappings == 0
+			|| !IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
 		return -ENXIO;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
