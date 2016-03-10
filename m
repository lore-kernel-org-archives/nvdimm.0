Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id A72A11A1EF8
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 15:55:55 -0800 (PST)
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 12/14] dax: Use vmf->gfp_mask
Date: Thu, 10 Mar 2016 18:55:29 -0500
Message-Id: <1457654131-4562-13-git-send-email-matthew.r.wilcox@intel.com>
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
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

We were assuming that it was OK to do a GFP_KERNEL allocation in page
fault context.  That appears to be largely true, but filesystems are
permitted to override that in their setting of mapping->gfp_flags, which
the VM then massages into vmf->gfp_flags.  No practical difference for
now, but there may come a day when we would have surprised a filesystem.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 35f0709..50636e1 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -316,7 +316,7 @@ static int dax_load_hole(struct address_space *mapping, struct page *page,
 	struct inode *inode = mapping->host;
 	if (!page)
 		page = find_or_create_page(mapping, vmf->pgoff,
-						GFP_KERNEL | __GFP_ZERO);
+						vmf->gfp_mask | __GFP_ZERO);
 	if (!page)
 		return VM_FAULT_OOM;
 	/* Recheck i_size under page lock to avoid truncate race */
-- 
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
