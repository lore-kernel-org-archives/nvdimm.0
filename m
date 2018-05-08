Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5717C202E5CCE
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 07:31:31 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id b130-v6so28505333oif.12
 for <linux-nvdimm@lists.01.org>; Tue, 08 May 2018 07:31:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180423233046.21476-5-logang@deltatee.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 May 2018 07:31:30 -0700
Message-ID: <CAPcyv4g+5N_n03J-VhmJfrr60Sqk95ZapLKBkwSsGvV4nQ+ZRw@mail.gmail.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 23, 2018 at 4:30 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> For peer-to-peer transactions to work the downstream ports in each
> switch must not have the ACS flags set. At this time there is no way
> to dynamically change the flags and update the corresponding IOMMU
> groups so this is done at enumeration time before the groups are
> assigned.
>
> This effectively means that if CONFIG_PCI_P2PDMA is selected then
> all devices behind any PCIe switch heirarchy will be in the same IOMMU
> group. Which implies that individual devices behind any switch
> heirarchy will not be able to be assigned to separate VMs because
> there is no isolation between them. Additionally, any malicious PCIe
> devices will be able to DMA to memory exposed by other EPs in the same
> domain as TLPs will not be checked by the IOMMU.
>
> Given that the intended use case of P2P Memory is for users with
> custom hardware designed for purpose, we do not expect distributors
> to ever need to enable this option. Users that want to use P2P
> must have compiled a custom kernel with this configuration option
> and understand the implications regarding ACS. They will either
> not require ACS or will have design the system in such a way that
> devices that require isolation will be separate from those using P2P
> transactions.

>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/pci/Kconfig        |  9 +++++++++
>  drivers/pci/p2pdma.c       | 45 ++++++++++++++++++++++++++++++---------------
>  drivers/pci/pci.c          |  6 ++++++
>  include/linux/pci-p2pdma.h |  5 +++++
>  4 files changed, 50 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index b2396c22b53e..b6db41d4b708 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -139,6 +139,15 @@ config PCI_P2PDMA
>           transations must be between devices behind the same root port.
>           (Typically behind a network of PCIe switches).
>
> +         Enabling this option will also disable ACS on all ports behind
> +         any PCIe switch. This effectively puts all devices behind any
> +         switch heirarchy into the same IOMMU group. Which implies that
> +         individual devices behind any switch will not be able to be
> +         assigned to separate VMs because there is no isolation between
> +         them. Additionally, any malicious PCIe devices will be able to
> +         DMA to memory exposed by other EPs in the same domain as TLPs
> +         will not be checked by the IOMMU.
> +
>           If unsure, say N.

It seems unwieldy that this is a compile time option and not a runtime
option. Can't we have a kernel command line option to opt-in to this
behavior rather than require a wholly separate kernel image?

Why is this text added in a follow on patch and not the patch that
introduced the config option?

I'm also wondering if that command line option can take a 'bus device
function' address of a switch to limit the scope of where ACS is
disabled.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
