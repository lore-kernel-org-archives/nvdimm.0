Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B687921939225
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 06:28:20 -0700 (PDT)
Received: from G9W8454.americas.hpqcorp.net (g9w8454.houston.hp.com
 [16.216.161.4])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3427.houston.hpe.com (Postfix) with ESMTPS id 13A9079
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 13:28:19 +0000 (UTC)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: panics related to nfit_test?
Message-ID: <58E793E8.8070507@hpe.com>
Date: Fri, 7 Apr 2017 09:28:08 -0400
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

I'm trying to run the ndctl tests on 4.11-rc5.  I've never run them before but I
think I correctly followed all the directions for building and installing the
tools/testing/nvdimm components as described in the ndctl README.md.  I'm
seeing two problems that may be related and I'm wondering whether this could
be build/user error or something real.

1) Running the tests was causing my system to panic when the nfit_test module
is unloaded.  I determined I don't actually have to run a test to cause the panic, just
modprobe the modules as listed in ndctl nfit_test_init(), then modprobe nfit_test,
then rmmod nfit_test.  I'm doing this on a system without NVDIMMs. I get
the same thing on a system with NVDIMMs although the other modules are already
loaded.

This is the panic I get, very reproducibly.

[53617.173340] nfit_test nfit_test.0: failed to evaluate _FIT

<The above message is from the modprobe. Is that expected? The rest is after the rmmod.>

[53683.797952] BUG: unable to handle kernel NULL pointer dereference at (null)
[53683.837521] IP: __list_del_entry_valid+0x29/0xd0
[53683.861449] PGD 105f4fb067
[53683.861449] PUD 1054889067
[53683.874551] PMD 0
[53683.887664]
[53683.903937] Oops: 0000 [#1] SMP
[53683.918657] Modules linked in: nfit_test(O-) nd_pmem(O) nd_e820(O) nd_blk(O) nd_btt(O)
dax_pmem(O) dax(O) nfit(O) libnvdimm(O) nfit_test_iomap(O) ip6t_rpfilter ipt_REJECT nf_reject_ipv4
ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security
ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp vfat fat
kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc ipmi_ssif aesni_intel
crypto_simd glue_helper cryptd sg hpilo iTCO_wdt
[53684.252765] hpwdt ipmi_si ipmi_devintf iTCO_vendor_support ioatdma i2c_i801 lpc_ich shpchp pcspkr
acpi_power_meter ipmi_msghandler dca wmi ip_tables xfs sd_mod mgag200 i2c_algo_bit drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm bnx2x tg3 mdio hpsa ptp i2c_core pps_core
libcrc32c scsi_transport_sas crc32c_intel
[53684.394684] CPU: 35 PID: 4087 Comm: rmmod Tainted: G W O 4.11.0-rc5+ #3
[53684.430295] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 10/05/2016
[53684.469368] task: ffff9cdbaca9ad00 task.stack: ffffbf3348cc8000
[53684.497175] RIP: 0010:__list_del_entry_valid+0x29/0xd0
[53684.521315] RSP: 0018:ffffbf3348ccbd90 EFLAGS: 00010007
[53684.545823] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
[53684.579642] RDX: dead000000000200 RSI: ffff9cdbaf4268a0 RDI: ffffbf334e302000
[53684.613132] RBP: ffffbf3348ccbd90 R08: 0000000000000000 R09: ffffbf334e302000
[53684.646725] R10: 0000000000000004 R11: ffff9cdbaf4268a0 R12: ffffbf3348ccbdc8
[53684.680100] R13: 0000000000000000 R14: 0000000000000000 R15: ffff9ce7a36f2400
[53684.713655] FS: 00007f1fab239740(0000) GS:ffff9ce7af040000(0000) knlGS:0000000000000000
[53684.751875] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[53684.778962] CR2: 0000000000000000 CR3: 000000106eb12000 CR4: 00000000003406e0
[53684.812949] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[53684.847826] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[53684.883234] Call Trace:
[53684.896228] release_nodes+0x76/0x260
[53684.913359] devres_release_all+0x3c/0x60
[53684.932192] device_release_driver_internal+0x151/0x1f0
[53684.956700] driver_detach+0x3f/0x80
[53684.973569] bus_remove_driver+0x55/0xd0
[53684.992057] driver_unregister+0x2c/0x50
[53685.010575] platform_driver_unregister+0x12/0x20
[53685.032584] nfit_test_exit+0x10/0xaa9 [nfit_test]
[53685.055372] SyS_delete_module+0x1ba/0x220
[53685.074931] do_syscall_64+0x67/0x180
[53685.092329] entry_SYSCALL64_slow_path+0x25/0x25
[53685.114144] RIP: 0033:0x7f1faa70dc27
[53685.131113] RSP: 002b:00007ffc579ffa98 EFLAGS: 00000202 ORIG_RAX: 00000000000000b0
[53685.167000] RAX: ffffffffffffffda RBX: 0000000002560340 RCX: 00007f1faa70dc27
[53685.201314] RDX: 00007f1faa77e000 RSI: 0000000000000800 RDI: 00000000025603a8
[53685.234812] RBP: 0000000000000000 R08: 00007f1faa9d1060 R09: 00007f1faa77e000
[53685.267909] R10: 00007ffc579ff820 R11: 0000000000000202 R12: 00007ffc57a00922
[53685.301350] R13: 0000000000000000 R14: 0000000002560340 R15: 0000000002560010
[53685.335068] Code: 00 00 55 48 8b 07 48 ba 00 01 00 00 00 00 ad de 4c 8b 47 08 48 89 e5 48 39 d0
74 27 48 ba 00 02 00 00 00 00 ad de 49 39 d0 74 7e <4d> 8b 00 4c 39 c7 75 55 4c 8b 40 08 4c 39 c7 75
2b b8 01 00 00
[53685.427540] RIP: __list_del_entry_valid+0x29/0xd0 RSP: ffffbf3348ccbd90
[53685.459123] CR2: 0000000000000000
[53685.477027] ---[ end trace 2392c114f429911a ]---
[53685.503198] Kernel panic - not syncing: Fatal exception
[53685.528001] Kernel Offset: 0x2da00000 from 0xffffffff81000000 (relocation range:
0xffffffff80000000-0xffffffffbfffffff)
[53685.584866] ---[ end Kernel panic - not syncing: Fatal exception

2) If I skip the step of loading all the other modules on a system without
NVDIMMs and just load nfit_test, the system will panic.  It sometimes panics
immediately in the nd code and sometimes a few seconds later.  Here's an
example of a more immediate panic:

[ 81.125797] nfit_test nfit_test.0: failed to evaluate _FIT
[ 82.213983] BUG: unable to handle kernel
[ 82.213985] nd_bus ndbus1: nd_pmem.probe(btt6.0) = -19
[ 82.213990] nd_bus ndbus1: nd_pmem.probe(pfn6.0) = -19
[ 82.214012] nd_bus ndbus1: dax_pmem.probe(dax6.0) = -19
[ 82.214029] nd_pmem namespace7.0: nd_btt_probe: btt: <none>
[ 82.214031] btt7.1: nd_btt_release
[ 82.214035] nd_bus ndbus1: nd_pmem.probe(btt7.0) = -19
[ 82.214036] nd_pmem namespace7.0: nd_pfn_probe: pfn: <none>
[ 82.214037] pfn7.1: nd_pfn_release
[ 82.214043] nd_pmem namespace7.0: nd_dax_probe: dax: <none>
[ 82.214063] dax7.1: nd_dax_release
[ 82.214066] nd_pmem namespace7.0: unable to guarantee persistence of writes
[ 82.214078] nd_bus ndbus1: dax_pmem.probe(dax7.0) = -19
[ 82.214104] nd_bus ndbus1: nd_pmem.probe(pfn7.0) = -19
[ 82.215500] pmem7: detected capacity change from 0 to 4194304
[ 82.215505] nd_bus ndbus1: nd_pmem.probe(namespace7.0) = 0
[ 82.584056] paging request at fffffc8a4d260060
[ 82.603976] IP: kfree+0x4b/0x180
[ 82.618403] PGD 0
[ 82.618404]
[ 82.634670] Oops: 0000 [#1] SMP
[ 82.648749] Modules linked in: dax_pmem(O) nd_pmem(O) dax(O) nd_blk(O) nd_btt(O) nfit_test(O)
nfit(O) libnvdimm(O) nfit_test_iomap(O) ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT
nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter vfat
fat intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif ghash_clmulni_intel pcbc aesni_intel crypto_simd
glue_helper cryptd ipmi_si sg ipmi_devintf iTCO_wdt
[ 82.977028] hpilo hpwdt iTCO_vendor_support wmi ipmi_msghandler ioatdma pcspkr acpi_power_meter
shpchp i2c_i801 lpc_ich dca ip_tables xfs sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ttm drm bnx2x tg3 mdio ptp hpsa i2c_core pps_core libcrc32c
crc32c_intel scsi_transport_sas
[ 83.109212] CPU: 1 PID: 3600 Comm: kworker/u145:3 Tainted: G O 4.11.0-rc5+ #3
[ 83.148180] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 10/05/2016
[ 83.187404] Workqueue: events_unbound async_run_entry_fn
[ 83.212597] task: ffff9aa1a4830000 task.stack: ffffac1085dfc000
[ 83.240553] RIP: 0010:kfree+0x4b/0x180
[ 83.258477] RSP: 0018:ffffac1085dffbf8 EFLAGS: 00010282
[ 83.284608] RAX: fffffc8a4d260040 RBX: ffffac1089801000 RCX: 0000000000000000
[ 83.320332] RDX: 0000656240000000 RSI: 0000000000000001 RDI: ffffac1089801000
[ 83.354911] RBP: ffffac1085dffc10 R08: 000000000001e6a0 R09: ffffffff883bc49c
[ 83.388249] R10: ffff9aa1af45e6a0 R11: fffffc4491b0bb00 R12: ffffffff883bc6b0
[ 83.421940] R13: ffffffff884e9693 R14: 0000000000000000 R15: 000000000000003b
[ 83.454797] FS: 0000000000000000(0000) GS:ffff9aa1af440000(0000) knlGS:0000000000000000
[ 83.492958] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 83.520259] CR2: fffffc8a4d260060 CR3: 0000000007a09000 CR4: 00000000003406e0
[ 83.553821] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 83.587522] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 83.621249] Call Trace:
[ 83.633325] ? pinctrl_put+0x30/0x30
[ 83.650243] devres_free+0x23/0x30
[ 83.666292] devres_release+0x32/0x50
[ 83.683445] devm_pinctrl_put+0x23/0x40
[ 83.701820] pinctrl_bind_pins+0xf0/0x290
[ 83.720422] driver_probe_device+0xa5/0x470
[ 83.740234] __device_attach_driver+0x7e/0xe0
[ 83.760925] ? driver_allows_async_probing+0x30/0x30
[ 83.784698] bus_for_each_drv+0x68/0xb0
[ 83.802935] __device_attach+0xdd/0x160
[ 83.821835] device_initial_probe+0x13/0x20
[ 83.841870] bus_probe_device+0x92/0xa0
[ 83.860552] device_add+0x44b/0x610
[ 83.877357] ? __switch_to+0x23e/0x510
[ 83.895861] nd_async_device_register+0x12/0x50 [libnvdimm]
[ 83.923081] async_run_entry_fn+0x39/0x170
[ 83.942256] process_one_work+0x165/0x410
[ 83.961263] worker_thread+0x137/0x4c0
[ 83.978660] kthread+0x101/0x140
[ 83.993687] ? rescuer_thread+0x3b0/0x3b0
[ 84.012334] ? kthread_park+0x90/0x90
[ 84.028959] ret_from_fork+0x2c/0x40
[ 84.045767] Code: 96 00 00 00 b8 00 00 00 80 48 8b 15 30 d3 9f 00 48 01 d8 0f 83 d3 00 00 00 48 01
d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 1d 4a a3 00 <4c> 8b 58 20 41 f6 c3 01 0f 85 12 01 00 00 49 89 c3
49 8b 43 20
[ 84.134033] RIP: kfree+0x4b/0x180 RSP: ffffac1085dffbf8
[ 84.158740] CR2: fffffc8a4d260060
[ 84.174402] ---[ end trace 0f035cd21307487a ]---


Here's an example of a panic that happened a bit later.

[ 111.030442] nfit_test nfit_test.0: failed to evaluate _FIT
[ 119.845687] BUG: unable to handle kernel paging request at ffffe2d2af202360
[ 119.880981] IP: kmem_cache_free+0x5a/0x1f0
[ 119.900905] PGD 0
[ 119.900905]
[ 119.918093] Oops: 0000 [#1] SMP
[ 119.935350] Modules linked in: dax_pmem(O) nd_pmem(O) dax(O) nd_blk(O) nd_btt(O) nfit_test(O)
nfit(O) libnvdimm(O) nfit_test_iomap(O) ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT
nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp vfat fat kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd glue_helper
cryptd ipmi_ssif sg iTCO_wdt hpwdt iTCO_vendor_support
[ 120.260507] hpilo i2c_i801 ioatdma wmi shpchp lpc_ich pcspkr dca ipmi_si ipmi_devintf
ipmi_msghandler acpi_power_meter ip_tables xfs sd_mod mgag200 i2c_algo_bit drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm bnx2x tg3 mdio hpsa ptp i2c_core pps_core
libcrc32c scsi_transport_sas crc32c_intel
[ 120.388305] CPU: 2 PID: 1075 Comm: systemd-readahe Tainted: G O 4.11.0-rc5+ #3
[ 120.427776] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 10/05/2016
[ 120.464931] task: ffff96af257aad00 task.stack: ffffb0ea8638c000
[ 120.491504] RIP: 0010:kmem_cache_free+0x5a/0x1f0
[ 120.512262] RSP: 0018:ffffb0ea8638f9e0 EFLAGS: 00010282
[ 120.535816] RAX: ffffe2d2af202340 RBX: ffffb0ea8808d000 RCX: ffff96a323fb8c00
[ 120.568021] RDX: 00006960c0000000 RSI: ffffb0ea8808d000 RDI: ffff96a03fc07ac0
[ 120.600166] RBP: ffffb0ea8638f9f8 R08: ffffb0ea8808d008 R09: ffffffffc0757dc5
[ 120.631954] R10: ffff96a32f49e660 R11: ffffe269918fee00 R12: ffff96a03fc07ac0
[ 120.665620] R13: 0000000000000014 R14: ffff96a323fb8c00 R15: 0000000000000000
[ 120.698552] FS: 00007fe16ec50740(0000) GS:ffff96a32f480000(0000) knlGS:0000000000000000
[ 120.735389] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 120.761414] CR2: ffffe2d2af202360 CR3: 000000046455b000 CR4: 00000000003406e0
[ 120.793444] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 120.825045] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 120.856860] Call Trace:
[ 120.868207] xfs_trans_free_item_desc+0x45/0x50 [xfs]
[ 120.893931] xfs_trans_free_items+0x80/0xb0 [xfs]
[ 120.917504] xfs_log_commit_cil+0x47c/0x5d0 [xfs]
[ 120.938651] __xfs_trans_commit+0x128/0x230 [xfs]
[ 120.959812] __xfs_trans_roll+0x6c/0xe0 [xfs]
[ 120.979722] xfs_trans_roll+0x25/0x40 [xfs]
[ 120.998656] xfs_defer_trans_roll+0x6b/0x170 [xfs]
[ 121.020117] xfs_defer_finish+0x7a/0x410 [xfs]
[ 121.040102] ? kvfree+0x35/0x40
[ 121.055078] xfs_finish_rename+0x3a/0x70 [xfs]
[ 121.076053] xfs_rename+0x75a/0xaa0 [xfs]
[ 121.094554] xfs_vn_rename+0xe4/0x140 [xfs]
[ 121.113325] vfs_rename+0x4d1/0x760
[ 121.129256] SyS_rename+0x359/0x3d0
[ 121.145260] entry_SYSCALL_64_fastpath+0x1a/0xa9
[ 121.166688] RIP: 0033:0x7fe16e0ad887
[ 121.183453] RSP: 002b:00007fff01d91ee8 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
[ 121.217581] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 00007fe16e0ad887
[ 121.249689] RDX: 000056433f863170 RSI: 000056433f794010 RDI: 000056433f862430
[ 121.281785] RBP: 00007fe16ec506a0 R08: 000056433f863090 R09: 00007fe16ec50740
[ 121.313793] R10: 000000000000000a R11: 0000000000000246 R12: 0000000000000002
[ 121.346068] R13: 0000000000000007 R14: 000056433f863090 R15: 000000000000a000
[ 121.378075] Code: b8 00 00 00 80 4c 8b 4d 08 48 8b 15 b1 d8 9f 00 48 01 d8 0f 83 b7 00 00 00 48 01
d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 9e 4f a3 00 <4c> 8b 58 20 41 f6 c3 01 0f 85 56 01 00 00 49 89 c3
4c 8b 17 65
[ 121.468457] RIP: kmem_cache_free+0x5a/0x1f0 RSP: ffffb0ea8638f9e0
[ 121.495935] CR2: ffffe2d2af202360
[ 121.510867] ---[ end trace f947aa5ca41bdfb4 ]---
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
