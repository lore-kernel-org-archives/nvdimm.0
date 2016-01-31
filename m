Return-Path: <owner-linux-mm@kvack.org>
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 0/6] DAX cleanups
Date: Sun, 31 Jan 2016 23:19:49 +1100
Message-Id: <1454242795-18038-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, willy@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Very little exciting in here.  This is all based on the PUD support code
that I just sent, mostly addressing things that came up during review
of the PUD code but weren't really justifiable as being mixed into the
adding of PUD support.

Matthew Wilcox (6):
  dax: Use vmf->gfp_mask
  dax: Remove unnecessary rechecking of i_size
  dax: Use vmf->pgoff in fault handlers
  dax: Use PAGE_CACHE_SIZE where appropriate
  dax: Factor dax_insert_pmd_mapping out of dax_pmd_fault
  dax: Factor dax_insert_pud_mapping out of dax_pud_fault

 fs/dax.c | 395 ++++++++++++++++++++++++++-------------------------------------
 1 file changed, 164 insertions(+), 231 deletions(-)

-- 
2.7.0.rc3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
