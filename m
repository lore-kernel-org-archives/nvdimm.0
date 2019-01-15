From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/5] kvm "virtio pmem" device
Date: Tue, 15 Jan 2019 00:35:06 -0500 (EST)
Message-ID: <1684638419.64320214.1547530506805.JavaMail.zimbra@redhat.com>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <1326478078.61913951.1547192704870.JavaMail.zimbra@redhat.com>
 <20190113232902.GD4205@dastard>
 <20190113233820.GX6310@bombadil.infradead.org>
 <942065073.64011540.1547450140670.JavaMail.zimbra@redhat.com>
 <20190114212501.GG4205@dastard>
 <CAPcyv4jtPcLV-s0sKNHwwk0ug7GLBV6699dpm1h3r2xSo879dg@mail.gmail.com>
 <20190114222132.GH4205@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190114222132.GH4205@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Qemu Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, adilger kernel <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, darrick wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Igor Mammedov <imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nitesh Narayan Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


> > > On Mon, Jan 14, 2019 at 02:15:40AM -0500, Pankaj Gupta wrote:
> > > >
> > > > > > Until you have images (and hence host page cache) shared between
> > > > > > multiple guests. People will want to do this, because it means they
> > > > > > only need a single set of pages in host memory for executable
> > > > > > binaries rather than a set of pages per guest. Then you have
> > > > > > multiple guests being able to detect residency of the same set of
> > > > > > pages. If the guests can then, in any way, control eviction of the
> > > > > > pages from the host cache, then we have a guest-to-guest
> > > > > > information
> > > > > > leak channel.
> > > > >
> > > > > I don't think we should ever be considering something that would
> > > > > allow a
> > > > > guest to evict page's from the host's pagecache [1].  The guest
> > > > > should
> > > > > be able to kick its own references to the host's pagecache out of its
> > > > > own pagecache, but not be able to influence whether the host or
> > > > > another
> > > > > guest has a read-only mapping cached.
> > > > >
> > > > > [1] Unless the guest is allowed to modify the host's file; obviously
> > > > > truncation, holepunching, etc are going to evict pages from the
> > > > > host's
> > > > > page cache.
> > > >
> > > > This is so correct. Guest does not not evict host page cache pages
> > > > directly.
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

First of all Thank you for all the useful discussions. 
I am summarizing here:

- We have to live with the limitation to not support fstrim and 
  mount -o discard options with virtio-pmem as they will evict 
  host page cache pages. We cannot allow this for virtio-pmem
  for security reasons. These filesystem commands will just zero out 
  unused pages currently.

- If alot of space is unused and not freed guest can request host 
  Administrator for truncating the host backing image. 
  We are also planning to support qcow2 sparse image format at 
  host side with virtio-pmem.

- There is no existing solution for Qemu persistent memory 
  emulation with write support currently. This solution provides 
  us the paravartualized way of emulating persistent memory. It 
  does not emulate of ACPI structures instead it just uses VIRTIO 
  for communication between guest & host. It is fast because of its
  asynchronous nature and it works well. This makes use of at guest 
  side libnvdimm API's 
  
- If disk size freeing problem with guest files trim truncate is 
  very important for users, they can still use real hardware which 
  will provide them both (advance disk features & page cache by pass).

Considering all the above reasons I think this feature is useful
from virtualization point of view. As Dave rightly said we should
be careful and I think now we are careful with the security implications
of this device. 

Thanks again for all the inputs.

Best regards,
Pankaj  


> 
> That's splitting some really fine hairs there...
> 
> > > > In case of virtio-pmem & DAX, guest clears guest page cache exceptional
> > > > entries.
> > > > Its solely decision of host to take action on the host page cache
> > > > pages.
> > > >
> > > > In case of virtio-pmem, guest does not modify host file directly i.e
> > > > don't
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
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
> 
