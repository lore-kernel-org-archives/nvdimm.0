Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 147D61A1F1C
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 09:29:34 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/7] dax: Fix condition for filling of PMD holes
Date: Thu, 12 May 2016 18:29:14 +0200
Message-Id: <1463070560-1979-2-git-send-email-jack@suse.cz>
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

Currently dax_pmd_fault() decides to fill a PMD-sized hole only if
returned buffer has BH_Uptodate set. However that doesn't get set for
any mapping buffer so that branch is actually a dead code. The
BH_Uptodate check doesn't make any sense so just remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9bc6624251b4..d7addfab2094 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -820,7 +820,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 
 	i_mmap_lock_read(mapping);
 
-	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
+	if (!write && !buffer_mapped(&bh)) {
 		spinlock_t *ptl;
 		pmd_t entry;
 		struct page *zero_page = get_huge_zero_page();
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
