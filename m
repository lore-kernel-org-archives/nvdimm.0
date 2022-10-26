Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4061A111D
	for <nvdimm@lists.linux.dev>; Wed, 26 Oct 2022 12:12:32 +0000 (UTC)
Received: by mail-oi1-f170.google.com with SMTP id l5so18203487oif.7
        for <nvdimm@lists.linux.dev>; Wed, 26 Oct 2022 05:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ5aSZWWIhIFIjTByURiHqOWXy1GxsKS3NVs264EAr8=;
        b=oXfPzt0JJzEiYPmp6/UVl3QESY5eYmPMyk1PUXcPsx5TkKA1luR3mwvzMiHsFdGkuw
         lFH6H1yHTH3ixTKPoCmMNQ4zmAp75XjW8TEArvQQcC9hfXaPtgUUlj1DryJcJiA3nJ+W
         cgnd9b+7zJ5sW07GpsYxTQ9nhqXaUOiY7d1M26nHfsv7Cr8ofV5LDZayI7aSrq/ruofN
         D9sxcxBlcJsoCSj/b9SDSbyoFg2D1P3keAyRtLQMECLOm6SnKgknqsy0ty6kzKJ1ys76
         UuRzGDlMsZauVIIEb8m9Do0erpzGPXdpUdcsyaPfqdbcpnUagMxNHH8ihhphMM3USBN5
         c7Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZ5aSZWWIhIFIjTByURiHqOWXy1GxsKS3NVs264EAr8=;
        b=xh3T9C3wAHIMqHzPopm2UZAGzCs76dwmm5ZgDyiyZF8ytAMiLqbDbOlACSDM2QiKVh
         OCOojRlA17Ct4HvswztlP8YjzcqfyQFtpj3TruqZTOGosLkBnqZ+C8DNsiYBw/n5EnEj
         jiB3FBGEe0YtKdRdmtwo1LgnMtjnRH1VUy1dlwZxoE4VMB504RaYzxDW540KwaOEMSqA
         jyEmtH7luKYe/vWM4ygu9N1W8HwtKya4dVWq4mmJKQd8UBVtHB+3pOvzanPAXZbVNGce
         oB2uq2kKJ3/1ZnWcYNK8p82emwCzdQAvD8xph9fDHgqCYM1nynthsRKX5f8RH3p0UzDZ
         vOpw==
X-Gm-Message-State: ACrzQf22883736XRFbrrllvPzTA7Ej5D4Jb0NjOGbu6t5cXmzWRCSwWh
	6gFjSYiIp+X1V5pub5Znplr4numaVc3EY2hXCms=
X-Google-Smtp-Source: AMsMyM6M69yoWy/DsnOkqIuIhedU2TaFkjjGn29Zgv+lzU9ZTLfGzsVjJyPfg+CacBfyK3QLJhVTKAWS0qGoNA4silI=
X-Received: by 2002:a05:6808:f93:b0:355:29b1:c2a1 with SMTP id
 o19-20020a0568080f9300b0035529b1c2a1mr1666878oiw.297.1666786351235; Wed, 26
 Oct 2022 05:12:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221017171118.1588820-1-sammler@google.com> <CAM9Jb+ggq5L9XZZHhfA98XDO+P=8y-mT+ct0JFAtXRbsCuORsA@mail.gmail.com>
 <CAFPP518-gU1M1XcHMHgpx=ZPPkSyjPmfOK6D+wM6t6vM6Ve6XQ@mail.gmail.com>
In-Reply-To: <CAFPP518-gU1M1XcHMHgpx=ZPPkSyjPmfOK6D+wM6t6vM6Ve6XQ@mail.gmail.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Wed, 26 Oct 2022 14:12:20 +0200
Message-ID: <CAM9Jb+hk0ZRtXnF+WVj0LiRiO7uH-jDydJrnUQ_57yTEcs--Dw@mail.gmail.com>
Subject: Re: [PATCH v1] virtio_pmem: populate numa information
To: Michael Sammler <sammler@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > > Compute the numa information for a virtio_pmem device from the memory
> > > range of the device. Previously, the target_node was always 0 since
> > > the ndr_desc.target_node field was never explicitly set. The code for
> > > computing the numa node is taken from cxl_pmem_region_probe in
> > > drivers/cxl/pmem.c.
> > >
> > > Signed-off-by: Michael Sammler <sammler@google.com>
> > > ---
> > >  drivers/nvdimm/virtio_pmem.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > > index 20da455d2ef6..a92eb172f0e7 100644
> > > --- a/drivers/nvdimm/virtio_pmem.c
> > > +++ b/drivers/nvdimm/virtio_pmem.c
> > > @@ -32,7 +32,6 @@ static int init_vq(struct virtio_pmem *vpmem)
> > >  static int virtio_pmem_probe(struct virtio_device *vdev)
> > >  {
> > >         struct nd_region_desc ndr_desc = {};
> > > -       int nid = dev_to_node(&vdev->dev);
> > >         struct nd_region *nd_region;
> > >         struct virtio_pmem *vpmem;
> > >         struct resource res;
> > > @@ -79,7 +78,15 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> > >         dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);
> > >
> > >         ndr_desc.res = &res;
> > > -       ndr_desc.numa_node = nid;
> > > +
> > > +       ndr_desc.numa_node = memory_add_physaddr_to_nid(res.start);
> > > +       ndr_desc.target_node = phys_to_target_node(res.start);
> > > +       if (ndr_desc.target_node == NUMA_NO_NODE) {
> > > +               ndr_desc.target_node = ndr_desc.numa_node;
> > > +               dev_dbg(&vdev->dev, "changing target node from %d to %d",
> > > +                       NUMA_NO_NODE, ndr_desc.target_node);
> > > +       }
> >
> > As this memory later gets hotplugged using "devm_memremap_pages". I don't
> > see if 'target_node' is used for fsdax case?
> >
> > It seems to me "target_node" is used mainly for volatile range above
> > persistent memory ( e.g kmem driver?).
> >
> I am not sure if 'target_node' is used in the fsdax case, but it is
> indeed used by the devdax/kmem driver when hotplugging the memory (see
> 'dev_dax_kmem_probe' and '__dax_pmem_probe').

Yes, but not currently for FS_DAX iiuc.

Thanks,
Pankaj
