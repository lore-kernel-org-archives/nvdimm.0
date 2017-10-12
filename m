From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 2/2] KVM: add virtio-pmem driver
Date: Thu, 12 Oct 2017 14:54:53 -0700
Message-ID: <CAPcyv4gkri7t+3Unf0sc9AHMnz-v9G_qV_bJppLjUUNAn7drrQ@mail.gmail.com>
References: <20171012155027.3277-1-pagupta@redhat.com> <20171012155027.3277-3-pagupta@redhat.com>
 <CAPcyv4i7k6aYK_y4zZtL6p8sW-E_Ft58d2HuxO=dYciqQxaoLg@mail.gmail.com> <1567317495.19940236.1507843517318.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1567317495.19940236.1507843517318.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pankaj Gupta <pagupta@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Rik van Riel <riel@redhat.com>, Haozhong Zhang <haozhong.zhang@intel.com>, Nitesh Narayan Lal <nilal@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Ross Zwisler <ross.zwisler@intel.com>, David Hildenbrand <david@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, Oct 12, 2017 at 2:25 PM, Pankaj Gupta <pagupta@redhat.com> wrote:
>
>> >   This patch adds virtio-pmem driver for KVM guest.
>> >   Guest reads the persistent memory range information
>> >   over virtio bus from Qemu and reserves the range
>> >   as persistent memory. Guest also allocates a block
>> >   device corresponding to the pmem range which later
>> >   can be accessed with DAX compatible file systems.
>> >   Idea is to use the virtio channel between guest and
>> >   host to perform the block device flush for guest pmem
>> >   DAX device.
>> >
>> >   There is work to do including DAX file system support
>> >   and other advanced features.
>> >
>> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
>> > ---
>> >  drivers/virtio/Kconfig           |  10 ++
>> >  drivers/virtio/Makefile          |   1 +
>> >  drivers/virtio/virtio_pmem.c     | 322
>> >  +++++++++++++++++++++++++++++++++++++++
>> >  include/uapi/linux/virtio_pmem.h |  55 +++++++
>> >  4 files changed, 388 insertions(+)
>> >  create mode 100644 drivers/virtio/virtio_pmem.c
>> >  create mode 100644 include/uapi/linux/virtio_pmem.h
>> >
>> > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
>> > index cff773f15b7e..0192c4bda54b 100644
>> > --- a/drivers/virtio/Kconfig
>> > +++ b/drivers/virtio/Kconfig
>> > @@ -38,6 +38,16 @@ config VIRTIO_PCI_LEGACY
>> >
>> >           If unsure, say Y.
>> >
>> > +config VIRTIO_PMEM
>> > +       tristate "Virtio pmem driver"
>> > +       depends on VIRTIO
>> > +       ---help---
>> > +        This driver adds persistent memory range within a KVM guest.
>>
>> I think we need to call this something other than persistent memory to
>> make it clear that this not memory where the persistence can be
>> managed from userspace. The persistence point always requires a driver
>> call, so this is something distinctly different than "persistent
>> memory". For example, it's a bug if this memory range ends up backing
>> a device-dax range in the guest where there is no such thing as a
>> driver callback to perform the flushing. How does this solution
>> protect against that scenario?
>
> yes, you are right we are not providing device_dax in this case so it should
> be clear from name. Any suggestion for name?

So currently /proc/iomem in a guest with a pmem device attached to a
namespace looks like this:

    c00000000-13bfffffff : Persistent Memory
       c00000000-13bfffffff : namespace2.0

Can we call it "Virtio Shared Memory" to make it clear it is a
different beast than typical "Persistent Memory"?  You can likely
inject your own name into the resource tree the same way we do in the
NFIT driver. See acpi_nfit_insert_resource().
