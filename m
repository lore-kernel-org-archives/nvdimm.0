Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F6E220336ADB
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 23:19:57 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 3/3] fs/ext2/inode: Optimize the condition for iomap_begin
Date: Sun,  1 Jul 2018 14:18:48 +0800
Message-Id: <20180701061848.7036-3-yehs2007@zoho.com>
In-Reply-To: <20180701061848.7036-1-yehs2007@zoho.com>
References: <20180701061848.7036-1-yehs2007@zoho.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, chengnt@lenovo.com, jack@suse.com, linux-kernel@vger.kernel.org, willy@infradead.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

If ext2_get_blocks returns negative result, ext2_iomap_begin
will return for error case.
Adjust the judging condition of ret value will be useful for
code simplification.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 fs/ext2/inode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index ca211bd..9b1004d 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -819,15 +819,15 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	iomap->offset = (loff_t)first_block << blkbits;
 	iomap->dax_dev = sbi->s_daxdev;
 
-	if (ret == 0) {
-		iomap->type = IOMAP_HOLE;
-		iomap->addr = IOMAP_NULL_ADDR;
-		iomap->length = 1 << blkbits;
-	} else {
+	if (ret) {
 		iomap->type = IOMAP_MAPPED;
 		iomap->addr = (u64)bno << blkbits;
 		iomap->length = (u64)ret << blkbits;
 		iomap->flags |= IOMAP_F_MERGED;
+	} else {
+		iomap->type = IOMAP_HOLE;
+		iomap->addr = IOMAP_NULL_ADDR;
+		iomap->length = 1 << blkbits;
 	}
 
 	if (new)
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
