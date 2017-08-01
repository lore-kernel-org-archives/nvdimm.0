Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo12.lge.com (LGEAMRELO12.lge.com [156.147.23.52])
 by ml01.01.org (Postfix) with ESMTP id BC5BC21CF951E
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 23:20:54 -0700 (PDT)
Date: Tue, 1 Aug 2017 15:23:01 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 0/3] remove rw_page() from brd, pmem and btt
Message-ID: <20170801062301.GB19932@bbox>
References: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
 <20170728173143.GE15980@bombadil.infradead.org>
 <20170728142123.729b20e9fcf45c6a814f18e7@linux-foundation.org>
 <20170730221659.GA28031@bbox> <20170731071707.GA16299@lst.de>
 <20170731073647.GA26199@bbox> <20170731074206.GA16706@lst.de>
 <20170731074404.GA16749@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170731074404.GA16749@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, seungho1.park@lge.com, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 09:44:04AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 31, 2017 at 09:42:06AM +0200, Christoph Hellwig wrote:
> > On Mon, Jul 31, 2017 at 04:36:47PM +0900, Minchan Kim wrote:
> > > Do you suggest define something special flag(e.g., SWP_INMEMORY)
> > > for in-memory swap to swap_info_struct when swapon time manually
> > > or from bdi_queue_someting automatically?
> > > And depending the flag of swap_info_struct, use the onstack bio
> > > instead of dynamic allocation if the swap device is in-memory?
> > 
> > Currently swap always just does I/O on a single page as far
> > as I can tell, so it can always just use an on-stack bio and
> > biovec.
> 
> That's for synchronous I/O, aka reads of course.  For writes you'll
> need to do a dynamic allocation if they are asynchronous.  But yes,
> if we want to force certain devices to be synchronous we'll need
> a flag for that.

Okay, I will look into that.
Thanks for the suggestion, Christoph.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
