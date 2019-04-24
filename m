Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id B14F821217953
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 02:07:18 -0700 (PDT)
Subject: Re: [PATCH] arm64: configurable sparsemem section size
References: <20190423203843.2898-1-pasha.tatashin@soleen.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <7f7499bd-8d48-945b-6d69-60685a02c8da@arm.com>
Date: Wed, 24 Apr 2019 14:37:11 +0530
MIME-Version: 1.0
In-Reply-To: <20190423203843.2898-1-pasha.tatashin@soleen.com>
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>, jmorris@namei.org, sashal@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, akpm@linux-foundation.org, mhocko@suse.com, dave.hansen@linux.intel.com, dan.j.williams@intel.com, keith.busch@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, zwisler@kernel.org, thomas.lendacky@amd.com, ying.huang@intel.com, fengguang.wu@intel.com, bp@suse.de, bhelgaas@google.com, baiyaowei@cmss.chinamobile.com, tiwai@suse.de, jglisse@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, rppt@linux.vnet.ibm.com, ard.biesheuvel@linaro.org, andrew.murray@arm.com, james.morse@arm.com, marc.zyngier@arm.com, sboyd@kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>



On 04/24/2019 02:08 AM, Pavel Tatashin wrote:
> sparsemem section size determines the maximum size and alignment that
> is allowed to offline/online memory block. The bigger the size the less
> the clutter in /sys/devices/system/memory/*. On the other hand, however,
> there is less flexability in what granules of memory can be added and
> removed.

Is there any scenario where less than a 1GB needs to be added on arm64 ?

> 
> Recently, it was enabled in Linux to hotadd persistent memory that
> can be either real NV device, or reserved from regular System RAM
> and has identity of devdax.

devdax (even ZONE_DEVICE) support has not been enabled on arm64 yet.

> 
> The problem is that because ARM64's section size is 1G, and devdax must
> have 2M label section, the first 1G is always missed when device is
> attached, because it is not 1G aligned.

devdax has to be 2M aligned ? Does Linux enforce that right now ?

> 
> Allow, better flexibility by making section size configurable.

Unless 2M is being enforced from Linux not sure why this is necessary at
the moment.

> 
> Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> ---
>  arch/arm64/Kconfig                 | 10 ++++++++++
>  arch/arm64/include/asm/sparsemem.h |  2 +-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b5d8cf57e220..a0c5b9d13a7f 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -801,6 +801,16 @@ config ARM64_PA_BITS
>  	default 48 if ARM64_PA_BITS_48
>  	default 52 if ARM64_PA_BITS_52
>  
> +config ARM64_SECTION_SIZE_BITS
> +	int "sparsemem section size shift"
> +	range 27 30

27 and 28 do not even compile for ARM64_64_PAGES because of MAX_ORDER and
SECTION_SIZE mismatch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
