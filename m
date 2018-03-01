Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAAB0224511BB
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 13:04:33 -0800 (PST)
Date: Thu, 1 Mar 2018 16:10:36 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Message-ID: <20180301211036.GB6742@redhat.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <8e808448-fc01-5da0-51e7-1a6657d5a23a@deltatee.com>
 <1519936195.4592.18.camel@au1.ibm.com>
 <20180301205548.GA6742@redhat.com>
 <a512edf9-2d96-9229-fe60-e0ea60b3922b@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a512edf9-2d96-9229-fe60-e0ea60b3922b@deltatee.com>
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

On Thu, Mar 01, 2018 at 02:03:26PM -0700, Logan Gunthorpe wrote:
> =

> =

> On 01/03/18 01:55 PM, Jerome Glisse wrote:
> > Well this again a new user of struct page for device memory just for
> > one usecase. I wanted HMM to be more versatile so that it could be use
> > for this kind of thing too. I guess the message didn't go through. I
> > will take some cycles tomorrow to look into this patchset to ascertain
> > how struct page is use in this context.
> =

> We looked at it but didn't see how any of it was applicable to our needs.
> =


It seems people miss-understand HMM :( you do not have to use all of
its features. If all you care about is having struct page then just
use that for instance in your case only use those following 3 functions:

hmm_devmem_add() or hmm_devmem_add_resource() and hmm_devmem_remove()
for cleanup.

You can set the fault callback to an empty stub that always do return
VM_SIGBUS or a patch to allow NULL callback inside HMM.

You don't have to use the free callback if you don't care and if there
is something that doesn't quite match what you want HMM can always be
ajusted to address this.

The intention of HMM is to be useful for all device memory that wish
to have struct page for various reasons.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
