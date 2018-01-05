Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 123BC21D046C6
 for <linux-nvdimm@lists.01.org>; Fri,  5 Jan 2018 10:03:36 -0800 (PST)
Date: Fri, 5 Jan 2018 11:11:53 -0700
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 09/12] nvme-pci: Use PCI p2pmem subsystem to manage the CMB
Message-ID: <20180105181152.GA10657@localhost.localdomain>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-10-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180104190137.7654-10-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 04, 2018 at 12:01:34PM -0700, Logan Gunthorpe wrote:
> Register the CMB buffer as p2pmem and use the appropriate allocation
> functions to create and destroy the IO SQ.
> 
> If the CMB supports WDS and RDS, publish it for use as p2p memory
> by other devices.

<>

> +	if (qid && dev->cmb_use_sqes) {
> +		nvmeq->sq_cmds = pci_alloc_p2pmem(pdev, SQ_SIZE(depth));

> +		nvmeq->sq_dma_addr = pci_p2pmem_virt_to_bus(pdev,
> +							    nvmeq->sq_cmds);
> +		nvmeq->sq_cmds_is_io = true;
> +	}

This gets into some spec type trouble for creating an IO submission
queue. We use the sq_dma_addr as the PRP entry to the Create I/O
SQ command, which has some requirements:

  "the PRP Entry shall have an offset of 0h."

So this has to be 4k aligned, but pci_alloc_p2pmem doesn't guarantee
that. I doubt the spec's intention was to require such alignment for
CMB SQs, but there may be controllers enforcing the rule as written.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
