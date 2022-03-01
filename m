Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507827A
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646094707; x=1677630707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QySiqZr3Aw1s/l/FX4PY4TC5JAQpi05yLKC4BU8F00g=;
  b=dF01SYY86TrrVJqWmzAjuMuuuiw4t5d5QjnxYIGGwnbxXMg+dKhMxfCE
   2fMLRZSNMtRLBtP+02zsiq4Hh3tX8VAOPB6yL3kMPqUpmR/OmzuHJQ2KP
   Jw3VhKPb5OWlBMEdVzNg6mCZoGtLzw9U1uA1ZWNPfLPm09w100lxOhYae
   P2lYf/Mnf/CltexZUaB4f904gauGXlaCWhxStqp5HaTSVZPLcPa9oZhMx
   vKSvpMycHIjRjAfIJKz9BRWMaTQ0sHwgBusk7VcGeukP9p4r6ULl56I05
   hrjXI5muu4ur9Yk19lm4BFJl4h3EpUP24yTO+8x8hPauhro4ghURpi1cw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="277683998"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="277683998"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 16:31:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="639181195"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 16:31:46 -0800
Date: Mon, 28 Feb 2022 16:31:46 -0800
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
Subject: Re: [PATCH 02/10] aoe: use bvec_kmap_local in bvcpy
Message-ID: <Yh1pclDpq6iImDAu@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-3-hch@lst.de>

On Tue, Feb 22, 2022 at 04:51:48PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/aoe/aoecmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index cc11f89a0928f..093996961d452 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -1018,7 +1018,7 @@ bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter, long cnt)
>  	iter.bi_size = cnt;
>  
>  	__bio_for_each_segment(bv, bio, iter, iter) {
> -		char *p = kmap_atomic(bv.bv_page) + bv.bv_offset;
> +		char *p = bvec_kmap_local(&bv);
>  		skb_copy_bits(skb, soff, p, bv.bv_len);
>  		kunmap_atomic(p);

kunmap_local()

Ira

>  		soff += bv.bv_len;
> -- 
> 2.30.2
> 
> 
