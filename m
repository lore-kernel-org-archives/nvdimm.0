Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from merlin.infradead.org (merlin.infradead.org
 [IPv6:2001:8b0:10b:1231::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D82AB203BBB83
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 21:43:49 -0700 (PDT)
Subject: Re: [External] [RFC PATCH v1 3/6] mm, zone_type: create ZONE_NVM and
 fill into GFP_ZONE_TABLE
References: <1525746628-114136-1-git-send-email-yehs1@lenovo.com>
 <1525746628-114136-4-git-send-email-yehs1@lenovo.com>
 <HK2PR03MB1684653383FFEDAE9B41A548929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ce3a6f37-3b13-0c35-6895-35156c7a290c@infradead.org>
Date: Mon, 7 May 2018 21:43:30 -0700
MIME-Version: 1.0
In-Reply-To: <HK2PR03MB1684653383FFEDAE9B41A548929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
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
To: Huaisheng HS1 Ye <yehs1@lenovo.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "mhocko@suse.com" <mhocko@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ocean HY1 He <hehy1@lenovo.com>, "penguin-kernel@I-love.SAKURA.ne.jp" <penguin-kernel@I-love.SAKURA.ne.jp>, NingTing Cheng <chengnt@lenovo.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "pasha.tatashin@oracle.com" <pasha.tatashin@oracle.com>, "willy@infradead.org" <willy@infradead.org>, "alexander.levin@verizon.com" <alexander.levin@verizon.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "colyli@suse.de" <colyli@suse.de>, "mgorman@techsingularity.net" <mgorman@techsingularity.net>, "vbabka@suse.cz" <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On 05/07/2018 07:33 PM, Huaisheng HS1 Ye wrote:
> diff --git a/mm/Kconfig b/mm/Kconfig
> index c782e8f..5fe1f63 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -687,6 +687,22 @@ config ZONE_DEVICE
>  
> +config ZONE_NVM
> +	bool "Manage NVDIMM (pmem) by memory management (EXPERIMENTAL)"
> +	depends on NUMA && X86_64

Hi,
I'm curious why this depends on NUMA. Couldn't it be useful in non-NUMA
(i.e., UMA) configs?

Thanks.

> +	depends on HAVE_MEMBLOCK_NODE_MAP
> +	depends on HAVE_MEMBLOCK
> +	depends on !IA32_EMULATION
> +	default n
> +
> +	help
> +	  This option allows you to use memory management subsystem to manage
> +	  NVDIMM (pmem). With it mm can arrange NVDIMMs into real physical zones
> +	  like NORMAL and DMA32. That means buddy system and swap can be used
> +	  directly to NVDIMM zone. This feature is beneficial to recover
> +	  dirty pages from power fail or system crash by storing write cache
> +	  to NVDIMM zone.



-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
