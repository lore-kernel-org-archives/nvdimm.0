From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [PATCH 3/3] virtio-pmem: Add virtio pmem driver
Date: Thu, 27 Sep 2018 09:06:40 -0400 (EDT)
Message-ID: <435471901.16563045.1538053600799.JavaMail.zimbra@redhat.com>
References: <20180831133019.27579-1-pagupta@redhat.com> <20180831133019.27579-4-pagupta@redhat.com> <CAPcyv4gy-ONZz=PnXN92xYnyRX0rhu7Oq-_jPWJekbYQjNKRiw@mail.gmail.com> <1204243972.15515798.1537782119951.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1204243972.15515798.1537782119951.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Rik van Riel <riel@surriel.com>, Nitesh Narayan Lal <nilal@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Ross Zwisler <ross.zwisler@intel.com>, David Hildenbrand <david@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Christoph Hellwig <hch@infradead.org>, "Michael S. Tsirkin" <mst@redhat.com>, niteshnarayanlal@hotmail.com, lcapitulino@redhat.com, Igor Mammedov <imammedo@redhat.com>, Eric Blake <eblake@redhat.com>
List-Id: linux-nvdimm@lists.01.org


Hello Dan,

> > > + /* The request submission function */
> > > +static int virtio_pmem_flush(struct nd_region *nd_region)
> > > +{
> > > +       int err;

[...]

> > > +       init_waitqueue_head(&req->host_acked);
> > > +       init_waitqueue_head(&req->wq_buf);
> > > +
> > > +       spin_lock_irqsave(&vpmem->pmem_lock, flags);
> > > +       sg_init_one(&sg, req->name, strlen(req->name));
> > > +       sgs[0] = &sg;
> > > +       sg_init_one(&ret, &req->ret, sizeof(req->ret));
> > > +       sgs[1] = &ret;

[...]
> > > +       spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
> > > +       /* When host has read buffer, this completes via host_ack */
> > > +       wait_event(req->host_acked, req->done);
> > 
> > Hmm, this seems awkward if this is called from pmem_make_request. If
> > we need to wait for completion that should be managed by the guest
> > block layer. I.e. make_request should just queue request and then
> > trigger bio_endio() when the response comes back.
> 
> We are plugging VIRTIO based flush callback for virtio_pmem driver. If pmem
> driver (pmem_make_request) has to queue request we have to plug "blk_mq_ops"
> callbacks for corresponding  VIRTIO vqs. AFAICU there is no existing
> multiqueue
> code merged for pmem driver yet, though i could see patches by Dave upstream.
> 

I thought about this and with current infrastructure "make_request" releases spinlock 
and makes current thread/task. All Other threads are free to call 'make_request'/flush 
and similarly wait by releasing the lock. This actually works like a queue of threads 
waiting for notifications from host.

Current pmem code do not have multiqueue support and I am not sure if core pmem code 
needs it. Adding multiqueue support just for virtio-pmem and not for pmem in same driver
will be confusing or require alot of tweaking.

Could you please give your suggestions on this. 
 
Thanks,
Pankaj
