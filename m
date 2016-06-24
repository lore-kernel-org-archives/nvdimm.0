From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Date: Sat, 25 Jun 2016 09:00:45 +1000
Message-ID: <20160624230045.GG12670@dastard>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
 <20160623232446.GA12670@dastard>
 <20160624072612.GA22205@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160624072612.GA22205@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Jun 24, 2016 at 09:26:12AM +0200, Christoph Hellwig wrote:
> On Fri, Jun 24, 2016 at 09:24:46AM +1000, Dave Chinner wrote:
> > Except we did that *intentionally* - by definition there is no
> > cache to bypass with DAX and so all IO is "direct". That, combined
> > with the fact that all Linux filesystems except XFS break the POSIX
> > exclusive writer rule you are quoting to begin with, it seemed
> > pointless to enforce it for DAX....
> 
> No file system breaks the exclusive writer rule - most filesystem
> don't make writers atomic vs readers.
> 
> More importantly every other filesystem (well there only are ext2
> and ext4..) exludes DAX writers against other DAX writers.
> 
> > So, before taking any patches to change that behaviour in XFS, a
> > wider discussion about the policy needs to be had. I don't think
> > we should care about POSIX here - if you have an application that
> > needs this serialisation, turn off DAX. That's why I made it a
> > per-inode inheritable flag and why the mount option will go away
> > over time.
> 
> Sorry, but this is simply broken - allowing apps to opt-in behavior
> (e.g. like we're using O_DIRECT) is always fine.  Requriring
> filesystem-specific tuning that has affect outside the app to get
> existing documented behavior is not how to design APIs.

Using DAX is an *admin decision*, not an application decision.
Indeed, it's a mount option right now, and that's most definitely not
something the application can turn on or off! Inode flags allow the
admin to decide that two apps working on the same filesystem can use
(or not use) DAX independently, rather than needing to put them on
different filesystems.

> Maybe we'll need to opt-in to use DAX for mmap, but giving the same
> existing behavior for read and write and avoiding a copy to the pagecache
> is an obvious win.

You can't use DAX just for mmap. It's an inode scope behaviour -
once it's turned on, all accesses to that inode - regardless of user
interface - must use DAX. It's all or nothing, not a per file
descript/mmap context option.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
