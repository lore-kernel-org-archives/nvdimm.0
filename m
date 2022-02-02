Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2C22F21
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N6XNpq0FwsPZbJN5qSf1QDu//6lOqVafqdV/nNfMwPs=; b=P9ssVHu92H395D9dqlvAQrFmVu
	zKIl0C7d+Txpf8iBrIzXx/dzU+g5VJHkZwUxKJbZGY5U2XKYdyQUyUDMuWLOnolX+Z6pU5eQXPSK6
	InvGInZPS2GjMZ1G+YA7vRJ4RBc1XvocjEaZ9AqVN03zK304M7dY6pesian6URx3SQPbe3Tw/BC8I
	nuKX6723VVs1siOOtPIS7hpOEwZlKXO1WFqmm6MsOSXZvMBRbAiytZ7k+C/VPyXQO3MDDqS6Kkdk/
	XIVB5yi2oAhPk1Dhl6rhpm8c6bBF3hS27kmmdxwNG0+Rd1Qp7whtxegvQGan1C9Eo4W6AogSh3sKI
	9eEXGwAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFFvE-00FNjc-Ie; Wed, 02 Feb 2022 13:43:44 +0000
Date: Wed, 2 Feb 2022 05:43:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 5/7] pmem: add pmem_recovery_write() dax op
Message-ID: <YfqKkEB3gBsiuMZt@infradead.org>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
 <20220128213150.1333552-6-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128213150.1333552-6-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> @@ -257,10 +263,15 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>  __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>  		long nr_pages, void **kaddr, pfn_t *pfn)
>  {
> +	bool bad_pmem;
> +	bool do_recovery = false;
>  	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>  
> -	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> -					PFN_PHYS(nr_pages))))
> +	bad_pmem = is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> +				PFN_PHYS(nr_pages));
> +	if (bad_pmem && kaddr)
> +		do_recovery = dax_recovery_started(pmem->dax_dev, kaddr);
> +	if (bad_pmem && !do_recovery)
>  		return -EIO;

I find the passing of the recovery flag through the address very
cumbersome.  I remember there was some kind of discussion, but this looks
pretty ugly.

Also no need for the bad_pmem variable:

	if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, PFN_PHYS(nr_pages)) &&
	    (!kaddr | !dax_recovery_started(pmem->dax_dev, kaddr)))
		return -EIO;

Also:  the !kaddr check could go into dax_recovery_started.  That way
even if we stick with the overloading kaddr could also be used just for
the flag if needed.
