Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1240C1A1EA1
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 09:29:34 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/7] dax: Make huge page handling depend of CONFIG_BROKEN
Date: Thu, 12 May 2016 18:29:15 +0200
Message-Id: <1463070560-1979-3-git-send-email-jack@suse.cz>
In-Reply-To: <1463070560-1979-1-git-send-email-jack@suse.cz>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
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
To: linux-nvdimm@lists.01.org
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Currently the handling of huge pages for DAX is racy. For example the
following can happen:

CPU0 (THP write fault)			CPU1 (normal read fault)

__dax_pmd_fault()			__dax_fault()
  get_block(inode, block, &bh, 0) -> not mapped
					get_block(inode, block, &bh, 0)
					  -> not mapped
  if (!buffer_mapped(&bh) && write)
    get_block(inode, block, &bh, 1) -> allocates blocks
  truncate_pagecache_range(inode, lstart, lend);
					dax_load_hole();

This results in data corruption since process on CPU1 won't see changes
into the file done by CPU0.

The race can happen even if two normal faults race however with THP the
situation is even worse because the two faults don't operate on the same
entries in the radix tree and we want to use these entries for
serialization. So make THP support in DAX code depend on CONFIG_BROKEN
for now.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/Kconfig          | 1 +
 fs/dax.c            | 2 +-
 include/linux/dax.h | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 6725f59c18e6..b8fcb416be72 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -52,6 +52,7 @@ config FS_DAX_PMD
 	depends on FS_DAX
 	depends on ZONE_DEVICE
 	depends on TRANSPARENT_HUGEPAGE
+	depends on BROKEN
 
 endif # BLOCK
 
diff --git a/fs/dax.c b/fs/dax.c
index d7addfab2094..ef44ee2af7af 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -707,7 +707,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 }
 EXPORT_SYMBOL_GPL(dax_fault);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
 /*
  * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
  * more often than one might expect in the below function.
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 7c45ac7ea1d1..3be567e3ae9c 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -23,7 +23,7 @@ static inline struct page *read_dax_sector(struct block_device *bdev,
 }
 #endif
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
 int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
 				unsigned int flags, get_block_t);
 int __dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
