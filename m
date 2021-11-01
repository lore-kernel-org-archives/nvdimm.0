Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9045C2C86
	for <nvdimm@lists.linux.dev>; Mon,  1 Nov 2021 21:50:58 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE86B60EE3;
	Mon,  1 Nov 2021 21:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1635803458;
	bh=LjQ+jv2pb1lXnkT/NVcDdURxhVA9PsUtmE/QNpSNqg4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=N6FQT6aVm4GMhI9nzrGsysH7nvafcXJaJ68z06dNDXo9ZYtqm7kQwr7/6hgLvth97
	 B2cDyAu7xEEWRlY/E5USrwrSW/MbV6+60CBtUR1Dz0KV3yE9KjvupadXKDPiUVb87K
	 r/lTvbZ5bvD8SEQ6/nfn/oEN26qQNqCie9q2OvJFP6oNHNjTCLkDjRNEbP32uibVRp
	 6RhNQUpmKoKnZoplursOROiGTZSORTMFfE6/q+jOHbTVZf2QYiba5GV/5YWankapHg
	 tDNDo9Wxgm3UiilWVJddCweCqsEjdS+Lh+ZqjoRR209vsLWIdGqBPJKFJpOUSWuGlJ
	 VYbSRfM/eKqig==
Date: Mon, 1 Nov 2021 16:50:56 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: dan.j.williams@intel.com, nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] memremap: remove support for external pgmap refcounts
Message-ID: <20211101215056.GA552989@bhelgaas>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028151017.50234-1-hch@lst.de>

On Thu, Oct 28, 2021 at 05:10:17PM +0200, Christoph Hellwig wrote:
> No driver is left using the external pgmap refcount, so remove the
> code to support it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 50cdde3e9a8b2..316fd2f44df45 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -219,7 +219,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
>  	error = gen_pool_add_owner(p2pdma->pool, (unsigned long)addr,
>  			pci_bus_address(pdev, bar) + offset,
>  			range_len(&pgmap->range), dev_to_node(&pdev->dev),
> -			pgmap->ref);
> +			&pgmap->ref);

I assume the change above is safe because of the one below.

>  struct dev_pagemap {
>  	struct vmem_altmap altmap;
> -	struct percpu_ref *ref;
> -	struct percpu_ref internal_ref;
> +	struct percpu_ref ref;
