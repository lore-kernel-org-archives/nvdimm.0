Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150413104531.GB30556@gmail.com>
References: <20150413093309.GA30219@gmail.com>
	<20150413093541.GA5147@lst.de>
	<20150413104531.GB30556@gmail.com>
Date: Mon, 13 Apr 2015 14:11:56 +0300
Message-ID: <CACTTzNYBUocOz7scco6x-22ngu9cMk5uXJnHgM5PGFBqD22X-A@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
From: Yigal Korman <yigal@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 13, 2015 at 1:45 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Christoph Hellwig <hch@lst.de> wrote:
>
>> On Mon, Apr 13, 2015 at 11:33:09AM +0200, Ingo Molnar wrote:
>> > Limitations: this is a regular block device, and since the pmem areas
>> > are not struct page backed, they are invisible to the rest of the
>> > system (other than the block IO device), so direct IO to/from pmem
>> > areas, direct mmap() or XIP is not possible yet. The page cache will
>> > also shadow and double buffer pmem contents, etc.
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
>    - zero copy O_DIRECT into DAX areas.
>    - futexes
>
>    - ( AFAICS hugetlbs won't work on DAX mmap()s yet - although with
>        the current nocache mapping that's probable the least of the
>        performance issues for now. )

mlock() and MAP_POPULATE don't work with DAX files as well.

>
> Btw., what's the future design plan here? Enable struct page backing,
> or provide special codepaths for all DAX uses like the special pte
> based approach for mmap()s?
>
> Thanks,
>
>         Ingo
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
