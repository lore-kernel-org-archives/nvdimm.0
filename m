Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from linode.aoot.com (linode.aoot.com [69.164.194.13])
 by ml01.01.org (Postfix) with ESMTP id 8F13A21A04830
 for <linux-nvdimm@lists.01.org>; Wed,  5 Apr 2017 08:41:47 -0700 (PDT)
From: "Steve Wise" <swise@opengridcomputing.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-3-git-send-email-logang@deltatee.com>
 <f269d9e1-8dcf-7970-382e-cb0d9a020efc@grimberg.me>
In-Reply-To: <f269d9e1-8dcf-7970-382e-cb0d9a020efc@grimberg.me>
Subject: RE: [RFC 2/8] cxgb4: setup pcie memory window 4 and create p2pmem
 region
Date: Wed, 5 Apr 2017 10:41:45 -0500
Message-ID: <003001d2ae23$21e8f7d0$65bae770$@opengridcomputing.com>
MIME-Version: 1.0
Content-Language: en-us
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
To: 'Sagi Grimberg' <sagi@grimberg.me>, 'Logan Gunthorpe' <logang@deltatee.com>, 'Christoph Hellwig' <hch@lst.de>, "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Jens Axboe' <axboe@kernel.dk>, 'Stephen Bates' <sbates@raithlin.com>, 'Max Gurtovoy' <maxg@mellanox.com>, 'Dan Williams' <dan.j.williams@intel.com>, 'Keith Busch' <keith.busch@intel.com>, 'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

> 
> 
> > +static void setup_memwin_p2pmem(struct adapter *adap)
> > +{
> > +	unsigned int mem_base = t4_read_reg(adap,
> CIM_EXTMEM2_BASE_ADDR_A);
> > +	unsigned int mem_size = t4_read_reg(adap,
> CIM_EXTMEM2_ADDR_SIZE_A);
> > +
> > +	if (!use_p2pmem)
> > +		return;
> 
> This is weird, why even call this if !use_p2pmem?
> 

The use_p2pmem was added after the original change.  I'll update as you
suggest.

> > +static int init_p2pmem(struct adapter *adapter)
> > +{
> > +	unsigned int mem_size = t4_read_reg(adapter,
> CIM_EXTMEM2_ADDR_SIZE_A);
> > +	struct p2pmem_dev *p;
> > +	int rc;
> > +	struct resource res;
> > +
> > +	if (!mem_size || !use_p2pmem)
> > +		return 0;
> 
> Again, weird...

Yup.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
