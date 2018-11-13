Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECB212118DC22
 for <linux-nvdimm@lists.01.org>; Tue, 13 Nov 2018 10:22:55 -0800 (PST)
Subject: Re: [PATCH 2/2] kvm: Use huge pages for DAX-backed files
References: <20181109203921.178363-1-brho@google.com>
 <20181109203921.178363-3-brho@google.com>
 <861c4adb-e2f0-2caf-8f6e-9f09ecb0b624@redhat.com>
 <20181113112148.6205fc56@gnomeregan.cam.corp.google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a1ab1066-ed2a-4a67-54e1-15982645cfe8@redhat.com>
Date: Tue, 13 Nov 2018 19:22:42 +0100
MIME-Version: 1.0
In-Reply-To: <20181113112148.6205fc56@gnomeregan.cam.corp.google.com>
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
To: Barret Rhoden <brho@google.com>
Cc: x86@kernel.org, yu.c.zhang@intel.com, kvm@vger.kernel.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Ross Zwisler <zwisler@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, yi.z.zhang@intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 13/11/2018 17:21, Barret Rhoden wrote:
> On 2018-11-12 at 20:31 Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Looks good.  What's the plan for removing PageReserved from DAX pages?
> 
> I hear that's going on in this thread:
> 
> https://lore.kernel.org/lkml/154145268025.30046.11742652345962594283.stgit@ahduyck-desk1.jf.intel.com/
> 
> Though it looks like it's speeding up page initialization, and not
> explicitly making the PageReserved change, yet.
> 
> Alternatively, I could change kvm_is_reserved_pfn() to single out
> zone_device pages if we don't want to wait or if there is a concern
> that it won't happen.
> 
> On a related note, there are two places in KVM where we check
> PageReserved outside of kvm_is_reserved_pfn().
> 
> For reference:
> 
> bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
> {
>         if (pfn_valid(pfn))
>                 return PageReserved(pfn_to_page(pfn));
> 
>         return true;
> }
> 
> One caller of PageReserved():
> 
> void kvm_set_pfn_dirty(kvm_pfn_t pfn)
> {
>         if (!kvm_is_reserved_pfn(pfn)) {
>                 struct page *page = pfn_to_page(pfn);
> 
>                 if (!PageReserved(page))
>                         SetPageDirty(page);
>         }
> }
> 
> In that one, the PageReserved() check looks redundant, since if the
> page was PageReserved, then it would have been kvm_is_reserved.

Make sense, and a patch to fix this is welcome.

> 
> The other is:
> 
> static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
> {
>         if (pfn_valid(pfn))
>                 return !is_zero_pfn(pfn) && PageReserved(pfn_to_page(pfn)) &&
>                         /*
>                          * Some reserved pages, such as those from NVDIMM
>                          * DAX devices, are not for MMIO, and can be mapped
>                          * with cached memory type for better performance.
>                          * However, the above check misconceives those pages
>                          * as MMIO, and results in KVM mapping them with UC
>                          * memory type, which would hurt the performance.
>                          * Therefore, we check the host memory type in addition
>                          * and only treat UC/UC-/WC pages as MMIO.
>                          */
>                         (!pat_enabled() || pat_pfn_immune_to_uc_mtrr(pfn));
> 
>         return true;
> }
> 
> Where the PAT stuff was motivated by DAX.  The PageReserved check here
> looks like a broken-out version of kvm_is_reserved_pfn(), so that we can
> make some extra checks around it.

Since this one is indeed motivated by DAX, it can be left in for now and
it will DTRT.  But when DAX is not PageReserved anymore, then this
second part of the condition can be reverted.

Paolo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
