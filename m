Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9161622280C45
 for <linux-nvdimm@lists.01.org>; Thu, 28 Dec 2017 23:49:30 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: revamp vmem_altmap / dev_pagemap handling V3
Date: Fri, 29 Dec 2017 08:53:49 +0100
Message-Id: <20171229075406.1936-1-hch@lst.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

Hi all,

this series started with two patches from Logan that now are in the
middle of the series to kill the memremap-internal pgmap structure
and to redo the dev_memreamp_pages interface to be better suitable
for future PCI P2P uses.  I reviewed them and noticed that there
isn't really any good reason to keep struct vmem_altmap either,
and that a lot of these alternative device page map access should
be better abstracted out instead of being sprinkled all over the
mm code.  But when we got the RCU warnings in V1 I went for yet
another approach, and now struct vmem_altmap is kept for now,
but passed explicitly through the memory hotplug code instead of
having to do unprotected lookups through the radix tree.  The
end result is that only the get_user_pages path ever looks up
struct dev_pagemap, and struct vmem_altmap is now always embedded
into struct dev_pagemap, and explicitly passed where needed.

Please review carefully, this has only been tested with my legacy
e820 NVDIMM system.

Chances since V2:
 - properly pass altmap from dev_devm_memremap_pages through add_pages
   (Dan Williams)
 - small changelog updates
 - a comment type fix
 - dropped the patch to just rely on the radix_tree_insert return value
 - initialize pgmap->type
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
