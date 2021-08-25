Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ACEC3FC0
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 21:54:57 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1096)
	id 1790520B8604; Wed, 25 Aug 2021 14:46:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1790520B8604
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1629927963;
	bh=+s1tBY7n8IA7c76i6xhDFhZ4g0e7MZsS2QaJRBnsq7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bSTGY2Tv3cQfTvzrFVpWbLkpUN1495TkQN3NB0SkPO6NZr/G0Bv58eErXAI8aihh4
	 o001QZfgFg3UW+BYyn8vZYQRaa51MWt+Y+dPe6mIGG2oXBVhePe/dWiByD6aYMCMOe
	 PnTLx248a2htN8VAzLlIn8JS+Uyu2sHWOT/5Bbfs=
Date: Wed, 25 Aug 2021 14:46:03 -0700
From: Taylor Stark <tstark@linux.microsoft.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Pankaj Gupta <pankaj.gupta@ionos.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, apais@microsoft.com,
	tyhicks@microsoft.com, jamorris@microsoft.com,
	benhill@microsoft.com, sunilmut@microsoft.com,
	grahamwo@microsoft.com, tstark@microsoft.com,
	"Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
Message-ID: <20210825214603.GA3868@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAM9Jb+g5viRiogvv2Mms+nBVWrYQXKofC9pweADUAW8-C6+iOw@mail.gmail.com>
 <20210720063510.GB8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CALzYo30-fzcQMDVEhKMAGmzXO5hvtd-J6CtavesAUzaQjcpDcg@mail.gmail.com>
 <20210721220851.GB19842@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAPcyv4gtS35-aLwmd5Jp+fT+CCdBaeFhaTor0t-p4GjhF8VtsQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gtS35-aLwmd5Jp+fT+CCdBaeFhaTor0t-p4GjhF8VtsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Aug 24, 2021 at 05:29:11PM -0700, Dan Williams wrote:
> On Wed, Jul 21, 2021 at 3:09 PM Taylor Stark <tstark@linux.microsoft.com> wrote:
> >
> > On Tue, Jul 20, 2021 at 08:51:04AM +0200, Pankaj Gupta wrote:
> > > > > >
> > > > > > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > > > > -                       start, &vpmem->start);
> > > > > > -       virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
> > > > > > -                       size, &vpmem->size);
> > > > > > +       /* Retrieve the pmem device's address and size. It may have been supplied
> > > > > > +        * as a PCI BAR-relative shared memory region, or as a guest absolute address.
> > > > > > +        */
> > > > > > +       have_shm_region = virtio_get_shm_region(vpmem->vdev, &pmem_region,
> > > > > > +                                               VIRTIO_PMEM_SHMCAP_ID_PMEM_REGION);
> > > > >
> > > > > Current implementation of Virtio pmem device in Qemu does not expose
> > > > > it as PCI BAR.
> > > > > So, can't test it. Just curious if device side implementation is also
> > > > > tested for asynchronous
> > > > > flush case?
> > > > >
> > > > > Thanks,
> > > > > Pankaj
> > > >
> > > > Yes, I tested the async flush case as well. We basically call
> > > > FlushFileBuffers on the backing file, which is Windows' equivalent of
> > > > fsync. I also briefly tested with qemu to ensure that still works with
> > > > the patch.
> > >
> > > Thank you for the confirmation. This sounds really good.
> > > I am also getting back to pending items for virtio-pmem.
> > >
> > > On a side question: Do you guys have any or plan for Windows guest
> > > implementation
> > > for virtio-pmem?
> >
> > Unfortunately, my team doesn't currently have any plans to add a Windows
> > virtio-pmem implementation. My team is primarily focused on virtualization
> > in client environments, which is a little different than server environments.
> > For our Windows-based scenarios, dynamically sized disks are important. It's
> > tricky to get that to work with pmem+DAX given that Windows isn't state separated.
> 
> Pardon me for commenting on an old thread...
> 
> What does "state separated" mean here? There's configuration
> flexibility in the driver to resize persistent memory namespaces.

I think I might have been using Microsoft specific terminology - my bad. By "state
separated" I mean the system is split into read-only and read-write partitions.
Typically OS state is on the read-only partition and user data is on the
read-write partition (for easier servicing/upgrade). One of our primary use cases
for virtio-pmem is WSL GUI app support. In that scenario, we have a read-only
system distro, and we let the user dynamically fill the read-write partitions with
as many apps as they want (and have space for - remembering that their Windows apps
on the host are eating up space as well). Windows is not state separated, so we
have OS state intermingled with user data/apps all on one read-write partition.

The crux of the problem isn't really related to state separation, it's how do
you handle dynamically sized data with virtio-pmem? If there's a way to do that
already, I'm all ears :) But right now virtio-pmem is supplied with a fixed range
during init, so it wasn't immediately obvious to me how to make dynamically sized
data work. We'd have to like pick a max size, and expand the backing file on the
host on second level page fault when the guest tries to touch a page past whats 
already been allocated or something. Which is doable, there are just gotchas around
failure cases (do we have to kill the guest?), sharing disk space between the
Windows host and guest, etc. Getting back to why I said state separation makes
this easier, the read-only partitions are fixed size. So our WSL system distro
slots in nicely with virtio-pmem, but less so IMO for Windows guests (at least for
our use cases).

Long explanation - hope it helped to explain things. And if I'm missing something
obvious, please let me know! :)

Thanks,
Taylor
