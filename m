From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [RFC v3 2/2] virtio-pmem: Add virtio pmem driver
Date: Tue, 17 Jul 2018 14:11:56 +0100
Message-ID: <20180717131156.GA13498@stefanha-x1.localdomain>
References: <20180713075232.9575-1-pagupta@redhat.com>
 <20180713075232.9575-3-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180713075232.9575-3-pagupta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, jack@suse.cz, dan.j.williams@intel.com, riel@surriel.com, haozhong.zhang@intel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, ross.zwisler@intel.com, david@redhat.com, xiaoguangrong.eric@gmail.com, hch@infradead.org, mst@redhat.com, niteshnarayanlal@hotmail.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com
List-Id: linux-nvdimm@lists.01.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


On Fri, Jul 13, 2018 at 01:22:31PM +0530, Pankaj Gupta wrote:
> + /* The request submission function */
> +static int virtio_pmem_flush(struct device *dev)
> +{
> +	int err;
> +	unsigned long flags;
> +	struct scatterlist *sgs[2], sg, ret;
> +	struct virtio_device *vdev = dev_to_virtio(dev->parent->parent);
> +	struct virtio_pmem *vpmem = vdev->priv;
> +	struct virtio_pmem_request *req = kmalloc(sizeof(*req), GFP_KERNEL);
> +
> +	req->done = false;
> +	init_waitqueue_head(&req->acked);
> +	spin_lock_irqsave(&vpmem->pmem_lock, flags);
> +
> +	sg_init_one(&sg, req, sizeof(req));

What are you trying to do here?

sizeof(req) == sizeof(struct virtio_pmem_request *) == sizeof(void *)

Did you mean sizeof(*req)?

But why map struct virtio_pmem_request to the device?  struct
virtio_pmem_request is the driver-internal request state and is not part
of the hardware interface.

> +	sgs[0] = &sg;
> +	sg_init_one(&ret, &req->ret, sizeof(req->ret));
> +	sgs[1] = &ret;
> +	err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req, GFP_ATOMIC);
> +	if (err) {
> +		dev_err(&vdev->dev, "failed to send command to virtio pmem device\n");

This can happen if the virtqueue is full.  Printing a message and
failing the flush isn't appropriate.  This thread needs to wait until
virtqueue space becomes available.

> +		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> +		return -ENOSPC;

req is leaked.

> +	virtio_device_ready(vdev);

This call isn't needed.  Driver use it when they wish to submit buffers
on virtqueues before ->probe() returns.

> diff --git a/include/linux/virtio_pmem.h b/include/linux/virtio_pmem.h
> new file mode 100644
> index 0000000..0f83d9c
> --- /dev/null
> +++ b/include/linux/virtio_pmem.h

include/ is for declarations (e.g. kernel APIs) needed by other
compilation units.  The contents of this header are internal to the
virtio_pmem driver implementation and can therefore be in virtio_pmem.c.
include/linux/virtio_pmem.h isn't necessary since nothing besides
virtio_pmem.c will need to include it.

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJbTescAAoJEJykq7OBq3PIwPQH/3keU8xWbvv1c729mwMrCSlT
GRJkt3AyzE2iIoaXFkeBpnjnpARsajzX0vH/EheCEse46G6aOtia9fALOzf0Fo2l
XRB1KM3WhEDIx+xNZuk4/WH5AaSHEJPjSBM6Isv410MASfrDJzyu0vuRSjzqEAT8
augb75qojqCkqkDQm5iMcN6zGwgjJ0MLrXZdN8EKIpgsqeMW7QmwWCwlmWwCgXrq
f5nor6oEl3jci/EYjw6ctjWsBCSKdDz813phHbQLCbcMD9IuEngGlZt5b9XwdfNY
5u2SaC66cIPqMYyogb6duBFMZ2AOzkrSZjHbHyh1HArf7Lhd/aoYYMLABy/hwTs=
=0jCu
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
