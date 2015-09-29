Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150929021807.GB27164@dastard>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
	<20150924025225.GT3902@dastard>
	<20150924155029.GA6008@linux.intel.com>
	<20150925025357.GU3902@dastard>
	<20150926031745.GA560@linux.intel.com>
	<20150928005904.GY19114@dastard>
	<CAPcyv4jfT2fvYPGFBgxynNAvJ4KoKX=_TZbpB4ieTQV25mmFkQ@mail.gmail.com>
	<20150928213548.GX3902@dastard>
	<CAPcyv4i2Bu1EsVrVkJpN8LUgoD+H5f+REBiEk-eoF=8xBJpL_g@mail.gmail.com>
	<20150929021807.GB27164@dastard>
Date: Mon, 28 Sep 2015 20:08:13 -0700
Message-ID: <CAA9_cmf7e+Ggo1UfrNZ_aFDqpT6zmbgM_qscyDSzFUvhRZGpCQ@mail.gmail.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 28, 2015 at 7:18 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Sep 28, 2015 at 03:57:29PM -0700, Dan Williams wrote:
>> On Mon, Sep 28, 2015 at 2:35 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Sep 28, 2015 at 05:13:50AM -0700, Dan Williams wrote:
>> >> On Sun, Sep 27, 2015 at 5:59 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > On Fri, Sep 25, 2015 at 09:17:45PM -0600, Ross Zwisler wrote:
>> >> >> On Fri, Sep 25, 2015 at 12:53:57PM +1000, Dave Chinner wrote:
>> >> [..]
>> >> >> Does this sound like a reasonable path forward for v4.3?  Dave, and Jan, can
>> >> >> you guys can provide guidance and code reviews for the XFS and ext4 bits?
>> >> >
>> >> > IMO, it's way too much to get into 4.3. I'd much prefer we revert
>> >> > the bad changes in 4.3, and then work towards fixing this for the
>> >> > 4.4 merge window. If someone needs this for 4.3, then they can
>> >> > backport the 4.4 code to 4.3-stable.
>> >> >
>> >>
>> >> If the proposal is to step back and get a running start at these fixes
>> >> for 4.4, then it is worth considering what the state of allocating
>> >> pages for DAX mappings will be in 4.4.
>> >
>> > Oh, do tell. I haven't seen any published design, code, etc,
>>
>> This is via the devm_memremap_pages() api that went into 4.2 [1] and
>> my v1 (RFC quality) series using it for dax get_user_pages() [2].
>>
>> [1]: https://lkml.org/lkml/2015/8/25/841
>> [2]: https://lkml.org/lkml/2015/9/23/11
>
> I'll have a look at some point when I'm not trying to put out fires.
>
>> > And, quite frankly, I'm not enabling any new DAX behaviour/subsystem
>> > in XFS until I've had time to review, test and fix it so it works
>> > without deadlocking or corrupting data.
>>
>> I'm in violent agreement, to the point where I'm pondering whether
>> CONFIG_FS_DAX should just depend on CONFIG_BROKEN in 4.3 until we've
>> convinced ourselves of all the fixes in 4.4.  It's not clear to me
>> that we have a stable baseline to which we can revert this "still in
>> development" implementation, did you have one in mind?
>
> XFS warns that DAX is experimental when you mount with that option,
> so there is no need to do that:
>
> [  686.055780] XFS (ram0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [  686.058464] XFS (ram0): Mounting V5 Filesystem
> [  686.062857] XFS (ram0): Ending clean mount

Well that is comforting, although a similar warning is missing from
ext4.  I'll send a patch.

>> >> It's already that case that
>> >> allocating struct page for DAX mappings is the only solution on the
>> >> horizon for enabling a get_user_pages() solution for persistent
>> >> memory.  We of course need to get the page-less DAX path fixed up, but
>> >> the near-term path to full functionality and safety is when struct
>> >> page is available to enable the typical synchronization mechanics.
>> >
>> > And we do so at the expense of medium to long term complexity and
>> > maintenance. I'm no fan of using struct pages to track terabytes to
>> > petabytes of persistent memory, and I'm even less of a fan of having
>> > to simultaneously support both struct page and pfn based DAX
>> > subsystems...
>>
>> I'm no fan of tracking petabytes of persistent memory with struct
>> page, but we're in the near term space (hardware technology-wise) of
>> how to enable DMA/RDMA to 100s of gigabytes to a few terabytes of
>> persistent memory.
>
> Don't think I don't know that - as I said to someone a few hours
> ago on IRC:
>
> [29/09/15 07:41] <dchinner> I'm sure they do, but they have a hard requirement to support RDMA from persistent memory
> [29/09/15 07:41] <dchinner> and that's what seems to be driving the "we need to use struct pages" design

Fair enough...

>> A page-less solution to that problem is not on the
>> horizon as far as I can tell.  In short, I am concerned we are
>> spending time working around the lack of struct page to get to a
>> stable page-less solution that is still missing support for the use
>> cases that are expected to "just work".
>
> I'm concerned with making what we have work before we go and change
> everything. You might want to move really quickly, but without sane
> filesystem support you can't ship anything worth a damn. There's all
> sorts of issues here, and introducing struct pages doesn't solve all
> of them.
>
> Let's concentrate on ensuring the basic operation of DAX is robust
> first - get the page fault vs extent manipulations serialised, sane
> and scalable before we start changing anything else. If we don't
> solve these problems, then nothing else we do will be reliable, and
> the problems exist regardless of whether we are using struct pages
> or not. Hence these are the critical problems we need to fix before
> anything else.
>
> Once we have these issues sorted out, switching between struct page
> and pfn should be much simpler because we don't have to worry about
> different locking strategies to protect against truncate, racing
> page faults, etc.

It sounds like you have a page-independent/scalable method in mind for
solving the truncate protection problem?  I had always thought that
must require struct page, but if you're happy to carry that solution
in the filesystem you're not going to see resistance from me.

>> I do not think introducing page-back persistent memory sets us back to
>> square 1.  Instead, given the functionality that is enabled when pages
>> are present I think it is safe to assume most platforms will arrange
>> for page backed persistent memory.
>
> Sure, but it will take a little time to get there. Moving fast
> doesn't help us here - it only results in stuff we have to revert or
> redo in the near future and that means progress is much slower than
> it should be. Let's solve the DAX problems in the right order - it
> will make things simpler and faster down the road.

Sounds workable, although this thread is missing an ext4
representative so far.  Hopefully ext4 is equally open to solving
these problems generically without struct page.

Outside of that there's also basic device driver lifetime fixes in the
get_user_pages() series (patches 8-10) that are 4.4 material to stop
the trivial breakage from unbinding the pmem driver regardless of when
we decide to stage the others.

In any event, thanks for the attention and patience, Dave, much appreciated.
