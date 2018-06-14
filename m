Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9418210ED79C
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 12:37:11 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] mm: disallow mapping that conflict for
 devm_memremap_pages()
Date: Thu, 14 Jun 2018 19:37:08 +0000
Message-ID: <AT5PR8401MB11698094C482D26E172B8E41AB7D0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <152900070339.49084.2958083852988708457.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152900070339.49084.2958083852988708457.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Dave Jiang' <dave.jiang@intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Dave Jiang
> Sent: Thursday, June 14, 2018 1:25 PM
> Subject: [PATCH] mm: disallow mapping that conflict for
> devm_memremap_pages()
...
> +	conflict_pgmap = get_dev_pagemap(PHYS_PFN(align_start), NULL);
> +	if (conflict_pgmap) {
> +		dev_warn(dev, "Conflicting mapping in same section\n");
> +		put_dev_pagemap(conflict_pgmap);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	conflict_pgmap = get_dev_pagemap(PHYS_PFN(align_end), NULL);
> +	if (conflict_pgmap) {
> +		dev_warn(dev, "Conflicting mapping in same section\n");
> +		put_dev_pagemap(conflict_pgmap);
> +		return ERR_PTR(-ENOMEM);
> +	}

Unique warning messages would help narrow down the problem.

dev_WARN is one way to make them unique, if a backtrace is also appropriate.


---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
