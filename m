From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [Qemu-devel] [RFC v3] qemu: Add virtio pmem device
Date: Thu, 19 Jul 2018 13:16:35 +0100
Message-ID: <20180719121635.GA28107@stefanha-x1.localdomain>
References: <20180713075232.9575-1-pagupta@redhat.com>
 <20180713075232.9575-4-pagupta@redhat.com>
 <20180718085529.133a0a22@doriath>
 <367397176.52317488.1531979293251.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <367397176.52317488.1531979293251.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pankaj Gupta <pagupta@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>, kwolf@redhat.com, haozhong zhang <haozhong.zhang@intel.com>, jack@suse.cz, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm@vger.kernel.org, riel@surriel.com, linux-nvdimm@ml01.01.org, david@redhat.com, ross zwisler <ross.zwisler@intel.com>, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, hch@infradead.org, imammedo@redhat.com, mst@redhat.com, niteshnarayanlal@hotmail.com, pbonzini@redhat.com, dan j williams <dan.j.williams@intel.com>, nilal@redhat.com
List-Id: linux-nvdimm@lists.01.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 19, 2018 at 01:48:13AM -0400, Pankaj Gupta wrote:
>=20
> >=20
> > >  This patch adds virtio-pmem Qemu device.
> > >=20
> > >  This device presents memory address range information to guest
> > >  which is backed by file backend type. It acts like persistent
> > >  memory device for KVM guest. Guest can perform read and persistent
> > >  write operations on this memory range with the help of DAX capable
> > >  filesystem.
> > >=20
> > >  Persistent guest writes are assured with the help of virtio based
> > >  flushing interface. When guest userspace space performs fsync on
> > >  file fd on pmem device, a flush command is send to Qemu over VIRTIO
> > >  and host side flush/sync is done on backing image file.
> > >=20
> > > Changes from RFC v2:
> > > - Use aio_worker() to avoid Qemu from hanging with blocking fsync
> > >   call - Stefan
> > > - Use virtio_st*_p() for endianess - Stefan
> > > - Correct indentation in qapi/misc.json - Eric
> > >=20
> > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > ---
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
> > >=20
> > > diff --git a/hw/virtio/Makefile.objs b/hw/virtio/Makefile.objs
> > > index 1b2799cfd8..7f914d45d0 100644
> > > --- a/hw/virtio/Makefile.objs
> > > +++ b/hw/virtio/Makefile.objs
> > > @@ -10,6 +10,9 @@ obj-$(CONFIG_VIRTIO_CRYPTO) +=3D virtio-crypto.o
> > >  obj-$(call land,$(CONFIG_VIRTIO_CRYPTO),$(CONFIG_VIRTIO_PCI)) +=3D
> > >  virtio-crypto-pci.o
> > > =20
> > >  obj-$(CONFIG_LINUX) +=3D vhost.o vhost-backend.o vhost-user.o
> > > +ifeq ($(CONFIG_MEM_HOTPLUG),y)
> > > +obj-$(CONFIG_LINUX) +=3D virtio-pmem.o
> > > +endif
> > >  obj-$(CONFIG_VHOST_VSOCK) +=3D vhost-vsock.o
> > >  endif
> > > =20
> > > diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> > > index 3a01fe90f0..93d3fc05c7 100644
> > > --- a/hw/virtio/virtio-pci.c
> > > +++ b/hw/virtio/virtio-pci.c
> > > @@ -2521,6 +2521,49 @@ static const TypeInfo virtio_rng_pci_info =3D {
> > >      .class_init    =3D virtio_rng_pci_class_init,
> > >  };
> > > =20
> > > +/* virtio-pmem-pci */
> > > +
> > > +static void virtio_pmem_pci_realize(VirtIOPCIProxy *vpci_dev, Error
> > > **errp)
> > > +{
> > > +    VirtIOPMEMPCI *vpmem =3D VIRTIO_PMEM_PCI(vpci_dev);
> > > +    DeviceState *vdev =3D DEVICE(&vpmem->vdev);
> > > +
> > > +    qdev_set_parent_bus(vdev, BUS(&vpci_dev->bus));
> > > +    object_property_set_bool(OBJECT(vdev), true, "realized", errp);
> > > +}
> > > +
> > > +static void virtio_pmem_pci_class_init(ObjectClass *klass, void *dat=
a)
> > > +{
> > > +    DeviceClass *dc =3D DEVICE_CLASS(klass);
> > > +    VirtioPCIClass *k =3D VIRTIO_PCI_CLASS(klass);
> > > +    PCIDeviceClass *pcidev_k =3D PCI_DEVICE_CLASS(klass);
> > > +    k->realize =3D virtio_pmem_pci_realize;
> > > +    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
> > > +    pcidev_k->vendor_id =3D PCI_VENDOR_ID_REDHAT_QUMRANET;
> > > +    pcidev_k->device_id =3D PCI_DEVICE_ID_VIRTIO_PMEM;
> > > +    pcidev_k->revision =3D VIRTIO_PCI_ABI_VERSION;
> > > +    pcidev_k->class_id =3D PCI_CLASS_OTHERS;
> > > +}
> > > +
> > > +static void virtio_pmem_pci_instance_init(Object *obj)
> > > +{
> > > +    VirtIOPMEMPCI *dev =3D VIRTIO_PMEM_PCI(obj);
> > > +
> > > +    virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
> > > +                                TYPE_VIRTIO_PMEM);
> > > +    object_property_add_alias(obj, "memdev", OBJECT(&dev->vdev), "me=
mdev",
> > > +                              &error_abort);
> > > +}
> > > +
> > > +static const TypeInfo virtio_pmem_pci_info =3D {
> > > +    .name          =3D TYPE_VIRTIO_PMEM_PCI,
> > > +    .parent        =3D TYPE_VIRTIO_PCI,
> > > +    .instance_size =3D sizeof(VirtIOPMEMPCI),
> > > +    .instance_init =3D virtio_pmem_pci_instance_init,
> > > +    .class_init    =3D virtio_pmem_pci_class_init,
> > > +};
> > > +
> > > +
> > >  /* virtio-input-pci */
> > > =20
> > >  static Property virtio_input_pci_properties[] =3D {
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
> > > @@ -57,6 +58,7 @@ typedef struct VirtIOInputHostPCI VirtIOInputHostPC=
I;
> > >  typedef struct VirtIOGPUPCI VirtIOGPUPCI;
> > >  typedef struct VHostVSockPCI VHostVSockPCI;
> > >  typedef struct VirtIOCryptoPCI VirtIOCryptoPCI;
> > > +typedef struct VirtIOPMEMPCI VirtIOPMEMPCI;
> > > =20
> > >  /* virtio-pci-bus */
> > > =20
> > > @@ -274,6 +276,18 @@ struct VirtIOBlkPCI {
> > >      VirtIOBlock vdev;
> > >  };
> > > =20
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
> > > index 0000000000..08c96d7e80
> > > --- /dev/null
> > > +++ b/hw/virtio/virtio-pmem.c
> > > @@ -0,0 +1,241 @@
> > > +/*
> > > + * Virtio pmem device
> > > + *
> > > + * Copyright (C) 2018 Red Hat, Inc.
> > > + * Copyright (C) 2018 Pankaj Gupta <pagupta@redhat.com>
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
> > > +    VirtIODeviceRequest *req =3D opaque;
> > > +    int err =3D 0;
> > > +
> > > +    /* flush raw backing image */
> > > +    err =3D fsync(req->fd);
> > > +    if (err !=3D 0) {
> > > +        err =3D errno;
> > > +    }
> > > +    req->resp.ret =3D err;
> >=20
> > Host question: are you returning the guest errno code to the host?
>=20
> No. I am returning error code from the host in-case of host fsync
> failure, otherwise returning zero.

I think that's what Luiz meant.  errno constants are not portable
between operating systems and architectures.  Therefore they cannot be
used in external interfaces in software that expects to communicate with
other systems.

It will be necessary to define specific constants for virtio-pmem
instead of passing errno from the host to guest.

Stefan

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJbUIEjAAoJEJykq7OBq3PIJxgIALhsccHLQSqX6n5jXBBdCxLY
tik3zenShvVbzv4cXvBPRD9kHFQXEet9f5/GLVidUmtgjo9KIydkL23hRfS+CGm1
ducL6odYDnFD2tIatTJ6ooQ0JMm5yuM4v/CTerwzPHdN/r9URo8vhwbXufeXq6UZ
GMNlAuDSgziDeGjrQQ0bcd6UUwGUBgxnkYM+AuvZXzOpIgNaBSWuFR4pNQi+cRqQ
6rsVUNMJulo9fJsVHqjhrgnnfR5PammV0cRe4STDkWlevRESbhK7N+uWxbK868Es
vXdPzKUUSqwIUksdoy82VuPiOxAVBF5f6EMQ0BSDZORMGKZR5A9hv+eGIX2XvnY=
=wLDi
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
