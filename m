Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DC94C7B
	for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 16:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0CBC433D2;
	Wed, 25 Jan 2023 16:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674664117;
	bh=EFtrI+qkMXtuqv2/AauSnQYLbjXALjHF58RitU958dY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H66lRNm1bH8ABZeGBLaQk11C4esX8FmvjWLeRmGDWDbm2Mg3g3NuDCyyaTpayLpwC
	 4sBV7g/avgr7fLS5n+EjEM+SjaS0g0pmJArbUpnbEdmDHtJHsC+tjmvcz4bjAVRq4+
	 4a5JyRYcGcyao7yE9sc2wYYkpapmvdsB/FlaoCRTDeIxsc6Srlkqa/1X1BPzpGP/p5
	 iCX6c+D/PHkT9D4K10VHOEhDhQwW93Idm/oNezpjLANXPDWaC9lHCIqtYifhENXuQe
	 RLw1KyXCdcnCUZMS93kV2vX48UzFSeewNTORHXQLaDnVLdz6FDsLwB2D8Pgh/zESjh
	 9G6SmhI66fG8A==
Date: Wed, 25 Jan 2023 09:28:33 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/7] block: remove ->rw_page
Message-ID: <Y9FYsXgo9pVJ5weX@kbusch-mbp.dhcp.thefacebook.com>
References: <20230125133436.447864-1-hch@lst.de>
 <20230125133436.447864-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125133436.447864-8-hch@lst.de>

On Wed, Jan 25, 2023 at 02:34:36PM +0100, Christoph Hellwig wrote:
> @@ -363,8 +384,10 @@ void __swap_writepage(struct page *page, struct writeback_control *wbc)
>  	 */
>  	if (data_race(sis->flags & SWP_FS_OPS))
>  		swap_writepage_fs(page, wbc);
> +	else if (sis->flags & SWP_SYNCHRONOUS_IO)
> +		swap_writepage_bdev_sync(page, wbc, sis);

For an additional cleanup, it looks okay to remove the SWP_SYNCHRONOUS_IO flag
entirely and just check bdev_synchronous(sis->bdev)) directly instead.
