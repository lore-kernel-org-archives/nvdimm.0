Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sun, 21 Jun 2015 12:10:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/15] libnvdimm: pmem, blk, and btt make_request
	cleanups
Message-ID: <20150621101055.GD5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235546.12943.2374.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150617235546.12943.2374.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

One patch per driver please.

> diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
> index 8a6345797a71..9d609ef95266 100644
> --- a/drivers/nvdimm/blk.c
> +++ b/drivers/nvdimm/blk.c
> @@ -170,18 +170,12 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
>  	struct bvec_iter iter;
>  	struct bio_vec bvec;
>  	int err = 0, rw;
> -	sector_t sector;
>  
> -	sector = bio->bi_iter.bi_sector;
> -	if (bio_end_sector(bio) > get_capacity(disk)) {
> +	if (unlikely(bio_end_sector(bio) > get_capacity(disk))) {
>  		err = -EIO;
>  		goto out;
>  	}
>  
> -	BUG_ON(bio->bi_rw & REQ_DISCARD);

If you remove the DISCARD check you can kill the max sectors one
as well, given that generic_make_request_checks() takes care of it.

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
