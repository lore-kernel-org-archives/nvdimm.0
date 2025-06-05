Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F740195;
	Thu,  5 Jun 2025 07:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749109605; cv=none; b=ePqJoJPZM2i89HMS0eR1aMGi4KTpWOVzxnIbgT0FvKloULM9SuAlp00qerxOmnX/6g+R9bGpYMn0nB5mFgW8cp/5lV3F/oaYPkvGUenVAb0AXHyowc7nKByxhkETIDLPnmeRtm0t3BepFEnKah3xuplW1Xw6bEAtCDZ7188Aya8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749109605; c=relaxed/simple;
	bh=DJazRaHZHktAWunilCrO7KAiCMUmHwlC2pVytbSPj6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qalwFLSidJcj9vgXiweJHKAWagyZBqjz+3Qkas6/LOaoHyP04XgZkHKNFQ3tVqxQG2TcJx6CY8GU8Jmhs5d6hUDJaFnbFqFGcXMKa99+SexdYOXuLD9hJQSlD97KZvLosPwEPNTXFBRZfj/1TWa9lMw/rR9FNavYp3wI/UkcTDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7FA0568AA6; Thu,  5 Jun 2025 09:46:37 +0200 (CEST)
Date: Thu, 5 Jun 2025 09:46:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	gerald.schaefer@linux.ibm.com, jgg@ziepe.ca, willy@infradead.org,
	david@redhat.com, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	jhubbard@nvidia.com, hch@lst.de, zhang.lyra@gmail.com,
	debug@rivosinc.com, bjorn@kernel.org, balbirs@nvidia.com,
	lorenzo.stoakes@oracle.com, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-cxl@vger.kernel.org,
	dri-devel@lists.freedesktop.org, John@groves.net
Subject: Re: [PATCH 03/12] mm/pagewalk: Skip dax pages in pagewalk
Message-ID: <20250605074637.GA7727@lst.de>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com> <1799c6772825e1401e7ccad81a10646118201953.1748500293.git-series.apopple@nvidia.com> <6840f9ed3785a_249110084@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6840f9ed3785a_249110084@dwillia2-xfh.jf.intel.com.notmuch>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 04, 2025 at 06:59:09PM -0700, Dan Williams wrote:
> +/* return normal pages backed by the page allocator */
> +static inline struct page *vm_normal_gfp_pmd(struct vm_area_struct *vma,
> +					     unsigned long addr, pmd_t pmd)
> +{
> +	struct page *page = vm_normal_page_pmd(vma, addr, pmd);
> +
> +	if (!is_devdax_page(page) && !is_fsdax_page(page))
> +		return page;
> +	return NULL;

If you go for this make it more straight forward by having the
normal path in the main flow:

	if (is_devdax_page(page) || is_fsdax_page(page))
		return NULL;
	return page;

> +static inline struct page *vm_normal_gfp_pte(struct vm_area_struct *vma,
> +					     unsigned long addr, pte_t pte)
> +{
> +	struct page *page = vm_normal_page(vma, addr, pte);
> +
> +	if (!is_devdax_page(page) && !is_fsdax_page(page))
> +		return page;
> +	return NULL;

Same here.

