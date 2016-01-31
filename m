Return-Path: <owner-linux-mm@kvack.org>
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v4 8/8] ext4: Support for PUD-sized transparent huge pages
Date: Sun, 31 Jan 2016 23:09:35 +1100
Message-Id: <1454242175-16870-9-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <1454242175-16870-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1454242175-16870-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Matthew Wilcox <willy@linux.intel.com>

ext4 needs to reserve enough space in the journal to allocate a PUD-sized
page.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/ext4/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 71859ed..ec6664a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -211,6 +211,10 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 			nblocks = ext4_chunk_trans_blocks(inode,
 						PMD_SIZE / PAGE_SIZE);
 			break;
+		case FAULT_FLAG_SIZE_PUD:
+			nblocks = ext4_chunk_trans_blocks(inode,
+						PUD_SIZE / PAGE_SIZE);
+			break;
 		default:
 			return VM_FAULT_FALLBACK;
 		}
-- 
2.7.0.rc3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
