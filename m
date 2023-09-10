Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DA48469
	for <nvdimm@lists.linux.dev>; Sun, 10 Sep 2023 19:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39736C433C7;
	Sun, 10 Sep 2023 19:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1694375179;
	bh=/RdVFooXsrbyX8Eta6x7htXabnWy2twp0h77zhMGNPY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2V9lg14df2D/mgk2t2MzpklZGlXD0fSgDj2B1xO9oTEOo0tWcfKvLnzI6IzxQO+nI
	 8jquFpiRQYfwFrS3s4ytrAXhsLyCNm/mhJXYBw0GlPara4S9uuL2pxGCWqGOF1ScRx
	 5fIsrrT1RU2JjcxqIjAdjhDtkACEXvWGkvWvWtRs=
Date: Sun, 10 Sep 2023 12:46:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: willy@infradead.org, nvdimm@lists.linux.dev, dan.j.williams@intel.com,
 naoya.horiguchi@nec.com, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: Convert DAX lock/unlock page to lock/unlock
 folio
Message-Id: <20230910124618.06a8284ba0e059da11cfa823@linux-foundation.org>
In-Reply-To: <20230908222336.186313-1-jane.chu@oracle.com>
References: <20230908222336.186313-1-jane.chu@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  8 Sep 2023 16:23:36 -0600 Jane Chu <jane.chu@oracle.com> wrote:

> >From Matthew Wilcox:
> 
> The one caller of DAX lock/unlock page already calls compound_head(),
> so use page_folio() instead, then use a folio throughout the DAX code
> to remove uses of page->mapping and page->index. [1]
> 
> The additional change to [1] is comments added to mf_generic_kill_procs().
> 
> [1] https://lore.kernel.org/linux-mm/b2b0fce8-b7f8-420e-0945-ab9581b23d9a@oracle.com/T/
> 

The delta versus the patch which is presently in mm.git is:

--- a/mm/memory-failure.c~a
+++ a/mm/memory-failure.c
@@ -1720,11 +1720,19 @@ static void unmap_and_kill(struct list_h
 	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
 }
 
+/*
+ * Only dev_pagemap pages get here, such as fsdax when the filesystem
+ * either do not claim or fails to claim a hwpoison event, or devdax.
+ * The fsdax pages are initialized per base page, and the devdax pages
+ * could be initialized either as base pages, or as compound pages with
+ * vmemmap optimization enabled. Devdax is simplistic in its dealing with
+ * hwpoison, such that, if a subpage of a compound page is poisoned,
+ * simply mark the compound head page is by far sufficient.
+ */
 static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 		struct dev_pagemap *pgmap)
 {
-	struct page *page = pfn_to_page(pfn);
-	struct folio *folio = page_folio(page);
+	struct folio *folio = pfn_folio(pfn);
 	LIST_HEAD(to_kill);
 	dax_entry_t cookie;
 	int rc = 0;

so I assume this is the v1->v3 delta.

I'll queue this as a fixup patch with the changelog

add comment to mf_generic_kill_procss(), simplify
mf_generic_kill_procs:folio initialization.

