Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo12.lge.com (LGEAMRELO12.lge.com [156.147.23.52])
 by ml01.01.org (Postfix) with ESMTP id 78DBA21AEB0BE
 for <linux-nvdimm@lists.01.org>; Mon, 31 Jul 2017 00:34:41 -0700 (PDT)
Date: Mon, 31 Jul 2017 16:36:47 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 0/3] remove rw_page() from brd, pmem and btt
Message-ID: <20170731073647.GA26199@bbox>
References: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
 <20170728173143.GE15980@bombadil.infradead.org>
 <20170728142123.729b20e9fcf45c6a814f18e7@linux-foundation.org>
 <20170730221659.GA28031@bbox> <20170731071707.GA16299@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170731071707.GA16299@lst.de>
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

On Mon, Jul 31, 2017 at 09:17:07AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 31, 2017 at 07:16:59AM +0900, Minchan Kim wrote:
> > rw_page's gain is reducing of dynamic allocation in swap path
> > as well as performance gain thorugh avoiding bio allocation.
> > And it would be important in memory pressure situation.
> 
> There is no need for any dynamic allocation when using the bio
> path.  Take a look at __blkdev_direct_IO_simple for an example
> that doesn't do any allocations.

Do you suggest define something special flag(e.g., SWP_INMEMORY)
for in-memory swap to swap_info_struct when swapon time manually
or from bdi_queue_someting automatically?
And depending the flag of swap_info_struct, use the onstack bio
instead of dynamic allocation if the swap device is in-memory?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
