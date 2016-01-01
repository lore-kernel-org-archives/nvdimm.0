Return-Path: <owner-linux-mm@kvack.org>
Subject: [-mm PATCH] dax: fix dax_pmd_dbg build warning
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Dec 2015 19:58:28 -0800
Message-ID: <20160101035828.29910.59955.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Fixes below warning from commit 3cb108f941deb
"dax-add-support-for-fsync-sync-v6" in -next.

    fs/dax.c: In function ‘__dax_pmd_fault’:
    fs/dax.c:916:15: warning: passing argument 1 of ‘__dax_dbg’ from incompatible pointer type
         dax_pmd_dbg(bdev, address,
                   ^
    fs/dax.c:738:13: note: expected ‘struct buffer_head *’ but argument is of type ‘struct block_device *’
     static void __dax_dbg(struct buffer_head *bh, unsigned long address,

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4ff61b412383..41cf4ee0b859 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -913,7 +913,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 			error = dax_radix_entry(mapping, pgoff, dax.sector,
 					true, true);
 			if (error) {
-				dax_pmd_dbg(bdev, address,
+				dax_pmd_dbg(&bh, address,
 						"PMD radix insertion failed");
 				goto fallback;
 			}

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
