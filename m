From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC v3] qemu: Add virtio pmem device
Date: Thu, 19 Jul 2018 15:58:20 +0200
Message-ID: <b6ef19f3-7f16-5427-bfed-f352a76e48b7@redhat.com>
References: <20180713075232.9575-1-pagupta@redhat.com>
 <20180713075232.9575-4-pagupta@redhat.com> <20180718085529.133a0a22@doriath>
 <367397176.52317488.1531979293251.JavaMail.zimbra@redhat.com>
 <20180719121635.GA28107@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180719121635.GA28107-lxVrvc10SDRcolVlb+j0YCZi+YwRKgec@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On 19.07.2018 14:16, Stefan Hajnoczi wrote:
> On Thu, Jul 19, 2018 at 01:48:13AM -0400, Pankaj Gupta wrote:
>>
>>>
>>>>  This patch adds virtio-pmem Qemu device.
>>>>
>>>>  This device presents memory address range information to guest
>>>>  which is backed by file backend type. It acts like persistent
>>>>  memory device for KVM guest. Guest can perform read and persistent
>>>>  write operations on this memory range with the help of DAX capable
>>>>  filesystem.
>>>>
>>>>  Persistent guest writes are assured with the help of virtio based
>>>>  flushing interface. When guest userspace space performs fsync on
>>>>  file fd on pmem device, a flush command is send to Qemu over VIRTIO
>>>>  and host side flush/sync is done on backing image file.
>>>>
>>>> Changes from RFC v2:
>>>> - Use aio_worker() to avoid Qemu from hanging with blocking fsync
>>>>   call - Stefan
>>>> - Use virtio_st*_p() for endianess - Stefan
>>>> - Correct indentation in qapi/misc.json - Eric
>>>>
>>>> Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>  hw/virtio/Makefile.objs                     |   3 +
>>>>  hw/virtio/virtio-pci.c                      |  44 +++++
>>>>  hw/virtio/virtio-pci.h                      |  14 ++
>>>>  hw/virtio/virtio-pmem.c                     | 241
>>>>  ++++++++++++++++++++++++++++
>>>>  include/hw/pci/pci.h                        |   1 +
>>>>  include/hw/virtio/virtio-pmem.h             |  42 +++++
>>>>  include/standard-headers/linux/virtio_ids.h |   1 +
>>>>  qapi/misc.json                              |  26 ++-
>>>>  8 files changed, 371 insertions(+), 1 deletion(-)
>>>>  create mode 100644 hw/virtio/virtio-pmem.c
>>>>  create mode 100644 include/hw/virtio/virtio-pmem.h
>>>>
>>>> diff --git a/hw/virtio/Makefile.objs b/hw/virtio/Makefile.objs
>>>> index 1b2799cfd8..7f914d45d0 100644
>>>> --- a/hw/virtio/Makefile.objs
>>>> +++ b/hw/virtio/Makefile.objs
>>>> @@ -10,6 +10,9 @@ obj-$(CONFIG_VIRTIO_CRYPTO) += virtio-crypto.o
>>>>  obj-$(call land,$(CONFIG_VIRTIO_CRYPTO),$(CONFIG_VIRTIO_PCI)) +=
>>>>  virtio-crypto-pci.o
>>>>  
>>>>  obj-$(CONFIG_LINUX) += vhost.o vhost-backend.o vhost-user.o
>>>> +ifeq ($(CONFIG_MEM_HOTPLUG),y)
>>>> +obj-$(CONFIG_LINUX) += virtio-pmem.o
>>>> +endif
>>>>  obj-$(CONFIG_VHOST_VSOCK) += vhost-vsock.o
>>>>  endif
>>>>  
>>>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
>>>> index 3a01fe90f0..93d3fc05c7 100644
>>>> --- a/hw/virtio/virtio-pci.c
>>>> +++ b/hw/virtio/virtio-pci.c
>>>> @@ -2521,6 +2521,49 @@ static const TypeInfo virtio_rng_pci_info = {
>>>>      .class_init    = virtio_rng_pci_class_init,
>>>>  };
>>>>  
>>>> +/* virtio-pmem-pci */
>>>> +
>>>> +static void virtio_pmem_pci_realize(VirtIOPCIProxy *vpci_dev, Error
>>>> **errp)
>>>> +{
>>>> +    VirtIOPMEMPCI *vpmem = VIRTIO_PMEM_PCI(vpci_dev);
>>>> +    DeviceState *vdev = DEVICE(&vpmem->vdev);
>>>> +
>>>> +    qdev_set_parent_bus(vdev, BUS(&vpci_dev->bus));
>>>> +    object_property_set_bool(OBJECT(vdev), true, "realized", errp);
>>>> +}
>>>> +
>>>> +static void virtio_pmem_pci_class_init(ObjectClass *klass, void *data)
>>>> +{
>>>> +    DeviceClass *dc = DEVICE_CLASS(klass);
>>>> +    VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
>>>> +    PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);
>>>> +    k->realize = virtio_pmem_pci_realize;
>>>> +    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
>>>> +    pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
>>>> +    pcidev_k->device_id = PCI_DEVICE_ID_VIRTIO_PMEM;
>>>> +    pcidev_k->revision = VIRTIO_PCI_ABI_VERSION;
>>>> +    pcidev_k->class_id = PCI_CLASS_OTHERS;
>>>> +}
>>>> +
>>>> +static void virtio_pmem_pci_instance_init(Object *obj)
>>>> +{
>>>> +    VirtIOPMEMPCI *dev = VIRTIO_PMEM_PCI(obj);
>>>> +
>>>> +    virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
>>>> +                                TYPE_VIRTIO_PMEM);
>>>> +    object_property_add_alias(obj, "memdev", OBJECT(&dev->vdev), "memdev",
>>>> +                              &error_abort);
>>>> +}
>>>> +
>>>> +static const TypeInfo virtio_pmem_pci_info = {
>>>> +    .name          = TYPE_VIRTIO_PMEM_PCI,
>>>> +    .parent        = TYPE_VIRTIO_PCI,
>>>> +    .instance_size = sizeof(VirtIOPMEMPCI),
>>>> +    .instance_init = virtio_pmem_pci_instance_init,
>>>> +    .class_init    = virtio_pmem_pci_class_init,
>>>> +};
>>>> +
>>>> +
>>>>  /* virtio-input-pci */
>>>>  
>>>>  static Property virtio_input_pci_properties[] = {
>>>> @@ -2714,6 +2757,7 @@ static void virtio_pci_register_types(void)
>>>>      type_register_static(&virtio_balloon_pci_info);
>>>>      type_register_static(&virtio_serial_pci_info);
>>>>      type_register_static(&virtio_net_pci_info);
>>>> +    type_register_static(&virtio_pmem_pci_info);
>>>>  #ifdef CONFIG_VHOST_SCSI
>>>>      type_register_static(&vhost_scsi_pci_info);
>>>>  #endif
>>>> diff --git a/hw/virtio/virtio-pci.h b/hw/virtio/virtio-pci.h
>>>> index 813082b0d7..fe74fcad3f 100644
>>>> --- a/hw/virtio/virtio-pci.h
>>>> +++ b/hw/virtio/virtio-pci.h
>>>> @@ -19,6 +19,7 @@
>>>>  #include "hw/virtio/virtio-blk.h"
>>>>  #include "hw/virtio/virtio-net.h"
>>>>  #include "hw/virtio/virtio-rng.h"
>>>> +#include "hw/virtio/virtio-pmem.h"
>>>>  #include "hw/virtio/virtio-serial.h"
>>>>  #include "hw/virtio/virtio-scsi.h"
>>>>  #include "hw/virtio/virtio-balloon.h"
>>>> @@ -57,6 +58,7 @@ typedef struct VirtIOInputHostPCI VirtIOInputHostPCI;
>>>>  typedef struct VirtIOGPUPCI VirtIOGPUPCI;
>>>>  typedef struct VHostVSockPCI VHostVSockPCI;
>>>>  typedef struct VirtIOCryptoPCI VirtIOCryptoPCI;
>>>> +typedef struct VirtIOPMEMPCI VirtIOPMEMPCI;
>>>>  
>>>>  /* virtio-pci-bus */
>>>>  
>>>> @@ -274,6 +276,18 @@ struct VirtIOBlkPCI {
>>>>      VirtIOBlock vdev;
>>>>  };
>>>>  
>>>> +/*
>>>> + * virtio-pmem-pci: This extends VirtioPCIProxy.
>>>> + */
>>>> +#define TYPE_VIRTIO_PMEM_PCI "virtio-pmem-pci"
>>>> +#define VIRTIO_PMEM_PCI(obj) \
>>>> +        OBJECT_CHECK(VirtIOPMEMPCI, (obj), TYPE_VIRTIO_PMEM_PCI)
>>>> +
>>>> +struct VirtIOPMEMPCI {
>>>> +    VirtIOPCIProxy parent_obj;
>>>> +    VirtIOPMEM vdev;
>>>> +};
>>>> +
>>>>  /*
>>>>   * virtio-balloon-pci: This extends VirtioPCIProxy.
>>>>   */
>>>> diff --git a/hw/virtio/virtio-pmem.c b/hw/virtio/virtio-pmem.c
>>>> new file mode 100644
>>>> index 0000000000..08c96d7e80
>>>> --- /dev/null
>>>> +++ b/hw/virtio/virtio-pmem.c
>>>> @@ -0,0 +1,241 @@
>>>> +/*
>>>> + * Virtio pmem device
>>>> + *
>>>> + * Copyright (C) 2018 Red Hat, Inc.
>>>> + * Copyright (C) 2018 Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> + *
>>>> + * This work is licensed under the terms of the GNU GPL, version 2.
>>>> + * See the COPYING file in the top-level directory.
>>>> + *
>>>> + */
>>>> +
>>>> +#include "qemu/osdep.h"
>>>> +#include "qapi/error.h"
>>>> +#include "qemu-common.h"
>>>> +#include "qemu/error-report.h"
>>>> +#include "hw/virtio/virtio-access.h"
>>>> +#include "hw/virtio/virtio-pmem.h"
>>>> +#include "hw/mem/memory-device.h"
>>>> +#include "block/aio.h"
>>>> +#include "block/thread-pool.h"
>>>> +
>>>> +typedef struct VirtIOPMEMresp {
>>>> +    int ret;
>>>> +} VirtIOPMEMResp;
>>>> +
>>>> +typedef struct VirtIODeviceRequest {
>>>> +    VirtQueueElement elem;
>>>> +    int fd;
>>>> +    VirtIOPMEM *pmem;
>>>> +    VirtIOPMEMResp resp;
>>>> +} VirtIODeviceRequest;
>>>> +
>>>> +static int worker_cb(void *opaque)
>>>> +{
>>>> +    VirtIODeviceRequest *req = opaque;
>>>> +    int err = 0;
>>>> +
>>>> +    /* flush raw backing image */
>>>> +    err = fsync(req->fd);
>>>> +    if (err != 0) {
>>>> +        err = errno;
>>>> +    }
>>>> +    req->resp.ret = err;
>>>
>>> Host question: are you returning the guest errno code to the host?
>>
>> No. I am returning error code from the host in-case of host fsync
>> failure, otherwise returning zero.
> 
> I think that's what Luiz meant.  errno constants are not portable
> between operating systems and architectures.  Therefore they cannot be
> used in external interfaces in software that expects to communicate with
> other systems.
> 
> It will be necessary to define specific constants for virtio-pmem
> instead of passing errno from the host to guest.
> 

In general, I wonder if we should report errors at all or rather *kill*
the guest. That might sound harsh, but think about the following scenario:

fsync() fails due to some block that cannot e.g. be written (e.g.
network connection failed). What happens if our guest tries to
read/write that mmaped block? (e.g. network connection failed).

I assume we'll get a signal an get killed? So we are trying to optimize
one special case (fsync()) although every read/write is prone to kill
the guest. And as soon as the guest will try to access the block that
made fsync fail, we will crash the guest either way.

I assume the main problem is that we are trying to take a file (with all
the errors that can happen during read/write/fsync) and make it look
like memory (dax). On ordinary block access, we can forward errors, but
not if it's memory (maybe using MCE, but it's complicated and
architecture specific).

So I wonder if we should rather assume that our backend file is placed
on some stable storage that cannot easily fail.

(we might have the same problem with NVDIMM right now, at least the
memory reading/writing part)

It's complicated and I am not a block level expert :)

> Stefan
> 


-- 

Thanks,

David / dhildenb
