From: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC 2/2] KVM: add virtio-pmem driver
Date: Thu, 12 Oct 2017 18:27:29 -0400
Message-ID: <1507847249.21121.207.camel@redhat.com>
References: <20171012155027.3277-1-pagupta@redhat.com>
	 <20171012155027.3277-3-pagupta@redhat.com>
	 <CAPcyv4i7k6aYK_y4zZtL6p8sW-E_Ft58d2HuxO=dYciqQxaoLg@mail.gmail.com>
	 <1567317495.19940236.1507843517318.JavaMail.zimbra@redhat.com>
	 <CAPcyv4gkri7t+3Unf0sc9AHMnz-v9G_qV_bJppLjUUNAn7drrQ@mail.gmail.com>
	 <1363955128.19944709.1507846719987.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1363955128.19944709.1507846719987.JavaMail.zimbra@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Pankaj Gupta <pagupta@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, KVM list <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Haozhong Zhang <haozhong.zhang@intel.com>, Nitesh Narayan Lal <nilal@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Ross Zwisler <ross.zwisler@intel.com>, David Hildenbrand <david@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, 2017-10-12 at 18:18 -0400, Pankaj Gupta wrote:
> > 
> > On Thu, Oct 12, 2017 at 2:25 PM, Pankaj Gupta <pagupta@redhat.com>
> > wrote:
> > > 
> > > > >   This patch adds virtio-pmem driver for KVM guest.
> > > > >   Guest reads the persistent memory range information
> > > > >   over virtio bus from Qemu and reserves the range
> > > > >   as persistent memory. Guest also allocates a block
> > > > >   device corresponding to the pmem range which later
> > > > >   can be accessed with DAX compatible file systems.
> > > > >   Idea is to use the virtio channel between guest and
> > > > >   host to perform the block device flush for guest pmem
> > > > >   DAX device.
> > > > > 
> > > > >   There is work to do including DAX file system support
> > > > >   and other advanced features.
> > > > > 
> > > > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > > > ---
> > > > >  drivers/virtio/Kconfig           |  10 ++
> > > > >  drivers/virtio/Makefile          |   1 +
> > > > >  drivers/virtio/virtio_pmem.c     | 322
> > > > >  +++++++++++++++++++++++++++++++++++++++
> > > > >  include/uapi/linux/virtio_pmem.h |  55 +++++++
> > > > >  4 files changed, 388 insertions(+)
> > > > >  create mode 100644 drivers/virtio/virtio_pmem.c
> > > > >  create mode 100644 include/uapi/linux/virtio_pmem.h
> > > > > 
> > > > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > > > index cff773f15b7e..0192c4bda54b 100644
> > > > > --- a/drivers/virtio/Kconfig
> > > > > +++ b/drivers/virtio/Kconfig
> > > > > @@ -38,6 +38,16 @@ config VIRTIO_PCI_LEGACY
> > > > > 
> > > > >           If unsure, say Y.
> > > > > 
> > > > > +config VIRTIO_PMEM
> > > > > +       tristate "Virtio pmem driver"
> > > > > +       depends on VIRTIO
> > > > > +       ---help---
> > > > > +        This driver adds persistent memory range within a
> > > > > KVM guest.

With "Virtio Block Backed Pmem" we could name the config
option VIRTIO_BLOCK_PMEM

The documentation text could make it clear to people that the
image shows up as a disk image on the host, but as a pmem
memory range in the guest.

> > > > I think we need to call this something other than persistent
> > > > memory to
> > > > make it clear that this not memory where the persistence can be
> > > > managed from userspace. The persistence point always requires
> > > > 
> > So currently /proc/iomem in a guest with a pmem device attached to
> > a
> > namespace looks like this:
> > 
> >     c00000000-13bfffffff : Persistent Memory
> >        c00000000-13bfffffff : namespace2.0
> > 
> > Can we call it "Virtio Shared Memory" to make it clear it is a
> > different beast than typical "Persistent Memory"?  You can likely
> 
> I think somewhere we need persistent keyword 'Virtio Persistent
> Memory' or 
> so.

Still hoping for better ideas than "Virtio Block Backed Pmem" :)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
