Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4CB0A21A02906
 for <linux-nvdimm@lists.01.org>; Fri, 26 May 2017 07:52:53 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: null pointer dereference in device unregister path
Date: Fri, 26 May 2017 10:52:51 -0400
Message-ID: <x49zidzbrgc.fsf@segfault.boston.devel.redhat.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

If I run the following script in a loop, and then ctrl-c it, the kernel
hits a BUG in the device unregister path.

---[ns-reconf.sh]---
function pmem_btt_dax_switch() {
        sector_size_list="512 520 528 4096 4104 4160 4224"
        for sector_size in $sector_size_list; do
                ndctl create-namespace -f -e namespace${1}.0 --mode=sector -l $sector_size
                ndctl create-namespace -f -e namespace${1}.0 --mode=raw
                ndctl create-namespace -f -e namespace${1}.0 --mode=dax
        done
}
for i in 0 1 2 3; do
        pmem_btt_dax_switch $i &
done
---[ns-reconf.sh]---

# while true; do ./ns-reconfig.sh 0; ./ns-reconfig.sh 1; done

I've tried three times and hit the bug every time, so it seems readily
reproducible.

Offset 0x20 is the put function pointer in struct klist.  This is where
the null pointer is triggered:

static void klist_put(struct klist_node *n, bool kill)
{
        struct klist *k = knode_klist(n);
        void (*put)(struct klist_node *) = k->put; <----

This is the tip of Linus' tree, commit be941bf2e6a32.

Any ideas?

-Jeff

[  117.728323] pmem0s: detected capacity change from 0 to 34093219840
[  117.831496] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
[  117.867193] IP: klist_put+0x1b/0x70
[  117.884172] PGD 0 
[  117.884172] P4D 0 
[  117.894325] 
[  117.912779] Oops: 0000 [#1] SMP
[  117.926842] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm vfat fat irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd nd_pmem iTCO_wdt iTCO_vendor_support glue_helper dax_pmem hpilo device_dax lpc_ich hpwdt cryptd nd_btt pcspkr ipmi_si sg ioatdma i2c_i801 mfd_core shpchp ipmi_devintf dca wmi ipmi_msghandler nfit acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea
[  118.247253]  sysfillrect sysimgblt bnx2x fb_sys_fops ahci tg3 mdio ttm libahci ptp drm libata i2c_core pps_core hpsa libcrc32c crc32c_intel scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  118.326324] CPU: 45 PID: 1060 Comm: kworker/u145:2 Not tainted 4.12.0-rc2+ #28
[  118.358984] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 10/05/2016
[  118.398735] Workqueue: events_unbound async_run_entry_fn
[  118.426362] task: ffff880465ea8000 task.stack: ffffc9000683c000
[  118.452949] RIP: 0010:klist_put+0x1b/0x70
[  118.470906] RSP: 0018:ffffc9000683fd70 EFLAGS: 00010246
[  118.494545] RAX: ffff880cfdbe8b40 RBX: 0000000000000000 RCX: 000000018022001c
[  118.526532] RDX: 000000018022001d RSI: 0000000000000001 RDI: 0000000000000000
[  118.558720] RBP: ffffc9000683fd90 R08: ffff88106463a8e8 R09: 000000018022001c
[  118.590772] R10: 000000006463a701 R11: ffff88106463a8e8 R12: ffff88106935cc00
[  118.622923] R13: ffff880cfdbe8b68 R14: 0000000000000001 R15: ffff88046f438ce8
[  118.655122] FS:  0000000000000000(0000) GS:ffff88046fac0000(0000) knlGS:0000000000000000
[  118.691517] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  118.716914] CR2: 0000000000000020 CR3: 0000000001c09000 CR4: 00000000003406e0
[  118.749349] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  118.781627] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  118.814621] Call Trace:
[  118.825740]  klist_del+0xe/0x10
[  118.839764]  device_del+0x11a/0x330
[  118.855526]  device_unregister+0x1a/0x60
[  118.873549]  nd_async_device_unregister+0x22/0x30
[  118.895091]  async_run_entry_fn+0x39/0x170
[  118.916718]  process_one_work+0x149/0x360
[  118.937472]  worker_thread+0x4d/0x3c0
[  118.953919]  kthread+0x109/0x140
[  118.968400]  ? rescuer_thread+0x380/0x380
[  118.986373]  ? kthread_park+0x60/0x60
[  119.002425]  ret_from_fork+0x2c/0x40
[  119.018421] Code: e9 1a ff ff ff 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 56 41 89 f6 41 55 49 89 fd 41 54 53 48 8b 1f 48 83 e3 fe 48 89 df <4c> 8b 63 20 e8 7c f8 00 00 45 84 f6 75 31 4c 89 ef e8 af fe ff 
[  119.103298] RIP: klist_put+0x1b/0x70 RSP: ffffc9000683fd70
[  119.128194] CR2: 0000000000000020
[  119.143813] ---[ end trace 4fadffd9ed599da8 ]---
[  119.169828] Kernel panic - not syncing: Fatal exception
[  119.193524] Kernel Offset: disabled
[  119.213732] ---[ end Kernel panic - not syncing: Fatal exception
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
