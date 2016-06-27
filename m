From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/2] mm: CONFIG_ZONE_DEVICE stop depending on CONFIG_EXPERT
Date: Mon, 27 Jun 2016 09:39:31 -0400
Message-ID: <x49a8i692ek.fsf@segfault.boston.devel.redhat.com>
References: <146687645727.39261.14620086569655191314.stgit@dwillia2-desk3.amr.corp.intel.com>
	<146687646274.39261.14267596518720371009.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <146687646274.39261.14267596518720371009.stgit@dwillia2-desk3.amr.corp.intel.com>
	(Dan Williams's message of "Sat, 25 Jun 2016 10:41:02 -0700")
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

Dan Williams <dan.j.williams@intel.com> writes:

> When it was first introduced CONFIG_ZONE_DEVICE depended on disabling
> CONFIG_ZONE_DMA, a configuration choice reserved for "experts".
> However, now that the ZONE_DMA conflict has been eliminated it no longer
> makes sense to require CONFIG_EXPERT.
>
> Reported-by: Eric Sandeen <sandeen@redhat.com>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Jeff Moyer <jmoyer@redhat.com>

> ---
>  mm/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 3e2daef3c946..d109a7a0c1c4 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -673,7 +673,7 @@ config IDLE_PAGE_TRACKING
>  	  See Documentation/vm/idle_page_tracking.txt for more details.
>  
>  config ZONE_DEVICE
> -	bool "Device memory (pmem, etc...) hotplug support" if EXPERT
> +	bool "Device memory (pmem, etc...) hotplug support"
>  	depends on MEMORY_HOTPLUG
>  	depends on MEMORY_HOTREMOVE
>  	depends on SPARSEMEM_VMEMMAP

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
