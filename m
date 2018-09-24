From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [PATCH 3/3] virtio-pmem: Add virtio pmem driver
Date: Mon, 24 Sep 2018 05:41:59 -0400 (EDT)
Message-ID: <1204243972.15515798.1537782119951.JavaMail.zimbra@redhat.com>
References: <20180831133019.27579-1-pagupta@redhat.com> <20180831133019.27579-4-pagupta@redhat.com> <CAPcyv4gy-ONZz=PnXN92xYnyRX0rhu7Oq-_jPWJekbYQjNKRiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gy-ONZz=PnXN92xYnyRX0rhu7Oq-_jPWJekbYQjNKRiw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Rik van Riel <riel@surriel.com>, Nitesh Narayan Lal <nilal@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Ross Zwisler <ross.zwisler@intel.com>, David Hildenbrand <david@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Christoph Hellwig <hch@infradead.org>, "Michael S. Tsirkin" <mst@redhat.com>, niteshnarayanlal@hotmail.com, lcapitulino@redhat.com, Igor Mammedov <imammedo@redhat.com>, Eric Blake <eblake@redhat.com>
List-Id: linux-nvdimm@lists.01.org

Hi Dan,

Thanks for the review. Please find my reply inline.

> > This patch adds virtio-pmem driver for KVM guest.
> >
> > Guest reads the persistent memory range information from
> > Qemu over VIRTIO and registers it on nvdimm_bus. It also
> > creates a nd_region object with the persistent memory
> > range information so that existing 'nvdimm/pmem' driver
> > can reserve this into system memory map. This way
> > 'virtio-pmem' driver uses existing functionality of pmem
> > driver to register persistent memory compatible for DAX
> > capable filesystems.
> >
> > This also provides function to perform guest flush over
> > VIRTIO from 'pmem' driver when userspace performs flush
> > on DAX memory range.
> >
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  drivers/virtio/Kconfig           |   9 ++
> >  drivers/virtio/Makefile          |   1 +
> >  drivers/virtio/virtio_pmem.c     | 255
> >  +++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/virtio_ids.h  |   1 +
> >  include/uapi/linux/virtio_pmem.h |  40 ++++++
> >  5 files changed, 306 insertions(+)
> >  create mode 100644 drivers/virtio/virtio_pmem.c
> >  create mode 100644 include/uapi/linux/virtio_pmem.h
> >
> > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > index 3589764..a331e23 100644
> > --- a/drivers/virtio/Kconfig
> > +++ b/drivers/virtio/Kconfig
> > @@ -42,6 +42,15 @@ config VIRTIO_PCI_LEGACY
> >
> >           If unsure, say Y.
> >
> > +config VIRTIO_PMEM
> > +       tristate "Support for virtio pmem driver"
> > +       depends on VIRTIO
> > +       help
> > +       This driver provides support for virtio based flushing interface
> > +       for persistent memory range.
> > +
> > +       If unsure, say M.
> > +
> >  config VIRTIO_BALLOON
> >         tristate "Virtio balloon driver"
> >         depends on VIRTIO
> > diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> > index 3a2b5c5..cbe91c6 100644
> > --- a/drivers/virtio/Makefile
> > +++ b/drivers/virtio/Makefile
> > @@ -6,3 +6,4 @@ virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
> >  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
> >  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
> >  obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
> > +obj-$(CONFIG_VIRTIO_PMEM) += virtio_pmem.o
> > diff --git a/drivers/virtio/virtio_pmem.c b/drivers/virtio/virtio_pmem.c
> > new file mode 100644
> > index 0000000..c22cc87
> > --- /dev/null
> > +++ b/drivers/virtio/virtio_pmem.c
> > @@ -0,0 +1,255 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * virtio_pmem.c: Virtio pmem Driver
> > + *
> > + * Discovers persistent memory range information
> > + * from host and provides a virtio based flushing
> > + * interface.
> > + */
> > +#include <linux/virtio.h>
> > +#include <linux/module.h>
> > +#include <linux/virtio_ids.h>
> > +#include <linux/virtio_config.h>
> > +#include <uapi/linux/virtio_pmem.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/libnvdimm.h>
> > +#include <linux/nd.h>
> 
> I think we need to split this driver into 2 files,
> drivers/virtio/pmem.c would discover and register the virtual pmem
> device with the libnvdimm core, and drivers/nvdimm/virtio.c would
> house virtio_pmem_flush().

o.k. Will split the driver into two files as suggested.

> 
> > +
> > +struct virtio_pmem_request {
> > +       /* Host return status corresponding to flush request */
> > +       int ret;
> > +
> > +       /* command name*/
> > +       char name[16];
> > +
> > +       /* Wait queue to process deferred work after ack from host */
> > +       wait_queue_head_t host_acked;
> > +       bool done;
> > +
> > +       /* Wait queue to process deferred work after virt queue buffer
> > avail */
> > +       wait_queue_head_t wq_buf;
> 
> Why does this need wait_queue's per request? shouldn't this be per-device?

This is used to wait flush calling threads when virtio queue is full. 
wait_queue in request struct binds waitqueue and request. When host acknowledges
guest, first waiting request is selected and corresponding thread is woken-up.

Alternatively, we can use "add_wait_queue_exclusive" with device wait_queue.
This will wake up only one exclusive process waiting. This will avoid using 
additional list for tracking.

> 
> > +       bool wq_buf_avail;
> > +       struct list_head list;
> > +};
> > +
> > +struct virtio_pmem {
> > +       struct virtio_device *vdev;
> > +
> > +       /* Virtio pmem request queue */
> > +       struct virtqueue *req_vq;
> > +
> > +       /* nvdimm bus registers virtio pmem device */
> > +       struct nvdimm_bus *nvdimm_bus;
> > +       struct nvdimm_bus_descriptor nd_desc;
> > +
> > +       /* List to store deferred work if virtqueue is full */
> > +       struct list_head req_list;
> > +
> > +       /* Synchronize virtqueue data */
> > +       spinlock_t pmem_lock;
> > +
> > +       /* Memory region information */
> > +       uint64_t start;
> > +       uint64_t size;
> > +};
> > +
> > +static struct virtio_device_id id_table[] = {
> > +       { VIRTIO_ID_PMEM, VIRTIO_DEV_ANY_ID },
> > +       { 0 },
> > +};
> > +
> > + /* The interrupt handler */
> > +static void host_ack(struct virtqueue *vq)
> > +{
> > +       unsigned int len;
> > +       unsigned long flags;
> > +       struct virtio_pmem_request *req, *req_buf;
> > +       struct virtio_pmem *vpmem = vq->vdev->priv;
> > +
> > +       spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > +       while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
> > +               req->done = true;
> > +               wake_up(&req->host_acked);
> > +
> > +               if (!list_empty(&vpmem->req_list)) {
> > +                       req_buf = list_first_entry(&vpmem->req_list,
> > +                                       struct virtio_pmem_request, list);
> > +                       list_del(&vpmem->req_list);
> > +                       req_buf->wq_buf_avail = true;
> > +                       wake_up(&req_buf->wq_buf);
> > +               }
> > +       }
> > +       spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > +}
> > + /* Initialize virt queue */
> > +static int init_vq(struct virtio_pmem *vpmem)
> > +{
> > +       struct virtqueue *vq;
> > +
> > +       /* single vq */
> > +       vpmem->req_vq = vq = virtio_find_single_vq(vpmem->vdev,
> > +                               host_ack, "flush_queue");
> > +       if (IS_ERR(vq))
> > +               return PTR_ERR(vq);
> > +
> > +       spin_lock_init(&vpmem->pmem_lock);
> > +       INIT_LIST_HEAD(&vpmem->req_list);
> > +
> > +       return 0;
> > +};
> > +
> > + /* The request submission function */
> > +static int virtio_pmem_flush(struct nd_region *nd_region)
> > +{
> > +       int err;
> > +       unsigned long flags;
> > +       struct scatterlist *sgs[2], sg, ret;
> > +       struct virtio_device *vdev =
> > +               dev_to_virtio(nd_region->dev.parent->parent);
> 
> That's a long de-ref chain I would just stash the vdev in
> nd_region->provider_data.

Sure. Will use 'nd_region->provider_data' for vdev.

> 
> > +       struct virtio_pmem *vpmem = vdev->priv;
> > +       struct virtio_pmem_request *req = kmalloc(sizeof(*req),
> > GFP_KERNEL);
> > +
> > +       if (!req)
> > +               return -ENOMEM;
> > +
> > +       req->done = req->wq_buf_avail = false;
> > +       strcpy(req->name, "FLUSH");
> > +       init_waitqueue_head(&req->host_acked);
> > +       init_waitqueue_head(&req->wq_buf);
> > +
> > +       spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > +       sg_init_one(&sg, req->name, strlen(req->name));
> > +       sgs[0] = &sg;
> > +       sg_init_one(&ret, &req->ret, sizeof(req->ret));
> > +       sgs[1] = &ret;
> > +       err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC);
> > +       if (err) {
> > +               dev_err(&vdev->dev, "failed to send command to virtio pmem
> > device\n");
> > +
> > +               list_add_tail(&vpmem->req_list, &req->list);
> > +               spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > +
> > +               /* When host has read buffer, this completes via host_ack
> > */
> > +               wait_event(req->wq_buf, req->wq_buf_avail);
> > +               spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > +       }
> > +       virtqueue_kick(vpmem->req_vq);
> > +       spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > +
> > +       /* When host has read buffer, this completes via host_ack */
> > +       wait_event(req->host_acked, req->done);
> 
> Hmm, this seems awkward if this is called from pmem_make_request. If
> we need to wait for completion that should be managed by the guest
> block layer. I.e. make_request should just queue request and then
> trigger bio_endio() when the response comes back.

We are plugging VIRTIO based flush callback for virtio_pmem driver. If pmem 
driver (pmem_make_request) has to queue request we have to plug "blk_mq_ops" 
callbacks for corresponding  VIRTIO vqs. AFAICU there is no existing multiqueue 
code merged for pmem driver yet, though i could see patches by Dave upstream.

Anything I am missing here?   

> 
> However this does mean that nvdimm_flush() becomes asynchronous. So
> maybe we need to pass in a 'sync' flag or the bio directly to indicate
> this is an asynchronous flush request from pmem_make_request() vs a
> synchronous one from nsio_rw_bytes().

Sure.

> 
> > +       err = req->ret;
> > +       kfree(req);
> > +
> > +       return err;
> > +};
> > +EXPORT_SYMBOL_GPL(virtio_pmem_flush);
> > +
> > +static int virtio_pmem_probe(struct virtio_device *vdev)
> > +{
> > +       int err = 0;
> > +       struct resource res;
> > +       struct virtio_pmem *vpmem;
> > +       struct nvdimm_bus *nvdimm_bus;
> > +       struct nd_region_desc ndr_desc;
> > +       int nid = dev_to_node(&vdev->dev);
> > +       struct nd_region *nd_region;
> > +
> > +       if (!vdev->config->get) {
> > +               dev_err(&vdev->dev, "%s failure: config disabled\n",
> > +                       __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       vdev->priv = vpmem = devm_kzalloc(&vdev->dev, sizeof(*vpmem),
> > +                       GFP_KERNEL);
> > +       if (!vpmem) {
> > +               err = -ENOMEM;
> > +               goto out_err;
> > +       }
> > +
> > +       vpmem->vdev = vdev;
> > +       err = init_vq(vpmem);
> > +       if (err)
> > +               goto out_err;
> > +
> > +       virtio_cread(vpmem->vdev, struct virtio_pmem_config,
> > +                       start, &vpmem->start);
> > +       virtio_cread(vpmem->vdev, struct virtio_pmem_config,
> > +                       size, &vpmem->size);
> > +
> > +       res.start = vpmem->start;
> > +       res.end   = vpmem->start + vpmem->size-1;
> > +       vpmem->nd_desc.provider_name = "virtio-pmem";
> > +       vpmem->nd_desc.module = THIS_MODULE;
> > +
> > +       vpmem->nvdimm_bus = nvdimm_bus = nvdimm_bus_register(&vdev->dev,
> > +                                               &vpmem->nd_desc);
> > +       if (!nvdimm_bus)
> > +               goto out_vq;
> > +
> > +       dev_set_drvdata(&vdev->dev, nvdimm_bus);
> > +       memset(&ndr_desc, 0, sizeof(ndr_desc));
> > +
> > +       ndr_desc.res = &res;
> > +       ndr_desc.numa_node = nid;
> > +       ndr_desc.flush = virtio_pmem_flush;
> > +       set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > +       nd_region = nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc);
> > +
> > +       if (!nd_region)
> > +               goto out_nd;
> > +
> > +       //virtio_device_ready(vdev);
> > +       return 0;
> > +out_nd:
> > +       err = -ENXIO;
> > +       nvdimm_bus_unregister(nvdimm_bus);
> > +out_vq:
> > +       vdev->config->del_vqs(vdev);
> > +out_err:
> > +       dev_err(&vdev->dev, "failed to register virtio pmem memory\n");
> > +       return err;
> > +}
> > +
> > +static void virtio_pmem_remove(struct virtio_device *vdev)
> > +{
> > +       struct virtio_pmem *vpmem = vdev->priv;
> > +       struct nvdimm_bus *nvdimm_bus = dev_get_drvdata(&vdev->dev);
> > +
> > +       nvdimm_bus_unregister(nvdimm_bus);
> > +       vdev->config->del_vqs(vdev);
> > +       kfree(vpmem);
> > +}
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int virtio_pmem_freeze(struct virtio_device *vdev)
> > +{
> > +       /* todo: handle freeze function */
> > +       return -EPERM;
> > +}
> > +
> > +static int virtio_pmem_restore(struct virtio_device *vdev)
> > +{
> > +       /* todo: handle restore function */
> > +       return -EPERM;
> > +}
> > +#endif
> 
> As far as I can see there's nothing to do on a power transition, I
> would just omit this completely.

o.k Will remove these handlers.

> 
> > +
> > +
> > +static struct virtio_driver virtio_pmem_driver = {
> > +       .driver.name            = KBUILD_MODNAME,
> > +       .driver.owner           = THIS_MODULE,
> > +       .id_table               = id_table,
> > +       .probe                  = virtio_pmem_probe,
> > +       .remove                 = virtio_pmem_remove,
> > +#ifdef CONFIG_PM_SLEEP
> > +       .freeze                 = virtio_pmem_freeze,
> > +       .restore                = virtio_pmem_restore,
> > +#endif
> > +};
> > +
> > +module_virtio_driver(virtio_pmem_driver);
> > +MODULE_DEVICE_TABLE(virtio, id_table);
> > +MODULE_DESCRIPTION("Virtio pmem driver");
> > +MODULE_LICENSE("GPL");
> > diff --git a/include/uapi/linux/virtio_ids.h
> > b/include/uapi/linux/virtio_ids.h
> > index 6d5c3b2..3463895 100644
> > --- a/include/uapi/linux/virtio_ids.h
> > +++ b/include/uapi/linux/virtio_ids.h
> > @@ -43,5 +43,6 @@
> >  #define VIRTIO_ID_INPUT        18 /* virtio input */
> >  #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
> >  #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
> > +#define VIRTIO_ID_PMEM         25 /* virtio pmem */
> >
> >  #endif /* _LINUX_VIRTIO_IDS_H */
> > diff --git a/include/uapi/linux/virtio_pmem.h
> > b/include/uapi/linux/virtio_pmem.h
> > new file mode 100644
> > index 0000000..c7c22a5
> > --- /dev/null
> > +++ b/include/uapi/linux/virtio_pmem.h
> > @@ -0,0 +1,40 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
> > + * anyone can use the definitions to implement compatible drivers/servers:
> 
> The SPDX identifier does not match this BSD license, and the whole
> point of the SPDX identifier is to get out of the need to have these
> large text blobs of license goop.

Right, just copied this. Will remove these BSD lines.

> 
> > + *
> > + *
> > + * Redistribution and use in source and binary forms, with or without
> > + * modification, are permitted provided that the following conditions
> > + * are met:
> > + * 1. Redistributions of source code must retain the above copyright
> > + *    notice, this list of conditions and the following disclaimer.
> > + * 2. Redistributions in binary form must reproduce the above copyright
> > + *    notice, this list of conditions and the following disclaimer in the
> > + *    documentation and/or other materials provided with the distribution.
> > + * 3. Neither the name of IBM nor the names of its contributors
> > + *    may be used to endorse or promote products derived from this
> > software
> > + *    without specific prior written permission.
> > + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> > ``AS IS''
> > + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
> > THE
> > + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
> > PURPOSE
> > + * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
> > + * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> > CONSEQUENTIAL
> > + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> > + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> > + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> > STRICT
> > + * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
> > WAY
> > + * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> > + * SUCH DAMAGE.
> > + *
> > + * Copyright (C) Red Hat, Inc., 2018-2019
> > + * Copyright (C) Pankaj Gupta <pagupta@redhat.com>, 2018
> > + */
> > +#ifndef _UAPI_LINUX_VIRTIO_PMEM_H
> > +#define _UAPI_LINUX_VIRTIO_PMEM_H
> > +
> > +struct virtio_pmem_config {
> > +       __le64 start;
> > +       __le64 size;
> > +};
> > +#endif
> 
> Why does this need to be in the uapi?

This struct is defined by userspace(Qemu) and used by kernel to fetch
values passed by qemu device.

Thanks,
Pankaj
