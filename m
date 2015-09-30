Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 30 Sep 2015 13:22:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150930032255.GF27164@dastard>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
 <20150925025357.GU3902@dastard>
 <20150926031745.GA560@linux.intel.com>
 <20150928005904.GY19114@dastard>
 <20150928224001.GA21955@linux.intel.com>
 <20150929024458.GC27164@dastard>
 <20150930020421.GA2417@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150930020421.GA2417@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 29, 2015 at 08:04:21PM -0600, Ross Zwisler wrote:
> On Tue, Sep 29, 2015 at 12:44:58PM +1000, Dave Chinner wrote:
> <>
> > Already testing a kernel with those reverted. My current DAX patch
> > stack is (bottom is first commit in stack):
> > 
> > f672ae4 xfs: add ->pfn_mkwrite support for DAX
> > 6855c23 xfs: remove DAX complete_unwritten callback
> > e074bdf Revert "dax: fix race between simultaneous faults"
> > 8ba0157 Revert "mm: take i_mmap_lock in unmap_mapping_range() for DAX"
> > a2ce6a5 xfs: DAX does not use IO completion callbacks
> > 246c52a xfs: update size during allocation for DAX
> > 9d10e7b xfs: Don't use unwritten extents for DAX
> > eaef807 xfs: factor out sector mapping.
> > e7f2d50 xfs: introduce per-inode DAX enablement
> 
> Dave, would you be willing to share these patches with me, even if they are
> just RFC?  I'm working through how to add equivalent support in both ext2 and
> ext4, and a conceptual example in XFS would be really helpful.

When I have code that works properly and isn't fundamentally broken,
I'll post it. Hopefully within the next day.

> Eric and Jan, if you guys have any spare cycles to help with the ext2/ext4
> bits, I certainly wouldn't say no.  :)

ext2 already does the block zeroing in allocation, so it only needs
locking help...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
