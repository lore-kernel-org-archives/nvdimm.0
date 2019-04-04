Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 48F9B211EC0F9
 for <linux-nvdimm@lists.01.org>; Wed,  3 Apr 2019 23:40:58 -0700 (PDT)
Date: Thu, 4 Apr 2019 09:40:18 +0300
From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [Qemu-devel] [PATCH v4 2/5] virtio-pmem: Add virtio pmem driver
Message-ID: <20190404064017.GA16459@lap1>
References: <20190403104018.23947-1-pagupta@redhat.com>
 <20190403104018.23947-3-pagupta@redhat.com>
 <20190403114328.GA17696@lap1>
 <519445273.17181191.1554295213412.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519445273.17181191.1554295213412.JavaMail.zimbra@redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Pankaj Gupta <pagupta@redhat.com>
Cc: jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, riel@surriel.com, stefanha@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com, darrick wong <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 03, 2019 at 08:40:13AM -0400, Pankaj Gupta wrote:
> 
> > Subject: Re: [Qemu-devel] [PATCH v4 2/5] virtio-pmem: Add virtio pmem driver
> > 
> > On Wed, Apr 03, 2019 at 04:10:15PM +0530, Pankaj Gupta wrote:
> > > This patch adds virtio-pmem driver for KVM guest.
> > > 
> > > Guest reads the persistent memory range information from
> > > Qemu over VIRTIO and registers it on nvdimm_bus. It also
> > > creates a nd_region object with the persistent memory
> > > range information so that existing 'nvdimm/pmem' driver
> > > can reserve this into system memory map. This way
> > > 'virtio-pmem' driver uses existing functionality of pmem
> > > driver to register persistent memory compatible for DAX
> > > capable filesystems.
> > > 
> > > This also provides function to perform guest flush over
> > > VIRTIO from 'pmem' driver when userspace performs flush
> > > on DAX memory range.
> > > 
> > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > ---
> > >  drivers/nvdimm/virtio_pmem.c     |  84 +++++++++++++++++++++
> > >  drivers/virtio/Kconfig           |  10 +++
> > >  drivers/virtio/Makefile          |   1 +
> > >  drivers/virtio/pmem.c            | 125 +++++++++++++++++++++++++++++++
> > >  include/linux/virtio_pmem.h      |  60 +++++++++++++++
> > >  include/uapi/linux/virtio_ids.h  |   1 +
> > >  include/uapi/linux/virtio_pmem.h |  10 +++
> > >  7 files changed, 291 insertions(+)
> > >  create mode 100644 drivers/nvdimm/virtio_pmem.c
> > >  create mode 100644 drivers/virtio/pmem.c
> > >  create mode 100644 include/linux/virtio_pmem.h
> > >  create mode 100644 include/uapi/linux/virtio_pmem.h
> > > 
> > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > > new file mode 100644
> > > index 000000000000..2a1b1ba2c1ff
> > > --- /dev/null
> > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > @@ -0,0 +1,84 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > 
> > Is this comment stile (//) acceptable?
> 
> In existing code, i can see same comment
> pattern for license at some places.

Is it preferred for new code?

> 
> > 
> > > +/*
> > > + * virtio_pmem.c: Virtio pmem Driver
> > > + *
> > > + * Discovers persistent memory range information
> > > + * from host and provides a virtio based flushing
> > > + * interface.
> > > + */
> > > +#include <linux/virtio_pmem.h>
> > > +#include "nd.h"
> > > +
> > > + /* The interrupt handler */
> > > +void host_ack(struct virtqueue *vq)
> > > +{
> > > +	unsigned int len;
> > > +	unsigned long flags;
> > > +	struct virtio_pmem_request *req, *req_buf;
> > > +	struct virtio_pmem *vpmem = vq->vdev->priv;
> > > +
> > > +	spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > > +	while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
> > > +		req->done = true;
> > > +		wake_up(&req->host_acked);
> > > +
> > > +		if (!list_empty(&vpmem->req_list)) {
> > > +			req_buf = list_first_entry(&vpmem->req_list,
> > > +					struct virtio_pmem_request, list);
> > > +			list_del(&vpmem->req_list);
> > > +			req_buf->wq_buf_avail = true;
> > > +			wake_up(&req_buf->wq_buf);
> > > +		}
> > > +	}
> > > +	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > > +}
> > > +EXPORT_SYMBOL_GPL(host_ack);
> > > +
> > > + /* The request submission function */
> > > +int virtio_pmem_flush(struct nd_region *nd_region)
> > > +{
> > > +	int err;
> > > +	unsigned long flags;
> > > +	struct scatterlist *sgs[2], sg, ret;
> > > +	struct virtio_device *vdev = nd_region->provider_data;
> > > +	struct virtio_pmem *vpmem = vdev->priv;
> > > +	struct virtio_pmem_request *req;
> > > +
> > > +	might_sleep();
> > 
> > [1]
> > 
> > > +	req = kmalloc(sizeof(*req), GFP_KERNEL);
> > > +	if (!req)
> > > +		return -ENOMEM;
> > > +
> > > +	req->done = req->wq_buf_avail = false;
> > > +	strcpy(req->name, "FLUSH");
> > > +	init_waitqueue_head(&req->host_acked);
> > > +	init_waitqueue_head(&req->wq_buf);
> > > +	sg_init_one(&sg, req->name, strlen(req->name));
> > > +	sgs[0] = &sg;
> > > +	sg_init_one(&ret, &req->ret, sizeof(req->ret));
> > > +	sgs[1] = &ret;
> > > +
> > > +	spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > > +	err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC);
> > 
> > Is it okay to use GFP_ATOMIC in a might-sleep ([1]) function?
> 
> might sleep will give us a warning if we try to sleep from non-sleepable
> context. 
> 
> We are doing it other way, i.e might_sleep is not inside GFP_ATOMIC. 
> 
> > 
> > > +	if (err) {
> > > +		dev_err(&vdev->dev, "failed to send command to virtio pmem device\n");
> > > +
> > > +		list_add_tail(&vpmem->req_list, &req->list);
> > > +		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > > +
> > > +		/* When host has read buffer, this completes via host_ack */
> > > +		wait_event(req->wq_buf, req->wq_buf_avail);
> > > +		spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > > +	}
> > > +	virtqueue_kick(vpmem->req_vq);
> > 
> > You probably want to check return value here.
> 
> Don't think it will matter in this case?

Have no idea, if it fails maybe you will never get to host_acked.

> 
> > 
> > > +	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > > +
> > > +	/* When host has read buffer, this completes via host_ack */
> > > +	wait_event(req->host_acked, req->done);
> > > +	err = req->ret;
> > > +	kfree(req);
> > > +
> > > +	return err;
> > > +};
> > > +EXPORT_SYMBOL_GPL(virtio_pmem_flush);
> > > +MODULE_LICENSE("GPL");
> > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > index 35897649c24f..9f634a2ed638 100644
> > > --- a/drivers/virtio/Kconfig
> > > +++ b/drivers/virtio/Kconfig
> > > @@ -42,6 +42,16 @@ config VIRTIO_PCI_LEGACY
> > >  
> > >  	  If unsure, say Y.
> > >  
> > > +config VIRTIO_PMEM
> > > +	tristate "Support for virtio pmem driver"
> > > +	depends on VIRTIO
> > > +	depends on LIBNVDIMM
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
> > > index 3a2b5c5dcf46..143ce91eabe9 100644
> > > --- a/drivers/virtio/Makefile
> > > +++ b/drivers/virtio/Makefile
> > > @@ -6,3 +6,4 @@ virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
> > >  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
> > >  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
> > >  obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
> > > +obj-$(CONFIG_VIRTIO_PMEM) += pmem.o ../nvdimm/virtio_pmem.o
> > > diff --git a/drivers/virtio/pmem.c b/drivers/virtio/pmem.c
> > > new file mode 100644
> > > index 000000000000..52f74064f67e
> > > --- /dev/null
> > > +++ b/drivers/virtio/pmem.c
> > > @@ -0,0 +1,125 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > 
> > Ditto
> > 
> > > +/*
> > > + * virtio_pmem.c: Virtio pmem Driver
> > > + *
> > > + * Discovers persistent memory range information
> > > + * from host and registers the virtual pmem device
> > > + * with libnvdimm core.
> > > + */
> > > +#include <linux/virtio_pmem.h>
> > > +#include <../../drivers/nvdimm/nd.h>
> > 
> > Should this file be moved to include/ directory?
> 
> We are not touching the directory structure of nd & nd_pmem
> kernel driver.

But since this file becomes public it should be considered, right?

> 
> > 
> > > +
> > > +static struct virtio_device_id id_table[] = {
> > > +	{ VIRTIO_ID_PMEM, VIRTIO_DEV_ANY_ID },
> > > +	{ 0 },
> > > +};
> > > +
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
> > > +
> > > +	spin_lock_init(&vpmem->pmem_lock);
> > > +	INIT_LIST_HEAD(&vpmem->req_list);
> > > +
> > > +	return 0;
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
> > 
> > Suggesting to indent it right so it will be under &vdev
> 
> o.k
> 
> > 
> > > +	if (!vpmem) {
> > > +		err = -ENOMEM;
> > > +		goto out_err;
> > > +	}
> > > +
> > > +	vpmem->vdev = vdev;
> > > +	err = init_vq(vpmem);
> > > +	if (err)
> > > +		goto out_err;
> > 
> > No need to free vpmem here?
> 
> No. devm_kzalloc will take care of it.

Nice.

> 
> > 
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
> > 
> > Ditto (i'm probably missing something here)
> > 
> > > +
> > > +	dev_set_drvdata(&vdev->dev, nvdimm_bus);
> > > +	memset(&ndr_desc, 0, sizeof(ndr_desc));
> > 
> > Any reason not to use compiler initialization?
> > i.e.
> > 	struct nd_region_desc ndr_desc = {};
> 
> will change.
> 
> > 
> > > +
> > > +	ndr_desc.res = &res;
> > > +	ndr_desc.numa_node = nid;
> > > +	ndr_desc.flush = virtio_pmem_flush;
> > > +	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > > +	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > > +	nd_region = nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc);
> > > +	nd_region->provider_data =  dev_to_virtio
> > > +					(nd_region->dev.parent->parent);
> > > +
> > > +	if (!nd_region)
> > > +		goto out_nd;
> > > +
> > > +	//virtio_device_ready(vdev);
> > 
> > Left over
> 
> o.k
> 
> > 
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
> > 
> > I think you should also call vdev->config->reset
> 
> o.k. Here device will be removed completely, still its required?

I had a bad experience with unloading virtio PCI driver and it gone after i
added call to 'reset'.
See the warning in function virtio_dev_remove.

> 
> > 
> > > +	kfree(vpmem);
> > > +}
> > > +
> > > +static struct virtio_driver virtio_pmem_driver = {
> > > +	.driver.name		= KBUILD_MODNAME,
> > > +	.driver.owner		= THIS_MODULE,
> > > +	.id_table		= id_table,
> > > +	.probe			= virtio_pmem_probe,
> > > +	.remove			= virtio_pmem_remove,
> > > +};
> > > +
> > > +module_virtio_driver(virtio_pmem_driver);
> > > +MODULE_DEVICE_TABLE(virtio, id_table);
> > > +MODULE_DESCRIPTION("Virtio pmem driver");
> > > +MODULE_LICENSE("GPL");
> > > diff --git a/include/linux/virtio_pmem.h b/include/linux/virtio_pmem.h
> > > new file mode 100644
> > > index 000000000000..224f9d934be6
> > > --- /dev/null
> > > +++ b/include/linux/virtio_pmem.h
> > > @@ -0,0 +1,60 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * virtio_pmem.h: virtio pmem Driver
> > > + *
> > > + * Discovers persistent memory range information
> > > + * from host and provides a virtio based flushing
> > > + * interface.
> > > + **/
> > > +
> > > +#ifndef _LINUX_VIRTIO_PMEM_H
> > > +#define _LINUX_VIRTIO_PMEM_H
> > > +
> > > +#include <linux/virtio_ids.h>
> > > +#include <linux/module.h>
> > > +#include <linux/virtio_config.h>
> > > +#include <uapi/linux/virtio_pmem.h>
> > > +#include <linux/libnvdimm.h>
> > > +#include <linux/spinlock.h>
> > > +
> > > +struct virtio_pmem_request {
> > > +	/* Host return status corresponding to flush request */
> > > +	int ret;
> > > +
> > > +	/* command name*/
> > > +	char name[16];
> > > +
> > > +	/* Wait queue to process deferred work after ack from host */
> > > +	wait_queue_head_t host_acked;
> > > +	bool done;
> > > +
> > > +	/* Wait queue to process deferred work after virt queue buffer avail */
> > > +	wait_queue_head_t wq_buf;
> > > +	bool wq_buf_avail;
> > > +	struct list_head list;
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
> > > +	/* List to store deferred work if virtqueue is full */
> > > +	struct list_head req_list;
> > > +
> > > +	/* Synchronize virtqueue data */
> > > +	spinlock_t pmem_lock;
> > > +
> > > +	/* Memory region information */
> > > +	uint64_t start;
> > > +	uint64_t size;
> > > +};
> > > +
> > > +void host_ack(struct virtqueue *vq);
> > > +int virtio_pmem_flush(struct nd_region *nd_region);
> > > +#endif
> > > diff --git a/include/uapi/linux/virtio_ids.h
> > > b/include/uapi/linux/virtio_ids.h
> > > index 6d5c3b2d4f4d..346389565ac1 100644
> > > --- a/include/uapi/linux/virtio_ids.h
> > > +++ b/include/uapi/linux/virtio_ids.h
> > > @@ -43,5 +43,6 @@
> > >  #define VIRTIO_ID_INPUT        18 /* virtio input */
> > >  #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
> > >  #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
> > > +#define VIRTIO_ID_PMEM         25 /* virtio pmem */
> > 
> > Any reason for the jump here? are 21 to 24 already taken or you just
> > want to be on the safe side?
> 
> They are already reserved.

Can you direct me to how to find a free ID?

> 
> Thanks,
> Pankaj
> 
> > 
> > >  
> > >  #endif /* _LINUX_VIRTIO_IDS_H */
> > > diff --git a/include/uapi/linux/virtio_pmem.h
> > > b/include/uapi/linux/virtio_pmem.h
> > > new file mode 100644
> > > index 000000000000..fa3f7d52717a
> > > --- /dev/null
> > > +++ b/include/uapi/linux/virtio_pmem.h
> > > @@ -0,0 +1,10 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +
> > > +#ifndef _UAPI_LINUX_VIRTIO_PMEM_H
> > > +#define _UAPI_LINUX_VIRTIO_PMEM_H
> > > +
> > > +struct virtio_pmem_config {
> > > +	__le64 start;
> > > +	__le64 size;
> > > +};
> > > +#endif
> > > --
> > > 2.20.1
> > > 
> > > 
> > 
> > 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
