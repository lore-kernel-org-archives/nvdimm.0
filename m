Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB11A2E762C;
	Sat, 26 Sep 2026 06:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403551; cv=none; b=qOzM17GjkUt4zVbPZuTerdcmabZW1anivzdGxoPQaDOD+Th9n8c3dDdgFGbFMAUHpyz4Yet02RPfzJVaqrS+wbkATcUjGw5+fnDdotStLXPNndE5WhlIAb5FkkVG+EqnibkJfKNO527DRsG8s/xFYnDYjtBMA5lyU4iXBDw5LbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403551; c=relaxed/simple;
	bh=LLAD/cysRIRq98BeK4gztFhOZ+m4K3Jogwtr/LAIuJI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Nor5nF8vlg1z6Ds/xeZjlSVMa1C8wWl7VN5nyIphxZkDNIEfQRLfLDebIx4QT+6UcCnlZej4Balf+gC4XDIZYqej+5Xoi62LIB/QtqFRLjyyfa35WcgAPov3PpX2y16I8JDUpvB4gECcOuMUB9LK1EvYh2utqhU1fGAexvyZI3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UTmCT6tM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UTmCT6tM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4691F000FF;
	Sat, 26 Sep 2026 06:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790403549;
	bh=0d2FoQNgB7w5W4igVSjXZBz5vM5BFD2MZGCHDpY+/iY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UTmCT6tMUksCasct4m6WGBQGIIq91wboZ/ltaw9f0etfNs5HNBcuscWHiY4/AfSPL
	 BF+Ryz+38xr+l3wstvnofOr0t+y/7Ozx6CN/DjlMRcwtAFe75KfAQ223AiHiIfEP6T
	 E+hgCPcbvG4pQJpXrvNXHtGAGpJvfQ8GnCMNLriQ=
Date: Fri, 25 Sep 2026 23:19:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Dan Williams
 <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang
 <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, Ira
 Weiny <iweiny@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/page-flags: Define HWPoison test-and-change
 helpers unconditionally
Message-Id: <20260925231908.25febf6c085f52be3a65d59b@linux-foundation.org>
In-Reply-To: <6eb272c0-0cfa-4354-a92b-4fc270e3b1fc@kernel.org>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
	<20260903053535.17611-2-kaitao.cheng@linux.dev>
	<6eb272c0-0cfa-4354-a92b-4fc270e3b1fc@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 7 Sep 2026 17:42:11 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 9/3/26 07:35, Kaitao Cheng wrote:
> > From: Kaitao Cheng <chengkaitao@kylinos.cn>
> > 
> > Page flag helpers for configuration-dependent flags provide false or no-op
> > variants so that their users can be independent of the configuration.
> > 
> > The HWPoison helpers do not fully follow this pattern. When
> > CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
> > regular, test-and-set, and test-and-clear operations. When it is disabled,
> > only PAGEFLAG_FALSE() is instantiated, leaving TestSetPageHWPoison() and
> > TestClearPageHWPoison() undefined.
> > 
> > Use TESTSCFLAG_FALSE() to provide the missing accessors when memory failure
> > handling is disabled. Both accessors return false, which is consistent with
> > HWPoison state being unavailable, and makes the accessor interface
> > consistent across configurations.
> > 
> > Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> > ---
> >  include/linux/page-flags.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 7a863572adce..a2315ab1dd3a 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -656,6 +656,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
> >  #define __PG_HWPOISON (1UL << PG_hwpoison)
> >  #else
> >  PAGEFLAG_FALSE(HWPoison, hwpoison)
> > +TESTSCFLAG_FALSE(HWPoison, hwpoison)
> >  #define __PG_HWPOISON 0
> >  #endif
> >  
> 
> Can we just squash this patch into #2 please?

I did that.


From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/page-flags: define HWPoison test-and-change helpers unconditionally
Date: Thu, 3 Sep 2026 13:35:34 +0800

Page flag helpers for configuration-dependent flags provide false or no-op
variants so that their users can be independent of the configuration.

The HWPoison helpers do not fully follow this pattern.  When
CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
regular, test-and-set, and test-and-clear operations.  When it is
disabled, only PAGEFLAG_FALSE() is instantiated, leaving
TestSetPageHWPoison() and TestClearPageHWPoison() undefined.

Use TESTSCFLAG_FALSE() to provide the missing accessors when memory
failure handling is disabled.  Both accessors return false, which is
consistent with HWPoison state being unavailable, and makes the accessor
interface consistent across configurations.

Also remove now-unneeded test_and_clear_pmem_poison() from nvdimm/pmem.

Link: https://lore.kernel.org/20260903053535.17611-1-kaitao.cheng@linux.dev
Link: https://lore.kernel.org/20260903053535.17611-2-kaitao.cheng@linux.dev
Link: https://lore.kernel.org/20260903053535.17611-3-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ira Weiny <iweiny@kernel.org>
---

 drivers/nvdimm/pmem.c      |    2 +-
 drivers/nvdimm/pmem.h      |   12 ------------
 include/linux/page-flags.h |    1 +
 3 files changed, 2 insertions(+), 13 deletions(-)

--- a/include/linux/page-flags.h~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
+++ a/include/linux/page-flags.h
@@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison, hwpoison)
+TESTSCFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
--- a/drivers/nvdimm/pmem.c~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
+++ a/drivers/nvdimm/pmem.c
@@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct p
 		 * here since we're in the driver I/O path and
 		 * outstanding I/O requests pin the dev_pagemap.
 		 */
-		if (test_and_clear_pmem_poison(page))
+		if (TestClearPageHWPoison(page))
 			clear_mce_nospec(pfn);
 	}
 }
--- a/drivers/nvdimm/pmem.h~mm-page-flags-define-hwpoison-test-and-change-helpers-unconditionally
+++ a/drivers/nvdimm/pmem.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __NVDIMM_PMEM_H__
 #define __NVDIMM_PMEM_H__
-#include <linux/page-flags.h>
 #include <linux/badblocks.h>
 #include <linux/memremap.h>
 #include <linux/types.h>
@@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_de
 		long nr_pages, enum dax_access_mode mode, void **kaddr,
 		unsigned long *pfn);
 
-#ifdef CONFIG_MEMORY_FAILURE
-static inline bool test_and_clear_pmem_poison(struct page *page)
-{
-	return TestClearPageHWPoison(page);
-}
-#else
-static inline bool test_and_clear_pmem_poison(struct page *page)
-{
-	return false;
-}
-#endif
 #endif /* __NVDIMM_PMEM_H__ */
_

