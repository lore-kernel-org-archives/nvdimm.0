Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo11.lge.com (LGEAMRELO11.lge.com [156.147.23.51])
 by ml01.01.org (Postfix) with ESMTP id A79D921E11D96
 for <linux-nvdimm@lists.01.org>; Sun, 30 Jul 2017 15:36:44 -0700 (PDT)
Date: Mon, 31 Jul 2017 07:38:51 +0900
From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 0/3] remove rw_page() from brd, pmem and btt
Message-ID: <20170730223851.GB28031@bbox>
References: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
 <20170728173143.GE15980@bombadil.infradead.org>
 <20170728142123.729b20e9fcf45c6a814f18e7@linux-foundation.org>
 <20170730221659.GA28031@bbox>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170730221659.GA28031@bbox>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, "karam . lee" <karam.lee@lge.com>, seungho1.park@lge.com, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 31, 2017 at 07:16:59AM +0900, Minchan Kim wrote:
> Hi Andrew,
> 
> On Fri, Jul 28, 2017 at 02:21:23PM -0700, Andrew Morton wrote:
> > On Fri, 28 Jul 2017 10:31:43 -0700 Matthew Wilcox <willy@infradead.org> wrote:
> > 
> > > On Fri, Jul 28, 2017 at 10:56:01AM -0600, Ross Zwisler wrote:
> > > > Dan Williams and Christoph Hellwig have recently expressed doubt about
> > > > whether the rw_page() interface made sense for synchronous memory drivers
> > > > [1][2].  It's unclear whether this interface has any performance benefit
> > > > for these drivers, but as we continue to fix bugs it is clear that it does
> > > > have a maintenance burden.  This series removes the rw_page()
> > > > implementations in brd, pmem and btt to relieve this burden.
> > > 
> > > Why don't you measure whether it has performance benefits?  I don't
> > > understand why zram would see performance benefits and not other drivers.
> > > If it's going to be removed, then the whole interface should be removed,
> > > not just have the implementations removed from some drivers.
> > 
> > Yes please.  Minchan, could you please take a look sometime?
> 
> rw_page's gain is reducing of dynamic allocation in swap path
> as well as performance gain thorugh avoiding bio allocation.
> And it would be important in memory pressure situation.
> 
> I guess it comes from bio_alloc mempool. Usually, zram-swap works
> in high memory pressure so mempool would be exahusted easily.
> It means that mempool wait and repeated alloc would consume the
> overhead.
> 
> Actually, at that time although Karam reported the gain is 2.4%,
> I got a report from production team that the gain in corner case
> (e.g., animation playing is smooth) would be much higher than
> expected.

One of the idea is to create bioset only for swap without sharing
with FS so bio allocation for swap doesn't need to wait returning
bio from FS side which does slow nand IO to mempool.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
