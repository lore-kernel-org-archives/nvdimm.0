Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF76D7A
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 02:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646100766; x=1677636766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FHnCsOMAMVBswmIQalbSrppghnzz3akbTDtT8A36Yxg=;
  b=bMTSdt1JNoYqbu4hV9MiOxj6zBlV745sFESsNI1dL7DwAxNMr2H+/3K8
   daVXASfafQtLZRutlLCdUdEakIrQVmQM5rDPDywZKTeT6C7tQ1Nq//ulm
   w4tQ7jOdyFjHRDutU78SoN8yIXyH+PDt0JjOBPAuxTe1lx1jbW4/qKQHg
   HaAhXRbuLCZLkfxAVJiie9gujgBOrwL3jF4UsPQd96LDQ14+f16YMplCq
   BTieRaFT2qeeys0Rsc8zTX2Pq6hzLqj/fMKDUizQd0IbaJ/+t32f05hWD
   WMCqQxLyPbMoGueyX6R+C3hC2puyzntyBL7U7iyd4thy2tcQ9SyafyKrR
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="252963985"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="252963985"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:12:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="629855449"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 18:12:45 -0800
Date: Mon, 28 Feb 2022 18:12:45 -0800
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
Subject: Re: [PATCH 04/10] zram: use memcpy_from_bvec in zram_bvec_write
Message-ID: <Yh2BHT4xXBJac987@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-5-hch@lst.de>

On Tue, Feb 22, 2022 at 04:51:50PM +0100, Christoph Hellwig wrote:
> Use memcpy_from_bvec instead of open coding the logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Same comment regarding the dst map.  Does it need to be atomic?

Regardless,
Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/block/zram/zram_drv.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 14becdf2815df..e9474b02012de 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1465,7 +1465,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
>  {
>  	int ret;
>  	struct page *page = NULL;
> -	void *src;
>  	struct bio_vec vec;
>  
>  	vec = *bvec;
> @@ -1483,11 +1482,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
>  		if (ret)
>  			goto out;
>  
> -		src = kmap_atomic(bvec->bv_page);
>  		dst = kmap_atomic(page);
> -		memcpy(dst + offset, src + bvec->bv_offset, bvec->bv_len);
> +		memcpy_from_bvec(dst + offset, bvec);
>  		kunmap_atomic(dst);
> -		kunmap_atomic(src);
>  
>  		vec.bv_page = page;
>  		vec.bv_len = PAGE_SIZE;
> -- 
> 2.30.2
> 
> 
