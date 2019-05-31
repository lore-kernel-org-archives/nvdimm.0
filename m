Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com
 [IPv6:2607:f8b0:4864:20::d44])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC7B22125584A
 for <linux-nvdimm@lists.01.org>; Fri, 31 May 2019 01:16:55 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e5so7477850iok.4
 for <linux-nvdimm@lists.01.org>; Fri, 31 May 2019 01:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <155925716254.3775979.16716824941364738117.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155925717803.3775979.14412010256191901040.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155925717803.3775979.14412010256191901040.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 31 May 2019 10:16:39 +0200
Message-ID: <CAKv+Gu8S8DaywCdEzQoZvSoE5by87+tBPPDeiVOVzr8naRstyA@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] efi: Enumerate EFI_MEMORY_SP
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 31 May 2019 at 01:13, Dan Williams <dan.j.williams@intel.com> wrote:
>
> UEFI 2.8 defines an EFI_MEMORY_SP attribute bit to augment the
> interpretation of the EFI Memory Types as "reserved for a specific
> purpose". The intent of this bit is to allow the OS to identify precious
> or scarce memory resources and optionally manage it separately from
> EfiConventionalMemory. As defined older OSes that do not know about this
> attribute are permitted to ignore it and the memory will be handled
> according to the OS default policy for the given memory type.
>
> In other words, this "specific purpose" hint is deliberately weaker than
> EfiReservedMemoryType in that the system continues to operate if the OS
> takes no action on the attribute. The risk of taking no action is
> potentially unwanted / unmovable kernel allocations from the designated
> resource that prevent the full realization of the "specific purpose".
> For example, consider a system with a high-bandwidth memory pool. Older
> kernels are permitted to boot and consume that memory as conventional
> "System-RAM" newer kernels may arrange for that memory to be set aside
> by the system administrator for a dedicated high-bandwidth memory aware
> application to consume.
>
> Specifically, this mechanism allows for the elimination of scenarios
> where platform firmware tries to game OS policy by lying about ACPI SLIT
> values, i.e. claiming that a precious memory resource has a high
> distance to trigger the OS to avoid it by default.
>
> Implement simple detection of the bit for EFI memory table dumps and
> save the kernel policy for a follow-on change.
>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/efi/efi.c |    5 +++--
>  include/linux/efi.h        |    1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 55b77c576c42..81db09485881 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -848,15 +848,16 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>         if (attr & ~(EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT |
>                      EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_RO |
>                      EFI_MEMORY_WP | EFI_MEMORY_RP | EFI_MEMORY_XP |
> -                    EFI_MEMORY_NV |
> +                    EFI_MEMORY_NV | EFI_MEMORY_SP |
>                      EFI_MEMORY_RUNTIME | EFI_MEMORY_MORE_RELIABLE))
>                 snprintf(pos, size, "|attr=0x%016llx]",
>                          (unsigned long long)attr);
>         else
>                 snprintf(pos, size,
> -                        "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> +                        "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
>                          attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
>                          attr & EFI_MEMORY_MORE_RELIABLE ? "MR" : "",
> +                        attr & EFI_MEMORY_SP      ? "SP"  : "",
>                          attr & EFI_MEMORY_NV      ? "NV"  : "",
>                          attr & EFI_MEMORY_XP      ? "XP"  : "",
>                          attr & EFI_MEMORY_RP      ? "RP"  : "",
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 6ebc2098cfe1..91368f5ce114 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -112,6 +112,7 @@ typedef     struct {
>  #define EFI_MEMORY_MORE_RELIABLE \
>                                 ((u64)0x0000000000010000ULL)    /* higher reliability */
>  #define EFI_MEMORY_RO          ((u64)0x0000000000020000ULL)    /* read-only */
> +#define EFI_MEMORY_SP          ((u64)0x0000000000040000ULL)    /* special purpose */
>  #define EFI_MEMORY_RUNTIME     ((u64)0x8000000000000000ULL)    /* range requires runtime mapping */
>  #define EFI_MEMORY_DESCRIPTOR_VERSION  1
>
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
