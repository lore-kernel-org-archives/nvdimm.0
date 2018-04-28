From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [RFC v2 1/2] virtio: add pmem driver
Date: Sat, 28 Apr 2018 06:48:41 -0400 (EDT)
Message-ID: <1266554822.23475618.1524912521209.JavaMail.zimbra@redhat.com>
References: <20180425112415.12327-1-pagupta@redhat.com>
 <20180425112415.12327-2-pagupta@redhat.com>
 <20180426131236.GA30991@stefanha-x1.localdomain>
 <197910974.22984070.1524757499459.JavaMail.zimbra@redhat.com>
 <20180427133146.GB11150@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180427133146.GB11150-lxVrvc10SDRcolVlb+j0YCZi+YwRKgec@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Stefan Hajnoczi <stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ross zwisler <ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


> > > > +        int err;
> > > > +
> > > > +        sg_init_one(&sg, buf, sizeof(buf));
> > > > +
> > > > +        err = virtqueue_add_outbuf(vpmem->req_vq, &sg, 1, buf, GFP_KERNEL);
> > > > +
> > > > +        if (err) {
> > > > +                dev_err(&vdev->dev, "failed to send command to virtio pmem
> > > > device\n");
> > > > +                return;
> > > > +        }
> > > > +
> > > > +        virtqueue_kick(vpmem->req_vq);
> > > 
> > > Is any locking necessary?  Two CPUs must not invoke virtio_pmem_flush()
> > > at the same time.  Not sure if anything guarantees this, maybe you're
> > > relying on libnvdimm but I haven't checked.
> > 
> > I thought about it to some extent, and wanted to go ahead with simple
> > version first:
> > 
> > - I think file 'inode -> locking' sill is there for request on single file.
> > - For multiple files, our aim is to just flush the backend block image.
> > - Even there is collision for virt queue read/write entry it should just
> > trigger a Qemu fsync.
> >   We just want most recent flush to assure guest writes are synced
> >   properly.
> > 
> > Important point here: We are doing entire block fsync for guest virtual
> > disk.
> 
> I don't understand your answer.  Is locking necessary or not?

It will be required with other changes.

> 
> From the virtqueue_add_outbuf() documentation:
> 
>  * Caller must ensure we don't call this with other virtqueue operations
>  * at the same time (except where noted).

Yes, I also saw it. But thought if can avoid it with current functionality. :)


Thanks,
Pankaj
