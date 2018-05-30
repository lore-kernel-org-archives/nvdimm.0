Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 0BEF32097DD29
 for <linux-nvdimm@lists.01.org>; Wed, 30 May 2018 10:31:45 -0700 (PDT)
Subject: Re: arch_wb_cache_pmem on ARM64
References: <alpine.LRH.2.02.1805301254340.25056@file01.intranet.prod.int.rdu2.redhat.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <92b97864-52af-88d1-f18d-c6f6764072b0@arm.com>
Date: Wed, 30 May 2018 18:31:42 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1805301254340.25056@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Mikulas Patocka <mpatocka@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 30/05/18 18:00, Mikulas Patocka wrote:
> Hi
> 
> I'd like to ask what's the purpose of dmb(osh) in the function
> arch_wb_cache_pmem in arch/arm64/mm/flush.c?
> 
> void arch_wb_cache_pmem(void *addr, size_t size)
> {
>          /* Ensure order against any prior non-cacheable writes */
>          dmb(osh);
>          __clean_dcache_area_pop(addr, size);
> }
> 
> The processor may flush the cache spontaneously, that means that all the
> flushing may actually happen before the dmb(osh) instruction - so what
> does that dmb instruction guard against?

IIRC the (very subtle) problem was to do with the odd case of a 
transparent (i.e. beyond the PoC) system cache - if data has been 
written to the pmem region via some non-cacheable alias, then the 
barrier was necessary to ensure that cache maintenance via the 
inner-shareable kernel mapping can push any data already at the PoC 
further along to the PoP.

Robin.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
