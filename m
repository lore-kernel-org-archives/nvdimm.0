Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo12.lge.com (LGEAMRELO12.lge.com [156.147.23.52])
 by ml01.01.org (Postfix) with ESMTP id C091621D1822E
 for <linux-nvdimm@lists.01.org>; Mon, 14 Aug 2017 01:48:21 -0700 (PDT)
Date: Mon, 14 Aug 2017 17:50:42 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v1 2/6] fs: use on-stack-bio if backing device has
 BDI_CAP_SYNC capability
Message-ID: <20170814085042.GG26913@bbox>
References: <1502175024-28338-3-git-send-email-minchan@kernel.org>
 <20170808124959.GB31390@bombadil.infradead.org>
 <20170808132904.GC31390@bombadil.infradead.org>
 <20170809015113.GB32338@bbox>
 <20170809023122.GF31390@bombadil.infradead.org>
 <20170809024150.GA32471@bbox>
 <20170810030433.GG31390@bombadil.infradead.org>
 <CAA9_cmekE9_PYmNnVmiOkyH2gq5o8=uvEKnAbMWw5nBX-zE69g@mail.gmail.com>
 <20170811104615.GA14397@lst.de>
 <20c5b30a-b787-1f46-f997-7542a87033f8@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20c5b30a-b787-1f46-f997-7542a87033f8@kernel.dk>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: kernel-team <kernel-team@lge.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm <linux-mm@kvack.org>, seungho1.park@lge.com, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Jens,

On Fri, Aug 11, 2017 at 08:26:59AM -0600, Jens Axboe wrote:
> On 08/11/2017 04:46 AM, Christoph Hellwig wrote:
> > On Wed, Aug 09, 2017 at 08:06:24PM -0700, Dan Williams wrote:
> >> I like it, but do you think we should switch to sbvec[<constant>] to
> >> preclude pathological cases where nr_pages is large?
> > 
> > Yes, please.
> > 
> > Then I'd like to see that the on-stack bio even matters for
> > mpage_readpage / mpage_writepage.  Compared to all the buffer head
> > overhead the bio allocation should not actually matter in practice.
> 
> I'm skeptical for that path, too. I also wonder how far we could go
> with just doing a per-cpu bio recycling facility, to reduce the cost
> of having to allocate a bio. The on-stack bio parts are fine for
> simple use case, where simple means that the patch just special
> cases the allocation, and doesn't have to change much else.
> 
> I had a patch for bio recycling and batched freeing a year or two
> ago, I'll see if I can find and resurrect it.

So, you want to go with per-cpu bio recycling approach to
remove rw_page?

So, do you want me to hold this patchset?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
