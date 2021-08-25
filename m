Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9A63FC1
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 00:29:23 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id m4so2252642pll.0
        for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 17:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2vFQqbfgjsvY1nxS/Dmd+cOY795N2fxUB0Uqo5tXf8=;
        b=b1Qy13+Nhafg1VrLOplJkDiyaz/tujVR2ehr8e1JQgnUFXKh+LJGQqx5J9ZEgSf5SE
         lZJbrnRE7WbtQCW6oiGwBm7Hcr5oSt82kGy+bq90i1XdktovcVb2Bx+n4wm1pcZzPJTf
         7JYJ+hYxDmB3z+O3cgQhYoB+9n1/AIMUaHMjyO96JXOinVmzuv8ngpi3O22vVAW7FIuH
         dqRE2ymyMVH8Os50UE0fS551bauKhAL9IYU/qOZ2EGGPByaaKpdiM+UmdYTn9URCY3Ql
         F7cZ82NM7Rfa96WoP0zQfhRXGe7M+vX3GTGKXB+JlRAW8HcoRy6+YhNPiayfoWMtrw3O
         lKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2vFQqbfgjsvY1nxS/Dmd+cOY795N2fxUB0Uqo5tXf8=;
        b=su4jPiX17VmiCt/Z097q/FDXdxBTA0IQp1/c5L/F+1etsZd0zkstQ5+yj8C6wjln32
         Qk6B8pmJ1VR+MXOYG6jByzBBZ13tZ1r9SoZAhSPQvBQH/2fAs8VcYJgFhxiwSbrOzUM6
         tEZDMLJ8fxR+pz4KqNqfkqp3b+3U7kggQg0RzAfcJWBKupD6h6xxeJWbn3a7/MiFTfyu
         nTDwh8/8v4LLTT3JoSu3Vqub7Irqct3QIaTXG7Or/7iuRXDiuoJPr9xSmuHcMYZjihMc
         kUSRnWIU4BBk/Et8zwgDjWdOh/OeaD+5ejEwkrjKtD6/X4OMK9ir3UVA8F4CMJq4StaC
         iuSg==
X-Gm-Message-State: AOAM532S4n9R5QjrpONpDrBiyaHV8vi1MNJP4ehV77itG4icIseQyBax
	8HXIseUTvSpFej0QXksqTR7eJhGX2rbPZCTOVFiHHQ==
X-Google-Smtp-Source: ABdhPJzAX4svsZJBR0uTKuyW92MpXalgxf7mgAQksgMRG/xooOOs/BVWpFamO9B9n4VAYHQ50sVKIbuyHft+VFBaV+8=
X-Received: by 2002:a17:90a:708c:: with SMTP id g12mr7453500pjk.13.1629851362583;
 Tue, 24 Aug 2021 17:29:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAM9Jb+g5viRiogvv2Mms+nBVWrYQXKofC9pweADUAW8-C6+iOw@mail.gmail.com>
 <20210720063510.GB8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CALzYo30-fzcQMDVEhKMAGmzXO5hvtd-J6CtavesAUzaQjcpDcg@mail.gmail.com> <20210721220851.GB19842@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20210721220851.GB19842@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Aug 2021 17:29:11 -0700
Message-ID: <CAPcyv4gtS35-aLwmd5Jp+fT+CCdBaeFhaTor0t-p4GjhF8VtsQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
To: Taylor Stark <tstark@linux.microsoft.com>
Cc: Pankaj Gupta <pankaj.gupta@ionos.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, apais@microsoft.com, 
	tyhicks@microsoft.com, jamorris@microsoft.com, benhill@microsoft.com, 
	sunilmut@microsoft.com, grahamwo@microsoft.com, tstark@microsoft.com, 
	"Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 21, 2021 at 3:09 PM Taylor Stark <tstark@linux.microsoft.com> wrote:
>
> On Tue, Jul 20, 2021 at 08:51:04AM +0200, Pankaj Gupta wrote:
> > > > >
> > > > > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > > > -                       start, &vpmem->start);
> > > > > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > > > -                       size, &vpmem->size);
> > > > > +       /* Retrieve the pmem device's address and size. It may have been supplied
> > > > > +        * as a PCI BAR-relative shared memory region, or as a guest absolute address.
> > > > > +        */
> > > > > +       have_shm_region = virtio_get_shm_region(vpmem->vdev, &pmem_region,
> > > > > +                                               VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION);
> > > >
> > > > Current implementation of Virtio pmem device in Qemu does not expose
> > > > it as PCI BAR.
> > > > So, can't test it. Just curious if device side implementation is also
> > > > tested for asynchronous
> > > > flush case?
> > > >
> > > > Thanks,
> > > > Pankaj
> > >
> > > Yes, I tested the async flush case as well. We basically call
> > > FlushFileBuffers on the backing file, which is Windows' equivalent of
> > > fsync. I also briefly tested with qemu to ensure that still works with
> > > the patch.
> >
> > Thank you for the confirmation. This sounds really good.
> > I am also getting back to pending items for virtio-pmem.
> >
> > On a side question: Do you guys have any or plan for Windows guest
> > implementation
> > for virtio-pmem?
>
> Unfortunately, my team doesn't currently have any plans to add a Windows
> virtio-pmem implementation. My team is primarily focused on virtualization
> in client environments, which is a little different than server environments.
> For our Windows-based scenarios, dynamically sized disks are important. It's
> tricky to get that to work with pmem+DAX given that Windows isn't state separated.

Pardon me for commenting on an old thread...

What does "state separated" mean here? There's configuration
flexibility in the driver to resize persistent memory namespaces.
