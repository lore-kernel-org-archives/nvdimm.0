Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B407221B02822
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 16:56:06 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id g27so16576757oth.6
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 16:56:06 -0800 (PST)
MIME-Version: 1.0
References: <20181109203921.178363-1-brho@google.com>
 <20181114215155.259978-1-brho@google.com>
In-Reply-To: <20181114215155.259978-1-brho@google.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Nov 2018 16:55:54 -0800
Message-ID: <CAPcyv4jga=HnsfHffWoo+JjRUBf3stD4VP3B5X5xSOZb=yh+Mw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] kvm: Use huge pages for DAX-backed files
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
Cc: X86 ML <x86@kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, KVM list <kvm@vger.kernel.org>, rkrcmar@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, zwisler@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, alexander.h.duyck@linux.intel.com, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

[ add Alex who is looking into removing PageReserved for DAX pages. ]
On Wed, Nov 14, 2018 at 1:53 PM Barret Rhoden <brho@google.com> wrote:
>
> This patch series depends on dax pages not being PageReserved.  Once
> that is in place, these changes will let KVM use huge pages with
> dax-backed files.  Without the PageReserved change, KVM and DAX still
> work with these patches, simply without huge pages - which is the
> current situation.
>
> RFC/discussion thread:
> https://lore.kernel.org/lkml/20181029210716.212159-1-brho@google.com/
>
> v1 -> v2:
> https://lore.kernel.org/lkml/20181109203921.178363-1-brho@google.com/
>
> - Updated Acks/Reviewed-by
> - Minor touchups
> - Added patch to remove redundant PageReserved() check
> - Rebased onto linux-next
>
>
> Barret Rhoden (3):
>   mm: make dev_pagemap_mapping_shift() externally visible
>   kvm: Use huge pages for DAX-backed files
>   kvm: remove redundant PageReserved() check
>
>  arch/x86/kvm/mmu.c  | 33 +++++++++++++++++++++++++++++++--
>  include/linux/mm.h  |  3 +++
>  mm/memory-failure.c | 38 +++-----------------------------------
>  mm/util.c           | 34 ++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c |  8 ++------
>  5 files changed, 73 insertions(+), 43 deletions(-)
>
> --
> 2.19.1.1215.g8438c0b245-goog
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
