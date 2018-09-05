Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22c.google.com (mail-it0-x22c.google.com
 [IPv6:2607:f8b0:4001:c0b::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F9E22194D387
 for <linux-nvdimm@lists.01.org>; Wed,  5 Sep 2018 13:14:52 -0700 (PDT)
Received: by mail-it0-x22c.google.com with SMTP id h23-v6so11166643ita.5
 for <linux-nvdimm@lists.01.org>; Wed, 05 Sep 2018 13:14:51 -0700 (PDT)
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-8-logang@deltatee.com>
 <b5ab8fa3-34ac-3117-fa0d-5206c3939435@kernel.dk>
 <20180901082812.GB670@lst.de>
 <5f79c012-c6e1-56bb-62fd-0689181fb2c9@deltatee.com>
 <59b28977-8f2a-6228-2050-03fae6bdbedd@kernel.dk>
 <1b4283da-44df-4a02-3167-e295243cef78@deltatee.com>
 <09258b9b-3aed-9890-b31a-bd70a133966c@kernel.dk>
 <20180905195647.GA1626@lst.de>
 <bcc1b3cf-2fd9-fa61-9cfb-b0e4d84e5d94@kernel.dk>
 <20180905201152.GA1893@lst.de>
 <eb42fb94-9da6-955b-8524-0a0f5ac4bd19@deltatee.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2a3394bd-5f13-4818-43f4-dfc61f501e05@kernel.dk>
Date: Wed, 5 Sep 2018 14:14:48 -0600
MIME-Version: 1.0
In-Reply-To: <eb42fb94-9da6-955b-8524-0a0f5ac4bd19@deltatee.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On 9/5/18 2:09 PM, Logan Gunthorpe wrote:
> 
> 
> On 05/09/18 02:11 PM, Christoph Hellwig wrote:
>> On Wed, Sep 05, 2018 at 01:54:31PM -0600, Jens Axboe wrote:
>>> On 9/5/18 1:56 PM, Christoph Hellwig wrote:
>>>> On Wed, Sep 05, 2018 at 01:45:04PM -0600, Jens Axboe wrote:
>>>>> The point is that the caller doesn't necessarily know where the bio
>>>>> will end up, hence the caller can't fully check if the whole stack
>>>>> supports P2P.
>>>>
>>>> The caller must necessarily know where the bio will end up, as for P2P
>>>> support we need to query if the bio target is P2P capable vs the
>>>> source of the P2P memory.
>>>
>>> Then what's the point of having the check at all?
>>
>> Just an additional little safe guard.  If you think it isn't worth
>> it I guess we can just drop it for now.
> 
> Yes, the point is to prevent driver writers from doing the wrong thing
> by not doing the necessary checks before submitting to the queue.

But if the caller must absolutely know where the bio will end up, then
it seems super redundant. So I'd vote for killing this check, it buys
us absolutely nothing and isn't even exhaustive in its current form.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
