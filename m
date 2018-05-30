Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 306D92063D74D
 for <linux-nvdimm@lists.01.org>; Wed, 30 May 2018 10:00:21 -0700 (PDT)
Date: Wed, 30 May 2018 13:00:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: arch_wb_cache_pmem on ARM64
Message-ID: <alpine.LRH.2.02.1805301254340.25056@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
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
To: Robin Murphy <robin.murphy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi

I'd like to ask what's the purpose of dmb(osh) in the function 
arch_wb_cache_pmem in arch/arm64/mm/flush.c?

void arch_wb_cache_pmem(void *addr, size_t size)
{
        /* Ensure order against any prior non-cacheable writes */
        dmb(osh);
        __clean_dcache_area_pop(addr, size);
}

The processor may flush the cache spontaneously, that means that all the 
flushing may actually happen before the dmb(osh) instruction - so what 
does that dmb instruction guard against?

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
