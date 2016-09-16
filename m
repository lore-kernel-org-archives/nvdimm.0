Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 16 Sep 2016 15:54:05 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
Message-ID: <20160916155405.6b634bbc@roar.ozlabs.ibm.com>
In-Reply-To: <20160915223350.GU22388@dastard>
References: <20160912075128.GB21474@infradead.org>
 <20160912180507.533b3549@roar.ozlabs.ibm.com>
 <20160912213435.GD30497@dastard>
 <20160913115311.509101b0@roar.ozlabs.ibm.com>
 <20160914073902.GQ22388@dastard>
 <20160914201936.08315277@roar.ozlabs.ibm.com>
 <20160915023133.GR22388@dastard>
 <20160915134945.0aaa4f5a@roar.ozlabs.ibm.com>
 <20160915103210.GT22388@dastard>
 <20160915214222.505f4888@roar.ozlabs.ibm.com>
 <20160915223350.GU22388@dastard>
MIME-Version: 1.0
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
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, KVM list <kvm@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Gleb Natapov <gleb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 16 Sep 2016 08:33:50 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Sep 15, 2016 at 09:42:22PM +1000, Nicholas Piggin wrote:
> > On Thu, 15 Sep 2016 20:32:10 +1000
> > Dave Chinner <david@fromorbit.com> wrote:  
> > > 
> > > You still haven't described anything about what a per-block flag
> > > design is supposed to look like.... :/  
> > 
> > For the API, or implementation? I'm not quite sure what you mean
> > here. For implementation it's possible to carefully ensure metadata
> > is persistent when allocating blocks in page fault but before
> > mapping pages. Truncate or hole punch or such things can be made to
> > work by invalidating all such mappings and holding them off until
> > you can cope with them again. Not necessarily for a filesystem with
> > *all* capabilities of XFS -- I don't know -- but for a complete basic
> > one.  
> 
> SO, essentially, it comes down to synchrnous metadta updates again.

Yes. I guess fundamentally you can't get away from either that or
preloading at some level.

(Also I don't know that there's a sane way to handle [cm]time properly,
so some things like that -- this is just about block allocation /
avoiding fdatasync).

> but synchronous updates would be conditional on whether an extent
> metadata with the "nofsync" flag asserted was updated? Where's the
> nofsync flag kept? in memory at a generic layer, or in the
> filesystem, potentially in an on-disk structure? How would the
> application set it for a given range?

I guess that comes back to the API. Whether you want it to be persistent,
request based, etc. It could be derived type of storage blocks that are
mapped there, stored per-inode, in-memory, or on extents on disk. I'm not
advocating for a particular API and of course less complexity better.

> 
> > > > > > Filesystem will
> > > > > > invalidate all such mappings before it does buffered IOs or hole punch,
> > > > > > and will sync metadata after allocating a new block but before returning
> > > > > > from a fault.      
> > > > > 
> > > > > ... requires synchronous metadata updates from page fault context,
> > > > > which we already know is not a good solution.  I'll quote one of
> > > > > Christoph's previous replies to save me the trouble:
> > > > > 
> > > > > 	"You could write all metadata synchronously from the page
> > > > > 	fault handler, but that's basically asking for all kinds of
> > > > > 	deadlocks."
> > > > > So, let's redirect back to the "no sync" flag you were talking about
> > > > > - can you answer the questions I asked above? It would be especially
> > > > > important to highlight how the proposed feature would avoid requiring
> > > > > synchronous metadata updates in page fault contexts....    
> > > > 
> > > > Right. So what deadlocks are you concerned about?    
> > > 
> > > It basically puts the entire journal checkpoint path under a page
> > > fault context. i.e. a whole new global locking context problem is  
> > 
> > Yes there are potentially some new lock orderings created if you
> > do that, depending on what locks the filesystem does.  
> 
> Well, that's the whole issue.

For filesystem implementations, but perhaps not mm/vfs implemenatation
AFAIKS.

> 
> > > created as this path can now be run both inside and outside the
> > > mmap_sem. Nothing ever good comes from running filesystem locking
> > > code both inside and outside the mmap_sem.  
> > 
> > You mean that some cases journal checkpoint runs with mmap_sem
> > held, and others without mmap_sem held? Not that mmap_sem is taken
> > inside journal checkpoint.  
> 
> Maybe not, but now we open up the potential for locks held inside
> or outside mmap sem to interact with the journal locks that are now
> held inside and outside mmap_sem. See below....
> 
> > Then I don't really see why that's a
> > problem. I mean performance could suffer a bit, but with fault
> > retry you can almost always do the syncing outside mmap_sem in
> > practice.
> > 
> > Yes, I'll preemptively agree with you -- We don't want to add any
> > such burden if it is not needed and well justified.
> >   
> > > FWIW, We've never executed synchronous transactions inside page
> > > faults in XFS, and I think ext4 is in the same boat - it may be even
> > > worse because of the way it does ordered data dispatch through the
> > > journal. I don't really even want to think about the level of hurt
> > > this might put btrfs or other COW/log structured filesystems under.
> > > I'm sure Christoph can reel off a bunch more issues off the top of
> > > his head....  
> > 
> > I asked him, we'll see what he thinks. I don't beleive there is
> > anything fundamental about mm or fs core layers that cause deadlocks
> > though.  
> 
> Spent 5 minutes looking at ext4 for an example: filesystems are
> allowed to take page locks during transaction commit. e.g ext4
> journal commit when using the default ordered data mode:
> 
> jbd2_journal_commit_transaction
>   journal_submit_data_buffers()
>     journal_submit_inode_data_buffers
>       generic_writepages()
>         ext4_writepages()
> 	  mpage_prepare_extent_to_map()
> 	    lock_page()
> 
> i.e. if we fault on the user buffer during a write() operation and
> that user buffer is a mmapped DAX file that needs to be allocated
> and we have synchronous metadata updates during page faults, we
> deadlock on the page lock held above the page fault context...

Yeah, page lock is probably bigger issue for filesystems than
mmap_sem. But still is filesystem implementation detail. Again,
I'm not suggesting you could just switch all filesystems today
to do a metadata sync with mmap sem and page lock held. Only that
there aren't fundamental deadlocks enforced by the mm/vfs.

Filesystems are already taking metadata page locks in the read path
while holding data page lock, so there's long been some amount of
nesting of page lock.

It would be possible to change the page fault handler to allow a
sync without holding page lock too if it came to it. But I don't
want to go to far about implementation handwaving before it's even
established that this would be worthwhile.

Definitely the first step would be your simple preallocated per
inode approach until it is shown to be insufficient.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
