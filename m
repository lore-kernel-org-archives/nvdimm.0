Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9A7E224C0F49
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 13:29:29 -0800 (PST)
Date: Thu, 1 Mar 2018 16:35:33 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v2 04/10] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Message-ID: <20180301213533.GE6742@redhat.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-5-logang@deltatee.com>
 <20180301180257.GH13722@bhelgaas-glaptop.roam.corp.google.com>
 <0D05579B-789C-4A19-B3A2-C1A630BE31C0@raithlin.com>
 <20180301142155.5966c4c0@w520.home>
 <EE1B4EB7-D3C0-4916-81CE-E647222D03E4@raithlin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <EE1B4EB7-D3C0-4916-81CE-E647222D03E4@raithlin.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Stephen Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 09:32:20PM +0000, Stephen  Bates wrote:
> > your kernel provider needs to decide whether they favor device assignme=
nt or p2p
> =

> Thanks Alex! The hardware requirements for P2P (switch, high performance =
EPs) are such that we really only expect CONFIG_P2P_DMA to be enabled in sp=
ecific instances and in those instances the users have made a decision to f=
avor P2P over IOMMU isolation. Or they have setup their PCIe topology in a =
way that gives them IOMMU isolation where they want it and P2P where they w=
ant it.
> =

> =


Note that they are usecase for P2P where IOMMU isolation matter and
the traffic through root complex isn't see as an issue. For instance
for GPU the idea is that you want to allow the RDMA device to directly
read or write from GPU memory to avoid having to migrate memory to
system memory. This isn't so much for performance than for ease of
use.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
