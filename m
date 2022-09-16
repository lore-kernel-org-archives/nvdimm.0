Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A0D20EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299387; x=1694835387;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ajaFzvrRPG16T180cU73eT4NP/l2RlRiUDdGWZj7wgU=;
  b=V6Z+xkkAQCCNfLUyTnvd7MbisOcimRcfLlmE0pfW0a7kcmYplm7GQqiU
   TvrGoP9axXzgOPl7E1tch2zkErmrqwI7qz2C5ChliWCU/S1S07AxWi6cE
   0wEjAsnr1S6M+sVSCdv1EgVbppzgwF+pkeCshbHw788oAi0c209yvrSS/
   KNEiDcK9S3gmwGKz8KQXd3dKg9/AEDshLjoEnW83gLjWDG86hTE4pyfye
   YpIv75e0WYOjUk9D2waPNobGOwBBt/I/43e2mPfTEVuK3k2K0X0RvxjOs
   cqMgOx8BeoznitqMr0HiVxrQm7xpq2SA+9xasJ8qXyYs7NrJcEsqOksDh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="360643260"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="360643260"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="679809498"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:36:25 -0700
Subject: [PATCH v2 13/18] dax: Prep mapping helpers for compound pages
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:36:25 -0700
Message-ID: <166329938508.2786261.5544204703263725154.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for device-dax to use the same mapping machinery as
fsdax, add support for device-dax compound pages.

Presently this is handled by dax_set_mapping() which is careful to only
update page->mapping for head pages. However, it does that by looking at
properties in the 'struct dev_dax' instance associated with the page.
Switch to just checking PageHead() directly in the functions that
iterate over pages in a large mapping.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig   |    1 +
 drivers/dax/mapping.c |   16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 205e9dda8928..2eddd32c51f4 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -9,6 +9,7 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
+	depends on !FS_DAX_LIMITED
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/drivers/dax/mapping.c b/drivers/dax/mapping.c
index 70576aa02148..5d4b9601f183 100644
--- a/drivers/dax/mapping.c
+++ b/drivers/dax/mapping.c
@@ -345,6 +345,8 @@ static vm_fault_t dax_associate_entry(void *entry,
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
+		page = compound_head(page);
+
 		if (flags & DAX_COW) {
 			dax_mapping_set_cow(page);
 		} else {
@@ -353,6 +355,9 @@ static vm_fault_t dax_associate_entry(void *entry,
 			page->index = index + i++;
 			page_ref_inc(page);
 		}
+
+		if (PageHead(page))
+			break;
 	}
 
 	return 0;
@@ -372,6 +377,9 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 
 	for_each_mapped_pfn(entry, pfn) {
 		page = pfn_to_page(pfn);
+
+		page = compound_head(page);
+
 		if (dax_mapping_is_cow(page->mapping)) {
 			/* keep the CoW flag if this page is still shared */
 			if (page->index-- > 0)
@@ -383,6 +391,9 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 		}
 		page->mapping = NULL;
 		page->index = 0;
+
+		if (PageHead(page))
+			break;
 	}
 
 	if (trunc && !dax_mapping_is_cow(page->mapping)) {
@@ -660,11 +671,16 @@ static struct page *dax_zap_pages(struct xa_state *xas, void *entry)
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
+		page = compound_head(page);
+
 		if (zap)
 			page_ref_dec(page);
 
 		if (!ret && !dax_page_idle(page))
 			ret = page;
+
+		if (PageHead(page))
+			break;
 	}
 
 	if (zap)

