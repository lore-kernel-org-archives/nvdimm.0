From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: Fix modifying of page protection by insert_pfn_pmd()
Date: Mon, 01 Apr 2019 10:49:18 +0000
Message-ID: <20190401104919.334CD20896@mail.kernel.org>
References: <20190330054121.27831-1-aneesh.kumar@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190330054121.27831-1-aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.0.5, v4.19.32, v4.14.109, v4.9.166, v4.4.177, v3.18.137.

v5.0.5: Build OK!
v4.19.32: Build OK!
v4.14.109: Build OK!
v4.9.166: Failed to apply! Possible dependencies:
    82b0f8c39a38 ("mm: join struct fault_env and vm_fault")
    953c66c2b22a ("mm: THP page cache support for ppc64")
    a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
    b5bc66b71310 ("mm: update mmu_gather range correctly")
    fd60775aea80 ("mm, thp: avoid unlikely branches for split_huge_pmd")

v4.4.177: Failed to apply! Possible dependencies:
    01871e59af5c ("mm, dax: fix livelock, allow dax pmd mappings to become writeable")
    01c8f1c44b83 ("mm, dax, gpu: convert vm_insert_mixed to pfn_t")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    34c0fd540e79 ("mm, dax, pmem: introduce pfn_t")
    52db400fcd50 ("pmem, dax: clean up clear_pmem()")
    6077776b5908 ("bpf: split HAVE_BPF_JIT into cBPF and eBPF variant")
    a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
    b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    b329f95d70f3 ("ARM: 8479/2: add implementation for arm-smccc")
    e37e43a497d5 ("x86/mm/64: Enable vmapped stacks (CONFIG_HAVE_ARCH_VMAP_STACK=y)")
    f25748e3c34e ("mm, dax: convert vmf_insert_pfn_pmd() to pfn_t")

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
