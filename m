Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4285212963FB
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 23:36:17 -0700 (PDT)
Date: Fri, 14 Jun 2019 08:35:49 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/22] device-dax: use the dev_pagemap internal refcount
Message-ID: <20190614063549.GK7246@lst.de>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-14-hch@lst.de>
 <20190614002217.GB783@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190614002217.GB783@iweiny-DESK2.sc.intel.com>
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
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 05:22:17PM -0700, Ira Weiny wrote:
> > -	dev_dax->pgmap.ref = &dev_dax->ref;
> 
> I don't think this exactly correct.  pgmap.ref is a pointer to the dev_dax ref
> structure.  Taking it away will cause devm_memremap_pages() to fail AFAICS.
> 
> I think you need to change struct dev_pagemap as well:

Take a look at the previous patch, which adds an internal_ref field
to dev_pagemap that ->ref is set up to point to if not otherwise
initialized.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
