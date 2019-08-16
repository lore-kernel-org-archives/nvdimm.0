Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 16 Aug 2019 16:18:06 +0530
From: Bharata B Rao <bharata@linux.ibm.com>
Subject: Re: add a not device managed memremap_pages v2
Reply-To: bharata@linux.ibm.com
References: <20190816065434.2129-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816065434.2129-1-hch@lst.de>
Message-Id: <20190816104806.GC8784@in.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 16, 2019 at 08:54:30AM +0200, Christoph Hellwig wrote:
> Hi Dan and Jason,
> 
> Bharata has been working on secure page management for kvmppc guests,
> and one I thing I noticed is that he had to fake up a struct device
> just so that it could be passed to the devm_memremap_pages
> instrastructure for device private memory.
> 
> This series adds non-device managed versions of the
> devm_request_free_mem_region and devm_memremap_pages functions for
> his use case.

Tested this series with my patches that add secure page management
for kvmppc guests. These patches along with migrate_vma-cleanup
series are good-to-have to support secure guests on ultravisor enabled
POWER platforms.

Regards,
Bharata.
