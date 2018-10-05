Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E2D2210F93C3
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 00:07:22 -0700 (PDT)
Date: Fri, 5 Oct 2018 09:07:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v9 13/13] nvmet: Optionally use PCI P2P memory
Message-ID: <20181005070720.GA23725@lst.de>
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181004212747.6301-14-logang@deltatee.com>
 <a3af4bda-0b73-c964-c7d6-5d59f0710768@grimberg.me>
 <2bcc0927-83ab-1bf2-d584-aebd5274cefa@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2bcc0927-83ab-1bf2-d584-aebd5274cefa@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 04, 2018 at 04:29:19PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2018-10-04 4:20 p.m., Sagi Grimberg wrote:
> >> +static inline struct device *nvmet_ns_dev(struct nvmet_ns *ns)
> >> +{
> >> +	return disk_to_dev(ns->bdev->bd_disk);
> >> +}
> > 
> > This needs to handle non bdev namespaces.
> 
> As it's coded now the helper never gets called unless ns->bdev is not
> null. But in general, yes you are right, we should probably return NULL
> if ns->bdev is NULL.

I'd rather skip that for now.

> > index ef286b72d958..3d12f5f4568d 100644
> > --- a/drivers/nvme/target/fc.c
> > +++ b/drivers/nvme/target/fc.c
> > @@ -2280,6 +2280,7 @@ nvmet_fc_handle_fcp_rqst(struct nvmet_fc_tgtport 
> > *tgtport,
> >          fod->req.cmd = &fod->cmdiubuf.sqe;
> >          fod->req.rsp = &fod->rspiubuf.cqe;
> >          fod->req.port = tgtport->pe->port;
> > +       fod->req.p2p_client = tgtport->dev;
> > 
> >          /* clear any response payload */
> >          memset(&fod->rspiubuf, 0, sizeof(fod->rspiubuf));
> > --
> 
> Sure, I guess that makes sense. I've never tried it with fc hardware but
> I assume there's no reason it wouldn't work.
> 
> I'll queue these changes up for a v10.

And I'd wait until someone has actually tested this case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
