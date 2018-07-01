Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C68A20336AD2
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 23:19:54 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 2/3] fs/ext2/inode: Fix a type cast error for fsdax
Date: Sun,  1 Jul 2018 14:18:47 +0800
Message-Id: <20180701061848.7036-2-yehs2007@zoho.com>
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

The type of offset within struct iomap is loff_t, which represents
file offset of mapping.

In ext2_iomap_begin, iomap->offset shall be given a type cast as
loff_t instead of u64.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 fs/ext2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7163590..ca211bd 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -816,7 +816,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	iomap->flags = 0;
 	iomap->bdev = inode->i_sb->s_bdev;
-	iomap->offset = (u64)first_block << blkbits;
+	iomap->offset = (loff_t)first_block << blkbits;
 	iomap->dax_dev = sbi->s_daxdev;
 
 	if (ret == 0) {
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
