Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBBB2209831CF
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 21:59:48 -0700 (PDT)
Subject: [PATCH v6 04/13] filesystem-dax: Set page->index
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 21:49:50 -0700
Message-ID: <153154379074.34503.9610948190338126460.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

In support of enabling memory_failure() handling for filesystem-dax
mappings, set ->index to the pgoff of the page. The rmap implementation
requires ->index to bound the search through the vma interval tree. The
index is set and cleared at dax_associate_entry() and
dax_disassociate_entry() time respectively.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 641192808bb6..4de11ed463ce 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -319,18 +319,27 @@ static unsigned long dax_radix_end_pfn(void *entry)
 	for (pfn = dax_radix_pfn(entry); \
 			pfn < dax_radix_end_pfn(entry); pfn++)
 
-static void dax_associate_entry(void *entry, struct address_space *mapping)
+/*
+ * TODO: for reflink+dax we need a way to associate a single page with
+ * multiple address_space instances at different linear_page_index()
+ * offsets.
+ */
+static void dax_associate_entry(void *entry, struct address_space *mapping,
+		struct vm_area_struct *vma, unsigned long address)
 {
-	unsigned long pfn;
+	unsigned long size = dax_entry_size(entry), pfn, index;
+	int i = 0;
 
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return;
 
+	index = linear_page_index(vma, address & ~(size - 1));
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
 		WARN_ON_ONCE(page->mapping);
 		page->mapping = mapping;
+		page->index = index + i++;
 	}
 }
 
@@ -348,6 +357,7 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
 		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
 		page->mapping = NULL;
+		page->index = 0;
 	}
 }
 
@@ -701,7 +711,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 	new_entry = dax_radix_locked_entry(pfn, flags);
 	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
 		dax_disassociate_entry(entry, mapping, false);
-		dax_associate_entry(new_entry, mapping);
+		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
 	}
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
