Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 92D60202E535A
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 15:31:08 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
Date: Tue, 26 Jun 2018 16:30:39 -0600
Message-Id: <20180626223041.15653-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180626223041.15653-1-ross.zwisler@linux.intel.com>
References: <20180626223041.15653-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

QUEUE_FLAG_DAX is an indication that a given block device supports
filesystem DAX and should not be set for PMEM namespaces which are in "raw"
mode.  These namespaces lack struct page and are prevented from
participating in filesystem DAX as of commit 569d0365f571 "dax: require
'struct page' by default for filesystem dax".

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvdimm/pmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 68940356cad3..8b1fd7f1a224 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -414,7 +414,8 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_logical_block_size(q, pmem_sector_size(ndns));
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-	blk_queue_flag_set(QUEUE_FLAG_DAX, q);
+	if (pmem->pfn_flags & PFN_MAP)
+		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 	q->queuedata = pmem;
 
 	disk = alloc_disk_node(0, nid);
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
