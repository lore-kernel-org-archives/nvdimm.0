Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5E970
	for <nvdimm@lists.linux.dev>; Mon,  7 Jun 2021 23:31:04 +0000 (UTC)
IronPort-SDR: gal26PsbYsaO2A4mew/qpWHpjj8cTlvgTjD7N467r85QJTZsBiKGrGeGveze5/wkW6NuVgT54K
 muoprrwJ63AQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="265888276"
X-IronPort-AV: E=Sophos;i="5.83,256,1616482800"; 
   d="scan'208";a="265888276"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 16:31:03 -0700
IronPort-SDR: W3dspCDkbCxzCDbE4kaCmB4/JnDzW5+/WmymGvff2AqghGNL1jAlcNvGlBg8Dfu9NFjHGx+iW/
 LSQyds8najVA==
X-IronPort-AV: E=Sophos;i="5.83,256,1616482800"; 
   d="scan'208";a="449288977"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 16:31:03 -0700
Subject: [PATCH] libnvdimm/pmem: Fix blk_cleanup_disk() usage
From: Dan Williams <dan.j.williams@intel.com>
To: axboe@kernel.dk
Cc: Sachin Sant <sachinp@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>,
 Ulf Hansson <ulf.hansson@linaro.org>, nvdimm@lists.linux.dev,
 linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Mon, 07 Jun 2021 16:31:02 -0700
Message-ID: <162310861219.1571453.6561642225122047071.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The queue_to_disk() helper can not be used after del_gendisk()
communicate @disk via the pgmap->owner.

Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Fixes: 87eb73b2ca7c ("nvdimm-pmem: convert to blk_alloc_disk/blk_cleanup_disk")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Jens,

Please take or fold this into your tree after Sachin has a chance
to test it out. It's passing my tests.

 drivers/nvdimm/pmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 31f3c4bd6f72..fc6b78dd2d24 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -337,8 +337,9 @@ static void pmem_pagemap_cleanup(struct dev_pagemap *pgmap)
 {
 	struct request_queue *q =
 		container_of(pgmap->ref, struct request_queue, q_usage_counter);
+	struct pmem_device *pmem = pgmap->owner;
 
-	blk_cleanup_disk(queue_to_disk(q));
+	blk_cleanup_disk(pmem->disk);
 }
 
 static void pmem_release_queue(void *pgmap)
@@ -427,6 +428,7 @@ static int pmem_attach_disk(struct device *dev,
 	q = disk->queue;
 
 	pmem->disk = disk;
+	pmem->pgmap.owner = pmem;
 	pmem->pfn_flags = PFN_DEV;
 	pmem->pgmap.ref = &q->q_usage_counter;
 	if (is_nd_pfn(dev)) {

