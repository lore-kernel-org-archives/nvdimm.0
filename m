Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B13C621F7D4E1
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 09:21:20 -0700 (PDT)
Date: Wed, 11 Oct 2017 10:24:49 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: nfit test deadlock
Message-ID: <20171011162449.GA20959@linux.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hey Dan,

I was getting the ndctl unit tests working again in my setup today, and on the
first run of ndctl's "make check" hit a deadlock.  This seems to be very easy
to reproduce, all you have to do is specify a number of jobs to make that is
larger than 1 (which I was accidentally doing via an alias),
i.e. "make -j32 check"

This seems to reproduce 100% of the time.

I'll append the ouptut of "echo w > /proc/sysrq-trigger" to the end of this
mail.

I was using v4.13 and ndctl 58.2.

- Ross

---

[  132.668043] sysrq: SysRq : Show Blocked State
[  132.668968]   task                        PC stack   pid father
[  132.670774] lt-libndctl     D    0  5991   5983 0x00000004
[  132.672102] Call Trace:
[  132.672744]  __schedule+0x411/0xb10
[  132.673266]  ? trace_hardirqs_on+0xd/0x10
[  132.674058]  schedule+0x40/0x90
[  132.674545]  __kernfs_remove+0x1f9/0x310
[  132.675298]  ? remove_wait_queue+0x70/0x70
[  132.676046]  kernfs_remove_by_name_ns+0x45/0x90
[  132.676848]  remove_files.isra.1+0x35/0x70
[  132.677451]  sysfs_remove_group+0x44/0x90
[  132.678259]  sysfs_remove_groups+0x2e/0x50
[  132.679047]  device_remove_attrs+0x4d/0x80
[  132.679438]  device_del+0x1ec/0x330
[  132.679888]  device_unregister+0x1a/0x60
[  132.680266]  nvdimm_bus_unregister+0x17/0x20 [libnvdimm]
[  132.680876]  acpi_nfit_unregister+0x15/0x20 [nfit]
[  132.681329]  devm_action_release+0xf/0x20
[  132.681835]  release_nodes+0x16d/0x2b0
[  132.682196]  devres_release_all+0x3c/0x50
[  132.682573]  device_release_driver_internal+0x175/0x220
[  132.683231]  device_release_driver+0x12/0x20
[  132.683715]  bus_remove_device+0x100/0x180
[  132.684102]  device_del+0x1f4/0x330
[  132.684428]  platform_device_del+0x28/0x90
[  132.684967]  platform_device_unregister+0x12/0x30
[  132.685412]  nfit_test_exit+0x17/0x92f [nfit_test]
[  132.685980]  SyS_delete_module+0x1d8/0x230
[  132.686369]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.686915] RIP: 0033:0x7f841012b317
[  132.687255] RSP: 002b:00007fffe5ce0898 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  132.688070] RAX: ffffffffffffffda RBX: 00007f84103e4500 RCX: 00007f841012b317
[  132.688850] RDX: 00007f84103e5730 RSI: 0000000000000800 RDI: 000000000258ac98
[  132.689501] RBP: 00007fffe5ce05b0 R08: 00007f8410e19c80 R09: 0000000000000017
[  132.690257] R10: 000000000000006d R11: 0000000000000206 R12: 0000000000000038
[  132.690988] R13: 0000000000000001 R14: 0000000000000000 R15: 00000000fbad2887
[  132.691735] lt-dsm-fail     D    0  5995   5986 0x00000004
[  132.692246] Call Trace:
[  132.692481]  __schedule+0x411/0xb10
[  132.692972]  schedule+0x40/0x90
[  132.693288]  schedule_preempt_disabled+0x18/0x30
[  132.694083]  __mutex_lock+0x487/0xa20
[  132.694720]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.695452]  mutex_lock_nested+0x1b/0x20
[  132.696245]  ? mutex_lock_nested+0x1b/0x20
[  132.696947]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.697750]  ? kernfs_seq_start+0x2f/0x90
[  132.698302]  ? __mutex_lock+0x228/0xa20
[  132.699077]  ? lock_acquire+0xea/0x1f0
[  132.699698]  ? kernfs_seq_start+0x37/0x90
[  132.700083]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.700529]  dev_attr_show+0x20/0x50
[  132.701022]  ? sysfs_file_ops+0x46/0x60
[  132.701392]  sysfs_kf_seq_show+0xb2/0x110
[  132.701910]  kernfs_seq_show+0x27/0x30
[  132.702271]  seq_read+0x103/0x3d0
[  132.702709]  kernfs_fop_read+0x11e/0x190
[  132.703082]  __vfs_read+0x37/0x160
[  132.703399]  ? security_file_permission+0x9e/0xc0
[  132.704000]  vfs_read+0xab/0x150
[  132.704312]  SyS_read+0x58/0xc0
[  132.704737]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.705295] RIP: 0033:0x7fc0be0d4a80
[  132.705964] RSP: 002b:00007fff3b5cfd08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.707094] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fc0be0d4a80
[  132.708154] RDX: 0000000000000400 RSI: 00007fff3b5cfd80 RDI: 0000000000000004
[  132.709206] RBP: 00007fff3b5d02a0 R08: 0000000001a3ec00 R09: 0000000000000035
[  132.709968] R10: 0000000000000073 R11: 0000000000000246 R12: 0000000000401620
[  132.710707] R13: 00007fff3b5d0cd0 R14: 0000000000000000 R15: 0000000000000000
[  132.711369] lt-parent-uuid  D    0  5998   5989 0x00000004
[  132.711984] Call Trace:
[  132.712229]  __schedule+0x411/0xb10
[  132.712565]  schedule+0x40/0x90
[  132.713004]  schedule_preempt_disabled+0x18/0x30
[  132.713443]  __mutex_lock+0x487/0xa20
[  132.713891]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.714378]  mutex_lock_nested+0x1b/0x20
[  132.714853]  ? mutex_lock_nested+0x1b/0x20
[  132.715239]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.715818]  ? kernfs_seq_start+0x2f/0x90
[  132.716205]  ? __mutex_lock+0x228/0xa20
[  132.716674]  ? lock_acquire+0xea/0x1f0
[  132.717035]  ? kernfs_seq_start+0x37/0x90
[  132.717412]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.718006]  dev_attr_show+0x20/0x50
[  132.718344]  ? sysfs_file_ops+0x46/0x60
[  132.718818]  sysfs_kf_seq_show+0xb2/0x110
[  132.719204]  kernfs_seq_show+0x27/0x30
[  132.719557]  seq_read+0x103/0x3d0
[  132.720011]  kernfs_fop_read+0x11e/0x190
[  132.720386]  __vfs_read+0x37/0x160
[  132.720826]  ? security_file_permission+0x9e/0xc0
[  132.721267]  vfs_read+0xab/0x150
[  132.721571]  SyS_read+0x58/0xc0
[  132.722072]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.722511] RIP: 0033:0x7f5906882a80
[  132.722967] RSP: 002b:00007ffc205e7108 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.723749] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f5906882a80
[  132.724410] RDX: 0000000000000400 RSI: 00007ffc205e7180 RDI: 0000000000000004
[  132.725174] RBP: 00007ffc205e7160 R08: 0000000000808350 R09: 00007f5906f7b88e
[  132.725909] R10: 0000000000000064 R11: 0000000000000246 R12: 0000000000401ac0
[  132.726899] R13: 00007ffc205e78b0 R14: 0000000000000000 R15: 0000000000000000
[  132.727997] lt-multi-pmem   D    0  6042   6009 0x00000004
[  132.728930] Call Trace:
[  132.729307]  __schedule+0x411/0xb10
[  132.729760]  schedule+0x40/0x90
[  132.730067]  schedule_preempt_disabled+0x18/0x30
[  132.730500]  __mutex_lock+0x487/0xa20
[  132.730990]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.731476]  mutex_lock_nested+0x1b/0x20
[  132.731946]  ? mutex_lock_nested+0x1b/0x20
[  132.732331]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.732892]  ? kernfs_seq_start+0x2f/0x90
[  132.733266]  ? __mutex_lock+0x228/0xa20
[  132.733730]  ? lock_acquire+0xea/0x1f0
[  132.734084]  ? kernfs_seq_start+0x37/0x90
[  132.734455]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.735042]  dev_attr_show+0x20/0x50
[  132.735379]  ? sysfs_file_ops+0x46/0x60
[  132.735853]  sysfs_kf_seq_show+0xb2/0x110
[  132.736233]  kernfs_seq_show+0x27/0x30
[  132.736685]  seq_read+0x103/0x3d0
[  132.737009]  kernfs_fop_read+0x11e/0x190
[  132.737375]  __vfs_read+0x37/0x160
[  132.737848]  ? security_file_permission+0x9e/0xc0
[  132.738317]  vfs_read+0xab/0x150
[  132.738935]  SyS_read+0x58/0xc0
[  132.739375]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.740161] RIP: 0033:0x7f8d9d7f9a80
[  132.740770] RSP: 002b:00007ffedd96f848 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.741829] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8d9d7f9a80
[  132.742479] RDX: 0000000000000400 RSI: 00007ffedd96f8c0 RDI: 0000000000000004
[  132.743252] RBP: 00007ffedd96fde0 R08: 0000000000c24870 R09: 0000000000000035
[  132.743985] R10: 0000000000000073 R11: 0000000000000246 R12: 0000000000404b70
[  132.744719] R13: 00007ffedd970150 R14: 0000000000000000 R15: 0000000000000000
[  132.745387] lt-pmem-ns      D    0  6108   6082 0x00000004
[  132.746010] Call Trace:
[  132.746253]  __schedule+0x411/0xb10
[  132.746685]  schedule+0x40/0x90
[  132.746987]  schedule_preempt_disabled+0x18/0x30
[  132.747412]  __mutex_lock+0x487/0xa20
[  132.747902]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.748389]  mutex_lock_nested+0x1b/0x20
[  132.748869]  ? mutex_lock_nested+0x1b/0x20
[  132.749255]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.749824]  ? kernfs_seq_start+0x2f/0x90
[  132.750202]  ? __mutex_lock+0x228/0xa20
[  132.750562]  ? lock_acquire+0xea/0x1f0
[  132.751051]  ? kernfs_seq_start+0x37/0x90
[  132.751433]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.751978]  dev_attr_show+0x20/0x50
[  132.752314]  ? sysfs_file_ops+0x46/0x60
[  132.752785]  sysfs_kf_seq_show+0xb2/0x110
[  132.753164]  kernfs_seq_show+0x27/0x30
[  132.753517]  seq_read+0x103/0x3d0
[  132.753974]  kernfs_fop_read+0x11e/0x190
[  132.754348]  __vfs_read+0x37/0x160
[  132.754781]  ? security_file_permission+0x9e/0xc0
[  132.755272]  vfs_read+0xab/0x150
[  132.755735]  SyS_read+0x58/0xc0
[  132.756184]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.756981] RIP: 0033:0x7fda3d852a80
[  132.757471] RSP: 002b:00007ffefc56b388 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.758724] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fda3d852a80
[  132.759657] RDX: 0000000000000400 RSI: 00007ffefc56b400 RDI: 0000000000000004
[  132.760318] RBP: 00007ffefc56b840 R08: 00000000024c9d90 R09: 0000000000000000
[  132.761086] R10: 0000000000000055 R11: 0000000000000246 R12: 0000000000401970
[  132.761817] R13: 00007ffefc56ba90 R14: 0000000000000000 R15: 0000000000000000
[  132.762475] lt-blk-ns       D    0  6235   6203 0x00000004
[  132.763085] Call Trace:
[  132.763327]  __schedule+0x411/0xb10
[  132.763769]  schedule+0x40/0x90
[  132.764070]  schedule_preempt_disabled+0x18/0x30
[  132.764495]  __mutex_lock+0x487/0xa20
[  132.764979]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.765468]  mutex_lock_nested+0x1b/0x20
[  132.765936]  ? mutex_lock_nested+0x1b/0x20
[  132.766325]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.766908]  ? kernfs_seq_start+0x2f/0x90
[  132.767284]  ? __mutex_lock+0x228/0xa20
[  132.767753]  ? lock_acquire+0xea/0x1f0
[  132.768109]  ? kernfs_seq_start+0x37/0x90
[  132.768479]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.769055]  dev_attr_show+0x20/0x50
[  132.769391]  ? sysfs_file_ops+0x46/0x60
[  132.769856]  sysfs_kf_seq_show+0xb2/0x110
[  132.770230]  kernfs_seq_show+0x27/0x30
[  132.770682]  seq_read+0x103/0x3d0
[  132.771003]  kernfs_fop_read+0x11e/0x190
[  132.771365]  __vfs_read+0x37/0x160
[  132.771962]  ? security_file_permission+0x9e/0xc0
[  132.772705]  vfs_read+0xab/0x150
[  132.773154]  SyS_read+0x58/0xc0
[  132.773763]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.774386] RIP: 0033:0x7fe3d21a9a80
[  132.775003] RSP: 002b:00007ffe84450168 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.775780] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fe3d21a9a80
[  132.776430] RDX: 0000000000000400 RSI: 00007ffe844501e0 RDI: 0000000000000004
[  132.777170] RBP: 00007ffe84450620 R08: 0000000001fd6d90 R09: 0000000000000000
[  132.777907] R10: 0000000000000055 R11: 0000000000000246 R12: 0000000000401a80
[  132.778786] R13: 00007ffe84450870 R14: 0000000000000000 R15: 0000000000000000
[  132.779870] lt-ndctl        D    0  6322   6058 0x00000004
[  132.780672] Call Trace:
[  132.780914]  __schedule+0x411/0xb10
[  132.781238]  schedule+0x40/0x90
[  132.781543]  schedule_preempt_disabled+0x18/0x30
[  132.782019]  __mutex_lock+0x487/0xa20
[  132.782373]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.782878]  mutex_lock_nested+0x1b/0x20
[  132.783246]  ? mutex_lock_nested+0x1b/0x20
[  132.783648]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.784104]  ? retint_kernel+0x2d/0x2d
[  132.784450]  ? trace_hardirqs_on_caller+0xf5/0x190
[  132.784907]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[  132.785336]  ? retint_kernel+0x2d/0x2d
[  132.785715]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.786156]  dev_attr_show+0x20/0x50
[  132.786485]  ? sysfs_file_ops+0x46/0x60
[  132.786860]  sysfs_kf_seq_show+0xb2/0x110
[  132.787236]  kernfs_seq_show+0x27/0x30
[  132.787603]  seq_read+0x103/0x3d0
[  132.787918]  kernfs_fop_read+0x11e/0x190
[  132.788401]  __vfs_read+0x37/0x160
[  132.788748]  ? security_file_permission+0x9e/0xc0
[  132.789182]  vfs_read+0xab/0x150
[  132.789485]  SyS_read+0x58/0xc0
[  132.789802]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.790230] RIP: 0033:0x7fc11000ea80
[  132.790562] RSP: 002b:00007ffd8aa3b858 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.791253] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc11000ea80
[  132.791918] RDX: 0000000000000400 RSI: 00007ffd8aa3b8d0 RDI: 0000000000000003
[  132.792568] RBP: 00007ffd8aa3bd00 R08: 00000000021f2e30 R09: 00007fc110b15c12
[  132.793221] R10: 0000000000000092 R11: 0000000000000246 R12: 00000000004074a0
[  132.793885] R13: 00007ffd8aa3c050 R14: 0000000000000000 R15: 0000000000000000
[  132.794540] lt-ndctl        D    0  6325   6105 0x00000004
[  132.795054] Call Trace:
[  132.795288]  __schedule+0x411/0xb10
[  132.795637]  schedule+0x40/0x90
[  132.795931]  schedule_preempt_disabled+0x18/0x30
[  132.796356]  __mutex_lock+0x487/0xa20
[  132.796716]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.797198]  mutex_lock_nested+0x1b/0x20
[  132.797566]  ? mutex_lock_nested+0x1b/0x20
[  132.797970]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.798434]  ? kernfs_seq_start+0x2f/0x90
[  132.798823]  ? __mutex_lock+0x228/0xa20
[  132.799183]  ? lock_acquire+0xea/0x1f0
[  132.799535]  ? kernfs_seq_start+0x37/0x90
[  132.799921]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.800361]  dev_attr_show+0x20/0x50
[  132.800713]  ? sysfs_file_ops+0x46/0x60
[  132.801069]  sysfs_kf_seq_show+0xb2/0x110
[  132.801437]  kernfs_seq_show+0x27/0x30
[  132.801801]  seq_read+0x103/0x3d0
[  132.802115]  kernfs_fop_read+0x11e/0x190
[  132.802476]  __vfs_read+0x37/0x160
[  132.802813]  ? security_file_permission+0x9e/0xc0
[  132.803245]  vfs_read+0xab/0x150
[  132.803551]  SyS_read+0x58/0xc0
[  132.803861]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.804285] RIP: 0033:0x7f075e511a80
[  132.804673] RSP: 002b:00007fff66916aa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.805461] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f075e511a80
[  132.806118] RDX: 0000000000000400 RSI: 00007fff66916b20 RDI: 0000000000000003
[  132.806786] RBP: 00007fff66916f50 R08: 00000000013dae30 R09: 00007f075f018c12
[  132.807428] R10: 0000000000000092 R11: 0000000000000246 R12: 00000000004074a0
[  132.808083] R13: 00007fff669172a0 R14: 0000000000000000 R15: 0000000000000000
[  132.808760] lt-ndctl        D    0  6326   6103 0x00000004
[  132.809265] Call Trace:
[  132.809502]  __schedule+0x411/0xb10
[  132.809844]  schedule+0x40/0x90
[  132.810140]  schedule_preempt_disabled+0x18/0x30
[  132.810566]  __mutex_lock+0x487/0xa20
[  132.810919]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.811398]  mutex_lock_nested+0x1b/0x20
[  132.811777]  ? mutex_lock_nested+0x1b/0x20
[  132.812157]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.812632]  ? kernfs_seq_start+0x2f/0x90
[  132.813003]  ? __mutex_lock+0x228/0xa20
[  132.813354]  ? lock_acquire+0xea/0x1f0
[  132.813717]  ? kernfs_seq_start+0x37/0x90
[  132.814091]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.814533]  dev_attr_show+0x20/0x50
[  132.814874]  ? sysfs_file_ops+0x46/0x60
[  132.815227]  sysfs_kf_seq_show+0xb2/0x110
[  132.815615]  kernfs_seq_show+0x27/0x30
[  132.815962]  seq_read+0x103/0x3d0
[  132.816270]  kernfs_fop_read+0x11e/0x190
[  132.816652]  __vfs_read+0x37/0x160
[  132.816973]  ? security_file_permission+0x9e/0xc0
[  132.817400]  vfs_read+0xab/0x150
[  132.817722]  SyS_read+0x58/0xc0
[  132.818019]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.818436] RIP: 0033:0x7f8cfd143a80
[  132.818784] RSP: 002b:00007ffddd621de8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.819466] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f8cfd143a80
[  132.820118] RDX: 0000000000000400 RSI: 00007ffddd621e60 RDI: 0000000000000003
[  132.820776] RBP: 00007ffddd622290 R08: 0000000002400e30 R09: 00007f8cfdc4ac12
[  132.821418] R10: 0000000000000092 R11: 0000000000000246 R12: 00000000004074a0
[  132.822174] R13: 00007ffddd6225e0 R14: 0000000000000000 R15: 0000000000000000
[  132.822846] lt-ndctl        D    0  6327   6065 0x00000004
[  132.823351] Call Trace:
[  132.823606]  __schedule+0x411/0xb10
[  132.823936]  schedule+0x40/0x90
[  132.824227]  schedule_preempt_disabled+0x18/0x30
[  132.824669]  __mutex_lock+0x487/0xa20
[  132.825010]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.825481]  mutex_lock_nested+0x1b/0x20
[  132.825862]  ? mutex_lock_nested+0x1b/0x20
[  132.826241]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.826711]  ? kernfs_seq_start+0x2f/0x90
[  132.827079]  ? __mutex_lock+0x228/0xa20
[  132.827432]  ? lock_acquire+0xea/0x1f0
[  132.827796]  ? kernfs_seq_start+0x37/0x90
[  132.828244]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.828704]  dev_attr_show+0x20/0x50
[  132.829035]  ? sysfs_file_ops+0x46/0x60
[  132.829385]  sysfs_kf_seq_show+0xb2/0x110
[  132.829774]  kernfs_seq_show+0x27/0x30
[  132.830124]  seq_read+0x103/0x3d0
[  132.830435]  kernfs_fop_read+0x11e/0x190
[  132.830818]  __vfs_read+0x37/0x160
[  132.831138]  ? security_file_permission+0x9e/0xc0
[  132.831572]  vfs_read+0xab/0x150
[  132.831893]  SyS_read+0x58/0xc0
[  132.832189]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.832633] RIP: 0033:0x7f5f1bdeda80
[  132.832964] RSP: 002b:00007fffec6bb078 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.833678] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f5f1bdeda80
[  132.834324] RDX: 0000000000000400 RSI: 00007fffec6bb0f0 RDI: 0000000000000003
[  132.834985] RBP: 00007fffec6bb520 R08: 0000000000f31e30 R09: 00007f5f1c8f4c12
[  132.835648] R10: 0000000000000092 R11: 0000000000000246 R12: 00000000004074a0
[  132.836286] R13: 00007fffec6bb870 R14: 0000000000000000 R15: 0000000000000000
[  132.836951] lt-ndctl        D    0  6328   6186 0x00000004
[  132.837451] Call Trace:
[  132.837706]  __schedule+0x411/0xb10
[  132.838034]  schedule+0x40/0x90
[  132.838425]  schedule_preempt_disabled+0x18/0x30
[  132.838867]  __mutex_lock+0x487/0xa20
[  132.839205]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.839696]  mutex_lock_nested+0x1b/0x20
[  132.840055]  ? mutex_lock_nested+0x1b/0x20
[  132.840430]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.840897]  ? kernfs_seq_start+0x2f/0x90
[  132.841265]  ? __mutex_lock+0x228/0xa20
[  132.841640]  ? lock_acquire+0xea/0x1f0
[  132.841986]  ? kernfs_seq_start+0x37/0x90
[  132.842355]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.842812]  dev_attr_show+0x20/0x50
[  132.843141]  ? sysfs_file_ops+0x46/0x60
[  132.843494]  sysfs_kf_seq_show+0xb2/0x110
[  132.843879]  kernfs_seq_show+0x27/0x30
[  132.844225]  seq_read+0x103/0x3d0
[  132.844538]  kernfs_fop_read+0x11e/0x190
[  132.844914]  __vfs_read+0x37/0x160
[  132.845232]  ? security_file_permission+0x9e/0xc0
[  132.845681]  vfs_read+0xab/0x150
[  132.845983]  SyS_read+0x58/0xc0
[  132.846276]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.846713] RIP: 0033:0x7fd70537ca80
[  132.847046] RSP: 002b:00007ffe1d968be8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.847743] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fd70537ca80
[  132.848380] RDX: 0000000000000400 RSI: 00007ffe1d968c60 RDI: 0000000000000003
[  132.849043] RBP: 00007ffe1d969090 R08: 00000000020fbe30 R09: 00007fd705e83c12
[  132.849705] R10: 0000000000000092 R11: 0000000000000246 R12: 00000000004074a0
[  132.850408] R13: 00007ffe1d9693e0 R14: 0000000000000000 R15: 0000000000000000
[  132.851070] lt-ndctl        D    0  6332   6090 0x00000004
[  132.851590] Call Trace:
[  132.851824]  __schedule+0x411/0xb10
[  132.852151]  schedule+0x40/0x90
[  132.852444]  schedule_preempt_disabled+0x18/0x30
[  132.852884]  __mutex_lock+0x487/0xa20
[  132.853226]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.853720]  mutex_lock_nested+0x1b/0x20
[  132.854084]  ? mutex_lock_nested+0x1b/0x20
[  132.854499]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.855071]  ? kernfs_seq_start+0x2f/0x90
[  132.855444]  ? __mutex_lock+0x228/0xa20
[  132.855817]  ? lock_acquire+0xea/0x1f0
[  132.856160]  ? kernfs_seq_start+0x37/0x90
[  132.856530]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.856981]  dev_attr_show+0x20/0x50
[  132.857309]  ? sysfs_file_ops+0x46/0x60
[  132.857679]  sysfs_kf_seq_show+0xb2/0x110
[  132.858047]  kernfs_seq_show+0x27/0x30
[  132.858386]  seq_read+0x103/0x3d0
[  132.858715]  kernfs_fop_read+0x11e/0x190
[  132.859075]  __vfs_read+0x37/0x160
[  132.859388]  ? security_file_permission+0x9e/0xc0
[  132.859836]  vfs_read+0xab/0x150
[  132.860138]  SyS_read+0x58/0xc0
[  132.860430]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.860868] RIP: 0033:0x7f00fc1b2a80
[  132.861198] RSP: 002b:00007ffe8183f8b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.861887] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f00fc1b2a80
[  132.862523] RDX: 0000000000000400 RSI: 00007ffe8183f930 RDI: 0000000000000003
[  132.863168] RBP: 00007ffe8183fd60 R08: 000000000188ee30 R09: 00007f00fccb9c12
[  132.863825] R10: 0000000000000092 R11: 0000000000000246 R12: 00000000004074a0
[  132.864459] R13: 00007ffe818400b0 R14: 0000000000000000 R15: 0000000000000000
[  132.865117] lt-ndctl        D    0  6335   6045 0x00000004
[  132.865634] Call Trace:
[  132.865867]  __schedule+0x411/0xb10
[  132.866189]  schedule+0x40/0x90
[  132.866476]  schedule_preempt_disabled+0x18/0x30
[  132.866912]  __mutex_lock+0x487/0xa20
[  132.867250]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.867737]  mutex_lock_nested+0x1b/0x20
[  132.868096]  ? mutex_lock_nested+0x1b/0x20
[  132.868467]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.868933]  ? kernfs_seq_start+0x2f/0x90
[  132.869301]  ? __mutex_lock+0x228/0xa20
[  132.869675]  ? lock_acquire+0xea/0x1f0
[  132.870019]  ? kernfs_seq_start+0x37/0x90
[  132.870387]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.870844]  dev_attr_show+0x20/0x50
[  132.871174]  ? sysfs_file_ops+0x46/0x60
[  132.871528]  sysfs_kf_seq_show+0xb2/0x110
[  132.872010]  kernfs_seq_show+0x27/0x30
[  132.872361]  seq_read+0x103/0x3d0
[  132.872693]  kernfs_fop_read+0x11e/0x190
[  132.873058]  __vfs_read+0x37/0x160
[  132.873373]  ? security_file_permission+0x9e/0xc0
[  132.873820]  vfs_read+0xab/0x150
[  132.874123]  SyS_read+0x58/0xc0
[  132.874415]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.874850] RIP: 0033:0x7f7620445a80
[  132.875179] RSP: 002b:00007ffd0df5f188 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.875871] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f7620445a80
[  132.876510] RDX: 0000000000000400 RSI: 00007ffd0df5f200 RDI: 0000000000000003
[  132.877153] RBP: 00007ffd0df5f630 R08: 0000000000e8fe30 R09: 00007f7620f4cc12
[  132.877809] R10: 0000000000000092 R11: 0000000000000246 R12: 00000000004074a0
[  132.878449] R13: 00007ffd0df5f980 R14: 0000000000000000 R15: 0000000000000000
[  132.879206] lt-ndctl        D    0  6343   6039 0x00000004
[  132.879732] Call Trace:
[  132.879969]  __schedule+0x411/0xb10
[  132.880292]  schedule+0x40/0x90
[  132.880604]  schedule_preempt_disabled+0x18/0x30
[  132.881028]  __mutex_lock+0x487/0xa20
[  132.881365]  ? acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.881858]  mutex_lock_nested+0x1b/0x20
[  132.882221]  ? mutex_lock_nested+0x1b/0x20
[  132.882615]  acpi_nfit_flush_probe+0x3a/0x150 [nfit]
[  132.883071]  ? kernfs_seq_start+0x2f/0x90
[  132.883437]  ? __mutex_lock+0x228/0xa20
[  132.883811]  ? lock_acquire+0xea/0x1f0
[  132.884159]  ? kernfs_seq_start+0x37/0x90
[  132.884533]  wait_probe_show+0x25/0x60 [libnvdimm]
[  132.884985]  dev_attr_show+0x20/0x50
[  132.885317]  ? sysfs_file_ops+0x46/0x60
[  132.885692]  sysfs_kf_seq_show+0xb2/0x110
[  132.886068]  kernfs_seq_show+0x27/0x30
[  132.886411]  seq_read+0x103/0x3d0
[  132.886741]  kernfs_fop_read+0x11e/0x190
[  132.887107]  __vfs_read+0x37/0x160
[  132.887424]  ? security_file_permission+0x9e/0xc0
[  132.887873]  vfs_read+0xab/0x150
[  132.888177]  SyS_read+0x58/0xc0
[  132.888593]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[  132.889018] RIP: 0033:0x7f1dc06f3a80
[  132.889346] RSP: 002b:00007ffdd14888c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  132.890045] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f1dc06f3a80
[  132.890709] RDX: 0000000000000400 RSI: 00007ffdd1488940 RDI: 0000000000000003
[  132.891352] RBP: 00007ffdd1488d70 R08: 0000000001fb2e30 R09: 00007f1dc11fac12
[  132.892009] R10: 0000000000000092 R11: 0000000000000246 R12: 00000000004074a0
[  132.892680] R13: 00007ffdd14890c0 R14: 0000000000000000 R15: 0000000000000000
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
