From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v2 2/2] virtio-pmem: Add virtio pmem driver
Date: Wed, 17 Oct 2018 21:44:49 -0400 (EDT)
Message-ID: <130749719.21742520.1539827089099.JavaMail.zimbra@redhat.com>
References: <20181013050021.11962-1-pagupta@redhat.com> <20181013050021.11962-3-pagupta@redhat.com> <CAPcyv4hroaVWA-HgjWCnr7QTd_y7U8sCvS+Up733ttnD6_cKzQ@mail.gmail.com> <431127218.21694133.1539803509205.JavaMail.zimbra@redhat.com> <CAPcyv4joz_dPruJY4CYAxXSuMTD-NUoqm6kvGFrF19jt5dN=rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4joz_dPruJY4CYAxXSuMTD-NUoqm6kvGFrF19jt5dN=rg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Jan Kara <jack@suse.cz>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, KVM list <kvm@vger.kernel.org>, Rik van Riel <riel@surriel.com>, linux-nvdimm <linux-nvdimm@ml01.01.org>, David Hildenbrand <david@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, Christoph Hellwig <hch@infradead.org>, Igor Mammedov <imammedo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>, zwisler@kernel.org, Dave Jiang <dave.jiang@intel.com>, lcapitulino@redhat.com
List-Id: linux-nvdimm@lists.01.org


> >
> >
> > > On Fri, Oct 12, 2018 at 10:01 PM Pankaj Gupta <pagupta@redhat.com> wrote:
> > > >
> > > > This patch adds virtio-pmem driver for KVM guest.
> > > >
> > > > Guest reads the persistent memory range information from
> > > > Qemu over VIRTIO and registers it on nvdimm_bus. It also
> > > > creates a nd_region object with the persistent memory
> > > > range information so that existing 'nvdimm/pmem' driver
> > > > can reserve this into system memory map. This way
> > > > 'virtio-pmem' driver uses existing functionality of pmem
> > > > driver to register persistent memory compatible for DAX
> > > > capable filesystems.
> > > >
> > > > This also provides function to perform guest flush over
> > > > VIRTIO from 'pmem' driver when userspace performs flush
> > > > on DAX memory range.
> > >
> > > Before we can move forward with this driver we need additional
> > > filesystem enabling to detect when the backing device is fronting DAX
> > > pmem or a paravirtualized page cache through virtio-pmem. Any
> > > interface that requires fsync() and a round trip to the hypervisor to
> > > flush host page cache is not DAX.
> >
> > I saw your proposal[1] for new mmap flag MAP_DIRECT. IIUIC mapping should
> > fail for
> > MAP_DIRECT if it requires explicit flush or buffer indirection. So, if we
> > disable
> > MAP_SYNC flag for virtio-pmem this should fail MAP_DIRECT as well?
> > Otherwise
> > without MAP_DIRECT, virtio-pmem should be defaulted to VIRTIO flush
> > mechanism.
> 
> Right, although I wouldn't worry about MAP_DIRECT in the short term
> since we're still discussing what the upstream interface. Regardless
> of whether MAP_DIRECT is specified or not the virtio-flush mechanism
> would always be used for virtio-pmem. I.e. there is no possibility to
> get full DAX operation with virtio-pmem, only the page-cache bypass
> sub-set.

Agree. I will also follow the thread.

> 
> Taking a look at where we could inject this check for filesystems it's
> a bit awkward to do it in xfs_file_mmap() for example because we do
> not have the backing device for the extents of the inode. So at a
> minimum you would need to investigate calling xfs_inode_supports_dax()
> from that path and teaching it about a new dax_device flag. I'm
> thinking the dax_device flag should be called DAXDEV_BUFFERED to
> indicate the presence of software buffering on a device that otherwise
> supports bypassing the local page cache.

Sure. Will investigate XFS code as suggested. 
Thanks for the detail directions towards the solution. Will try to come up 
with a solution.

Best regards,
Pankaj
  
