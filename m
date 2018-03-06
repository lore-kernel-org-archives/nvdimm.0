Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DBE5922283504
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 08:49:04 -0800 (PST)
References: <20180306045647.7784-1-oohall@gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <32ddc675-f12f-1a75-2dee-7edffc60d9c7@deltatee.com>
Date: Tue, 6 Mar 2018 09:55:13 -0700
MIME-Version: 1.0
In-Reply-To: <20180306045647.7784-1-oohall@gmail.com>
Content-Language: en-US
Subject: Re: [PATCH] kernel/memremap: Remove stale devres_free() call
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Oliver O'Halloran <oohall@gmail.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 05/03/18 09:56 PM, Oliver O'Halloran wrote:
> devm_memremap_pages() was re-worked in e8d513483300 to take a caller
> allocated struct dev_pagemap as a function parameter. A call to
> devres_free() was left in the error cleanup path which results in
> a kernel panic if the remap fails for some reason. Remove it
> to fix the panic and let devm_memremap_pages() fail gracefully.
> 
> Fixes: e8d513483300 ("memremap: change devm_memremap_pages interface to use struct dev_pagemap")
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

> ---
> Both in-tree users of devm_memremap_pages() embed dev_pagemap into other
> structures so this shouldn't cause any leaks. Logan's p2p series does
> add one usage that assumes pgmap will be freed on error so that'll
> need fixing.

Yup, nice catch! I'll fix that for the next series.

Thanks,

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
