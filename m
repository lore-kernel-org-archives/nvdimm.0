Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6511621BC6ADB
 for <linux-nvdimm@lists.01.org>; Sun,  2 Apr 2017 14:04:01 -0700 (PDT)
Subject: Re: [RFC 1/8] Introduce Peer-to-Peer memory (p2pmem) device
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-2-git-send-email-logang@deltatee.com>
 <cb102386-0314-a3a3-ed44-b42debdf1512@codeaurora.org>
 <7158f2e8-2016-f398-e77f-0fcbe6cb41dd@deltatee.com>
 <e6a74aeb-9f54-51c5-8ad9-3b6fb92c03b3@codeaurora.org>
 <0280fbb4-ba9e-ac64-6bb3-b72590a54e57@deltatee.com>
 <0ae27bca-21be-b89c-aba4-6cc9766ebd7b@codeaurora.org>
 <c8edc480-a2ac-a763-8438-18f3396db483@deltatee.com>
 <e2165253dc355d5cb223e754d78047b1@codeaurora.org>
 <c5d7da85-41fd-2769-fcf8-b3c2a1fab95f@deltatee.com>
 <f0448277-9381-5c3d-d194-1efa1d1b44a6@codeaurora.org>
 <63d73995-4dfa-6270-ca13-972e0628011b@deltatee.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <bed80d4e-7709-5991-498e-0ac361ca96a6@codeaurora.org>
Date: Sun, 2 Apr 2017 17:03:53 -0400
MIME-Version: 1.0
In-Reply-To: <63d73995-4dfa-6270-ca13-972e0628011b@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 4/2/2017 1:21 PM, Logan Gunthorpe wrote:
>> This is when the BIOS date helps so that you don't break existing systems.
> I'm not that worried about this code breaking existing systems. There
> are significant trade-offs with using p2pmem (ie. you are quite likely
> sacrificing performance for memory QOS or upstream PCI bandwidth), and
> therefore the user _has_ to specifically say to use it. This is why
> we've put a flag in the nvme target code that defaults to off. Thus we
> are not going to have a situation where people upgrade their kernels and
> see broken or slow systems. People _have_ to make the decision to turn
> it on and decide based on their use case whether it's appropriate.
> 

OK. I didn't know the feature was not enabled by default. This is even 
easier now. 

Push the decision all the way to the user. Let them decide whether they
want this feature to work on a root port connected port or under the
switch.

>> We can't guarentee all switches will work either. See above for instructions
>> on when this feature should be enabled.
> It's a lot easier to say that all switches will work than it is for root
> ports. This is essentially what switches are designed for, so I'd be
> surprised to find one that doesn't work. Root ports are the trouble here
> seeing it's a lot more likely for them to be designed without
> considering that traffic needs to move between ports efficiently. If we
> do find extremely broken switches that don't support this then we'd
> probably want to create a black list for that. Also, there's
> significantly fewer PCI switch products on the market than there are
> root port instances, so a black list would be much easier to manage there.
> 

I thought the issue was feature didn't work at all with some root ports
or there was some kind of memory corruption issue that you were trying to
avoid with the existing systems.

If you are just worried about performance, the switch recommendation belongs
to your particular product tuning guide or a howto document not into the
actual code itself. 

I think you should get rid of all pci searching business in your code.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
