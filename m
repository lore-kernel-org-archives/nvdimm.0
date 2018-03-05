Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA0B02257C2D7
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 07:53:51 -0800 (PST)
Date: Mon, 5 Mar 2018 09:00:05 -0700
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage
 the CMB
Message-ID: <20180305160004.GA30975@localhost.localdomain>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
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
To: Oliver <oohall@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 05, 2018 at 12:33:29PM +1100, Oliver wrote:
> On Thu, Mar 1, 2018 at 10:40 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
> > @@ -429,10 +429,7 @@ static void __nvme_submit_cmd(struct nvme_queue *nvmeq,
> >  {
> >         u16 tail = nvmeq->sq_tail;
> 
> > -       if (nvmeq->sq_cmds_io)
> > -               memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd, sizeof(*cmd));
> > -       else
> > -               memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
> > +       memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
> 
> Hmm, how safe is replacing memcpy_toio() with regular memcpy()? On PPC
> the _toio() variant enforces alignment, does the copy with 4 byte
> stores, and has a full barrier after the copy. In comparison our
> regular memcpy() does none of those things and may use unaligned and
> vector load/stores. For normal (cacheable) memory that is perfectly
> fine, but they can cause alignment faults when targeted at MMIO
> (cache-inhibited) memory.
> 
> I think in this particular case it might be ok since we know SEQs are
> aligned to 64 byte boundaries and the copy is too small to use our
> vectorised memcpy(). I'll assume we don't need explicit ordering
> between writes of SEQs since the existing code doesn't seem to care
> unless the doorbell is being rung, so you're probably fine there too.
> That said, I still think this is a little bit sketchy and at the very
> least you should add a comment explaining what's going on when the CMB
> is being used. If someone more familiar with the NVMe driver could
> chime in I would appreciate it.

I may not be understanding the concern, but I'll give it a shot.

You're right, the start of any SQE is always 64-byte aligned, so that
should satisfy alignment requirements.

The order when writing multiple/successive SQEs in a submission queue
does matter, and this is currently serialized through the q_lock.

The order in which the bytes of a single SQE is written doesn't really
matter as long as the entire SQE is written into the CMB prior to writing
that SQ's doorbell register.

The doorbell register is written immediately after copying a command
entry into the submission queue (ignore "shadow buffer" features),
so the doorbells written to commands submitted is 1:1.

If a CMB SQE and DB order is not enforced with the memcpy, then we do
need a barrier after the SQE's memcpy and before the doorbell's writel.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
