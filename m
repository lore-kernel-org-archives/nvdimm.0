Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29FC421A16ECF
 for <linux-nvdimm@lists.01.org>; Tue, 13 Jun 2017 14:15:36 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id k145so68465923oih.3
 for <linux-nvdimm@lists.01.org>; Tue, 13 Jun 2017 14:16:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170613210630.GA5135@linux.intel.com>
References: <149713136649.17377.3742583729924020371.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149713137177.17377.6712234218256825718.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170613210630.GA5135@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Jun 2017 14:16:49 -0700
Message-ID: <CAPcyv4jjx3QpAMgpRx0h+8bUkcKC0DhW-3Bds0T8K1Z8kgw=xA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: improve readability of
 transparent_hugepage_enabled()
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 13, 2017 at 2:06 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Sat, Jun 10, 2017 at 02:49:31PM -0700, Dan Williams wrote:
>> Turn the macro into a static inline and rewrite the condition checks for
>> better readability in preparation for adding another condition.
>>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  include/linux/huge_mm.h |   35 ++++++++++++++++++++++++-----------
>>  1 file changed, 24 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index a3762d49ba39..c4706e2c3358 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -85,14 +85,26 @@ extern struct kobj_attribute shmem_enabled_attr;
>>
>>  extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
>>
>> -#define transparent_hugepage_enabled(__vma)                          \
>> -     ((transparent_hugepage_flags &                                  \
>> -       (1<<TRANSPARENT_HUGEPAGE_FLAG) ||                             \
>> -       (transparent_hugepage_flags &                                 \
>> -        (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&                   \
>> -        ((__vma)->vm_flags & VM_HUGEPAGE))) &&                       \
>> -      !((__vma)->vm_flags & VM_NOHUGEPAGE) &&                        \
>> -      !is_vma_temporary_stack(__vma))
>> +extern unsigned long transparent_hugepage_flags;
>> +
>> +static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
>> +{
>> +     if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
>> +             return true;
>> +
>> +     if (transparent_hugepage_flags
>> +                     & (1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
>> +             /* check vma flags */;
>> +     else
>> +             return false;
>> +
>> +     if ((vma->vm_flags & (VM_HUGEPAGE | VM_NOHUGEPAGE)) == VM_HUGEPAGE
>> +                     && !is_vma_temporary_stack(vma))
>> +             return true;
>> +
>> +     return false;
>> +}
>
> I don't think that these are equivalent.  Here is the logic from the macro,
> with whitespace added so things are more readable:
>
> #define transparent_hugepage_enabled(__vma)
> (
>         (
>           transparent_hugepage_flags & (1<<TRANSPARENT_HUGEPAGE_FLAG)
>
>           ||
>
>           (
>             transparent_hugepage_flags & (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)
>
>             &&
>
>             ((__vma)->vm_flags & VM_HUGEPAGE)
>           )
>         )
>
>          &&
>
>          !((__vma)->vm_flags & VM_NOHUGEPAGE)
>
>          &&
>
>          !is_vma_temporary_stack(__vma)

Yeah, good catch I had read the VM_NOHUGEPAGE flag as being relative
to the REQ_MADV_FLAG.

> )
>
> So, if the VM_NOHUGEPAGE flag is set or if the vma is for a temporary stack,
> we always bail.  Also, we only care about the VM_HUGEPAGE flag in the presence
> of TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG.
>
> I think this static inline is logically equivalent (untested):
>
> static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
> {
>         if ((vma->vm_flags & VM_NOHUGEPAGE) || is_vma_temporary_stack(vma))
>                 return false;
>
>         if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
>                 return true;
>
>         if ((transparent_hugepage_flags &
>                                 (1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
>                         && vma->vm_flags & VM_HUGEPAGE)
>                 return true;

We can clean this up a bit and do:

   return !!(vma->vm_flags & VM_HUGEPAGE)

...to drop the &&


>         return false;
> }
>
> The ordering of the checks is different, but we're not using && or || to
> short-circuit checks with side effects, so I think it is more readable and
> should be fine.

Agreed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
