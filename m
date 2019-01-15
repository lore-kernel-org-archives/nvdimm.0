From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 0/5] kvm "virtio pmem" device
Date: Mon, 14 Jan 2019 21:19:09 -0500
Message-ID: <20190114205031-mutt-send-email-mst@kernel.org>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190110012617.GA4205@dastard>
 <1326478078.61913951.1547192704870.JavaMail.zimbra@redhat.com>
 <20190113232902.GD4205@dastard>
 <20190113233820.GX6310@bombadil.infradead.org>
 <942065073.64011540.1547450140670.JavaMail.zimbra@redhat.com>
 <20190114212501.GG4205@dastard>
 <CAPcyv4jtPcLV-s0sKNHwwk0ug7GLBV6699dpm1h3r2xSo879dg@mail.gmail.com>
 <20190114222132.GH4205@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190114222132.GH4205@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Pankaj Gupta <pagupta@redhat.com>, Matthew Wilcox <willy@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Rik van Riel <riel@surriel.com>, Nitesh Narayan Lal <nilal@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Ross Zwisler <zwisler@kernel.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Jan 15, 2019 at 09:21:32AM +1100, Dave Chinner wrote:
> On Mon, Jan 14, 2019 at 01:35:57PM -0800, Dan Williams wrote:
> > On Mon, Jan 14, 2019 at 1:25 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Mon, Jan 14, 2019 at 02:15:40AM -0500, Pankaj Gupta wrote:
> > > >
> > > > > > Until you have images (and hence host page cache) shared between
> > > > > > multiple guests. People will want to do this, because it means they
> > > > > > only need a single set of pages in host memory for executable
> > > > > > binaries rather than a set of pages per guest. Then you have
> > > > > > multiple guests being able to detect residency of the same set of
> > > > > > pages. If the guests can then, in any way, control eviction of the
> > > > > > pages from the host cache, then we have a guest-to-guest information
> > > > > > leak channel.
> > > > >
> > > > > I don't think we should ever be considering something that would allow a
> > > > > guest to evict page's from the host's pagecache [1].  The guest should
> > > > > be able to kick its own references to the host's pagecache out of its
> > > > > own pagecache, but not be able to influence whether the host or another
> > > > > guest has a read-only mapping cached.
> > > > >
> > > > > [1] Unless the guest is allowed to modify the host's file; obviously
> > > > > truncation, holepunching, etc are going to evict pages from the host's
> > > > > page cache.
> > > >
> > > > This is so correct. Guest does not not evict host page cache pages directly.
> > >
> > > They don't right now.
> > >
> > > But someone is going to end up asking for discard to work so that
> > > the guest can free unused space in the underlying spares image (i.e.
> > > make use of fstrim or mount -o discard) because they have workloads
> > > that have bursts of space usage and they need to trim the image
> > > files afterwards to keep their overall space usage under control.
> > >
> > > And then....
> > 
> > ...we reject / push back on that patch citing the above concern.
> 
> So at what point do we draw the line?
> 
> We're allowing writable DAX mappings, but as I've pointed out that
> means we are going to be allowing  a potential information leak via
> files with shared extents to be directly mapped and written to.
> 
> But we won't allow useful admin operations that allow better
> management of host side storage space similar to how normal image
> files are used by guests because it's an information leak vector?
> 
> That's splitting some really fine hairs there...

May I summarize that th security implications need to
be documented?

In fact that would make a fine security implications section
in the device specification.





> > > > In case of virtio-pmem & DAX, guest clears guest page cache exceptional entries.
> > > > Its solely decision of host to take action on the host page cache pages.
> > > >
> > > > In case of virtio-pmem, guest does not modify host file directly i.e don't
> > > > perform hole punch & truncation operation directly on host file.
> > >
> > > ... this will no longer be true, and the nuclear landmine in this
> > > driver interface will have been armed....
> > 
> > I agree with the need to be careful when / if explicit cache control
> > is added, but that's not the case today.
> 
> "if"?
> 
> I expect it to be "when", not if. Expect the worst, plan for it now.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
