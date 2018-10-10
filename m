Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com
 [IPv6:2607:f8b0:4864:20::d42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F5312116169A
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 13:00:11 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id w16-v6so4833049iom.7
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 13:00:11 -0700 (PDT)
Subject: Re: [PATCH v9 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181004212747.6301-8-logang@deltatee.com>
 <485de371-0e84-6f20-7f3b-cec5635b87fe@kernel.dk>
 <20181010195901.GE5906@bhelgaas-glaptop.roam.corp.google.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <167fcf01-4bbc-f870-3750-6e950bfd6471@kernel.dk>
Date: Wed, 10 Oct 2018 14:00:07 -0600
MIME-Version: 1.0
In-Reply-To: <20181010195901.GE5906@bhelgaas-glaptop.roam.corp.google.com>
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
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On 10/10/18 1:59 PM, Bjorn Helgaas wrote:
> On Fri, Oct 05, 2018 at 07:16:04PM -0600, Jens Axboe wrote:
>> On 10/4/18 3:27 PM, Logan Gunthorpe wrote:
>>> QUEUE_FLAG_PCI_P2P is introduced meaning a driver's request queue
>>> supports targeting P2P memory. This will be used by P2P providers and
>>> orchestrators (in subsequent patches) to ensure block devices can
>>> support P2P memory before submitting P2P backed pages to submit_bio().
>>
>> Nit pick, but the subject line still says that it checks support
>> for requests. This patch just adds the ability to flag support
>> in the queue.
> 
> What about the following?  MAINTAINERS doesn't list a specific
> maintainer for include/linux/blkdev.h (maybe the "BLOCK LAYER" entry
> should have an F: pattern for it?), but I'd really like your ack
> before merging this.
> 
> commit 7e647ae1eda290786851c3dff4f38189b982386d
> Author: Logan Gunthorpe <logang@deltatee.com>
> Date:   Thu Oct 4 15:27:41 2018 -0600
> 
>     block: Add PCI P2P flag for request queue
>     
>     Add QUEUE_FLAG_PCI_P2P, meaning a driver's request queue supports targeting
>     P2P memory.  This will be used by P2P providers and orchestrators (in
>     subsequent patches) to ensure block devices can support P2P memory before
>     submitting P2P-backed pages to submit_bio().
>     
>     Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     Reviewed-by: Christoph Hellwig <hch@lst.de>

You can add my acked-by to this one.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
