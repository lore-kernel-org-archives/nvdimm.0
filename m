Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F40EA21951C81
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 09:58:48 -0700 (PDT)
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <c8edc480-a2ac-a763-8438-18f3396db483@deltatee.com>
 <e2165253dc355d5cb223e754d78047b1@codeaurora.org>
 <c5d7da85-41fd-2769-fcf8-b3c2a1fab95f@deltatee.com>
 <f0448277-9381-5c3d-d194-1efa1d1b44a6@codeaurora.org>
 <63d73995-4dfa-6270-ca13-972e0628011b@deltatee.com>
 <bed80d4e-7709-5991-498e-0ac361ca96a6@codeaurora.org>
 <ef507444-d3e5-0454-86a0-b5c4ae4b4dd9@deltatee.com>
 <117239810.400362790.1493121533234.JavaMail.zimbra@kalray.eu>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <190d9a89-e227-e410-5886-ee2e20a9b941@deltatee.com>
Date: Tue, 25 Apr 2017 10:58:40 -0600
MIME-Version: 1.0
In-Reply-To: <117239810.400362790.1493121533234.JavaMail.zimbra@kalray.eu>
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
To: Marta Rybczynska <mrybczyn@kalray.eu>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Alex Williamson <alex.williamson@redhat.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-ID: <linux-nvdimm@lists.01.org>



On 25/04/17 05:58 AM, Marta Rybczynska wrote:
> I would add one issue that doesn't seem to be addressed: in my experience
> P2P doesn't work when IOMMU activated. It works best with deactivation at
> the BIOS level, even the kernel options are not enough in some cases.

Well this would likely be addressed by 'arch_p2p_cross_segment' as
proposed by Jason.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
