Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 12 Jan 2016 10:31:02 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: xfs over pmem - cp performance
Message-ID: <20160112173102.GA10519@linux.intel.com>
References: <94D0CD8314A33A4D9D801C0FE68B40295BF0881D@G4W3202.americas.hpqcorp.net>
 <20160108220328.GB10456@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160108220328.GB10456@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jan 09, 2016 at 09:03:28AM +1100, Dave Chinner wrote:
> On Fri, Jan 08, 2016 at 09:07:27PM +0000, Elliott, Robert (Persistent Memory) wrote:
> > I tried using cp to copy the linux git tree between
> > pmem devices like this:
> >                 cp -r /mnt/xfs-pmem1/linux /mnt/xfs-pmem2
> > 
> > The time taken by various filesystems varies (4.4-rc5):
> > * xfs    w/dax: 42 s
> > * xfs   no dax: 14 s
> > * ext4   w/dax:  7 s
> > * ext4  no dax: 15 s
> > * btrfs no dax: 18 s
> 
> Yes, we know.
> 
> > mount options:
> > * /dev/pmem1 on /mnt/xfs-pmem1 type xfs (rw,relatime,seclabel,attr2,dax,inode64,noquota)
> > * /dev/pmem1 on /mnt/ext4-pmem1 type ext4 (rw,relatime,seclabel,dax,data=ordered)
> > * /dev/pmem1 on /mnt/btrfs-pmem1 type btrfs (rw,relatime,seclabel,ssd,space_cache,subvolid=5,subvol=/)
> > 
> > xfs with dax spends most of the time in clear_page_c_e and
> > dax-clear_blocks (from "perf top"): 
> >   30.06%  [kernel]            [k] clear_page_c_e        
> >   12.24%  [kernel]            [k] dax_clear_blocks      
> 
> That's where the difference is - XFS is zeroing the blocks during
> allocation so that we know that a failed write or crash during a
> write will not expose stale data to the user. I've made comment
> about this previously here:
> 
> http://oss.sgi.com/archives/xfs/2015-11/msg00021.html
> 
> and it's a result of the current "everything is synchronous" DAX cpu
> cache control behaviour.
> 
> I think it's worth noting that ext4 is not spending any time
> zeroing the blocks during allocation, which I think means that it
> can expose stale data as a result of a crash or partial write....

Jan's patch series that does the zeroing for newly allocated blocks in ext4
hasn't been merged yet, and is queued for v4.5 inclusion:

https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/log/

My guess is that once this set is included the ext4 overhead for block zeroing
will go up.  If you're testing v4.4 code the zeroing for newly allocated
blocks with ext4 is still happening inside of DAX.

> We're working on fixing this, but it needs all the fsync patches
> from Ross to enable us to turn off the synchronous cache flushes
> in the DAX IO code.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
