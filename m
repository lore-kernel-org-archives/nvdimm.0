Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <57279D57.5020800@plexistor.com>
Date: Mon, 02 May 2016 21:32:55 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>	<5727753F.6090104@plexistor.com>	<CAPcyv4jWPTDbbw6uMFEEt2Kazgw+wb5Pfwroej--uQPE+AtUbA@mail.gmail.com>	<57277EDA.9000803@plexistor.com>	<CAPcyv4jnz69a3S+XZgLaLojHZmpfoVXGDkJkt_1Q=8kk0gik9w@mail.gmail.com>	<572791E1.7000103@plexistor.com> <CAPcyv4hGV07gpADT32xn=3brEq75P4RJA592vp-1A+jXMQCeOQ@mail.gmail.com>
In-Reply-To: <CAPcyv4hGV07gpADT32xn=3brEq75P4RJA592vp-1A+jXMQCeOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Jens Axboe <axboe@fb.com>, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/02/2016 09:10 PM, Dan Williams wrote:
<>
> 
> The semantic I am talking about preserving is:
> 
> buffered / unaligned write of a bad sector => -EIO on reading into the
> page cache
> 

What about aligned buffered write? like write 0-to-eof
This still broken? (and is what restore apps do)

> ...and that the only guaranteed way to clear an error (assuming the
> block device supports it) is an O_DIRECT write.
> 

Sure fixing dax_do_io will guaranty that.

<>
> I still think we're talking past each other on this point.  

Yes we are!

> This patch
> set is not overloading error semantics, it's fixing the error handling
> problem that was introduced in this commit:
> 
>    d475c6346a38 dax,ext2: replace XIP read and write with DAX I/O
> 
> ...where we started overloading O_DIRECT and dax_do_io() semantics.
> 

But above does not fix them does it? it just completely NULLs DAX for
O_DIRECT which is a great pity, why did we do all this work in the first
place.

And then it keeps broken the aligned buffered writes, which are still
broken after this set.

I have by now read the v2 patches. And I think you guys did not yet try
the proper fix for dax_do_io. I think you need to go deeper into the loops
and selectively call bdev_* when error on a specific page copy. No need to
go through direct_IO path at all.
Do you need that I send you a patch to demonstrate what I mean?

But yes I feel too that "we're talking past each other". I did want
to come to LSF and talk to you, but was not invited. Should I call you?

Thanks
Boaz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
