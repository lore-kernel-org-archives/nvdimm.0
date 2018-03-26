Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on0082.outbound.protection.outlook.com [104.47.0.82])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5214321F85E70
 for <linux-nvdimm@lists.01.org>; Mon, 26 Mar 2018 12:28:46 -0700 (PDT)
Date: Mon, 26 Mar 2018 13:35:02 -0600
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180326193502.GI15530@mellanox.com>
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <20180326121138.00005e30@huawei.com>
 <20180326164129.GF15530@mellanox.com>
 <6ead7f19-c0e5-5584-2518-1e1889a007e4@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6ead7f19-c0e5-5584-2518-1e1889a007e4@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Eric Wehage <Eric.Wehage@huawei.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 26, 2018 at 11:30:38AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 26/03/18 10:41 AM, Jason Gunthorpe wrote:
> > On Mon, Mar 26, 2018 at 12:11:38PM +0100, Jonathan Cameron wrote:
> >> On Tue, 13 Mar 2018 10:43:55 -0600
> >> Logan Gunthorpe <logang@deltatee.com> wrote:
> >>
> >>> On 12/03/18 09:28 PM, Sinan Kaya wrote:
> >>>> On 3/12/2018 3:35 PM, Logan Gunthorpe wrote:
> >>>> Regarding the switch business, It is amazing how much trouble you went into
> >>>> limit this functionality into very specific hardware.
> >>>>
> >>>> I thought that we reached to an agreement that code would not impose
> >>>> any limits on what user wants.
> >>>>
> >>>> What happened to all the emails we exchanged?  
> >>>
> >>> It turns out that root ports that support P2P are far less common than 
> >>> anyone thought. So it will likely have to be a white list.
> >>
> >> This came as a bit of a surprise to our PCIe architect.
> > 
> > I don't think it is a hardware problem.
> 
> The latest and greatest Power9 CPUs still explicitly do not support
> this.

I think this is another case of the HW can do it but the SW support is
missing. IOMMU configuration and maybe firmware too, for instance.

If I recall I saw a presentation that Coral was expected to use P2P
between the network and GPU.

> And, if I recall correctly, the ARM64 device we played with did
> not either -- but I suspect that will differ depending on vendor.

Wouldn't surprise me at all to see broken implementations in
ARM64.. But even there it needs IOMMU enablement to work at all if I
recall.

Bascially, this is probably not a HW problem that needs a HW bit, but
a OS/firmware problem to do all the enablement..

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
