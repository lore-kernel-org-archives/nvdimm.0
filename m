Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 30 Oct 2015 10:40:29 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 UPDATE-2 3/3] ACPI/APEI/EINJ: Allow memory error
 injection to NVDIMM
Message-ID: <20151030094029.GC20952@pd.tnic>
References: <1445894544-21382-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1445894544-21382-1-git-send-email-toshi.kani@hpe.com>
Sender: owner-linux-mm@kvack.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: tony.luck@intel.com, akpm@linux-foundation.org, dan.j.williams@intel.com, rjw@rjwysocki.net, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 26, 2015 at 03:22:24PM -0600, Toshi Kani wrote:
> @@ -545,10 +545,15 @@ static int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
>  	/*
>  	 * Disallow crazy address masks that give BIOS leeway to pick
>  	 * injection address almost anywhere. Insist on page or
> -	 * better granularity and that target address is normal RAM.
> +	 * better granularity and that target address is normal RAM or
> +	 * NVDIMM.
>  	 */
> -	pfn = PFN_DOWN(param1 & param2);
> -	if (!page_is_ram(pfn) || ((param2 & PAGE_MASK) != PAGE_MASK))
> +	base_addr = param1 & param2;
> +	size = (~param2) + 1;

Hmm, I missed this last time: why are the brackets there?

AFAIK, bitwise NOT has a higher precedence than addition.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
