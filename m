Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5921F0E29
	for <nvdimm@lists.linux.dev>; Fri, 21 Mar 2025 21:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592998; cv=none; b=RmIlKx7LMcY3XzSW7ad9eH22XUYsz6FJlwb/i+M01LPGjilCj+TQZ/9rzM6KdFJvPzZJDZgqPyspUmgU4uK6RdwalZPUY2l2TNl+hxyf/gxVaMZcHOh/Qsf0D9Iel0R9H/FwmA4Sef+3D0n0/hNhtfC6FGtriA9e10xXRGsJ1Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592998; c=relaxed/simple;
	bh=wAnKCPo4D3W8q0rl0JPHAuic/xGeAs4+4FyCaGr4K24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJVJ5+8DXbIyVVl8Uik9ga3Xea1bWDvTBKju8fbPWm/alR5E2BnEsQQ34NrScvLSzHC5crKw4HmMZcTn5lzb9Ts55nlgGvqTmb7ilHP89Kn7EnGt7FrN+zFTux/O17ThPzN5oHHkJ7l4Fi3vdecLWHdyhL0HzOJof20tPykKGZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RScLzArQ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RScLzArQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742592996; x=1774128996;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wAnKCPo4D3W8q0rl0JPHAuic/xGeAs4+4FyCaGr4K24=;
  b=RScLzArQoOzzOqRsSClyAkwrqO+p6efAARqINGoPOQTOMCSi2maIs3n1
   3Wxy5/L1/w7TWhMpYogUGvswXKyMuTCBAKgmL2l+eTK3rGnf5R957j6A5
   Zq3GR82gtJMCfqe29qeugGKI5hRRiJr5cdf8kQxZoW3RSd5fOtw08aXYo
   xWWE1gIwZuhcufSi2k/YyaRd715w0NSgpM1SNcWxGbgW1fghwgqzv54QJ
   fWf5940T+GP5MmZgosKqxW/IQoCnVjs85Os5vtI5YmDLcjSeixd6Q2oLi
   8/M1uGlntI5jxYe5UgtwrJuZHQ3V2rR64rQneKGRAJuVIvcpTe9lDUeFd
   A==;
X-CSE-ConnectionGUID: M9D2ZV9ARHOtzQYkGwkcag==
X-CSE-MsgGUID: OpRBBo6tQGak9DIl/wxqtw==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43886728"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43886728"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 14:36:34 -0700
X-CSE-ConnectionGUID: FsIVv9ghSaa2UyqxGXKtVw==
X-CSE-MsgGUID: fdo7ykeoTCefAeEtBUnaeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="154407118"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.203])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 14:36:33 -0700
Date: Fri, 21 Mar 2025 14:36:32 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Yi Zhang <yi.zhang@redhat.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [bug report] ndctl test suite daxctl-create.sh triggered RIP:
 0010:memset_orig+0x33/0xb0
Message-ID: <Z93b4PAHdVoiznig@aschofie-mobl2.lan>
References: <CAHj4cs_=H8CcFGaup0ufDQtqh3cX+CCdyGUAGbyhmGBpdaz6PQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHj4cs_=H8CcFGaup0ufDQtqh3cX+CCdyGUAGbyhmGBpdaz6PQ@mail.gmail.com>

On Thu, Mar 13, 2025 at 10:46:53AM +0800, Yi Zhang wrote:
> Hello
> 
> I found this issue during ndctl test suite with the latest linux tree,
> please help check it and let me know if you need any test/info for it,
> thanks.

Hi Yi Zhang,

I was able to reproduce a 'similar' failure on both linux-next* and 6.14-rc7
with ndctl v80 by forcing the 'too small..' after alignment failure. Not
sure that's a true test, but pretty sure it shouldn't lead to an OOPs. 

*I was curious about linux-next because it holds pending DAX changes.

The reason I had to fake the failure is because my memory_block_size()
of 128MB always got past the align check. I notice that it fails but
doesn't OOPs on the initial cxl-test module load and attempt to config
the dax region, only on the subsequent daxctl-create.sh.

I'm appending my failure notes and will check back on this when I return.
(Spring Break for the next 10 days :))

Also, just as I went to write this up, I see this on the list and it
sounds related:
https://lore.kernel.org/linux-cxl/20250321180731.568460-1-gourry@gourry.net

> 
snip
> 
> [10965.520762] kmem dax3.0: mapping0: 0x3ff010000000-0x3ff02fffffff
> too small after alignment
> [10965.529291] kmem dax3.0: rejecting DAX region without any memory
> after alignment
> [10965.536704] kmem dax3.0: probe with driver kmem failed with error -22

My happy alignment with block size 128MB.

[ ] kmem dax0.0: ALISON mapping0: 0x3ff010000000-0x3ff02fffffff Good after alignment
[ ] kmem dax0.0: ALISON memory block size bytes:0x8000000
[ ] kmem dax0.0: ALISON fake failure here
[ ] kmem dax0.0: rejecting DAX region without any memory after alignment
[ ] kmem dax0.0: probe with driver kmem failed with error -22

Appending the stack trace, that is different from yours.

[  100.061790] BUG: unable to handle page fault for address: ffffeaffc0400034
[  100.063933] #PF: supervisor write access in kernel mode
[  100.065654] #PF: error_code(0x0002) - not-present page
[  100.067357] PGD 0 P4D 0 
[  100.068485] Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
[  100.070156] CPU: 2 UID: 0 PID: 1225 Comm: daxctl Tainted: G           O       6.14.0-rc7+ #3
[  100.072602] Tainted: [O]=OOT_MODULE
[  100.073999] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  100.076031] RIP: 0010:__init_zone_device_page+0x16/0xb0
[  100.077245] Code: 83 eb bf cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 48 c1 e2 38 48 89 f0 55 48 c1 e1 3a 48 be 00 00 00 00 00 00 00 03 <c7> 47 34 01 00 00 00 48 21 f2 c7 47 30 ff ff ff ff 48 09 ca 48 89
[  100.080886] RSP: 0018:ffffc90002afbab0 EFLAGS: 00010246
[  100.082146] RAX: 00000003ff010000 RBX: ffffeaffc0400000 RCX: 0000000000000000
[  100.083683] RDX: 0300000000000000 RSI: 0300000000000000 RDI: ffffeaffc0400000
[  100.085198] RBP: ffffc90002afbb10 R08: ffff888033f7ee28 R09: ffff88807fe4ac40
[  100.086741] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  100.087843] R13: ffff888033f7ee28 R14: 00000003ff030000 R15: 00000003ff010000
[  100.088946] FS:  00007f46a8a147c0(0000) GS:ffff88807d900000(0000) knlGS:0000000000000000
[  100.090117] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  100.091079] CR2: ffffeaffc0400034 CR3: 000000005041a002 CR4: 0000000000370ef0
[  100.092173] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  100.093251] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  100.094328] Call Trace:
[  100.094937]  <TASK>
[  100.095465]  ? show_regs+0x5f/0x70
[  100.095987]  ? __die+0x1f/0x70
[  100.096469]  ? page_fault_oops+0x14b/0x440
[  100.097036]  ? __init_zone_device_page+0x16/0xb0
[  100.097680]  ? search_exception_tables+0x5b/0x60
[  100.098271]  ? fixup_exception+0x22/0x300
[  100.098886]  ? kernelmode_fixup_or_oops.constprop.0+0x40/0x50
[  100.099593]  ? __bad_area_nosemaphore+0x15e/0x240
[  100.100193]  ? bad_area_nosemaphore+0x11/0x20
[  100.100825]  ? do_kern_addr_fault+0x7a/0x90
[  100.101376]  ? exc_page_fault+0x123/0x230
[  100.101922]  ? asm_exc_page_fault+0x27/0x30
[  100.102474]  ? __init_zone_device_page+0x16/0xb0
[  100.103065]  ? memmap_init_zone_device+0xc1/0x1b0
[  100.103706]  memremap_pages+0x366/0x7c0
[  100.104222]  devm_memremap_pages+0x1d/0x70
[  100.104803]  __wrap_devm_memremap_pages+0xf5/0x190 [nfit_test_iomap]
[  100.105511]  dev_dax_probe+0x1cc/0x380 [device_dax]
[  100.106111]  dax_bus_probe+0x6a/0xa0
[  100.106671]  really_probe+0xd7/0x390
[  100.107165]  __driver_probe_device+0xc4/0x150
[  100.107765]  driver_probe_device+0x1f/0x90
[  100.108293]  __driver_attach+0xd8/0x1d0
[  100.108859]  ? __pfx___driver_attach+0x10/0x10
[  100.109413]  bus_for_each_dev+0x65/0xb0
[  100.109931]  driver_attach+0x19/0x20
[  100.110415]  do_id_store+0xb9/0x200
[  100.110896]  ? check_preemption_disabled+0xb0/0xe0
[  100.111466]  new_id_store+0xe/0x20
[  100.111939]  drv_attr_store+0x1c/0x40
[  100.112423]  sysfs_kf_write+0x44/0x60
[  100.112913]  kernfs_fop_write_iter+0x13a/0x1f0
[  100.113452]  vfs_write+0x25c/0x500
[  100.113921]  ksys_write+0x5c/0xd0
[  100.114371]  __x64_sys_write+0x14/0x20
[  100.114859]  x64_sys_call+0x1f0d/0x1f80
[  100.115331]  do_syscall_64+0x64/0x140
[  100.115819]  entry_SYSCALL_64_after_hwframe+0x71/0x79
[  100.116374] RIP: 0033:0x7f46a8901c37
[  100.116830] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[  100.118617] RSP: 002b:00007ffc4b4da068 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  100.119370] RAX: ffffffffffffffda RBX: 00007ffc4b4da5f8 RCX: 00007f46a8901c37
[  100.120094] RDX: 0000000000000007 RSI: 0000000015c1b9d6 RDI: 0000000000000004
[  100.120894] RBP: 00007ffc4b4da0a0 R08: 0000000015c1b920 R09: 0000000000000073
[  100.121629] R10: 00007f46a8807140 R11: 0000000000000246 R12: 0000000000000000
[  100.122340] R13: 00007ffc4b4da630 R14: 0000000000414da0 R15: 00007f46a8b2b000
[  100.123057]  </TASK>
[  100.123404] Modules linked in: cxl_test(O) cxl_mem(O) cxl_pmem(O) cxl_acpi(O) cxl_port(O) cxl_mock(O) device_dax(O) kmem nd_pmem(O) nd_btt(O) dax_pmem(O) dax_cxl nd_e820(O) nfit(O) cxl_mock_mem(O) libnvdimm(O) nfit_test_iomap(O) cxl_core(O) [last unloaded: cxl_mock(O)]
[  100.125586] CR2: ffffeaffc0400034
[  100.126051] ---[ end trace 0000000000000000 ]---
[  100.126647] RIP: 0010:__init_zone_device_page+0x16/0xb0
[  100.127240] Code: 83 eb bf cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 48 c1 e2 38 48 89 f0 55 48 c1 e1 3a 48 be 00 00 00 00 00 00 00 03 <c7> 47 34 01 00 00 00 48 21 f2 c7 47 30 ff ff ff ff 48 09 ca 48 89
[  100.129112] RSP: 0018:ffffc90002afbab0 EFLAGS: 00010246
[  100.129760] RAX: 00000003ff010000 RBX: ffffeaffc0400000 RCX: 0000000000000000
[  100.130503] RDX: 0300000000000000 RSI: 0300000000000000 RDI: ffffeaffc0400000
[  100.131244] RBP: ffffc90002afbb10 R08: ffff888033f7ee28 R09: ffff88807fe4ac40
[  100.132027] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  100.132858] R13: ffff888033f7ee28 R14: 00000003ff030000 R15: 00000003ff010000
[  100.133659] FS:  00007f46a8a147c0(0000) GS:ffff88807d900000(0000) knlGS:0000000000000000
[  100.134478] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  100.135136] CR2: ffffeaffc0400034 CR3: 000000005041a002 CR4: 0000000000370ef0
[  100.135927] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  100.136747] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  100.137505] note: daxctl[1225] exited with irqs disabled


> [10966.419131] BUG: unable to handle page fault for address: ffffeaffc0400000
> [10966.426011] #PF: supervisor write access in kernel mode
> [10966.431234] #PF: error_code(0x0002) - not-present page
> [10966.436374] PGD 0 P4D 0
> [10966.438913] Oops: Oops: 0002 [#1] PREEMPT SMP KASAN NOPTI
> [10966.444315] CPU: 1 UID: 0 PID: 21254 Comm: daxctl Tainted: G
>    O       6.14.0-rc6+ #2
> [10966.452832] Tainted: [O]=OOT_MODULE
> [10966.456323] Hardware name: Dell Inc. PowerEdge R640/06NR82, BIOS
> 2.22.2 09/12/2024
> [10966.463891] RIP: 0010:memset_orig+0x33/0xb0
> [10966.468084] Code: b6 ce 48 b8 01 01 01 01 01 01 01 01 48 0f af c1
> 41 89 f9 41 83 e1 07 75 70 48 89 d1 48 c1 e9 06 74 35 0f 1f 44 00 00
> 48 ff c9 <48> 89 07 48 89 47 08 48 89 47 10 48 89 47 18 48 89 47 20 48
> 89 47
> [10966.486831] RSP: 0018:ffffc90005ddf3a8 EFLAGS: 00010216
> [10966.492055] RAX: ffffffffffffffff RBX: 0000000000200000 RCX: 0000000000007fff
> [10966.499189] RDX: 0000000000200000 RSI: 00000000ffffffff RDI: ffffeaffc0400000
> [10966.506320] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
> [10966.513453] R10: ffffeaffc0400000 R11: 0000000000000000 R12: 000000000007fe02
> [10966.520584] R13: 0000000000000ffc R14: 0000000000007fe0 R15: 00000003ff010000
> [10966.527717] FS:  00007f59922b97c0(0000) GS:ffff88901f400000(0000)
> knlGS:0000000000000000
> [10966.535802] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [10966.541551] CR2: ffffeaffc0400000 CR3: 000000032ed88006 CR4: 00000000007726f0
> [10966.548680] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [10966.555813] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [10966.562947] PKRU: 55555554
> [10966.565658] Call Trace:
> [10966.568112]  <TASK>
> [10966.570217]  ? show_trace_log_lvl+0x1b0/0x2f0
> [10966.574577]  ? show_trace_log_lvl+0x1b0/0x2f0
> [10966.578938]  ? sparse_add_section+0x2e6/0x740
> [10966.583297]  ? __die_body.cold+0x8/0x12
> [10966.587136]  ? page_fault_oops+0x15e/0x1e0
> [10966.591235]  ? __pfx_page_fault_oops+0x10/0x10
> [10966.595678]  ? search_bpf_extables+0x168/0x260
> [10966.600128]  ? exc_page_fault+0x10c/0x120
> [10966.604138]  ? asm_exc_page_fault+0x26/0x30
> [10966.608327]  ? memset_orig+0x33/0xb0
> [10966.611903]  sparse_add_section+0x2e6/0x740
> [10966.616091]  ? __pfx_sparse_add_section+0x10/0x10
> [10966.620797]  __add_pages+0x1ca/0x290
> [10966.624374]  add_pages+0x52/0x1c0
> [10966.627693]  pagemap_range+0x4ec/0x1070
> [10966.631534]  ? __pfx_dev_pagemap_percpu_release+0x10/0x10
> [10966.636932]  ? percpu_ref_init+0x12c/0x330
> [10966.641031]  memremap_pages+0x2eb/0x700
> [10966.644870]  ? __pfx_memremap_pages+0x10/0x10
> [10966.649232]  ? __pfx_get_nfit_res+0x10/0x10 [nfit_test_iomap]
> [10966.654984]  ? trace_irq_enable.constprop.0+0x151/0x1c0
> [10966.660210]  devm_memremap_pages+0x45/0x90
> [10966.664309]  dev_dax_probe+0x296/0xa90 [device_dax]
> [10966.669188]  ? __pfx___up_read+0x10/0x10
> [10966.673117]  dax_bus_probe+0x106/0x1e0
> [10966.676874]  ? driver_sysfs_add+0xfc/0x290
> [10966.680976]  really_probe+0x1e0/0x8a0
> [10966.684641]  __driver_probe_device+0x18c/0x370
> [10966.689086]  driver_probe_device+0x4a/0x120
> [10966.693273]  __driver_attach+0x194/0x4a0
> [10966.697199]  ? __pfx___driver_attach+0x10/0x10
> [10966.701642]  bus_for_each_dev+0x106/0x190
> [10966.705657]  ? __pfx_bus_for_each_dev+0x10/0x10
> [10966.710191]  do_id_store+0x14c/0x4c0
> [10966.713769]  ? __pfx_do_id_store+0x10/0x10
> [10966.717870]  ? __pfx_sysfs_kf_write+0x10/0x10
> [10966.722235]  kernfs_fop_write_iter+0x39f/0x5a0
> [10966.726683]  vfs_write+0x5fa/0xe90
> [10966.730087]  ? __pfx_vfs_write+0x10/0x10
> [10966.734016]  ? rcu_is_watching+0x15/0xb0
> [10966.737947]  ksys_write+0xfa/0x1d0
> [10966.741352]  ? __pfx_ksys_write+0x10/0x10
> [10966.745368]  do_syscall_64+0x92/0x180
> [10966.749032]  ? __x64_sys_openat+0x109/0x1d0
> [10966.753216]  ? __pfx___x64_sys_openat+0x10/0x10
> [10966.757749]  ? rcu_is_watching+0x15/0xb0
> [10966.761675]  ? trace_irq_enable.constprop.0+0x151/0x1c0
> [10966.766902]  ? syscall_exit_to_user_mode+0x82/0x250
> [10966.771781]  ? do_syscall_64+0x9e/0x180
> [10966.775619]  ? __x64_sys_getdents64+0x157/0x240
> [10966.780151]  ? __pfx___x64_sys_getdents64+0x10/0x10
> [10966.785030]  ? rcu_is_watching+0x15/0xb0
> [10966.788958]  ? __pfx_filldir64+0x10/0x10
> [10966.792884]  ? rcu_is_watching+0x15/0xb0
> [10966.796808]  ? trace_irq_enable.constprop.0+0x151/0x1c0
> [10966.802035]  ? syscall_exit_to_user_mode+0x82/0x250
> [10966.806913]  ? do_syscall_64+0x9e/0x180
> [10966.810752]  ? syscall_exit_to_user_mode+0x82/0x250
> [10966.815633]  ? do_syscall_64+0x9e/0x180
> [10966.819472]  ? __pfx___call_rcu_common.constprop.0+0x10/0x10
> [10966.825133]  ? rcu_is_watching+0x15/0xb0
> [10966.829055]  ? trace_irq_enable.constprop.0+0x151/0x1c0
> [10966.834282]  ? syscall_exit_to_user_mode+0x82/0x250
> [10966.839163]  ? clear_bhb_loop+0x25/0x80
> [10966.842999]  ? clear_bhb_loop+0x25/0x80
> [10966.846840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [10966.851893] RIP: 0033:0x7f5992562e14
> [10966.855489] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f
> 84 00 00 00 00 00 f3 0f 1e fa 80 3d 95 d2 0d 00 00 74 13 b8 01 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24
> 18 48
> [10966.874233] RSP: 002b:00007ffee3bc0118 EFLAGS: 00000202 ORIG_RAX:
> 0000000000000001
> [10966.881800] RAX: ffffffffffffffda RBX: 00007ffee3bc06a8 RCX: 00007f5992562e14
> [10966.888931] RDX: 0000000000000007 RSI: 00000000042fcd86 RDI: 0000000000000004
> [10966.896064] RBP: 00007ffee3bc0150 R08: 0000000000000073 R09: 00000000ffffffff
> [10966.903198] R10: 00007f59926b4370 R11: 0000000000000202 R12: 0000000000000000
> [10966.910330] R13: 00007ffee3bc06e0 R14: 00007f59926ef000 R15: 0000000000414d78
> [10966.917467]  </TASK>
> [10966.919653] Modules linked in: cxl_test(O) cxl_mem(O) cxl_pmem(O)
> cxl_acpi(O) cxl_port(O) dax_pmem(O) nd_pmem(O) device_dax(O) dax_cxl
> cxl_mock_mem(O) cxl_mock(O) cxl_core(O) einj ext4 mbcache jbd2 kmem
> rfkill sunrpc intel_rapl_msr intel_rapl_common intel_uncore_frequency
> intel_uncore_frequency_common skx_edac skx_edac_common
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_wdt
> dell_pc iTCO_vendor_support rapl ipmi_ssif dell_smbios
> platform_profile vfat intel_cstate fat dcdbas intel_uncore
> dell_wmi_descriptor wmi_bmof pcspkr mgag200 tg3 mei_me i2c_i801
> i2c_algo_bit mei i2c_smbus lpc_ich intel_pch_thermal acpi_power_meter
> ipmi_si acpi_ipmi ipmi_devintf ipmi_msghandler sg loop fuse nfnetlink
> xfs sd_mod nd_btt(O) ghash_clmulni_intel nd_e820(O) megaraid_sas ahci
> libahci libata wmi nfit(O) libnvdimm(O) nfit_test_iomap(O) dm_mirror
> dm_region_hash dm_log dm_mod
> [10966.919776] Unloaded tainted modules: cxl_port(O):23 cxl_mem(O):23
> cxl_pmem(O):23 cxl_acpi(O):23 cxl_test(O):23 dax_pmem(O):37
> device_dax(O):37 nd_pmem(O):37 nfit_test(O):39 [last unloaded:
> cxl_port(O)]
> [10967.014742] CR2: ffffeaffc0400000
> [10967.018062] ---[ end trace 0000000000000000 ]---
> [10967.080660] RIP: 0010:memset_orig+0x33/0xb0
> [10967.084863] Code: b6 ce 48 b8 01 01 01 01 01 01 01 01 48 0f af c1
> 41 89 f9 41 83 e1 07 75 70 48 89 d1 48 c1 e9 06 74 35 0f 1f 44 00 00
> 48 ff c9 <48> 89 07 48 89 47 08 48 89 47 10 48 89 47 18 48 89 47 20 48
> 89 47
> [10967.103608] RSP: 0018:ffffc90005ddf3a8 EFLAGS: 00010216
> [10967.108832] RAX: ffffffffffffffff RBX: 0000000000200000 RCX: 0000000000007fff
> [10967.115965] RDX: 0000000000200000 RSI: 00000000ffffffff RDI: ffffeaffc0400000
> [10967.123098] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
> [10967.130230] R10: ffffeaffc0400000 R11: 0000000000000000 R12: 000000000007fe02
> [10967.137362] R13: 0000000000000ffc R14: 0000000000007fe0 R15: 00000003ff010000
> [10967.144494] FS:  00007f59922b97c0(0000) GS:ffff88901f400000(0000)
> knlGS:0000000000000000
> [10967.152579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [10967.158327] CR2: ffffeaffc0400000 CR3: 000000032ed88006 CR4: 00000000007726f0
> [10967.165460] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [10967.172593] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [10967.179724] PKRU: 55555554
> [10967.182439] Kernel panic - not syncing: Fatal exception
> [10967.187682] Kernel Offset: 0x20800000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [10967.236024] pstore: backend (erst) writing error (-28)
> [10967.241171] ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> -- 
> Best Regards,
>   Yi Zhang
> 
