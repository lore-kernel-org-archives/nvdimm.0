Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB362A31
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 08:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uJdzlcEvij5Ft5CrLtuSMWt2NhA+02RXJxJray9JMj4=; b=M9YAGf4DfLFxhrF5jVExSCvkEh
	F5kzgwhWOl5Rhw1rx8z0Q1Tk614exWnNSewldl9jMIQzc5LkF+IK4YWl5o1M8da8g6a3+uEReKaod
	r5/OvpYjZUkLj6pqAIS8MdtWHq813xsfM01oCqrQ8Lkh4hInX2nfBYj87F9y1bQ/Zbe+Og8lYPy2Z
	ticSqIplcnJBoCCPg7jSYPfZ2qc9u0dQe5qoOxTYE9ugxK8ywSK6Uzrp7EzxHPM9d9cr0wR9Q5BBL
	R0/JmZJihfa3SxFUqAIfCSdBIoXY7cR0rP8Ds0Q9z0xu/nq6HUZDFVO5qbbMwetDdyls+5ZhfyYPU
	/y5sUiig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nWaGF-00AVAX-ND; Tue, 22 Mar 2022 08:53:03 +0000
Date: Tue, 22 Mar 2022 01:53:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 5/6] pmem: refactor pmem_clear_poison()
Message-ID: <YjmOb0dSY9GG/Q6r@infradead.org>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-6-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220319062833.3136528-6-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -static void hwpoison_clear(struct pmem_device *pmem,
> -		phys_addr_t phys, unsigned int len)
> +static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
>  {
> +	return pmem->phys_addr + offset;
> +}
> +
> +static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
> +{
> +	return (offset - pmem->data_offset) / 512;
> +}
> +
> +static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
> +{
> +	return sector * 512 + pmem->data_offset;
> +}

The multiplicate / divison using 512 could use shifts using
SECTOR_SHIFT.

> +
> +static void clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
> +		unsigned int len)

> +static void clear_bb(struct pmem_device *pmem, sector_t sector, long blks)

All these functions lack a pmem_ prefix.

> +static blk_status_t __pmem_clear_poison(struct pmem_device *pmem,
> +		phys_addr_t offset, unsigned int len,
> +		unsigned int *blks)
> +{
> +	phys_addr_t phys = to_phys(pmem, offset);
>  	long cleared;
> +	blk_status_t rc;
>  
> +	cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);
> +	*blks = cleared / 512;
> +	rc = (cleared < len) ? BLK_STS_IOERR : BLK_STS_OK;
> +	if (cleared <= 0 || *blks == 0)
> +		return rc;

This look odd.  I think just returing the cleared byte value would
make much more sense:

static long __pmem_clear_poison(struct pmem_device *pmem,
		phys_addr_t offset, unsigned int len)
{
	long cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);

	if (cleared > 0) {
		clear_hwpoison(pmem, offset, cleared);
		arch_invalidate_pmem(pmem->virt_addr + offset, len);
	}

	return cleared;
}
