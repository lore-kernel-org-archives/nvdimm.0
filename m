Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA2C17E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 04:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646107598; x=1677643598;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wwDVriVDm7UgNSs8eXv3lJSf+SyllYz/XxGrm4fiOYw=;
  b=YlB+sAUmywGN2lfpmLiY3e6/68ilwZ/TLqkcekjz7TdZ0ypHby8Jftal
   dQZUV59gIVQUAKkSb7e31plz0pl7V+dgvDBpln3ODobH/dEOJt0sEnq5r
   Z6OtrsMwk222j0LxFSXl7XNk3hawHeqBnSywO92RaoAlZMpnYi/LqWlLm
   8bPbaA9D7x/zATMQeIyMazfqB93tZJbb5DlB8uEalJJiwKjIFew6el7NV
   7FVF4uNxIJbw+R12zE2reOB7Z/gxpadSylqVDgT8Ob3VgVBEHu0sXejCi
   tWVxDq8/PbHO2WRQDwPZrN49Ss08Gx41+HFE5xZmoFfJVGQohe4VEvmo0
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="313770842"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="313770842"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:06:38 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="639228248"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:06:37 -0800
Date: Mon, 28 Feb 2022 20:06:37 -0800
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
Subject: Re: [PATCH 08/10] drbd: use bvec_kmap_local in drbd_csum_bio
Message-ID: <Yh2bzX6YzzltNLZg@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-9-hch@lst.de>

On Tue, Feb 22, 2022 at 04:51:54PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/block/drbd/drbd_worker.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
> index a5e04b38006b6..1b48c8172a077 100644
> --- a/drivers/block/drbd/drbd_worker.c
> +++ b/drivers/block/drbd/drbd_worker.c
> @@ -326,9 +326,9 @@ void drbd_csum_bio(struct crypto_shash *tfm, struct bio *bio, void *digest)
>  	bio_for_each_segment(bvec, bio, iter) {
>  		u8 *src;
>  
> -		src = kmap_atomic(bvec.bv_page);
> -		crypto_shash_update(desc, src + bvec.bv_offset, bvec.bv_len);
> -		kunmap_atomic(src);
> +		src = bvec_kmap_local(&bvec);
> +		crypto_shash_update(desc, src, bvec.bv_len);
> +		kunmap_local(src);
>  
>  		/* REQ_OP_WRITE_SAME has only one segment,
>  		 * checksum the payload only once. */
> -- 
> 2.30.2
> 
> 
