Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE1EF203369DD
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 14:11:55 -0700 (PDT)
From: Colin Ian King <colin.king@canonical.com>
Subject: re: memremap: change devm_memremap_pages interface to use struct
 dev_pagemap
Message-ID: <5f52b3d3-6720-426d-6f8c-dfed997e4705@canonical.com>
Date: Sat, 30 Jun 2018 22:11:41 +0100
MIME-Version: 1.0
Content-Language: en-US
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
To: Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

static analysis with CoverityScan detected an issue with the following
commit:

commit e8d5134833006a46fcbefc5f4a84d0b62bd520e7
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Dec 29 08:54:05 2017 +0100

    memremap: change devm_memremap_pages interface to use struct dev_pagemap


247        }
248
   CID 1464431 (#1 of 1): Unchecked return value (CHECKED_RETURN)
check_return: Calling devm_add_action without checking return value (as
is done elsewhere 33 out of 35 times).

249        devm_add_action(dev, devm_memremap_pages_release, pgmap);
250
251        return __va(res->start);

devm_add_action can fail and return -ENOMEM because it calls
devres_alloc which can fail in an out of memory situation. So I believe
it may be pertinent to add a -ENOMEM check and clean up appropriately.
I'm not sure of the correct way to perform the error clean up, so I'm
sending this report instead of a fix.

Colin
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
