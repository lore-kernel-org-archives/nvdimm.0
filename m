Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 13 Apr 2015 14:35:35 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] PMEM driver for v4.1
Message-ID: <20150413123535.GA2666@gmail.com>
References: <20150413093309.GA30219@gmail.com>
 <20150413093541.GA5147@lst.de>
 <20150413104531.GB30556@gmail.com>
 <552BB4CA.6060808@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <552BB4CA.6060808@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>


* Boaz Harrosh <boaz@plexistor.com> wrote:

> On 04/13/2015 01:45 PM, Ingo Molnar wrote:
> > 
> > * Christoph Hellwig <hch@lst.de> wrote:
> > 
> >> On Mon, Apr 13, 2015 at 11:33:09AM +0200, Ingo Molnar wrote:
> >>> Limitations: this is a regular block device, and since the pmem areas 
> >>> are not struct page backed, they are invisible to the rest of the 
> >>> system (other than the block IO device), so direct IO to/from pmem 
> >>> areas, direct mmap() or XIP is not possible yet. The page cache will 
> >>> also shadow and double buffer pmem contents, etc.
> >>
> >> Unless you use the DAX support in ext2/4 and soon XFS, in which case
> >> we avoid that double buffering when doing read/write and mmap
> > 
> > Indeed, I missed that DAX support just went upstream in v4.0 - nice!
> > 
> > DAX may have some other limitations though that comes from not having 
> > struct page * backing and using VM_MIXEDMAP, the following APIs might 
> > not work on DAX files:
> > 
> >    - splice
> 
> splice works fine. Also I sent a cleanup in this area to Andrew it will
> be in for 4.1

How does splice work with DAX files? AFAICS vmsplice() won't work, as 
it uses get_user_pages(), which needs struct page backing. Also, how 
will f_op->sendpage() work? That too needs page backing.

> >    - zero copy O_DIRECT into DAX areas.
> 
> DAX is always O_DIRECT.
> 
> What does not work is mmap of DAX file and use that pointer in an
> O_DIRECT operation of another device. (unless it is a DAX device)

That is what I meant: O_DIRECT into (or from) DAX mmap()-ed areas, 
from a different device.

I'm not promoting the use of these APIs, some of them are quirky, just 
wanted to list the known limitations. The pmem driver is already 
useful as-is.

Thanks,

	Ingo
