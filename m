Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1DC62119309E
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 13:16:49 -0800 (PST)
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 1/2] dax: Check page->mapping isn't NULL
Date: Tue, 27 Nov 2018 13:16:33 -0800
Message-Id: <20181127211634.4995-2-willy@infradead.org>
In-Reply-To: <20181127211634.4995-1-willy@infradead.org>
References: <20181127211634.4995-1-willy@infradead.org>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

If we race with inode destroy, it's possible for page->mapping to be
NULL before we even enter this routine, as well as after having slept
waiting for the dax entry to become unlocked.

Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
Cc: stable@vger.kernel.org
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9bcce89ea18e..e69fc231833b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -365,7 +365,7 @@ bool dax_lock_mapping_entry(struct page *page)
 		struct address_space *mapping = READ_ONCE(page->mapping);
 
 		locked = false;
-		if (!dax_mapping(mapping))
+		if (!mapping || !dax_mapping(mapping))
 			break;
 
 		/*
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
