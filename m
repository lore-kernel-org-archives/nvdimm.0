Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E00417E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 04:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646107800; x=1677643800;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R1uMAEtzeBJ62IRlIzYoDZhF0ZqNu5JCt6nzrNsVez8=;
  b=dRwqH2lU/q4iYyifa6T+GjTA/kKZYhQsWAA+sXaU6DZ0lTbqLXlLPNKd
   MSoFkMqstoWYKFLLFoCEpr4GZ4s78vXd1GJSiHwyUJhQdAEmcgh2T+HLh
   qNB0ZtEvYJFATCLNspkNhU8vJa8bF7S9bxIEMQNA3hdtA1IT1SS2y/lfN
   Gd5heMkgHUvcnulrXPszKqcxjW3KdoY/+kZbpUeGg62FQ+PGQVN50tXlk
   b3/kdRw0+8ZuaqvYWRK0tLJU0a2ykyxMHzyxbhXkhKD1OtAnLH8Q8uQGg
   xOAqjLfS1H2syl8F8dIkLXxn8QJI3ooOElBrgHFA7NDJ3FjVVTlSuijwI
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="253242035"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="253242035"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:09:59 -0800
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="804056797"
Received: from chunhanz-mobl.amr.corp.intel.com (HELO localhost) ([10.212.29.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 20:09:59 -0800
Date: Mon, 28 Feb 2022 20:09:58 -0800
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
Subject: Re: [PATCH 09/10] drbd: use bvec_kmap_local in recv_dless_read
Message-ID: <Yh2clo6ATYC/e8Jm@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222155156.597597-10-hch@lst.de>

On Tue, Feb 22, 2022 at 04:51:55PM +0100, Christoph Hellwig wrote:
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/block/drbd/drbd_receiver.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
> index 04e3ec12d8b49..fa00cf2ea9529 100644
> --- a/drivers/block/drbd/drbd_receiver.c
> +++ b/drivers/block/drbd/drbd_receiver.c
> @@ -2017,10 +2017,10 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
>  	D_ASSERT(peer_device->device, sector == bio->bi_iter.bi_sector);
>  
>  	bio_for_each_segment(bvec, bio, iter) {
> -		void *mapped = kmap(bvec.bv_page) + bvec.bv_offset;
> +		void *mapped = bvec_kmap_local(&bvec);
>  		expect = min_t(int, data_size, bvec.bv_len);
>  		err = drbd_recv_all_warn(peer_device->connection, mapped, expect);
> -		kunmap(bvec.bv_page);
> +		kunmap_local(mapped);
>  		if (err)
>  			return err;
>  		data_size -= expect;
> -- 
> 2.30.2
> 
> 
