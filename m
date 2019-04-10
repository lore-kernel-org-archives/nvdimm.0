Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4BDB8212017F9
 for <linux-nvdimm@lists.01.org>; Wed, 10 Apr 2019 08:44:23 -0700 (PDT)
Date: Wed, 10 Apr 2019 11:44:21 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1051460502.20833720.1554911061402.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190410143826.GA7856@lap1>
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-3-pagupta@redhat.com>
 <20190410142426.5bf0d9a4.cohuck@redhat.com> <20190410143826.GA7856@lap1>
Subject: Re: [PATCH v5 2/5] virtio-pmem: Add virtio pmem driver
MIME-Version: 1.0
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
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: jack@suse.cz, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, stefanha@redhat.com, pbonzini@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, Cornelia Huck <cohuck@redhat.com>, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com, darrick wong <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>


> > 
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
> > >  drivers/nvdimm/virtio_pmem.c     |  88 ++++++++++++++++++++++
> > >  drivers/virtio/Kconfig           |  10 +++
> > >  drivers/virtio/Makefile          |   1 +
> > >  drivers/virtio/pmem.c            | 124 +++++++++++++++++++++++++++++++
> > >  include/linux/virtio_pmem.h      |  60 +++++++++++++++
> > >  include/uapi/linux/virtio_ids.h  |   1 +
> > >  include/uapi/linux/virtio_pmem.h |  10 +++
> > >  7 files changed, 294 insertions(+)
> > >  create mode 100644 drivers/nvdimm/virtio_pmem.c
> > >  create mode 100644 drivers/virtio/pmem.c
> > >  create mode 100644 include/linux/virtio_pmem.h
> > >  create mode 100644 include/uapi/linux/virtio_pmem.h
> > > 
> > (...)
> > > diff --git a/drivers/virtio/pmem.c b/drivers/virtio/pmem.c
> > > new file mode 100644
> > > index 000000000000..cc9de9589d56
> > > --- /dev/null
> > > +++ b/drivers/virtio/pmem.c
> > > @@ -0,0 +1,124 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * virtio_pmem.c: Virtio pmem Driver
> > > + *
> > > + * Discovers persistent memory range information
> > > + * from host and registers the virtual pmem device
> > > + * with libnvdimm core.
> > > + */
> > > +#include <linux/virtio_pmem.h>
> > > +#include <../../drivers/nvdimm/nd.h>
> > > +
> > > +static struct virtio_device_id id_table[] = {
> > > +	{ VIRTIO_ID_PMEM, VIRTIO_DEV_ANY_ID },
> > > +	{ 0 },
> > > +};
> > > +
> > > + /* Initialize virt queue */
> > > +static int init_vq(struct virtio_pmem *vpmem)
> > 
> > IMHO, you don't gain much by splitting off this function...
> 
> It make sense to have all the vq-init-related stuff in one function, so
> here pmem_lock and req_list are used only for the vq.

Yes.

> Saying that - maybe it would be better to have the 3 in one struct.
> 
> > 
> > > +{
> > > +	struct virtqueue *vq;
> > > +
> > > +	/* single vq */
> > > +	vpmem->req_vq = vq = virtio_find_single_vq(vpmem->vdev,
> > > +				host_ack, "flush_queue");
> > > +	if (IS_ERR(vq))
> > > +		return PTR_ERR(vq);
> > 
> > I'm personally not a fan of chained assignments... I think I'd just
> > drop the 'vq' variable and operate on vpmem->req_vq directly.
> 
> +1

Will drop extra vq.

> 
> > 
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
> > > +	struct nd_region_desc ndr_desc = {};
> > > +	int nid = dev_to_node(&vdev->dev);
> > > +	struct nd_region *nd_region;
> > > +
> > > +	if (!vdev->config->get) {
> > > +		dev_err(&vdev->dev, "%s failure: config disabled\n",
> > 
> > Maybe s/config disabled/config access disabled/ ? That seems to be the
> > more common message.
> > 
> > > +			__func__);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	vdev->priv = vpmem = devm_kzalloc(&vdev->dev, sizeof(*vpmem),
> > > +					GFP_KERNEL);
> > 
> > Here, the vpmem variable makes sense for convenience, but I'm again not
> > a fan of the chaining :)
> 
> +1

here as well.

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
> > 
> > And here :)
> > 
> > > +	if (!nvdimm_bus)
> > > +		goto out_vq;
> > > +
> > > +	dev_set_drvdata(&vdev->dev, nvdimm_bus);
> > > +
> > > +	ndr_desc.res = &res;
> > > +	ndr_desc.numa_node = nid;
> > > +	ndr_desc.flush = virtio_pmem_flush;
> > > +	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > > +	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> > > +	nd_region = nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc);
> > > +	nd_region->provider_data =  dev_to_virtio
> > > +					(nd_region->dev.parent->parent);
> > 
> > Isn't it clear that this parent chain will always end up at &vdev->dev?
> > Maybe simply set ->provider_data to vdev directly? (Does it need to
> > grab a reference count of the device, BTW?)
> > 
> > > +
> > > +	if (!nd_region)
> > > +		goto out_nd;
> > 
> > Probably better to do this check before you access nd_region's
> > members :)
> > 
> > > +
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
> > 
> > I haven't followed this around the nvdimm code, but is the nd_region
> > you created during probe cleaned up automatically, or would you need to
> > do something here?
> > 
> > > +	vdev->config->del_vqs(vdev);
> > > +	vdev->config->reset(vdev);
> > > +	kfree(vpmem);
> > 
> > You allocated vpmem via devm_kzalloc; isn't it freed automatically on
> > remove?
> > 
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
> > 
> > Only looked at this from the general virtio driver angle; seems fine
> > apart from some easy-to-fix issues and some personal style preference
> > things.
> 

Best regards,
Pankaj
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
