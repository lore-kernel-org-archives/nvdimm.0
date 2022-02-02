Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40D42F27
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 18:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DHt+NoiQ/xSDzcu85V4cS/XqDEmzCog6ySkjKbfn9Y4=; b=Pc3z+/fGMsWFz6LsSLIIQE5noH
	/S4+fwoYEH0STHqc5Vh9NnnAMQBL07imdXuFR+SlwylTbKodsNxhP1pZb3tp5bCXn19LzDITTKcxB
	cQlQhPLSrCxeywyWBe+ajFd4uB40UM3qdNMAPxmMDdvinodcuT+Ht9LsP5DYBK81MYUEaxV6oRQc4
	cNRR7p3wDwukXXid0UOM8DAEOUHQuQapC60F0vFAdw/vJyYkW1FjqtG4SxJXbUOrMRNYS/OdXxHNX
	r/94W6wRKoMP0UBjr26/YURhqnOfzagiNzzKT4gm1is+U63mxHPiwfmxyp6IyE0EMSZaMGJdCD3eU
	5AvLNsew==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFKMk-00FbFv-Pl; Wed, 02 Feb 2022 18:28:26 +0000
Date: Wed, 2 Feb 2022 18:28:26 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: dan.j.williams@intel.com, jack@suse.cz, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, apopple@nvidia.com, shy828301@gmail.com,
	rcampbell@nvidia.com, hughd@google.com, xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com, zwisler@kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, duanxiongchun@bytedance.com
Subject: Re: [PATCH v2 3/6] mm: page_vma_mapped: support checking if a pfn is
 mapped into a vma
Message-ID: <YfrNSvttbQgLKKwj@casper.infradead.org>
References: <20220202143307.96282-1-songmuchun@bytedance.com>
 <20220202143307.96282-4-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202143307.96282-4-songmuchun@bytedance.com>

On Wed, Feb 02, 2022 at 10:33:04PM +0800, Muchun Song wrote:
> page_vma_mapped_walk() is supposed to check if a page is mapped into a vma.
> However, not all page frames (e.g. PFN_DEV) have a associated struct page
> with it. There is going to be some duplicate codes similar with this function
> if someone want to check if a pfn (without a struct page) is mapped into a
> vma. So add support for checking if a pfn is mapped into a vma. In the next
> patch, the dax will use this new feature.

I'm coming to more or less the same solution for fixing the bug in
page_mapped_in_vma().  If you call it with a head page, it will look
for any page in the THP instead of the precise page.  I think we can do
a fairly significant simplification though, so I'm going to go off
and work on that next ...

