Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C233217E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 04:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646107876; x=1677643876;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qltwIc937Uu5ijgl7gEV8QkFm9r0IMF7rI6cefmccNg=;
  b=M6i/D8mcSzertUgoZedoD2ZstrLGCCTGRxA7uO6UBU7QgXeEd11RYcJs
   V6ee1QP1z99YCinMvfQDdQrE3XjHVBWIP5StE7FNhRTPyNgZoL34ltusE
   p8pMONrkYdSFzNcUXNVKSYb+kHTismkd+tQT6TYwEUl0537PIZu0YKfh0
   mq9eAXB9AkQoXgqfJOq7mHmoh5tcXhGoz6tugCfr/W9WSm5OCKP20v3HS
   mXElobuZiJOsCZFz6bfn673RQ+uEIWWhPnIBNkcHHhtf91+0R0OcqPb67
   EGpkMghHDT3nzGNy4KkydcReTvYd4HvD1a/mYFJZv/IFkUeihMA5V5D10
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="313771457"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="313771457"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:11:16 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="550543648"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:11:15 -0800
Date: Mon, 28 Feb 2022 20:11:15 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Denis Efremov <efremov@linux.com>, Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 10/10] floppy: use memcpy_{to,from}_bvec
Message-ID: <Yh2c41kEWmmGgWLG@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-11-hch@lst.de>

On Tue, Feb 22, 2022 at 04:51:56PM +0100, Christoph Hellwig wrote:
> Use the helpers instead of open coding them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/block/floppy.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 19c2d0327e157..8c647532e3ce9 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -2485,11 +2485,9 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
>  		}
>  
>  		if (CT(raw_cmd->cmd[COMMAND]) == FD_READ)
> -			memcpy_to_page(bv.bv_page, bv.bv_offset, dma_buffer,
> -				       size);
> +			memcpy_to_bvec(&bv, dma_buffer);
>  		else
> -			memcpy_from_page(dma_buffer, bv.bv_page, bv.bv_offset,
> -					 size);
> +			memcpy_from_bvec(dma_buffer, &bv);
>  
>  		remaining -= size;
>  		dma_buffer += size;
> -- 
> 2.30.2
> 
> 
