Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <55098DFE.8080502@plexistor.com>
Date: Wed, 18 Mar 2015 16:38:54 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [RFC PATCH 0/7] evacuate struct page from the
 block layer
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <550957B9.5050803@gmail.com> <20150318130641.GD4003@linux.intel.com>
In-Reply-To: <20150318130641.GD4003@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Boaz Harrosh <openosd@gmail.com>
Cc: axboe@kernel.dk, linux-arch@vger.kernel.org, riel@redhat.com, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, hch@infradead.org, Linus Torvalds <torvalds@osdl.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de
List-ID: <linux-nvdimm@lists.01.org>

On 03/18/2015 03:06 PM, Matthew Wilcox wrote:
> On Wed, Mar 18, 2015 at 12:47:21PM +0200, Boaz Harrosh wrote:
>> God! Look at this endless list of files and it is only the very beginning.
>> It does not even work and touches only 10% of what will need to be touched
>> for this to work, and very very marginally at that. There will always be
>> "another subsystem" that will not work. For example NUMA how will you do
>> NUMA aware pmem? and this is just a simple example. (I'm saying NUMA
>> because our tests show a huge drop in performance if you do not do
>> NUMA aware allocation)
> 
> You're very entertaining, but please, tone down your emails and stick
> to facts.  The BIOS presents the persistent memory as one table entry
> per NUMA node, so you get one block device per NUMA node.  There's no
> mixing of memory from different NUMA nodes within a single filesystem,
> unless you have a filesystem that uses multiple block devices.
> 

Not current BIOS, if we have them contiguous then they are presented as
one range. (DDR3 BIOS). But I agree it is a bug and in our configuration
we separate them to different pmem devices.

Yes I meant a "filesystem that uses multiple block devices"

>> I'm not the one afraid of hard work, if it was for a good cause, but for what?
>> really for what? The block layer, and RDMA, and networking, and spline, and what
>> ever the heck any one wants to imagine to do with pmem, already works perfectly
>> stable. right now!
> 
> The overhead.  Allocating a struct page for every 4k page in a 400GB DIMM
> (the current capacity available from one NV-DIMM vendor) occupies 6.4GB.
> That's an unacceptable amount of overhead.
> 

So lets fix the stacks to work nice with 2M pages. That said we can
allocate the struct page also from pmem if we need to. The fact remains
that we need state down the different stacks and this is the current
design over all.

I hate it that you introduce a double design a pfn-or-page and the
combinations of them. It is ugliness to much for my guts. I would
like a unified design. that runs all over the stack. Already we have
too much duplication to my taste, and would love to see more
unification and not more splitting.

But the most important for me is do we have to sacrifice the short
term to the long term. Such a massive change as you are proposing
it will take years. for a theoretical 400GB DIMM. What about the
4G DIMM now in peoples hands, need they wait?
(Though I still do not agree with your design)

I love the SPARSE model of the "section" and the page being it's
own identity relative to virtual & PFN of the section. We could
think of a much smaller page-struct that only takes a ref-count
and flags and have bigger page type for regular use, separate the
low common part of the page, lay down clear rules about its use,
and an high part that's per user. But let us think of a unified
design through out. (most members of page are accessed through
wrappers it would be relatively easy to split)

And let us not sacrifice the now for the "far tomorrow", we should
be able to do this incrementally, wasting more space now and saving
later.

[We can even invent a sizeless page you know how we encode
 the section ID directly into the 64 bit address of the page,
 So we can have a flag at the section that says this is a
 zero-size page section and the needed info is stored at
 the section object. But I still think you will need state
 per page and that we do need a minimal size.
]

[BTW: The only 400GB DIMM I know of is a real flash, and not directly
 mapped to CPU, OK maybe read only, but the erase/write makes it
 logical-to-physical managed and not directly accessed
]

And a personal note. I mean only to entertain. If any one feels
I "toned-up", please forgive me. I meant no such thing. As a rule
if I come across strong then please just laugh and don't take me
seriously. I only mean scientific soundness.

Thanks
Boaz

