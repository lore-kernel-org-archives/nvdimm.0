Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B2C91211093A4
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 17:34:51 -0700 (PDT)
Subject: Re: [PATCH v5 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-7-logang@deltatee.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <382af881-0ae1-0274-4628-0137071125b1@infradead.org>
Date: Thu, 30 Aug 2018 17:34:32 -0700
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Jonathan Corbet <corbet@lwn.net>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

I have a few comments below...

On 08/30/2018 11:53 AM, Logan Gunthorpe wrote:
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> ---
>  Documentation/driver-api/pci/index.rst  |   1 +
>  Documentation/driver-api/pci/p2pdma.rst | 170 ++++++++++++++++++++++++++++++++
>  2 files changed, 171 insertions(+)
>  create mode 100644 Documentation/driver-api/pci/p2pdma.rst

> diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> new file mode 100644
> index 000000000000..ac857450d53f
> --- /dev/null
> +++ b/Documentation/driver-api/pci/p2pdma.rst
> @@ -0,0 +1,170 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
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

                                            transactions

> +hierarchy will be routable, but it does not require routing
> +between hierarchies.
> +
> +The second issue is that to make use of existing interfaces in Linux,
> +memory that is used for P2P transactions needs to be backed by struct
> +pages. However, PCI BARs are not typically cache coherent so there are
> +a few corner case gotchas with these pages so developers need to
> +be careful about what they do with them.
> +
> +
> +Driver Writer's Guide
> +=====================
> +
> +In a given P2P implementation there may be three or more different
> +types of kernel drivers in play:
> +
> +* Provider - A driver which provides or publishes P2P resources like
> +  memory or doorbell registers to other drivers.
> +* Client - A driver which makes use of a resource by setting up a
> +  DMA transaction to or from it.
> +* Orchestrator - A driver which orchestrates the flow of data between
> +  clients and providers

Might as well end that last one with a period since the other 2 are.

> +
> +In many cases there could be overlap between these three types (i.e.,
> +it may be typical for a driver to be both a provider and a client).
> +

[snip]

> +
> +Orchestrator Drivers
> +--------------------
> +
> +The first task an orchestrator driver must do is compile a list of
> +all client devices that will be involved in a given transaction. For
> +example, the NVMe Target driver creates a list including all NVMe
> +devices and the RNIC in use. The list is stored as an anonymous struct
> +list_head which must be initialized with the usual INIT_LIST_HEAD.
> +The following functions may then be used to add to, remove from and free
> +the list of clients with the functions :c:func:`pci_p2pdma_add_client()`,
> +:c:func:`pci_p2pdma_remove_client()` and
> +:c:func:`pci_p2pdma_client_list_free()`.
> +
> +With the client list in hand, the orchestrator may then call> +:c:func:`pci_p2pmem_find()` to obtain a published P2P memory provider
> +that is supported (behind the same root port) as all the clients. If more
> +than one provider is supported, the one nearest to all the clients will
> +be chosen first. If there are more than one provider is an equal distance
> +away, the one returned will be chosen at random. This function returns the PCI

random or just arbitrarily?

> +device to use for the provider with a reference taken and therefore
> +when it's no longer needed it should be returned with pci_dev_put().


thanks,
-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
