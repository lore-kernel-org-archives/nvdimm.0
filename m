Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE44E68
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:34:06 +0000 (UTC)
Received: by mail-qv1-f45.google.com with SMTP id kl8so1978663qvb.3
        for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 07:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xrgHnzEuXdDQnDfAgVFJeYXWXU/wp4hergRrT9uknxk=;
        b=YS73mq9GAX47GV1Tsf0uXZhfamYp9oAAP4/sn6XnYKWBButpN58bewYuClCAhvbsx7
         2OilYsQd6++EVff4d/Uf80/g6t/mN4x4hY/UqapMnzQjyFaSTJPqPOt+0A1aKQ2VJD1o
         wdcx1pzuCLnDZfQJ5QcdYsgd61V31BgE3N1Wb68yNMYmRixtzHYfhxSSxYOfxDkwt706
         kNj5nV2Hpz2MgLGwRBolsQ8hj9VEy6/Vb6QUDIGPEM71390UqP6k/b3zPYQ8WboTiwjM
         rG/6yup165WRlvU6+1t5qSwEF/ZN8re/mxlvAbcX2CIU6genJ7KcSTrA0Sp9bxfLzz2H
         m16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xrgHnzEuXdDQnDfAgVFJeYXWXU/wp4hergRrT9uknxk=;
        b=v83pEo4pXjX72pKqecRVbj1If5bcVwVYdQxl+Aqa0gHWuxz3dDA6e3nPad22rSI7ZV
         eyPcnTJQmn+fzkjcBSzooQuVXrNFlxhGBS0f3POWlFdHQdlkUMPwKxTJqEaVDk07Rv0c
         Jum3dOKIPihmbRDdmkP4aJv5KikehKd0jRDZpLPhyrqqHVL7WlAYvcVhgHU4xMp3/GO/
         JGTWpdQ+UYxGQtie0wd0RWvjVlnRENYgCCvpbNELB+mu8iJ4vFCg1yfevEedeWJBkxkz
         YfcLX8325KglIplvudnrueziiHLyo8R/nJHKT27UeMOXKYD9fpsBDVIShhWGq9NTO23a
         K7zg==
X-Gm-Message-State: AOAM532NwaLvLvytX0GV4toqUxb1MLjfTUEhdNBQhLYI3G1lknvErJzh
	Y1EzuxLgDQiFVUkpIVNmoUGrRA==
X-Google-Smtp-Source: ABdhPJzPucpGQXurj467junIVP7ueDppunByZw5QMjrA4NaqFxle4jwuOw8Xm+N1RCQgaFjgpnjv7Q==
X-Received: by 2002:a05:6214:250d:: with SMTP id gf13mr15263616qvb.39.1636731245689;
        Fri, 12 Nov 2021 07:34:05 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id m68sm2815075qkb.105.2021.11.12.07.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:34:05 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mlYZ2-0096x0-4k; Fri, 12 Nov 2021 11:34:04 -0400
Date: Fri, 12 Nov 2021 11:34:04 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH v5 8/8] device-dax: compound devmap support
Message-ID: <20211112153404.GD876299@ziepe.ca>
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
 <20211112150824.11028-9-joao.m.martins@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112150824.11028-9-joao.m.martins@oracle.com>

On Fri, Nov 12, 2021 at 04:08:24PM +0100, Joao Martins wrote:

> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index a65c67ab5ee0..0c2ac97d397d 100644
> +++ b/drivers/dax/device.c
> @@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>  }
>  #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>  
> +static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
> +			     unsigned long fault_size,
> +			     struct address_space *f_mapping)
> +{
> +	unsigned long i;
> +	pgoff_t pgoff;
> +
> +	pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
> +
> +	for (i = 0; i < fault_size / PAGE_SIZE; i++) {
> +		struct page *page;
> +
> +		page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
> +		if (page->mapping)
> +			continue;
> +		page->mapping = f_mapping;
> +		page->index = pgoff + i;
> +	}
> +}
> +
> +static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
> +				 unsigned long fault_size,
> +				 struct address_space *f_mapping)
> +{
> +	struct page *head;
> +
> +	head = pfn_to_page(pfn_t_to_pfn(pfn));
> +	head = compound_head(head);
> +	if (head->mapping)
> +		return;
> +
> +	head->mapping = f_mapping;
> +	head->index = linear_page_index(vmf->vma,
> +			ALIGN(vmf->address, fault_size));
> +}

Should this stuff be setup before doing vmf_insert_pfn_XX?

In normal cases the page should be returned in the vmf and populated
to the page tables by the core code after all this is done. 

dax can't do that because of the refcount mess, but I would think the
basic ordering should be the same.

Jason
