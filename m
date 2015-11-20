Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151120040625.GI19199@dastard>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
	<20151117201614.15053.62376.stgit@dwillia2-desk3.jf.intel.com>
	<20151118150945.GE6097@quack.suse.cz>
	<1447892533.13153.8.camel@intel.com>
	<20151119125541.GC18581@quack.suse.cz>
	<CAPcyv4iGYPGz6n6YxdEWFJ4c0BZRXrWpa2188K2z9zz4_ez0TA@mail.gmail.com>
	<20151119231704.GG19199@dastard>
	<1447977911.20885.10.camel@intel.com>
	<20151120040625.GI19199@dastard>
Date: Thu, 19 Nov 2015 20:25:58 -0800
Message-ID: <CAA9_cmcNJK2GMmqE-Ss+P5TQMEE3CrViQ9JX77BC6nn8ihi_ag@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm, dax: truncate dax mappings at bdev or fs shutdown
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jack@suse.com" <jack@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 19, 2015 at 8:06 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Nov 20, 2015 at 12:05:11AM +0000, Williams, Dan J wrote:
>> On Fri, 2015-11-20 at 10:17 +1100, Dave Chinner wrote:
>> > Actually, I think we need to trigger a filesystem shutdown before
>> > doing anything else (e.g. before unmapping the inodes).That way the
>> > filesystem will error out new calls to get_blocks() and prevent any
>> > new IO submission while the block device teardown and inode
>> > unmapping is done. i.e. solving the problem at the block device
>> > level is hard, but we already have all the necessary infrastructure
>> > to shut off IO and new block mappings at the filesystem level....
>> >
>>
>> Shutting down the filesystem on block_device remove seems a more
>> invasive behavior change from what we've historically done.
>
> I've heard that so many times I figured that would be your answer.
> yet we've got a clear situation where we have a race between file
> level access and block device operations that is clearly solved by
> doing an upfront filesystem shutdown on unplug, but still the answer
> is "ignore the filesystem, we need to do everything in the block
> layer, no matter how hard or complex it is to solve"...

I was only disagreeing with your assertion that solving this
particular problem in the block layer was hard, and not asserting that
this needs to be solved in the block layer at all costs.

>>  I.e. a
>> best effort "let the fs struggle on to service whatever it can that is
>> not dependent on new disk I/O".
>
> And so we still have this limbo fs state that is an utter nightmare
> to handle sanely. We don't know what the cause of the IO error are
> and so we have to try to handle them as though we can recover in
> some way from the error. Only when we get an error we can't possibly
> recover from do we shut the fileystem down and then stop all
> attempts at issuing IO, mapping page faults, etc.
>
> However, if the device has been unplugged then we *can never
> recover* and so continuing on with out eyes closed and fingers in
> our eyes shouting 'lalalalalalala" as loud as we can won't change
> the fact that we are going to shut down the filesystem in the near
> future.
>

Can't argue with that, and XFS takes a lot longer to mourn the loss of
the block device than ext4.

What would be the recommended interface to tell XFS to sync if it can,
but give up quickly if it hits an error and then shutdown permanently?
