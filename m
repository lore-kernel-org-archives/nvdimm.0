Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D2C6FC1
	for <nvdimm@lists.linux.dev>; Sun, 13 Nov 2022 17:44:38 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id h132so9457908oif.2
        for <nvdimm@lists.linux.dev>; Sun, 13 Nov 2022 09:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vSpSXd4xBTYt0GhSjGvAmECM0CAegHMeid7wAuT1mCI=;
        b=Iqmevfc8DicUj3o12i8cN1FEDRtwyxOcguIwcTFKcqAe80/LiALvG5Ux7cTbv0/Qiz
         +oVmJFi8ks3IOjzlGVXZcUkakMo9RBY9EX81rPnYA4G1rOQ2Pu2SgL90vtAJ5h/f83ij
         srA1uUj4/tRSjkb8P97SP4XieuvenNkQ9HSAIoH1sXBPRR+hDbjxBMip4wN8m1IeWHoJ
         vGv6fSgUQzhqJ6AtJAC9H+Xnz+4miA/cCcJfFwOd6wY3rS1LH1SjwOja1TeNcTODQKq6
         24pH1Xw5s192ck6v7MDwUX4tJnNeTfdZpuvacaQtGkeoS5PoLac3Kiv4nFadk8DDQSBZ
         kHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vSpSXd4xBTYt0GhSjGvAmECM0CAegHMeid7wAuT1mCI=;
        b=JEsB2QIuGHvzzZlwRZ067rAx+ASNB7j3V2NUgifLOju8g85Lz7VZ22773VncMJa5hV
         KmKkNaS+GAMqlJ7CHOmX8/z7P6nej+EfGO09XnUP9QH12kAcDNBZL6/N7AHZaoLLj7aQ
         /sfnSqUdnpNiwlAXrE98FUrN9dwLRaH8vNjd50sXZjWXuXLiDiKhFWHzDmqijOIgwA6/
         wPIKB6HG1mypaj3r5jRO2YDicgs09bZZoROEWQOpSSoSi19psopN78dARRzfA4QRwXoM
         NfJ98HLhlSI/U9OktUnpjOStaHWJ8fn4ICi3fhu/3Y6u8/D2IQ8Quiiud8SdQ9TmL6u4
         pdAw==
X-Gm-Message-State: ANoB5pllAIsOhJNy+yet8LaVRIZxilqohc9u20biR6Y5KTcHLHVfWv5n
	z5FQHKAmWTyEnCcYcc9BOaNh28db3Kb/67o8ans=
X-Google-Smtp-Source: AA0mqf763ayLv+C8H6TkBm9gazkkwsnig5L2IS08iwPvTaK9k+4imomma5TQkF2EOgRUOuaHbd7gupbF7f+r97FMxoA=
X-Received: by 2002:aca:e156:0:b0:35a:3093:d3a with SMTP id
 y83-20020acae156000000b0035a30930d3amr4646957oig.283.1668361478005; Sun, 13
 Nov 2022 09:44:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221017171118.1588820-1-sammler@google.com> <CAM9Jb+ggq5L9XZZHhfA98XDO+P=8y-mT+ct0JFAtXRbsCuORsA@mail.gmail.com>
 <CAFPP518-gU1M1XcHMHgpx=ZPPkSyjPmfOK6D+wM6t6vM6Ve6XQ@mail.gmail.com>
 <CAM9Jb+hk0ZRtXnF+WVj0LiRiO7uH-jDydJrnUQ_57yTEcs--Dw@mail.gmail.com>
 <6359ab83d6e4d_4da3294d0@dwillia2-xfh.jf.intel.com.notmuch> <CAHS8izOYYV+dz3vPdbkipt1i1XAU-mvJOn6c_z-NJJwzUtWzDg@mail.gmail.com>
In-Reply-To: <CAHS8izOYYV+dz3vPdbkipt1i1XAU-mvJOn6c_z-NJJwzUtWzDg@mail.gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Sun, 13 Nov 2022 18:44:26 +0100
Message-ID: <CAM9Jb+j3MDq_HpaZXYaMWmc4OhXob9hQiLLeSvaJfGa2LoPBDw@mail.gmail.com>
Subject: Re: [PATCH v1] virtio_pmem: populate numa information
To: Mina Almasry <almasrymina@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Michael Sammler <sammler@google.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > Pankaj Gupta wrote:
> > > > > > Compute the numa information for a virtio_pmem device from the memory
> > > > > > range of the device. Previously, the target_node was always 0 since
> > > > > > the ndr_desc.target_node field was never explicitly set. The code for
> > > > > > computing the numa node is taken from cxl_pmem_region_probe in
> > > > > > drivers/cxl/pmem.c.
> > > > > >
> > > > > > Signed-off-by: Michael Sammler <sammler@google.com>
>
> Tested-by: Mina Almasry <almasrymina@google.com>
>
> I don't have much expertise on this driver, but with the help of this
> patch I was able to get memory tiering [1] emulation going on qemu. As
> far as I know there is no alternative to this emulation, and so I
> would love to see this or equivalent merged, if possible.
>
> This is what I have going to get memory tiering emulation:
>
> In qemu, added these configs:
>       -object memory-backend-file,id=m4,share=on,mem-path="$path_to_virtio_pmem_file",size=2G
> \
>       -smp 2,sockets=2,maxcpus=2  \
>       -numa node,nodeid=0,memdev=m0 \
>       -numa node,nodeid=1,memdev=m1 \
>       -numa node,nodeid=2,memdev=m2,initiator=0 \
>       -numa node,nodeid=3,initiator=0 \
>       -device virtio-pmem-pci,memdev=m4,id=nvdimm1 \
>
> On boot, ran these commands:
>     ndctl_static create-namespace -e namespace0.0 -m devdax -f 1&> /dev/null
>     echo dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
>     echo dax0.0 > /sys/bus/dax/drivers/kmem/new_id
>     for i in `ls /sys/devices/system/memory/`; do
>       state=$(cat "/sys/devices/system/memory/$i/state" 2&>/dev/null)
>       if [ "$state" == "offline" ]; then
>         echo online_movable > "/sys/devices/system/memory/$i/state"
>       fi
>     done

Nice to see the way to handle the virtio-pmem device memory through kmem driver
and online the corresponding memory blocks to 'zone_movable'.

This also opens way to use this memory range directly irrespective of attached
block device. Of course there won't be any persistent data guarantee. But good
way to simulate memory tiering inside guest as demonstrated below.
>
> Without this CL, I see the memory onlined in node 0 always, and is not
> a separate memory tier. With this CL and qemu configs, the memory is
> onlined in node 3 and is set as a separate memory tier, which enables
> qemu-based development:
>
> ==> /sys/devices/virtual/memory_tiering/memory_tier22/nodelist <==
> 3
> ==> /sys/devices/virtual/memory_tiering/memory_tier4/nodelist <==
> 0-2
>
> AFAIK there is no alternative to enabling memory tiering emulation in
> qemu, and would love to see this or equivalent merged, if possible.

Just wondering if Qemu vNVDIMM device can also achieve this?

In any case, this patch is useful, So,
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com

>
>
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
>
> > > > > > ---
> > > > > >  drivers/nvdimm/virtio_pmem.c | 11 +++++++++--
> > > > > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > > > > > index 20da455d2ef6..a92eb172f0e7 100644
> > > > > > --- a/drivers/nvdimm/virtio_pmem.c
> > > > > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > > > > @@ -32,7 +32,6 @@ static int init_vq(struct virtio_pmem *vpmem)
> > > > > >  static int virtio_pmem_probe(struct virtio_device *vdev)
> > > > > >  {
> > > > > >         struct nd_region_desc ndr_desc = {};
> > > > > > -       int nid = dev_to_node(&vdev->dev);
> > > > > >         struct nd_region *nd_region;
> > > > > >         struct virtio_pmem *vpmem;
> > > > > >         struct resource res;
> > > > > > @@ -79,7 +78,15 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > > > > >         dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);
> > > > > >
> > > > > >         ndr_desc.res = &res;
> > > > > > -       ndr_desc.numa_node = nid;
> > > > > > +
> > > > > > +       ndr_desc.numa_node = memory_add_physaddr_to_nid(res.start);
> > > > > > +       ndr_desc.target_node = phys_to_target_node(res.start);
> > > > > > +       if (ndr_desc.target_node == NUMA_NO_NODE) {
> > > > > > +               ndr_desc.target_node = ndr_desc.numa_node;
> > > > > > +               dev_dbg(&vdev->dev, "changing target node from %d to %d",
> > > > > > +                       NUMA_NO_NODE, ndr_desc.target_node);
> > > > > > +       }
> > > > >
> > > > > As this memory later gets hotplugged using "devm_memremap_pages". I don't
> > > > > see if 'target_node' is used for fsdax case?
> > > > >
> > > > > It seems to me "target_node" is used mainly for volatile range above
> > > > > persistent memory ( e.g kmem driver?).
> > > > >
> > > > I am not sure if 'target_node' is used in the fsdax case, but it is
> > > > indeed used by the devdax/kmem driver when hotplugging the memory (see
> > > > 'dev_dax_kmem_probe' and '__dax_pmem_probe').
> > >
> > > Yes, but not currently for FS_DAX iiuc.
> >
> > The target_node is only used by the dax_kmem driver. In the FSDAX case
> > the memory (persistent or otherwise) is mapped behind a block-device.
> > That block-device has affinity to a CPU initiator, but that memory does
> > not itself have any NUMA affinity or identity as a target.
> >
> > So:
> >
> > block-device NUMA node == closest CPU initiator node to the device
> >
> > dax-device target node == memory only NUMA node target, after onlining
