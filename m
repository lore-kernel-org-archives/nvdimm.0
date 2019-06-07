Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 256AF21290DE1
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 12:53:59 -0700 (PDT)
Subject: Re: [PATCH v3 03/10] efi: Enumerate EFI_MEMORY_SP
References: <155993563277.3036719.17400338098057706494.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155993564854.3036719.3692507629721494555.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <f6c2d673-a202-4ad5-7055-5aaece9356e1@intel.com>
Date: Fri, 7 Jun 2019 12:53:58 -0700
MIME-Version: 1.0
In-Reply-To: <155993564854.3036719.3692507629721494555.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-nvdimm@lists.01.org, peterz@infradead.org, dave.hansen@linux.intel.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 6/7/19 12:27 PM, Dan Williams wrote:
> @@ -848,15 +848,16 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>  	if (attr & ~(EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT |
>  		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_RO |
>  		     EFI_MEMORY_WP | EFI_MEMORY_RP | EFI_MEMORY_XP |
> -		     EFI_MEMORY_NV |
> +		     EFI_MEMORY_NV | EFI_MEMORY_SP |
>  		     EFI_MEMORY_RUNTIME | EFI_MEMORY_MORE_RELIABLE))
>  		snprintf(pos, size, "|attr=0x%016llx]",
>  			 (unsigned long long)attr);
>  	else
>  		snprintf(pos, size,
> -			 "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> +			 "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
>  			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
>  			 attr & EFI_MEMORY_MORE_RELIABLE ? "MR" : "",
> +			 attr & EFI_MEMORY_SP      ? "SP"  : "",
>  			 attr & EFI_MEMORY_NV      ? "NV"  : "",
>  			 attr & EFI_MEMORY_XP      ? "XP"  : "",
>  			 attr & EFI_MEMORY_RP      ? "RP"  : "",

Haha, I went digging in sysfs to find out where this gets dumped out.
The joke was on me because it seems to only go to dmesg.

Separate from these patches, should we have a runtime file that dumps
out the same info?  dmesg isn't always available, and hotplug could
change this too, I'd imagine.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
