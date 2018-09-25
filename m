Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
 [209.85.210.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6E942115743C
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 11:31:22 -0700 (PDT)
Received: by mail-pf1-f193.google.com with SMTP id s5-v6so4032325pfj.7
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 11:31:22 -0700 (PDT)
Message-ID: <1537900280.11137.30.camel@acm.org>
Subject: Re: [PATCH v7 02/13] PCI/P2PDMA: Add sysfs group to display p2pmem
 stats
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 25 Sep 2018 11:31:20 -0700
In-Reply-To: <9241a6af-9826-d1ff-c13b-882cb3b6a34a@deltatee.com>
References: <20180925162231.4354-1-logang@deltatee.com>
 <20180925162231.4354-3-logang@deltatee.com>
 <1537896555.11137.22.camel@acm.org>
 <9241a6af-9826-d1ff-c13b-882cb3b6a34a@deltatee.com>
Mime-Version: 1.0
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-09-25 at 12:15 -0600, Logan Gunthorpe wrote:
> On 2018-09-25 11:29 a.m., Bart Van Assche wrote:
> > On Tue, 2018-09-25 at 10:22 -0600, Logan Gunthorpe wrote:
> > > @@ -83,9 +132,14 @@ static int pci_p2pdma_setup(struct pci_dev *pdev)
> > >  
> > >  	pdev->p2pdma = p2p;
> > >  
> > > +	error = sysfs_create_group(&pdev->dev.kobj, &p2pmem_group);
> > > +	if (error)
> > > +		goto out_pool_destroy;
> > > +
> > >  	return 0;
> > >  
> > >  out_pool_destroy:
> > > +	pdev->p2pdma = NULL;
> > >  	gen_pool_destroy(p2p->pool);
> > >  out:
> > >  	devm_kfree(&pdev->dev, p2p);
> > 
> > This doesn't look right to me. Shouldn't devm_remove_action() be called instead
> > of devm_kfree() if sysfs_create_group() fails?
> 
> That makes no sense to me. We are reversing a devm_kzalloc() not a
> custom action....

In case what I wrote was not clear: both devm_kzalloc() and
devm_add_action_or_reset() have to be reversed if sysfs_create_group() fails.
devm_add_action_or_reset() calls devres_add(). The latter function adds an
element to the dev->devres_head list. So I think that only calling devm_kfree()
if sysfs_create_group() fails will lead to corruption of the dev->devres_head
list.

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
