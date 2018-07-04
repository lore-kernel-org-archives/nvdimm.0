Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BBBF1211F8860
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 04:30:15 -0700 (PDT)
Date: Wed, 4 Jul 2018 13:30:12 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] fs/dax: Assigning NULL to gfn of dax_direct_access
 if useless
Message-ID: <20180704113012.trnfzeefao25clri@quack2.suse.cz>
References: <20180704064058.1344-1-yehs2007@zoho.com>
 <20180704064058.1344-3-yehs2007@zoho.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180704064058.1344-3-yehs2007@zoho.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, mawilcox@microsoft.com, chengnt@lenovo.com, linux-nvdimm@lists.01.org, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, bart.vanassche@wdc.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, linux-fsdevel@vger.kernel.org, jack@suse.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed 04-07-18 14:40:58, Huaisheng Ye wrote:
> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> Some functions within fs/dax don't need to get gfn from direct_access.
> Assigning NULL to gfn of dax_direct_access is more intuitive and simple
> than offering a useless local variable.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

I like this. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

for the series.

								Honza

> ---
>  fs/dax.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index aaec72de..aa75dfd 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -550,7 +550,6 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
>  {
>  	void *vto, *kaddr;
>  	pgoff_t pgoff;
> -	pfn_t pfn;
>  	long rc;
>  	int id;
>  
> @@ -559,7 +558,7 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
>  		return rc;
>  
>  	id = dax_read_lock();
> -	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
> +	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, NULL);
>  	if (rc < 0) {
>  		dax_read_unlock(id);
>  		return rc;
> @@ -961,7 +960,6 @@ int __dax_zero_page_range(struct block_device *bdev,
>  		pgoff_t pgoff;
>  		long rc, id;
>  		void *kaddr;
> -		pfn_t pfn;
>  
>  		rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
>  		if (rc)
> @@ -969,7 +967,7 @@ int __dax_zero_page_range(struct block_device *bdev,
>  
>  		id = dax_read_lock();
>  		rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr,
> -				&pfn);
> +				NULL);
>  		if (rc < 0) {
>  			dax_read_unlock(id);
>  			return rc;
> @@ -1024,7 +1022,6 @@ int __dax_zero_page_range(struct block_device *bdev,
>  		ssize_t map_len;
>  		pgoff_t pgoff;
>  		void *kaddr;
> -		pfn_t pfn;
>  
>  		if (fatal_signal_pending(current)) {
>  			ret = -EINTR;
> @@ -1036,7 +1033,7 @@ int __dax_zero_page_range(struct block_device *bdev,
>  			break;
>  
>  		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
> -				&kaddr, &pfn);
> +				&kaddr, NULL);
>  		if (map_len < 0) {
>  			ret = map_len;
>  			break;
> -- 
> 1.8.3.1
> 
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
