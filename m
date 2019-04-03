Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DA9C211EC0FC
 for <linux-nvdimm@lists.01.org>; Wed,  3 Apr 2019 05:29:40 -0700 (PDT)
Date: Wed, 03 Apr 2019 12:29:39 +0000
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2] mm: Fix modifying of page protection by
 insert_pfn_pmd()
In-Reply-To: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
References: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
Message-Id: <20190403122939.C4187214AF@mail.kernel.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Sasha Levin <sashal@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, dan.j.williams@intel.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.0.5, v4.19.32, v4.14.109, v4.9.166, v4.4.177, v3.18.137.

v5.0.5: Build OK!
v4.19.32: Build OK!
v4.14.109: Failed to apply! Possible dependencies:
    b4e98d9ac775 ("mm: account pud page tables")
    c4812909f5d5 ("mm: introduce wrappers to access mm->nr_ptes")

v4.9.166: Failed to apply! Possible dependencies:
    166f61b9435a ("mm: codgin-style fixes")
    505a60e22560 ("asm-generic: introduce 5level-fixup.h")
    5c6a84a3f455 ("mm/kasan: Switch to using __pa_symbol and lm_alias")
    82b0f8c39a38 ("mm: join struct fault_env and vm_fault")
    953c66c2b22a ("mm: THP page cache support for ppc64")
    b279ddc33824 ("mm: clarify mm_struct.mm_{users,count} documentation")
    b4e98d9ac775 ("mm: account pud page tables")
    c2febafc6773 ("mm: convert generic code to 5-level paging")
    c4812909f5d5 ("mm: introduce wrappers to access mm->nr_ptes")

v4.4.177: Failed to apply! Possible dependencies:
    01871e59af5c ("mm, dax: fix livelock, allow dax pmd mappings to become writeable")
    01c8f1c44b83 ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    1bdb2d4ee05f ("ARM: split off core mapping logic from create_mapping")
    34c0fd540e79 ("mm, dax, pmem: introduce pfn_t")
    3ed3a4f0ddff ("mm: cleanup *pte_alloc* interfaces")
    52db400fcd50 ("pmem, dax: clean up clear_pmem()")
    7bc3777ca19c ("sparc64: Trim page tables for 8M hugepages")
    b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    c4812909f5d5 ("mm: introduce wrappers to access mm->nr_ptes")
    c7936206b971 ("ARM: implement create_mapping_late() for EFI use")
    f25748e3c34e ("mm, dax: convert vmf_insert_pfn_pmd() to pfn_t")
    f579b2b10412 ("ARM: factor out allocation routine from __create_mapping()")

v3.18.137: Failed to apply! Possible dependencies:
    047fc8a1f9a6 ("libnvdimm, nfit, nd_blk: driver for BLK-mode access persistent memory")
    2a3746984c98 ("x86: Use new cache mode type in track_pfn_remap() and track_pfn_insert()")
    34c0fd540e79 ("mm, dax, pmem: introduce pfn_t")
    4c1eaa2344fb ("drivers/block/pmem: Fix 32-bit build warning in pmem_alloc()")
    5cad465d7fa6 ("mm: add vmf_insert_pfn_pmd()")
    61031952f4c8 ("arch, x86: pmem api for ensuring durability of persistent memory updates")
    62232e45f4a2 ("libnvdimm: control (ioctl) messages for nvdimm_bus and nvdimm devices")
    777783e0abae ("staging: android: binder: move to the "real" part of the kernel")
    957e3facd147 ("gcov: enable GCOV_PROFILE_ALL from ARCH Kconfigs")
    9e853f2313e5 ("drivers/block/pmem: Add a driver for persistent memory")
    9f53f9fa4ad1 ("libnvdimm, pmem: add libnvdimm support to the pmem driver")
    b94d5230d06e ("libnvdimm, nfit: initial libnvdimm infrastructure and NFIT support")
    cb389b9c0e00 ("dax: drop size parameter to ->direct_access()")
    dd22f551ac0a ("block: Change direct_access calling convention")
    e2e05394e4a3 ("pmem, dax: have direct_access use __pmem annotation")
    ec776ef6bbe1 ("x86/mm: Add support for the non-standard protected e820 type")
    f0dc089ce217 ("libnvdimm: enable iostat")
    f25748e3c34e ("mm, dax: convert vmf_insert_pfn_pmd() to pfn_t")


How should we proceed with this patch?

--
Thanks,
Sasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
