From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v3 0/5] kvm "virtio pmem" device
Date: Wed, 16 Jan 2019 07:42:23 +1100
Message-ID: <20190115204222.GK4205@dastard>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <1326478078.61913951.1547192704870.JavaMail.zimbra@redhat.com>
 <20190113232902.GD4205@dastard>
 <20190113233820.GX6310@bombadil.infradead.org>
 <942065073.64011540.1547450140670.JavaMail.zimbra@redhat.com>
 <20190114212501.GG4205@dastard>
 <CAPcyv4jtPcLV-s0sKNHwwk0ug7GLBV6699dpm1h3r2xSo879dg@mail.gmail.com>
 <20190114222132.GH4205@dastard>
 <1684638419.64320214.1547530506805.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1684638419.64320214.1547530506805.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Qemu Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, adilger kernel <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, darrick wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Igor Mammedov <imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nitesh Narayan Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Jan 15, 2019 at 12:35:06AM -0500, Pankaj Gupta wrote:
> 
> > > > On Mon, Jan 14, 2019 at 02:15:40AM -0500, Pankaj Gupta wrote:
> > > > >
> > > > > > > Until you have images (and hence host page cache) shared between
> > > > > > > multiple guests. People will want to do this, because it means they
> > > > > > > only need a single set of pages in host memory for executable
> > > > > > > binaries rather than a set of pages per guest. Then you have
> > > > > > > multiple guests being able to detect residency of the same set of
> > > > > > > pages. If the guests can then, in any way, control eviction of the
> > > > > > > pages from the host cache, then we have a guest-to-guest
> > > > > > > information
> > > > > > > leak channel.
> > > > > >
> > > > > > I don't think we should ever be considering something that would
> > > > > > allow a
> > > > > > guest to evict page's from the host's pagecache [1].  The guest
> > > > > > should
> > > > > > be able to kick its own references to the host's pagecache out of its
> > > > > > own pagecache, but not be able to influence whether the host or
> > > > > > another
> > > > > > guest has a read-only mapping cached.
> > > > > >
> > > > > > [1] Unless the guest is allowed to modify the host's file; obviously
> > > > > > truncation, holepunching, etc are going to evict pages from the
> > > > > > host's
> > > > > > page cache.
> > > > >
> > > > > This is so correct. Guest does not not evict host page cache pages
> > > > > directly.
> > > >
> > > > They don't right now.
> > > >
> > > > But someone is going to end up asking for discard to work so that
> > > > the guest can free unused space in the underlying spares image (i.e.
> > > > make use of fstrim or mount -o discard) because they have workloads
> > > > that have bursts of space usage and they need to trim the image
> > > > files afterwards to keep their overall space usage under control.
> > > >
> > > > And then....
> > > 
> > > ...we reject / push back on that patch citing the above concern.
> > 
> > So at what point do we draw the line?
> > 
> > We're allowing writable DAX mappings, but as I've pointed out that
> > means we are going to be allowing  a potential information leak via
> > files with shared extents to be directly mapped and written to.
> > 
> > But we won't allow useful admin operations that allow better
> > management of host side storage space similar to how normal image
> > files are used by guests because it's an information leak vector?
> 
> First of all Thank you for all the useful discussions. 
> I am summarizing here:
> 
> - We have to live with the limitation to not support fstrim and 
>   mount -o discard options with virtio-pmem as they will evict 
>   host page cache pages. We cannot allow this for virtio-pmem
>   for security reasons. These filesystem commands will just zero out 
>   unused pages currently.

Not sure I follow you here - what pages are going to be zeroed and
when will they be zeroed? If discard is not allowed, filesystems
just don't issue such commands and the underlying device will never
seen them.

> - If alot of space is unused and not freed guest can request host 
>   Administrator for truncating the host backing image. 

You can't use truncate to free space in a disk image file. The only
way to do it safely in a generic, filesystem agnositic way is to
mount the disk image (e.g. on loopback) and run fstrim on it. The
loopback device will punches holes in the file where all the free
space is reported by the filesystem via discard requests.

Which is kinda my point - this could only be done if the guest is
shut down, which makes it very difficult for admins to manage. 

>   We are also planning to support qcow2 sparse image format at 
>   host side with virtio-pmem.

So you're going to be remapping a huge number of disjoint regions
into a linear pmem mapping? ISTR discussions about similar things
for virtio+fuse+dax that came up against "large numbers of mapped
regions don't scale" and so it wasn't a practical solution compared
to a just using raw sparse files....

> - There is no existing solution for Qemu persistent memory 
>   emulation with write support currently. This solution provides 
>   us the paravartualized way of emulating persistent memory.

Sure, but the question is why do you need to create an emulation
that doesn't actually perform like pmem? The whole point of pmem is
performance, and emulating pmem by mmap() of a file on spinning
disks is going to be horrible for performance. Even on SSDs it's
going to be orders of magnitudes slower than real pmem.

So exactly what problem are you trying to solve with this driver?

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
