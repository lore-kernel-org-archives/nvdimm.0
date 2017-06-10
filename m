Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A5C5D21A143C2
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 20:33:59 -0700 (PDT)
Received: by mail-ot0-x233.google.com with SMTP id a2so47088644oth.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Jun 2017 20:35:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170610030346.GA3575@linux.intel.com>
References: <20170607204859.13104-1-ross.zwisler@linux.intel.com>
 <CAA9_cmcPsyZCB7-pd9djL0+bLamfL49SJVgkyoJ22G6tgOxyww@mail.gmail.com>
 <20170610030346.GA3575@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jun 2017 20:35:08 -0700
Message-ID: <CAPcyv4jsgUfL5Cr5a342aVNKXBrtXzpuar_1U3w3auHoT2E08A@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: add vm_insert_mixed_mkwrite()
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jonathan Corbet <corbet@lwn.net>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-mm <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, ext4 hackers <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 9, 2017 at 8:03 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Jun 09, 2017 at 02:23:51PM -0700, Dan Williams wrote:
>> On Wed, Jun 7, 2017 at 1:48 PM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > To be able to use the common 4k zero page in DAX we need to have our PTE
>> > fault path look more like our PMD fault path where a PTE entry can be
>> > marked as dirty and writeable as it is first inserted, rather than waiting
>> > for a follow-up dax_pfn_mkwrite() => finish_mkwrite_fault() call.
>> >
>> > Right now we can rely on having a dax_pfn_mkwrite() call because we can
>> > distinguish between these two cases in do_wp_page():
>> >
>> >         case 1: 4k zero page => writable DAX storage
>> >         case 2: read-only DAX storage => writeable DAX storage
>> >
>> > This distinction is made by via vm_normal_page().  vm_normal_page() returns
>> > false for the common 4k zero page, though, just as it does for DAX ptes.
>> > Instead of special casing the DAX + 4k zero page case, we will simplify our
>> > DAX PTE page fault sequence so that it matches our DAX PMD sequence, and
>> > get rid of dax_pfn_mkwrite() completely.
>> >
>> > This means that insert_pfn() needs to follow the lead of insert_pfn_pmd()
>> > and allow us to pass in a 'mkwrite' flag.  If 'mkwrite' is set insert_pfn()
>> > will do the work that was previously done by wp_page_reuse() as part of the
>> > dax_pfn_mkwrite() call path.
>> >
>> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> > ---
>> >  include/linux/mm.h |  9 +++++++--
>> >  mm/memory.c        | 21 ++++++++++++++-------
>> >  2 files changed, 21 insertions(+), 9 deletions(-)
>> >
>> > diff --git a/include/linux/mm.h b/include/linux/mm.h
>> > index b892e95..11e323a 100644
>> > --- a/include/linux/mm.h
>> > +++ b/include/linux/mm.h
>> > @@ -2294,10 +2294,15 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>> >                         unsigned long pfn);
>> >  int vm_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>> >                         unsigned long pfn, pgprot_t pgprot);
>> > -int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>> > -                       pfn_t pfn);
>> > +int vm_insert_mixed_mkwrite(struct vm_area_struct *vma, unsigned long addr,
>> > +                       pfn_t pfn, bool mkwrite);
>>
>> Are there any other planned public users of vm_insert_mixed_mkwrite()
>> that would pass false? I think not.
>>
>> >  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
>> >
>> > +static inline int vm_insert_mixed(struct vm_area_struct *vma,
>> > +               unsigned long addr, pfn_t pfn)
>> > +{
>> > +       return vm_insert_mixed_mkwrite(vma, addr, pfn, false);
>> > +}
>>
>> ...in other words instead of making the distinction of
>> vm_insert_mixed_mkwrite() and vm_insert_mixed() with extra flag
>> argument just move the distinction into mm/memory.c directly.
>>
>> So, the prototype remains the same as vm_insert_mixed()
>>
>> int vm_insert_mixed_mkwrite(struct vm_area_struct *vma, unsigned long
>> addr, pfn_t pfn);
>>
>> ...and only static insert_pfn(...) needs to change.
>
> My usage of vm_insert_mixed_mkwrite() in fs/dax.c needs the mkwrite flag to be
> there.  From dax_insert_mapping():
>
>         return vm_insert_mixed_mkwrite(vma, vaddr, pfn,
>                                 vmf->flags & FAULT_FLAG_WRITE);

Ok, I missed that.

>
> So, yes, we could do what you suggest, but then that code becomes:
>
>         if (vmf->flags & FAULT_FLAG_WRITE)
>                 vm_insert_mixed_mkwrite(vma, vaddr, pfn);
>         else
>                 vm_insert_mixed(vma, vaddr, pfn);

I think that's more readable / greppable.

>
> And vm_insert_mixed_mkwrite() and vm_insert_mixed() are redundant with only
> the insert_pfn() line differing?  This doesn't seem better...unless I'm
> missing something?
>
> The way it is, vm_insert_mixed_mkwrite() also closely matches
> insert_pfn_pmd(), which we use in the PMD case and which also takes a 'write'
> boolean which works the same as our newly added 'mkwrite'.

Hmm, but now the pfn and pmd cases are inconsistent, if you put the
flag name in the function then don't add an argument, or make it like
the pmd case and add an argument to vm_insert_mixed(). I prefer the
former.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
