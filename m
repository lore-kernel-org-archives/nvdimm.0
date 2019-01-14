From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v3 0/5] kvm "virtio pmem" device
Date: Mon, 14 Jan 2019 13:50:54 +1100
Message-ID: <20190114025054.GE4205@dastard>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190110012617.GA4205@dastard>
 <1326478078.61913951.1547192704870.JavaMail.zimbra@redhat.com>
 <20190113232902.GD4205@dastard>
 <20190113233820.GX6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190113233820.GX6310-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, adilger kernel <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, darrick wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Sun, Jan 13, 2019 at 03:38:21PM -0800, Matthew Wilcox wrote:
> On Mon, Jan 14, 2019 at 10:29:02AM +1100, Dave Chinner wrote:
> > Until you have images (and hence host page cache) shared between
> > multiple guests. People will want to do this, because it means they
> > only need a single set of pages in host memory for executable
> > binaries rather than a set of pages per guest. Then you have
> > multiple guests being able to detect residency of the same set of
> > pages. If the guests can then, in any way, control eviction of the
> > pages from the host cache, then we have a guest-to-guest information
> > leak channel.
> 
> I don't think we should ever be considering something that would allow a
> guest to evict page's from the host's pagecache [1].  The guest should
> be able to kick its own references to the host's pagecache out of its
> own pagecache, but not be able to influence whether the host or another
> guest has a read-only mapping cached.
> 
> [1] Unless the guest is allowed to modify the host's file; obviously
> truncation, holepunching, etc are going to evict pages from the host's
> page cache.

Right, and that's exactly what I mean by "we need to be real careful
with functionality like this".

To be honest, I really don't think I've even touched the surface
here.

e.g. Filesystems and storage can share logical and physical extents.
Which means that image files that share storage (e.g.  because they
are all cloned from the same master image and/or there's in-line
deduplication running on the storage) and can be directly accessed
by guests may very well be susceptible to detection of host side
deduplication and subsequent copy-on-write operations.

This really doesn't seem much different to me from the guest being
able to infer host side KSM page deduplication and COW operation in
the guest side page cache.  The only difference is that DAX is being
used to probe the host side page cache and storage rather than the
guest side.

IOWs, I suspect there's a world of pain waiting for us if we punch
huge holes through the virtual machine abstractions like this.

Improving performance is a laudible goal, but at what price?

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
