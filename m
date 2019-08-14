Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 14 Aug 2019 08:11:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] memremap: provide a not device managed
 memremap_pages
Message-ID: <20190814061150.GA24835@lst.de>
References: <20190811081247.22111-1-hch@lst.de> <20190811081247.22111-6-hch@lst.de> <20190812145058.GA16950@in.ibm.com> <20190812150012.GA12700@lst.de> <20190813045611.GB16950@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813045611.GB16950@in.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Bharata B Rao <bharata@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 13, 2019 at 10:26:11AM +0530, Bharata B Rao wrote:
> Yes, this patchset works non-modular and with kvm-hv as module, it
> works with devm_memremap_pages_release() and release_mem_region() in the
> cleanup path. The cleanup path will be required in the non-modular
> case too for proper recovery from failures.

Can you check if the version here:

    git://git.infradead.org/users/hch/misc.git pgmap-remove-dev

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/pgmap-remove-dev

works for you fully before I resend?

> 
> Regards,
> Bharata.
---end quoted text---
