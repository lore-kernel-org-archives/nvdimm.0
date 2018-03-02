Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9EF032250EDC2
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 07:47:23 -0800 (PST)
Date: Fri, 2 Mar 2018 07:53:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 10/10] nvmet: Optionally use PCI P2P memory
Message-ID: <20180302155322.GA5934@infradead.org>
References: <20180228234006.21093-11-logang@deltatee.com>
 <749e3752-4349-0bdf-5243-3d510c2b26db@grimberg.me>
 <40d69074-31a8-d06a-ade9-90de7712c553@deltatee.com>
 <5649098f-b775-815b-8b9a-f34628873ff4@grimberg.me>
 <20180301184249.GI19007@ziepe.ca>
 <edaf476a-cfe9-0598-1aa5-14802a9a1477@deltatee.com>
 <20180301224540.GL19007@ziepe.ca>
 <77591162-4CCD-446E-A27C-1CDB4996ACB7@raithlin.com>
 <20180301234930.GG14799@localhost.localdomain>
 <6B6A0FD9-14F5-4AF2-A74A-DAA562C34AB9@raithlin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6B6A0FD9-14F5-4AF2-A74A-DAA562C34AB9@raithlin.com>
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
To: Stephen Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex.williamson@redhat.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 11:53:16PM +0000, Stephen  Bates wrote:
> > There's a meaningful difference between writing to an NVMe CMB vs PMR
> 
> When the PMR spec becomes public we can discuss how best to integrate it into the P2P framework (if at all) ;-).

http://nvmexpress.org/wp-content/uploads/NVM-Express-1.3-Ratified-TPs.zip
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
