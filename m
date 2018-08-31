Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on0048.outbound.protection.outlook.com [104.47.38.48])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DCFD21106F31
 for <linux-nvdimm@lists.01.org>; Fri, 31 Aug 2018 01:08:34 -0700 (PDT)
Subject: Re: [PATCH v5 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-7-logang@deltatee.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <98bff500-4e4c-3a34-6762-16ef4b076d90@amd.com>
Date: Fri, 31 Aug 2018 10:08:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180830185352.3369-7-logang@deltatee.com>
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
Cc: Jonathan Corbet <corbet@lwn.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Am 30.08.2018 um 20:53 schrieb Logan Gunthorpe:
> [SNIP]
> +============================
> +PCI Peer-to-Peer DMA Support
> +============================
> +
> +The PCI bus has pretty decent support for performing DMA transfers
> +between two devices on the bus. This type of transaction is henceforth
> +called Peer-to-Peer (or P2P). However, there are a number of issues that
> +make P2P transactions tricky to do in a perfectly safe way.
> +
> +One of the biggest issues is that PCI doesn't require forwarding
> +transactions between hierarchy domains, and in PCIe, each Root Port
> +defines a separate hierarchy domain. To make things worse, there is no
> +simple way to determine if a given Root Complex supports this or not.
> +(See PCIe r4.0, sec 1.3.1). Therefore, as of this writing, the kernel
> +only supports doing P2P when the endpoints involved are all behind the
> +same PCI bridge, as such devices are all in the same PCI hierarchy
> +domain, and the spec guarantees that all transacations within the
> +hierarchy will be routable, but it does not require routing
> +between hierarchies.

Can we add a kernel command line switch and a whitelist to enable P2P 
between separate hierarchies?

At least all newer AMD chipsets supports this and I'm pretty sure that 
Intel has a list with PCI-IDs of the root hubs for this as well.

Regards,
Christian.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
