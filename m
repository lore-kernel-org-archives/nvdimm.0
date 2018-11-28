Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 58D3821B02822
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 11:06:12 -0800 (PST)
Subject: [4.19-stable PATCH] dax: Avoid losing wakeup in dax_lock_mapping_entry
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Nov 2018 10:53:44 -0800
Message-ID: <154343119877.981933.9776503138356369421.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20181126142743.GA25618@bombadil.infradead.org>
References: <20181126142743.GA25618@bombadil.infradead.org>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Matthew Wilcox <willy@infradead.org>

commit 25bbe21bf427a81b8e3ccd480ea0e1d940256156 upstream.

After calling get_unlocked_entry(), you have to call
put_unlocked_entry() to avoid subsequent waiters losing wakeups.

Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Passes the nvdimm unit test suite which exercises the lock path.

 fs/dax.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 0fb270f0a0ef..b0cd1364c68f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -217,6 +217,9 @@ static inline void *unlock_slot(struct address_space *mapping, void **slot)
 	return (void *)entry;
 }
 
+static void put_unlocked_mapping_entry(struct address_space *mapping,
+				       pgoff_t index, void *entry);
+
 /*
  * Lookup entry in radix tree, wait for it to become unlocked if it is
  * exceptional entry and return it. The caller must call
@@ -256,8 +259,10 @@ static void *__get_unlocked_mapping_entry(struct address_space *mapping,
 		revalidate = wait_fn();
 		finish_wait(wq, &ewait.wait);
 		xa_lock_irq(&mapping->i_pages);
-		if (revalidate)
+		if (revalidate) {
+			put_unlocked_mapping_entry(mapping, index, entry);
 			return ERR_PTR(-EAGAIN);
+		}
 	}
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
