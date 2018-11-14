Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 30D4B2118DC50
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 01:09:48 -0800 (PST)
Date: Wed, 14 Nov 2018 04:09:47 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1826878055.33695230.1542186587142.JavaMail.zimbra@redhat.com>
In-Reply-To: <20181113105628.37449f52@gnomeregan.cam.corp.google.com>
References: <20181109203921.178363-1-brho@google.com>
 <20181109203921.178363-3-brho@google.com>
 <043a592d-6592-3053-15a0-68cc54a26deb@redhat.com>
 <286665658.33247363.1542103353780.JavaMail.zimbra@redhat.com>
 <20181113105628.37449f52@gnomeregan.cam.corp.google.com>
Subject: Re: [PATCH 2/2] kvm: Use huge pages for DAX-backed files
MIME-Version: 1.0
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
Cc: x86@kernel.org, yu c zhang <yu.c.zhang@intel.com>, kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Ross Zwisler <zwisler@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, yi z zhang <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>


> > As this patch is dependent on PageReserved patch(which is in progress),
> > just
> > wondering if we are able to test the code path for hugepage with DAX.
> 
> For testing, I used the following patch.  It's not 100%, since it
> intercepts at kvm_is_reserved_pfn(), and not PageReserved() directly.
> The only difference is with kvm_set_pfn_dirty() I think.
> 

Yes, this should be ok.

Thanks,
Pankaj 

> I also have a nasty module that would dump the EPT's and the host page
> table's mappings so I could confirm that the huge pages are being mapped
> correctly.
> 
> -----------------------
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2679e476b6c3..1b394a0752a0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -148,6 +148,10 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct
> kvm *kvm,
>  
>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>  {
> +	// XXX hack
> +	if (is_zone_device_page(pfn_to_page(pfn)))
> +		return false;
> +
>  	if (pfn_valid(pfn))
>  		return PageReserved(pfn_to_page(pfn));
>  
> -----------------------
> 
> Thanks,
> 
> Barret
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
