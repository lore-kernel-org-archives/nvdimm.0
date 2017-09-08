Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D4BE20945C13
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 02:46:04 -0700 (PDT)
Date: Fri, 8 Sep 2017 11:48:52 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170908094852.GA30332@quack2.suse.cz>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
 <20170907215148.GA12669@linux.intel.com>
 <20170907221201.GZ17782@dastard>
 <20170907221900.GB12669@linux.intel.com>
 <20170907232543.GB17782@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170907232543.GB17782@dastard>
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

On Fri 08-09-17 09:25:43, Dave Chinner wrote:
> On Thu, Sep 07, 2017 at 04:19:00PM -0600, Ross Zwisler wrote:
> > On Fri, Sep 08, 2017 at 08:12:01AM +1000, Dave Chinner wrote:
> > > On Thu, Sep 07, 2017 at 03:51:48PM -0600, Ross Zwisler wrote:
> > > > On Thu, Sep 07, 2017 at 03:26:10PM -0600, Andreas Dilger wrote:
> > > > > However, I wonder if this could
> > > > > be prevented at runtime, and only allow S_DAX to be set when the inode is
> > > > > first instantiated, and wouldn't be allowed to change after that?  Setting
> > > > > or clearing the per-inode DAX flag might still be allowed, but it wouldn't
> > > > > be enabled until the inode is next fetched into cache?  Similarly, for
> > > > > inodes that have conflicting features (e.g. inline data or encryption)
> > > > > would not be allowed to enable S_DAX.
> > > > 
> > > > Ooh, this seems interesting.  This would ensure that S_DAX transitions
> > > > couldn't ever race with I/Os or mmaps().  I had some other ideas for how to
> > > > handle this, but I think your idea is more promising. :)
> > > 
> > > IMO, that's an awful admin interface - it can't be done on demand
> > > (i.e. when needed) because we can't force an inode to be evicted
> > > from the cache. And then we have the "why the hell did that just
> > > change" problem if an inode is evicted due to memory pressure and
> > > then immediately reinstantiated by the running workload. That's a
> > > recipe for driving admins insane...
> > > 
> > > > I guess with this solution we'd need:
> > > > 
> > > > a) A good way of letting the user detect the state where they had set the DAX
> > > > inode flag, but that it wasn't yet in use by the inode.
> > > > 
> > > > b) A reliable way of flushing the inode from the filesystem cache, so that the
> > > > next time an open() happens they get the new behavior.  The way I usually do
> > > > this is via umount/remount, but there is probably already a way to do this?
> > > 
> > > Not if it's referenced. And if it's not referenced, then the only
> > > hammer we have is Brutus^Wdrop_caches. That's not an option for
> > > production machines.
> > > 
> > > Neat idea, but one I'd already thought of and discarded as "not
> > > practical from an admin perspective".
> > 
> > Okay, so other ideas (which you have also probably already though of) include:
> > 
> > 1) Just return -EBUSY if anyone tries to change the DAX flag of an inode with
> > open mappings or any open file handles.
> 
> You have to have an open fd to change the flag. :)

Yeah, open file handles don't matter and we can serialize against IO in
progress, that's not a big deal. Established mappings are difficult to deal
with.

> > To prevent TOCTOU races we'd have to
> > do some additional locking while actually changing the flag.
> 
> I think that make sense - the fundamental problem is that the
> mappings are different between dax and non-dax, and that we can't
> properly lock out page faults to to prevent sending a racing
> page fault down the wrong path.
> 
> > 2) Be more drastic and follow the flow of ext4 file based encryption, only
> > allowing the inode flag to be set by an admin on an empty directory.  Files in
> > that directory will inherit it when they are created, and we don't provide a
> > way to clear.  If you want your file to not use DAX, move it to a different
> > directory (which I think for ext4 encryption turns it into a new inode).
> 
> Seems like the wrong model to me - moving application data files
> is a PITA because you've also go to change the app config to point
> at the new location...

Agreed.

> > Other ideas?
> 
> IMO, we need to fix the page fault path so we don't look at inode
> flags to determine processing behaviour during the fault. Fault
> processing as DAX or non-dax needs to be determined by the page
> fault code and communicated to the fs via the vmf as the contents
> of the vmf for a dax fault can be invalid for a non-dax fault. Fixing
> that problem (i.e. make DAX is a property of the mapping and
> instantiate it from the inode only at mmap() time) means all the
> page fault vs inode flag race problems go away and we have a model
> that is much more robust if we want to expand it in future.

In fact, the real problem is only with .page_mkwrite and .pfn_mkwrite
callbacks. For those setup of 'vmf' differs. For .fault or .huge_fault the
vmf is the same regardless whether we do DAX or non-DAX fault. But it seems
difficult to me to determine DAX / non-DAX fault in vmf since locks
necessary to stabilize S_DAX flag are acquired only in filesystem-specific
handlers (and the locks themselves are fs specific).

So the only way I see of dealing safely with these races is careful
checking in .page_mkwrite and .pfn_mkwrite after necessary locks are
obtained and bail out doing nothing if state is inconsistent. VM will retry
the fault and we'll get to the correct handler next time.

But if we disallow any mappings when switching S_DAX flag, then all the
above is moot and there can be no races... We just have to be sure to block
new mappings of the file while switching the flag.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
