Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519993093CF
	for <nvdimm@lists.linux.dev>; Mon, 10 Aug 2026 20:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786394465; cv=none; b=azNOCiuEwnnd7BzqpcnrLNTie0tnPOjk+8tho6vlMX3ZWff0Yqkbn9WLOnQdPkZNeA0Guas6XPYX7NbtV4wJGbIvBQ1L/IQ57Htd2wGzPQPvw8VNtzWVWIYRUWfLI3P29yDxAKzszD1SFXM1uwwrjBm1xZ9OOhG9iae0//QcpvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786394465; c=relaxed/simple;
	bh=khTbQWWFV9bOrfXG+iqpW/ZtxmkD74y/07pmEqhXD30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vir2xoLTfHXggx94fXF+GCj7hr7wr7hTtjN9vByu2sbnRdASafBhE7BtBSuOWiathEye5KxyBWBbokOJOlsFTFyvuXOJb0pE+tHrq54lLfY8N0xpm8qoKvjpoe46o2CKqPY6fQkwXWNoZUDftPwBcIzeDqVwEtIwmtcCSNq/mjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XbfjpO8n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XbfjpO8n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786394462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBu07eFdsAaRS4DouGyS0AD72vCjFyZu2g7jKIa4PTw=;
	b=XbfjpO8nWfrKDmlgiBkEWQ9XsdII3C0cCo2M3nx28ICreNqyYnVBrIZrFeFF3MSgKM24FE
	dMJ41Dqrwt3H0CcNJ8JjocB+mcIhXU/vezJCJZ0NH01HVve+yY2YY26BwhaHdZGhxtIDPU
	fZseq3rB2pJlh985AzySjFWimCUStdQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-144-VnfPPCRKObiAty1uR5NNVQ-1; Mon,
 10 Aug 2026 16:39:10 -0400
X-MC-Unique: VnfPPCRKObiAty1uR5NNVQ-1
X-Mimecast-MFC-AGG-ID: VnfPPCRKObiAty1uR5NNVQ_1786394348
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C00A19560BB;
	Mon, 10 Aug 2026 20:39:07 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7FE851800347;
	Mon, 10 Aug 2026 20:39:05 +0000 (UTC)
Date: Mon, 10 Aug 2026 16:39:01 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: Jason Wang <jasowangio@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	David Airlie <airlied@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	dri-devel@lists.freedesktop.org,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Feng Liu <feliu@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>,
	Jiri Pirko <jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, nh-open-source@amazon.com,
	nvdimm@lists.linux.dev, Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Parav Pandit <parav@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	virtualization@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [RFC PATCH 00/12] virtio: support devices that own their
 virtqueue memory
Message-ID: <20260810203901.GA35278@fedora>
References: <20260809182010.32931-1-graf@amazon.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E1944FrHRiu7HOOY"
Content-Disposition: inline
In-Reply-To: <20260809182010.32931-1-graf@amazon.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

--E1944FrHRiu7HOOY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 09, 2026 at 06:19:58PM +0000, Alexander Graf wrote:
> Virtio drivers use guest memory to back virtqueues and their buffers.
> That means a VMM needs to be able to map guest memory. That is ok in the
> normal virt case. It gets icky with confidential computing (where we use
> swiotlb as workaround) and it defeats the purpose of isolated vhost-user
> backing devices, because they end up with full RAM access to the guest.
>=20
> So instead, I'm proposing an extension to virtio which allows it to give
> each virtio device its own dedicated memory region to communicate with the
> host, called DMB (Device Memory Buffer). A trusted hypervisor can force
> DMB to be present, which then enables safer, more isolated and resilient
> communication between guest and host.
>=20
> With DMB, the device provides a shared memory region that both parties
> agree is the full memory map both have access to. All memory offsets
> that previously would have been into guest RAM, are then offsets into
> this shared memory buffer region. One nice property of this is that it
> is a generic mechanism in the virtio transport layer, so higher level
> drivers work unmodified.

This is similar to VIRTIO's Shared Memory Regions. A problem with this
kind of approach is that guest software that depends on zero-copy,
O_DIRECT, the ability to mmap, etc may break when passing an address
=66rom one device to another device.

For example, a guest userspace application writing to a virtio-blk
device with O_DIRECT can pass any source memory buffer. One VIRTIO
device will be unable to address another VIRTIO device's DMB. This
problem also extends to vhost-user where one back-end cannot access
another back-end's DMB or Shared Memory Regions.

Maybe your use case will never hit this problem because you can rely on
the guest software never to assume zero-copy/O_DIRECT/etc works.
virtiofs hit it with its DAX Shared Memory Regions.

I'm mentioned it in case this is something you want to think about
before deploying this approach.

>=20
> I was exploring to use swiotlb instead to create individual pools. But
> that approach has multiple downsides:
>=20
> 1. Swiotlb is an OS primitive which is not available in all Operating
> Systems. DMB however lives in the virtio transport layer, which means we
> can add support for it in any OS independent of generic layers. This
> helps with Windows support.
>=20
> 2. We munge DMA space together. DMB provides a separate DMA space per
> virtio device. This means we can for example implement a device in
> vhost-user and give the implementing process only visibility to the DMB
> region, not all of guest memory. That reduces the exposure the
> vhost-user provider has, improving security.

Connor Kite is working on a different approach for vhost-user memory
isolation here:
https://lore.kernel.org/qemu-devel/20260723-vhost-user-isolated-memory-v1-0=
-6b97c439eb28@gmail.com/T/#t

It involves a bounce buffer at the VMM level. Unmodified vhost-user
back-ends never sees guest RAM. Guest drivers are also unmodified. The
cost of doing this is that the VMM has to intercept kick and call
eventfds in order to copy between the bounce buffer and guest RAM.

I don't see DMB or vhost-user memory isolation as conflicting features.
There can be two ways of solving the same problem with different
trade-offs. I just wanted to share a link to Connor's ongoing work.

>=20
> 3. Devices can opt-in. A hypervisor can choose to use standard virtio
> semantics for self-implemented devices (e.g. NSM), while requiring DMB
> for devices implemented by less trustworthy providers. The
> non-trustworthy devices do not get any visibility into the trustworthy
> ones, even with DMB in place for both.
>=20
> =3D=3D Limitations =3D=3D
>=20
>   - Only PCI is wired up.
>   - Feature bit 44 and the shared memory id register at offset 0x40 of the
>     PCI common configuration are provisional: the OASIS technical
>     committee has the specification and has allocated neither.
>=20
>   https://lore.kernel.org/virtio-comment/20260804161202.38619-1-graf@amaz=
on.com/
>=20
>   - The device I ran this against is not public, so you cannot reproduce
>     the numbers below. The KUnit test you can.
>=20
> =3D=3D Testing =3D=3D
>=20
> Without patches 10 and 12 a receive refill livelocks and queues starve
> each other: 29,319,791 receive softirqs in five seconds with not one
> packet received, against 4 with them, and 2 of 7 receive queues that never
> see a buffer, against none. Earlier revisions moved 512 MiB of O_DIRECT
> block I/O and 2.7 GB of verified vsock through a region with no error.
>=20
> The KUnit test for patch 12's guarantee you can run yourself, and two of
> its five cases fail if I take the fix out:
>=20
>   tools/testing/kunit/kunit.py run --arch=3Dx86_64 \
>       --kconfig_add CONFIG_VIRTIO_MMIO=3Dy \
>       --kconfig_add CONFIG_VIRTIO_DMB=3Dy virtio_dmb
>=20
> Patch 1 can be taken on its own: a stale worked example in a vdpa
> comment. Patch 10 fixes something older than this series too, a failed
> mapping arriving as -EIO from a packed ring, failing an I/O that on a
> split ring is only back-pressure, but it does not apply alone: it wants
> patch 2, and patch 9 for the file its documentation hunk edits. Both
> carry Fixes:. Patch 12 wants 10 first.
>=20
> I wrote this series with an AI coding assistant, which drafted the code,
> the changelogs and this cover letter. I reviewed and reworked all of it,
> and every commit carries an Assisted-by: trailer.
>=20
> Alex
>=20
> Alexander Graf (12):
>   vdpa: correct the VIRTIO_DEVICE_F_MASK example value
>   virtio_ring: validate premapped addresses through the device's map
>   virtio: add the VIRTIO_F_DMB feature bit
>   virtio_pci: read the device memory buffer shared memory id
>   virtio_pci: create virtqueues with the device's mapping token
>   virtio: add a device memory buffer region allocator
>   virtio: locate the device memory buffer after feature negotiation
>   virtio_pci: support VIRTIO_F_DMB
>   Documentation: virtio: describe the device memory buffer
>   virtio_ring: report a bounded pool's exhaustion as -ENOSPC
>   virtio: expose device memory buffer occupancy over debugfs
>   virtio: guarantee a virtqueue can publish its first descriptor chain
>=20
>  Documentation/driver-api/virtio/index.rst     |    1 +
>  .../driver-api/virtio/virtio-dmb.rst          |  803 ++++++++
>  drivers/vdpa/vdpa.c                           |    2 +-
>  drivers/virtio/Kconfig                        |   29 +
>  drivers/virtio/Makefile                       |    3 +-
>  drivers/virtio/virtio.c                       |   15 +-
>  drivers/virtio/virtio_dmb.c                   | 1719 +++++++++++++++++
>  drivers/virtio/virtio_dmb.h                   |   34 +
>  drivers/virtio/virtio_dmb_test.c              |  279 +++
>  drivers/virtio/virtio_pci_modern.c            |  100 +-
>  drivers/virtio/virtio_pci_modern_dev.c        |   23 +-
>  drivers/virtio/virtio_ring.c                  |  216 ++-
>  include/linux/virtio.h                        |    3 +
>  include/linux/virtio_config.h                 |   41 +
>  include/linux/virtio_pci_modern.h             |    1 +
>  include/uapi/linux/virtio_config.h            |   17 +-
>  include/uapi/linux/virtio_pci.h               |   10 +
>  17 files changed, 3254 insertions(+), 42 deletions(-)
>  create mode 100644 Documentation/driver-api/virtio/virtio-dmb.rst
>  create mode 100644 drivers/virtio/virtio_dmb.c
>  create mode 100644 drivers/virtio/virtio_dmb.h
>  create mode 100644 drivers/virtio/virtio_dmb_test.c
>=20
>=20
> base-commit: fc02acf6ac0ccde0c805c2daa9148683cdd01ba8
>=20

--E1944FrHRiu7HOOY
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmp6NuUACgkQnKSrs4Gr
c8h0ggf9EhOgsO3HluDcAxl3LjRyKeWbnNqK/dzD/aM1tcO8azZNHWFtAJ2p4lRl
tdNT844A8krTR2ljwTsyQ0A5RDiSb1bG78G03NSmTWjTXp9o8czKuB9vppbMVcPE
cbTditRQwpwQNt2xKLg1jkObOA5IZj7NMDSZPsDGrdWsRZN3q2zOorsyykwSGLVv
fnfdz5V0COWy+6Y1PR0sfOpW++T5hV2YPCs0B/s99hdMkCC0j9K42jkhcMTJK5eT
aBQTdNsanuH6DeW6YTIoikD01SLzLy1sJvvJx0Slw00aA1QsPXxEK51YkQZqSnkn
pgJmmLt2/LwAxoWM3zZC5sUiv5kkpQ==
=R2aw
-----END PGP SIGNATURE-----

--E1944FrHRiu7HOOY--

