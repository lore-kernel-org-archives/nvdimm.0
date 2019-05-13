Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D18D521260519
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 12:22:36 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
References: <155727335978.292046.12068191395005445711.stgit@dwillia2-desk3.amr.corp.intel.com>
 <059859ca-3cc8-e3ff-f797-1b386931c41e@deltatee.com>
Message-ID: <17ada515-f488-d153-90ef-7a5cc5fefb0f@deltatee.com>
Date: Mon, 13 May 2019 13:22:30 -0600
MIME-Version: 1.0
In-Reply-To: <059859ca-3cc8-e3ff-f797-1b386931c41e@deltatee.com>
Content-Language: en-CA
Subject: Re: [PATCH v2 0/6] mm/devm_memremap_pages: Fix page release race
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
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 2019-05-08 11:05 a.m., Logan Gunthorpe wrote:
> 
> 
> On 2019-05-07 5:55 p.m., Dan Williams wrote:
>> Changes since v1 [1]:
>> - Fix a NULL-pointer deref crash in pci_p2pdma_release() (Logan)
>>
>> - Refresh the p2pdma patch headers to match the format of other p2pdma
>>    patches (Bjorn)
>>
>> - Collect Ira's reviewed-by
>>
>> [1]: https://lore.kernel.org/lkml/155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com/
> 
> This series looks good to me:
> 
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> 
> However, I haven't tested it yet but I intend to later this week.

I've tested libnvdimm-pending which includes this series on my setup and
everything works great.

Thanks,

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
