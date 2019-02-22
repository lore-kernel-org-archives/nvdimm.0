Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55744211CD610
 for <linux-nvdimm@lists.01.org>; Fri, 22 Feb 2019 10:20:14 -0800 (PST)
Date: Fri, 22 Feb 2019 10:20:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] pmem: advertise page alignment for pmem devices
 supporting fsdax
Message-ID: <20190222182008.GT6503@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
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
To: dan.j.williams@intel.com
Cc: xfs <linux-xfs@vger.kernel.org>, zwisler@kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi all!

Uh, we have an internal customer <cough> who's been trying out MAP_SYNC
on pmem, and they've observed that one has to do a fair amount of
legwork (in the form of mkfs.xfs parameters) to get the kernel to set up
2M PMD mappings.  They (of course) want to mmap hundreds of GB of pmem,
so the PMD mappings are much more efficient.

I started poking around w.r.t. what mkfs.xfs was doing and realized that
if the fsdax pmem device advertised iomin/ioopt of 2MB, then mkfs will
set up all the parameters automatically.  Below is my ham-handed attempt
to teach the kernel to do this.

Comments, flames, "WTF is this guy smoking?" are all welcome. :)

--D

---
Configure pmem devices to advertise the default page alignment when said
block device supports fsdax.  Certain filesystems use these iomin/ioopt
hints to try to create aligned file extents, which makes it much easier
for mmaps to take advantage of huge page table entries.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/nvdimm/pmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index bc2f700feef8..3eeb9dd117d5 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -441,8 +441,11 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_logical_block_size(q, pmem_sector_size(ndns));
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-	if (pmem->pfn_flags & PFN_MAP)
+	if (pmem->pfn_flags & PFN_MAP) {
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
+		blk_queue_io_min(q, PFN_DEFAULT_ALIGNMENT);
+		blk_queue_io_opt(q, PFN_DEFAULT_ALIGNMENT);
+	}
 	q->queuedata = pmem;
 
 	disk = alloc_disk_node(0, nid);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
