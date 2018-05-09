Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C2CE207E540D
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 09:07:28 -0700 (PDT)
Date: Wed, 9 May 2018 12:07:23 -0400
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Message-ID: <20180509160722.GB4140@redhat.com>
References: <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
 <1775CC56-4651-422F-953A-18E024D3717C@raithlin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1775CC56-4651-422F-953A-18E024D3717C@raithlin.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 09, 2018 at 03:41:44PM +0000, Stephen  Bates wrote:
> Christian
> =

> >    Interesting point, give me a moment to check that. That finally make=
s =

> >    all the hardware I have standing around here valuable :)
>     =

> Yes. At the very least it provides an initial standards based path
> for P2P DMAs across RPs which is something we have discussed on this
> list in the past as being desirable.
> =

> BTW I am trying to understand how an ATS capable EP function determines
> when to perform an ATS Translation Request (ATS TR). Is there an
> upstream example of the driver for your APU that uses ATS? If so, can
> you provide a pointer to it. Do you provide some type of entry in the
> submission queues for commands going to the APU to indicate if the
> address associated with a specific command should be translated using
> ATS or not? Or do you simply enable ATS and then all addresses passed
> to your APU that miss the local cache result in a ATS TR?

On GPU ATS is always tie to a PASID. You do not do the former without
the latter (AFAICT this is not doable, maybe through some JTAG but not
in normal operation).

GPU are like CPU, so you have GPU threads that run against an address
space. This address space use a page table (very much like the CPU page
table). Now inside that page table you can point GPU virtual address
to use GPU memory or use system memory. Those system memory entry can
also be mark as ATS against a given PASID.

On some GPU you define a window of GPU virtual address that goes through
PASID & ATS (so access in that window do not go through the page table
but directly through PASID & ATS).

J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
