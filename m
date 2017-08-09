Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo11.lge.com (LGEAMRELO11.lge.com [156.147.23.51])
 by ml01.01.org (Postfix) with ESMTP id 5981221E0C302
 for <linux-nvdimm@lists.01.org>; Tue,  8 Aug 2017 18:49:02 -0700 (PDT)
Date: Wed, 9 Aug 2017 10:51:13 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v1 2/6] fs: use on-stack-bio if backing device has
 BDI_CAP_SYNC capability
Message-ID: <20170809015113.GB32338@bbox>
References: <1502175024-28338-1-git-send-email-minchan@kernel.org>
 <1502175024-28338-3-git-send-email-minchan@kernel.org>
 <20170808124959.GB31390@bombadil.infradead.org>
 <20170808132904.GC31390@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170808132904.GC31390@bombadil.infradead.org>
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, kernel-team <kernel-team@lge.com>, seungho1.park@lge.com, "karam . lee" <karam.lee@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 08, 2017 at 06:29:04AM -0700, Matthew Wilcox wrote:
> On Tue, Aug 08, 2017 at 05:49:59AM -0700, Matthew Wilcox wrote:
> > +	struct bio sbio;
> > +	struct bio_vec sbvec;
> 
> ... this needs to be sbvec[nr_pages], of course.
> 
> > -		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
> > +		if (bdi_cap_synchronous_io(inode_to_bdi(inode))) {
> > +			bio = &sbio;
> > +			bio_init(bio, &sbvec, nr_pages);
> 
> ... and this needs to be 'sbvec', not '&sbvec'.

I don't get it why we need sbvec[nr_pages].
On-stack-bio works with per-page.
May I miss something?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
