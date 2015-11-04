Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jpNtML7NuizvWUVW3Jxma4-D4+c59yJw_PZ140KoVqsw@mail.gmail.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151102043053.6610.43948.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151103003234.GM10656@dastard>
	<CAPcyv4j8=_LdfK_TjJfEP0aA-1d3wSaLwBcpmrTobijpcRk1Dw@mail.gmail.com>
	<20151103202041.GG19199@dastard>
	<CAPcyv4jpNtML7NuizvWUVW3Jxma4-D4+c59yJw_PZ140KoVqsw@mail.gmail.com>
Date: Wed, 4 Nov 2015 11:23:16 -0800
Message-ID: <CAPcyv4ibo-MDxr06wo49pB-EhAWEPXy1_GFDU9KnoPma9gu9JQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/15] block, dax: make dax mappings opt-in by default
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 3, 2015 at 3:04 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Nov 3, 2015 at 12:20 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Mon, Nov 02, 2015 at 11:35:04PM -0800, Dan Williams wrote:
>>> On Mon, Nov 2, 2015 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> [..]
>>> Only in the mmap path:
>>
>> which means blkdev_direct_IO() is now always going to go down the
>> dax_do_io() path for any driver with a ->direct_access method rather
>> than the direct IO path, regardless of whether DAX is enabled on the
>> device or not.
>>
>> That really seems wrong to me - you've replace explicit "is DAX
>> enabled" checks with "is DAX possible" checks, and so DAX paths are
>> used regardless of whether DAX is enabled or not. And it's not
>> obvious why this is done, nor is it now obvious how DAX interacts
>> with the block device.
>>
>> This really seems like a step backwards to me.
>
> I think the reason it is not obvious is the original justification for
> the bypass as stated in commit bbab37ddc20b "block: Add support for
> DAX reads/writes to block devices" was:
>
>     "instead of allocating a DIO and a BIO"
>
> It turns out it's faster and as far as I can tell semantically
> equivalent to the __blockdev_direct_IO() path.  The DAX mmap path in
> comparison has plenty of sharp edges and semantic differences that
> would be avoided by turning off DAX.
>
> I'm not opposed to also turning off dax_do_io() when S_DAX is clear,
> but I don't currently see the point.  At the very least I need to add
> the above comments to the code, but do you still think opt-in DAX is a
> backwards step?

I thought of one way dax_do_io() breaks current semantics, it defeats
blktrace and i/o stat tracking.  I'll restore the existing behavior
that gates dax_do_io() on S_DAX.
