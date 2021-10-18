Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D082C89
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 18:37:51 +0000 (UTC)
Received: by mail-qk1-f170.google.com with SMTP id x123so2421598qke.7
        for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 11:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wJNcqyK0rI+evQwD2jibSP3vMmIjKUzQYxLr4+LBMxw=;
        b=mHTSwxuHIb35EXaVeJxHacMsxHXRiwRrzFlTIzu95R4xpKwQjwTi98YJDiO/ogOyVM
         1V7to07GJw+HEy22WjoZpWwQLvne2PqoTaWujVU221XSQ58bOy/UsmRz4R02QewOXFks
         acre2QabSw5LHCBI+pv5SpreClVFg/bJ6nlQ/VS75gnqpOpQ72VMWJUgtPfdSaVZ2NRR
         aR9NXBrEKrOwNVxyGUgJ3GgJi4d5JiOV3jk9t3w19Mx1HFZ37As2BIG1ofkgahbOsDOr
         Ld9w6HJk+P8TZXAQcbI/asl8w6v8xhjwIELLnYWoSLB09w6bhkGIiXfr0SSCeYn6edEm
         cAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wJNcqyK0rI+evQwD2jibSP3vMmIjKUzQYxLr4+LBMxw=;
        b=XoHnpnyDG9h0wDDNYDktUA/Kgs++dkfuUlSlYDh27E8XdTf98D04vkuTlW9t/Jf7Nz
         x3+0j/fjsWLyJ90Wz3LaswasR64A66luGo2cx002yusyconsxORTccsQJKfmt4kxUdiE
         Vf0TbJnYTFMqvp01QZ28bGGAjcUwe19snT5BFgLE7fI7zWX7HJzwgGaIhdyPFhqxWDLq
         8hDBjKsUOBR600laPu7KCQo7SgTe2b2QehwRd3u1sNDLh5m6wyFFjRo4ayF98oiMVdhi
         hdhij8asinJSYRP/EaNglPHVCcOs8MKLNae9bWfM297S2iweUDsPcWjj7E1PR+/SsPYv
         9dng==
X-Gm-Message-State: AOAM531voOUEprRUKJTZVl1194HqKhDAbSueM1ioh5/Be611KCsayQNJ
	c2idco8OrP8Cwju9fflTWuoOvA==
X-Google-Smtp-Source: ABdhPJwqYNU955h8X5OyxNzk5+v0MXjssNIi2HrA1CNfbfl5up52FXcbIilaAETYLXx/PoOFN5pYfg==
X-Received: by 2002:a05:620a:1a28:: with SMTP id bk40mr15176090qkb.224.1634582270558;
        Mon, 18 Oct 2021 11:37:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id bk7sm5189997qkb.72.2021.10.18.11.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 11:37:50 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mcXW9-00GLve-Gq; Mon, 18 Oct 2021 15:37:49 -0300
Date: Mon, 18 Oct 2021 15:37:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
Message-ID: <20211018183749.GE3686969@ziepe.ca>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
 <20210827162552.GK1200268@ziepe.ca>
 <da90638d-d97f-bacb-f0fa-01f5fd9f2504@oracle.com>
 <20210830130741.GO1200268@ziepe.ca>
 <cda6d8fb-bd48-a3de-9d4e-96e4a43ebe58@oracle.com>
 <20210831170526.GP1200268@ziepe.ca>
 <8c23586a-eb3b-11a6-e72a-dcc3faad4e96@oracle.com>
 <20210928180150.GI3544071@ziepe.ca>
 <3f35cc33-7012-5230-a771-432275e6a21e@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f35cc33-7012-5230-a771-432275e6a21e@oracle.com>

On Wed, Sep 29, 2021 at 12:50:15PM +0100, Joao Martins wrote:
> On 9/28/21 19:01, Jason Gunthorpe wrote:
> > On Thu, Sep 23, 2021 at 05:51:04PM +0100, Joao Martins wrote:
> >> So ... if pgmap accounting was removed from gup-fast then this patch
> >> would be a lot simpler and we could perhaps just fallback to the regular
> >> hugepage case (THP, HugeTLB) like your suggestion at the top. See at the
> >> end below scissors mark as the ballpark of changes.
> >>
> >> So far my options seem to be: 1) this patch which leverages the existing
> >> iteration logic or 2) switching to for_each_compound_range() -- see my previous
> >> reply 3) waiting for Dan to remove @pgmap accounting in gup-fast and use
> >> something similar to below scissors mark.
> >>
> >> What do you think would be the best course of action?
> > 
> > I still think the basic algorithm should be to accumulate physicaly
> > contiguous addresses when walking the page table and then flush them
> > back to struct pages once we can't accumulate any more.
> > 
> > That works for both the walkers and all the page types?
> > 
> 
> The logic already handles all page types -- I was trying to avoid the extra
> complexity in regular hugetlb/THP path by not merging the handling of the
> oddball case that is devmap (or fundamentally devmap
> non-compound case in the future).

FYI, this untested thing is what I came to when I tried to make
something like this:

/*
 * A large page entry such as PUD/PMD can point to a struct page. In cases like
 * THP this struct page will be a compound page of the same order as the page
 * table level. However, in cases like DAX or more generally pgmap ZONE_DEVICE,
 * the PUD/PMD may point at the first pfn in a string of pages.
 *
 * This helper iterates over all head pages or all the non-compound base pages.
 */
static pt_entry_iter_state
{
	struct page *head;
	unsigned long compound_nr;
	unsigned long pfn;
	unsigned long end_pfn;
};

static inline struct page *__pt_start_iter(struct iter_state *state,
					   struct page *page, unsigned long pfn,
					   unsigned int entry_size)
{
	state->head = compound_head(page);
	state->compound_nr = compound_nr(page);
	state->pfn = pfn & (~(state->compound_nr - 1));
	state->end_pfn = pfn + entry_size / PAGE_SIZE;
	return state->head;
}

static inline struct page *__pt_next_page(struct iter_state *state)
{
	state->pfn += state->compound_nr;
	if (state->end_pfn <= state->pfn)
		return NULL;
	state->head = pfn_to_page(state->pfn);
	state->compound_nr = compound_nr(page);
	return state->head;
}

#define for_each_page_in_pt_entry(state, page, pfn, entry_size)                \
	for (page = __pt_start_iter(state, page, pfn, entry_size); page;       \
	     page = __pt_next_page(&state))

static bool remove_pages_from_page_table(struct vm_area_struct *vma,
					 struct page *page, unsigned long pfn,
					 unsigned int entry_size, bool is_dirty,
					 bool is_young)
{
	struct iter_state state;

	for_each_page_in_pt_entry(&state, page, pfn, entry_size)
		remove_page_from_page_table(vma, page, is_dirty, is_young);
}


Jason
