Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80AA621A134AC
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:02:27 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/16] xfs: use uuid_copy() helper to abstract uuid_t
Date: Wed, 10 May 2017 20:01:59 +0200
Message-Id: <20170510180214.16852-2-hch@lst.de>
In-Reply-To: <20170510180214.16852-1-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Amir Goldstein <amir73il@gmail.com>

uuid_t definition is about to change.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode_item.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 08cb7d1a4a3a..013cc78d7daf 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -834,9 +834,7 @@ xfs_inode_item_format_convert(
 		in_f->ilf_dsize = in_f32->ilf_dsize;
 		in_f->ilf_ino = in_f32->ilf_ino;
 		/* copy biggest field of ilf_u */
-		memcpy(in_f->ilf_u.ilfu_uuid.__u_bits,
-		       in_f32->ilf_u.ilfu_uuid.__u_bits,
-		       sizeof(uuid_t));
+		uuid_copy(&in_f->ilf_u.ilfu_uuid, &in_f32->ilf_u.ilfu_uuid);
 		in_f->ilf_blkno = in_f32->ilf_blkno;
 		in_f->ilf_len = in_f32->ilf_len;
 		in_f->ilf_boffset = in_f32->ilf_boffset;
@@ -851,9 +849,7 @@ xfs_inode_item_format_convert(
 		in_f->ilf_dsize = in_f64->ilf_dsize;
 		in_f->ilf_ino = in_f64->ilf_ino;
 		/* copy biggest field of ilf_u */
-		memcpy(in_f->ilf_u.ilfu_uuid.__u_bits,
-		       in_f64->ilf_u.ilfu_uuid.__u_bits,
-		       sizeof(uuid_t));
+		uuid_copy(&in_f->ilf_u.ilfu_uuid, &in_f64->ilf_u.ilfu_uuid);
 		in_f->ilf_blkno = in_f64->ilf_blkno;
 		in_f->ilf_len = in_f64->ilf_len;
 		in_f->ilf_boffset = in_f64->ilf_boffset;
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
