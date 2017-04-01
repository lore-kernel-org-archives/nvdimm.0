Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24D2720D77820
 for <linux-nvdimm@lists.01.org>; Sat,  1 Apr 2017 15:16:47 -0700 (PDT)
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-2-git-send-email-logang@deltatee.com>
 <cb102386-0314-a3a3-ed44-b42debdf1512@codeaurora.org>
 <7158f2e8-2016-f398-e77f-0fcbe6cb41dd@deltatee.com>
 <e6a74aeb-9f54-51c5-8ad9-3b6fb92c03b3@codeaurora.org>
 <0280fbb4-ba9e-ac64-6bb3-b72590a54e57@deltatee.com>
 <0ae27bca-21be-b89c-aba4-6cc9766ebd7b@codeaurora.org>
 <c8edc480-a2ac-a763-8438-18f3396db483@deltatee.com>
 <e2165253dc355d5cb223e754d78047b1@codeaurora.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <c5d7da85-41fd-2769-fcf8-b3c2a1fab95f@deltatee.com>
Date: Sat, 1 Apr 2017 16:16:35 -0600
MIME-Version: 1.0
In-Reply-To: <e2165253dc355d5cb223e754d78047b1@codeaurora.org>
Subject: Re: [RFC 1/8] Introduce Peer-to-Peer memory (p2pmem) device
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
To: okaya@codeaurora.org
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, linux-scsi@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hey,

On 31/03/17 08:17 PM, okaya@codeaurora.org wrote:
> See drivers/pci and drivers/acpi directory.

The best I could find was the date of the firmware/bios. I really don't
think that makes sense to tie the two together. And really the more that
I think about it trying to do a date cutoff for this seems crazy without
very comprehensive hardware testing done. I have no idea which AMD chips
have decent root ports for this and then if we include all of ARM and
POWERPC, etc there's a huge amount of unknown hardware. Saying that the
system's firmware has to be written after 2016 seems like an arbitrary
restriction that isn't likely to correlate to any working systems.

I still say the only sane thing to do is allow all switches and then add
a whitelist of root ports that are known to work well. If we care about
preventing broken systems in a comprehensive way then that's the only
thing that is going to work.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
