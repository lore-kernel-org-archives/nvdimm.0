Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 021722122CAB4
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 11:53:25 -0700 (PDT)
Subject: Re: [PATCH v2 0/6] mm/devm_memremap_pages: Fix page release race
References: <155727335978.292046.12068191395005445711.stgit@dwillia2-desk3.amr.corp.intel.com>
 <059859ca-3cc8-e3ff-f797-1b386931c41e@deltatee.com>
 <17ada515-f488-d153-90ef-7a5cc5fefb0f@deltatee.com>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <8a7cfa6b-6312-e8e5-9314-954496d2f6ce@oracle.com>
Date: Tue, 14 May 2019 11:51:04 -0700
MIME-Version: 1.0
In-Reply-To: <17ada515-f488-d153-90ef-7a5cc5fefb0f@deltatee.com>
Content-Language: en-US
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
To: Logan Gunthorpe <logang@deltatee.com>, Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 5/13/2019 12:22 PM, Logan Gunthorpe wrote:

>
> On 2019-05-08 11:05 a.m., Logan Gunthorpe wrote:
>>
>> On 2019-05-07 5:55 p.m., Dan Williams wrote:
>>> Changes since v1 [1]:
>>> - Fix a NULL-pointer deref crash in pci_p2pdma_release() (Logan)
>>>
>>> - Refresh the p2pdma patch headers to match the format of other p2pdma
>>>     patches (Bjorn)
>>>
>>> - Collect Ira's reviewed-by
>>>
>>> [1]: https://lore.kernel.org/lkml/155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com/
>> This series looks good to me:
>>
>> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
>>
>> However, I haven't tested it yet but I intend to later this week.
> I've tested libnvdimm-pending which includes this series on my setup and
> everything works great.

Just wondering in a difference scenario where pmem pages are exported to
a KVM guest, and then by mistake the user issues "ndctl destroy-namespace -f",
will the kernel wait indefinitely until the user figures out to kill the guest
and release the pmem pages?

thanks,
-jane
  

>
> Thanks,
>
> Logan
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
