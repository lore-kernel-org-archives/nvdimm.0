Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FD1E2244E3E3
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 09:29:12 -0700 (PDT)
Subject: Re: [PATCH] dax: Change return type to vm_fault_t
References: <20180414155059.GA18015@jordon-HP-15-Notebook-PC>
 <CAPcyv4g+Gdc2tJ1qrM5Xn9vtARw-ZqFXaMbiaBKJJsYDtSNBig@mail.gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e20daa13-b756-8e8e-c98c-22030fb0a5f8@infradead.org>
Date: Mon, 16 Apr 2018 09:29:09 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g+Gdc2tJ1qrM5Xn9vtARw-ZqFXaMbiaBKJJsYDtSNBig@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Souptick Joarder <jrdr.linux@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/16/2018 09:14 AM, Dan Williams wrote:
> On Sat, Apr 14, 2018 at 8:50 AM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>> Use new return type vm_fault_t for fault and
>> huge_fault handler.
>>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>> Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
>> ---
>>  drivers/dax/device.c | 26 +++++++++++---------------
>>  1 file changed, 11 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>> index 2137dbc..a122701 100644
>> --- a/drivers/dax/device.c
>> +++ b/drivers/dax/device.c
>> @@ -243,11 +243,11 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
>>         return -1;
>>  }
>>
>> -static int __dev_dax_pte_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
>> +static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
>> +                               struct vm_fault *vmf)
>>  {
>>         struct device *dev = &dev_dax->dev;
>>         struct dax_region *dax_region;
>> -       int rc = VM_FAULT_SIGBUS;
>>         phys_addr_t phys;
>>         pfn_t pfn;
>>         unsigned int fault_size = PAGE_SIZE;
>> @@ -274,17 +274,11 @@ static int __dev_dax_pte_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
>>
>>         pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
>>
>> -       rc = vm_insert_mixed(vmf->vma, vmf->address, pfn);
>> -
>> -       if (rc == -ENOMEM)
>> -               return VM_FAULT_OOM;
>> -       if (rc < 0 && rc != -EBUSY)
>> -               return VM_FAULT_SIGBUS;
>> -
>> -       return VM_FAULT_NOPAGE;
>> +       return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
> 
> Ugh, so this change to vmf_insert_mixed() went upstream without fixing
> the users? This changelog is now misleading as it does not mention
> that is now an urgent standalone fix. On first read I assumed this was
> part of a wider effort for 4.18.
> 
> Grumble, we'll get this applied with a 'Fixes: 1c8f422059ae ("mm:
> change return type to vm_fault_t")' tag.
> 

Thanks for that explanation. The patch description is missing any kind
of "why" (justification).


-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
