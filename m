Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B75521E082BF
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 14:03:50 -0800 (PST)
Date: Fri, 2 Mar 2018 17:09:51 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Message-ID: <20180302220950.GA6148@redhat.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <8e808448-fc01-5da0-51e7-1a6657d5a23a@deltatee.com>
 <1519936195.4592.18.camel@au1.ibm.com>
 <20180301205548.GA6742@redhat.com>
 <a512edf9-2d96-9229-fe60-e0ea60b3922b@deltatee.com>
 <20180301211036.GB6742@redhat.com>
 <8D3B5C26-39E0-478D-B51F-A22B3F36C4D7@raithlin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8D3B5C26-39E0-478D-B51F-A22B3F36C4D7@raithlin.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Oliver OHalloran <oliveroh@au1.ibm.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 02, 2018 at 09:38:43PM +0000, Stephen  Bates wrote:
> > It seems people miss-understand HMM :( =

> =

> Hi Jerome
> =

> Your unhappy face emoticon made me sad so I went off to (re)read up
> on HMM. Along the way I came up with a couple of things.
> =

> While hmm.txt is really nice to read it makes no mention of
> DEVICE_PRIVATE and DEVICE_PUBLIC. It also gives no indication when
> one might choose to use one over the other. Would it be possible to
> update hmm.txt to include some discussion on this? I understand
> that DEVICE_PUBLIC creates a mapping in the kernel's linear address
> space for the device memory and DEVICE_PRIVATE does not. However,
> like I said, I am not sure when you would use either one and the
> pros and cons of doing so. I actually ended up finding some useful
> information in memremap.h but I don't think it is fair to expect
> people to dig *that* deep to find this information ;-).

Yes i need to document that some more in hmm.txt, PRIVATE is for device
that have memory that do not fit regular memory expectation ie cachable
so PCIe device memory fit under that category. So if all you need is
struct page for such memory then this is a perfect fit. On top of that
you can use more HMM feature, like using this memory transparently
inside a process address space.

PUBLIC is for memory that belong to a device but still can be access by
CPU in cache coherent way (CAPI, CCIX, ...). Again if you have such
memory and just want struct page you can use that and again if you want
to use that inside a process address space HMM provide more helpers to
do so.


> A quick grep shows no drivers using the HMM API in the upstream code
> today. Is this correct? Are there any examples of out of tree drivers
> that use HMM you can point me too? As a driver developer what
> resources exist to help me write a HMM aware driver?

I am about to send RFC for nouveau, i am still working out some bugs.
I was hoping to be done today but i am still fighting with the hardware.
They are other drivers being work on with HMM. I do not know exactly
when they will be made public (i expect in coming months).

How you use HMM is under the control of the device driver, as well as
how you expose it to userspace. They use it how they want to use it.
There is no pattern or requirement imposed by HMM. All driver being work
on so far are GPU like hardware, ie big chunk of on board memory
(several giga-bytes) and they want to use that memory inside process
address space in a transparent fashion to the program and CPU.

Each have their own API expose to userspace and while they are a lot of
similarity among them, lot of details of userspace API is hardware
specific. In GPU world most of the driver are in userspace, application
do target high level API such as OpenGL, Vulkan, OpenCL or CUDA. Those
API then have a hardware specific userspace driver that talks to hardware
specific IOCTL. So this is not like network or block device.


> The (very nice) hmm.txt document is not references in the MAINTAINERS
> file? You might want to fix that when you have a moment.

I have couple small fixes/typo patches that i need to cleanup and send
i will fix the MAINTAINERS as part of those.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
