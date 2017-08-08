Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 8 Aug 2017 06:29:04 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 2/6] fs: use on-stack-bio if backing device has
 BDI_CAP_SYNC capability
Message-ID: <20170808132904.GC31390@bombadil.infradead.org>
References: <1502175024-28338-1-git-send-email-minchan@kernel.org>
 <1502175024-28338-3-git-send-email-minchan@kernel.org>
 <20170808124959.GB31390@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170808124959.GB31390@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Ross Zwisler <ross.zwisler@linux.intel.com>, "karam . lee" <karam.lee@lge.com>, seungho1.park@lge.com, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, jack@suse.cz, Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org, kernel-team <kernel-team@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 08, 2017 at 05:49:59AM -0700, Matthew Wilcox wrote:
> +	struct bio sbio;
> +	struct bio_vec sbvec;

... this needs to be sbvec[nr_pages], of course.

> -		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
> +		if (bdi_cap_synchronous_io(inode_to_bdi(inode))) {
> +			bio = &sbio;
> +			bio_init(bio, &sbvec, nr_pages);

... and this needs to be 'sbvec', not '&sbvec'.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
