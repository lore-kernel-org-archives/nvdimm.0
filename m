Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B2183212377E4
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 22:55:25 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4G5koNs091262
 for <linux-nvdimm@lists.01.org>; Thu, 16 May 2019 01:55:24 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2sh0db3k94-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 16 May 2019 01:55:23 -0400
Received: from localhost
 by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <vaibhav@linux.ibm.com>;
 Thu, 16 May 2019 06:55:21 +0100
From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: [PATCH] dax: Fix last_page check in  __bdev_dax_supported()
Date: Thu, 16 May 2019 11:24:22 +0530
MIME-Version: 1.0
Message-Id: <20190516055422.16939-1-vaibhav@linux.ibm.com>
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
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-kernel@vger.kernel.org, Chandan Rajendra <chandan@linux.ibm.com>, Vaibhav Jain <vaibhav@linux.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Presently __bdev_dax_supported() checks if first sector of last
page ( last_page ) on the block device is aligned to page
boundary. However the code to compute 'last_page' assumes that there
are 8 sectors/page assuming a 4K page-size.

This assumption breaks on architectures which use a different page
size specifically PPC64 where page-size == 64K. Hence a warning is
seen while trying to mount a xfs/ext4 file-system with dax enabled:

$ sudo mount -o dax /dev/pmem0 /mnt/pmem
XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
XFS (pmem0): DAX unsupported by block device. Turning off DAX.

The patch fixes this issue by updating calculation of 'last_var' to
take into account number-of-sectors/page instead of assuming it to be
'8'.

Fixes: ad428cdb525a ("dax: Check the end of the block-device capacity with dax_direct_access()")
Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 drivers/dax/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index bbd57ca0634a..6b50ed3673d3 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -116,7 +116,9 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 		return false;
 	}
 
-	last_page = PFN_DOWN(i_size_read(bdev->bd_inode) - 1) * 8;
+	/* Calculate the first sector of last page on the block device */
+	last_page = PFN_DOWN(i_size_read(bdev->bd_inode) - 1) *
+		(PAGE_SIZE >> SECTOR_SHIFT);
 	err = bdev_dax_pgoff(bdev, last_page, PAGE_SIZE, &pgoff_end);
 	if (err) {
 		pr_debug("%s: error: unaligned partition for dax\n",
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
