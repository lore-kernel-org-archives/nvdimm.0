Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x231.google.com (mail-pf0-x231.google.com
 [IPv6:2607:f8b0:400e:c00::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 105C721A18AA9
 for <linux-nvdimm@lists.01.org>; Mon, 29 May 2017 07:21:01 -0700 (PDT)
Received: by mail-pf0-x231.google.com with SMTP id 9so48959332pfj.1
 for <linux-nvdimm@lists.01.org>; Mon, 29 May 2017 07:21:59 -0700 (PDT)
From: Yasunori Goto <ygotopersonal@gmail.com>
Subject: Fwd: Fw: Panic when make check for ndctl
References: <20170529155643.5848.E1E9C6FF@jp.fujitsu.com>
Message-ID: <c5a2a27e-50ee-b08f-4e2d-d8fbb496adfd@gmail.com>
Date: Mon, 29 May 2017 23:21:54 +0900
MIME-Version: 1.0
In-Reply-To: <20170529155643.5848.E1E9C6FF@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org, y-goto@jp.fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>


Hello,
I tried "make check" of ndctl command on the kernel of libnvdimm-for-next branch(*),
but I feel its kernel is unstable when nfit_test.ko module is loaded.

(*)  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-for-next
         The newest commit is f5705aa8cfed

Here is console logs when the kernel was paniced, and I'll attach the kernel config file.

Does anyone know how to solve this? Am I something wrong?

-------
CentOS Linux 7 (Core)
Kernel 4.12.0-rc1+ on an x86_64

goto-guest login: [   75.737769] random: crng init done
[  189.205125] nfit_test_iomap: loading out-of-tree module taints kernel.
[  189.586917] nfit_test nfit_test.0: found a zero length table '0' parsing nfit
[  191.644655] nfit_test nfit_test.0: failed to evaluate _FIT
[  191.692708] nfit_test nfit_test.1: nmem4 flags: save_fail restore_fail flush_fail not_armed
[  191.694838] nfit_test nfit_test.1: nmem5 flags: map_fail
[  192.734002] nd_pmem namespace6.0: region6 read-only, marking pmem6 read-only
[  192.743577] pmem7: detected capacity change from 0 to 4194304
[  192.747323] pmem6: detected capacity change from 0 to 33554432

CentOS Linux 7 (Core)
Kernel 4.12.0-rc1+ on an x86_64

goto-guest login: [  342.168046] pmem5: detected capacity change from 0 to 67108864
[  342.253861] pmem5: detected capacity change from 0 to 63590400
[  342.332442] pmem5: detected capacity change from 0 to 67108864
[  342.376596] nd_pmem btt5.0: No existing arenas
[  342.382494] pmem5s: detected capacity change from 0 to 65961984
[  342.461783] pmem5: detected capacity change from 0 to 67108864
[  342.542996] ndblk1.0: detected capacity change from 0 to 33554432
[  342.614674] nd_blk btt1.0: No existing arenas
[  342.629830] ndblk1.0s: detected capacity change from 0 to 32440320
[  342.850342] pmem5: detected capacity change from 0 to 67108864
[  342.935050] pmem5: detected capacity change from 0 to 63590400
[  343.059219]  pfn5.1: bad offset: 0x35b000 dax disabled align: 0x200000
[  343.062980] pmem5: detected capacity change from 0 to 67108864
[  343.240452] list_del corruption. next->prev should be ffff92f06f5ba940, but was           (null)
[  343.247955] ------------[ cut here ]------------
[  343.249663] WARNING: CPU: 2 PID: 15846 at lib/list_debug.c:56 __list_del_entry_valid+0x6c/0xa0
[  343.252757] Modules linked in: dax_pmem(O) device_dax(O) nd_pmem(O) nd_blk(O) nd_btt(O) nfit_test(O-) nfit(O) libnvdimm(O) nfit_test_iomap(O) rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache nfsd 
ppdev auth_rpcgss nfs_acl lockd parport_pc parport virtio_balloon grace sg pcspkr sunrpc i2c_piix4 i2c_core acpi_cpufreq ip_tables xfs libcrc32c sr_mod cdrom ata_generic pata_acpi virtio_net 
virtio_console virtio_blk ata_piix libata virtio_pci virtio_ring crc32c_intel serio_raw virtio floppy
[  343.267337] CPU: 2 PID: 15846 Comm: modprobe Tainted: G           O   4.12.0-rc1+ #3
[  343.269805] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  343.271694] task: ffff92f068bed500 task.stack: ffff9ff05d4ac000
[  343.273626] RIP: 0010:__list_del_entry_valid+0x6c/0xa0
[  343.275271] RSP: 0018:ffff9ff05d4afd38 EFLAGS: 00010046
[  343.276969] RAX: 0000000000000054 RBX: ffff9ff042d09000 RCX: 0000000000000000
[  343.279206] RDX: 0000000000000000 RSI: ffff92f06f28e0a8 RDI: ffff92f06f28e0a8
[  343.281545] RBP: ffff9ff05d4afd38 R08: 00000000fffffffe R09: 0000000000000236
[  343.283737] R10: 0000000000000005 R11: 0000000000000235 R12: ffff9ff05d4afd70
[  343.285799] R13: ffff9ff042d09000 R14: 0000000000000000 R15: ffff92f066ed3c00
[  343.287859] FS:  00007f9a9c471740(0000) GS:ffff92f06f280000(0000) knlGS:0000000000000000
[  343.290175] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  343.291852] CR2: 00007f9a9b914eb0 CR3: 00000003b58cd000 CR4: 00000000000006e0
[  343.293975] Call Trace:
[  343.294751]  release_nodes+0x76/0x260
[  343.295881]  devres_release_all+0x3c/0x50
[  343.297070]  device_release_driver_internal+0x159/0x200
[  343.298598]  device_release_driver+0x12/0x20
[  343.299919]  bus_remove_device+0xfd/0x170
[  343.301133]  device_del+0x1e8/0x330
[  343.302180]  ? __getnstimeofday64+0x3c/0xd0
[  343.303412]  platform_device_del+0x28/0x90
[  343.304626]  platform_device_unregister+0x12/0x30
[  343.306065]  nfit_test_exit+0x2a/0x93b [nfit_test]
[  343.307477]  SyS_delete_module+0x171/0x250
[  343.308716]  do_syscall_64+0x67/0x150
[  343.309832]  entry_SYSCALL64_slow_path+0x25/0x25
[  343.311204] RIP: 0033:0x7f9a9b945c27
[  343.312263] RSP: 002b:00007ffef08b9728 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  343.314468] RAX: ffffffffffffffda RBX: 0000000001888490 RCX: 00007f9a9b945c27
[  343.316535] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 00000000018884f8
[  343.318615] RBP: 0000000000000000 R08: 00007f9a9bc09060 R09: 00007f9a9b9b6000
[  343.320682] R10: 00007ffef08b94b0 R11: 0000000000000206 R12: 0000000000000000
[  343.322758] R13: 0000000000000001 R14: 00000000018884f8 R15: 0000000000000000
[  343.324771] Code: 48 89 c2 48 89 fe 31 c0 48 c7 c7 48 6a a7 b9 e8 fa 37 e0 ff 0f ff 31 c0 5d c3 48 89 fe 31 c0 48 c7 c7 f8 6a a7 b9 e8 e3 37 e0 ff <0f> ff 31 c0 5d c3 48 89 fe 31 c0 48 c7 c7 b8 6a 
a7 b9 e8 cc 37 [   343.329870] ---[ end trace 7b42652be22fe7db ]---
[  343.331207] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  343.333310] IP: __list_del_entry_valid+0x29/0xa0
[  343.334618] PGD 3b5a8b067 [  343.334619] P4D 3b5a8b067 [  343.335365] PUD 3b5ad1067 [  343.336109] PMD 0 [  343.336856] [  343.337886] Oops: 0000 [#1] SMP
[  343.338809] Modules linked in: dax_pmem(O) device_dax(O) nd_pmem(O) nd_blk(O) nd_btt(O) nfit_test(O-) nfit(O) libnvdimm(O) nfit_test_iomap(O) rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache nfsd 
ppdev auth_rpcgss nfs_acl lockd parport_pc parport virtio_balloon grace sg pcspkr sunrpc i2c_piix4 i2c_core acpi_cpufreq ip_tables xfs libcrc32c sr_mod cdrom ata_generic pata_acpi virtio_net 
virtio_console virtio_blk ata_piix libata virtio_pci virtio_ring crc32c_intel serio_raw virtio floppy
[  343.350897] CPU: 2 PID: 15846 Comm: modprobe Tainted: G        W  O   4.12.0-rc1+ #3
[  343.352954] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  343.354403] task: ffff92f068bed500 task.stack: ffff9ff05d4ac000
[  343.355876] RIP: 0010:__list_del_entry_valid+0x29/0xa0
[  343.357213] RSP: 0018:ffff9ff05d4afd38 EFLAGS: 00010007
[  343.358515] RAX: 0000000000000000 RBX: 0000000000000000 RCX: dead000000000200
[  343.360275] RDX: 0000000000000000 RSI: ffff9ff05d4afd70 RDI: ffff9ff042d09000
[  343.362026] RBP: ffff9ff05d4afd38 R08: 00000000fffffffe R09: ffff9ff042d09000
[  343.363830] R10: 0000000000000005 R11: ffff92f06f5ba920 R12: ffff9ff05d4afd70
[  343.365498] R13: 0000000000000000 R14: 0000000000000000 R15: ffff92f066ed3c00
[  343.367137] FS:  00007f9a9c471740(0000) GS:ffff92f06f280000(0000) knlGS:0000000000000000
[  343.369017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  343.370362] CR2: 0000000000000000 CR3: 00000003b58cd000 CR4: 00000000000006e0
[  343.372108] Call Trace:
[  343.372700]  release_nodes+0x76/0x260
[  343.373560]  devres_release_all+0x3c/0x50
[  343.374532]  device_release_driver_internal+0x159/0x200
[  343.375771]  device_release_driver+0x12/0x20
[  343.376834]  bus_remove_device+0xfd/0x170
[  343.377799]  device_del+0x1e8/0x330
[  343.378670]  ? __getnstimeofday64+0x3c/0xd0
[  343.379657]  platform_device_del+0x28/0x90
[  343.380687]  platform_device_unregister+0x12/0x30
[  343.381796]  nfit_test_exit+0x2a/0x93b [nfit_test]
[  343.382926]  SyS_delete_module+0x171/0x250
[  343.383904]  do_syscall_64+0x67/0x150
[  343.384779]  entry_SYSCALL64_slow_path+0x25/0x25
[  343.385870] RIP: 0033:0x7f9a9b945c27
[  343.386716] RSP: 002b:00007ffef08b9728 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  343.388484] RAX: ffffffffffffffda RBX: 0000000001888490 RCX: 00007f9a9b945c27
[  343.390217] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 00000000018884f8
[  343.391875] RBP: 0000000000000000 R08: 00007f9a9bc09060 R09: 00007f9a9b9b6000
[  343.393619] R10: 00007ffef08b94b0 R11: 0000000000000206 R12: 0000000000000000
[  343.395291] R13: 0000000000000001 R14: 00000000018884f8 R15: 0000000000000000
[  343.397010] Code: 00 00 55 48 8b 07 48 b9 00 01 00 00 00 00 ad de 48 8b 57 08 48 89 e5 48 39 c8 74 27 48 b9 00 02 00 00 00 00 ad de 48 39 ca 74 60 <48> 8b 12 48 39 d7 75 41 48 8b 50 08 48 39 d7 75 
21 b8 01 00 00 [   343.401444] RIP: __list_del_entry_valid+0x29/0xa0 RSP: ffff9ff05d4afd38
[  343.402972] CR2: 0000000000000000
[  343.403774] ---[ end trace 7b42652be22fe7dc ]---
[  343.404872] Kernel panic - not syncing: Fatal exception
[  343.438096] Kernel Offset: 0x38000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  343.440605] ---[ end Kernel panic - not syncing: Fatal exception



-- 
Yasunori Goto <y-goto@jp.fujitsu.com>





_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
