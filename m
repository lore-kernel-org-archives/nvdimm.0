Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7FC10EC
	for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 07:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=21mNC1xMcb143QvqEDow7m5pUs/f8C5BnuVHx811IUY=; b=OyrX/F9/CkEzV2AJPytb9wOZe/
	xVlVjM4Mv9OnTKyiF6cpVh+Lwn0P7HwhNa3rYDlLij84mntPBmNs9LvVI7aROjv7wQu6m79nP2LRi
	I9jTbJMDqly7aZfSfm7/ONz0mxcoBk3vPSbBZ0sdEQEmXpJTeodLum0KIib5NP53Lp+b6ljFbJPzX
	E18EpZvaJnzlFZwIvexozxCxHxwIIQ4ncxaopxsiiYs38YUzYCuMVa9SUmCWxzjK0yhdecVOv7zFM
	N7FcPgI4h26a1A3ZDKlLYdg6O0Cp67bEI/Jyc80MlsDU+Wi8R0fvARRVPQjbhDI4e/niO8gq0/08Z
	9jWhlbFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ndo7t-0075f9-59; Mon, 11 Apr 2022 07:06:17 +0000
Date: Mon, 11 Apr 2022 00:06:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [RFC PATCH] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Message-ID: <YlPTaexutZrus1kQ@infradead.org>
References: <20220410171623.3788004-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410171623.3788004-1-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 11, 2022 at 01:16:23AM +0800, Shiyang Ruan wrote:
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index bd502957cfdf..72d9e69aea98 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -359,7 +359,6 @@ static void pmem_release_disk(void *__pmem)
>  	struct pmem_device *pmem = __pmem;
>  
>  	dax_remove_host(pmem->disk);
> -	kill_dax(pmem->dax_dev);
>  	put_dax(pmem->dax_dev);
>  	del_gendisk(pmem->disk);
>  
> @@ -597,6 +596,8 @@ static void nd_pmem_remove(struct device *dev)
>  		pmem->bb_state = NULL;
>  	}
>  	nvdimm_flush(to_nd_region(dev->parent), NULL);
> +
> +	kill_dax(pmem->dax_dev);

I think the put_dax will have to move as well.

This part should probably also be a separate, well-documented
cleanup patch.
