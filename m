Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAB6E21159930
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 04:23:41 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] dax: Fix deadlock in dax_lock_mapping_entry()
Date: Thu, 27 Sep 2018 13:23:32 +0200
Message-Id: <20180927112332.3649-1-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, Barret Rhoden <brho@google.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When dax_lock_mapping_entry() has to sleep to obtain entry lock, it will
fail to unlock mapping->i_pages spinlock and thus immediately deadlock
against itself when retrying to grab the entry lock again. Fix the
problem by unlocking mapping->i_pages before retrying.

Fixes: c2a7d2a115525d3501d38e23d24875a79a07e15e
Reported-by: Barret Rhoden <brho@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

Dan, can you please get this merged? Otherwise dax_lock_mapping_entry()
deadlocks as soon as there's any contention.

diff --git a/fs/dax.c b/fs/dax.c
index b68ce484e1be..4becbf168b7f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -447,6 +447,7 @@ bool dax_lock_mapping_entry(struct page *page)
 			xa_unlock_irq(&mapping->i_pages);
 			break;
 		} else if (IS_ERR(entry)) {
+			xa_unlock_irq(&mapping->i_pages);
 			WARN_ON_ONCE(PTR_ERR(entry) != -EAGAIN);
 			continue;
 		}
-- 
2.16.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
