Return-Path: <linux-ext4-owner@vger.kernel.org>
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/18] dax: Fix condition for filling of PMD holes
Date: Mon, 18 Apr 2016 23:35:34 +0200
Message-Id: <1461015341-20153-12-git-send-email-jack@suse.cz>
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Currently dax_pmd_fault() decides to fill a PMD-sized hole only if
returned buffer has BH_Uptodate set. However that doesn't get set for
any mapping buffer so that branch is actually a dead code. The
BH_Uptodate check doesn't make any sense so just remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 237581441bc1..42bf65b4e752 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -878,7 +878,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		goto fallback;
 	}
 
-	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
+	if (!write && !buffer_mapped(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
 		struct page *zero_page = get_huge_zero_page();
-- 
2.6.6

