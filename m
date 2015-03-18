Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 18 Mar 2015 09:06:41 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Message-ID: <20150318130641.GD4003@linux.intel.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
 <550957B9.5050803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <550957B9.5050803@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, Al Viro <viro@ZenIV.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>, linux-arch@vger.kernel.org, riel@redhat.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 18, 2015 at 12:47:21PM +0200, Boaz Harrosh wrote:
> God! Look at this endless list of files and it is only the very beginning.
> It does not even work and touches only 10% of what will need to be touched
> for this to work, and very very marginally at that. There will always be
> "another subsystem" that will not work. For example NUMA how will you do
> NUMA aware pmem? and this is just a simple example. (I'm saying NUMA
> because our tests show a huge drop in performance if you do not do
> NUMA aware allocation)

You're very entertaining, but please, tone down your emails and stick
to facts.  The BIOS presents the persistent memory as one table entry
per NUMA node, so you get one block device per NUMA node.  There's no
mixing of memory from different NUMA nodes within a single filesystem,
unless you have a filesystem that uses multiple block devices.

> I'm not the one afraid of hard work, if it was for a good cause, but for what?
> really for what? The block layer, and RDMA, and networking, and spline, and what
> ever the heck any one wants to imagine to do with pmem, already works perfectly
> stable. right now!

The overhead.  Allocating a struct page for every 4k page in a 400GB DIMM
(the current capacity available from one NV-DIMM vendor) occupies 6.4GB.
That's an unacceptable amount of overhead.

