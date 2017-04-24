Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9151C21954066
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 08:13:36 -0700 (PDT)
Date: Mon, 24 Apr 2017 11:13:35 -0400 (EDT)
From: Yi Zhang <yizhan@redhat.com>
Message-ID: <1482421304.370160.1493046815781.JavaMail.zimbra@redhat.com>
In-Reply-To: <895281518.353931.1493045976821.JavaMail.zimbra@redhat.com>
Subject: task ndctl:5155 blocked for more than 120 seconds observed during
 pmem/btt/dax switch test
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello

I reproduced ndctl blocked issue on 4.11.0-rc8, here is the reproduce steps and kernel log, could you help check it? Thanks.

Reproduce steps:
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

kernel log:
[ 6026.482747] INFO: task ndctl:5155 blocked for more than 120 seconds.
[ 6026.514573]       Not tainted 4.11.0-rc8 #1
[ 6026.535467] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6026.573932] ndctl           D    0  5155   5154 0x00000080
[ 6026.600220] Call Trace:
[ 6026.611766]  __schedule+0x289/0x8f0
[ 6026.628026]  schedule+0x36/0x80
[ 6026.642725]  schedule_preempt_disabled+0xe/0x10
[ 6026.663804]  __mutex_lock.isra.8+0x266/0x500
[ 6026.683820]  ? mntput+0x24/0x40
[ 6026.698596]  __mutex_lock_slowpath+0x13/0x20
[ 6026.718558]  mutex_lock+0x2f/0x40
[ 6026.734046]  region_size_show+0x20/0x70 [dax]
[ 6026.754563]  dev_attr_show+0x20/0x50
[ 6026.771246]  ? mutex_lock+0x12/0x40
[ 6026.787201]  sysfs_kf_seq_show+0xbf/0x1a0
[ 6026.805510]  kernfs_seq_show+0x21/0x30
[ 6026.823174]  seq_read+0x115/0x390
[ 6026.838263]  ? do_filp_open+0xa5/0x100
[ 6026.855906]  kernfs_fop_read+0xff/0x180
[ 6026.873983]  __vfs_read+0x37/0x150
[ 6026.889786]  ? security_file_permission+0x9d/0xc0
[ 6026.911642]  vfs_read+0x8c/0x130
[ 6026.926874]  SyS_read+0x55/0xc0
[ 6026.941636]  do_syscall_64+0x67/0x180
[ 6026.959003]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6026.980692] RIP: 0033:0x7f24eba9c7e0
[ 6026.999534] RSP: 002b:00007fff94cbb658 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 6027.035833] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f24eba9c7e0
[ 6027.071099] RDX: 0000000000000400 RSI: 00007fff94cbb680 RDI: 0000000000000004
[ 6027.106350] RBP: 0000000001d784e0 R08: 00007f24eb9fb988 R09: 0000000000000027
[ 6027.141119] R10: 000000000000000a R11: 0000000000000246 R12: 00007fff94cbb680
[ 6027.175009] R13: 0000000001d73270 R14: 00007fff94cbb680 R15: 0000000001d7b333
[ 6027.208899] INFO: task ndctl:5164 blocked for more than 120 seconds.
[ 6027.238487]       Not tainted 4.11.0-rc8 #1
[ 6027.258025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6027.296084] ndctl           D    0  5164   5163 0x00000080
[ 6027.321726] Call Trace:
[ 6027.333199]  __schedule+0x289/0x8f0
[ 6027.349688]  schedule+0x36/0x80
[ 6027.364463]  schedule_preempt_disabled+0xe/0x10
[ 6027.385667]  __mutex_lock.isra.8+0x266/0x500
[ 6027.405824]  ? refcount_dec_and_test+0x11/0x20
[ 6027.426656]  ? wait_probe_show+0x70/0x70 [libnvdimm]
[ 6027.449966]  __mutex_lock_slowpath+0x13/0x20
[ 6027.470000]  mutex_lock+0x2f/0x40
[ 6027.485369]  flush_regions_dimms+0x1b/0x40 [libnvdimm]
[ 6027.509549]  device_for_each_child+0x50/0x90
[ 6027.529466]  wait_probe_show+0x46/0x70 [libnvdimm]
[ 6027.551543]  dev_attr_show+0x20/0x50
[ 6027.569666]  ? mutex_lock+0x12/0x40
[ 6027.586494]  sysfs_kf_seq_show+0xbf/0x1a0
[ 6027.607243]  kernfs_seq_show+0x21/0x30
[ 6027.625886]  seq_read+0x115/0x390
[ 6027.641497]  ? do_filp_open+0xa5/0x100
[ 6027.659110]  kernfs_fop_read+0xff/0x180
[ 6027.677120]  __vfs_read+0x37/0x150
[ 6027.692972]  ? security_file_permission+0x9d/0xc0
[ 6027.714948]  vfs_read+0x8c/0x130
[ 6027.730083]  SyS_read+0x55/0xc0
[ 6027.745087]  do_syscall_64+0x67/0x180
[ 6027.762273]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6027.784092] RIP: 0033:0x7f08e08527e0
[ 6027.800715] RSP: 002b:00007fff5ffcd358 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 6027.836082] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f08e08527e0
[ 6027.869667] RDX: 0000000000000400 RSI: 00007fff5ffcd380 RDI: 0000000000000003
[ 6027.904697] RBP: 0000000000000000 R08: 00007f08e07b1988 R09: 0000000000000046
[ 6027.938016] R10: 0000000000000046 R11: 0000000000000246 R12: 00007fff5ffcd380
[ 6027.970932] R13: 0000000000000000 R14: 0000000000001388 R15: 00007fff5ffcd380
[ 6028.004331] INFO: task ndctl:5172 blocked for more than 120 seconds.
[ 6028.034311]       Not tainted 4.11.0-rc8 #1
[ 6028.053796] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6028.092317] ndctl           D    0  5172   5171 0x00000080
[ 6028.120694] Call Trace:
[ 6028.132134]  __schedule+0x289/0x8f0
[ 6028.148496]  schedule+0x36/0x80
[ 6028.163221]  schedule_preempt_disabled+0xe/0x10
[ 6028.184498]  __mutex_lock.isra.8+0x266/0x500
[ 6028.204502]  ? refcount_dec_and_test+0x11/0x20
[ 6028.225383]  ? wait_probe_show+0x70/0x70 [libnvdimm]
[ 6028.248818]  __mutex_lock_slowpath+0x13/0x20
[ 6028.268915]  mutex_lock+0x2f/0x40
[ 6028.284572]  flush_regions_dimms+0x1b/0x40 [libnvdimm]
[ 6028.308483]  device_for_each_child+0x50/0x90
[ 6028.328625]  wait_probe_show+0x46/0x70 [libnvdimm]
[ 6028.351106]  dev_attr_show+0x20/0x50
[ 6028.367457]  ? mutex_lock+0x12/0x40
[ 6028.383180]  sysfs_kf_seq_show+0xbf/0x1a0
[ 6028.401459]  kernfs_seq_show+0x21/0x30
[ 6028.418997]  seq_read+0x115/0x390
[ 6028.434451]  ? do_filp_open+0xa5/0x100
[ 6028.451975]  kernfs_fop_read+0xff/0x180
[ 6028.469849]  __vfs_read+0x37/0x150
[ 6028.485746]  ? security_file_permission+0x9d/0xc0
[ 6028.507435]  vfs_read+0x8c/0x130
[ 6028.522452]  SyS_read+0x55/0xc0
[ 6028.537079]  do_syscall_64+0x67/0x180
[ 6028.554153]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6028.575778] RIP: 0033:0x7eff768387e0
[ 6028.592970] RSP: 002b:00007ffcf5367668 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 6028.631343] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007eff768387e0
[ 6028.664793] RDX: 0000000000000400 RSI: 00007ffcf5367690 RDI: 0000000000000003
[ 6028.698191] RBP: 0000000000000000 R08: 00007eff76797988 R09: 0000000000000046
[ 6028.731690] R10: 0000000000000046 R11: 0000000000000246 R12: 00007ffcf5367690
[ 6028.765029] R13: 0000000000000000 R14: 0000000000001388 R15: 00007ffcf5367690
[ 6028.798470] INFO: task ndctl:5180 blocked for more than 120 seconds.
[ 6028.828412]       Not tainted 4.11.0-rc8 #1
[ 6028.848058] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6028.884846] ndctl           D    0  5180   5179 0x00000080
[ 6028.910311] Call Trace:
[ 6028.921891]  __schedule+0x289/0x8f0
[ 6028.938354]  schedule+0x36/0x80
[ 6028.952914]  __kernfs_remove+0x169/0x220
[ 6028.971210]  ? remove_wait_queue+0x60/0x60
[ 6028.990431]  kernfs_remove_by_name_ns+0x43/0xa0
[ 6029.011866]  remove_files.isra.1+0x36/0x70
[ 6029.032520]  sysfs_remove_group+0x44/0x90
[ 6029.051185]  sysfs_remove_groups+0x2e/0x50
[ 6029.070831]  dax_region_unregister+0x21/0x40 [dax]
[ 6029.093260]  devm_action_release+0xf/0x20
[ 6029.113529]  release_nodes+0x218/0x260
[ 6029.132924]  devres_release_all+0x3c/0x60
[ 6029.152249]  device_release_driver_internal+0x151/0x1f0
[ 6029.176701]  device_release_driver+0x12/0x20
[ 6029.196651]  unbind_store+0xba/0xe0
[ 6029.213026]  drv_attr_store+0x24/0x30
[ 6029.229987]  sysfs_kf_write+0x3a/0x50
[ 6029.247412]  kernfs_fop_write+0xff/0x180
[ 6029.265909]  __vfs_write+0x37/0x160
[ 6029.282231]  ? selinux_file_permission+0xe5/0x120
[ 6029.304504]  ? security_file_permission+0x3b/0xc0
[ 6029.326647]  vfs_write+0xb2/0x1b0
[ 6029.341929]  ? syscall_trace_enter+0x1d0/0x2b0
[ 6029.362863]  SyS_write+0x55/0xc0
[ 6029.377955]  do_syscall_64+0x67/0x180
[ 6029.395080]  entry_SYSCALL64_slow_path+0x25/0x25
[ 6029.416677] RIP: 0033:0x7f83a79b7840
[ 6029.433311] RSP: 002b:00007ffca25e4198 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[ 6029.468729] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f83a79b7840
[ 6029.502221] RDX: 0000000000000007 RSI: 00000000016deb90 RDI: 0000000000000003
[ 6029.535277] RBP: 00000000016deb90 R08: 00007f83a7916988 R09: 0000000000000046
[ 6029.568341] R10: 00007ffca25e3eb0 R11: 0000000000000246 R12: 0000000000000007
[ 6029.601701] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000002



#ps aux | grep ndctl
root      5155  0.0  0.0  41576  3044 pts/0    D+   10:53   0:00 ndctl create-namespace -f -e namespace2.0 --mode=dax
root      5164  0.0  0.0  41576  3040 pts/0    D+   10:53   0:00 ndctl create-namespace -f -e namespace0.0 --mode=dax
root      5172  0.1  0.0  41576  3024 pts/0    D+   10:53   0:00 ndctl create-namespace -f -e namespace3.0 --mode=dax
root      5180  0.0  0.0  41576  3036 pts/0    D+   10:53   0:00 ndctl create-namespace -f -e namespace1.0 --mode=sector -l 528

# cat /proc/5155/stack 
[<ffffffffc096f320>] region_size_show+0x20/0x70 [dax]
[<ffffffffbeae2fb0>] dev_attr_show+0x20/0x50
[<ffffffffbe8ca08f>] sysfs_kf_seq_show+0xbf/0x1a0
[<ffffffffbe8c8741>] kernfs_seq_show+0x21/0x30
[<ffffffffbe866f65>] seq_read+0x115/0x390
[<ffffffffbe8c8ebf>] kernfs_fop_read+0xff/0x180
[<ffffffffbe83ebe7>] __vfs_read+0x37/0x150
[<ffffffffbe83fb2c>] vfs_read+0x8c/0x130
[<ffffffffbe841105>] SyS_read+0x55/0xc0
[<ffffffffbe603a47>] do_syscall_64+0x67/0x180
[<ffffffffbed5602b>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

# cat /proc/5164/stack 
[<ffffffffc0bf720b>] flush_regions_dimms+0x1b/0x40 [libnvdimm]
[<ffffffffbeae2b30>] device_for_each_child+0x50/0x90
[<ffffffffc0bf71c6>] wait_probe_show+0x46/0x70 [libnvdimm]
[<ffffffffbeae2fb0>] dev_attr_show+0x20/0x50
[<ffffffffbe8ca08f>] sysfs_kf_seq_show+0xbf/0x1a0
[<ffffffffbe8c8741>] kernfs_seq_show+0x21/0x30
[<ffffffffbe866f65>] seq_read+0x115/0x390
[<ffffffffbe8c8ebf>] kernfs_fop_read+0xff/0x180
[<ffffffffbe83ebe7>] __vfs_read+0x37/0x150
[<ffffffffbe83fb2c>] vfs_read+0x8c/0x130
[<ffffffffbe841105>] SyS_read+0x55/0xc0
[<ffffffffbe603a47>] do_syscall_64+0x67/0x180
[<ffffffffbed5602b>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

# cat /proc/5172/stack 
[<ffffffffc0bf720b>] flush_regions_dimms+0x1b/0x40 [libnvdimm]
[<ffffffffbeae2b30>] device_for_each_child+0x50/0x90
[<ffffffffc0bf71c6>] wait_probe_show+0x46/0x70 [libnvdimm]
[<ffffffffbeae2fb0>] dev_attr_show+0x20/0x50
[<ffffffffbe8ca08f>] sysfs_kf_seq_show+0xbf/0x1a0
[<ffffffffbe8c8741>] kernfs_seq_show+0x21/0x30
[<ffffffffbe866f65>] seq_read+0x115/0x390
[<ffffffffbe8c8ebf>] kernfs_fop_read+0xff/0x180
[<ffffffffbe83ebe7>] __vfs_read+0x37/0x150
[<ffffffffbe83fb2c>] vfs_read+0x8c/0x130
[<ffffffffbe841105>] SyS_read+0x55/0xc0
[<ffffffffbe603a47>] do_syscall_64+0x67/0x180
[<ffffffffbed5602b>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

# cat /proc/5180/stack 
[<ffffffffbe8c7669>] __kernfs_remove+0x169/0x220
[<ffffffffbe8c8523>] kernfs_remove_by_name_ns+0x43/0xa0
[<ffffffffbe8cad26>] remove_files.isra.1+0x36/0x70
[<ffffffffbe8cb0e4>] sysfs_remove_group+0x44/0x90
[<ffffffffbe8cb1de>] sysfs_remove_groups+0x2e/0x50
[<ffffffffc09700a1>] dax_region_unregister+0x21/0x40 [dax]
[<ffffffffbeaec2ef>] devm_action_release+0xf/0x20
[<ffffffffbeaed038>] release_nodes+0x218/0x260
[<ffffffffbeaed28c>] devres_release_all+0x3c/0x60
[<ffffffffbeae8d71>] device_release_driver_internal+0x151/0x1f0
[<ffffffffbeae8e22>] device_release_driver+0x12/0x20
[<ffffffffbeae6a3a>] unbind_store+0xba/0xe0
[<ffffffffbeae6034>] drv_attr_store+0x24/0x30
[<ffffffffbe8c9c3a>] sysfs_kf_write+0x3a/0x50
[<ffffffffbe8c971f>] kernfs_fop_write+0xff/0x180
[<ffffffffbe83ed37>] __vfs_write+0x37/0x160
[<ffffffffbe83fc82>] vfs_write+0xb2/0x1b0
[<ffffffffbe8411c5>] SyS_write+0x55/0xc0
[<ffffffffbe603a47>] do_syscall_64+0x67/0x180
[<ffffffffbed5602b>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff


Best Regards,
  Yi Zhang


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
