Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 13C891A1F6A
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 15:56:09 -0800 (PST)
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 11/14] ext4: Support for PUD-sized transparent huge pages
Date: Thu, 10 Mar 2016 18:55:28 -0500
Message-Id: <1457654131-4562-12-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <1457654131-4562-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1457654131-4562-1-git-send-email-matthew.r.wilcox@intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Matthew Wilcox <willy@linux.intel.com>

ext4 needs to reserve enough space in the journal to allocate a PUD-sized
page.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/ext4/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index a2f975e..b966b17 100644
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
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
