Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Sun, 22 Nov 2015 08:32:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: drop file_update_time from ext4_dax_fault
Message-ID: <20151121213159.GJ19199@dastard>
References: <20151120001813.27997.41722.stgit@dwillia2-desk3.jf.intel.com>
 <20151120030344.GH19199@dastard>
 <CAA9_cmeEL2+w0Lj5RWT_cH6qUw6V36o1v17tpYYHJ-aRN0m7mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmeEL2+w0Lj5RWT_cH6qUw6V36o1v17tpYYHJ-aRN0m7mw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ted Ts'o <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ext4 hackers <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 19, 2015 at 08:39:06PM -0800, Dan Williams wrote:
> On Thu, Nov 19, 2015 at 7:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Nov 19, 2015 at 04:18:13PM -0800, Dan Williams wrote:
> >>  WARNING: CPU: 0 PID: 2133 at fs/fs-writeback.c:2065 __mark_inode_dirty+0x261/0x350()
> >>  bdi-block not registered
> >    ^^^^^^^^^^^^^^^^^^^^^^^^
> >>  [..]
> >>  Call Trace:
> >>   [<ffffffff81459f62>] dump_stack+0x44/0x62
> >>   [<ffffffff810a2052>] warn_slowpath_common+0x82/0xc0
> >>   [<ffffffff810a20ec>] warn_slowpath_fmt+0x5c/0x80
> >>   [<ffffffff812831a1>] __mark_inode_dirty+0x261/0x350
> >>   [<ffffffff8126d109>] generic_update_time+0x79/0xd0
> >>   [<ffffffff8126d28d>] file_update_time+0xbd/0x110
> >>   [<ffffffff812e4bc8>] ext4_dax_fault+0x68/0x110
> >>   [<ffffffff811f816e>] __do_fault+0x4e/0xf0
> >>   [<ffffffff811fc2a7>] handle_mm_fault+0x5e7/0x1b50
> >>   [<ffffffff811fbd11>] ? handle_mm_fault+0x51/0x1b50
> >>   [<ffffffff810689c1>] __do_page_fault+0x191/0x3f0
> >>   [<ffffffff81068cef>] trace_do_page_fault+0x4f/0x120
> >>   [<ffffffff8106314a>] do_async_page_fault+0x1a/0xa0
> >>   [<ffffffff81902678>] async_page_fault+0x28/0x30
> >
> > Doesn't this indicate some problem at the block/bdi level?
> > __mark_inode_dirty() should not throw warnings like this regardless
> > of where it is called from...
> >
> 
> I'll look closer at how the xfs path avoids triggering this...

XFS doesn't mark inodes dirty at the VFS level for inode metadata
changes - dirty metadata is tracked by the journalling subsystem,
not the VFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
