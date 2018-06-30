Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6834B203369D3
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 16:15:20 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id k81-v6so11622540oib.4
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 16:15:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5f52b3d3-6720-426d-6f8c-dfed997e4705@canonical.com>
References: <5f52b3d3-6720-426d-6f8c-dfed997e4705@canonical.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 30 Jun 2018 16:15:17 -0700
Message-ID: <CAPcyv4iWOo2fqd3Z73Ge55nF719j2Dtt=hW7O-kxL75jTkxQoA@mail.gmail.com>
Subject: Re: memremap: change devm_memremap_pages interface to use struct
 dev_pagemap
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
To: Colin Ian King <colin.king@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 30, 2018 at 2:11 PM, Colin Ian King
<colin.king@canonical.com> wrote:
> Hi,
>
> static analysis with CoverityScan detected an issue with the following
> commit:
>
> commit e8d5134833006a46fcbefc5f4a84d0b62bd520e7
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Fri Dec 29 08:54:05 2017 +0100
>
>     memremap: change devm_memremap_pages interface to use struct dev_pagemap
>
>
> 247        }
> 248
>    CID 1464431 (#1 of 1): Unchecked return value (CHECKED_RETURN)
> check_return: Calling devm_add_action without checking return value (as
> is done elsewhere 33 out of 35 times).
>
> 249        devm_add_action(dev, devm_memremap_pages_release, pgmap);
> 250
> 251        return __va(res->start);
>
> devm_add_action can fail and return -ENOMEM because it calls
> devres_alloc which can fail in an out of memory situation. So I believe
> it may be pertinent to add a -ENOMEM check and clean up appropriately.
> I'm not sure of the correct way to perform the error clean up, so I'm
> sending this report instead of a fix.

Thanks for this. We have a fix pending here looking to go through Andrew's tree.

    https://patchwork.kernel.org/patch/10473317/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
