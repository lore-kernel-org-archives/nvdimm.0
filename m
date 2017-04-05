Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from linode.aoot.com (linode.aoot.com [69.164.194.13])
 by ml01.01.org (Postfix) with ESMTP id 11AB021A04830
 for <linux-nvdimm@lists.01.org>; Wed,  5 Apr 2017 08:43:40 -0700 (PDT)
From: "Steve Wise" <swise@opengridcomputing.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-5-git-send-email-logang@deltatee.com>
 <95928b70-0148-7297-8f5e-5031d996bb98@grimberg.me>
In-Reply-To: <95928b70-0148-7297-8f5e-5031d996bb98@grimberg.me>
Subject: RE: [RFC 4/8] p2pmem: Add debugfs "stats" file
Date: Wed, 5 Apr 2017 10:43:38 -0500
Message-ID: <003201d2ae23$6527ef10$2f77cd30$@opengridcomputing.com>
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
> > +	p2pmem_debugfs_root = debugfs_create_dir("p2pmem", NULL);
> > +	if (!p2pmem_debugfs_root)
> > +		pr_info("could not create debugfs entry, continuing\n");
> > +
> 
> Why continue? I think it'd be better to just fail it.
> 

Because not having debugfs support isn't fatal to using p2pmem.  So I
believe it is better to continue.  But this is trivial, IMO, so either was
is ok with me.

> Besides, this can be safely squashed into patch 1.

Yes.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
