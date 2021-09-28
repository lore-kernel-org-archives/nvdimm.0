Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572F129CA
	for <nvdimm@lists.linux.dev>; Tue, 28 Sep 2021 18:01:53 +0000 (UTC)
Received: by mail-qk1-f172.google.com with SMTP id i132so41764178qke.1
        for <nvdimm@lists.linux.dev>; Tue, 28 Sep 2021 11:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hbv2nrTZWWGTP0zetuxX8JZfSvkOTIqxNDWscf8lqjM=;
        b=k4yeqVkRBZLOz8RVqZfB/X5go9d5P08x7DAbdDnxauKP3w8Ly9MWhcIHzduBQOXIv6
         5T5FpLdhoYxRIYJWBMLnAJ7jOYyO3vy177E9aPa3GqGMao6G1SAoEYk2fyt1p3IWPBuw
         K1Anqfuu7NYgolRTn0AfvVNGspfbs0NRJ1sKcbA2uCFLvg5fZxKmQPdfUDYS23yyyQLB
         aLowg6jW72cG3PRtSZ6WOi2yuNJGa4STjmwpcX5B0gvtmcRhLASp6KxUB1QEMamXP1nY
         oA4t3c6XPhHyNRDddoMK+c2IK+nwFlv8bVPLD9Q944WafOhKBZ3mKMpllZ11Y9sQe7tM
         HxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hbv2nrTZWWGTP0zetuxX8JZfSvkOTIqxNDWscf8lqjM=;
        b=i5mTfBtkRHnr4CftelZX6Ly3eS5kDp4tpC29X416ZlBVw8HXHvdSG5Gxn89pye6evC
         vOWojvRgygbyf6FpE5az+vvhjhp0vjhuKxSD5hzLKg+WETAarBSbq+vkIdZ9mZNGqJ+W
         bPjLla69qrcLPQMxlwFrX08k5BJXlDWymk9CP94aHwxUlOc36uqewx8319lfsT3HX6Vj
         FRfqZMM5m9nGyhQYkZqlAX7Ha1lcArA7yGn36gFvAaANAh/f5goBrI+uoPT6sI/GXNV+
         couaMO1cYDMKmWnZCDwjy/zv+WRQPTYyERziqMYnSESyny8d0dmcLBGOfzqgLiPEWMV3
         7wAg==
X-Gm-Message-State: AOAM532wBKTnhn7enfbkVmlf96hBVvIim2KTERyy3B4uOJTNXXfZh70B
	BMljCmcdm+ySMqFr7d1hwNXZIw==
X-Google-Smtp-Source: ABdhPJw8PoqtCM9jEu0HEkGUTPOuB+K045ZQ+xnwIr++i1ps2Ma+Gi571Hezhn6PyiIq87siDpO+yw==
X-Received: by 2002:ae9:eb8b:: with SMTP id b133mr1406067qkg.188.1632852112225;
        Tue, 28 Sep 2021 11:01:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id q184sm15663797qkd.35.2021.09.28.11.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 11:01:51 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mVHQM-007Eis-Ps; Tue, 28 Sep 2021 15:01:50 -0300
Date: Tue, 28 Sep 2021 15:01:50 -0300
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
Message-ID: <20210928180150.GI3544071@ziepe.ca>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
 <20210827162552.GK1200268@ziepe.ca>
 <da90638d-d97f-bacb-f0fa-01f5fd9f2504@oracle.com>
 <20210830130741.GO1200268@ziepe.ca>
 <cda6d8fb-bd48-a3de-9d4e-96e4a43ebe58@oracle.com>
 <20210831170526.GP1200268@ziepe.ca>
 <8c23586a-eb3b-11a6-e72a-dcc3faad4e96@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c23586a-eb3b-11a6-e72a-dcc3faad4e96@oracle.com>

On Thu, Sep 23, 2021 at 05:51:04PM +0100, Joao Martins wrote:
> On 8/31/21 6:05 PM, Jason Gunthorpe wrote:

> >> Switching to similar iteration logic to unpin would look something like
> >> this (still untested):
> >>
> >>         for_each_compound_range(index, &page, npages, head, refs) {
> >>                 pgmap = get_dev_pagemap(pfn + *nr, pgmap);
> > 
> > I recall talking to DanW about this and we agreed it was unnecessary
> > here to hold the pgmap and should be deleted.
> 
> Yeap, I remember that conversation[0]. It was a long time ago, and I am
> not sure what progress was made there since the last posting? Dan, any
> thoughts there?
> 
> [0]
> https://lore.kernel.org/linux-mm/161604050866.1463742.7759521510383551055.stgit@dwillia2-desk3.amr.corp.intel.com/

I would really like to see that finished :\

> So ... if pgmap accounting was removed from gup-fast then this patch
> would be a lot simpler and we could perhaps just fallback to the regular
> hugepage case (THP, HugeTLB) like your suggestion at the top. See at the
> end below scissors mark as the ballpark of changes.
> 
> So far my options seem to be: 1) this patch which leverages the existing
> iteration logic or 2) switching to for_each_compound_range() -- see my previous
> reply 3) waiting for Dan to remove @pgmap accounting in gup-fast and use
> something similar to below scissors mark.
> 
> What do you think would be the best course of action?

I still think the basic algorithm should be to accumulate physicaly
contiguous addresses when walking the page table and then flush them
back to struct pages once we can't accumulate any more.

That works for both the walkers and all the page types?

If the get_dev_pagemap has to remain then it just means we have to
flush before changing pagemap pointers

Jason
