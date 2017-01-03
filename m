Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C3AF817F1
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jan 2017 13:37:56 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] dax: fix deadlock with DAX 4k holes
Date: Tue,  3 Jan 2017 14:36:05 -0700
Message-Id: <1483479365-13607-1-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <20161027112230.wsumgs62fqdxt3sc@xzhoul.usersys.redhat.com>
References: <20161027112230.wsumgs62fqdxt3sc@xzhoul.usersys.redhat.com>
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
To: Xiong Zhou <xzhou@redhat.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Dave Hansen <dave.hansen@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Currently in DAX if we have three read faults on the same hole address we
can end up with the following:

Thread 0		Thread 1		Thread 2
--------		--------		--------
dax_iomap_fault
 grab_mapping_entry
  lock_slot
   <locks empty DAX entry>

  			dax_iomap_fault
			 grab_mapping_entry
			  get_unlocked_mapping_entry
			   <sleeps on empty DAX entry>

						dax_iomap_fault
						 grab_mapping_entry
						  get_unlocked_mapping_entry
						   <sleeps on empty DAX entry>
  dax_load_hole
   find_or_create_page
   ...
    page_cache_tree_insert
     dax_wake_mapping_entry_waiter
      <wakes one sleeper>
     __radix_tree_replace
      <swaps empty DAX entry with 4k zero page>

			<wakes>
			get_page
			lock_page
			...
			put_locked_mapping_entry
			unlock_page
			put_page

						<sleeps forever on the DAX
						 wait queue>

The crux of the problem is that once we insert a 4k zero page, all locking
from then on is done in terms of that 4k zero page and any additional
threads sleeping on the empty DAX entry will never be woken.  Fix this by
waking all sleepers when we replace the DAX radix tree entry with a 4k zero
page.  This will allow all sleeping threads to successfully transition from
locking based on the DAX empty entry to locking on the 4k zero page.

With the test case reported by Xiong this happens very regularly in my test
setup, with some runs resulting in 9+ threads in this deadlocked state.
With this fix I've been able to run that same test dozens of times in a
loop without issue.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Xiong Zhou <xzhou@redhat.com>
Fixes: commit ac401cc78242 ("dax: New fault locking")
Cc: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # 4.7+
---

This issue exists as far back as v4.7, and I was easly able to reproduce it
with v4.7 using the same test.

Unfortunately this patch won't apply cleanly to the stable trees, but the
change is very simple and should be easy to replicate by hand.  Please ping
me if you'd like patches that apply cleanly to the v4.9 and v4.8.15 trees.

---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index d0e4d10..b772a33 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -138,7 +138,7 @@ static int page_cache_tree_insert(struct address_space *mapping,
 				dax_radix_locked_entry(0, RADIX_DAX_EMPTY));
 			/* Wakeup waiters for exceptional entry lock */
 			dax_wake_mapping_entry_waiter(mapping, page->index, p,
-						      false);
+						      true);
 		}
 	}
 	__radix_tree_replace(&mapping->page_tree, node, slot, page,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
