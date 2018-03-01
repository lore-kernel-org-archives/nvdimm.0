Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31DF32242383D
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 02:25:50 -0800 (PST)
Received: by mail-wr0-f194.google.com with SMTP id k9so5519086wre.9
 for <linux-nvdimm@lists.01.org>; Thu, 01 Mar 2018 02:31:58 -0800 (PST)
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
References: <20180228234006.21093-1-logang@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <90b658d9-da8a-af36-ad8f-a72ef0c6e3c1@grimberg.me>
Date: Thu, 1 Mar 2018 12:31:53 +0200
MIME-Version: 1.0
In-Reply-To: <20180228234006.21093-1-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>


> Hi Everyone,

Hi Logan,

> Here's v2 of our series to introduce P2P based copy offload to NVMe
> fabrics. This version has been rebased onto v4.16-rc3 which already
> includes Christoph's devpagemap work the previous version was based
> off as well as a couple of the cleanup patches that were in v1.
> 
> Additionally, we've made the following changes based on feedback:
> 
> * Renamed everything to 'p2pdma' per the suggestion from Bjorn as well
>    as a bunch of cleanup and spelling fixes he pointed out in the last
>    series.
> 
> * To address Alex's ACS concerns, we change to a simpler method of
>    just disabling ACS behind switches for any kernel that has
>    CONFIG_PCI_P2PDMA.
> 
> * We also reject using devices that employ 'dma_virt_ops' which should
>    fairly simply handle Jason's concerns that this work might break with
>    the HFI, QIB and rxe drivers that use the virtual ops to implement
>    their own special DMA operations.

That's good, but what would happen for these devices? simply fail the
mapping causing the ulp to fail its rdma operation? I would think
that we need a capability flag for devices that support it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
