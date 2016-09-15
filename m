Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 15 Sep 2016 13:49:45 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
Message-ID: <20160915134945.0aaa4f5a@roar.ozlabs.ibm.com>
In-Reply-To: <20160915023133.GR22388@dastard>
References: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
 <20160908225636.GB15167@linux.intel.com>
 <20160912052703.GA1897@infradead.org>
 <CAOSf1CHaW=szD+YEjV6vcUG0KKr=aXv8RXomw9xAgknh_9NBFQ@mail.gmail.com>
 <20160912075128.GB21474@infradead.org>
 <20160912180507.533b3549@roar.ozlabs.ibm.com>
 <20160912213435.GD30497@dastard>
 <20160913115311.509101b0@roar.ozlabs.ibm.com>
 <20160914073902.GQ22388@dastard>
 <20160914201936.08315277@roar.ozlabs.ibm.com>
 <20160915023133.GR22388@dastard>
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

On Thu, 15 Sep 2016 12:31:33 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Sep 14, 2016 at 08:19:36PM +1000, Nicholas Piggin wrote:
> > On Wed, 14 Sep 2016 17:39:02 +1000
> > Dave Chinner <david@fromorbit.com> wrote:  
> > > Ok, looking back over your example, you seem to be suggesting a new
> > > page fault behaviour is required from filesystems that has not been
> > > described or explained, and that behaviour is triggered
> > > (persistently) somehow from userspace. You've also suggested
> > > filesystems store a persistent per-block "no fsync" flag
> > > in their extent map as part of the implementation. Right?  
> > 
> > This is what we're talking about. Of course a filesystem can't just
> > start supporting the feature without any changes.  
> 
> Sure, but one first has to describe the feature desired before all

The DAX people have been. They want to be able to get mappings
that can be synced without doing fsync. The *exact* extent of
those capabilities and what the API exactly looks like is up for
discussion.


> parties can discuss it. We need more than vague references and
> allusions from you to define the solution you are proposing.
> 
> Once everyone understands what is being describing, we might be able
> to work out how it can be implemented in a simple, generic manner
> rather than require every filesystem to change their on-disk
> formats. IOWs, we need you to describe /details/ of semantics,
> behaviour and data integrity constraints that are required, not
> describe an implementation of something we have no knwoledge about.

Well you said it was impossible already and Christoph told them
they were smoking crack :)

Anyway, there's a few questions. Implementation and API. Some
filesystems may never cope with it. Of course it should be as
generic as possible though.


> > > Reading between the lines, I'm guessing that the "no fsync" flag has
> > > very specific update semantics, constraints and requirements.  Can
> > > you outline how you expect this flag to be set and updated, how it's
> > > used consistently between different applications (e.g. cp of a file
> > > vs the app using the file), behavioural constraints it implies for
> > > page faults vs non-mmap access to the data in the block, how
> > > you'd expect filesystems to deal with things like a hole punch
> > > landing in the middle of an extent marked with "no fsync", etc?  
> > 
> > Well that's what's being discussed.  An approach close to what I did is
> > to allow the app request a "no sync" type of mmap.  
> 
> That's not an answer to the questions I asked about about the "no
> sync" flag you were proposing. You've redirected to the a different
> solution, one that ....

No sync flag would do the same thing exactly in terms of consistency.
It would just do the no-sync sequence by default rather than being
asked for it. More of an API detail than implementation.

> 
> > Filesystem will
> > invalidate all such mappings before it does buffered IOs or hole punch,
> > and will sync metadata after allocating a new block but before returning
> > from a fault.  
> 
> ... requires synchronous metadata updates from page fault context,
> which we already know is not a good solution.  I'll quote one of
> Christoph's previous replies to save me the trouble:
> 
> 	"You could write all metadata synchronously from the page
> 	fault handler, but that's basically asking for all kinds of
> 	deadlocks."
> So, let's redirect back to the "no sync" flag you were talking about
> - can you answer the questions I asked above? It would be especially
> important to highlight how the proposed feature would avoid requiring
> synchronous metadata updates in page fault contexts....

Right. So what deadlocks are you concerned about?

There could be a scale of capabilities here, for different filesystems
that do things differently. 

Some filesystems could require fsync for metadata, but allow fdatasync
to be skipped. Users would need to have some knowledge of block size
or do preallocation and sync.

That might put more burden on libraries/applications if there are
concurrent operations, but that might be something they can deal with
-- fdatasync already requires some knowledge of concurrent operations
(or lack thereof).


> > > [snip]
> > >   
> > > > If there is any huge complexity or unsolved problem, it is in XFS.
> > > > Conceptual problem is simple.    
> > > 
> > > Play nice and be constructive, please?  
> > 
> > So you agree that the persistent memory people who have come with some
> > requirements and ideas for an API should not be immediately shut down
> > with bogus handwaving.  
> 
> Pull your head in, Nick.
> 
> You've been absent from the community for the last 5 years. You
> suddenly barge in with a massive chip on your shoulder and try to

I'm trying to give some constructive input to the nvdimm guys.

You and Christoph know a huge amount about vfs and filesystems.
But sometimes you shut people down prematurely. It can be very
intimidating for someone who might not know *exactly* what they
are asking for or have not considered some difficult locking case
in a filesystem. I'm sure it's not intentional, but that's how it
can come across.

That said, I don't want to derail their thread any further with
this. So I apologise for my tone to you, Dave.

Thanks,
Nick
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
