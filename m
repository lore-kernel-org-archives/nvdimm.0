Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7867480
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 20:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0366EC433C1;
	Fri,  2 Dec 2022 20:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1670012281;
	bh=vzzVaosh6o8JL4+OzaJBhy3ljlqNHLgnYfdJDBqdxdM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Qiy/Rz8BpdMFrfatVnHWOKxqNt2djdf4PTkeB4ZV0Tyn/Jb62vwuneHFMPvFBOLkw
	 w+r2SMd4NOzTl+0auLMbL5P9Ju/DUFPVUf9f6PpA331zT7i0awPSCxDvrLwf3LVuOZ
	 5NfKJOs/ikde+UrvqNcQBJIVEwVlRSMNBkhNHLXY=
Date: Fri, 2 Dec 2022 12:18:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
 <djwong@kernel.org>, <david@fromorbit.com>, <dan.j.williams@intel.com>
Subject: Re: [PATCH v2.1 1/8] fsdax: introduce page->share for fsdax in
 reflink mode
Message-Id: <20221202121800.598afc7a5124561069f91014@linux-foundation.org>
In-Reply-To: <1669972991-246-1-git-send-email-ruansy.fnst@fujitsu.com>
References: <1669908538-55-2-git-send-email-ruansy.fnst@fujitsu.com>
	<1669972991-246-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Dec 2022 09:23:11 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

> fsdax page is used not only when CoW, but also mapread. To make the it
> easily understood, use 'share' to indicate that the dax page is shared
> by more than one extent.  And add helper functions to use it.
> 
> Also, the flag needs to be renamed to PAGE_MAPPING_DAX_SHARED.
> 

For those who are wondering what changed, I queued the below incremental
patch.


From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: introduce page->share for fsdax in reflink mode
Date: Fri, 2 Dec 2022 09:23:11 +0000

rename several functions

Link: https://lkml.kernel.org/r/1669972991-246-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/dax.c~fsdax-introduce-page-share-for-fsdax-in-reflink-mode-fix
+++ a/fs/dax.c
@@ -334,7 +334,7 @@ static unsigned long dax_end_pfn(void *e
 	for (pfn = dax_to_pfn(entry); \
 			pfn < dax_end_pfn(entry); pfn++)
 
-static inline bool dax_mapping_is_shared(struct page *page)
+static inline bool dax_page_is_shared(struct page *page)
 {
 	return (unsigned long)page->mapping == PAGE_MAPPING_DAX_SHARED;
 }
@@ -343,7 +343,7 @@ static inline bool dax_mapping_is_shared
  * Set the page->mapping with PAGE_MAPPING_DAX_SHARED flag, increase the
  * refcount.
  */
-static inline void dax_mapping_set_shared(struct page *page)
+static inline void dax_page_bump_sharing(struct page *page)
 {
 	if ((uintptr_t)page->mapping != PAGE_MAPPING_DAX_SHARED) {
 		/*
@@ -357,7 +357,7 @@ static inline void dax_mapping_set_share
 	page->share++;
 }
 
-static inline unsigned long dax_mapping_decrease_shared(struct page *page)
+static inline unsigned long dax_page_drop_sharing(struct page *page)
 {
 	return --page->share;
 }
@@ -381,7 +381,7 @@ static void dax_associate_entry(void *en
 		struct page *page = pfn_to_page(pfn);
 
 		if (shared) {
-			dax_mapping_set_shared(page);
+			dax_page_bump_sharing(page);
 		} else {
 			WARN_ON_ONCE(page->mapping);
 			page->mapping = mapping;
@@ -402,9 +402,9 @@ static void dax_disassociate_entry(void
 		struct page *page = pfn_to_page(pfn);
 
 		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
-		if (dax_mapping_is_shared(page)) {
+		if (dax_page_is_shared(page)) {
 			/* keep the shared flag if this page is still shared */
-			if (dax_mapping_decrease_shared(page) > 0)
+			if (dax_page_drop_sharing(page) > 0)
 				continue;
 		} else
 			WARN_ON_ONCE(page->mapping && page->mapping != mapping);
_

