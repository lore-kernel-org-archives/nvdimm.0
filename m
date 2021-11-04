Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE72C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=S8+GvGjJAqniHYjM2Wp5vjOitbiYfVXd5DEzzMgGQcs=; b=cl00Zy7gZSJ0I2s23pCGHt0Q6X
	Q8OT0LUd5SXoIe7fvuNwxZ+uR2NfFqjAr1lmqRjRY7MysVby4VZTVSub++9SMNi1mHMzSPsvTumjK
	fU4/TJZZ0aaOrVT0cuznAxYACaRH0wsXg84useAnwbW66Ut3sO+SzdI9uc1abVRpHzWnCz5iUodL8
	R+Jct1O4oQtdBIq3Es2RfNRKmwoA0aFBJaCvJKlSeyPKKba6vPk6u10I//qdSmC57tFPWyee9ZspH
	55psKuHOFabypdipvFDLwBxbjTuKFxruc/976HfLSlC0TIfzKMHCkmhEis0hsj0M802VPWZOPyuaa
	r08pc56w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1migxH-009jE8-C7; Thu, 04 Nov 2021 17:55:15 +0000
Date: Thu, 4 Nov 2021 10:55:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, viro@zeniv.linux.org.uk,
	willy@infradead.org, jack@suse.cz, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] libnvdimm/pmem: Provide pmem_dax_clear_poison for
 dax operation
Message-ID: <YYQegz3nPmbavQtK@infradead.org>
References: <20210914233132.3680546-1-jane.chu@oracle.com>
 <20210914233132.3680546-5-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914233132.3680546-5-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 14, 2021 at 05:31:32PM -0600, Jane Chu wrote:
> +static int pmem_dax_clear_poison(struct dax_device *dax_dev, pgoff_t pgoff,
> +					size_t nr_pages)
> +{
> +	unsigned int len = PFN_PHYS(nr_pages);
> +	sector_t sector = PFN_PHYS(pgoff) >> SECTOR_SHIFT;
> +	struct pmem_device *pmem = dax_get_private(dax_dev);
> +	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> +	blk_status_t ret;
> +
> +	if (!is_bad_pmem(&pmem->bb, sector, len))
> +		return 0;
> +
> +	ret = pmem_clear_poison(pmem, pmem_off, len);
> +	return (ret == BLK_STS_OK) ? 0 : -EIO;

No need for the braces here (and I'd prefer a good old if anyway).

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
