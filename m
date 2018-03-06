Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81A6522135D47
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 11:03:22 -0800 (PST)
Received: by mail-ot0-x241.google.com with SMTP id 79so19388250oth.11
 for <linux-nvdimm@lists.01.org>; Tue, 06 Mar 2018 11:09:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <32ddc675-f12f-1a75-2dee-7edffc60d9c7@deltatee.com>
References: <20180306045647.7784-1-oohall@gmail.com>
 <32ddc675-f12f-1a75-2dee-7edffc60d9c7@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Mar 2018 11:09:35 -0800
Message-ID: <CAPcyv4gMahR82SOUBKd5sNHexFq0y6iwWkKfjjv-S+Osw8+2BA@mail.gmail.com>
Subject: Re: [PATCH] kernel/memremap: Remove stale devres_free() call
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 6, 2018 at 8:55 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
> On 05/03/18 09:56 PM, Oliver O'Halloran wrote:
>>
>> devm_memremap_pages() was re-worked in e8d513483300 to take a caller
>> allocated struct dev_pagemap as a function parameter. A call to
>> devres_free() was left in the error cleanup path which results in
>> a kernel panic if the remap fails for some reason. Remove it
>> to fix the panic and let devm_memremap_pages() fail gracefully.
>>
>> Fixes: e8d513483300 ("memremap: change devm_memremap_pages interface to
>> use struct dev_pagemap")
>> Cc: Logan Gunthorpe <logang@deltatee.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>
>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
