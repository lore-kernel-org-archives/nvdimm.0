Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150428182417.35812.92834.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150428182417.35812.92834.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 28 Apr 2015 13:49:35 -0700
Message-ID: <CALCETrWq4NYqYomAVDZB6NBheLp-zA6yJXmcN244skYweAGaBg@mail.gmail.com>
Subject: Re: [PATCH v2 01/20] e820, efi: add ACPI 6.0 persistent memory types
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Boaz Harrosh <boaz@plexistor.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 11:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> ACPI 6.0 formalizes e820-type-7 and efi-type-14 as persistent memory.
> Mark it "reserved" and allow it to be claimed by a persistent memory
> device driver.
>
> This definition is in addition to the Linux kernel's existing type-12
> definition that was recently added in support of shipping platforms with
> NVDIMM support that predate ACPI 6.0 (which now classifies type-12 as
> OEM reserved).  We may choose to exploit this wealth of definitions for
> NVDIMMs to differentiate E820_PRAM (type-12) from E820_PMEM (type-7).
> One potential differentiation is that PMEM is not backed by struct page
> by default in contrast to PRAM.  For now, they are effectively treated
> as aliases by the mm.
>
> Note, /proc/iomem can be consulted for differentiating legacy
> "Persistent RAM" E820_PRAM vs standard "Persistent I/O Memory"
> E820_PMEM.
>
> Cc: Boaz Harrosh <boaz@plexistor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Andy Lutomirski <luto@amacapital.net>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/arm64/kernel/efi.c          |    1 +
>  arch/ia64/kernel/efi.c           |    4 ++++
>  arch/x86/boot/compressed/eboot.c |    4 ++++
>  arch/x86/include/uapi/asm/e820.h |    1 +
>  arch/x86/kernel/e820.c           |   26 +++++++++++++++++++++++---
>  arch/x86/platform/efi/efi.c      |    3 +++
>  include/linux/efi.h              |    3 ++-
>  7 files changed, 38 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index ab21e0d58278..9d4aa18f2a82 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -158,6 +158,7 @@ static __init int is_reserve_region(efi_memory_desc_t *md)
>         case EFI_BOOT_SERVICES_CODE:
>         case EFI_BOOT_SERVICES_DATA:
>         case EFI_CONVENTIONAL_MEMORY:
> +       case EFI_PERSISTENT_MEMORY:
>                 return 0;
>         default:
>                 break;
> diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
> index c52d7540dc05..9028bc268cd7 100644
> --- a/arch/ia64/kernel/efi.c
> +++ b/arch/ia64/kernel/efi.c
> @@ -1223,6 +1223,10 @@ efi_initialize_iomem_resources(struct resource *code_resource,
>                                 flags |= IORESOURCE_DISABLED;
>                                 break;
>
> +                       case EFI_PERSISTENT_MEMORY:
> +                               name = "persistent";
> +                               break;
> +
>                         case EFI_RESERVED_TYPE:
>                         case EFI_RUNTIME_SERVICES_CODE:
>                         case EFI_RUNTIME_SERVICES_DATA:
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index ef17683484e9..dde5bf7726f4 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -1222,6 +1222,10 @@ static efi_status_t setup_e820(struct boot_params *params,
>                         e820_type = E820_NVS;
>                         break;
>
> +               case EFI_PERSISTENT_MEMORY:
> +                       e820_type = E820_PMEM;
> +                       break;
> +
>                 default:
>                         continue;
>                 }
> diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
> index 960a8a9dc4ab..0f457e6eab18 100644
> --- a/arch/x86/include/uapi/asm/e820.h
> +++ b/arch/x86/include/uapi/asm/e820.h
> @@ -32,6 +32,7 @@
>  #define E820_ACPI      3
>  #define E820_NVS       4
>  #define E820_UNUSABLE  5
> +#define E820_PMEM      7
>
>  /*
>   * This is a non-standardized way to represent ADR or NVDIMM regions that
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 11cc7d54ec3f..d38b53a7e9b2 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -149,6 +149,7 @@ static void __init e820_print_type(u32 type)
>         case E820_UNUSABLE:
>                 printk(KERN_CONT "unusable");
>                 break;
> +       case E820_PMEM:
>         case E820_PRAM:
>                 printk(KERN_CONT "persistent (type %u)", type);
>                 break;

I'd kind of like to make it more clear what's going on here.  It
doesn't help that the spec chose poor names.

How about "NVDIMM physical aperture" for E820_PMEM and "legacy
persistent RAM" for E820_PRAM?

Otherwise this looks generaly sensible, although I don't really
understand why e820_type_to_string and e820_print_type are different.

--Andy
