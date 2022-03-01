Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347627A
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 00:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646094637; x=1677630637;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iQYOoTv3Io78EdoGSCPEiJBASaZqMAGkeBkPnB8tiBw=;
  b=S2lHEqIWThXdjAILI9/eVU8wo6iigOOWywy/jvUiGnTAeARJetFwVMEL
   nXKZ4AaOdQA5IRza8Abd0cVPYwk6ETcIFuQS5edNY5onUxad7p902vUKM
   uBUOJd+pEI+6LSwf7JsLd3swG1U/FiS5ZF/K9FNIr8prmDmY/wbh9boCd
   2Dimfq7K+I5yp10rZmwV9As9gGZB+e0E71r2Um9Oa08f5kg9cWXzC8W/5
   rZXg6miA+UdnHWFlaR43d4ecT7UdqLlM1N9ZXgAsnZW426gTBRoizlPtE
   zFVr5i6Ve6JQ+OMbH1VRGpr69VRGdtV+hRXowqNkdLo4ztNCGAyB2Lfxv
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="316237128"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="316237128"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 16:30:36 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="803674992"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 16:30:35 -0800
Date: Mon, 28 Feb 2022 16:30:35 -0800
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
Subject: Re: [PATCH 01/10] iss-simdisk: use bvec_kmap_local in
 simdisk_submit_bio
Message-ID: <Yh1pKyX8z6R1l7mf@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-2-hch@lst.de>

On Tue, Feb 22, 2022 at 04:51:47PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  arch/xtensa/platforms/iss/simdisk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
> index 8eb6ad1a3a1de..0f0e0724397f4 100644
> --- a/arch/xtensa/platforms/iss/simdisk.c
> +++ b/arch/xtensa/platforms/iss/simdisk.c
> @@ -108,13 +108,13 @@ static void simdisk_submit_bio(struct bio *bio)
>  	sector_t sector = bio->bi_iter.bi_sector;
>  
>  	bio_for_each_segment(bvec, bio, iter) {
> -		char *buffer = kmap_atomic(bvec.bv_page) + bvec.bv_offset;
> +		char *buffer = bvec_kmap_local(&bvec);
>  		unsigned len = bvec.bv_len >> SECTOR_SHIFT;
>  
>  		simdisk_transfer(dev, sector, len, buffer,
>  				bio_data_dir(bio) == WRITE);
>  		sector += len;
> -		kunmap_atomic(buffer);
> +		kunmap_local(buffer);
>  	}
>  
>  	bio_endio(bio);
> -- 
> 2.30.2
> 
> 
