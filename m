Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151021023847.GB19199@dastard>
References: <1445383903.6611.39.camel@intel.com>
	<20151021000103.GA19199@dastard>
	<CAPcyv4hBV=tsEmNajuMXr8Jj7-+ovT7FP3yWrfDLZVWejgA2ig@mail.gmail.com>
	<20151021023847.GB19199@dastard>
Date: Tue, 20 Oct 2015 20:17:56 -0700
Message-ID: <CAPcyv4gGdypCBQSCsY9ZkY+5PLKR74D26MNirCTvJCsFgcah5Q@mail.gmail.com>
Subject: Re: what's in nvdimm.git for v4.4?
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 20, 2015 at 7:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Oct 20, 2015 at 05:31:18PM -0700, Dan Williams wrote:
>> On Tue, Oct 20, 2015 at 5:01 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Tue, Oct 20, 2015 at 11:31:45PM +0000, Williams, Dan J wrote:
>> >> Here is a status summary of the topic-branches nvdimm.git is tracking
>> >> for v4.4.  Unless indicated these branches are not present in -next.
>> >> Please ACK, NAK, or ask for a re-post of any of the below to disposition
>> >> it for the merge window.
>> >>
>> >> ===
>> >> for-4.4/dax-fixes:
>> >> ===
>> > ...
>> >>         Dave Chinner (5):
>> >>               xfs: fix inode size update overflow in xfs_map_direct()
>> >>               xfs: introduce BMAPI_ZERO for allocating zeroed extents
>> >>               xfs: Don't use unwritten extents for DAX
>> >>               xfs: DAX does not use IO completion callbacks
>> >>               xfs: add ->pfn_mkwrite support for DAX
>> >
>> > Please drop these. They have not been reviewed yet, and because
>> > the changes affect more than just DAX (core XFS allocator
>> > functionality was changed) these need to go through the XFS tree.
>> >
>>
>> Ok, thanks for the heads up.  For the get_user_pages() patches that
>> build on these fixes I'm assuming your review bandwidth is in short
>> supply to also give an XFS sign-off on those changes for 4.4?
>
> I'm not aware of any other patches that touch XFS. AFAIA, you
> haven't cc'd anything to xfs@oss.sgi.com, so it's not on my radar...
>

I can cc xfs@oss.sgi.com on fs/dax.c changes going forward, but for
these I figure it was off topic since nothing touched fs/xfs/.

>> I'm wondering if we can take a conservative step forward with those
>> patches for 4.4.  if XFS and EXT4 interactions need more time to get
>> worked out, which I believe they do, I can conceive just turning on
>> get_user_pages() support for DAX-mappings of the raw block device.
>
> Regardless of the ext4/XFS status, isn't it a bit late to be
> proposing brand new stuff that nobody has had time to think about
> for the next merge window?
>

The "dax-for-raw-block support" is indeed new, but it's a fairly
straightforward extension of these patches that have been out for
review since 4.3-rc2, or 4.1-rc6 in the case of the pfn_t enabling.
Cutting out the filesystem interactions makes it that much simpler to
comprehend.
