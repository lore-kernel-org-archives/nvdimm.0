Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E532C80
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 18:05:07 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7811E61156;
	Thu, 14 Oct 2021 18:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1634234707;
	bh=Rqf9bmS83xeh3gCkrvLoUtzShhDQVtdQ2GWkdDACjQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K2OxDOj4FznqZrubwOPyMGzMHqGX17L7kfeSgXLp/+KyODPMHxpsiFkoPrIKO2qDL
	 mZYZQEuF6syddsDF3heZBQ7jwZIz8dmD0WVRQ2Av5DhkmdY0+22qCGtv809c7Ze8Er
	 WTglLurLQf0WfhK3SZl0nyUuEl+ZaZnB7GVzPx1VXQHwbugLIbDNVp9oMwsNMpGcEt
	 PWY9ml3cpZ2bxt/JUKxCBSYvpYUtpcvyATECCVRF96dhMBlyjygp5xMOkK3kIAxt6C
	 YlXwsKsKMgYGLjV15y4itRVFcpz0qtI2oFKPucHsjl2nH6lbJyZqWP/eJRwfb8lJ7e
	 EA8BlYXkO5PFg==
Date: Thu, 14 Oct 2021 11:05:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	david@fromorbit.com, hch@infradead.org, jane.chu@oracle.com
Subject: Re: [PATCH v7 4/8] pagemap,pmem: Introduce ->memory_failure()
Message-ID: <20211014180507.GG24307@magnolia>
References: <20210924130959.2695749-1-ruansy.fnst@fujitsu.com>
 <20210924130959.2695749-5-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924130959.2695749-5-ruansy.fnst@fujitsu.com>

On Fri, Sep 24, 2021 at 09:09:55PM +0800, Shiyang Ruan wrote:
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the filesystem in which
> the corrupted page located in.
> 
> With dax_holder notify support, we are able to notify the memory failure
> from pmem driver to upper layers.  If there is something not support in
> the notify routine, memory_failure will fall back to the generic hanlder.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  drivers/nvdimm/pmem.c    | 11 +++++++++++
>  include/linux/memremap.h |  9 +++++++++
>  mm/memory-failure.c      | 14 ++++++++++++++
>  3 files changed, 34 insertions(+)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 72de88ff0d30..0dfafad8fcc5 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -362,9 +362,20 @@ static void pmem_release_disk(void *__pmem)
>  	del_gendisk(pmem->disk);
>  }
>  
> +static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
> +		unsigned long pfn, size_t size, int flags)
> +{
> +	struct pmem_device *pmem =
> +			container_of(pgmap, struct pmem_device, pgmap);
> +	loff_t offset = PFN_PHYS(pfn) - pmem->phys_addr - pmem->data_offset;
> +
> +	return dax_holder_notify_failure(pmem->dax_dev, offset, size, flags);
> +}
> +
>  static const struct dev_pagemap_ops fsdax_pagemap_ops = {
>  	.kill			= pmem_pagemap_kill,
>  	.cleanup		= pmem_pagemap_cleanup,
> +	.memory_failure		= pmem_pagemap_memory_failure,
>  };
>  
>  static int pmem_attach_disk(struct device *dev,
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index c0e9d35889e8..36d47bacd46d 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -87,6 +87,15 @@ struct dev_pagemap_ops {
>  	 * the page back to a CPU accessible page.
>  	 */
>  	vm_fault_t (*migrate_to_ram)(struct vm_fault *vmf);
> +
> +	/*
> +	 * Handle the memory failure happens on a range of pfns.  Notify the
> +	 * processes who are using these pfns, and try to recover the data on
> +	 * them if necessary.  The flag is finally passed to the recover
> +	 * function through the whole notify routine.
> +	 */
> +	int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
> +			      size_t size, int flags);
>  };
>  
>  #define PGMAP_ALTMAP_VALID	(1 << 0)
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 8ff9b52823c0..85eab206b68f 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1605,6 +1605,20 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
>  	if (!pgmap_pfn_valid(pgmap, pfn))
>  		goto out;
>  
> +	/*
> +	 * Call driver's implementation to handle the memory failure, otherwise
> +	 * fall back to generic handler.
> +	 */
> +	if (pgmap->ops->memory_failure) {
> +		rc = pgmap->ops->memory_failure(pgmap, pfn, PAGE_SIZE, flags);
> +		/*
> +		 * Fall back to generic handler too if operation is not
> +		 * supported inside the driver/device/filesystem.
> +		 */
> +		if (rc != EOPNOTSUPP)

-EOPNOTSUPP?  (negative errno)

--D

> +			goto out;
> +	}
> +
>  	rc = mf_generic_kill_procs(pfn, flags, pgmap);
>  out:
>  	/* drop pgmap ref acquired in caller */
> -- 
> 2.33.0
> 
> 
> 
