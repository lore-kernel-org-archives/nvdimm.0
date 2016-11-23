Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6AB9981EBC
 for <linux-nvdimm@lists.01.org>; Wed, 23 Nov 2016 10:45:06 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/6] dax: fix build breakage with ext4, dax and !iomap
Date: Wed, 23 Nov 2016 11:44:17 -0700
Message-Id: <1479926662-21718-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

With the current Kconfig setup it is possible to have the following:

CONFIG_EXT4_FS=y
CONFIG_FS_DAX=y
CONFIG_FS_IOMAP=n	# this is in fs/Kconfig & isn't user accessible

With this config we get build failures in ext4_dax_fault() because the
iomap functions in fs/dax.c are missing:

fs/built-in.o: In function `ext4_dax_fault':
file.c:(.text+0x7f3ac): undefined reference to `dax_iomap_fault'
file.c:(.text+0x7f404): undefined reference to `dax_iomap_fault'
fs/built-in.o: In function `ext4_file_read_iter':
file.c:(.text+0x7fc54): undefined reference to `dax_iomap_rw'
fs/built-in.o: In function `ext4_file_write_iter':
file.c:(.text+0x7fe9a): undefined reference to `dax_iomap_rw'
file.c:(.text+0x7feed): undefined reference to `dax_iomap_rw'
fs/built-in.o: In function `ext4_block_zero_page_range':
inode.c:(.text+0x85c0d): undefined reference to `iomap_zero_range'

Now that the struct buffer_head based DAX fault paths and I/O path have
been removed we really depend on iomap support being present for DAX.  Make
this explicit by selecting FS_IOMAP if we compile in DAX support.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/Kconfig      | 1 +
 fs/dax.c        | 2 --
 fs/ext2/Kconfig | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 8e9e5f41..18024bf 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -38,6 +38,7 @@ config FS_DAX
 	bool "Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
+	select FS_IOMAP
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
diff --git a/fs/dax.c b/fs/dax.c
index be39633..d8fe3eb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -968,7 +968,6 @@ int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
 
-#ifdef CONFIG_FS_IOMAP
 static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 {
 	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
@@ -1405,4 +1404,3 @@ int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(dax_iomap_pmd_fault);
 #endif /* CONFIG_FS_DAX_PMD */
-#endif /* CONFIG_FS_IOMAP */
diff --git a/fs/ext2/Kconfig b/fs/ext2/Kconfig
index 36bea5a..c634874e 100644
--- a/fs/ext2/Kconfig
+++ b/fs/ext2/Kconfig
@@ -1,6 +1,5 @@
 config EXT2_FS
 	tristate "Second extended fs support"
-	select FS_IOMAP if FS_DAX
 	help
 	  Ext2 is a standard Linux file system for hard disks.
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
