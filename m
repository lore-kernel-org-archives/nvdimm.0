From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/3] virtio-pmem: Add virtio pmem driver
Date: Thu, 27 Sep 2018 08:55:56 -0700
Message-ID: <CAPcyv4gvPhi4oe-KOo1HH+QbE-9whOvP7TypDshbbx3XZXh9=A@mail.gmail.com>
References: <20180831133019.27579-1-pagupta@redhat.com> <20180831133019.27579-4-pagupta@redhat.com>
 <CAPcyv4gy-ONZz=PnXN92xYnyRX0rhu7Oq-_jPWJekbYQjNKRiw@mail.gmail.com>
 <1204243972.15515798.1537782119951.JavaMail.zimbra@redhat.com> <435471901.16563045.1538053600799.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <435471901.16563045.1538053600799.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pankaj Gupta <pagupta@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Jan Kara <jack@suse.cz>, Stefan Hajnoczi <stefanha@redhat.com>, Rik van Riel <riel@surriel.com>, Nitesh Narayan Lal <nilal@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Zwisler, Ross" <ross.zwisler@intel.com>, David Hildenbrand <david@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Christoph Hellwig <hch@infradead.org>, "Michael S. Tsirkin" <mst@redhat.com>, niteshnarayanlal@hotmail.com, lcapitulino@redhat.com, Igor Mammedov <imammedo@redhat.com>, Eric Blake <eblake@redhat.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, Sep 27, 2018 at 6:07 AM Pankaj Gupta <pagupta@redhat.com> wrote:
[..]
> > We are plugging VIRTIO based flush callback for virtio_pmem driver. If pmem
> > driver (pmem_make_request) has to queue request we have to plug "blk_mq_ops"
> > callbacks for corresponding  VIRTIO vqs. AFAICU there is no existing
> > multiqueue
> > code merged for pmem driver yet, though i could see patches by Dave upstream.
> >
>
> I thought about this and with current infrastructure "make_request" releases spinlock
> and makes current thread/task. All Other threads are free to call 'make_request'/flush
> and similarly wait by releasing the lock.

Which lock are you referring?

> This actually works like a queue of threads
> waiting for notifications from host.
>
> Current pmem code do not have multiqueue support and I am not sure if core pmem code
> needs it. Adding multiqueue support just for virtio-pmem and not for pmem in same driver
> will be confusing or require alot of tweaking.

Why does the pmem driver need to be converted to multiqueue support?

> Could you please give your suggestions on this.

I was expecting that flush requests that cannot be completed
synchronously be placed on a queue and have bio_endio() called at a
future time. I.e. use bio_chain() to manage the async portion of the
flush request. This causes the guest block layer to just assume the
bio was queued and will be completed at some point in the future.
