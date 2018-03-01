Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D4D8224E693F
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 13:19:37 -0800 (PST)
Date: Thu, 1 Mar 2018 16:25:42 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Message-ID: <20180301212541.GD6742@redhat.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <8e808448-fc01-5da0-51e7-1a6657d5a23a@deltatee.com>
 <1519936195.4592.18.camel@au1.ibm.com>
 <20180301205548.GA6742@redhat.com>
 <a512edf9-2d96-9229-fe60-e0ea60b3922b@deltatee.com>
 <20180301211036.GB6742@redhat.com>
 <8ed955f8-55c9-a2bd-1d58-90bf1dcfa055@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8ed955f8-55c9-a2bd-1d58-90bf1dcfa055@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Oliver OHalloran <oliveroh@au1.ibm.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 02:15:01PM -0700, Logan Gunthorpe wrote:
> =

> =

> On 01/03/18 02:10 PM, Jerome Glisse wrote:
> > It seems people miss-understand HMM :( you do not have to use all of
> > its features. If all you care about is having struct page then just
> > use that for instance in your case only use those following 3 functions:
> > =

> > hmm_devmem_add() or hmm_devmem_add_resource() and hmm_devmem_remove()
> > for cleanup.
> =

> To what benefit over just using devm_memremap_pages()? If I'm using the h=
mm
> interface and disabling all the features, I don't see the point. We've al=
so
> cleaned up the devm_memremap_pages() interface to be more usefully generic
> in such a way that I'd hope HMM starts using it too and gets rid of the c=
ode
> duplication.
> =


The first HMM variant find a hole and do not require a resource as input
parameter. Beside that internaly for PCIE device memory devm_memremap_pages=
()
does not do the right thing last time i check it always create a linear
mapping of the range ie HMM call add_pages() while devm_memremap_pages()
call arch_add_memory()

When i upstreamed HMM, Dan didn't want me to touch devm_memremap_pages()
to match my need. I am more than happy to modify devm_memremap_pages() to
also handle HMM needs.

Note that the intention of HMM is to be a middle layer between low level
infrastructure and device driver. Idea is that such impedance layer should
make it easier down the road to change how thing are handled down below
without having to touch many device driver.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
