Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 446F32118C4E3
 for <linux-nvdimm@lists.01.org>; Mon,  5 Nov 2018 19:44:50 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: fsdax memory error handling regression
Date: Tue, 6 Nov 2018 03:44:47 +0000
Message-ID: <118cae852d1dbcc582261ae364e75a7bdf3d43ed.camel@intel.com>
Content-Language: en-US
Content-ID: <9874202371C9B3498037C5CDDBEF5A75@intel.com>
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
To: "willy@infradead.org" <willy@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Willy,

I'm seeing the following warning with v4.20-rc1 and the "dax.sh" test
from the ndctl repository:

[   69.962873] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[   69.969522] EXT4-fs (pmem0): mounted filesystem with ordered data mode. Opts: dax
[   70.028571] Injecting memory failure for pfn 0x208900 at process virtual address 0x7efe87b00000
[   70.032384] Memory failure: 0x208900: Killing dax-pmd:7066 due to hardware memory corruption
[   70.034420] Memory failure: 0x208900: recovery action for dax page: Recovered
[   70.038878] WARNING: CPU: 37 PID: 7066 at fs/dax.c:464 dax_insert_entry+0x30b/0x330
[   70.040675] Modules linked in: ebtable_nat(E) ebtable_broute(E) bridge(E) stp(E) llc(E) ip6table_mangle(E) ip6table_raw(E) ip6table_security(E) iptable_mangle(E) iptable_raw(E) iptable_security(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) crct10dif_pclmul(E) crc32_pclmul(E) dax_pmem(OE) crc32c_intel(E) device_dax(OE) ghash_clmulni_intel(E) nd_pmem(OE) nd_btt(OE) serio_raw(E) nd_e820(OE) nfit(OE) libnvdimm(OE) nfit_test_iomap(OE)
[   70.049936] CPU: 37 PID: 7066 Comm: dax-pmd Tainted: G           OE     4.19.0-rc5+ #2589
[   70.051726] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
[   70.055215] RIP: 0010:dax_insert_entry+0x30b/0x330
[   70.056769] Code: 84 b7 fe ff ff 48 81 e6 00 00 e0 ff e9 b2 fe ff ff 48 8b 3c 24 48 89 ee 31 d2 e8 10 eb ff ff 49 8b 7d 00 31 f6 e9 99 fe ff ff <0f> 0b e9 f8 fe ff ff 0f 0b e9 e2 fd ff ff e8 82 f1 f4 ff e9 9c fe
[   70.062086] RSP: 0000:ffffc900086bfb20 EFLAGS: 00010082
[   70.063726] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffea0008220000
[   70.065755] RDX: 0000000000000000 RSI: 0000000000208800 RDI: 0000000000208800
[   70.067784] RBP: ffff880327870bb0 R08: 0000000000208801 R09: 0000000000208a00
[   70.069813] R10: 0000000000208801 R11: 0000000000000001 R12: ffff880327870bb8
[   70.071837] R13: 0000000000000000 R14: 0000000004110003 R15: 0000000000000009
[   70.073867] FS:  00007efe8859d540(0000) GS:ffff88033ea80000(0000) knlGS:0000000000000000
[   70.076547] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   70.078294] CR2: 00007efe87a00000 CR3: 0000000334564003 CR4: 0000000000160ee0
[   70.080326] Call Trace:
[   70.081404]  ? dax_iomap_pfn+0xb4/0x100
[   70.082770]  dax_iomap_pte_fault+0x648/0xd60
[   70.084222]  dax_iomap_fault+0x230/0xba0
[   70.085596]  ? lock_acquire+0x9e/0x1a0
[   70.086940]  ? ext4_dax_huge_fault+0x5e/0x200
[   70.088406]  ext4_dax_huge_fault+0x78/0x200
[   70.089840]  ? up_read+0x1c/0x70
[   70.091071]  __do_fault+0x1f/0x136
[   70.092344]  __handle_mm_fault+0xd2b/0x11c0
[   70.093790]  handle_mm_fault+0x198/0x3a0
[   70.095166]  __do_page_fault+0x279/0x510
[   70.096546]  do_page_fault+0x32/0x200
[   70.097884]  ? async_page_fault+0x8/0x30
[   70.099256]  async_page_fault+0x1e/0x30

I tried to get this test going on -next before the merge window, but
-next was not bootable for me. Bisection points to:

    9f32d221301c dax: Convert dax_lock_mapping_entry to XArray

At first glance I think we need the old "always retry if we slept"
behavior. Otherwise this failure seems similar to the issue fixed by
Ross' change to always retry on any potential collision:

    b1f382178d15 ext4: close race between direct IO and ext4_break_layouts()

I'll take a closer look tomorrow to see if that guess is plausible.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
