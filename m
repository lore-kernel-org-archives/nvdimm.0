Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail03.adl2.internode.on.net (ipmail03.adl2.internode.on.net
 [150.101.137.141])
 by ml01.01.org (Postfix) with ESMTP id 85399203BA4F0
 for <linux-nvdimm@lists.01.org>; Sun,  3 Jun 2018 17:27:34 -0700 (PDT)
Date: Mon, 4 Jun 2018 10:25:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180604002525.GI10363@dastard>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com>
 <20180531191332.GB7825@magnolia> <20180601012657.GQ10363@dastard>
 <CAPcyv4g6dv9sG9dR-iY+aEfSi2r3ey1dXGbX-nexKsN72t0QMw@mail.gmail.com>
 <20180601022418.GR10363@dastard>
 <CAPcyv4iXTsxmQgjoLs2E_8QrLHrFOV_58T7UYf0zPJuB2744qQ@mail.gmail.com>
 <20180603222038.GS10363@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180603222038.GS10363@dastard>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 04, 2018 at 08:20:38AM +1000, Dave Chinner wrote:
> On Thu, May 31, 2018 at 09:02:52PM -0700, Dan Williams wrote:
> > On Thu, May 31, 2018 at 7:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Thu, May 31, 2018 at 06:57:33PM -0700, Dan Williams wrote:
> > >> > FWIW, XFS+DAX used to just work on this setup (I hadn't even
> > >> > installed ndctl until this morning!) but after changing the kernel
> > >> > it no longer works. That would make it a regression, yes?
> 
> [....]
> 
> > >> I suspect your kernel does not have CONFIG_ZONE_DEVICE enabled which
> > >> has the following dependencies:
> > >>
> > >>         depends on MEMORY_HOTPLUG
> > >>         depends on MEMORY_HOTREMOVE
> > >>         depends on SPARSEMEM_VMEMMAP
> > >
> > > Filesystem DAX now has a dependency on memory hotplug?
> 
> [....]
> 
> > > OK, works now I've found the magic config incantantions to turn
> > > everything I now need on.
> 
> By enabling these options, my test VM now has a ~30s pause in the
> boot very soon after the nvdimm subsystem is initialised.
> 
> [    1.523718] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.550353] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    1.552175] Non-volatile memory driver v1.3
> [    2.332045] tsc: Refined TSC clocksource calibration: 2199.909 MHz
> [    2.333280] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb5dcd4620, max_idle_ns: 440795264143 ns
> [   37.217453] brd: module loaded
> [   37.225423] loop: module loaded
> [   37.228441] virtio_blk virtio2: [vda] 10485760 512-byte logical blocks (5.37 GB/5.00 GiB)
> [   37.245418] virtio_blk virtio3: [vdb] 146800640 512-byte logical blocks (75.2 GB/70.0 GiB)
> [   37.255794] virtio_blk virtio4: [vdc] 1073741824000 512-byte logical blocks (550 TB/500 TiB)
> [   37.265403] nd_pmem namespace1.0: unable to guarantee persistence of writes
> [   37.265618] nd_pmem namespace0.0: unable to guarantee persistence of writes
> 
> The system does not appear to be consuming CPU, but it is blocking
> NMIs so I can't get a CPU trace. For a VM that I rely on booting in
> a few seconds because I reboot it tens of times a day, this is a
> problem....

And when I turn on KASAN, the kernel fails to boot to a login prompt
because:

[   15.363583] Non-volatile memory driver v1.3
[   22.286787] brd: module loaded
[   22.347054] loop: module loaded
[   22.352158] virtio_blk virtio2: [vda] 10485760 512-byte logical blocks (5.37 GB/5.00 GiB)
[   22.373921] virtio_blk virtio3: [vdb] 146800640 512-byte logical blocks (75.2 GB/70.0 GiB)
[   22.394363] virtio_blk virtio4: [vdc] 1073741824000 512-byte logical blocks (550 TB/500 TiB)
[   22.410145] Loading iSCSI transport class v2.0-870.
[   22.411506] nd_pmem namespace0.0: unable to guarantee persistence of writes
[   22.412777] iscsi: registered transport (tcp)
[   22.412780] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   22.412806] nd_pmem namespace1.0: unable to guarantee persistence of writes
[   22.413090] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   22.421485] kworker/u33:4 (1087) used greatest stack depth: 27704 bytes left
[   22.430664] scsi host0: ata_piix
[   22.711000] BUG: unable to handle kernel paging request at ffffed0078000000
[   22.712225] PGD 13ffd1067 P4D 13ffd1067 PUD 1247d2067 PMD 0 
[   22.713180] Oops: 0000 [#1] PREEMPT SMP KASAN
[   22.713884] CPU: 8 PID: 168 Comm: kworker/u33:3 Not tainted 4.17.0-rc7-dgc+ #549
[   22.714480] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[   22.714480] Workqueue: events_unbound async_run_entry_fn
[   22.714480] RIP: 0010:check_memory_region+0xdd/0x190
[   22.714480] RSP: 0000:ffff88007a1aec08 EFLAGS: 00010202
[   22.714480] RAX: ffffed0078000000 RBX: ffff8803c0000fff RCX: ffffffff81d41a12
[   22.714480] RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff8803c0000000
[   22.714480] RBP: ffffed0078000200 R08: 0000000000000200 R09: 0000000000000040
[   22.714480] R10: 0000000000000200 R11: ffffed00780001ff R12: ffff8803c0000000
[   22.714480] R13: 000000000192f3f0 R14: 0000000000000000 R15: 0000000000000000
[   22.714480] FS:  0000000000000000(0000) GS:ffff88007f700000(0000) knlGS:0000000000000000
[   22.714480] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.714480] CR2: ffffed0078000000 CR3: 000000000300f001 CR4: 00000000000606e0
[   22.714480] Call Trace:
[   22.714480]  memcpy+0x1f/0x50
[   22.714480]  pmem_do_bvec+0x182/0x350
[   22.714480]  ? pmem_release_queue+0x10/0x10
[   22.714480]  ? __blkdev_get+0x484/0x7b0
[   22.714480]  ? blkdev_get+0x1e6/0x4f0
[   22.714480]  ? __device_add_disk+0x62a/0x780
[   22.714480]  ? pmem_attach_disk+0x580/0x7b0
[   22.714480]  ? do_raw_spin_unlock+0xa4/0x130
[   22.714480]  ? _raw_spin_unlock+0xa/0x20
[   22.714480]  ? create_task_io_context+0x195/0x1d0
[   22.714480]  ? generic_make_request_checks+0x33a/0x7a0
[   22.714480]  pmem_make_request+0x1d9/0x3c0
[   22.714480]  generic_make_request+0x2d8/0x6c0
[   22.714480]  ? blk_plug_queued_count+0xb0/0xb0
[   22.714480]  ? memset+0x1f/0x40
[   22.714480]  ? submit_bio+0xc8/0x1e0
[   22.714480]  submit_bio+0xc8/0x1e0
[   22.714480]  ? direct_make_request+0x150/0x150
[   22.714480]  ? alloc_buffer_head+0x3c/0x80
[   22.714480]  ? alloc_page_buffers+0x7f/0x120
[   22.714480]  ? __rcu_read_unlock+0x66/0x80
[   22.714480]  ? guard_bio_eod+0xa9/0x1e0
[   22.714480]  submit_bh_wbc.isra.41+0x257/0x280
[   22.714480]  ? end_buffer_read_nobh+0x10/0x10
[   22.714480]  block_read_full_page+0x307/0x470
[   22.714480]  ? block_llseek+0x80/0x80
[   22.714480]  ? block_page_mkwrite+0x150/0x150
[   22.714480]  ? add_to_page_cache_lru+0xd7/0x160
[   22.714480]  ? add_to_page_cache_locked+0x10/0x10
[   22.714480]  ? policy_node+0x56/0x60
[   22.714480]  do_read_cache_page+0x3e3/0x730
[   22.714480]  ? bus_probe_device+0xf3/0x120
[   22.714480]  ? async_run_entry_fn+0x75/0x1e0
[   22.714480]  ? blkdev_writepages+0x10/0x10
[   22.714480]  ? filemap_fault+0x940/0x940
[   22.714480]  ? unwind_next_frame+0x8cf/0x940
[   22.714480]  ? stack_access_ok+0x35/0x80
[   22.714480]  ? __alloc_pages_nodemask+0x18e/0x320
[   22.714480]  ? __alloc_pages_slowpath+0x12b0/0x12b0
[   22.714480]  read_dev_sector+0x61/0x120
[   22.753746] scsi host1: ata_piix
[   22.753296]  read_lba+0x260/0x2d0
[   22.753296]  ? sgi_partition+0x3c0/0x3c0
[   22.755203] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc100 irq 14
[   22.753296]  ? do_raw_spin_unlock+0xa4/0x130
[   22.756637] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc108 irq 15
[   22.753296]  ? is_gpt_valid.part.5+0x3c0/0x3c0
[   22.758498]  efi_partition+0x252/0xb40
[   22.758498]  ? __inc_numa_state+0x19/0x90
[   22.758498]  ? kasan_unpoison_shadow+0x30/0x40
[   22.758498]  ? vzalloc+0x58/0x60
[   22.758498]  ? rescan_partitions+0x133/0x510
[   22.758498]  ? is_gpt_valid.part.5+0x3c0/0x3c0
[   22.758498]  ? kasan_unpoison_shadow+0x30/0x40
[   22.764064]  ? get_page_from_freelist+0x16dd/0x1a50
[   22.764064]  ? widen_string+0x25/0x100
[   22.766067]  ? widen_string+0x25/0x100
[   22.766282] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   22.766575]  ? string+0xc4/0xf0
[   22.766575]  ? format_decode+0x79/0x4b0
[   22.766575]  ? memcpy+0x34/0x50
[   22.770062] serio: i8042 KBD port at 0x60,0x64 irq 1
[   22.766575]  ? vsnprintf+0xf2/0x7d0
[   22.771264] serio: i8042 AUX port at 0x60,0x64 irq 12
[   22.766575]  ? num_to_str+0x160/0x160
[   22.772750]  ? __might_sleep+0x31/0xd0
[   22.773202] mousedev: PS/2 mouse device common for all mice
[   22.772750]  ? snprintf+0x8f/0xc0
[   22.772750]  ? vscnprintf+0x30/0x30
[   22.772750]  ? is_gpt_valid.part.5+0x3c0/0x3c0
[   22.776149] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   22.776242]  ? check_partition+0x18f/0x310
[   22.776717] rtc_cmos 00:00: RTC can wake from S4
[   22.778723] rtc_cmos 00:00: registered as rtc0
[   22.779023]  check_partition+0x18f/0x310
[   22.779023]  rescan_partitions+0x133/0x510
[   22.780706] rtc_cmos 00:00: nvmem registration failed
[   22.779023]  ? __might_sleep+0x31/0xd0
[   22.782618] rtc_cmos 00:00: alarms up to one day, y3k, 114 bytes nvram, hpet irqs
[   22.779023]  ? kmem_cache_alloc+0xdd/0x5b0
[   22.779023]  ? ___might_sleep+0x7c/0x1a0
[   22.786069]  ? bd_set_size+0x104/0x160
[   22.786069]  __blkdev_get+0x484/0x7b0
[   22.786069]  ? bd_set_size+0x160/0x160
[   22.786069]  ? map_id_range_down+0x150/0x170
[   22.788981] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) initialised: dm-devel@redhat.com
[   22.786069]  ? free_user_ns+0x170/0x170
[   22.789183]  blkdev_get+0x1e6/0x4f0
[   22.789183]  ? __raw_spin_lock_init+0x42/0x50
[   22.789183]  ? __wake_up_bit+0x78/0xc0
[   22.792867] device-mapper: raid: Loading target version 1.13.2
[   22.789183]  ? __blkdev_get+0x7b0/0x7b0
[   22.789183]  ? refcount_sub_and_test+0xa7/0x120
[   22.789183]  ? refcount_inc+0x30/0x30
[   22.795220]  ? do_raw_spin_lock+0x9b/0x130
[   22.795991] hidraw: raw HID events driver (C) Jiri Kosina
[   22.796068]  ? do_raw_spin_unlock+0xa4/0x130
[   22.796068]  ? kobject_put+0x2d/0x100
[   22.796068]  __device_add_disk+0x62a/0x780
[   22.796068]  ? bdget_disk+0x50/0x50
[   22.796068]  ? alloc_dax+0x222/0x2e0
[   22.800041]  ? kill_dax+0xc0/0xc0
[   22.800041]  ? mutex_lock+0x2a/0x50
[   22.800041]  ? nvdimm_badblocks_populate+0x56/0x1d0
[   22.800041]  ? __raw_spin_lock_init+0x42/0x50
[   22.800041]  pmem_attach_disk+0x580/0x7b0
[   22.803358] oprofile: using NMI interrupt.
[   22.800041]  ? nd_pmem_notify+0x240/0x240
[   22.804217]  ? nd_dax_probe+0xef/0x110
[   22.805177] NET: Registered protocol family 17
[   22.804217]  nvdimm_bus_probe+0x76/0xe0
[   22.804217]  driver_probe_device+0x31d/0x450
[   22.806975] sctp: Hash tables configured (bind 128/128)
[   22.804217]  ? __driver_attach+0xd0/0xd0
[   22.808773] Key type dns_resolver registered
[   22.804217]  bus_for_each_drv+0xd8/0x130
[   22.809534] Key type ceph registered
[   22.804217]  ? subsys_find_device_by_id+0x1e0/0x1e0
[   22.804217]  ? do_raw_spin_unlock+0xa4/0x130
[   22.811472]  __device_attach+0x14d/0x1b0
[   22.812223]  ? device_bind_driver+0x70/0x70
[   22.812768] libceph: loaded (mon/osd proto 15/24)
[   22.812223]  ? kobject_uevent_env+0x15d/0x7f0
[   22.812223]  bus_probe_device+0xf3/0x120
[   22.812223]  device_add+0x696/0xa20
[   22.812223]  ? device_private_init+0xc0/0xc0
[   22.816158]  ? __wake_up_common_lock+0xcb/0x110
[   22.816158]  ? __wake_up_common+0x240/0x240
[   22.816158]  ? nd_async_device_unregister+0x30/0x30
[   22.816158]  nd_async_device_register+0xe/0x40
[   22.816158]  async_run_entry_fn+0x75/0x1e0
[   22.819536]  process_one_work+0x349/0x6d0
[   22.819536]  worker_thread+0x74/0x5c0
[   22.819536]  ? process_one_work+0x6d0/0x6d0
[   22.819536]  kthread+0x1b7/0x1e0
[   22.819536]  ? __kthread_bind_mask+0x70/0x70
[   22.819536]  ret_from_fork+0x24/0x30
[   22.819536] Code: 01 74 0b 41 80 38 00 74 f0 4d 85 c0 75 56 4c 01 c8 49 89 e8 49 29 c0 4d 8d 48 07 4d 85 c0 4d 0f 49 c8 49 c1 f9 03 45 85 c9 74 5b <48> 83 38 00 75 18 45 8d 41 ff 4e 8d 44 c0 08 48 8 
[   22.819536] RIP: check_memory_region+0xdd/0x190 RSP: ffff88007a1aec08
[   22.819536] CR2: ffffed0078000000
[   22.819536] ---[ end trace 2d3ad661d958a6e8 ]---
[   22.819536] BUG: sleeping function called from invalid context at ./include/linux/percpu-rwsem.h:34
[   22.819536] in_atomic(): 1, irqs_disabled(): 1, pid: 168, name: kworker/u33:3
[   22.819536] CPU: 8 PID: 168 Comm: kworker/u33:3 Tainted: G    B D           4.17.0-rc7-dgc+ #549
[   22.819536] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[   22.819536] Workqueue: events_unbound async_run_entry_fn
[   22.819536] Call Trace:
[   22.819536]  dump_stack+0x9a/0xeb
[   22.819536]  ___might_sleep+0x169/0x1a0
[   22.819536]  exit_signals+0x67/0x310
[   22.819536]  ? get_signal+0x860/0x860
[   22.819536]  ? __wake_up_common+0x240/0x240
[   22.819536]  ? nd_async_device_unregister+0x30/0x30
[   22.819536]  ? blocking_notifier_call_chain+0x24/0x70
[   22.819536]  do_exit+0x14d/0x1370
[   22.819536]  ? is_current_pgrp_orphaned+0x60/0x60
[   22.819536]  ? worker_thread+0x74/0x5c0
[   22.819536]  ? process_one_work+0x6d0/0x6d0
[   22.819536]  ? kthread+0x1b7/0x1e0
[   22.819536]  rewind_stack_do_exit+0x17/0x20
[   22.819536] ==================================================================
[   22.819536] BUG: KASAN: stack-out-of-bounds in widen_string+0x25/0x100
[   22.819536] Read of size 8 at addr ffff88007a1afae0 by task kworker/u33:3/168
[   22.819536] 
[   22.819536] CPU: 8 PID: 168 Comm: kworker/u33:3 Tainted: G      D           4.17.0-rc7-dgc+ #549
[   22.819536] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[   22.819536] Workqueue: events_unbound async_run_entry_fn
[   22.819536] Call Trace:
[   22.819536]  dump_stack+0x9a/0xeb
[   22.819536]  ? widen_string+0x25/0x100
[   22.819536]  print_address_description+0x7e/0x290
[   22.819536]  ? widen_string+0x25/0x100
[   22.819536]  kasan_report+0x237/0x360
[   22.819536]  widen_string+0x25/0x100
[   22.819536]  string+0xc4/0xf0
[   22.819536]  vsnprintf+0x2a8/0x7d0
[   22.819536]  ? num_to_str+0x160/0x160
[   22.819536]  ? subsys_find_device_by_id+0x1e0/0x1e0
[   22.819536]  ? do_raw_spin_unlock+0xa4/0x130
[   22.819536]  vscnprintf+0x9/0x30
[   22.819536]  vprintk_emit+0x86/0x400
[   22.819536]  printk+0x94/0xb0
[   22.819536]  ? cpumask_weight.constprop.27+0x1e/0x1e
[   22.819536]  ? bus_probe_device+0xf3/0x120
[   22.819536]  ? ___might_sleep+0xa7/0x1a0
[   22.819536]  ___might_sleep+0xee/0x1a0
[   22.819536]  exit_signals+0x67/0x310
[   22.819536]  ? get_signal+0x860/0x860
[   22.819536]  ? __wake_up_common+0x240/0x240
[   22.819536]  ? nd_async_device_unregister+0x30/0x30
[   22.819536]  ? blocking_notifier_call_chain+0x24/0x70
[   22.819536]  do_exit+0x14d/0x1370
[   22.819536]  ? is_current_pgrp_orphaned+0x60/0x60
[   22.819536]  ? worker_thread+0x74/0x5c0
[   22.819536]  ? process_one_work+0x6d0/0x6d0
[   22.819536]  ? kthread+0x1b7/0x1e0
[   22.819536]  rewind_stack_do_exit+0x17/0x20
[   22.819536] 
[   22.819536] The buggy address belongs to the page:
[   22.819536] page:ffffea0001ab5e48 count:0 mapcount:0 mapping:0000000000000000 index:0x0
[   22.819536] flags: 0xfffffc0000000()
[   22.819536] raw: 000fffffc0000000 0000000000000000 0000000000000000 00000000ffffffff
[   22.819536] raw: ffffea0001ab5e68 ffffea0001ab5e68 0000000000000000
[   22.819536] page dumped because: kasan: bad access detected
[   22.819536] 
[   22.819536] Memory state around the buggy address:
[   22.819536]  ffff88007a1af980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   22.819536]  ffff88007a1afa00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f1
[   22.819536] >ffff88007a1afa80: f1 f1 f1 00 00 00 00 00 00 00 00 f3 f3 f3 f3 00
[   22.819536]                                                        ^
[   22.819536]  ffff88007a1afb00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   22.819536]  ffff88007a1afb80: 00 00 f1 f1 f1 f1 00 f2 f2 f2 f3 f3 f3 f3 f3 f3
[   22.819536] ==================================================================
[   22.882914] hpet1: lost 5 rtc interrupts
[   22.883636] note: kworker/u33:3[168] exited with preempt_count 1
[   22.885240] kworker/u33:3 (168) used greatest stack depth: 24768 bytes left
[   22.887136] BUG: unable to handle kernel paging request at ffffed00c0000000
[   22.888327] PGD 13ffd1067 P4D 13ffd1067 PUD 0 
[   22.889043] Oops: 0000 [#2] PREEMPT SMP KASAN
[   22.889747] CPU: 12 PID: 159 Comm: kworker/u33:2 Tainted: G    B D W         4.17.0-rc7-dgc+ #549
[   22.890253] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[   22.890253] Workqueue: events_unbound async_run_entry_fn
[   22.890253] RIP: 0010:check_memory_region+0xdd/0x190
[   22.890253] RSP: 0000:ffff88007a16ec08 EFLAGS: 00010202
[   22.890253] RAX: ffffed00c0000000 RBX: ffff880600000fff RCX: ffffffff81d41a12
[   22.890253] RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff880600000000
[   22.890253] RBP: ffffed00c0000200 R08: 0000000000000200 R09: 0000000000000040
[   22.890253] R10: 0000000000000200 R11: ffffed00c00001ff R12: ffff880600000000
[   22.890253] R13: 0000000001927f90 R14: 0000000000000000 R15: 0000000000000000
[   22.890253] FS:  0000000000000000(0000) GS:ffff88007f780000(0000) knlGS:0000000000000000
[   22.890253] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.890253] CR2: ffffed00c0000000 CR3: 000000000300f001 CR4: 00000000000606e0
[   22.890253] Call Trace:
[   22.890253]  memcpy+0x1f/0x50
[   22.890253]  pmem_do_bvec+0x182/0x350
[   22.890253]  ? pmem_release_queue+0x10/0x10
[   22.890253]  ? blkdev_get+0x1e6/0x4f0
[   22.890253]  ? __device_add_disk+0x62a/0x780
[   22.890253]  ? pmem_attach_disk+0x580/0x7b0
[   22.890253]  ? do_raw_spin_unlock+0xa4/0x130
[   22.890253]  ? _raw_spin_unlock+0xa/0x20
[   22.890253]  ? create_task_io_context+0x195/0x1d0
[   22.890253]  ? generic_make_request_checks+0x33a/0x7a0
[   22.890253]  pmem_make_request+0x1d9/0x3c0
[   22.890253]  generic_make_request+0x2d8/0x6c0
[   22.890253]  ? blk_plug_queued_count+0xb0/0xb0
[   22.890253]  ? memset+0x1f/0x40
[   22.890253]  ? submit_bio+0xc8/0x1e0
[   22.890253]  submit_bio+0xc8/0x1e0
[   22.890253]  ? direct_make_request+0x150/0x150
[   22.890253]  ? alloc_buffer_head+0x3c/0x80
[   22.890253]  ? alloc_page_buffers+0x7f/0x120
[   22.890253]  ? __rcu_read_unlock+0x66/0x80
[   22.917466] ata2.01: NODEV after polling detection
[   22.890253]  ? guard_bio_eod+0xa9/0x1e0
[   22.919184] ata1.01: NODEV after polling detection
[   22.890253]  submit_bh_wbc.isra.41+0x257/0x280
[   22.920719] ata2.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
[   22.890253]  ? end_buffer_read_nobh+0x10/0x10
[   22.922324] ata1.00: ATA-7: QEMU HARDDISK, 2.5+, max UDMA/100
[   22.890253]  block_read_full_page+0x307/0x470
[   22.923573] ata1.00: 20971520 sectors, multi 16: LBA48 
[   22.890253]  ? block_llseek+0x80/0x80
[   22.890253]  ? block_page_mkwrite+0x150/0x150
[   22.890253]  ? add_to_page_cache_lru+0xd7/0x160
[   22.890253]  ? add_to_page_cache_locked+0x10/0x10
[   22.890253]  ? policy_node+0x56/0x60
[   22.926515] ata2.00: configured for MWDMA2
[   22.890253]  do_read_cache_page+0x3e3/0x730
[   22.927886] ata1.00: configured for MWDMA2
[   22.890253]  ? bus_probe_device+0xf3/0x120
[   22.890253]  ? async_run_entry_fn+0x75/0x1e0
[   22.890253]  ? blkdev_writepages+0x10/0x10
[   22.890253]  ? filemap_fault+0x940/0x940
[   22.890253]  ? unwind_next_frame+0x8cf/0x940
[   22.890253]  ? stack_access_ok+0x35/0x80
[   22.890253]  ? deref_stack_reg+0x7f/0xb0
[   22.890253]  ? __read_once_size_nocheck.constprop.6+0x10/0x10
[   22.890253]  ? unwind_get_return_address_ptr+0x50/0x50
[   22.890253]  ? save_stack+0x89/0xb0
[   22.890253]  ? __orc_find+0x6b/0xc0
[   22.890253]  ? unwind_next_frame+0xc8/0x940
[   22.890253]  read_dev_sector+0x61/0x120
[   22.890253]  read_lba+0x260/0x2d0
[   22.890253]  ? sgi_partition+0x3c0/0x3c0
[   22.890253]  ? __save_stack_trace+0x73/0xd0
[   22.890253]  ? is_gpt_valid.part.5+0x3c0/0x3c0
[   22.890253]  efi_partition+0x252/0xb40
[   22.890253]  ? __inc_numa_state+0x19/0x90
[   22.890253]  ? kasan_unpoison_shadow+0x30/0x40
[   22.890253]  ? is_gpt_valid.part.5+0x3c0/0x3c0
[   22.890253]  ? kasan_unpoison_shadow+0x30/0x40
[   22.890253]  ? get_page_from_freelist+0x16dd/0x1a50
[   22.890253]  ? widen_string+0x25/0x100
[   22.890253]  ? widen_string+0x25/0x100
[   22.890253]  ? string+0xc4/0xf0
[   22.890253]  ? format_decode+0x79/0x4b0
[   22.890253]  ? memcpy+0x34/0x50
[   22.890253]  ? vsnprintf+0xf2/0x7d0
[   22.890253]  ? num_to_str+0x160/0x160
[   22.890253]  ? __might_sleep+0x31/0xd0
[   22.890253]  ? snprintf+0x8f/0xc0
[   22.890253]  ? vscnprintf+0x30/0x30
[   22.890253]  ? is_gpt_valid.part.5+0x3c0/0x3c0
[   22.890253]  ? check_partition+0x18f/0x310
[   22.890253]  check_partition+0x18f/0x310
[   22.890253]  rescan_partitions+0x133/0x510
[   22.890253]  ? __might_sleep+0x31/0xd0
[   22.890253]  ? ___might_sleep+0x7c/0x1a0
[   22.890253]  ? bd_set_size+0x104/0x160
[   22.890253]  __blkdev_get+0x484/0x7b0
[   22.890253]  ? __raw_spin_lock_init+0x42/0x50
[   22.890253]  ? bd_set_size+0x160/0x160
[   22.890253]  ? map_id_range_down+0x150/0x170
[   22.890253]  ? free_user_ns+0x170/0x170
[   22.890253]  blkdev_get+0x1e6/0x4f0
[   22.890253]  ? __raw_spin_lock_init+0x42/0x50
[   22.890253]  ? __wake_up_bit+0x78/0xc0
[   22.890253]  ? __blkdev_get+0x7b0/0x7b0
[   22.890253]  ? refcount_sub_and_test+0xa7/0x120
[   22.890253]  ? refcount_inc+0x30/0x30
[   22.890253]  ? do_raw_spin_lock+0x9b/0x130
[   22.890253]  ? do_raw_spin_unlock+0xa4/0x130
[   22.890253]  ? kobject_put+0x2d/0x100
[   22.890253]  __device_add_disk+0x62a/0x780
[   22.890253]  ? bdget_disk+0x50/0x50
[   22.890253]  ? alloc_dax+0x222/0x2e0
[   22.890253]  ? kill_dax+0xc0/0xc0
[   22.890253]  ? mutex_lock+0x2a/0x50
[   22.890253]  ? nvdimm_badblocks_populate+0x56/0x1d0
[   22.890253]  ? __raw_spin_lock_init+0x42/0x50
[   22.890253]  pmem_attach_disk+0x580/0x7b0
[   22.890253]  ? nd_pmem_notify+0x240/0x240
[   22.890253]  ? nd_dax_probe+0xef/0x110
[   22.890253]  nvdimm_bus_probe+0x76/0xe0
[   22.890253]  driver_probe_device+0x31d/0x450
[   22.890253]  ? __driver_attach+0xd0/0xd0
[   22.890253]  bus_for_each_drv+0xd8/0x130
[   22.890253]  ? subsys_find_device_by_id+0x1e0/0x1e0
[   22.890253]  ? do_raw_spin_unlock+0xa4/0x130
[   22.890253]  __device_attach+0x14d/0x1b0
[   22.890253]  ? device_bind_driver+0x70/0x70
[   22.890253]  ? kobject_uevent_env+0x15d/0x7f0
[   22.890253]  bus_probe_device+0xf3/0x120
[   22.890253]  device_add+0x696/0xa20
[   22.890253]  ? device_private_init+0xc0/0xc0
[   22.890253]  ? finish_task_switch+0xf8/0x3c0
[   22.890253]  ? nd_async_device_unregister+0x30/0x30
[   22.890253]  nd_async_device_register+0xe/0x40
[   22.890253]  async_run_entry_fn+0x75/0x1e0
[   22.890253]  process_one_work+0x349/0x6d0
[   22.890253]  worker_thread+0x74/0x5c0
[   22.890253]  ? process_one_work+0x6d0/0x6d0
[   22.890253]  kthread+0x1b7/0x1e0
[   22.890253]  ? __kthread_bind_mask+0x70/0x70
[   22.890253]  ret_from_fork+0x24/0x30
[   22.890253] Code: 01 74 0b 41 80 38 00 74 f0 4d 85 c0 75 56 4c 01 c8 49 89 e8 49 29 c0 4d 8d 48 07 4d 85 c0 4d 0f 49 c8 49 c1 f9 03 45 85 c9 74 5b <48> 83 38 00 75 18 45 8d 41 ff 4e 8d 44 c0 08 48 8 
[   22.890253] RIP: check_memory_region+0xdd/0x190 RSP: ffff88007a16ec08
[   22.890253] CR2: ffffed00c0000000
[   22.890253] ---[ end trace 2d3ad661d958a6e9 ]---

-Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
