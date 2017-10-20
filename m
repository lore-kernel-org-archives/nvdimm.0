Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0552B202E60FB
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 19:42:20 -0700 (PDT)
Subject: [PATCH v3 07/13] dax: warn if dma collides with truncate
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 19:39:34 -0700
Message-ID: <150846717482.24336.5408601305480590234.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Catch cases where truncate encounters pages that are still under active
dma. This warning is a canary for potential data corruption as truncated
blocks could be allocated to a new file while the device is still
perform i/o.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index ac6497dcfebd..b03f547b36e7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -437,6 +437,38 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 	return entry;
 }
 
+static unsigned long dax_entry_size(void *entry)
+{
+	if (dax_is_zero_entry(entry))
+		return 0;
+	else if (dax_is_pmd_entry(entry))
+		return HPAGE_SIZE;
+	else
+		return PAGE_SIZE;
+}
+
+static void dax_check_truncate(void *entry)
+{
+	unsigned long pfn = dax_radix_pfn(entry);
+	unsigned long size = dax_entry_size(entry);
+	unsigned long end_pfn;
+
+	if (!size)
+		return;
+	end_pfn = pfn + size / PAGE_SIZE;
+	for (; pfn < end_pfn; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		/*
+		 * devmap pages are idle when their count is 1 and the
+		 * only path that increases their count is
+		 * get_user_pages().
+		 */
+		WARN_ONCE(page_ref_count(page) > 1,
+				"dax-dma truncate collision\n");
+	}
+}
+
 static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
 {
@@ -452,6 +484,7 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	    (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
 	     radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE)))
 		goto out;
+	dax_check_truncate(entry);
 	radix_tree_delete(page_tree, index);
 	mapping->nrexceptional--;
 	ret = 1;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
