Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A39621959CB2
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 00:34:24 -0700 (PDT)
Received: by mail-pg1-f195.google.com with SMTP id f18-v6so4365520pgv.3
 for <linux-nvdimm@lists.01.org>; Fri, 05 Oct 2018 00:34:23 -0700 (PDT)
Subject: Re: [PATCH v9 13/13] nvmet: Optionally use PCI P2P memory
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181004212747.6301-14-logang@deltatee.com>
 <a3af4bda-0b73-c964-c7d6-5d59f0710768@grimberg.me>
 <2bcc0927-83ab-1bf2-d584-aebd5274cefa@deltatee.com>
 <20181005070720.GA23725@lst.de>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <236ae882-34e0-50d8-ac19-ee5dab8db3f2@grimberg.me>
Date: Fri, 5 Oct 2018 00:34:06 -0700
MIME-Version: 1.0
In-Reply-To: <20181005070720.GA23725@lst.de>
Content-Language: en-US
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
To: Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>


>>>> +static inline struct device *nvmet_ns_dev(struct nvmet_ns *ns)
>>>> +{
>>>> +	return disk_to_dev(ns->bdev->bd_disk);
>>>> +}
>>>
>>> This needs to handle non bdev namespaces.
>>
>> As it's coded now the helper never gets called unless ns->bdev is not
>> null. But in general, yes you are right, we should probably return NULL
>> if ns->bdev is NULL.
> 
> I'd rather skip that for now.

If there is a v10 I don't see why that cannot be addressed.

>>> index ef286b72d958..3d12f5f4568d 100644
>>> --- a/drivers/nvme/target/fc.c
>>> +++ b/drivers/nvme/target/fc.c
>>> @@ -2280,6 +2280,7 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport
>>> *tgtport,
>>>           fod->req.cmd = &fod->cmdiubuf.sqe;
>>>           fod->req.rsp = &fod->rspiubuf.cqe;
>>>           fod->req.port = tgtport->pe->port;
>>> +       fod->req.p2p_client = tgtport->dev;
>>>
>>>           /* clear any response payload */
>>>           memset(&fod->rspiubuf, 0, sizeof(fod->rspiubuf));
>>> --
>>
>> Sure, I guess that makes sense. I've never tried it with fc hardware but
>> I assume there's no reason it wouldn't work.
>>
>> I'll queue these changes up for a v10.
> 
> And I'd wait until someone has actually tested this case.

Oh yes, agreed. Should work though...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
