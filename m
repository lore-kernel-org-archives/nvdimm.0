From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [BUG] kernel NULL pointer dereference observed during pmem btt
 switch test
Date: Thu, 28 Jul 2016 08:50:52 -0700
Message-ID: <CAPcyv4g5PpShWfXSV+KPJYW7GFrejUNjk=C1-ak=88iX8XczGA@mail.gmail.com>
References: <622794958.9574724.1469674652262.JavaMail.zimbra@redhat.com> <1762637089.9575520.1469676013321.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1762637089.9575520.1469676013321.JavaMail.zimbra@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Yi Zhang <yizhan@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>, linux-block@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

[ adding linux-block ]

On Wed, Jul 27, 2016 at 8:20 PM, Yi Zhang <yizhan@redhat.com> wrote:
> Hello everyone
>
> Could you help check this issue, thanks.
>
> Steps I used:
> 1. Reserve 4*8G of memory for pmem by add kernel parameter "memmap=8G!4G memmap=8G!12G memmap=8G!20G memmap=8G!28G"
> 2. Execute below script
> #!/bin/bash
> pmem_btt_switch() {
>         sector_size_list="512 520 528 4096 4104 4160 4224"
>         for sector_size in $sector_size_list; do
>                 ndctl create-namespace -f -e namespace${1}.0 --mode=sector -l $sector_size
>                 ndctl create-namespace -f -e namespace${1}.0 --mode=raw
>         done
> }
>
> for i in 0 1 2 3; do
>         pmem_btt_switch $i &
> done

Thanks for the report.  This looks like del_gendisk() frees the
previous usage of the devt before the bdi is unregistered.  This
appears to be a general problem with all block drivers, not just
libnvdimm, since blk_cleanup_queue() is typically called after
del_gendisk().  I.e. it will always be the case that the bdi
registered with the devt allocated at add_disk() will still be alive
when del_gendisk()->disk_release() frees the previous devt number.

I *think* the path forward is to allow the bdi to hold a reference
against the blk_alloc_devt() allocation until it is done with it.  Any
other ideas on fixing this object lifetime problem?

>
> KERNEL log:
> [  243.404847] nd_pmem namespace2.0: unable to guarantee persistence of writes
> [  243.467271] nd_pmem namespace3.0: unable to guarantee persistence of writes
> [  243.513412] nd_pmem namespace1.0: unable to guarantee persistence of writes
> [  243.544728] nd_pmem namespace0.0: unable to guarantee persistence of writes
> [  243.545371] ------------[ cut here ]------------
> [  243.545381] WARNING: CPU: 10 PID: 2078 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80
> [  243.545382] sysfs: cannot create duplicate filename '/devices/virtual/bdi/259:1'
> [  243.545432] Modules linked in: nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw nd_pmem gf128mul glue_helper ablk_helper cryptd nd_btt hpilo iTCO_wdt iTCO_vendor_support sg hpwdt pcspkr ipmi_ssif ioatdma wmi pcc_cpufreq acpi_cpufreq acpi_power_meter lpc_ich ipmi_si ipmi_msghandler mfd_core shpchp dca nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel tg3 serio_raw hpsa ptp i2c_core scsi_transport_sas pps_core fjes dm_mirror dm_region_hash dm_log dm_mod
> [  243.545435] CPU: 10 PID: 2078 Comm: ndctl Not tainted 4.7.0-rc7 #1
> [  243.545436] Hardware name: HP ProLiant DL580 Gen8, BIOS P79 05/06/2015
> [  243.545439]  0000000000000286 0000000002c04ad5 ffff88006f24f970 ffffffff8134caec
> [  243.545441]  ffff88006f24f9c0 0000000000000000 ffff88006f24f9b0 ffffffff8108c351
> [  243.545442]  0000001f0000000c ffff88105d236000 ffff88105d1031e0 ffff8800357427f8
> [  243.545443] Call Trace:
> [  243.545452]  [<ffffffff8134caec>] dump_stack+0x63/0x87
> [  243.545460]  [<ffffffff8108c351>] __warn+0xd1/0xf0
> [  243.545463]  [<ffffffff8108c3cf>] warn_slowpath_fmt+0x5f/0x80
> [  243.545465]  [<ffffffff812a0d34>] sysfs_warn_dup+0x64/0x80
> [  243.545466]  [<ffffffff812a0e1e>] sysfs_create_dir_ns+0x7e/0x90
> [  243.545469]  [<ffffffff8134faaa>] kobject_add_internal+0xaa/0x320
> [  243.545473]  [<ffffffff81358d4e>] ? vsnprintf+0x34e/0x4d0
> [  243.545475]  [<ffffffff8134ff55>] kobject_add+0x75/0xd0
> [  243.545483]  [<ffffffff816e66b2>] ? mutex_lock+0x12/0x2f
> [  243.545489]  [<ffffffff8148b0a5>] device_add+0x125/0x610
> [  243.545491]  [<ffffffff8148b788>] device_create_groups_vargs+0xd8/0x100
> [  243.545492]  [<ffffffff8148b7cc>] device_create_vargs+0x1c/0x20
> [  243.545498]  [<ffffffff811b775c>] bdi_register+0x8c/0x180
> [  243.545500]  [<ffffffff811b7877>] bdi_register_dev+0x27/0x30
> [  243.545505]  [<ffffffff813317f5>] add_disk+0x175/0x4a0
> [  243.545507]  [<ffffffff816e66b2>] ? mutex_lock+0x12/0x2f
> [  243.545513]  [<ffffffff814afb7f>] ? nvdimm_bus_unlock+0x1f/0x30
> [  243.545518]  [<ffffffffa04e039f>] nd_pmem_probe+0x28f/0x360 [nd_pmem]
> [  243.545521]  [<ffffffff814b0599>] nvdimm_bus_probe+0x69/0x120
> [  243.545524]  [<ffffffff8148e779>] driver_probe_device+0x239/0x460
> [  243.545526]  [<ffffffff8148c974>] bind_store+0xd4/0x110
> [  243.545528]  [<ffffffff8148c054>] drv_attr_store+0x24/0x30
> [  243.545529]  [<ffffffff812a042a>] sysfs_kf_write+0x3a/0x50
> [  243.545531]  [<ffffffff8129fa3b>] kernfs_fop_write+0x11b/0x1a0
> [  243.545536]  [<ffffffff8121d5e7>] __vfs_write+0x37/0x160
> [  243.545544]  [<ffffffff812ceadd>] ? security_file_permission+0x3d/0xc0
> [  243.545550]  [<ffffffff810d7e1f>] ? percpu_down_read+0x1f/0x50
> [  243.545552]  [<ffffffff8121e8e2>] vfs_write+0xb2/0x1b0
> [  243.545555]  [<ffffffff8121fd35>] SyS_write+0x55/0xc0
> [  243.545560]  [<ffffffff81003b12>] do_syscall_64+0x62/0x110
> [  243.545563]  [<ffffffff816e85e1>] entry_SYSCALL64_slow_path+0x25/0x25
> [  243.545579] ---[ end trace 6d3b90c425a39fda ]---
> [  243.545580] ------------[ cut here ]------------
> [  243.545583] WARNING: CPU: 10 PID: 2078 at lib/kobject.c:240 kobject_add_internal+0x262/0x320
> [  243.545584] kobject_add_internal failed for 259:1 with -EEXIST, don't try to register things with the same name in the same directory.
> [  243.545603] Modules linked in: nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw nd_pmem gf128mul glue_helper ablk_helper cryptd nd_btt hpilo iTCO_wdt iTCO_vendor_support sg hpwdt pcspkr ipmi_ssif ioatdma wmi pcc_cpufreq acpi_cpufreq acpi_power_meter lpc_ich ipmi_si ipmi_msghandler mfd_core shpchp dca nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel tg3 serio_raw hpsa ptp i2c_core scsi_transport_sas pps_core fjes dm_mirror dm_region_hash dm_log dm_mod
> [  243.545605] CPU: 10 PID: 2078 Comm: ndctl Tainted: G        W       4.7.0-rc7 #1
> [  243.545605] Hardware name: HP ProLiant DL580 Gen8, BIOS P79 05/06/2015
> [  243.545607]  0000000000000286 0000000002c04ad5 ffff88006f24f9c0 ffffffff8134caec
> [  243.545608]  ffff88006f24fa10 0000000000000000 ffff88006f24fa00 ffffffff8108c351
> [  243.545610]  000000f06f24fa28 ffff880035164010 ffff88006c7e3780 00000000ffffffef
> [  243.545610] Call Trace:
> [  243.545612]  [<ffffffff8134caec>] dump_stack+0x63/0x87
> [  243.545614]  [<ffffffff8108c351>] __warn+0xd1/0xf0
> [  243.545616]  [<ffffffff8108c3cf>] warn_slowpath_fmt+0x5f/0x80
> [  243.545618]  [<ffffffff812a0d3c>] ? sysfs_warn_dup+0x6c/0x80
> [  243.545619]  [<ffffffff8134fc62>] kobject_add_internal+0x262/0x320
> [  243.545621]  [<ffffffff81358d4e>] ? vsnprintf+0x34e/0x4d0
> [  243.545622]  [<ffffffff8134ff55>] kobject_add+0x75/0xd0
> [  243.545625]  [<ffffffff816e66b2>] ? mutex_lock+0x12/0x2f
> [  243.545626]  [<ffffffff8148b0a5>] device_add+0x125/0x610
> [  243.545628]  [<ffffffff8148b788>] device_create_groups_vargs+0xd8/0x100
> [  243.545630]  [<ffffffff8148b7cc>] device_create_vargs+0x1c/0x20
> [  243.545632]  [<ffffffff811b775c>] bdi_register+0x8c/0x180
> [  243.545634]  [<ffffffff811b7877>] bdi_register_dev+0x27/0x30
> [  243.545636]  [<ffffffff813317f5>] add_disk+0x175/0x4a0
> [  243.545638]  [<ffffffff816e66b2>] ? mutex_lock+0x12/0x2f
> [  243.545640]  [<ffffffff814afb7f>] ? nvdimm_bus_unlock+0x1f/0x30
> [  243.545642]  [<ffffffffa04e039f>] nd_pmem_probe+0x28f/0x360 [nd_pmem]
> [  243.545644]  [<ffffffff814b0599>] nvdimm_bus_probe+0x69/0x120
> [  243.545646]  [<ffffffff8148e779>] driver_probe_device+0x239/0x460
> [  243.545648]  [<ffffffff8148c974>] bind_store+0xd4/0x110
> [  243.545649]  [<ffffffff8148c054>] drv_attr_store+0x24/0x30
> [  243.545651]  [<ffffffff812a042a>] sysfs_kf_write+0x3a/0x50
> [  243.545652]  [<ffffffff8129fa3b>] kernfs_fop_write+0x11b/0x1a0
> [  243.545654]  [<ffffffff8121d5e7>] __vfs_write+0x37/0x160
> [  243.545657]  [<ffffffff812ceadd>] ? security_file_permission+0x3d/0xc0
> [  243.545659]  [<ffffffff810d7e1f>] ? percpu_down_read+0x1f/0x50
> [  243.545661]  [<ffffffff8121e8e2>] vfs_write+0xb2/0x1b0
> [  243.545663]  [<ffffffff8121fd35>] SyS_write+0x55/0xc0
> [  243.545665]  [<ffffffff81003b12>] do_syscall_64+0x62/0x110
> [  243.545666]  [<ffffffff816e85e1>] entry_SYSCALL64_slow_path+0x25/0x25
> [  243.545667] ---[ end trace 6d3b90c425a39fdb ]---
> [  243.577109] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> [  243.577117] IP: [<ffffffff812a1054>] sysfs_do_create_link_sd.isra.2+0x34/0xb0
> [  243.577119] PGD 1057752067 PUD 105e37a067 PMD 0
> [  243.577121] Oops: 0000 [#1] SMP
> [  243.577154] Modules linked in: nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw nd_pmem gf128mul glue_helper ablk_helper cryptd nd_btt hpilo iTCO_wdt iTCO_vendor_support sg hpwdt pcspkr ipmi_ssif ioatdma wmi pcc_cpufreq acpi_cpufreq acpi_power_meter lpc_ich ipmi_si ipmi_msghandler mfd_core shpchp dca nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel tg3 serio_raw hpsa ptp i2c_core scsi_transport_sas pps_core fjes dm_mirror dm_region_hash dm_log dm_mod
> [  243.577157] CPU: 6 PID: 2078 Comm: ndctl Tainted: G        W       4.7.0-rc7 #1
> [  243.577158] Hardware name: HP ProLiant DL580 Gen8, BIOS P79 05/06/2015
> [  243.577159] task: ffff8800340c8000 ti: ffff88006f24c000 task.ti: ffff88006f24c000
> [  243.577162] RIP: 0010:[<ffffffff812a1054>]  [<ffffffff812a1054>] sysfs_do_create_link_sd.isra.2+0x34/0xb0
> [  243.577163] RSP: 0018:ffff88006f24fc28  EFLAGS: 00010246
> [  243.577164] RAX: 0000000000000000 RBX: 0000000000000040 RCX: 0000000000000001
> [  243.577164] RDX: 0000000000000001 RSI: 0000000000000040 RDI: ffffffff822411f0
> [  243.577165] RBP: ffff88006f24fc50 R08: ffff8800690f1711 R09: ffffffff8134e82e
> [  243.577166] R10: ffff88007799b640 R11: ffffea0000d46000 R12: ffffffff81a3dc3c
> [  243.577166] R13: ffff88105ae627f8 R14: 0000000000000001 R15: ffff880034a89040
> [  243.577168] FS:  00007f685b5dc780(0000) GS:ffff880077980000(0000) knlGS:0000000000000000
> [  243.577168] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  243.577169] CR2: 0000000000000040 CR3: 000000105bb0b000 CR4: 00000000001406e0
> [  243.577170] Stack:
> [  243.577172]  ffff880070666000 ffff880070666080 ffff88006a0635d0 ffff88007066600c
> [  243.577173]  ffff880034a89040 ffff88006f24fc60 ffffffff812a10f5 ffff88006f24fcc8
> [  243.577175]  ffffffff8133188b ffff880070666000 1030000135282c00 ffff880070666000
> [  243.577175] Call Trace:
> [  243.577179]  [<ffffffff812a10f5>] sysfs_create_link+0x25/0x40
> [  243.577184]  [<ffffffff8133188b>] add_disk+0x20b/0x4a0
> [  243.577189]  [<ffffffffa04e039f>] nd_pmem_probe+0x28f/0x360 [nd_pmem]
> [  243.577194]  [<ffffffff814b0599>] nvdimm_bus_probe+0x69/0x120
> [  243.577198]  [<ffffffff8148e779>] driver_probe_device+0x239/0x460
> [  243.577200]  [<ffffffff8148c974>] bind_store+0xd4/0x110
> [  243.577202]  [<ffffffff8148c054>] drv_attr_store+0x24/0x30
> [  243.577203]  [<ffffffff812a042a>] sysfs_kf_write+0x3a/0x50
> [  243.577205]  [<ffffffff8129fa3b>] kernfs_fop_write+0x11b/0x1a0
> [  243.577209]  [<ffffffff8121d5e7>] __vfs_write+0x37/0x160
> [  243.577215]  [<ffffffff812ceadd>] ? security_file_permission+0x3d/0xc0
> [  243.577220]  [<ffffffff810d7e1f>] ? percpu_down_read+0x1f/0x50
> [  243.577222]  [<ffffffff8121e8e2>] vfs_write+0xb2/0x1b0
> [  243.577224]  [<ffffffff8121fd35>] SyS_write+0x55/0xc0
> [  243.577229]  [<ffffffff81003b12>] do_syscall_64+0x62/0x110
> [  243.577232]  [<ffffffff816e85e1>] entry_SYSCALL64_slow_path+0x25/0x25
> [  243.577248] Code: 48 89 e5 41 57 41 56 41 55 41 54 49 89 d4 53 74 73 48 85 ff 49 89 fd 74 6b 48 89 f3 48 c7 c7 f0 11 24 82 41 89 ce e8 7c 72 44 00 <48> 8b 1b 48 85 db 74 08 48 89 df e8 ac c1 ff ff 48 c7 c7 f0 11
> [  243.577250] RIP  [<ffffffff812a1054>] sysfs_do_create_link_sd.isra.2+0x34/0xb0
> [  243.577251]  RSP <ffff88006f24fc28>
> [  243.577251] CR2: 0000000000000040
> [  243.577285] ---[ end trace 6d3b90c425a39fdc ]---
> [  243.578932] Kernel panic - not syncing: Fatal exception
> [  243.597839] Kernel Offset: disabled
> [  247.934728] ---[ end Kernel panic - not syncing: Fatal exception
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
> Best Regards,
>   Yi Zhang
>
>
