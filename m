Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B4BB521154135
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 09:05:31 -0700 (PDT)
Date: Fri, 21 Sep 2018 18:05:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 01/13] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180921160533.GA26601@lst.de>
References: <20180913001156.4115-1-logang@deltatee.com>
 <20180913001156.4115-2-logang@deltatee.com>
 <20180920223829.GD224714@bhelgaas-glaptop.roam.corp.google.com>
 <ab733346-9518-ed68-492d-e52929586293@deltatee.com>
 <20180921130010.GE224714@bhelgaas-glaptop.roam.corp.google.com>
 <a7e2b2cb-ea35-0a97-498b-1f5753e406aa@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a7e2b2cb-ea35-0a97-498b-1f5753e406aa@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 21, 2018 at 09:37:33AM -0600, Logan Gunthorpe wrote:
> On 2018-09-21 7:00 AM, Bjorn Helgaas wrote:
> > On Thu, Sep 20, 2018 at 04:47:49PM -0600, Logan Gunthorpe wrote:
> >> On 2018-09-20 4:38 PM, Bjorn Helgaas wrote:
> >>>> +#define pr_fmt(fmt) "pci-p2pdma: " fmt
> >>>
> >>> Is pr_fmt() actually used anywhere?
> >>
> >> It's used in a Patch 4 to print errors in the configfs helpers.
> > 
> > Ideally pr_fmt() would be added in the same patch that uses it, but
> > obviously pretty trivial.
> 
> Hmm, well Christoph asked me to do it this way. ;)

Sorry.  I somehow was under the impression we already had a printk
in the earlier patch, but it looks like I was confused.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
