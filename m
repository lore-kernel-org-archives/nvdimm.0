From: Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC v3 2/2] virtio-pmem: Add virtio pmem driver
Date: Mon, 16 Jul 2018 10:03:11 -0400
Message-ID: <20180716100311.0149c873@doriath>
References: <20180713075232.9575-1-pagupta@redhat.com>
 <20180713075232.9575-3-pagupta@redhat.com>
 <20180713163827.74e9fc91@doriath>
 <633297685.51039804.1531741590092.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <633297685.51039804.1531741590092.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Mon, 16 Jul 2018 07:46:30 -0400 (EDT)
Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> >   
> > > This patch adds virtio-pmem driver for KVM guest.
> > > 
> > > Guest reads the persistent memory range information from Qemu over
> > > VIRTIO and registers it on nvdimm_bus. It also creates a nd_region
> > > object with the persistent memory range information so that existing
> > > 'nvdimm/pmem' driver can reserve this into system memory map. This way
> > > 'virtio-pmem' driver uses existing functionality of pmem driver to
> > > register persistent memory compatible for DAX capable filesystems.
> > > 
> > > This also provides function to perform guest flush over VIRTIO from
> > > 'pmem' driver when userspace performs flush on DAX memory range.
> > > 
> > > Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  drivers/virtio/Kconfig           |   9 ++
> > >  drivers/virtio/Makefile          |   1 +
> > >  drivers/virtio/virtio_pmem.c     | 190
> > >  +++++++++++++++++++++++++++++++++++++++
> > >  include/linux/virtio_pmem.h      |  44 +++++++++
> > >  include/uapi/linux/virtio_ids.h  |   1 +
> > >  include/uapi/linux/virtio_pmem.h |  40 +++++++++
> > >  6 files changed, 285 insertions(+)
> > >  create mode 100644 drivers/virtio/virtio_pmem.c
> > >  create mode 100644 include/linux/virtio_pmem.h
> > >  create mode 100644 include/uapi/linux/virtio_pmem.h
> > > 
> > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > index 3589764..a331e23 100644
> > > --- a/drivers/virtio/Kconfig
> > > +++ b/drivers/virtio/Kconfig
> > > @@ -42,6 +42,15 @@ config VIRTIO_PCI_LEGACY
> > >  
> > >  	  If unsure, say Y.
> > >  
> > > +config VIRTIO_PMEM
> > > +	tristate "Support for virtio pmem driver"
> > > +	depends on VIRTIO
> > > +	help
> > > +	This driver provides support for virtio based flushing interface
> > > +	for persistent memory range.
> > > +
> > > +	If unsure, say M.
> > > +
> > >  config VIRTIO_BALLOON
> > >  	tristate "Virtio balloon driver"
> > >  	depends on VIRTIO
> > > diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> > > index 3a2b5c5..cbe91c6 100644
> > > --- a/drivers/virtio/Makefile
> > > +++ b/drivers/virtio/Makefile
> > > @@ -6,3 +6,4 @@ virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
> > >  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
> > >  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
> > >  obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
> > > +obj-$(CONFIG_VIRTIO_PMEM) += virtio_pmem.o
> > > diff --git a/drivers/virtio/virtio_pmem.c b/drivers/virtio/virtio_pmem.c
> > > new file mode 100644
> > > index 0000000..6200b5e
> > > --- /dev/null
> > > +++ b/drivers/virtio/virtio_pmem.c
> > > @@ -0,0 +1,190 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * virtio_pmem.c: Virtio pmem Driver
> > > + *
> > > + * Discovers persistent memory range information
> > > + * from host and provides a virtio based flushing
> > > + * interface.
> > > + */
> > > +#include <linux/virtio.h>
> > > +#include <linux/module.h>
> > > +#include <linux/virtio_pmem.h>
> > > +
> > > +static struct virtio_device_id id_table[] = {
> > > +	{ VIRTIO_ID_PMEM, VIRTIO_DEV_ANY_ID },
> > > +	{ 0 },
> > > +};
> > > +
> > > + /* The interrupt handler */
> > > +static void host_ack(struct virtqueue *vq)
> > > +{
> > > +	unsigned int len;
> > > +	unsigned long flags;
> > > +	struct virtio_pmem_request *req;
> > > +	struct virtio_pmem *vpmem = vq->vdev->priv;
> > > +
> > > +	spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > > +	while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
> > > +		req->done = true;
> > > +		wake_up(&req->acked);
> > > +	}
> > > +	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);  
> > 
> > Honest question: why do you need to disable interrupts here?  
> 
> To avoid interrupt for VQ trying to take same spinlock already taken by process 
> context and resulting in deadlock. Looks like interrupts are already disabled in 
> function call, see [1]. But still to protect with any future work. 
> 
> [1]
>    vp_interrupt
>        vp_vring_interrupt
>            vring_interrupt

I think you're right, and I think I may have caused some confusion. See
below.

> >   
> > > +}
> > > + /* Initialize virt queue */
> > > +static int init_vq(struct virtio_pmem *vpmem)
> > > +{
> > > +	struct virtqueue *vq;
> > > +
> > > +	/* single vq */
> > > +	vpmem->req_vq = vq = virtio_find_single_vq(vpmem->vdev,
> > > +				host_ack, "flush_queue");
> > > +	if (IS_ERR(vq))
> > > +		return PTR_ERR(vq);
> > > +	spin_lock_init(&vpmem->pmem_lock);
> > > +
> > > +	return 0;
> > > +};
> > > +
> > > + /* The request submission function */
> > > +static int virtio_pmem_flush(struct device *dev)
> > > +{
> > > +	int err;
> > > +	unsigned long flags;
> > > +	struct scatterlist *sgs[2], sg, ret;
> > > +	struct virtio_device *vdev = dev_to_virtio(dev->parent->parent);
> > > +	struct virtio_pmem *vpmem = vdev->priv;
> > > +	struct virtio_pmem_request *req = kmalloc(sizeof(*req), GFP_KERNEL);  
> > 
> > Not checking kmalloc() return.  
> 
> Will add it.
> >   
> > > +
> > > +	req->done = false;
> > > +	init_waitqueue_head(&req->acked);
> > > +	spin_lock_irqsave(&vpmem->pmem_lock, flags);  
> > 
> > Why do you need spin_lock_irqsave()? There are two points consider:
> > 
> > 1. Will virtio_pmem_flush() ever be called with interrupts disabled?
> >    If yes, then it's broken since you should be using GFP_ATOMIC in the
> >    kmalloc() call and you can't call wait_event()  
> 
> Yes, GFP_ATOMIC should be right thing.
> 
> > 
> > 2. If virtio_pmem_flush() is never called with interrupts disabled, do
> >    you really need to disable interrupts? If yes, why?  
> 
> Same reason as discussed above. Data is shared between interrupt handler
> and process context 'virtio-pmem_flush' function. To avoid a deadlock resulting 
> between interrupt context and process context on same spinlock.
> 
> > 
> > Another point to consider is whether or not virtio_pmem_flush()
> > can be called from atomic context. nvdimm_flush() itself is called
> > from a few atomic sites, but I can't tell if virtio_pmem_flush()
> > will ever be called from those sites. If it can be called atomic
> > context, then item 1 applies here. If you're sure it can't, then
> > you should probably call might_sleep().  
> 
> I think 'virtio_pmem_flush' can be called from atomic context.

If you're certain of this, then everything I said in my previous
email should be correct (ie. GFP_ATOMIC in kmalloc() and the fact
that you can't sleep).

Now, if for some reason virtio_pmem_flush() is not called from
atomic context (say, because it's never called from the ACPI code),
then my review was wrong and I think your code is correct, since
you're disabling irqs to protect the virtqueue against the interrupt
handler. In this case you can sleep outside the atomic context.

> 
> Thanks,
> Pankaj
> 
> >   
> > > +
> > > +	sg_init_one(&sg, req, sizeof(req));
> > > +	sgs[0] = &sg;
> > > +	sg_init_one(&ret, &req->ret, sizeof(req->ret));
> > > +	sgs[1] = &ret;
> > > +	err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC);
> > > +	if (err) {
> > > +		dev_err(&vdev->dev, "failed to send command to virtio pmem device\n");
> > > +		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > > +		return -ENOSPC;
> > > +	}
> > > +	virtqueue_kick(vpmem->req_vq);
> > > +	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > > +
> > > +	/* When host has read buffer, this completes via host_ack */
> > > +	wait_event(req->acked, req->done);
> > > +	err = req->ret;
> > > +	kfree(req);
> > > +
> > > +	return err;
> > > +};
> > > +
> > > +static int virtio_pmem_probe(struct virtio_device *vdev)
> > > +{
> > > +	int err = 0;
> > > +	struct resource res;
> > > +	struct virtio_pmem *vpmem;
> > > +	struct nvdimm_bus *nvdimm_bus;
> > > +	struct nd_region_desc ndr_desc;
> > > +	int nid = dev_to_node(&vdev->dev);
> > > +	struct nd_region *nd_region;
> > > +
> > > +	if (!vdev->config->get) {
> > > +		dev_err(&vdev->dev, "%s failure: config disabled\n",
> > > +			__func__);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	vdev->priv = vpmem = devm_kzalloc(&vdev->dev, sizeof(*vpmem),
> > > +			GFP_KERNEL);
> > > +	if (!vpmem) {
> > > +		err = -ENOMEM;
> > > +		goto out_err;
> > > +	}
> > > +
> > > +	vpmem->vdev = vdev;
> > > +	err = init_vq(vpmem);
> > > +	if (err)
> > > +		goto out_err;
> > > +
> > > +	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
> > > +			start, &vpmem->start);
> > > +	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
> > > +			size, &vpmem->size);
> > > +
> > > +	res.start = vpmem->start;
> > > +	res.end   = vpmem->start + vpmem->size-1;
> > > +	vpmem->nd_desc.provider_name = "virtio-pmem";
> > > +	vpmem->nd_desc.module = THIS_MODULE;
> > > +
> > > +	vpmem->nvdimm_bus = nvdimm_bus = nvdimm_bus_register(&vdev->dev,
> > > +						&vpmem->nd_desc);
> > > +	if (!nvdimm_bus)
> > > +		goto out_vq;
> > > +
> > > +	dev_set_drvdata(&vdev->dev, nvdimm_bus);
> > > +	memset(&ndr_desc, 0, sizeof(ndr_desc));
> > > +
> > > +	ndr_desc.res = &res;
> > > +	ndr_desc.numa_node = nid;
> > > +	ndr_desc.flush = virtio_pmem_flush;
> > > +	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > > +	nd_region = nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc);
> > > +
> > > +	if (!nd_region)
> > > +		goto out_nd;
> > > +
> > > +	virtio_device_ready(vdev);
> > > +	return 0;
> > > +out_nd:
> > > +	err = -ENXIO;
> > > +	nvdimm_bus_unregister(nvdimm_bus);
> > > +out_vq:
> > > +	vdev->config->del_vqs(vdev);
> > > +out_err:
> > > +	dev_err(&vdev->dev, "failed to register virtio pmem memory\n");
> > > +	return err;
> > > +}
> > > +
> > > +static void virtio_pmem_remove(struct virtio_device *vdev)
> > > +{
> > > +	struct virtio_pmem *vpmem = vdev->priv;
> > > +	struct nvdimm_bus *nvdimm_bus = dev_get_drvdata(&vdev->dev);
> > > +
> > > +	nvdimm_bus_unregister(nvdimm_bus);
> > > +	vdev->config->del_vqs(vdev);
> > > +	kfree(vpmem);
> > > +}
> > > +
> > > +#ifdef CONFIG_PM_SLEEP
> > > +static int virtio_pmem_freeze(struct virtio_device *vdev)
> > > +{
> > > +	/* todo: handle freeze function */
> > > +	return -EPERM;
> > > +}
> > > +
> > > +static int virtio_pmem_restore(struct virtio_device *vdev)
> > > +{
> > > +	/* todo: handle restore function */
> > > +	return -EPERM;
> > > +}
> > > +#endif
> > > +
> > > +
> > > +static struct virtio_driver virtio_pmem_driver = {
> > > +	.driver.name		= KBUILD_MODNAME,
> > > +	.driver.owner		= THIS_MODULE,
> > > +	.id_table		= id_table,
> > > +	.probe			= virtio_pmem_probe,
> > > +	.remove			= virtio_pmem_remove,
> > > +#ifdef CONFIG_PM_SLEEP
> > > +	.freeze                 = virtio_pmem_freeze,
> > > +	.restore                = virtio_pmem_restore,
> > > +#endif
> > > +};
> > > +
> > > +module_virtio_driver(virtio_pmem_driver);
> > > +MODULE_DEVICE_TABLE(virtio, id_table);
> > > +MODULE_DESCRIPTION("Virtio pmem driver");
> > > +MODULE_LICENSE("GPL");
> > > diff --git a/include/linux/virtio_pmem.h b/include/linux/virtio_pmem.h
> > > new file mode 100644
> > > index 0000000..0f83d9c
> > > --- /dev/null
> > > +++ b/include/linux/virtio_pmem.h
> > > @@ -0,0 +1,44 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * virtio_pmem.h: virtio pmem Driver
> > > + *
> > > + * Discovers persistent memory range information
> > > + * from host and provides a virtio based flushing
> > > + * interface.
> > > + */
> > > +#ifndef _LINUX_VIRTIO_PMEM_H
> > > +#define _LINUX_VIRTIO_PMEM_H
> > > +
> > > +#include <linux/virtio_ids.h>
> > > +#include <linux/virtio_config.h>
> > > +#include <uapi/linux/virtio_pmem.h>
> > > +#include <linux/libnvdimm.h>
> > > +#include <linux/spinlock.h>
> > > +
> > > +struct virtio_pmem_request {
> > > +	/* Host return status corresponding to flush request */
> > > +	int ret;
> > > +
> > > +	/* Wait queue to process deferred work after ack from host */
> > > +	wait_queue_head_t acked;
> > > +	bool done;
> > > +};
> > > +
> > > +struct virtio_pmem {
> > > +	struct virtio_device *vdev;
> > > +
> > > +	/* Virtio pmem request queue */
> > > +	struct virtqueue *req_vq;
> > > +
> > > +	/* nvdimm bus registers virtio pmem device */
> > > +	struct nvdimm_bus *nvdimm_bus;
> > > +	struct nvdimm_bus_descriptor nd_desc;
> > > +
> > > +	/* Synchronize virtqueue data */
> > > +	spinlock_t pmem_lock;
> > > +
> > > +	/* Memory region information */
> > > +	uint64_t start;
> > > +	uint64_t size;
> > > +};
> > > +#endif
> > > diff --git a/include/uapi/linux/virtio_ids.h
> > > b/include/uapi/linux/virtio_ids.h
> > > index 6d5c3b2..3463895 100644
> > > --- a/include/uapi/linux/virtio_ids.h
> > > +++ b/include/uapi/linux/virtio_ids.h
> > > @@ -43,5 +43,6 @@
> > >  #define VIRTIO_ID_INPUT        18 /* virtio input */
> > >  #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
> > >  #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
> > > +#define VIRTIO_ID_PMEM         25 /* virtio pmem */
> > >  
> > >  #endif /* _LINUX_VIRTIO_IDS_H */
> > > diff --git a/include/uapi/linux/virtio_pmem.h
> > > b/include/uapi/linux/virtio_pmem.h
> > > new file mode 100644
> > > index 0000000..c7c22a5
> > > --- /dev/null
> > > +++ b/include/uapi/linux/virtio_pmem.h
> > > @@ -0,0 +1,40 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
> > > + * anyone can use the definitions to implement compatible drivers/servers:
> > > + *
> > > + *
> > > + * Redistribution and use in source and binary forms, with or without
> > > + * modification, are permitted provided that the following conditions
> > > + * are met:
> > > + * 1. Redistributions of source code must retain the above copyright
> > > + *    notice, this list of conditions and the following disclaimer.
> > > + * 2. Redistributions in binary form must reproduce the above copyright
> > > + *    notice, this list of conditions and the following disclaimer in the
> > > + *    documentation and/or other materials provided with the distribution.
> > > + * 3. Neither the name of IBM nor the names of its contributors
> > > + *    may be used to endorse or promote products derived from this
> > > software
> > > + *    without specific prior written permission.
> > > + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> > > ``AS IS''
> > > + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
> > > THE
> > > + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
> > > PURPOSE
> > > + * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
> > > + * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> > > CONSEQUENTIAL
> > > + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> > > + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> > > + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> > > STRICT
> > > + * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
> > > WAY
> > > + * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> > > + * SUCH DAMAGE.
> > > + *
> > > + * Copyright (C) Red Hat, Inc., 2018-2019
> > > + * Copyright (C) Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 2018
> > > + */
> > > +#ifndef _UAPI_LINUX_VIRTIO_PMEM_H
> > > +#define _UAPI_LINUX_VIRTIO_PMEM_H
> > > +
> > > +struct virtio_pmem_config {
> > > +	__le64 start;
> > > +	__le64 size;
> > > +};
> > > +#endif  
> > 
> > 
> >   
> 
