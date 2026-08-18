Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1D835C190;
	Tue, 18 Aug 2026 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787087675; cv=none; b=pH3FRnyDDOFofGnuZ0Tbw/jhlzcHXSmx34YONjptwOznz4PbCIZOWl5u0NgkyLuKKVeaPc6E+yzkVnsrDJa7t6MDSUzRVoDdVo+M3IzNkvk/3nY/azAIvuGg2sdLq6mXUgSI76FCnOgCnYiWtgXdWTsQmJW2yZJwi3iXfHAMtLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787087675; c=relaxed/simple;
	bh=EtgII+6aFzxtL9xEcTtjczBjknxrb73HycvECBG2Bnw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FH66z83eTd2qWLCJcp5cniQxE14YUKiGGWsOSyevEgUBbDOeJH6R5M8M+IPpQ8DsqlrxNDci/IyhcixfClsRY2kPGNoWUW7EHGBNIn4RoaumgxjXmA1tu2yrPd2+o4qCQyChKQ2Kll3VoEz5p9qSzNsE4hnd40o0HxF7WgDWWiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=nA+JwJhq; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="nA+JwJhq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1787087674; x=1818623674;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eS2+jMJ39vieGJ8Hcj7Y1Wa3CkrQMnaJIAG8TuvM7Mw=;
  b=nA+JwJhqBTi3GgirMhZ6Slt9JMLX//eQVmCzXVu7ADOtgKfjLv5TpPIK
   A/0zwqYtNBEdRnn7fZ39LPnSCUd57GSvPXuV0nqCOwc51aETJq+Ew/HWI
   tBPWRCJ6XGKVcLf46bl+Q3AKkHgcAQxIlgQNpRKQQHKXVPM2e16VTsNip
   E1xOLboJ8obyQ0ctFwzIbBVZ8IyxTdGNbvJxE++c+0qFxh+A6EPhWXn87
   w31HZ3Z2wIDXuD9wcx486JpHGmkEDxCWSw/4qdn3tlZffCWdyXVU9oZsa
   AZaSlqPSjNjZk96hWZU/v3U8A4/Y7S0t1kiJlyuZya+wA6g8omiw10tr8
   g==;
X-CSE-ConnectionGUID: P4lFDOY3T5CSk48EPUWUaw==
X-CSE-MsgGUID: jJ/hbMEKTTeRfa9R2DxdcQ==
X-IronPort-AV: E=Sophos;i="6.25,230,1779148800"; 
   d="scan'208";a="26303260"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 21:14:31 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:10500]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.18:2525] with esmtp (Farcaster)
 id f7d7b8ba-428e-4ab2-a0ac-0d66c74ec954; Tue, 18 Aug 2026 21:14:31 +0000 (UTC)
X-Farcaster-Flow-ID: f7d7b8ba-428e-4ab2-a0ac-0d66c74ec954
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 18 Aug 2026 21:14:30 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 18 Aug 2026 21:14:27 +0000
From: Alexander Graf <graf@amazon.com>
To: Jason Wang <jasowangio@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>
CC: <nh-open-source@amazon.com>, Alex Williamson <alex@shazbot.org>, "David
 Airlie" <airlied@redhat.com>, Dmitry Osipenko
	<dmitry.osipenko@collabora.com>, <dri-devel@lists.freedesktop.org>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>, Feng Liu
	<feliu@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, Halil Pasic
	<pasic@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>, Jiri Pirko
	<jiri@resnulli.us>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>, Pankaj Gupta
	<pankaj.gupta.linux@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Parav
 Pandit" <parav@nvidia.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH v2 00/12] virtio: support devices that own their virtqueue memory
Date: Tue, 18 Aug 2026 21:14:13 +0000
Message-ID: <20260818211425.91009-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Virtio drivers use guest memory to back virtqueues and their buffers.
That means a VMM needs to be able to map guest memory. That is ok in the
normal virt case. It gets icky with confidential computing (where we use
swiotlb as workaround) and it defeats the purpose of isolated vhost-user
backing devices, because they end up with full RAM access to the guest.

So instead, I'm proposing an extension to virtio which allows it to give
each virtio device its own dedicated memory region to communicate with the
host, called DMB (Device Memory Buffer). A trusted hypervisor can force
DMB to be present, which then enables safer, more isolated and resilient
communication between guest and host.

With DMB, the device provides a shared memory region that both parties
agree is the full memory map both have access to. All memory offsets
that previously would have been into guest RAM, are then offsets into
this shared memory buffer region. One nice property of this is that it
is a generic mechanism in the virtio transport layer, so higher level
drivers work unmodified.

I was exploring to use swiotlb instead to create individual pools. But
that approach has multiple downsides:

1. Swiotlb is an OS primitive which is not available in all Operating
Systems. DMB however lives in the virtio transport layer, which means we
can add support for it in any OS independent of generic layers. This
helps with Windows support.

2. We munge DMA space together. DMB provides a separate DMA space per
virtio device. This means we can for example implement a device in
vhost-user and give the implementing process only visibility to the DMB
region, not all of guest memory. That reduces the exposure the
vhost-user provider has, improving security.

3. Devices can opt-in. A hypervisor can choose to use standard virtio
semantics for self-implemented devices (e.g. NSM), while requiring DMB
for devices implemented by less trustworthy providers. The
non-trustworthy devices do not get any visibility into the trustworthy
ones, even with DMB in place for both.

I also looked at virtio-iommu. To restrict DMA visibility, virtio-iommu
allows the guest to open specific windows into guest memory to the
device, but it comes with its own bag of problems, such as dynamic
allocations and complicated device <-> iommu connections that need to be
represented reliably.

== Limitations ==

  - Only PCI is wired up.
  - Feature bit 44 and the two registers at offsets 0x40 and 0x42 of the
    PCI common configuration are provisional: the OASIS technical
    committee has the specification and has allocated none of them.

  https://lore.kernel.org/virtio-comment/20260818060255.6853-1-graf@amazon.com/

== Testing ==

I ran this against a device that offers DMB and not
VIRTIO_F_ACCESS_PLATFORM, with a 16 MiB region on each device. A kernel
without patch 10 finds the region and then hangs with nothing in the log;
with it, 512 MiB of O_DIRECT block reads and 137 MiB of loopback network
traffic go through the regions with no allocation failure.

Patches 1 to 4 do not need the rest of the series. They remove an API no
driver calls and a stale worked example in a vdpa comment. Patch 3 and
patch 4 carry Fixes:; patch 4's are older than this series, a failed
mapping arriving from a packed ring as -EIO, which fails an I/O that on a
split ring is only back-pressure.

I wrote this series with an AI coding assistant, which drafted the code,
the changelogs and this cover letter. I reviewed and reworked all of it,
and every commit carries an Assisted-by: trailer.

Alex

v1: https://lore.kernel.org/all/20260809182010.32931-1-graf@amazon.com/

v1 -> v2:

  - Remove the unused map sync API (Michael)
  - Drop the sync operations from virtio_map_ops (Michael)
  - Drop the stale mask expansion instead of correcting it (Michael)
  - Treat VIRTIO_F_DMB as implying VIRTIO_F_ACCESS_PLATFORM
  - Read the region's memory type and accept only a coherent one
  - Rewrite the region allocator over gen_pool
  - Return -ENOMEM instead of -EIO from a failed packed ring mapping
  - Drop the patch validating premapped addresses through the map
  - Drop the patch reporting a bounded pool's exhaustion as -ENOSPC
  - Drop the range withheld for a virtqueue's first descriptor chain
  - Drop the .rst and describe the region in the headers instead

Alexander Graf (12):
  virtio_ring: remove the unused map sync API
  virtio: drop the sync operations from virtio_map_ops
  vdpa: drop the VIRTIO_DEVICE_F_MASK example value
  virtio_ring: return -ENOMEM when a packed ring mapping fails
  virtio: add the VIRTIO_F_DMB feature bit
  virtio_pci: read the device memory buffer registers
  virtio_pci: create virtqueues with the device's mapping token
  virtio: add a device memory buffer region allocator
  virtio: locate the device memory buffer after feature negotiation
  virtio: treat VIRTIO_F_DMB as implying VIRTIO_F_ACCESS_PLATFORM
  virtio_pci: support VIRTIO_F_DMB
  virtio: expose device memory buffer occupancy over debugfs

 drivers/vdpa/vdpa.c                    |   7 +-
 drivers/vdpa/vdpa_user/iova_domain.c   |  20 -
 drivers/vdpa/vdpa_user/iova_domain.h   |   8 -
 drivers/vdpa/vdpa_user/vduse_dev.c     |  40 --
 drivers/virtio/Kconfig                 |  17 +
 drivers/virtio/Makefile                |   3 +-
 drivers/virtio/virtio.c                |  25 +-
 drivers/virtio/virtio_dmb.c            | 959 +++++++++++++++++++++++++
 drivers/virtio/virtio_dmb.h            |  28 +
 drivers/virtio/virtio_pci_modern.c     |  75 +-
 drivers/virtio/virtio_pci_modern_dev.c |  47 +-
 drivers/virtio/virtio_ring.c           |  93 +--
 include/linux/virtio.h                 |  11 +-
 include/linux/virtio_config.h          |  41 +-
 include/linux/virtio_pci_modern.h      |   2 +
 include/uapi/linux/virtio_config.h     |  24 +-
 include/uapi/linux/virtio_pci.h        |  19 +
 tools/virtio/linux/dma-mapping.h       |   7 -
 18 files changed, 1217 insertions(+), 209 deletions(-)
 create mode 100644 drivers/virtio/virtio_dmb.c
 create mode 100644 drivers/virtio/virtio_dmb.h


base-commit: fc02acf6ac0ccde0c805c2daa9148683cdd01ba8
