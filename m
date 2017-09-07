Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
 [150.101.137.131])
 by ml01.01.org (Postfix) with ESMTP id 175FF21D492E6
 for <linux-nvdimm@lists.01.org>; Thu,  7 Sep 2017 15:09:13 -0700 (PDT)
Date: Fri, 8 Sep 2017 08:12:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170907221201.GZ17782@dastard>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
 <20170907215148.GA12669@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170907215148.GA12669@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 07, 2017 at 03:51:48PM -0600, Ross Zwisler wrote:
> On Thu, Sep 07, 2017 at 03:26:10PM -0600, Andreas Dilger wrote:
> > However, I wonder if this could
> > be prevented at runtime, and only allow S_DAX to be set when the inode is
> > first instantiated, and wouldn't be allowed to change after that?  Setting
> > or clearing the per-inode DAX flag might still be allowed, but it wouldn't
> > be enabled until the inode is next fetched into cache?  Similarly, for
> > inodes that have conflicting features (e.g. inline data or encryption)
> > would not be allowed to enable S_DAX.
> 
> Ooh, this seems interesting.  This would ensure that S_DAX transitions
> couldn't ever race with I/Os or mmaps().  I had some other ideas for how to
> handle this, but I think your idea is more promising. :)

IMO, that's an awful admin interface - it can't be done on demand
(i.e. when needed) because we can't force an inode to be evicted
from the cache. And then we have the "why the hell did that just
change" problem if an inode is evicted due to memory pressure and
then immediately reinstantiated by the running workload. That's a
recipe for driving admins insane...

> I guess with this solution we'd need:
> 
> a) A good way of letting the user detect the state where they had set the DAX
> inode flag, but that it wasn't yet in use by the inode.
> 
> b) A reliable way of flushing the inode from the filesystem cache, so that the
> next time an open() happens they get the new behavior.  The way I usually do
> this is via umount/remount, but there is probably already a way to do this?

Not if it's referenced. And if it's not referenced, then the only
hammer we have is Brutus^Wdrop_caches. That's not an option for
production machines.

Neat idea, but one I'd already thought of and discarded as "not
practical from an admin perspective".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
