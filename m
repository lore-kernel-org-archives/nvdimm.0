Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2735672
	for <nvdimm@lists.linux.dev>; Wed, 29 Sep 2021 19:34:07 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id l13so3424303qtv.3
        for <nvdimm@lists.linux.dev>; Wed, 29 Sep 2021 12:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YeRhNJ7jlY3oUozrJZP1T+QUmec+ncw55w2AGtphODI=;
        b=WIEYwcinYNjedpVCgwyiHFNyRVj+yNiqCmyujbt4xu70fiFBFXhRiD8KkC3Y/hAxHt
         xt60J6WG9Heyt1nf27SZQMkUfJv5+WCN9YXZEaJL39AFEx5mG/hCCWHP2sVtLfoib6/Q
         120c3B1DmhrMPsjsZ1ajQi8p897EWxNx8yjIWx5ySpTIg2Y9e5yLxQOalgCa/JlbQL9p
         DQH2bBAStB0pSRRjqynDg256re8kYFZenv9riLJNWRXM/v+HanWiuwIpa1GSSQxzDHq8
         zWULe76apd9GV/P9SlupYhzzWIE25AS0N0h63yYulIoiuxeRdVmueYjdDVlNKwNl6vu2
         +23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YeRhNJ7jlY3oUozrJZP1T+QUmec+ncw55w2AGtphODI=;
        b=L1O9eJCxw6sDJ5whAzUPKC5SkO5QtdWsMcngzpO6ZQlFCkDQVY+tFumlVvgy51phMW
         mBGa4JvtuskW4wNFWSJWS06tujsAIGKjUvp0oktptqVc/HkSl+vE5oEOQbcedl4fWjvP
         qtnKQTtj3U9jrWkU/yvfZm1tB3pcQ+pUKpURizc0APyTprsN9w+BTnFyEVoVD1+1LnSS
         38uow08gc/ENuwR/Kyyv6Zxv6/g8pByaG8LK7xbEwORMMCTno0UMyxeKjAkSs+YpaSbW
         8PHXgM3gZuEVvwSGnA/UCoDlj42jPEoJcLaDCIalajwePfWp8eHHu0RoGpD8BuiT2f7a
         E6TQ==
X-Gm-Message-State: AOAM532Qhi6SeKljOwPiPmrH/EnnWO4BUUVfECiJ96aqd5WOxWNdY6se
	rziFN+p+NswIKZbfS4lolUecIw==
X-Google-Smtp-Source: ABdhPJyPLnPnrW8O/Y248rZfGn927UBJEmhsFQuMX5UkUptbaNnvSEd9XSlEGuo3ZaVbqSWxhCJTBg==
X-Received: by 2002:a05:622a:1a86:: with SMTP id s6mr1957356qtc.43.1632944046995;
        Wed, 29 Sep 2021 12:34:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id 188sm402364qkm.21.2021.09.29.12.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 12:34:06 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mVfLB-007fLb-Ml; Wed, 29 Sep 2021 16:34:05 -0300
Date: Wed, 29 Sep 2021 16:34:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joao Martins <joao.m.martins@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>
Cc: linux-mm@kvack.org, Vishal Verma <vishal.l.verma@intel.com>,
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
Message-ID: <20210929193405.GZ3544071@ziepe.ca>
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

> > If the get_dev_pagemap has to remain then it just means we have to
> > flush before changing pagemap pointers
> Right -- I don't think we should need it as that discussion on the other
> thread goes.
> 
> OTOH, using @pgmap might be useful to unblock gup-fast FOLL_LONGTERM
> for certain devmap types[0] (like MEMORY_DEVICE_GENERIC [device-dax]
> can support it but not MEMORY_DEVICE_FSDAX [fsdax]).

When looking at Logan's patches I think it is pretty clear to me that
page->pgmap must never be a dangling pointer if the caller has a
legitimate refcount on the page.

For instance the migrate and stuff all blindly calls
is_device_private_page() on the struct page expecting a valid
page->pgmap.

This also looks like it is happening, ie

void __put_page(struct page *page)
{
	if (is_zone_device_page(page)) {
		put_dev_pagemap(page->pgmap);

Is indeed putting the pgmap ref back when the page becomes ungettable.

This properly happens when the page refcount goes to zero and so it
should fully interlock with __page_cache_add_speculative():

	if (unlikely(!page_ref_add_unless(page, count, 0))) {

Thus, in gup.c, if we succeed at try_grab_compound_head() then
page->pgmap is a stable pointer with a valid refcount.

So, all the external pgmap stuff in gup.c is completely pointless.
try_grab_compound_head() provides us with an equivalent protection at
lower cost. Remember gup.c doesn't deref the pgmap at all.

Dan/Alistair/Felix do you see any hole in that argument??

So lets just delete it!

Jason
