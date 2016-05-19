Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A164F1A1FD4
 for <linux-nvdimm@lists.01.org>; Thu, 19 May 2016 02:27:03 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] dax: Remove unused variable in __dax_pmd_fault()
Date: Thu, 19 May 2016 11:26:52 +0200
Message-Id: <1463650012-8107-1-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Ross spotted this small issue in my patch set so can you guys please merge this
fixup as well? Thanks!

diff --git a/fs/dax.c b/fs/dax.c
index a07202ab8f61..10f0303a92a5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1007,7 +1007,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	struct block_device *bdev;
 	pgoff_t size, pgoff;
 	sector_t block;
-	int error, result = 0;
+	int result = 0;
 	bool alloc = false;
 
 	/* dax pmd mappings require pfn_t_devmap() */
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
