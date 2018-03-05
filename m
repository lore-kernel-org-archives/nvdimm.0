Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B4C5F22546BA7
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 14:22:09 -0800 (PST)
Date: Mon, 5 Mar 2018 16:28:21 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v2 04/10] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Message-ID: <20180305222821.GA33706@bhelgaas-glaptop.roam.corp.google.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-5-logang@deltatee.com>
 <20180301180257.GH13722@bhelgaas-glaptop.roam.corp.google.com>
 <bab9fb8b-1449-4b87-94de-7da26a279331@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bab9fb8b-1449-4b87-94de-7da26a279331@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 12:13:10PM -0700, Logan Gunthorpe wrote:
> 
> 
> On 01/03/18 11:02 AM, Bjorn Helgaas wrote:
> > >   void pci_enable_acs(struct pci_dev *dev)
> > >   {
> > > +	if (pci_p2pdma_disable_acs(dev))
> > > +		return;
> > 
> > This doesn't read naturally to me.  I do see that when
> > CONFIG_PCI_P2PDMA is not set, pci_p2pdma_disable_acs() does nothing
> > and returns 0, so we'll go ahead and try to enable ACS as before.
> > 
> > But I think it would be clearer to have an #ifdef CONFIG_PCI_P2PDMA
> > right here so it's more obvious that we only disable ACS when it's
> > selected.
> 
> I could do this... however, I wrote it this way because I've read Linus
> dislikes using #ifdef's inside function bodies and I personally agree with
> that sentiment.

I try to avoid #ifdefs too, but in this case the plain reading of the
code makes no sense (we're in a function called "enable_acs()", and
the first thing we do is call a function to "disable_acs()".

Disabling ACS is scary for all the security reasons mentioned
elsewhere, so a reader who knows what ACS does and cares about
virtualization and security *has* to go look up the definition of
pci_p2pdma_disable_acs().

If you put the #ifdef right here, then it's easier to read because we
can see that "oh, this is a special and uncommon case that I can
probably ignore".

Bjorn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
