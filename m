Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 12/17] pmem: flag pmem block devices as non-rotational
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jun 2015 05:37:22 -0400
Message-ID: <20150625093722.40066.10804.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

...since they are effectively SSDs as far as userspace is concerned.

Reviewed-by: Vishal Verma <vishal.l.verma@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 09195e3b7453..a9709db0704c 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -158,6 +158,7 @@ static int pmem_attach_disk(struct nd_namespace_common *ndns,
 	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
 	blk_queue_max_hw_sectors(pmem->pmem_queue, UINT_MAX);
 	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->pmem_queue);
 
 	disk = alloc_disk(0);
 	if (!disk) {

