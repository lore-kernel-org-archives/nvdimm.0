Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F2A1D21A04820
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 19:17:07 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 31 Mar 2017 22:17:07 -0400
From: okaya@codeaurora.org
Subject: Re: [RFC 1/8] Introduce Peer-to-Peer memory (p2pmem) device
In-Reply-To: <c8edc480-a2ac-a763-8438-18f3396db483@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-2-git-send-email-logang@deltatee.com>
 <cb102386-0314-a3a3-ed44-b42debdf1512@codeaurora.org>
 <7158f2e8-2016-f398-e77f-0fcbe6cb41dd@deltatee.com>
 <e6a74aeb-9f54-51c5-8ad9-3b6fb92c03b3@codeaurora.org>
 <0280fbb4-ba9e-ac64-6bb3-b72590a54e57@deltatee.com>
 <0ae27bca-21be-b89c-aba4-6cc9766ebd7b@codeaurora.org>
 <c8edc480-a2ac-a763-8438-18f3396db483@deltatee.com>
Message-ID: <e2165253dc355d5cb223e754d78047b1@codeaurora.org>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "James E.J. Bottomley  <jejb@linux.vnet.ibm.com>, Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, linux-scsi@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 2017-03-31 21:57, Logan Gunthorpe wrote:
> On 31/03/17 05:51 PM, Sinan Kaya wrote:
>> You can put a restriction with DMI/SMBIOS such that all devices from 
>> 2016
>> work else they belong to blacklist.
> 
> How do you get a manufacturing date for a given device within the
> kernel? Is this actually something generically available?
> 
> Logan

Smbios calls are used all over the place in kernel for introducing new 
functionality while maintaining backwards compatibility.

See drivers/pci and drivers/acpi directory.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
