Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo11.lge.com (LGEAMRELO11.lge.com [156.147.23.51])
 by ml01.01.org (Postfix) with ESMTP id 6453521D1822E
 for <linux-nvdimm@lists.01.org>; Mon, 14 Aug 2017 01:46:16 -0700 (PDT)
Date: Mon, 14 Aug 2017 17:48:37 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v1 2/6] fs: use on-stack-bio if backing device has
 BDI_CAP_SYNC capability
Message-ID: <20170814084837.GF26913@bbox>
References: <1502175024-28338-1-git-send-email-minchan@kernel.org>
 <1502175024-28338-3-git-send-email-minchan@kernel.org>
 <20170808124959.GB31390@bombadil.infradead.org>
 <20170808132904.GC31390@bombadil.infradead.org>
 <20170809015113.GB32338@bbox>
 <20170809023122.GF31390@bombadil.infradead.org>
 <20170809024150.GA32471@bbox>
 <20170810030433.GG31390@bombadil.infradead.org>
 <CAA9_cmekE9_PYmNnVmiOkyH2gq5o8=uvEKnAbMWw5nBX-zE69g@mail.gmail.com>
 <20170811104615.GA14397@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170811104615.GA14397@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-mm <linux-mm@kvack.org>, kernel-team <kernel-team@lge.com>, seungho1.park@lge.com, "karam . lee" <karam.lee@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Christoph,

On Fri, Aug 11, 2017 at 12:46:15PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 09, 2017 at 08:06:24PM -0700, Dan Williams wrote:
> > I like it, but do you think we should switch to sbvec[<constant>] to
> > preclude pathological cases where nr_pages is large?
> 
> Yes, please.

Still, I don't understand how sbvec[nr_pages] with on-stack bio in
do_mpage_readpage can help the performance.

IIUC, do_mpage_readpage works with page-base. IOW, it passes just one
page, not multiple pages so if we use on-stack bio, we just add *a page*
via bio_add_page and submit the bio before the function returning.

So, rather than sbvec[1], why de we need sbvec[nr_pages]?

Please, let me open my eyes. :)

Thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
