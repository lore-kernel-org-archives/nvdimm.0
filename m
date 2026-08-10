Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCE537FF40
	for <nvdimm@lists.linux.dev>; Mon, 10 Aug 2026 06:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786342991; cv=none; b=R90AjLHMkEHpUpid1BbHDfdOAXcoOslczqQ1Gf9k3zUPZwJMREBrSJTGH1Fe1tvNmQV9Y5X7vsj+up03bdH01s1dUvTvS7UaqcQbobBM9a5whZjEA4LMlNMaEsET6kou1iQ7eXdD2YzaJXm5QGh2Qk4y66GsoWBaLw2gVOaHaH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786342991; c=relaxed/simple;
	bh=CL3X1O2vNTR8rCDYsz1fgV8vYCK1Bc4ZPwJoxBwu00c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=EdJO8PX+mr0SwNuAPH7nrXv5OGSLOYBm1w2R0wYlkomf7fz4Zn5FkCQiIxC2uHlRJRbz8zDm+chdvg8MPZBFlYiDAWbUGQCKSDqniYpeHT2/ZaecEuvSmV/F1ozQAT8cMHqXeEDEsyzm6xtGuqU/GSfJBXvDDBaJgsU/oRcNASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ITx7t0Vk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ITx7t0Vk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786342988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HzXPQnozqWnPo5236EWypdZ47CBguSfl6g0bCZAQVQ4=;
	b=ITx7t0VkdU8SdayRlji5gOnUN6dDimWMN2n8kdgcc/6xml/BSlUwiZOVDSqMOCqWhaXiAT
	QcqouPBM4XFVkwb9hzx6zyHE4rP52CjGAaeoY2g1hCffjyJYcTv+lcOBN5NyusLCfCIgW1
	JMRrYqnQhDWE9+4cEl0KxB2846sGNXI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-2Nw1_XcRPIyvLUj9AIBwbw-1; Mon, 10 Aug 2026 02:23:06 -0400
X-MC-Unique: 2Nw1_XcRPIyvLUj9AIBwbw-1
X-Mimecast-MFC-AGG-ID: 2Nw1_XcRPIyvLUj9AIBwbw_1786342986
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-474170b59dfso962014f8f.3
        for <nvdimm@lists.linux.dev>; Sun, 09 Aug 2026 23:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786342985; x=1786947785;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HzXPQnozqWnPo5236EWypdZ47CBguSfl6g0bCZAQVQ4=;
        b=IreW+i2/rCEN/DtMIjW62YADeW/dWx0wFopTPR9ObD8cHtddy/rRBMCz80BEY0PwzG
         N88CAwmifUqhBDLP2cmrXHDZFQBFjJwHJAkneGk/XjOzhdvA2UbqCXYUny3MIWXgSS5+
         Cf/oBTYYbKozf6xp1pTNLuS4S9wllG8g8QZEnJVF+TMaURbiQLyVYXojuSxjZhhI7Wvp
         tVJ9X+g4ImccBEteJQqjYRhTpV356VrrF9R/dnTkYFvfIzXwiaOaRdfr1b5EdcDiHXK4
         /gLlDt1fR0AVMpLmKfu3+gA3yBigxcX/zbD1e7vb0ZKThY9vX6hl7V7Wp8VSs5N5qYfV
         5lBA==
X-Forwarded-Encrypted: i=1; AHgh+RpABZNgah4uM4N8+I0hkUznrNEnvc1BXiBmlIP4eVI1y9uLwbcpTEiZLDY4NBl54lCszSZBpjg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKxMo91CmSwFYr/A1YhYWfWZy2j/il0HwYqBqx/renD3s4D1t0
	91z5ATYW6BJP4OIXdr3zeGMRNm+OP6wQCC1v0PdYh868l9jkYcPjbJD1N+NbdiL1sEloFopIp1+
	Sk7s3Wewn91x+F/6ynfRY5drhGJMgswq3RG7IKiBzwt2RYAHWdG7W5YqsoihXfFDqig==
X-Gm-Gg: AR+sD109EKKLsuba2YAEvYWrF35WZXoe1L1Naouh/XTY8cRWfAZwqaXu18W2/EpZfW4
	cvHBmB3iXesW7wg/fJsz7b7Fk0KBVnn06YrOUhs9SO3sPC6ppfJHUmTAnUQEvUwHtYXgcqEV4+2
	T5vgYrxAe7tPFyozKV1nTkd6i1r8/6UFdaKw4CCgVlSb5YjLBikzJwz6qT6WL1djQL4F1dLb+Rk
	r39O7DqCTZfpTVDZyYnsUx1gBjrxLqEx2Qebmei1tXYsR6XHGJt5yyJmmwbfw9j30DJni1zAf/F
	N05urzWrVEed7MDJfRpcqbzS+WXzbcjSNnO1YOmoBzvM5jRR4sxyTaL3jEXvguPeSFcGqLwWII6
	ey1k6metQj7bEjqPplbP9mQ==
X-Received: by 2002:a05:6000:41d3:b0:45e:e1a4:c4c3 with SMTP id ffacd0b85a97d-47fec628b57mr64771510f8f.15.1786342985408;
        Sun, 09 Aug 2026 23:23:05 -0700 (PDT)
X-Received: by 2002:a05:6000:41d3:b0:45e:e1a4:c4c3 with SMTP id ffacd0b85a97d-47fec628b57mr64771414f8f.15.1786342984878;
        Sun, 09 Aug 2026 23:23:04 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-39-98.inter.net.il. [80.230.39.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800220aa83sm26809797f8f.36.2026.08.09.23.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 23:23:04 -0700 (PDT)
Date: Mon, 10 Aug 2026 02:23:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: Jason Wang <jasowangio@gmail.com>, Alex Williamson <alex@shazbot.org>,
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
	Stefan Hajnoczi <stefanha@redhat.com>,
	virtualization@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [RFC PATCH 00/12] virtio: support devices that own their
 virtqueue memory
Message-ID: <20260810021450-mutt-send-email-mst@kernel.org>
References: <20260809182010.32931-1-graf@amazon.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260809182010.32931-1-graf@amazon.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fL6gPctbkgsnYCVv3yRwl0aC_ZbCJwcH_BS-zdOfbnU_1786342986
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 09, 2026 at 06:19:58PM +0000, Alexander Graf wrote:
> Virtio drivers use guest memory to back virtqueues and their buffers.
> That means a VMM needs to be able to map guest memory. That is ok in the
> normal virt case. It gets icky with confidential computing (where we use
> swiotlb as workaround) and it defeats the purpose of isolated vhost-user
> backing devices, because they end up with full RAM access to the guest.
> 
> So instead, I'm proposing an extension to virtio which allows it to give
> each virtio device its own dedicated memory region to communicate with the
> host, called DMB (Device Memory Buffer). A trusted hypervisor can force
> DMB to be present, which then enables safer, more isolated and resilient
> communication between guest and host.
> 
> With DMB, the device provides a shared memory region that both parties
> agree is the full memory map both have access to. All memory offsets
> that previously would have been into guest RAM, are then offsets into
> this shared memory buffer region. One nice property of this is that it
> is a generic mechanism in the virtio transport layer, so higher level
> drivers work unmodified.
> 
> I was exploring to use swiotlb instead to create individual pools. But
> that approach has multiple downsides:
> 
> 1. Swiotlb is an OS primitive which is not available in all Operating
> Systems. DMB however lives in the virtio transport layer, which means we
> can add support for it in any OS independent of generic layers. This
> helps with Windows support.


How does it help, if you are going to put a pool in
the driver, put a pool in the driver. Maybe with virtio mem to
simplify allocation.

> 2. We munge DMA space together. DMB provides a separate DMA space per
> virtio device. This means we can for example implement a device in
> vhost-user and give the implementing process only visibility to the DMB
> region, not all of guest memory. That reduces the exposure the
> vhost-user provider has, improving security.
> 
> 3. Devices can opt-in. A hypervisor can choose to use standard virtio
> semantics for self-implemented devices (e.g. NSM), while requiring DMB
> for devices implemented by less trustworthy providers. The
> non-trustworthy devices do not get any visibility into the trustworthy
> ones, even with DMB in place for both.



So I am not sure whether the implication is that it's purely a software
construct. But if it is, can we extend virtio iommu to
add a way to discover and enforce trust boundaries?
And maybe translate offsets to BARs, if that is desired?



It seems to be that the result would be that we don't need fiddly
special casing in virtio ring specifically, and a lot of things like
pre-mapped dma will begin to work.



> == Limitations ==
> 
>   - Only PCI is wired up.
>   - Feature bit 44 and the shared memory id register at offset 0x40 of the
>     PCI common configuration are provisional: the OASIS technical
>     committee has the specification and has allocated neither.
> 
>   https://lore.kernel.org/virtio-comment/20260804161202.38619-1-graf@amazon.com/
> 
>   - The device I ran this against is not public, so you cannot reproduce
>     the numbers below. The KUnit test you can.
> 
> == Testing ==
> 
> Without patches 10 and 12 a receive refill livelocks and queues starve
> each other: 29,319,791 receive softirqs in five seconds with not one
> packet received, against 4 with them, and 2 of 7 receive queues that never
> see a buffer, against none. Earlier revisions moved 512 MiB of O_DIRECT
> block I/O and 2.7 GB of verified vsock through a region with no error.
> 
> The KUnit test for patch 12's guarantee you can run yourself, and two of
> its five cases fail if I take the fix out:
> 
>   tools/testing/kunit/kunit.py run --arch=x86_64 \
>       --kconfig_add CONFIG_VIRTIO_MMIO=y \
>       --kconfig_add CONFIG_VIRTIO_DMB=y virtio_dmb
> 
> Patch 1 can be taken on its own: a stale worked example in a vdpa
> comment. Patch 10 fixes something older than this series too, a failed
> mapping arriving as -EIO from a packed ring, failing an I/O that on a
> split ring is only back-pressure, but it does not apply alone: it wants
> patch 2, and patch 9 for the file its documentation hunk edits. Both
> carry Fixes:. Patch 12 wants 10 first.
> 
> I wrote this series with an AI coding assistant, which drafted the code,
> the changelogs and this cover letter. I reviewed and reworked all of it,
> and every commit carries an Assisted-by: trailer.
> 
> Alex
> 
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
> 
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
> 
> 
> base-commit: fc02acf6ac0ccde0c805c2daa9148683cdd01ba8

