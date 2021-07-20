Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FFE70
	for <nvdimm@lists.linux.dev>; Tue, 20 Jul 2021 06:51:16 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id a12so34235504lfb.7
        for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 23:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aYwYtLmWkzL3x9IjqcMiTVGuH2raC566+MRB47zYHFc=;
        b=NXQaaPdCRZf0X+nj/5vpaOatAb3BKZ1StuJPfRsM5FGshG0A4xLi8OZZk6KB5iqwZf
         ZQjOrUtZeg6bCSEyYmvcAjzDYnvflgDRP/sGUn3s625ODDCciK2SXRg6uu00cDlVhbNn
         gsbW8yLdChZ2AABmFubdCqJvkapVLv4dLR816XTkDdXewNrCNcfm9fZ28OSqJDs77pcd
         N2F5CGEdd3slQSoh3sF/UK18yvhDrejDeS5bVVikkCWx3vpINpCaBfMoL3mq9QelJ6g8
         wvOI3+BvFlvjhZU3bB6X6HGbVk0U4ehr80lk+WqmBDi/yRULJozzrZ8VIIlOCed4a3PZ
         T3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aYwYtLmWkzL3x9IjqcMiTVGuH2raC566+MRB47zYHFc=;
        b=c78rCvS/lBn4ZXn8RbJYSIeyitU8wBSj2G3VWI9bYJFJHgOQ269ZPAAF/FvaxRy5GW
         pIAz80+MADcpVFICBll/IfvVL8M+H1Ni2LUwrYXkPSmH/ShOtwrgk1sH/0m5C8tXHr7A
         cg8EV//+gx/45Xid4PgM2UyqAcVLJNcC7ZprBA9wUqDWUzM6/ihCWTAfsNOnHsPY/xoG
         sgzASj4TB7f3oZeTbWFMfUytyUKRcB9joadROrMxO1sx1lAciqAxQU69N0swptcMXB4L
         53rL9/cm9hZ9tKGuW4e+WumnJBnVSbtZZ8J+IMUFev66uhFAQKqsXFHGhhqUgPKBMn7e
         anOg==
X-Gm-Message-State: AOAM530RZV4uPxxc4sd6ukOgWStQIhw6SQsl/ndLS8TV5auV4+QfVVoW
	qKKfs96F+hd16wHPuMh1KB0B9oEZeEhoEOp98qkNXA==
X-Google-Smtp-Source: ABdhPJxzQEofO7lkqOXYRfUEfChs5RF6J614Q2HXjMph1B1IGp5DLiZCguyxucxfG2LSxV0Bx/Nq+ZCp9FwJkIjZz6E=
X-Received: by 2002:a05:6512:220b:: with SMTP id h11mr14325763lfu.504.1626763875065;
 Mon, 19 Jul 2021 23:51:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAM9Jb+g5viRiogvv2Mms+nBVWrYQXKofC9pweADUAW8-C6+iOw@mail.gmail.com> <20210720063510.GB8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20210720063510.GB8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Pankaj Gupta <pankaj.gupta@ionos.com>
Date: Tue, 20 Jul 2021 08:51:04 +0200
Message-ID: <CALzYo30-fzcQMDVEhKMAGmzXO5hvtd-J6CtavesAUzaQjcpDcg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
To: Taylor Stark <tstark@linux.microsoft.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev, apais@microsoft.com, 
	tyhicks@microsoft.com, jamorris@microsoft.com, benhill@microsoft.com, 
	sunilmut@microsoft.com, grahamwo@microsoft.com, tstark@microsoft.com, 
	"Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"

> > >
> > > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > -                       start, &vpmem->start);
> > > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > -                       size, &vpmem->size);
> > > +       /* Retrieve the pmem device's address and size. It may have been supplied
> > > +        * as a PCI BAR-relative shared memory region, or as a guest absolute address.
> > > +        */
> > > +       have_shm_region = virtio_get_shm_region(vpmem->vdev, &pmem_region,
> > > +                                               VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION);
> >
> > Current implementation of Virtio pmem device in Qemu does not expose
> > it as PCI BAR.
> > So, can't test it. Just curious if device side implementation is also
> > tested for asynchronous
> > flush case?
> >
> > Thanks,
> > Pankaj
>
> Yes, I tested the async flush case as well. We basically call
> FlushFileBuffers on the backing file, which is Windows' equivalent of
> fsync. I also briefly tested with qemu to ensure that still works with
> the patch.

Thank you for the confirmation. This sounds really good.
I am also getting back to pending items for virtio-pmem.

On a side question: Do you guys have any or plan for Windows guest
implementation
for virtio-pmem?

Thanks,
Pankaj
