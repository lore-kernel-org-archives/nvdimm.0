Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8FA2521B00DC0
 for <linux-nvdimm@lists.01.org>; Fri, 10 Nov 2017 01:04:17 -0800 (PST)
Date: Fri, 10 Nov 2017 10:08:18 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] dax: associate mappings with inodes, and warn if
 dma collides with truncate
Message-ID: <20171110090818.GE4895@lst.de>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150949217152.24061.9869502311102659784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150949217152.24061.9869502311102659784.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

> +		struct {
> +			/*
> +			 * ZONE_DEVICE pages are never on an lru or handled by
> +			 * a slab allocator, this points to the hosting device
> +			 * page map.
> +			 */
> +			struct dev_pagemap *pgmap;
> +			/*
> +			 * inode association for MEMORY_DEVICE_FS_DAX page-idle
> +			 * callbacks. Note that we don't use ->mapping since
> +			 * that has hard coded page-cache assumptions in
> +			 * several paths.
> +			 */

What assumptions?  I'd much rather fix those up than having two fields
that have the same functionality.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
