Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXdNn5_gf+fFcV+HS0Wq1RikKYP0+Mn7wv1tqN0vtQqKQ@mail.gmail.com>
References: <20150923043737.36490.70547.stgit@dwillia2-desk3.jf.intel.com>
	<20150923044216.36490.51220.stgit@dwillia2-desk3.jf.intel.com>
	<CAMuHMdXdNn5_gf+fFcV+HS0Wq1RikKYP0+Mn7wv1tqN0vtQqKQ@mail.gmail.com>
Date: Wed, 23 Sep 2015 09:59:45 -0700
Message-ID: <CAPcyv4ivFeGfuvykhU9ZQKL0k2N0GYvLPfOBKpcfZnw2ORb3Eg@mail.gmail.com>
Subject: Re: [PATCH 12/15] mm, dax, gpu: convert vm_insert_mixed to __pfn_t,
 introduce _PAGE_DEVMAP
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, David Airlie <airlied@linux.ie>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 23, 2015 at 6:47 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Dan,
>
> On Wed, Sep 23, 2015 at 6:42 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> Convert the raw unsigned long 'pfn' argument to __pfn_t for the purpose of
>> evaluating the PFN_MAP and PFN_DEV flags.  When both are set the it
>
> s/the it/it/

yes.

>> triggers _PAGE_DEVMAP to be set in the resulting pte.  This flag will
>> later be used in the get_user_pages() path to pin the page mapping,
>> dynamically allocated by devm_memremap_pages(), until all the resulting
>> pages are released.
>>
>> There are no functional changes to the gpu drivers as a result of this
>> conversion.
>>
>> This uncovered several architectures with no local definition for
>> pfn_pte(), in response __pfn_t_pte() is only defined when an arch
>> opts-in by "#define pfn_pte pfn_pte".
>>
>> Cc: Dave Hansen <dave@sr71.net>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Airlie <airlied@linux.ie>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
>> diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
>> index ef209169579a..930a42f6db44 100644
>> --- a/arch/m68k/include/asm/page_no.h
>> +++ b/arch/m68k/include/asm/page_no.h
>> @@ -34,6 +34,7 @@ extern unsigned long memory_end;
>>
>>  #define        virt_addr_valid(kaddr)  (((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
>>                                 ((void *)(kaddr) < (void *)memory_end))
>> +#define __pfn_to_phys(pfn)     PFN_PHYS(pfn)
>
> The above change doesn't match the patch description?
>

I should have noted that this is a new compile error introduced by
this patch since include/linux/mm.h now calls __pfn_to_phys() and m68k
does not always have it defined.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
