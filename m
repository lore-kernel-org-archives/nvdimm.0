Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA3B42194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 15:14:23 -0700 (PDT)
Received: from G4W9121.americas.hpqcorp.net (g4w9121.houston.hp.com
 [16.210.21.16])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2353.austin.hpe.com (Postfix) with ESMTPS id 1CB5657
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 22:14:23 +0000 (UTC)
Subject: Re: panics related to nfit_test?
References: <58E793E8.8070507@hpe.com>
 <CAPcyv4jfCZMpNAC=-vG0a_koAfe-Vrr_+xcHXw1=TD+3DsqN+Q@mail.gmail.com>
 <58E7C875.8050008@hpe.com> <58E7F689.8010709@hpe.com>
 <CAPcyv4gS+z_HiMrgvayDaQr2qNKtZ+6boMdDZj0hQrxJhc+U6g@mail.gmail.com>
 <58E80ABB.3040807@ymail.com>
 <CAPcyv4i7LURhWQvDtxu6Bdtr2sEEHqjPqaE6a7oBYX7raNqyCw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58F1494F.2080107@hpe.com>
Date: Fri, 14 Apr 2017 18:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4i7LURhWQvDtxu6Bdtr2sEEHqjPqaE6a7oBYX7raNqyCw@mail.gmail.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/14/2017 11:50 AM, Dan Williams wrote:
> 
> I have not been able to reproduce this panic, but does the following
> make a difference on your systems?
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index bc02f28ed8b8..afb7a7efc12a 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -1983,9 +1983,9 @@ static __exit void nfit_test_exit(void)
>  {
>         int i;
> 
> -       platform_driver_unregister(&nfit_test_driver);
>         for (i = 0; i < NUM_NFITS; i++)
>                 platform_device_unregister(&instances[i]->pdev);
> +       platform_driver_unregister(&nfit_test_driver);
>         nfit_test_teardown();
>         class_destroy(nfit_test_dimm);
>  }

I tried it on both of my systems.  My 72-core server has NVDIMMs and my
4-core laptop does not.  Both systems still panic but now
they panic before trying to rmmod the module, which I had commented
out of my script.  I tried it several times and got panics in different
modules (xfs, selinux, etc) but all seem to be related to kmem.  See
below for an example.

It feels like corruption that has just moved a bit.  If you recall
from my original mail, I reported two kinds of panics and this looks
just like the second panic.

Since it never happens for you and always happens for me, it feels
like a build/procedure problem.  I haven't had a chance to try in
a VM.  Have you had a chance to try on bare metal?

-- ljk

This is what I ran:

$ sudo ./test.sh
+ modprobe nfit
+ modprobe dax
+ modprobe dax_pmem
+ modprobe libnvdimm
+ modprobe nd_blk
+ modprobe nd_btt
+ modprobe nd_e820
+ modprobe nd_pmem
+ lsmod
+ grep nfit
nfit 49152 8
libnvdimm 135168 6 nd_btt,nd_pmem,nd_e820,nd_blk,dax_pmem,nfit
nfit_test_iomap 16384 4 nd_pmem,dax_pmem,nfit,libnvdimm
+ modprobe nfit_test
+ lsmod
+ grep nfit
nfit_test 28672 6
nfit 49152 9 nfit_test
libnvdimm 135168 7 nfit_test,nd_btt,nd_pmem,nd_e820,nd_blk,dax_pmem,nfit
nfit_test_iomap 16384 5 nfit_test,nd_pmem,dax_pmem,nfit,libnvdimm
+ ndctl disable-region all


This is what I got:

[ 70.247427] nfit_test nfit_test.0: failed to evaluate _FIT
[ 71.340634] BUG: unable to handle kernel paging request at ffffeb04002e00a0
[ 71.341359] nd btt9.0: nd_btt_release
[ 71.341396] nd_bus ndbus1: nd_region.remove(region9) = 0
[ 71.341399] nd_bus ndbus1: nvdimm_map_release: 0xffffc90006d00000
[ 71.341401] nd_bus ndbus1: nvdimm_map_release: 0xffffc90026003000
[ 71.342597] nd btt11.0: nd_btt_release
[ 71.342599] nd_bus ndbus1: nd_region.remove(region11) = 0
[ 71.342601] nd_bus ndbus1: nvdimm_map_release: 0xffffc90006d5e000
[ 71.342603] nd_bus ndbus1: nvdimm_map_release: 0xffffc9002a005000
[ 71.343797] nd pfn13.0: nd_pfn_release
[ 71.343837] nd btt13.0: nd_btt_release
[ 71.343848] nd dax13.0: nd_dax_release
[ 71.343850] nd_bus ndbus1: nd_region.remove(region13) = 0
[ 71.343852] nd_bus ndbus1: nvdimm_map_release: 0xffffc90003841000
[ 71.343853] nd_bus ndbus1: nvdimm_map_release: 0xffffc90003819000
[ 71.345058] nd btt8.0: nd_btt_release
[ 71.345090] nd_bus ndbus1: nd_region.remove(region8) = 0
[ 71.345092] nd_bus ndbus1: nvdimm_map_release: 0xffffc90006b91000
[ 71.345093] nd_bus ndbus1: nvdimm_map_release: 0xffffc90024002000
[ 71.345095] nd_bus ndbus1: nvdimm_map_release: 0xffffc90003811000
[ 71.346280] nd btt10.0: nd_btt_release
[ 71.346311] nd_bus ndbus1: nd_region.remove(region10) = 0
[ 71.346313] nd_bus ndbus1: nvdimm_map_release: 0xffffc90006d3d000
[ 71.346314] nd_bus ndbus1: nvdimm_map_release: 0xffffc90028004000
[ 71.346316] nd_bus ndbus1: nvdimm_map_release: 0xffffc90003821000
[ 71.348129] nd btt1.0: nd_btt_release
[ 71.348161] nd pfn1.0: nd_pfn_release
[ 71.348187] nd dax1.0: nd_dax_release
[ 71.348217] nd_bus ndbus0: nd_pmem.remove(pfn1.1) = 0
[ 72.024210] IP: kmem_cache_free+0x5a/0x1f0
[ 72.042828] PGD 0
[ 72.042829]
[ 72.058492] Oops: 0000 [#1] SMP
[ 72.072584] Modules linked in: nfit_test(O) nd_e820(O) nd_blk(O) ip6t_rpfilter ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute
bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp vfat
fat coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
ipmi_ssif aesni_intel crypto_simd glue_helper cryptd nd_pmem(O) nd_btt(O) dax_pmem(O) iTCO_wdt
dax(O) sg i2c_i801 wmi hpilo hpwdt ioatdma iTCO_vendor_support
[ 72.402497] ipmi_si shpchp dca pcspkr ipmi_devintf lpc_ich nfit(O) libnvdimm(O) ipmi_msghandler
acpi_power_meter nfit_test_iomap(O) ip_tables xfs sd_mod mgag200 i2c_algo_bit drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm bnx2x tg3 mdio ptp hpsa i2c_core pps_core
libcrc32c scsi_transport_sas crc32c_intel
[ 72.533082] CPU: 3 PID: 2112 Comm: in:imjournal Tainted: G O 4.11.0-rc5+ #3
[ 72.570128] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 10/05/2016
[ 72.607350] task: ffff88105a664380 task.stack: ffffc9000683c000
[ 72.633968] RIP: 0010:kmem_cache_free+0x5a/0x1f0
[ 72.654852] RSP: 0018:ffffc9000683f9c8 EFLAGS: 00010282
[ 72.678481] RAX: ffffeb04002e0080 RBX: ffffc9000b802000 RCX: 0000000000000002
[ 72.710704] RDX: 000077ff80000000 RSI: ffffc9000b802000 RDI: ffff88017fc07ac0
[ 72.742815] RBP: ffffc9000683f9e0 R08: ffffc9000b802008 R09: ffffffffc0458dc5
[ 72.775750] R10: ffff88046f4de660 R11: ffffea0011a025c0 R12: ffff88017fc07ac0
[ 72.809516] R13: 0000000000000018 R14: ffff880468097200 R15: 0000000000000000
[ 72.843108] FS: 00007f2e10184700(0000) GS:ffff88046f4c0000(0000) knlGS:0000000000000000
[ 72.882118] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 72.910341] CR2: ffffeb04002e00a0 CR3: 0000001054d31000 CR4: 00000000003406e0
[ 72.945776] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 72.980142] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 73.013916] Call Trace:
[ 73.025544] xfs_trans_free_item_desc+0x45/0x50 [xfs]
[ 73.049367] xfs_trans_free_items+0x80/0xb0 [xfs]
[ 73.071701] xfs_log_commit_cil+0x47c/0x5d0 [xfs]
[ 73.093910] __xfs_trans_commit+0x128/0x230 [xfs]
[ 73.116015] xfs_trans_commit+0x10/0x20 [xfs]
[ 73.136621] xfs_create+0x6fa/0x740 [xfs]
[ 73.155495] xfs_generic_create+0x1ee/0x2d0 [xfs]
[ 73.177635] ? __d_lookup_done+0x7c/0xe0
[ 73.196182] xfs_vn_mknod+0x14/0x20 [xfs]
[ 73.214656] xfs_vn_create+0x13/0x20 [xfs]
[ 73.233910] path_openat+0xed6/0x13c0
[ 73.251135] ? futex_wake_op+0x421/0x620
[ 73.269542] do_filp_open+0x91/0x100
[ 73.286798] ? do_futex+0x14b/0x570
[ 73.303905] ? __alloc_fd+0x46/0x170
[ 73.320897] do_sys_open+0x124/0x210
[ 73.338029] ? __audit_syscall_exit+0x209/0x290
[ 73.359419] SyS_open+0x1e/0x20
[ 73.374132] do_syscall_64+0x67/0x180
[ 73.391704] entry_SYSCALL64_slow_path+0x25/0x25
[ 73.414681] RIP: 0033:0x7f2e133aaa2d
[ 73.432523] RSP: 002b:00007f2e10183970 EFLAGS: 00000293 ORIG_RAX: 0000000000000002
[ 73.470497] RAX: ffffffffffffffda RBX: 00007f2e12c5394f RCX: 00007f2e133aaa2d
[ 73.504061] RDX: 00000000000001b6 RSI: 0000000000000241 RDI: 00007f2e10183a20
[ 73.537942] RBP: 00007f2e101839d0 R08: 00007f2e12c53954 R09: 0000000000000240
[ 73.571752] R10: 0000000000000024 R11: 0000000000000293 R12: 00007f2e00001f70
[ 73.605982] R13: 0000000000000004 R14: 00007f2e000012f0 R15: 000000000000000a
[ 73.640046] Code: b8 00 00 00 80 4c 8b 4d 08 48 8b 15 b1 d8 9f 00 48 01 d8 0f 83 b7 00 00 00 48 01
d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 9e 4f a3 00 <4c> 8b 58 20 41 f6 c3 01 0f 85 56 01 00 00 49 89 c3
4c 8b 17 65
[ 73.729777] RIP: kmem_cache_free+0x5a/0x1f0 RSP: ffffc9000683f9c8
[ 73.758552] CR2: ffffeb04002e00a0
[ 73.774478] ---[ end trace f5ad68bbafdb5b54 ]---
[ 73.801397] Kernel panic - not syncing: Fatal exception
[ 73.825880] Kernel Offset: disabled
[ 73.849946] ---[ end Kernel panic - not syncing: Fatal exception
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
