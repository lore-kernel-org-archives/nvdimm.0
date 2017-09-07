Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52EDE21D492E4
 for <linux-nvdimm@lists.01.org>; Thu,  7 Sep 2017 15:16:10 -0700 (PDT)
Date: Thu, 7 Sep 2017 16:19:00 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170907221900.GB12669@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
 <20170907215148.GA12669@linux.intel.com>
 <20170907221201.GZ17782@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170907221201.GZ17782@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 08, 2017 at 08:12:01AM +1000, Dave Chinner wrote:
> On Thu, Sep 07, 2017 at 03:51:48PM -0600, Ross Zwisler wrote:
> > On Thu, Sep 07, 2017 at 03:26:10PM -0600, Andreas Dilger wrote:
> > > However, I wonder if this could
> > > be prevented at runtime, and only allow S_DAX to be set when the inode is
> > > first instantiated, and wouldn't be allowed to change after that?  Setting
> > > or clearing the per-inode DAX flag might still be allowed, but it wouldn't
> > > be enabled until the inode is next fetched into cache?  Similarly, for
> > > inodes that have conflicting features (e.g. inline data or encryption)
> > > would not be allowed to enable S_DAX.
> > 
> > Ooh, this seems interesting.  This would ensure that S_DAX transitions
> > couldn't ever race with I/Os or mmaps().  I had some other ideas for how to
> > handle this, but I think your idea is more promising. :)
> 
> IMO, that's an awful admin interface - it can't be done on demand
> (i.e. when needed) because we can't force an inode to be evicted
> from the cache. And then we have the "why the hell did that just
> change" problem if an inode is evicted due to memory pressure and
> then immediately reinstantiated by the running workload. That's a
> recipe for driving admins insane...
> 
> > I guess with this solution we'd need:
> > 
> > a) A good way of letting the user detect the state where they had set the DAX
> > inode flag, but that it wasn't yet in use by the inode.
> > 
> > b) A reliable way of flushing the inode from the filesystem cache, so that the
> > next time an open() happens they get the new behavior.  The way I usually do
> > this is via umount/remount, but there is probably already a way to do this?
> 
> Not if it's referenced. And if it's not referenced, then the only
> hammer we have is Brutus^Wdrop_caches. That's not an option for
> production machines.
> 
> Neat idea, but one I'd already thought of and discarded as "not
> practical from an admin perspective".

Okay, so other ideas (which you have also probably already though of) include:

1) Just return -EBUSY if anyone tries to change the DAX flag of an inode with
open mappings or any open file handles.  To prevent TOCTOU races we'd have to
do some additional locking while actually changing the flag.

2) Be more drastic and follow the flow of ext4 file based encryption, only
allowing the inode flag to be set by an admin on an empty directory.  Files in
that directory will inherit it when they are created, and we don't provide a
way to clear.  If you want your file to not use DAX, move it to a different
directory (which I think for ext4 encryption turns it into a new inode).

Other ideas?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
