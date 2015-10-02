Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <560F0854.9040300@deltatee.com>
Date: Fri, 02 Oct 2015 16:42:28 -0600
From: Logan Gunthorpe <logang@deltatee.com>
MIME-Version: 1.0
References: <20150923043737.36490.70547.stgit@dwillia2-desk3.jf.intel.com>	<20150923044227.36490.99741.stgit@dwillia2-desk3.jf.intel.com>	<20151002212137.GB30448@deltatee.com> <CAPcyv4iwJJX-rSgC0ramLrvccdzDXgnUAUMQbTMpoODo2f7kOw@mail.gmail.com>
In-Reply-To: <CAPcyv4iwJJX-rSgC0ramLrvccdzDXgnUAUMQbTMpoODo2f7kOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 14/15] mm, dax, pmem: introduce {get|put}_dev_pagemap()
 for dax-gup
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Stephen Bates <Stephen.Bates@pmcs.com>
List-ID: <linux-nvdimm@lists.01.org>



On 02/10/15 03:53 PM, Dan Williams wrote:
> Yes, this location for dev_pagemap will not work.  I've since moved it
> to a union with the lru list_head since ZONE_DEVICE pages memory
> should always have an elevated page count and never land on a slab
> allocator lru.

Oh, also, I was actually hoping to make use of the lru list_head in the 
future with ZONE_DEVICE memory. One thought I had was once we have a 
PCIe device with a BAR space, we'd then need to have a way of allocating 
these buffers when user space needs them. The simple way I was thinking 
was to just use the lru list head to store lists of used and unused 
pages -- though there are probably other solutions to this that don't 
require using struct pages.

Thanks,

Logan

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
