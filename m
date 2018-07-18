From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v3 2/2] virtio-pmem: Add virtio pmem driver
Date: Wed, 18 Jul 2018 03:05:09 -0400 (EDT)
Message-ID: <2137768776.51859350.1531897509492.JavaMail.zimbra@redhat.com>
References: <20180713075232.9575-1-pagupta@redhat.com>
 <20180713075232.9575-3-pagupta@redhat.com>
 <20180717131156.GA13498@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180717131156.GA13498-lxVrvc10SDRcolVlb+j0YCZi+YwRKgec@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


Hi Stefan,

> > + /* The request submission function */
> > +static int virtio_pmem_flush(struct device *dev)
> > +{
> > +	int err;
> > +	unsigned long flags;
> > +	struct scatterlist *sgs[2], sg, ret;
> > +	struct virtio_device *vdev = dev_to_virtio(dev->parent->parent);
> > +	struct virtio_pmem *vpmem = vdev->priv;
> > +	struct virtio_pmem_request *req = kmalloc(sizeof(*req), GFP_KERNEL);
> > +
> > +	req->done = false;
> > +	init_waitqueue_head(&req->acked);
> > +	spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > +
> > +	sg_init_one(&sg, req, sizeof(req));
> 
> What are you trying to do here?
> 
> sizeof(req) == sizeof(struct virtio_pmem_request *) == sizeof(void *)
> 
> Did you mean sizeof(*req)?

yes, I meant: sizeof(struct virtio_pmem_request)

Thanks for catching this.

> 
> But why map struct virtio_pmem_request to the device?  struct
> virtio_pmem_request is the driver-internal request state and is not part
> of the hardware interface.

o.k. I will separate out request from 'virtio_pmem_request' struct
and use that. 

> 
> > +	sgs[0] = &sg;
> > +	sg_init_one(&ret, &req->ret, sizeof(req->ret));
> > +	sgs[1] = &ret;
> > +	err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC);
> > +	if (err) {
> > +		dev_err(&vdev->dev, "failed to send command to virtio pmem device\n");
> 
> This can happen if the virtqueue is full.  Printing a message and
> failing the flush isn't appropriate.  This thread needs to wait until
> virtqueue space becomes available.

o.k. I will implement this.

> 
> > +		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > +		return -ENOSPC;
> 
> req is leaked.

will free req.

> 
> > +	virtio_device_ready(vdev);
> 
> This call isn't needed.  Driver use it when they wish to submit buffers
> on virtqueues before ->probe() returns.

o.k. I will remove it.

> 
> > diff --git a/include/linux/virtio_pmem.h b/include/linux/virtio_pmem.h
> > new file mode 100644
> > index 0000000..0f83d9c
> > --- /dev/null
> > +++ b/include/linux/virtio_pmem.h
> 
> include/ is for declarations (e.g. kernel APIs) needed by other
> compilation units.  The contents of this header are internal to the
> virtio_pmem driver implementation and can therefore be in virtio_pmem.c.
> include/linux/virtio_pmem.h isn't necessary since nothing besides
> virtio_pmem.c will need to include it.

Agree. Will move declarations from virtio_pmem.h to virtio_pmem.c

Thanks,
Pankaj
