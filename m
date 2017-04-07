Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 32E6521942323
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 09:44:32 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id b187so92429714oif.0
 for <linux-nvdimm@lists.01.org>; Fri, 07 Apr 2017 09:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58E793E8.8070507@hpe.com>
References: <58E793E8.8070507@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Apr 2017 09:44:31 -0700
Message-ID: <CAPcyv4jfCZMpNAC=-vG0a_koAfe-Vrr_+xcHXw1=TD+3DsqN+Q@mail.gmail.com>
Subject: Re: panics related to nfit_test?
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 7, 2017 at 6:28 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> I'm trying to run the ndctl tests on 4.11-rc5.  I've never run them before but I
> think I correctly followed all the directions for building and installing the
> tools/testing/nvdimm components as described in the ndctl README.md.  I'm
> seeing two problems that may be related and I'm wondering whether this could
> be build/user error or something real.
>
> 1) Running the tests was causing my system to panic when the nfit_test module
> is unloaded.  I determined I don't actually have to run a test to cause the panic, just
> modprobe the modules as listed in ndctl nfit_test_init(), then modprobe nfit_test,
> then rmmod nfit_test.  I'm doing this on a system without NVDIMMs. I get
> the same thing on a system with NVDIMMs although the other modules are already
> loaded.
>
> This is the panic I get, very reproducibly.
>
> [53617.173340] nfit_test nfit_test.0: failed to evaluate _FIT
>
> <The above message is from the modprobe. Is that expected? The rest is after the rmmod.>
>
> [53683.797952] BUG: unable to handle kernel NULL pointer dereference at (null)
> [53683.837521] IP: __list_del_entry_valid+0x29/0xd0
> [53683.861449] PGD 105f4fb067
> [53683.861449] PUD 1054889067
> [53683.874551] PMD 0
> [53683.887664]
> [53683.903937] Oops: 0000 [#1] SMP
> [53683.918657] Modules linked in: nfit_test(O-) nd_pmem(O) nd_e820(O) nd_blk(O) nd_btt(O)
> dax_pmem(O) dax(O) nfit(O) libnvdimm(O) nfit_test_iomap(O) ip6t_rpfilter ipt_REJECT nf_reject_ipv4
> ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc
> ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security
> ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
> iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables
> iptable_filter intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp vfat fat
> kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc ipmi_ssif aesni_intel
> crypto_simd glue_helper cryptd sg hpilo iTCO_wdt
> [53684.252765] hpwdt ipmi_si ipmi_devintf iTCO_vendor_support ioatdma i2c_i801 lpc_ich shpchp pcspkr
> acpi_power_meter ipmi_msghandler dca wmi ip_tables xfs sd_mod mgag200 i2c_algo_bit drm_kms_helper
> syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm bnx2x tg3 mdio hpsa ptp i2c_core pps_core
> libcrc32c scsi_transport_sas crc32c_intel
> [53684.394684] CPU: 35 PID: 4087 Comm: rmmod Tainted: G W O 4.11.0-rc5+ #3
> [53684.430295] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 10/05/2016
> [53684.469368] task: ffff9cdbaca9ad00 task.stack: ffffbf3348cc8000
> [53684.497175] RIP: 0010:__list_del_entry_valid+0x29/0xd0
> [53684.521315] RSP: 0018:ffffbf3348ccbd90 EFLAGS: 00010007
> [53684.545823] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
> [53684.579642] RDX: dead000000000200 RSI: ffff9cdbaf4268a0 RDI: ffffbf334e302000
> [53684.613132] RBP: ffffbf3348ccbd90 R08: 0000000000000000 R09: ffffbf334e302000
> [53684.646725] R10: 0000000000000004 R11: ffff9cdbaf4268a0 R12: ffffbf3348ccbdc8
> [53684.680100] R13: 0000000000000000 R14: 0000000000000000 R15: ffff9ce7a36f2400
> [53684.713655] FS: 00007f1fab239740(0000) GS:ffff9ce7af040000(0000) knlGS:0000000000000000
> [53684.751875] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [53684.778962] CR2: 0000000000000000 CR3: 000000106eb12000 CR4: 00000000003406e0
> [53684.812949] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [53684.847826] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [53684.883234] Call Trace:
> [53684.896228] release_nodes+0x76/0x260
> [53684.913359] devres_release_all+0x3c/0x60
> [53684.932192] device_release_driver_internal+0x151/0x1f0
> [53684.956700] driver_detach+0x3f/0x80
> [53684.973569] bus_remove_driver+0x55/0xd0
> [53684.992057] driver_unregister+0x2c/0x50
> [53685.010575] platform_driver_unregister+0x12/0x20
> [53685.032584] nfit_test_exit+0x10/0xaa9 [nfit_test]
> [53685.055372] SyS_delete_module+0x1ba/0x220

Can you send your kernel config? I've seen reports of this crash
signature from the team trying to integrate the ndctl unit tests into
the 0day kbuild robot, but I have thus far been unable to reproduce
them. On my system if I do:

# modprobe nfit_test
# rmmod nfit_test
rmmod: ERROR: Module nfit_test is in use

Are you saying you are able to remove nfit_test on your system without
first disabling regions?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
