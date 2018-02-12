Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27E0E222DE132
 for <linux-nvdimm@lists.01.org>; Mon, 12 Feb 2018 15:00:26 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] loop: Fix lost writes caused by missing flag
Date: Mon, 12 Feb 2018 16:05:58 -0700
Message-Id: <20180212230558.5546-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following commit:

commit aa4d86163e4e ("block: loop: switch to VFS ITER_BVEC")

replaced __do_lo_send_write(), which used ITER_KVEC iterators, with
lo_write_bvec() which uses ITER_BVEC iterators.  In this change, though,
the WRITE flag was lost:

-       iov_iter_kvec(&from, ITER_KVEC | WRITE, &kvec, 1, len);
+       iov_iter_bvec(&i, ITER_BVEC, bvec, 1, bvec->bv_len);

This flag is necessary for the DAX case because we make decisions based on
whether or not the iterator is a READ or a WRITE in dax_iomap_actor() and
in dax_iomap_rw().

We end up going through this path in configurations where we combine a PMEM
device with 4k sectors, a loopback device and DAX.  The consequence of this
missed flag is that what we intend as a write actually turns into a read in
the DAX code, so no data is ever written.

The very simplest test case is to create a loopback device and try and
write a small string to it, then hexdump a few bytes of the device to see
if the write took.  Without this patch you read back all zeros, with this
you read back the string you wrote.

For XFS this causes us to fail or panic during the following xfstests:

	xfs/074 xfs/078 xfs/216 xfs/217 xfs/250

For ext4 we have a similar issue where writes never happen, but we don't
currently have any xfstests that use loopback and show this issue.

Fix this by restoring the WRITE flag argument to iov_iter_bvec().  This
causes the xfstests to all pass.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: commit aa4d86163e4e ("block: loop: switch to VFS ITER_BVEC")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
---
 drivers/block/loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d5fe720cf149..89d2ee00cced 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -266,7 +266,7 @@ static int lo_write_bvec(struct file *file, struct bio_vec *bvec, loff_t *ppos)
 	struct iov_iter i;
 	ssize_t bw;
 
-	iov_iter_bvec(&i, ITER_BVEC, bvec, 1, bvec->bv_len);
+	iov_iter_bvec(&i, ITER_BVEC | WRITE, bvec, 1, bvec->bv_len);
 
 	file_start_write(file);
 	bw = vfs_iter_write(file, &i, ppos, 0);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
