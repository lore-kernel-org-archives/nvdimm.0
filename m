Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3F770
	for <nvdimm@lists.linux.dev>; Tue, 20 Jul 2021 06:35:16 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1096)
	id 4E7C920B7178; Mon, 19 Jul 2021 23:35:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4E7C920B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1626762910;
	bh=JTacEHvMReBHz+sxFanAVqmTqOcf9mqw8F4SJvhKzOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g6f30W3BNATqxc4IE8KuToFJbE8gQej/w30TePM77G90p04xW4IKFx7XIzRfkkIGi
	 HWhzD5M1FgBoVoxcoeCrwi+d30DELNVW2CX3dy6JaugviNgywKg88x4XrhGWQk1kM6
	 hd6qgPUsFdZTcWqA0CNzVOmK3Ikk2y+fTEVmPR64=
Date: Mon, 19 Jul 2021 23:35:10 -0700
From: Taylor Stark <tstark@linux.microsoft.com>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, apais@microsoft.com, tyhicks@microsoft.com,
	jamorris@microsoft.com, benhill@microsoft.com,
	sunilmut@microsoft.com, grahamwo@microsoft.com,
	tstark@microsoft.com, "Michael S . Tsirkin" <mst@redhat.com>,
	Pankaj Gupta <pankaj.gupta@ionos.com>
Subject: Re: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
Message-ID: <20210720063510.GB8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAM9Jb+g5viRiogvv2Mms+nBVWrYQXKofC9pweADUAW8-C6+iOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9Jb+g5viRiogvv2Mms+nBVWrYQXKofC9pweADUAW8-C6+iOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Jul 19, 2021 at 10:36:34PM +0200, Pankaj Gupta wrote:
> > Update virtio-pmem to allow for the pmem region to be specified in either
> > guest absolute terms or as a PCI BAR-relative address. This is required
> > to support virtio-pmem in Hyper-V, since Hyper-V only allows PCI devices
> > to operate on PCI memory ranges defined via BARs.
> >
> > Virtio-pmem will check for a shared memory window and use that if found,
> > else it will fallback to using the guest absolute addresses in
> > virtio_pmem_config. This was chosen over defining a new feature bit,
> > since it's similar to how virtio-fs is configured.
> >
> > Signed-off-by: Taylor Stark <tstark@microsoft.com>
> > ---
> >  drivers/nvdimm/virtio_pmem.c | 21 +++++++++++++++++----
> >  drivers/nvdimm/virtio_pmem.h |  3 +++
> >  2 files changed, 20 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> > index 726c7354d465..43c1d835a449 100644
> > --- a/drivers/nvdimm/virtio_pmem.c
> > +++ b/drivers/nvdimm/virtio_pmem.c
> > @@ -37,6 +37,8 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >         struct virtio_pmem *vpmem;
> >         struct resource res;
> >         int err = 0;
> > +       bool have_shm_region;
> > +       struct virtio_shm_region pmem_region;
> >
> >         if (!vdev->config->get) {
> >                 dev_err(&vdev->dev, "%s failure: config access disabled\n",
> > @@ -58,10 +60,21 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
> >                 goto out_err;
> >         }
> >
> > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > -                       start, &vpmem->start);
> > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > -                       size, &vpmem->size);
> > +       /* Retrieve the pmem device's address and size. It may have been supplied
> > +        * as a PCI BAR-relative shared memory region, or as a guest absolute address.
> > +        */
> > +       have_shm_region = virtio_get_shm_region(vpmem->vdev, &pmem_region,
> > +                                               VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION);
> 
> Current implementation of Virtio pmem device in Qemu does not expose
> it as PCI BAR.
> So, can't test it. Just curious if device side implementation is also
> tested for asynchronous
> flush case?
> 
> Thanks,
> Pankaj

Yes, I tested the async flush case as well. We basically call
FlushFileBuffers on the backing file, which is Windows' equivalent of
fsync. I also briefly tested with qemu to ensure that still works with
the patch.

Thanks,
Taylor
 
> > +
> > +       if (have_shm_region) {
> > +               vpmem->start = pmem_region.addr;
> > +               vpmem->size = pmem_region.len;
> > +       } else {
> > +               virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > +                               start, &vpmem->start);
> > +               virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > +                               size, &vpmem->size);
> > +       }
> >
> >         res.start = vpmem->start;
> >         res.end   = vpmem->start + vpmem->size - 1;
> > diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
> > index 0dddefe594c4..62bb564e81cb 100644
> > --- a/drivers/nvdimm/virtio_pmem.h
> > +++ b/drivers/nvdimm/virtio_pmem.h
> > @@ -50,6 +50,9 @@ struct virtio_pmem {
> >         __u64 size;
> >  };
> >
> > +/* For the id field in virtio_pci_shm_cap */
> > +#define VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION 0
> > +
> >  void virtio_pmem_host_ack(struct virtqueue *vq);
> >  int async_pmem_flush(struct nd_region *nd_region, struct bio *bio);
> >  #endif
> > --
> > 2.32.0
> >
> >
