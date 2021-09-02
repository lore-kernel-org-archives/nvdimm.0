Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09853FC1
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 07:27:23 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id D973368B05; Thu,  2 Sep 2021 09:27:19 +0200 (CEST)
Date: Thu, 2 Sep 2021 09:27:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
	Ritesh Harjani <riteshh@linux.ibm.com>
Subject: Re: [PATCH v8 3/7] fsdax: Replace mmap entry in case of CoW
Message-ID: <20210902072719.GB13867@lst.de>
References: <20210829122517.1648171-1-ruansy.fnst@fujitsu.com> <20210829122517.1648171-4-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210829122517.1648171-4-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Aug 29, 2021 at 08:25:13PM +0800, Shiyang Ruan wrote:
> We replace the existing entry to the newly allocated one in case of CoW.
> Also, we mark the entry as PAGECACHE_TAG_TOWRITE so writeback marks this
> entry as writeprotected.  This helps us snapshots so new write
> pagefaults after snapshots trigger a CoW.

Nit: s/We r/R/ above.

> + * MAP_SYNC on a dax mapping guarantees dirty metadata is
> + * flushed on write-faults (non-cow), but not read-faults.
> + */
> +static bool dax_fault_is_synchronous(const struct iomap_iter *iter,
> +		struct vm_area_struct *vma)
> +{
> +	return (iter->flags & IOMAP_WRITE) && (vma->vm_flags & VM_SYNC)
> +		&& (iter->iomap.flags & IOMAP_F_DIRTY);
> +}
> +
> +static bool dax_fault_is_cow(const struct iomap_iter *iter)
> +{
> +	return (iter->flags & IOMAP_WRITE)
> +		&& (iter->iomap.flags & IOMAP_F_SHARED);
> +}

The && goes last on the first line, not at the beginning of the second.
