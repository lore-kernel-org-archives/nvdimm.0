Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FCDB211158DA
 for <linux-nvdimm@lists.01.org>; Sat,  6 Oct 2018 11:13:47 -0700 (PDT)
Subject: [PATCH] filesystem-dax: Fix dax_layout_busy_page() livelock
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 06 Oct 2018 11:01:52 -0700
Message-ID: <153884891237.3128209.14619968108312095820.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org, Ross Zwisler <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

In the presence of multi-order entries the typical
pagevec_lookup_entries() pattern may loop forever:

	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
				min(end - index, (pgoff_t)PAGEVEC_SIZE),
				indices)) {
		...
		for (i = 0; i < pagevec_count(&pvec); i++) {
			index = indices[i];
			...
		}
		index++; /* BUG */
	}

The loop updates 'index' for each index found and then increments to the
next possible page to continue the lookup. However, if the last entry in
the pagevec is multi-order then the next possible page index is more
than 1 page away. Fix this locally for the filesystem-dax case by
checking for dax-multi-order entries. Going forward new users of
multi-order entries need to be similarly careful, or we need a generic
way to report the page increment in the radix iterator.

Fixes: 5fac7408d828 ("mm, fs, dax: handle layout changes to pinned dax...")
Cc: <stable@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4becbf168b7f..c1472eede1f7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -666,6 +666,8 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 	while (index < end && pagevec_lookup_entries(&pvec, mapping, index,
 				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 				indices)) {
+		pgoff_t nr_pages = 1;
+
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *pvec_ent = pvec.pages[i];
 			void *entry;
@@ -680,8 +682,11 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 
 			xa_lock_irq(&mapping->i_pages);
 			entry = get_unlocked_mapping_entry(mapping, index, NULL);
-			if (entry)
+			if (entry) {
 				page = dax_busy_page(entry);
+				/* account for multi-order entries */
+				nr_pages = 1UL << dax_radix_order(entry);
+			}
 			put_unlocked_mapping_entry(mapping, index, entry);
 			xa_unlock_irq(&mapping->i_pages);
 			if (page)
@@ -696,7 +701,7 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 		 */
 		pagevec_remove_exceptionals(&pvec);
 		pagevec_release(&pvec);
-		index++;
+		index += nr_pages;
 
 		if (page)
 			break;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
