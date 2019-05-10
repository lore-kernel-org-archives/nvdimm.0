Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tartarus.angband.pl (tartarus.angband.pl
 [IPv6:2001:41d0:602:dbe::8])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0DF342122CA87
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 08:33:27 -0700 (PDT)
From: Adam Borowski <kilobyte@angband.pl>
Date: Fri, 10 May 2019 17:32:22 +0200
Message-Id: <20190510153222.24665-1-kilobyte@angband.pl>
In-Reply-To: <20190429172649.8288-13-rgoldwyn@suse.de>
References: <20190429172649.8288-13-rgoldwyn@suse.de>
MIME-Version: 1.0
Subject: [PATCH for-goldwyn] btrfs: disallow MAP_SYNC outside of DAX mounts
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
To: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de, darrick.wong@oracle.com, dsterba@suse.cz, nborisov@suse.com, linux-nvdimm@lists.01.org
Cc: Adam Borowski <kilobyte@angband.pl>
List-ID: <linux-nvdimm@lists.01.org>

Even if allocation is done synchronously, data would be lost except on
actual pmem.  Explicit msync()s don't need MAP_SYNC, and don't require
a sync per page.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
MAP_SYNC can't be allowed unconditionally, as cacheline flushes don't help
guarantee persistency in page cache.  This fixes an error in my earlier
patch "btrfs: allow MAP_SYNC mmap" -- you'd probably want to amend that.


 fs/btrfs/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 362a9cf9dcb2..0bc5428037ba 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2233,6 +2233,13 @@ static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 	if (!IS_DAX(inode) && !mapping->a_ops->readpage)
 		return -ENOEXEC;
 
+	/*
+	 * Normal operation of btrfs is pretty much an antithesis of MAP_SYNC;
+	 * supporting it outside DAX is pointless.
+	 */
+	if (!IS_DAX(inode) && (vma->vm_flags & VM_SYNC))
+		return -EOPNOTSUPP;
+
 	file_accessed(filp);
 	if (IS_DAX(inode))
 		vma->vm_ops = &btrfs_dax_vm_ops;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
