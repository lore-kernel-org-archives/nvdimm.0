Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190818090557.17853-1-hch@lst.de> <20190818090557.17853-3-hch@lst.de>
In-Reply-To: <20190818090557.17853-3-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Aug 2019 18:44:02 -0700
Message-ID: <CAPcyv4iYytOoX3QMRmvNLbroxD0szrVLauXFjnQMvtQOH3as_w@mail.gmail.com>
Subject: Re: [PATCH 2/4] memremap: remove the dev field in struct dev_pagemap
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Bharata B Rao <bharata@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Ira Weiny <ira.weiny@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Aug 18, 2019 at 2:12 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The dev field in struct dev_pagemap is only used to print dev_name in
> two places, which are at best nice to have.  Just remove the field
> and thus the name in those two messages.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Needs the below as well.

/me goes to check if he ever merged the fix to make the unit test
stuff get built by default with COMPILE_TEST [1]. Argh! Nope, didn't
submit it for 5.3-rc1, sorry for the thrash.

You can otherwise add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

[1]: https://lore.kernel.org/lkml/156097224232.1086847.9463861924683372741.stgit@dwillia2-desk3.amr.corp.intel.com/

---

diff --git a/tools/testing/nvdimm/test/iomap.c
b/tools/testing/nvdimm/test/iomap.c
index cd040b5abffe..3f55f2f99112 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -132,7 +132,6 @@ void *__wrap_devm_memremap_pages(struct device
*dev, struct dev_pagemap *pgmap)
        if (!nfit_res)
                return devm_memremap_pages(dev, pgmap);

-       pgmap->dev = dev;
        if (!pgmap->ref) {
                if (pgmap->ops && (pgmap->ops->kill || pgmap->ops->cleanup))
                        return ERR_PTR(-EINVAL);
