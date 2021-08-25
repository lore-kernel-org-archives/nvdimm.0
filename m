Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264B03FC2
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 19:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vnK5hFrC8B8FFVr6MsO2gBo3ffuSh4w2DLgihKVUK6M=; b=cmBRpgWdWjBIMPIsvZrzbol9Hw
	yO76NUo2Jd8uNlz+kXHIw45BDSGZigykP7lPwGDwXH2zO0IdX++vbdCKGa2A/KcQmthtZCSeBcDQJ
	5F2Z/uCa0cXVH461xd7dwrhJ8NhEsLIeoxXI3KTbDNYsXhCEbKb3JTa5leBFFgq+dwEnt3RnWpT+p
	qH8irJsTwDEssqCfjg5xqf5chSaiZ65QoB+qDDtlYxe+Y86IhjaJ2B8HHEr8Gd2tSUfehvtCi5Wye
	M4UnPFiO2GqoJSj/LXl26cUJSMWFkG2ICuRuMIyYl1Fzg+VEho/h/q2GsT6Ke8d3ykf+mPkefceWo
	qkWGbKzg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mIyNC-00Cb3F-Hj; Wed, 25 Aug 2021 19:15:52 +0000
Date: Wed, 25 Aug 2021 20:15:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Linux MM <linux-mm@kvack.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 13/14] mm/gup: grab head page refcount once for group
 of subpages
Message-ID: <YSaW3kkcwATVtbVv@casper.infradead.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-14-joao.m.martins@oracle.com>
 <CAPcyv4i_BbQn6WkgeNq5kLeQcMu=w4GBdrBZ=YbuYnGC5-Dbiw@mail.gmail.com>
 <861f03ee-f8c8-cc89-3fc2-884c062fea11@oracle.com>
 <CAPcyv4gkxysWT60P_A+Q18K=Zc9i5P6u69tD5g9_aLV=TW1gpA@mail.gmail.com>
 <21939df3-9376-25f2-bf94-acb55ef49307@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21939df3-9376-25f2-bf94-acb55ef49307@oracle.com>

On Wed, Aug 25, 2021 at 08:10:39PM +0100, Joao Martins wrote:
> @@ -2273,8 +2273,7 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>                 refs = record_subpages(page, addr, next, pages + *nr);
> 
>                 SetPageReferenced(head);
> -               pinned_head = try_grab_compound_head(head, refs, flags);
> -               if (unlikely(!pinned_head)) {
> +               if (unlikely(!try_grab_compound_head(head, refs, flags))) {
>                         if (PageCompound(head))

BTW, you can just check PageHead(head).  We know it can't be PageTail ...

