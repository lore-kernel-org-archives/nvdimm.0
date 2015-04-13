Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 13 Apr 2015 12:45:32 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] PMEM driver for v4.1
Message-ID: <20150413104531.GB30556@gmail.com>
References: <20150413093309.GA30219@gmail.com>
 <20150413093541.GA5147@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150413093541.GA5147@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>


* Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Apr 13, 2015 at 11:33:09AM +0200, Ingo Molnar wrote:
> > Limitations: this is a regular block device, and since the pmem areas 
> > are not struct page backed, they are invisible to the rest of the 
> > system (other than the block IO device), so direct IO to/from pmem 
> > areas, direct mmap() or XIP is not possible yet. The page cache will 
> > also shadow and double buffer pmem contents, etc.
> 
> Unless you use the DAX support in ext2/4 and soon XFS, in which case
> we avoid that double buffering when doing read/write and mmap

Indeed, I missed that DAX support just went upstream in v4.0 - nice!

DAX may have some other limitations though that comes from not having 
struct page * backing and using VM_MIXEDMAP, the following APIs might 
not work on DAX files:

   - splice
   - zero copy O_DIRECT into DAX areas.
   - futexes

   - ( AFAICS hugetlbs won't work on DAX mmap()s yet - although with
       the current nocache mapping that's probable the least of the 
       performance issues for now. )

Btw., what's the future design plan here? Enable struct page backing, 
or provide special codepaths for all DAX uses like the special pte 
based approach for mmap()s?

Thanks,

	Ingo
