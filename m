Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A446102
	for <nvdimm@lists.linux.dev>; Fri, 21 Oct 2022 17:08:43 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso3285019pjc.5
        for <nvdimm@lists.linux.dev>; Fri, 21 Oct 2022 10:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BcKjJ/DvYciO22U+4C9FPgHR8gF43QoCQeInlu7o77U=;
        b=BKEWwEYSWhHnlAgMPL5eP9WwVf3jy/GmXCmDjYwxfZrmp3PJ3y9KZE1fifNjoSWhB5
         QCdaNDrLRb3V7Zm81gOAQWP8XKPBP08M57aMfpXQ//zEda/M0jLED/drOl3f/eTYs/Om
         dHR+mNPadrMkcl49SSVFZqrQsr5hE1DBqzi6wjMKCcNfocWhr61i5yZCRmy5W1Rt9t4Y
         5NtRqtsykWk1qpd3X2WEjB/PsIcWb2YyuVisrXbgE0HHWqXSqhY95p3Jy1H5rc+MV47d
         t/hYWZEuiNnDiJQ5Qxn4EOV3bZdiWN8S7A20/AHIGCETT8aRLQDqX6DGLZN0C5OAlP9t
         nbWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BcKjJ/DvYciO22U+4C9FPgHR8gF43QoCQeInlu7o77U=;
        b=T0M1CeaZi4L/0jxGB1d71ead8Kbz3TbVPimnm8f2hhdn9Ks1hzrlrSQb4fzBKeUorU
         NYWOqrgqHY91M8UY8nhtS8kMezWQsSVSb9Llpd7WDnLQYrly0hCk8ML8lQ0I8/m9XFQP
         CvS6imiNoJOB+4geCAlRTA6Sp8XMX+AfA/Sy5AdRLIABL5RNJbQmkn7pTJmIzpFnOSz7
         I8bk70/sIm238ZRaNi52QcG7lNpv4tBDeJYZrqrkGio76yx6nTlm2re/YaOrvyAMcTA/
         U6MtvW23SfWOyaVeUaGKvfOLmCQUn+a5Wv+lDynhuqlhGHp1ZTEQih5kaextxhcu1enA
         lnSw==
X-Gm-Message-State: ACrzQf1Gik31KEcuPo8sHS5c7V5CMPHQZNejjjmtYGsH/KURJji+U+gw
	CQPDbhMzLdgKZUapaF81EA9LJZZ+c+kqN72eBvet5Q==
X-Google-Smtp-Source: AMsMyM7BW0377LCk6CQ5XZ0Vo9ObgaT/Wg9+y4LfXOhJBeGHzrWRSas/sCJXvN86SDgpNNVZC29CrJBhl72ukgaEzU8=
X-Received: by 2002:a17:90b:3c51:b0:20c:2630:5259 with SMTP id
 pm17-20020a17090b3c5100b0020c26305259mr58147003pjb.177.1666372123045; Fri, 21
 Oct 2022 10:08:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221017171118.1588820-1-sammler@google.com> <CAM9Jb+ggq5L9XZZHhfA98XDO+P=8y-mT+ct0JFAtXRbsCuORsA@mail.gmail.com>
In-Reply-To: <CAM9Jb+ggq5L9XZZHhfA98XDO+P=8y-mT+ct0JFAtXRbsCuORsA@mail.gmail.com>
From: Michael Sammler <sammler@google.com>
Date: Fri, 21 Oct 2022 10:08:31 -0700
Message-ID: <CAFPP518-gU1M1XcHMHgpx=ZPPkSyjPmfOK6D+wM6t6vM6Ve6XQ@mail.gmail.com>
Subject: Re: [PATCH v1] virtio_pmem: populate numa information
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Pankaj,
Thank you for looking at the patch.

>
> > Compute the numa information for a virtio_pmem device from the memory
> > range of the device. Previously, the target_node was always 0 since
> > the ndr_desc.target_node field was never explicitly set. The code for
> > computing the numa node is taken from cxl_pmem_region_probe in
> > drivers/cxl/pmem.c.
> >
> > Signed-off-by: Michael Sammler <sammler@google.com>
> > ---
> >  drivers/nvdimm/virtio_pmem.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > index 20da455d2ef6..a92eb172f0e7 100644
> > --- a/drivers/nvdimm/virtio_pmem.c
> > +++ b/drivers/nvdimm/virtio_pmem.c
> > @@ -32,7 +32,6 @@ static int init_vq(struct virtio_pmem *vpmem)
> >  static int virtio_pmem_probe(struct virtio_device *vdev)
> >  {
> >         struct nd_region_desc ndr_desc = {};
> > -       int nid = dev_to_node(&vdev->dev);
> >         struct nd_region *nd_region;
> >         struct virtio_pmem *vpmem;
> >         struct resource res;
> > @@ -79,7 +78,15 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >         dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);
> >
> >         ndr_desc.res = &res;
> > -       ndr_desc.numa_node = nid;
> > +
> > +       ndr_desc.numa_node = memory_add_physaddr_to_nid(res.start);
> > +       ndr_desc.target_node = phys_to_target_node(res.start);
> > +       if (ndr_desc.target_node == NUMA_NO_NODE) {
> > +               ndr_desc.target_node = ndr_desc.numa_node;
> > +               dev_dbg(&vdev->dev, "changing target node from %d to %d",
> > +                       NUMA_NO_NODE, ndr_desc.target_node);
> > +       }
>
> As this memory later gets hotplugged using "devm_memremap_pages". I don't
> see if 'target_node' is used for fsdax case?
>
> It seems to me "target_node" is used mainly for volatile range above
> persistent memory ( e.g kmem driver?).
>
I am not sure if 'target_node' is used in the fsdax case, but it is
indeed used by the devdax/kmem driver when hotplugging the memory (see
'dev_dax_kmem_probe' and '__dax_pmem_probe').

Best,
Michael
> Thanks,
> Pankaj
>
> > +
> >         ndr_desc.flush = async_pmem_flush;
> >         ndr_desc.provider_data = vdev;
> >         set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> > --
