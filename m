Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A795017E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 03:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646107148; x=1677643148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JmKLQqD/paUGVR0IFWSaZMWPH0JozuynpP4eKVlBoHg=;
  b=HimiAOqKIifFYqXOwg2A3wZSi6X3kB+T9JEx5TtZNb+isnHz/kA79nY7
   IOzQS8kaCp1u0vex8/o4psgJg22sDlkwlM+WengzhRd34+Zgu7N1FkL0O
   jDzK8Flh1xMO3DyfPdmKXbTt+UVGP6uSpe7QUqOG/DCR+cgf6Wi6KIlte
   yzZNtSqpArxeCNklNH/9LXXVUrfs4skKvurE4cw8uW+FKyp1iuUihJHrs
   w42qMQq7H/oomA8OuxQbhyGf30TNQiPG7aBhZQbcm8IQxIxr/5PVOB4m2
   oGzNVGie59CbA/lXtXGjuN0Sx+kx4q42dkYYcXzVYKH7ixOUzcAuKUSGz
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="277712493"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="277712493"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 19:59:08 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575563941"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 19:59:07 -0800
Date: Mon, 28 Feb 2022 19:59:06 -0800
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
Subject: Re: [PATCH 06/10] nvdimm-btt: use bvec_kmap_local in btt_rw_integrity
Message-ID: <Yh2aCi6gtG0naC1r@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-7-hch@lst.de>

On Tue, Feb 22, 2022 at 04:51:52PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvdimm/btt.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index cbd994f7f1fe6..9613e54c7a675 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1163,17 +1163,15 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
>  		 */
>  
>  		cur_len = min(len, bv.bv_len);
> -		mem = kmap_atomic(bv.bv_page);
> +		mem = bvec_kmap_local(&bv);
>  		if (rw)
> -			ret = arena_write_bytes(arena, meta_nsoff,
> -					mem + bv.bv_offset, cur_len,
> +			ret = arena_write_bytes(arena, meta_nsoff, mem, cur_len,

Why drop bv.bv_offset here and below?

Ira

>  					NVDIMM_IO_ATOMIC);
>  		else
> -			ret = arena_read_bytes(arena, meta_nsoff,
> -					mem + bv.bv_offset, cur_len,
> +			ret = arena_read_bytes(arena, meta_nsoff, mem, cur_len,
>  					NVDIMM_IO_ATOMIC);
>  
> -		kunmap_atomic(mem);
> +		kunmap_local(mem);
>  		if (ret)
>  			return ret;
>  
> -- 
> 2.30.2
> 
> 
