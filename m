Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866717F
	for <nvdimm@lists.linux.dev>; Mon, 22 Aug 2022 06:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HBBcM9A/awFTGNV6DJENggodsApSG3Yqfk+2KouRytw=; b=2njf6YzoOY74vKtpZpZ6F9ctF7
	ZN7kngU/R2cbNVb79v3SS1WbSehYORP54z1w/9AdtIqlVKeM1igPjVUu8UACXINb7lJJ1NeNARNe2
	X/MGBj60eb8jRcdRkf38ucSaka943Je/6nwC+890otwlDxhUumx32O367UCUv5ttn6J6VvjC7CwVm
	0xetAh0J5S0L7tbptmZ1s8mVzKv6YybnXLaSvik2rGNgdnRGirCxMUzCAEV1rSZF34sMRG4dJUZMr
	c2SUlO47+rcHOthZFim6I6352/gCiUe9koyOFOrCQjqQhyyaIa9gQBBeGhm+vg0F0BvzFEfS/U3Au
	9BgLXaQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oQ14a-005WRv-J5; Mon, 22 Aug 2022 06:38:08 +0000
Date: Sun, 21 Aug 2022 23:38:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-arch@vger.kernel.org, dan.j.williams@intel.com,
	peterz@infradead.org, mark.rutland@arm.com, dave.jiang@intel.com,
	Jonathan.Cameron@huawei.com, a.manzanares@samsung.com,
	bwidawsk@kernel.org, alison.schofield@intel.com,
	ira.weiny@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arch/cacheflush: Introduce flush_all_caches()
Message-ID: <YwMkUMiKf3ZyMDDF@infradead.org>
References: <20220819171024.1766857-1-dave@stgolabs.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819171024.1766857-1-dave@stgolabs.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 19, 2022 at 10:10:24AM -0700, Davidlohr Bueso wrote:
> index b192d917a6d0..ac4d4fd4e508 100644
> --- a/arch/x86/include/asm/cacheflush.h
> +++ b/arch/x86/include/asm/cacheflush.h
> @@ -10,4 +10,8 @@
>  
>  void clflush_cache_range(void *addr, unsigned int size);
>  
> +/* see comments in the stub version */
> +#define flush_all_caches() \
> +	do { wbinvd_on_all_cpus(); } while(0)

Yikes.  This is just a horrible, horrible name and placement for a bad
hack that should have no generic relevance.

Please fix up the naming to make it clear that this function is for a
very specific nvdimm use case, and move it to a nvdimm-specific header
file.
