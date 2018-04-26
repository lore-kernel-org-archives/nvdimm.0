From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC v2] qemu: Add virtio pmem device
Date: Thu, 26 Apr 2018 12:43:24 -0400 (EDT)
Message-ID: <358601698.23011599.1524761004239.JavaMail.zimbra@redhat.com>
References: <20180425112415.12327-1-pagupta@redhat.com>
 <20180425112415.12327-4-pagupta@redhat.com>
 <20180426132406.GC30991@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180426132406.GC30991-lxVrvc10SDRcolVlb+j0YCZi+YwRKgec@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org



> > +static void virtio_pmem_flush(VirtIODevice *vdev, VirtQueue *vq)
> > +{
> > +    VirtQueueElement *elem;
> > +    VirtIOPMEM *pmem = VIRTIO_PMEM(vdev);
> > +    HostMemoryBackend *backend = MEMORY_BACKEND(pmem->memdev);
> > +    int fd = memory_region_get_fd(&backend->mr);
> > +
> > +    elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
> > +    if (!elem) {
> > +        return;
> > +    }
> > +    /* flush raw backing image */
> > +    fsync(fd);
> 
> fsync(2) is a blocking syscall.  This can hang QEMU for an unbounded
> amount of time.

o.k. Main thread will block, agree.

> 
> Please do the fsync from a thread pool.  See block/file-posix.c's
> aio_worker() for an example.

Sure!

> 
> > +static void virtio_pmem_get_config(VirtIODevice *vdev, uint8_t *config)
> > +{
> > +    VirtIOPMEM *pmem = VIRTIO_PMEM(vdev);
> > +    struct virtio_pmem_config *pmemcfg = (struct virtio_pmem_config *)
> > config;
> > +
> > +    pmemcfg->start = pmem->start;
> > +    pmemcfg->size  = pmem->size;
> 
> Endianness.  Please use virtio_st*_p() instead.

sure.

> 
> > +#define VIRTIO_PMEM_PLUG 0
> 
> What is this?

will remove

Thanks,
Pankaj 
