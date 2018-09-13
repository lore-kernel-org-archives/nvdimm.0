From: Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] qemu: Add virtio pmem device
Date: Thu, 13 Sep 2018 08:22:35 -0400
Message-ID: <20180913082235.50d01365@doriath>
References: <20180831133019.27579-1-pagupta@redhat.com>
 <20180831133019.27579-5-pagupta@redhat.com>
 <20180912125707.58df7dc5@doriath>
 <563893075.12819183.1536822387535.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <563893075.12819183.1536822387535.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Thu, 13 Sep 2018 03:06:27 -0400 (EDT)
Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> >   
> > >  This patch adds virtio-pmem Qemu device.
> > > 
> > >  This device presents memory address range information to guest
> > >  which is backed by file backend type. It acts like persistent
> > >  memory device for KVM guest. Guest can perform read and
> > >  persistent write operations on this memory range with the help
> > >  of DAX capable filesystem.
> > > 
> > >  Persistent guest writes are assured with the help of virtio
> > >  based flushing interface. When guest userspace space performs
> > >  fsync on file fd on pmem device, a flush command is send to
> > >  Qemu over VIRTIO and host side flush/sync is done on backing
> > >  image file.
> > > 
> > > Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > > Changes from RFC v3:
> > > - Return EIO for host fsync failure instead of errno - Luiz, Stefan
> > > - Change version for inclusion to Qemu 3.1 - Eric
> > > 
> > > Changes from RFC v2:
> > > - Use aio_worker() to avoid Qemu from hanging with blocking fsync
> > >   call - Stefan
> > > - Use virtio_st*_p() for endianess - Stefan
> > > - Correct indentation in qapi/misc.json - Eric
> > > 
> > >  hw/virtio/Makefile.objs                     |   3 +
> > >  hw/virtio/virtio-pci.c                      |  44 +++++
> > >  hw/virtio/virtio-pci.h                      |  14 ++
> > >  hw/virtio/virtio-pmem.c                     | 241
> > >  ++++++++++++++++++++++++++++
> > >  include/hw/pci/pci.h                        |   1 +
> > >  include/hw/virtio/virtio-pmem.h             |  42 +++++
> > >  include/standard-headers/linux/virtio_ids.h |   1 +
> > >  qapi/misc.json                              |  26 ++-
> > >  8 files changed, 371 insertions(+), 1 deletion(-)
> > >  create mode 100644 hw/virtio/virtio-pmem.c
> > >  create mode 100644 include/hw/virtio/virtio-pmem.h
> > > 
> > > diff --git a/hw/virtio/Makefile.objs b/hw/virtio/Makefile.objs
> > > index 1b2799cfd8..7f914d45d0 100644
> > > --- a/hw/virtio/Makefile.objs
> > > +++ b/hw/virtio/Makefile.objs
> > > @@ -10,6 +10,9 @@ obj-$(CONFIG_VIRTIO_CRYPTO) += virtio-crypto.o
> > >  obj-$(call land,$(CONFIG_VIRTIO_CRYPTO),$(CONFIG_VIRTIO_PCI)) +=
> > >  virtio-crypto-pci.o
> > >  
> > >  obj-$(CONFIG_LINUX) += vhost.o vhost-backend.o vhost-user.o
> > > +ifeq ($(CONFIG_MEM_HOTPLUG),y)
> > > +obj-$(CONFIG_LINUX) += virtio-pmem.o
> > > +endif
> > >  obj-$(CONFIG_VHOST_VSOCK) += vhost-vsock.o
> > >  endif
> > >  
> > > diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> > > index 3a01fe90f0..93d3fc05c7 100644
> > > --- a/hw/virtio/virtio-pci.c
> > > +++ b/hw/virtio/virtio-pci.c
> > > @@ -2521,6 +2521,49 @@ static const TypeInfo virtio_rng_pci_info = {
> > >      .class_init    = virtio_rng_pci_class_init,
> > >  };
> > >  
> > > +/* virtio-pmem-pci */
> > > +
> > > +static void virtio_pmem_pci_realize(VirtIOPCIProxy *vpci_dev, Error
> > > **errp)
> > > +{
> > > +    VirtIOPMEMPCI *vpmem = VIRTIO_PMEM_PCI(vpci_dev);
> > > +    DeviceState *vdev = DEVICE(&vpmem->vdev);
> > > +
> > > +    qdev_set_parent_bus(vdev, BUS(&vpci_dev->bus));
> > > +    object_property_set_bool(OBJECT(vdev), true, "realized", errp);
> > > +}
> > > +
> > > +static void virtio_pmem_pci_class_init(ObjectClass *klass, void *data)
> > > +{
> > > +    DeviceClass *dc = DEVICE_CLASS(klass);
> > > +    VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
> > > +    PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);
> > > +    k->realize = virtio_pmem_pci_realize;
> > > +    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
> > > +    pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
> > > +    pcidev_k->device_id = PCI_DEVICE_ID_VIRTIO_PMEM;
> > > +    pcidev_k->revision = VIRTIO_PCI_ABI_VERSION;
> > > +    pcidev_k->class_id = PCI_CLASS_OTHERS;
> > > +}
> > > +
> > > +static void virtio_pmem_pci_instance_init(Object *obj)
> > > +{
> > > +    VirtIOPMEMPCI *dev = VIRTIO_PMEM_PCI(obj);
> > > +
> > > +    virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
> > > +                                TYPE_VIRTIO_PMEM);
> > > +    object_property_add_alias(obj, "memdev", OBJECT(&dev->vdev), "memdev",
> > > +                              &error_abort);
> > > +}
> > > +
> > > +static const TypeInfo virtio_pmem_pci_info = {
> > > +    .name          = TYPE_VIRTIO_PMEM_PCI,
> > > +    .parent        = TYPE_VIRTIO_PCI,
> > > +    .instance_size = sizeof(VirtIOPMEMPCI),
> > > +    .instance_init = virtio_pmem_pci_instance_init,
> > > +    .class_init    = virtio_pmem_pci_class_init,
> > > +};
> > > +
> > > +
> > >  /* virtio-input-pci */
> > >  
> > >  static Property virtio_input_pci_properties[] = {
> > > @@ -2714,6 +2757,7 @@ static void virtio_pci_register_types(void)
> > >      type_register_static(&virtio_balloon_pci_info);
> > >      type_register_static(&virtio_serial_pci_info);
> > >      type_register_static(&virtio_net_pci_info);
> > > +    type_register_static(&virtio_pmem_pci_info);
> > >  #ifdef CONFIG_VHOST_SCSI
> > >      type_register_static(&vhost_scsi_pci_info);
> > >  #endif
> > > diff --git a/hw/virtio/virtio-pci.h b/hw/virtio/virtio-pci.h
> > > index 813082b0d7..fe74fcad3f 100644
> > > --- a/hw/virtio/virtio-pci.h
> > > +++ b/hw/virtio/virtio-pci.h
> > > @@ -19,6 +19,7 @@
> > >  #include "hw/virtio/virtio-blk.h"
> > >  #include "hw/virtio/virtio-net.h"
> > >  #include "hw/virtio/virtio-rng.h"
> > > +#include "hw/virtio/virtio-pmem.h"
> > >  #include "hw/virtio/virtio-serial.h"
> > >  #include "hw/virtio/virtio-scsi.h"
> > >  #include "hw/virtio/virtio-balloon.h"
> > > @@ -57,6 +58,7 @@ typedef struct VirtIOInputHostPCI VirtIOInputHostPCI;
> > >  typedef struct VirtIOGPUPCI VirtIOGPUPCI;
> > >  typedef struct VHostVSockPCI VHostVSockPCI;
> > >  typedef struct VirtIOCryptoPCI VirtIOCryptoPCI;
> > > +typedef struct VirtIOPMEMPCI VirtIOPMEMPCI;
> > >  
> > >  /* virtio-pci-bus */
> > >  
> > > @@ -274,6 +276,18 @@ struct VirtIOBlkPCI {
> > >      VirtIOBlock vdev;
> > >  };
> > >  
> > > +/*
> > > + * virtio-pmem-pci: This extends VirtioPCIProxy.
> > > + */
> > > +#define TYPE_VIRTIO_PMEM_PCI "virtio-pmem-pci"
> > > +#define VIRTIO_PMEM_PCI(obj) \
> > > +        OBJECT_CHECK(VirtIOPMEMPCI, (obj), TYPE_VIRTIO_PMEM_PCI)
> > > +
> > > +struct VirtIOPMEMPCI {
> > > +    VirtIOPCIProxy parent_obj;
> > > +    VirtIOPMEM vdev;
> > > +};
> > > +
> > >  /*
> > >   * virtio-balloon-pci: This extends VirtioPCIProxy.
> > >   */
> > > diff --git a/hw/virtio/virtio-pmem.c b/hw/virtio/virtio-pmem.c
> > > new file mode 100644
> > > index 0000000000..69ae4c0a50
> > > --- /dev/null
> > > +++ b/hw/virtio/virtio-pmem.c
> > > @@ -0,0 +1,241 @@
> > > +/*
> > > + * Virtio pmem device
> > > + *
> > > + * Copyright (C) 2018 Red Hat, Inc.
> > > + * Copyright (C) 2018 Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > + *
> > > + * This work is licensed under the terms of the GNU GPL, version 2.
> > > + * See the COPYING file in the top-level directory.
> > > + *
> > > + */
> > > +
> > > +#include "qemu/osdep.h"
> > > +#include "qapi/error.h"
> > > +#include "qemu-common.h"
> > > +#include "qemu/error-report.h"
> > > +#include "hw/virtio/virtio-access.h"
> > > +#include "hw/virtio/virtio-pmem.h"
> > > +#include "hw/mem/memory-device.h"
> > > +#include "block/aio.h"
> > > +#include "block/thread-pool.h"
> > > +
> > > +typedef struct VirtIOPMEMresp {
> > > +    int ret;
> > > +} VirtIOPMEMResp;
> > > +
> > > +typedef struct VirtIODeviceRequest {
> > > +    VirtQueueElement elem;
> > > +    int fd;
> > > +    VirtIOPMEM *pmem;
> > > +    VirtIOPMEMResp resp;
> > > +} VirtIODeviceRequest;
> > > +
> > > +static int worker_cb(void *opaque)
> > > +{
> > > +    VirtIODeviceRequest *req = opaque;
> > > +    int err = 0;
> > > +
> > > +    /* flush raw backing image */
> > > +    err = fsync(req->fd);
> > > +    if (err != 0) {
> > > +        err = EIO;
> > > +    }
> > > +    req->resp.ret = err;  
> > 
> > As I mentioned in the kernel patch, I think you should 1 for
> > error and let the guest pick the error it wants to return to
> > the calling thread.  
> 
> Sure.
> 
> >   
> > > +
> > > +    return 0;
> > > +}
> > > +
> > > +static void done_cb(void *opaque, int ret)
> > > +{
> > > +    VirtIODeviceRequest *req = opaque;
> > > +    int len = iov_from_buf(req->elem.in_sg, req->elem.in_num, 0,
> > > +                              &req->resp, sizeof(VirtIOPMEMResp));
> > > +
> > > +    /* Callbacks are serialized, so no need to use atomic ops.  */
> > > +    virtqueue_push(req->pmem->rq_vq, &req->elem, len);
> > > +    virtio_notify((VirtIODevice *)req->pmem, req->pmem->rq_vq);
> > > +    g_free(req);
> > > +}
> > > +
> > > +static void virtio_pmem_flush(VirtIODevice *vdev, VirtQueue *vq)
> > > +{
> > > +    VirtIODeviceRequest *req;
> > > +    VirtIOPMEM *pmem = VIRTIO_PMEM(vdev);
> > > +    HostMemoryBackend *backend = MEMORY_BACKEND(pmem->memdev);
> > > +    ThreadPool *pool = aio_get_thread_pool(qemu_get_aio_context());
> > > +
> > > +    req = virtqueue_pop(vq, sizeof(VirtIODeviceRequest));
> > > +    if (!req) {
> > > +        virtio_error(vdev, "virtio-pmem missing request data");
> > > +        return;
> > > +    }
> > > +
> > > +    if (req->elem.out_num < 1 || req->elem.in_num < 1) {
> > > +        virtio_error(vdev, "virtio-pmem request not proper");
> > > +        g_free(req);
> > > +        return;
> > > +    }  
> > 
> > I think you should abort() in those errors.  
> 
> Just skimmed over how other devices handle such errors (virtio_blk & virtio_scsi):
> None of these is aborting?

My fear is threads on the host side getting blocked in a row forever.

> 
>   if (req->elem.out_num < 1 || req->elem.in_num < 1) {
>         virtio_error(vdev, "virtio-blk missing headers");
>         return -1;
>     }
> 
> Thanks,
> Pankaj
> 
> >   
> > > +    req->fd = memory_region_get_fd(&backend->mr);
> > > +    req->pmem = pmem;
> > > +    thread_pool_submit_aio(pool, worker_cb, req, done_cb, req);
> > > +}
> > > +
> > > +static void virtio_pmem_get_config(VirtIODevice *vdev, uint8_t *config)
> > > +{
> > > +    VirtIOPMEM *pmem = VIRTIO_PMEM(vdev);
> > > +    struct virtio_pmem_config *pmemcfg = (struct virtio_pmem_config *)
> > > config;
> > > +
> > > +    virtio_stq_p(vdev, &pmemcfg->start, pmem->start);
> > > +    virtio_stq_p(vdev, &pmemcfg->size, pmem->size);
> > > +}
> > > +
> > > +static uint64_t virtio_pmem_get_features(VirtIODevice *vdev, uint64_t
> > > features,
> > > +                                        Error **errp)
> > > +{
> > > +    return features;
> > > +}
> > > +
> > > +static void virtio_pmem_realize(DeviceState *dev, Error **errp)
> > > +{
> > > +    VirtIODevice   *vdev   = VIRTIO_DEVICE(dev);
> > > +    VirtIOPMEM     *pmem   = VIRTIO_PMEM(dev);
> > > +    MachineState   *ms     = MACHINE(qdev_get_machine());
> > > +    uint64_t align;
> > > +    Error *local_err = NULL;
> > > +    MemoryRegion *mr;
> > > +
> > > +    if (!pmem->memdev) {
> > > +        error_setg(errp, "virtio-pmem memdev not set");
> > > +        return;
> > > +    }
> > > +
> > > +    mr  = host_memory_backend_get_memory(pmem->memdev);
> > > +    align = memory_region_get_alignment(mr);
> > > +    pmem->size = QEMU_ALIGN_DOWN(memory_region_size(mr), align);
> > > +    pmem->start = memory_device_get_free_addr(ms, NULL, align, pmem->size,
> > > +
> > > &local_err);
> > > +    if (local_err) {
> > > +        error_setg(errp, "Can't get free address in mem device");
> > > +        return;
> > > +    }
> > > +    memory_region_init_alias(&pmem->mr, OBJECT(pmem),
> > > +                             "virtio_pmem-memory", mr, 0, pmem->size);
> > > +    memory_device_plug_region(ms, &pmem->mr, pmem->start);
> > > +
> > > +    host_memory_backend_set_mapped(pmem->memdev, true);
> > > +    virtio_init(vdev, TYPE_VIRTIO_PMEM, VIRTIO_ID_PMEM,
> > > +                                          sizeof(struct
> > > virtio_pmem_config));
> > > +    pmem->rq_vq = virtio_add_queue(vdev, 128, virtio_pmem_flush);
> > > +}
> > > +
> > > +static void virtio_mem_check_memdev(Object *obj, const char *name, Object
> > > *val,
> > > +                                    Error **errp)
> > > +{
> > > +    if (host_memory_backend_is_mapped(MEMORY_BACKEND(val))) {
> > > +        char *path = object_get_canonical_path_component(val);
> > > +        error_setg(errp, "Can't use already busy memdev: %s", path);
> > > +        g_free(path);
> > > +        return;
> > > +    }
> > > +
> > > +    qdev_prop_allow_set_link_before_realize(obj, name, val, errp);
> > > +}
> > > +
> > > +static const char *virtio_pmem_get_device_id(VirtIOPMEM *vm)
> > > +{
> > > +    Object *obj = OBJECT(vm);
> > > +    DeviceState *parent_dev;
> > > +
> > > +    /* always use the ID of the proxy device */
> > > +    if (obj->parent && object_dynamic_cast(obj->parent, TYPE_DEVICE)) {
> > > +        parent_dev = DEVICE(obj->parent);
> > > +        return parent_dev->id;
> > > +    }
> > > +    return NULL;
> > > +}
> > > +
> > > +static void virtio_pmem_md_fill_device_info(const MemoryDeviceState *md,
> > > +                                           MemoryDeviceInfo *info)
> > > +{
> > > +    VirtioPMemDeviceInfo *vi = g_new0(VirtioPMemDeviceInfo, 1);
> > > +    VirtIOPMEM *vm = VIRTIO_PMEM(md);
> > > +    const char *id = virtio_pmem_get_device_id(vm);
> > > +
> > > +    if (id) {
> > > +        vi->has_id = true;
> > > +        vi->id = g_strdup(id);
> > > +    }
> > > +
> > > +    vi->start = vm->start;
> > > +    vi->size = vm->size;
> > > +    vi->memdev = object_get_canonical_path(OBJECT(vm->memdev));
> > > +
> > > +    info->u.virtio_pmem.data = vi;
> > > +    info->type = MEMORY_DEVICE_INFO_KIND_VIRTIO_PMEM;
> > > +}
> > > +
> > > +static uint64_t virtio_pmem_md_get_addr(const MemoryDeviceState *md)
> > > +{
> > > +    VirtIOPMEM *vm = VIRTIO_PMEM(md);
> > > +
> > > +    return vm->start;
> > > +}
> > > +
> > > +static uint64_t virtio_pmem_md_get_plugged_size(const MemoryDeviceState
> > > *md)
> > > +{
> > > +    VirtIOPMEM *vm = VIRTIO_PMEM(md);
> > > +
> > > +    return vm->size;
> > > +}
> > > +
> > > +static uint64_t virtio_pmem_md_get_region_size(const MemoryDeviceState
> > > *md)
> > > +{
> > > +    VirtIOPMEM *vm = VIRTIO_PMEM(md);
> > > +
> > > +    return vm->size;
> > > +}
> > > +
> > > +static void virtio_pmem_instance_init(Object *obj)
> > > +{
> > > +    VirtIOPMEM *vm = VIRTIO_PMEM(obj);
> > > +    object_property_add_link(obj, "memdev", TYPE_MEMORY_BACKEND,
> > > +                                (Object **)&vm->memdev,
> > > +                                (void *) virtio_mem_check_memdev,
> > > +                                OBJ_PROP_LINK_STRONG,
> > > +                                &error_abort);
> > > +}
> > > +
> > > +
> > > +static void virtio_pmem_class_init(ObjectClass *klass, void *data)
> > > +{
> > > +    VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
> > > +    MemoryDeviceClass *mdc = MEMORY_DEVICE_CLASS(klass);
> > > +
> > > +    vdc->realize      =  virtio_pmem_realize;
> > > +    vdc->get_config   =  virtio_pmem_get_config;
> > > +    vdc->get_features =  virtio_pmem_get_features;
> > > +
> > > +    mdc->get_addr         = virtio_pmem_md_get_addr;
> > > +    mdc->get_plugged_size = virtio_pmem_md_get_plugged_size;
> > > +    mdc->get_region_size  = virtio_pmem_md_get_region_size;
> > > +    mdc->fill_device_info = virtio_pmem_md_fill_device_info;
> > > +}
> > > +
> > > +static TypeInfo virtio_pmem_info = {
> > > +    .name          = TYPE_VIRTIO_PMEM,
> > > +    .parent        = TYPE_VIRTIO_DEVICE,
> > > +    .class_init    = virtio_pmem_class_init,
> > > +    .instance_size = sizeof(VirtIOPMEM),
> > > +    .instance_init = virtio_pmem_instance_init,
> > > +    .interfaces = (InterfaceInfo[]) {
> > > +        { TYPE_MEMORY_DEVICE },
> > > +        { }
> > > +  },
> > > +};
> > > +
> > > +static void virtio_register_types(void)
> > > +{
> > > +    type_register_static(&virtio_pmem_info);
> > > +}
> > > +
> > > +type_init(virtio_register_types)
> > > diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
> > > index 990d6fcbde..28829b6437 100644
> > > --- a/include/hw/pci/pci.h
> > > +++ b/include/hw/pci/pci.h
> > > @@ -85,6 +85,7 @@ extern bool pci_available;
> > >  #define PCI_DEVICE_ID_VIRTIO_RNG         0x1005
> > >  #define PCI_DEVICE_ID_VIRTIO_9P          0x1009
> > >  #define PCI_DEVICE_ID_VIRTIO_VSOCK       0x1012
> > > +#define PCI_DEVICE_ID_VIRTIO_PMEM        0x1013
> > >  
> > >  #define PCI_VENDOR_ID_REDHAT             0x1b36
> > >  #define PCI_DEVICE_ID_REDHAT_BRIDGE      0x0001
> > > diff --git a/include/hw/virtio/virtio-pmem.h
> > > b/include/hw/virtio/virtio-pmem.h
> > > new file mode 100644
> > > index 0000000000..fda3ee691c
> > > --- /dev/null
> > > +++ b/include/hw/virtio/virtio-pmem.h
> > > @@ -0,0 +1,42 @@
> > > +/*
> > > + * Virtio pmem Device
> > > + *
> > > + * Copyright Red Hat, Inc. 2018
> > > + * Copyright Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > + *
> > > + * This work is licensed under the terms of the GNU GPL, version 2 or
> > > + * (at your option) any later version.  See the COPYING file in the
> > > + * top-level directory.
> > > + */
> > > +
> > > +#ifndef QEMU_VIRTIO_PMEM_H
> > > +#define QEMU_VIRTIO_PMEM_H
> > > +
> > > +#include "hw/virtio/virtio.h"
> > > +#include "exec/memory.h"
> > > +#include "sysemu/hostmem.h"
> > > +#include "standard-headers/linux/virtio_ids.h"
> > > +#include "hw/boards.h"
> > > +#include "hw/i386/pc.h"
> > > +
> > > +#define TYPE_VIRTIO_PMEM "virtio-pmem"
> > > +
> > > +#define VIRTIO_PMEM(obj) \
> > > +        OBJECT_CHECK(VirtIOPMEM, (obj), TYPE_VIRTIO_PMEM)
> > > +
> > > +/* VirtIOPMEM device structure */
> > > +typedef struct VirtIOPMEM {
> > > +    VirtIODevice parent_obj;
> > > +
> > > +    VirtQueue *rq_vq;
> > > +    uint64_t start;
> > > +    uint64_t size;
> > > +    MemoryRegion mr;
> > > +    HostMemoryBackend *memdev;
> > > +} VirtIOPMEM;
> > > +
> > > +struct virtio_pmem_config {
> > > +    uint64_t start;
> > > +    uint64_t size;
> > > +};
> > > +#endif
> > > diff --git a/include/standard-headers/linux/virtio_ids.h
> > > b/include/standard-headers/linux/virtio_ids.h
> > > index 6d5c3b2d4f..346389565a 100644
> > > --- a/include/standard-headers/linux/virtio_ids.h
> > > +++ b/include/standard-headers/linux/virtio_ids.h
> > > @@ -43,5 +43,6 @@
> > >  #define VIRTIO_ID_INPUT        18 /* virtio input */
> > >  #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
> > >  #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
> > > +#define VIRTIO_ID_PMEM         25 /* virtio pmem */
> > >  
> > >  #endif /* _LINUX_VIRTIO_IDS_H */
> > > diff --git a/qapi/misc.json b/qapi/misc.json
> > > index d450cfef21..517376b866 100644
> > > --- a/qapi/misc.json
> > > +++ b/qapi/misc.json
> > > @@ -2907,6 +2907,29 @@
> > >            }
> > >  }
> > >  
> > > +##
> > > +# @VirtioPMemDeviceInfo:
> > > +#
> > > +# VirtioPMem state information
> > > +#
> > > +# @id: device's ID
> > > +#
> > > +# @start: physical address, where device is mapped
> > > +#
> > > +# @size: size of memory that the device provides
> > > +#
> > > +# @memdev: memory backend linked with device
> > > +#
> > > +# Since: 3.1
> > > +##
> > > +{ 'struct': 'VirtioPMemDeviceInfo',
> > > +  'data': { '*id': 'str',
> > > +            'start': 'size',
> > > +            'size': 'size',
> > > +            'memdev': 'str'
> > > +          }
> > > +}
> > > +
> > >  ##
> > >  # @MemoryDeviceInfo:
> > >  #
> > > @@ -2916,7 +2939,8 @@
> > >  ##
> > >  { 'union': 'MemoryDeviceInfo',
> > >    'data': { 'dimm': 'PCDIMMDeviceInfo',
> > > -            'nvdimm': 'PCDIMMDeviceInfo'
> > > +            'nvdimm': 'PCDIMMDeviceInfo',
> > > +	    'virtio-pmem': 'VirtioPMemDeviceInfo'
> > >            }
> > >  }
> > >    
> > 
> >   
> 
