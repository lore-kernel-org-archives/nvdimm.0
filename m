Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423161B32D9;
	Thu,  1 Aug 2024 17:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722534464; cv=none; b=botSoriuWGS/eG0h17um5zH7hs5BD8qunWWytWoatQNUxmcU2l37jFa+nSOypsKjhtVL+gy9omWOWzk5OgBZHCtPmo9GyqLr0Ouv/Z/d1cN0ny/zU/nhQgKPHke3gfHdiw3CAhpNiJOyO6GvFV8HxrNRZjayaT1RRk20L9r6tOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722534464; c=relaxed/simple;
	bh=QjDENAGyYUfkxISJ55CXGA0nu5yApMiihtQuD/xC0eQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dVHCEGnKSqipeKrSKYsQn5rzXX186nzOr3tcWJCvI/D8bDLsZt1i+D6GFSUD7ptxqzWd49ahG0x1pOxog7L6kht6TNMpY3JG/4bm2F7Ys3mCfh2l44tpNh/79dNq+UOUJFkhznfkl9UTTD0p2k8Pe1jUTDz1HhWabxpvDPXT7aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WZbvg4GP6z6K91N;
	Fri,  2 Aug 2024 01:45:03 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id DD56C140B55;
	Fri,  2 Aug 2024 01:47:39 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 1 Aug
 2024 18:47:38 +0100
Date: Thu, 1 Aug 2024 18:47:38 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Mike Rapoport <rppt@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Alexander Gordeev
	<agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Borislav
 Petkov" <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, Christophe
 Leroy <christophe.leroy@csgroup.eu>, Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand
	<david@redhat.com>, "David S. Miller" <davem@davemloft.net>, Davidlohr Bueso
	<dave@stgolabs.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, Heiko
 Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, "John Paul
 Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>, Jonathan Corbet
	<corbet@lwn.net>, Michael Ellerman <mpe@ellerman.id.au>, Palmer Dabbelt
	<palmer@dabbelt.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Rob Herring
	<robh@kernel.org>, Samuel Holland <samuel.holland@sifive.com>, Thomas
 Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner
	<tglx@linutronix.de>, "Vasily Gorbik" <gor@linux.ibm.com>, Will Deacon
	<will@kernel.org>, Zi Yan <ziy@nvidia.com>, <devicetree@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-mips@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <loongarch@lists.linux.dev>,
	<nvdimm@lists.linux.dev>, <sparclinux@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v3 06/26] MIPS: loongson64: drop
 HAVE_ARCH_NODEDATA_EXTENSION
Message-ID: <20240801184738.00003e6e@Huawei.com>
In-Reply-To: <20240801060826.559858-7-rppt@kernel.org>
References: <20240801060826.559858-1-rppt@kernel.org>
	<20240801060826.559858-7-rppt@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Thu,  1 Aug 2024 09:08:06 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Commit f8f9f21c7848 ("MIPS: Fix build error for loongson64 and
> sgi-ip27") added HAVE_ARCH_NODEDATA_EXTENSION to loongson64 to silence a
> compilation error that happened because loongson64 didn't define array
> of pg_data_t as node_data like most other architectures did.
> 
> After rename of __node_data to node_data arch_alloc_nodedata() and
> HAVE_ARCH_NODEDATA_EXTENSION can be dropped from loongson64.
> 
> Since it was the only user of HAVE_ARCH_NODEDATA_EXTENSION config option
> also remove this option from arch/mips/Kconfig.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

These are as you say now identical to the generic form, so
don't need a special version for any reason I can see.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  arch/mips/Kconfig           |  4 ----
>  arch/mips/loongson64/numa.c | 10 ----------
>  2 files changed, 14 deletions(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index ea5f3c3c31f6..43da6d596e2b 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -502,7 +502,6 @@ config MACH_LOONGSON64
>  	select USE_OF
>  	select BUILTIN_DTB
>  	select PCI_HOST_GENERIC
> -	select HAVE_ARCH_NODEDATA_EXTENSION if NUMA
>  	help
>  	  This enables the support of Loongson-2/3 family of machines.
>  
> @@ -2612,9 +2611,6 @@ config NUMA
>  config SYS_SUPPORTS_NUMA
>  	bool
>  
> -config HAVE_ARCH_NODEDATA_EXTENSION
> -	bool
> -
>  config RELOCATABLE
>  	bool "Relocatable kernel"
>  	depends on SYS_SUPPORTS_RELOCATABLE
> diff --git a/arch/mips/loongson64/numa.c b/arch/mips/loongson64/numa.c
> index b50ce28d2741..64fcfaa885b6 100644
> --- a/arch/mips/loongson64/numa.c
> +++ b/arch/mips/loongson64/numa.c
> @@ -198,13 +198,3 @@ void __init prom_init_numa_memory(void)
>  	pr_info("CP0_PageGrain: CP0 5.1 (0x%x)\n", read_c0_pagegrain());
>  	prom_meminit();
>  }
> -
> -pg_data_t * __init arch_alloc_nodedata(int nid)
> -{
> -	return memblock_alloc(sizeof(pg_data_t), SMP_CACHE_BYTES);
> -}
> -
> -void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
> -{
> -	node_data[nid] = pgdat;
> -}

