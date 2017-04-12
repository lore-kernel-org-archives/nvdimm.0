Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D37821A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 17:25:51 -0700 (PDT)
Received: by mail-pg0-x242.google.com with SMTP id g2so2180913pge.2
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 17:25:51 -0700 (PDT)
Message-ID: <1491956745.8380.10.camel@gmail.com>
Subject: Re: [PATCH 6/9] powerpc, mm: Enable ZONE_DEVICE on powerpc
From: Balbir Singh <bsingharora@gmail.com>
Date: Wed, 12 Apr 2017 10:25:45 +1000
In-Reply-To: <20170411174233.21902-7-oohall@gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-7-oohall@gmail.com>
Mime-Version: 1.0
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
To: Oliver O'Halloran <oohall@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc: arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2017-04-12 at 03:42 +1000, Oliver O'Halloran wrote:
> Flip the switch. Running around and screaming "IT'S ALIVE" is optional,
> but recommended.
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
>  mm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 43d000e44424..d696af58f97f 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -724,7 +724,7 @@ config ZONE_DEVICE
>  	depends on MEMORY_HOTPLUG
>  	depends on MEMORY_HOTREMOVE
>  	depends on SPARSEMEM_VMEMMAP
> -	depends on X86_64 #arch_add_memory() comprehends device memory
> +	depends on (X86_64 || PPC_BOOK3S_64)  #arch_add_memory() comprehends device memory

Reviewed-by: Balbir Singh <bsingharora@gmail.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
