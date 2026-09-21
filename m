Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A865749B458;
	Mon, 21 Sep 2026 13:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996184; cv=none; b=mSAjecBDVWHSG2ItTV92KkRN9/T2B7Lq5Srgtiukmkbz+CzaShqCgBcoRhmE0yFkTw+zS+P6lbkNuX+X13cc/OqCey0knXnqrzE5j3Gdl17+RIzhodWBTQJQn//Vg+MK0NsOWrIJsBq/qSvL+LIWUdFo5IiroS3wO2r195Q0RBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996184; c=relaxed/simple;
	bh=F559ocMlket3wrii61B/hX+vnT8hvF0tI9aaDMoyuvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b9eXfFyq6PrSUg/MlfflcIuM2IlhIpDHiLjDoYZrEobdMpnx7xonU0+ZXMjfXkzVqxusCRd71RggrO/B+5CCJ9n6b8ase2XYOdFvFz/Vj3wq500x7Eavb17vyB/FKkiVc5LfrAB6T0UXZ1QNIkDRaKXYRyS5ZvIrX3feBRxnomo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e13sQNVB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e13sQNVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B921F0089A;
	Mon, 21 Sep 2026 13:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789996183;
	bh=7BEi9bnupk2tGkEwUZeOZfddlvvx1uRhC2R2hXlT/kw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e13sQNVBQ80LOFKn6Ix6ZyO14nn7uPNK5BQjitRo7n3ax1ueKz8MjZiX0bZgbrBvP
	 fG4Xp5Ni9rypjZmCg7K7CGkosry3KmKqDILW1r97oHAD49pakCTY7H8Gwr3ekRb8pj
	 rT9KFIaqi44ROkVlFjypQNYXkpe9f/liIPbG/ks3gnOGLQ5oMSp+jkNNOGaAPJTRXH
	 M+HRGr9xRrl47i3MBwIGAwc9nhhyNvfwQkWGujxMsJIOiBSasO862KfnqxhXQUCjUe
	 exKEzyygUfkJLu/WDJms7Lh7z4TZHd5PsREH4VkR81sfgud3+g1MKCrZH5udQlUbko
	 jcju+hpfy8+iw==
Date: Mon, 21 Sep 2026 15:09:35 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>, Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
Message-ID: <arEsjy0QwLekLVbf@localhost.localdomain>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-4-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903122128.12264-4-songmuchun@bytedance.com>

On Thu, Sep 03, 2026 at 08:21:26PM +0800, Muchun Song wrote:
> FS-DAX registers persistent-memory ranges as ZONE_DEVICE memory, and the
> kernel normally allocates and initializes vmemmap storage for every
> advertised PFN up front. Sparse pmem images and workloads that only use the
> DAX direct-access path may never need writable per-PFN state for most of
> that range, but still pay the memory and initialization cost.
> 
> Add an opt-in dev_pagemap mode that populates FS-DAX vmemmap PTEs from a
> shared read-only metadata page. The shared page is initialized with the
> common ZONE_DEVICE and dev_pagemap state, so every PFN still has a valid
> struct page representation while private metadata allocation is deferred.
> 
> This relies on sizeof(struct page) being a power of two, so each vmemmap
> page contains a naturally aligned and repeatable set of struct page slots.
> It also requires architecture support for runtime vmemmap remapping,
> because shared mappings must be replaced with private writable pages before
> a PFN can enter userspace mappings.
> 
> The initial implementation is deliberately limited to a single
> memory-block-aligned range. That is not a fundamental requirement, but keeps
> the registration and teardown paths simple; support for multiple ranges or
> less strict alignment can be added later.
> 
> Provide vmemmap_materialize_page() to replace shared mappings in the
> requested metadata range with private writable copies. A later patch will
> call it from the FS-DAX fault path.
> 
> No caller enables the mode yet.
...  
> +static int pgmap_vmemmap_shared_page_alloc(struct dev_pagemap *pgmap, int nid)
> +{
> +	const struct range *range = &pgmap->range;
> +
> +	if (!is_power_of_2(sizeof(struct page)) ||
> +	    !IS_ENABLED(CONFIG_ARCH_SUPPORTS_VMEMMAP_REMAP) ||
> +	    !(pgmap->flags & PGMAP_VMEMMAP_OPTIMIZATION))
> +		return 0;
> +
> +	if (pgmap->nr_range != 1 ||
> +	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
> +		return 0;
> +
> +	pgmap->vmemmap_shared_page = alloc_pages_node(nid, GFP_KERNEL, 0);
> +
> +	return pgmap->vmemmap_shared_page ? 0 : -ENOMEM;

I yet have to look into this with more detail, but this caught my eye.
Should not this be a best-efford mode optimization? So, if we were
unable to allocate the page, could not we treat this as a normal "cannot
be optimized, follow by-default procedure" ?



-- 
Oscar Salvador
SUSE Labs
