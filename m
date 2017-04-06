Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-f196.google.com (mail-wr0-f196.google.com
 [209.85.128.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A3A4321942327
 for <linux-nvdimm@lists.01.org>; Wed,  5 Apr 2017 22:47:27 -0700 (PDT)
Received: by mail-wr0-f196.google.com with SMTP id t20so8035349wra.2
 for <linux-nvdimm@lists.01.org>; Wed, 05 Apr 2017 22:47:27 -0700 (PDT)
Subject: Re: [RFC 3/8] nvmet: Use p2pmem in nvme target
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-4-git-send-email-logang@deltatee.com>
 <bce6b009-7756-3cf7-5053-2628b26c8d97@grimberg.me>
 <ec05b7d9-8dfd-8227-84d2-7d391df32219@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <0689e764-bf04-6da2-3b7d-2cbf0b6b94a0@grimberg.me>
Date: Thu, 6 Apr 2017 08:47:22 +0300
MIME-Version: 1.0
In-Reply-To: <ec05b7d9-8dfd-8227-84d2-7d391df32219@deltatee.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>
List-ID: <linux-nvdimm@lists.01.org>


> I hadn't done this yet but I think a simple closest device in the tree
> would solve the issue sufficiently. However, I originally had it so the
> user has to pick the device and I prefer that approach. But if the user
> picks the device, then why bother restricting what he picks?

Because the user can get it wrong, and its our job to do what we can in
order to prevent the user from screwing itself.

> Per the
> thread with Sinan, I'd prefer to use what the user picks. You were one
> of the biggest opponents to that so I'd like to hear your opinion on
> removing the restrictions.

I wasn't against it that much, I'm all for making things "just work"
with minimal configuration steps, but I'm not sure we can get it
right without it.

>>> Ideally, we'd want to use an NVME CMB buffer as p2p memory. This would
>>> save an extra PCI transfer as the NVME card could just take the data
>>> out of it's own memory. However, at this time, cards with CMB buffers
>>> don't seem to be available.
>>
>> Even if it was available, it would be hard to make real use of this
>> given that we wouldn't know how to pre-post recv buffers (for in-capsule
>> data). But let's leave this out of the scope entirely...
>
> I don't understand what you're referring to. We'd simply use the CMB
> buffer as a p2pmem device, why does that change anything?

I'm referring to the in-capsule data buffers pre-posts that we do.
Because we prepare a buffer that would contain in-capsule data, we have
no knowledge to which device the incoming I/O is directed to, which
means we can (and will) have I/O where the data lies in CMB of device
A but it's really targeted to device B - which sorta defeats the purpose
of what we're trying to optimize here...

>> Why do you need this? you have a reference to the
>> queue itself.
>
> This keeps track of whether the response was actually allocated with
> p2pmem or not. It's needed for when we free the SGL because the queue
> may have a p2pmem device assigned to it but, if the alloc failed and it
> fell back on system memory then we need to know how to free it. I'm
> currently looking at having SGLs having an iomem flag. In which case,
> this would no longer be needed as the flag in the SGL could be used.

That would be better, maybe...

[...]

>> This is a problem. namespaces can be added at any point in time. No one
>> guarantee that dma_devs are all the namepaces we'll ever see.
>
> Yeah, well restricting p2pmem based on all the devices in use is hard.
> So we'd need a call into the transport every time an ns is added and
> we'd have to drop the p2pmem if they add one that isn't supported. This
> complexity is just one of the reasons I prefer just letting the user chose.

Still the user can get it wrong. Not sure we can get a way without
keeping track of this as new devices join the subsystem.

>>> +
>>> +    if (queue->p2pmem)
>>> +        pr_debug("using %s for rdma nvme target queue",
>>> +             dev_name(&queue->p2pmem->dev));
>>> +
>>> +    kfree(dma_devs);
>>> +}
>>> +
>>>  static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
>>>          struct rdma_cm_event *event)
>>>  {
>>> @@ -1199,6 +1271,8 @@ static int nvmet_rdma_queue_connect(struct
>>> rdma_cm_id *cm_id,
>>>      }
>>>      queue->port = cm_id->context;
>>>
>>> +    nvmet_rdma_queue_setup_p2pmem(queue);
>>> +
>>
>> Why is all this done for each queue? looks completely redundant to me.
>
> A little bit. Where would you put it?

I think we'll need a representation of a controller in nvmet-rdma for
that. we sort of got a way without it so far, but I don't think we can
anymore with this.

>>>      ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
>>>      if (ret)
>>>          goto release_queue;
>>
>> You seemed to skip the in-capsule buffers for p2pmem (inline_page), I'm
>> curious why?
>
> Yes, the thinking was that these transfers were small anyway so there
> would not be significant benefit to pushing them through p2pmem. There's
> really no reason why we couldn't do that if it made sense to though.

I don't see an urgent reason for it too. I was just curious...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
