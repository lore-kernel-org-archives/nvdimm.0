Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <552BB4CA.6060808@plexistor.com>
Date: Mon, 13 Apr 2015 15:21:30 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [GIT PULL] PMEM driver for v4.1
References: <20150413093309.GA30219@gmail.com> <20150413093541.GA5147@lst.de> <20150413104531.GB30556@gmail.com>
In-Reply-To: <20150413104531.GB30556@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 04/13/2015 01:45 PM, Ingo Molnar wrote:
> 
> * Christoph Hellwig <hch@lst.de> wrote:
> 
>> On Mon, Apr 13, 2015 at 11:33:09AM +0200, Ingo Molnar wrote:
>>> Limitations: this is a regular block device, and since the pmem areas 
>>> are not struct page backed, they are invisible to the rest of the 
>>> system (other than the block IO device), so direct IO to/from pmem 
>>> areas, direct mmap() or XIP is not possible yet. The page cache will 
>>> also shadow and double buffer pmem contents, etc.
>>
>> Unless you use the DAX support in ext2/4 and soon XFS, in which case
>> we avoid that double buffering when doing read/write and mmap
> 
> Indeed, I missed that DAX support just went upstream in v4.0 - nice!
> 
> DAX may have some other limitations though that comes from not having 
> struct page * backing and using VM_MIXEDMAP, the following APIs might 
> not work on DAX files:
> 
>    - splice

splice works fine. Also I sent a cleanup in this area to Andrew it will
be in for 4.1

>    - zero copy O_DIRECT into DAX areas.

DAX is always O_DIRECT.

What does not work is mmap of DAX file and use that pointer in an
O_DIRECT operation of another device. (unless it is a DAX device)

Also mmap of DAX file and RDMA or direct-networking. Will need
a copy.

All this is fixable by applying my page-struct patch for pmem

>    - futexes
> 
>    - ( AFAICS hugetlbs won't work on DAX mmap()s yet - although with
>        the current nocache mapping that's probable the least of the 
>        performance issues for now. )
> 
> Btw., what's the future design plan here? Enable struct page backing, 
> or provide special codepaths for all DAX uses like the special pte 
> based approach for mmap()s?
> 

I'm hopping for struct page, 4k pages at first and 2M pages later on,
which needs more work in IO stacks, where I need this most.

> Thanks,
> 	Ingo
> 

Thanks
Boaz

