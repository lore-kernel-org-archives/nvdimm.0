Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEF1386C2A
	for <nvdimm@lists.linux.dev>; Mon, 10 Aug 2026 08:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786349109; cv=none; b=CLHfS9oGuPS5oQDHHGCy4LQX7LwbFpKRZpVqbzk+vWnkXBCAZF7olTo4560K2Vdt0tmelKY9YlfV1gEY+p3aOHo7SX/QxEEmB4yQWj4/Sb/tCpNX9JEzOSOt3MSjG9uRBj4xnQNSsBdte0kR2uf5zuciKuS0Jhr0xa+Evn47FCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786349109; c=relaxed/simple;
	bh=+lkuVQnHgrhF7fjMdkJDE/fkoUTrWZAAHCdTOrn70ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=jQstumiotZPU6OW+p5rxztxre7QiyYWBXWLoKd2kwXGiyLbjbqpqdA7sXPsvUWjwlENgbVpLRcaF9oYeyaJ8yVhGRCD8bz5wmFcFl+V+ea8Ab4SOSb5Q99nrB6V1HUTWvwH+i4S3qbA6va2i6w0Xvfsb06MXQ4BAbuA49mpDgvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADyYXTuv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADyYXTuv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786349106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/+a+0U5GgUWNz5gXhQg+X0ag29Jj0knQnRmccGbHPwc=;
	b=ADyYXTuvaCLUBaA0qf+ZBxu7F81GjGy/NQzTBc0UwNZdoBkMsChYEpMi1PAbdaJWCkrfNn
	9t605Rv6ldYQYCp2oTkW6s0CxxAoq/FcvYyRcu9wtXPfwoewvhcaICekYgvGSCuzPEwprb
	4TZdhYr0uo2GeA11x8Au+s8ZFo3F6pc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-1UEidx9hN1iPB5KCvw1gjw-1; Mon, 10 Aug 2026 04:05:02 -0400
X-MC-Unique: 1UEidx9hN1iPB5KCvw1gjw-1
X-Mimecast-MFC-AGG-ID: 1UEidx9hN1iPB5KCvw1gjw_1786349102
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47f83416551so1475692f8f.3
        for <nvdimm@lists.linux.dev>; Mon, 10 Aug 2026 01:05:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786349101; x=1786953901;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/+a+0U5GgUWNz5gXhQg+X0ag29Jj0knQnRmccGbHPwc=;
        b=pNqwQ4/ehdKE8omvlM6zNvg3i+ivbIeOldh24ZWHqm57nSZnT44SG6Vedn1sopTTzM
         3cWjYxyzaiY9fdrnC2CCWdjPE9NKWf+mM5uEalNZfl3HVXX/2wkSo58gm16Teiy81wgo
         fTMuBbhfAwufmyJPHR81kR+V+w17wQORRn57pEsVPudYCJfUGHgkpHGQV5VZeTM1goNP
         pdIAQ7fmIGKE3mZeuyKx2puIkhkD80aFoL8XG0z/8LLCRsBrZSaVdyycakteTDenTRE7
         vwBv+Fmu1G4j/h4bOw4HYeamxxqw5f8ftgB5ba/AgXm5kJN6vB+YACNs9SVg9mAeF6m5
         m9VQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8AnZYVnIbOsSw5Hez0vaAD8UsqIAroHwFLmQ3bSrwyupEfXwN25D2yGw2vqsISISFy2eQZ5E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzal2z9FzLQm5pzFF/MW/k/bF9wRIjlh3RnZXiwFdXeYTavMqXG
	jWS4iLAyozUGVxVSX26ybq1QiB4xtHF2AUXJRK8UHvhmZYjxk12BlmabRAmrfN+QC7MGpCn0Hem
	uoRH4kSfHzufBMpa4Upseh5lIcEsWftSb9kK+STWkRIrjxf1nrmmJP+fc6Q==
X-Gm-Gg: AR+sD10jkKqTBpq0sQ8SvhBSVbL/nh52pC80vb7ulVgOwsoi4eFuHsWRpwscGxKuMxt
	5fEHjPLNZfnq5dzrEQj8+cRbLbQIO1PghRANcptWVZEjNUAy14hY6nGg9E7IzQxurcPpEAi8Qem
	Ftodmp4j/D3C/Co97HYOHYEv662AunQPM3+x7U3+x4OuC89AgjHtRV1pG0RcYtyZIODudjnQCk4
	20+Y9uYCS0m6DWTf3BcoLZLSBzKGsPBNdc4rCvYaBj1+//vmOtYNJ1HzV1lZ3C6tSieGdsA7HgB
	dXecmIlxuy3DW6vYl27oddgIKItLzP73RA/9Fr1j//NXNRI+opIHfrGyOtKGCwrclUUD881sEIC
	BCf8uPSVK8BRAbNm+CDQLEA==
X-Received: by 2002:a05:6000:430a:b0:47f:71a6:970e with SMTP id ffacd0b85a97d-47ffd203e5emr38268908f8f.2.1786349101183;
        Mon, 10 Aug 2026 01:05:01 -0700 (PDT)
X-Received: by 2002:a05:6000:430a:b0:47f:71a6:970e with SMTP id ffacd0b85a97d-47ffd203e5emr38268788f8f.2.1786349100617;
        Mon, 10 Aug 2026 01:05:00 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-39-98.inter.net.il. [80.230.39.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021e8b09sm35811136f8f.23.2026.08.10.01.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 01:05:00 -0700 (PDT)
Date: Mon, 10 Aug 2026 04:04:55 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Graf (AWS), Alexander" <graf@amazon.de>
Cc: Jason Wang <jasowangio@gmail.com>, Alex Williamson <alex@shazbot.org>,
	David Airlie <airlied@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Feng Liu <feliu@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>,
	Jiri Pirko <jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Parav Pandit <parav@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [RFC PATCH 00/12] virtio: support devices that own their
 virtqueue memory
Message-ID: <20260810035246-mutt-send-email-mst@kernel.org>
References: <20260809182010.32931-1-graf@amazon.com>
 <20260810021450-mutt-send-email-mst@kernel.org>
 <c56fb4d0-33ef-4e9b-ac18-ac4e896957cd@amazon.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c56fb4d0-33ef-4e9b-ac18-ac4e896957cd@amazon.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j0EJBgVJ4Fx_sxKO7xftDS__cDCvXyFwlPLS3xNmPgo_1786349102
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 10, 2026 at 07:39:02AM +0000, Graf (AWS), Alexander wrote:
> Hey Michael,
> 
> Thanks a bunch for having a detailed and quick look!
> 
> On 10.08.26 08:23, Michael S. Tsirkin wrote:
> > On Sun, Aug 09, 2026 at 06:19:58PM +0000, Alexander Graf wrote:
> >> Virtio drivers use guest memory to back virtqueues and their buffers.
> >> That means a VMM needs to be able to map guest memory. That is ok in the
> >> normal virt case. It gets icky with confidential computing (where we use
> >> swiotlb as workaround) and it defeats the purpose of isolated vhost-user
> >> backing devices, because they end up with full RAM access to the guest.
> >>
> >> So instead, I'm proposing an extension to virtio which allows it to give
> >> each virtio device its own dedicated memory region to communicate with the
> >> host, called DMB (Device Memory Buffer). A trusted hypervisor can force
> >> DMB to be present, which then enables safer, more isolated and resilient
> >> communication between guest and host.
> >>
> >> With DMB, the device provides a shared memory region that both parties
> >> agree is the full memory map both have access to. All memory offsets
> >> that previously would have been into guest RAM, are then offsets into
> >> this shared memory buffer region. One nice property of this is that it
> >> is a generic mechanism in the virtio transport layer, so higher level
> >> drivers work unmodified.
> >>
> >> I was exploring to use swiotlb instead to create individual pools. But
> >> that approach has multiple downsides:
> >>
> >> 1. Swiotlb is an OS primitive which is not available in all Operating
> >> Systems. DMB however lives in the virtio transport layer, which means we
> >> can add support for it in any OS independent of generic layers. This
> >> helps with Windows support.
> >
> > How does it help, if you are going to put a pool in
> > the driver, put a pool in the driver. Maybe with virtio mem to
> > simplify allocation.
> 
> 
> I'm not sure I understand the suggestion :)
> 


I'm not sure what the problem is for windows :)

But if you want a chunk of contiguos memory that windows
does not poke at without a driver, virtio mem is that :)

> >
> >> 2. We munge DMA space together. DMB provides a separate DMA space per
> >> virtio device. This means we can for example implement a device in
> >> vhost-user and give the implementing process only visibility to the DMB
> >> region, not all of guest memory. That reduces the exposure the
> >> vhost-user provider has, improving security.
> >>
> >> 3. Devices can opt-in. A hypervisor can choose to use standard virtio
> >> semantics for self-implemented devices (e.g. NSM), while requiring DMB
> >> for devices implemented by less trustworthy providers. The
> >> non-trustworthy devices do not get any visibility into the trustworthy
> >> ones, even with DMB in place for both.
> >
> > So I am not sure whether the implication is that it's purely a software
> > construct. But if it is, can we extend virtio iommu to
> > add a way to discover and enforce trust boundaries?
> > And maybe translate offsets to BARs, if that is desired?
> >
> > It seems to be that the result would be that we don't need fiddly
> > special casing in virtio ring specifically, and a lot of things like
> > pre-mapped dma will begin to work.
> 
> 
> On thing I'm trying to avoid is dynamicity. Anything that dynamically 
> changes visibility or needs state tracking is something that can go 
> wrong. By keeping everything self-contained within the guest, I can 
> reason about what is visible and what is not easily. Especially for 
> confidential computing, IMHO static wins over dynamic in general.
> 
> Or did I misunderstand your suggestion?


I get this part. But we can absolutely make it static.


Let's start by replicating your functionality with virtio-iommu.  So:

-device is behind virtio-iommu
-virtio-iommu tells guest "this device can only consume memory from that range,"
-and maybe: ...and translation is 1:1 with this offset

if guest does not acknowledge it will just fail?


this covers the proposal here simply by using a dedicated range
per device, right?



But look what we can easily add later: share a range
between devices, now you can move data between them with zero copies.


Isn't that better?


> As to pure software construct: With CXL, you can implement the exact 
> same protocol on real hardware as well. All it takes is cache coherency 
> of the BAR (or whatever the transport uses) region.
> 
> 
> 
> Alex

Yes this is what I thought originally, that you intend to
do it in hardware. But re-reading it, it begins to look like
that's not really the case, it's only "theoretically possible"?



-- 
MST

