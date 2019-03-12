Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 12 Mar 2019 15:37:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hang / zombie process from Xarray page-fault conversion
 (bisected)
Message-ID: <20190312043754.GD23020@dastard>
References: <CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail.gmail.com>
 <20190311150947.GD19508@bombadil.infradead.org>
 <CAPcyv4jG5r2LOesxSx+Mdf+L_gQWqnhk+gKZyKAAPTHy1Drvqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jG5r2LOesxSx+Mdf+L_gQWqnhk+gKZyKAAPTHy1Drvqw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Barror, Robert" <robert.barror@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 11, 2019 at 08:35:05PM -0700, Dan Williams wrote:
> On Mon, Mar 11, 2019 at 8:10 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Mar 07, 2019 at 10:16:17PM -0800, Dan Williams wrote:
> > > Hi Willy,
> > >
> > > We're seeing a case where RocksDB hangs and becomes defunct when
> > > trying to kill the process. v4.19 succeeds and v4.20 fails. Robert was
> > > able to bisect this to commit b15cd800682f "dax: Convert page fault
> > > handlers to XArray".
> > >
> > > I see some direct usage of xa_index and wonder if there are some more
> > > pmd fixups to do?
> > >
> > > Other thoughts?
> >
> > I don't see why killing a process would have much to do with PMD
> > misalignment.  The symptoms (hanging on a signal) smell much more like
> > leaving a locked entry in the tree.  Is this easy to reproduce?  Can you
> > get /proc/$pid/stack for a hung task?
> 
> It's fairly easy to reproduce, I'll see if I can package up all the
> dependencies into something that fails in a VM.
> 
> It's limited to xfs, no failure on ext4 to date.
> 
> The hung process appears to be:
> 
>      kworker/53:1-xfs-sync/pmem0

That's completely internal to XFS. Every 30s the work is triggered
and it either does a log flush (if the fs is active) or it syncs the
superblock to clean the log and idle the filesystem. It has nothing
to do with user processes, and I don't see why killing a process has
any effect on what it does...

> ...and then the rest of the database processes grind to a halt from there.
> 
> Robert was kind enough to capture /proc/$pid/stack, but nothing interesting:
> 
> [<0>] worker_thread+0xb2/0x380
> [<0>] kthread+0x112/0x130
> [<0>] ret_from_fork+0x1f/0x40
> [<0>] 0xffffffffffffffff

Much more useful would be:

# echo w > /proc/sysrq-trigger

And post the entire output of dmesg.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
