Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4881521E1DAD9
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 14:11:25 -0700 (PDT)
Date: Thu, 3 Aug 2017 15:13:35 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/3] remove rw_page() from brd, pmem and btt
Message-ID: <20170803211335.GA1260@linux.intel.com>
References: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
 <20170728173143.GE15980@bombadil.infradead.org>
 <20170802221359.GA20666@linux.intel.com>
 <20170803001315.GF32020@bbox>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170803001315.GF32020@bbox>
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
To: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, seungho1.park@lge.com, Jan Kara <jack@suse.cz>, "karam . lee" <karam.lee@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 03, 2017 at 09:13:15AM +0900, Minchan Kim wrote:
> Hi Ross,
> 
> On Wed, Aug 02, 2017 at 04:13:59PM -0600, Ross Zwisler wrote:
> > On Fri, Jul 28, 2017 at 10:31:43AM -0700, Matthew Wilcox wrote:
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
> > Okay, I've run a bunch of performance tests with the PMEM and with BTT entry
> > points for rw_pages() in a swap workload, and in all cases I do see an
> > improvement over the code when rw_pages() is removed.  Here are the results
> > from my random lab box:
> > 
> >   Average latency of swap_writepage()
> > +------+------------+---------+-------------+
> > |      | no rw_page | rw_page | Improvement |
> > +-------------------------------------------+
> > | PMEM |  5.0 us    |  4.7 us |     6%      |
> > +-------------------------------------------+
> > |  BTT |  6.8 us    |  6.1 us |    10%      |
> > +------+------------+---------+-------------+
> > 
> >   Average latency of swap_readpage()
> > +------+------------+---------+-------------+
> > |      | no rw_page | rw_page | Improvement |
> > +-------------------------------------------+
> > | PMEM |  3.3 us    |  2.9 us |    12%      |
> > +-------------------------------------------+
> > |  BTT |  3.7 us    |  3.4 us |     8%      |
> > +------+------------+---------+-------------+
> > 
> > The workload was pmbench, a memory benchmark, run on a system where I had
> > severely restricted the amount of memory in the system with the 'mem' kernel
> > command line parameter.  The benchmark was set up to test more memory than I
> > allowed the OS to have so it spilled over into swap.
> > 
> > The PMEM or BTT device was set up as my swap device, and during the test I got
> > a few hundred thousand samples of each of swap_writepage() and
> > swap_writepage().  The PMEM/BTT device was just memory reserved with the
> > memmap kernel command line parameter.
> > 
> > Thanks, Matthew, for asking for performance data.  It looks like removing this
> > code would have been a mistake.
> 
> By suggestion of Christoph Hellwig, I made a quick patch which does IO without
> dynamic bio allocation for swap IO. Actually, it's not formal patch to be
> worth to send mainline yet but I believe it's enough to test the improvement.
> 
> Could you test patchset on pmem and btt without rw_page?
> 
> For working the patch, block drivers need to declare it's synchronous IO
> device via BDI_CAP_SYNC but if it's hard, you can just make every swap IO
> comes from (sis->flags & SWP_SYNC_IO) with removing condition check
> 
> if (!(sis->flags & SWP_SYNC_IO)) in swap_[read|write]page.
> 
> Patchset is based on 4.13-rc3.

Thanks for the patch, here are the updated results from my test box:

 Average latency of swap_writepage()
+------+------------+---------+---------+
|      | no rw_page | minchan | rw_page |
+----------------------------------------
| PMEM |  5.0 us    | 4.98 us |  4.7 us |
+----------------------------------------
|  BTT |  6.8 us    | 6.3 us  |  6.1 us |
+------+------------+---------+---------+
  				   
 Average latency of swap_readpage()
+------+------------+---------+---------+
|      | no rw_page | minchan | rw_page |
+----------------------------------------
| PMEM |  3.3 us    | 3.27 us |  2.9 us |
+----------------------------------------
|  BTT |  3.7 us    | 3.44 us |  3.4 us |
+------+------------+---------+---------+

I've added another digit in precision in some cases to help differentiate the
various results.

In all cases your patches did perform better than with the regularly allocated
BIO, but again for all cases the rw_page() path was the fastest, even if only
marginally.

- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
