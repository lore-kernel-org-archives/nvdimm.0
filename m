Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo13.lge.com (LGEAMRELO13.lge.com [156.147.23.53])
 by ml01.01.org (Postfix) with ESMTP id AE63321E2DA5E
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 21:45:36 -0700 (PDT)
Date: Wed, 16 Aug 2017 13:48:00 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v1 2/6] fs: use on-stack-bio if backing device has
 BDI_CAP_SYNC capability
Message-ID: <20170816044759.GC24294@blaptop>
References: <CAA9_cmekE9_PYmNnVmiOkyH2gq5o8=uvEKnAbMWw5nBX-zE69g@mail.gmail.com>
 <20170811104615.GA14397@lst.de>
 <20c5b30a-b787-1f46-f997-7542a87033f8@kernel.dk>
 <20170814085042.GG26913@bbox>
 <51f7472a-977b-be69-2688-48f2a0fa6fb3@kernel.dk>
 <20170814150620.GA12657@bgram>
 <51893dc5-05a3-629a-3b88-ecd8e25165d0@kernel.dk>
 <20170814153059.GA13497@bgram>
 <0c83e7af-10a4-3462-bb4c-4254adcf6f7a@kernel.dk>
 <058b4ae5-c6e9-ff32-6440-fb1e1b85b6fd@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <058b4ae5-c6e9-ff32-6440-fb1e1b85b6fd@kernel.dk>
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

On Mon, Aug 14, 2017 at 10:17:09AM -0600, Jens Axboe wrote:
> On 08/14/2017 09:38 AM, Jens Axboe wrote:
> > On 08/14/2017 09:31 AM, Minchan Kim wrote:
> >>> Secondly, generally you don't have slow devices and fast devices
> >>> intermingled when running workloads. That's the rare case.
> >>
> >> Not true. zRam is really popular swap for embedded devices where
> >> one of low cost product has a really poor slow nand compared to
> >> lz4/lzo [de]comression.
> > 
> > I guess that's true for some cases. But as I said earlier, the recycling
> > really doesn't care about this at all. They can happily coexist, and not
> > step on each others toes.
> 
> Dusted it off, result is here against -rc5:
> 
> http://git.kernel.dk/cgit/linux-block/log/?h=cpu-alloc-cache
> 
> I'd like to split the amount of units we cache and the amount of units
> we free, right now they are both CPU_ALLOC_CACHE_SIZE. This means that
> once we hit that count, we free all of the, and then store the one we
> were asked to free. That always keeps 1 local, but maybe it'd make more
> sense to cache just free CPU_ALLOC_CACHE_SIZE/2 (or something like that)
> so that we retain more than 1 per cpu in case and app preempts when
> sleeping for IO and the new task on that CPU then issues IO as well.
> Probably minor.
> 
> Ran a quick test on nullb0 with 32 sync readers. The test was O_DIRECT
> on the block device, so I disabled the __blkdev_direct_IO_simple()
> bypass. With the above branch, we get ~18.0M IOPS, and without we get
> ~14M IOPS. Both ran with iostats disabled, to avoid any interference
> from that.

Looks promising.
If recycling bio works well enough, I think we don't need to introduce
new split in the path for on-stack bio.
I will test your version on zram-swap!

Thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
