Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E1E72097FAB7
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 16:53:15 -0700 (PDT)
Date: Mon, 30 Jul 2018 19:53:12 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Help trying to use /dev/pmem for dax debugging?
Message-ID: <20180730235312.GA5089@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>
Cc: linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In newer kernels, it looks like you can't use /dev/pmem0 for DAX
unless it's marked as being DAX capable.  This appears to require
CONFIG_NVDIMM_PFN.  But when I tried to build a kernel with that
configured, I get the following BUG:

[    0.000000] Linux version 4.18.0-rc4-xfstests-00031-g7c2d77aa7d80 (tytso@cwcc) (gcc version 7.3.0 (Debian 7.3.0-27)) #460 SMP Mon Jul 30 19:38:44 EDT 2018
[    0.000000] Command line: systemd.show_status=auto systemd.log_level=crit root=/dev/vda console=ttyS0,115200 cmd=maint fstesttz=America/New_York fstesttyp=ext4 fstestapi=1.4 memmap=4G!9G memmap=9G!14G
	...
[   16.544707] BUG: unable to handle kernel paging request at ffffed0048000000
[   16.546132] PGD 6bffe9067 P4D 6bffe9067 PUD 6bfbec067 PMD 0 
[   16.547174] Oops: 0000 [#1] SMP KASAN PTI
[   16.547923] CPU: 0 PID: 81 Comm: kworker/u8:1 Not tainted 4.18.0-rc4-xfstests-00031-g7c2d77aa7d80 #460
[   16.549706] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/2014
[   16.551285] Workqueue: events_unbound async_run_entry_fn
[   16.552309] RIP: 0010:check_memory_region+0xdd/0x190
[   16.553264] Code: 74 0b 41 80 38 00 74 f0 4d 85 c0 75 56 4c 01 c8 49 89 e8 49 29 c0 4d 8d 48 07 4d 85 c0 4d 0f 49 c8 49 c1 f9 03 45 85 c9 74 5b <48> 83 38 00 75 18 45 8d 41 ff 4e 8d 44 c0 08 48 83 c0 08 49 39 c0 
[   16.556872] RSP: 0000:ffff8806469b6bb8 EFLAGS: 00010202
[   16.557861] RAX: ffffed0048000000 RBX: ffff880240000fff RCX: ffffffffa8a2f9bc
[   16.559500] RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff880240000000
[   16.561255] RBP: ffffed0048000200 R08: 0000000000000200 R09: 0000000000000040
[   16.563245] R10: 0000000000000200 R11: ffffed00480001ff R12: ffff880240000000
[   16.565186] R13: dffffc0000000000 R14: fffffbfff5361562 R15: ffffea0015d34bd8
[   16.567119] FS:  0000000000000000(0000) GS:ffff88064b600000(0000) knlGS:0000000000000000
[   16.569331] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.570927] CR2: ffffed0048000000 CR3: 0000000212416001 CR4: 0000000000360ef0
[   16.572839] Call Trace:
[   16.573493]  memcpy+0x1f/0x50
[   16.574050]  pmem_do_bvec+0x1dc/0x670
[   16.575086]  ? pmem_release_pgmap_ops+0x10/0x10
[   16.576392]  ? rcu_read_lock_sched_held+0x110/0x130
[   16.577785]  ? generic_make_request_checks+0xf87/0x1520
[   16.579310]  ? do_read_cache_page+0x219/0x8b0
[   16.580551]  pmem_make_request+0x306/0x9e0
[   16.581714]  generic_make_request+0x565/0xd30
[   16.582947]  ? mempool_alloc+0xf7/0x2d0
[   16.584032]  ? blk_plug_queued_count+0x150/0x150
[   16.585339]  ? sched_clock_cpu+0x18/0x180
[   16.586473]  ? debug_show_all_locks+0x2d0/0x2d0
[   16.587803]  ? submit_bio+0x139/0x3a0
[   16.588864]  submit_bio+0x139/0x3a0
[   16.589896]  ? lock_downgrade+0x5e0/0x5e0
[   16.591031]  ? lock_acquire+0x106/0x3e0
[   16.592123]  ? direct_make_request+0x1e0/0x1e0
[   16.593428]  ? guard_bio_eod+0x19d/0x570
[   16.594547]  submit_bh_wbc.isra.12+0x409/0x5a0
[   16.595804]  block_read_full_page+0x526/0x800
[   16.597032]  ? block_llseek+0xd0/0xd0
[   16.598072]  ? block_page_mkwrite+0x270/0x270
[   16.599317]  ? add_to_page_cache_lru+0x119/0x210
[   16.600621]  ? add_to_page_cache_locked+0x40/0x40
[   16.601943]  ? pagecache_get_page+0x44/0x6b0
[   16.603153]  do_read_cache_page+0x219/0x8b0
[   16.604338]  ? blkdev_writepages+0x10/0x10
[   16.605500]  read_dev_sector+0xbb/0x390
[   16.606606]  read_lba.isra.0+0x2f0/0x5c0
[   16.607735]  ? compare_gpts+0x1500/0x1500
[   16.608870]  ? efi_partition+0x2bc/0x1bb0
[   16.610021]  ? rcu_read_lock_sched_held+0x110/0x130
[   16.611387]  efi_partition+0x2e6/0x1bb0
[   16.612468]  ? __isolate_free_page+0x530/0x530
[   16.613717]  ? rcu_read_lock_sched_held+0x110/0x130
[   16.615103]  ? is_gpt_valid.part.1+0xdc0/0xdc0
[   16.616396]  ? string+0x14c/0x220
[   16.617344]  ? string+0x14c/0x220
[   16.618285]  ? format_decode+0x3be/0x760
[   16.619409]  ? vsnprintf+0x1ff/0x10a0
[   16.620439]  ? num_to_str+0x220/0x220
[   16.621472]  ? snprintf+0x8f/0xc0
[   16.622411]  ? vscnprintf+0x30/0x30
[   16.623402]  ? is_gpt_valid.part.1+0xdc0/0xdc0
[   16.624650]  ? check_partition+0x308/0x660
[   16.625818]  check_partition+0x308/0x660
[   16.626966]  rescan_partitions+0x187/0x8d0
[   16.628123]  ? lock_acquire+0x106/0x3e0
[   16.629219]  ? up_write+0x1d/0x150
[   16.630185]  ? bd_set_size+0x24e/0x2e0
[   16.631244]  __blkdev_get+0x696/0xfd0
[   16.632276]  ? bd_set_size+0x2e0/0x2e0
[   16.633337]  ? kvm_sched_clock_read+0x21/0x30
[   16.634570]  ? sched_clock+0x5/0x10
[   16.635563]  ? sched_clock_cpu+0x18/0x180
[   16.636706]  blkdev_get+0x28f/0x850
[   16.637714]  ? lockdep_rcu_suspicious+0x150/0x150
[   16.639032]  ? __blkdev_get+0xfd0/0xfd0
[   16.640144]  ? refcount_sub_and_test+0xcd/0x160
[   16.641415]  ? refcount_inc+0x30/0x30
[   16.642453]  ? do_raw_spin_unlock+0x144/0x220
[   16.643680]  ? kobject_put+0x50/0x410
[   16.644711]  __device_add_disk+0xbe5/0xe40
[   16.645916]  ? bdget_disk+0x60/0x60
[   16.646919]  ? alloc_dax+0x2b2/0x5b0
[   16.647939]  ? kill_dax+0x140/0x140
[   16.648928]  ? nvdimm_badblocks_populate+0x47/0x360
[   16.649904]  ? __raw_spin_lock_init+0x2d/0x100
[   16.650720]  pmem_attach_disk+0x944/0xf90
[   16.651477]  ? nd_pmem_notify+0x4a0/0x4a0
[   16.652233]  ? kfree+0xd4/0x210
[   16.652822]  ? nd_dax_probe+0x1d0/0x240
[   16.653526]  nvdimm_bus_probe+0xd4/0x370
[   16.654261]  driver_probe_device+0x56d/0xbe0
[   16.655432]  ? __driver_attach+0x2c0/0x2c0
[   16.656548]  bus_for_each_drv+0x10d/0x1a0
[   16.657414]  ? subsys_find_device_by_id+0x2e0/0x2e0
[   16.658385]  __device_attach+0x19c/0x230
[   16.659225]  ? device_bind_driver+0xa0/0xa0
[   16.660135]  ? kobject_uevent_env+0x223/0xfb0
[   16.661072]  bus_probe_device+0x1ad/0x260
[   16.661852]  ? sysfs_create_groups+0x86/0x130
[   16.662826]  device_add+0x9fe/0x1340
[   16.663814]  ? device_private_init+0x180/0x180
[   16.664786]  nd_async_device_register+0xe/0x40
[   16.665621]  async_run_entry_fn+0xc3/0x630
[   16.666400]  process_one_work+0x767/0x1670
[   16.667221]  ? debug_show_all_locks+0x2d0/0x2d0
[   16.668137]  ? pwq_dec_nr_in_flight+0x2c0/0x2c0
[   16.669011]  worker_thread+0x87/0xb90
[   16.669730]  ? __kthread_parkme+0xb6/0x180
[   16.670515]  ? process_one_work+0x1670/0x1670
[   16.671339]  kthread+0x314/0x3d0
[   16.671963]  ? kthread_flush_work_fn+0x10/0x10
[   16.672810]  ret_from_fork+0x3a/0x50
[   16.673502] CR2: ffffed0048000000
[   16.674436] ---[ end trace ac6b16a57e0c48ad ]---

Does this ring any bells?  Any suggestions about how I get ext4 dax
testing working again?  Many thanks!!

(full log and config attached below, compressed for size reasons)

      	      	     	      	     		- Ted

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
