Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E00C721A0480E
 for <linux-nvdimm@lists.01.org>; Sun, 30 Apr 2017 02:16:14 -0700 (PDT)
Subject: Re: task ndctl:5155 blocked for more than 120 seconds observed during
 pmem/btt/dax switch test
References: <895281518.353931.1493045976821.JavaMail.zimbra@redhat.com>
 <1482421304.370160.1493046815781.JavaMail.zimbra@redhat.com>
 <CAPcyv4jufPjoxKZ+82WBSEHs8VafEfZv1nozDsF29f45=0Us=A@mail.gmail.com>
From: Yi Zhang <yizhan@redhat.com>
Message-ID: <0193aa84-a6ad-8472-43de-a49ea8617fc4@redhat.com>
Date: Sun, 30 Apr 2017 17:16:06 +0800
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jufPjoxKZ+82WBSEHs8VafEfZv1nozDsF29f45=0Us=A@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/29/2017 01:35 PM, Dan Williams wrote:
> On Mon, Apr 24, 2017 at 8:13 AM, Yi Zhang <yizhan@redhat.com> wrote:
>> Hello
>>
>> I reproduced ndctl blocked issue on 4.11.0-rc8, here is the reproduce steps and kernel log, could you help check it? Thanks.
>>
>> Reproduce steps:
>> function pmem_btt_dax_switch() {
>>          sector_size_list="512 520 528 4096 4104 4160 4224"
>>          for sector_size in $sector_size_list; do
>>                  ndctl create-namespace -f -e namespace${1}.0 --mode=sector -l $sector_size
>>                  ndctl create-namespace -f -e namespace${1}.0 --mode=raw
>>                  ndctl create-namespace -f -e namespace${1}.0 --mode=dax
>>          done
>> }
>> for i in 0 1 2 3; do
>>          pmem_btt_dax_switch $i &
>> done
> Thanks for the report!
>
> I couldn't run your script directly, do you have 4 memmap= regions
> defined, or...?
Here is my environment[1], pls try script [2]
[1]
# ndctl list -NB
{
   "provider":"ACPI.NFIT",
   "dev":"ndbus0",
   "namespaces":[
     {
       "dev":"namespace1.0",
       "mode":"dax",
       "size":8453619712,
       "uuid":"83bb25db-4a60-4613-a1c8-89d0f8f68c0d"
     },
     {
       "dev":"namespace3.0",
       "mode":"dax",
       "size":8453619712,
       "uuid":"243ab8f4-1d29-43c3-b5f1-be2e470b3a85"
     },
     {
       "dev":"namespace0.0",
       "mode":"dax",
       "size":8453619712,
       "uuid":"38d3a3ad-b6e2-4e4f-bf58-b793f9c039ea"
     },
     {
       "dev":"namespace2.0",
       "mode":"dax",
       "size":8453619712,
       "uuid":"f1887ded-7f8b-4fe0-bacb-303f88584711"
     }
   ]
}

[2]
#!/bin/bash
function pmem_btt_switch() {
         sector_size_list="512 520 528 4096 4104 4160 4224"
         for sector_size in $sector_size_list; do
                 ndctl create-namespace -f -e namespace${1}.0 
--mode=sector -l $sector_size
                 ndctl create-namespace -f -e namespace${1}.0 --mode=raw
                 ndctl create-namespace -f -e namespace${1}.0 --mode=dax
         done
}
num=0
while [ $num -lt 500 ]; do
         for i in 0 1 2 3; do
                 pmem_btt_switch $i &
         done
         wait
         ((num++))
done

> I was able to find a locking problem with a debug patch that turned on
> lockdep coverage for the device_lock(). Can you give the attached
> patch a try to see if it resolves your lockup?
>
> This is against latest nvdimm.git/libnvdimm-for-next
I tried the attached patch against bellow code[3], seems reproduced this 
issue again, pls check below log[4]
[3]
git clone -b libnvdimm-for-next 
git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
[4]
[  637.673117] nd_pmem btt3.0: No existing arenas
[  637.673118] nd_pmem btt1.0: No existing arenas
[  637.692493] pmem1s: detected capacity change from 0 to 7582678528
[  637.694980] pmem0: detected capacity change from 0 to 8589934592
[  637.778798] pmem3s: detected capacity change from 0 to 7582678528
[  637.812557] pmem2: detected capacity change from 0 to 8589934592
[  637.868725] nd_pmem btt0.0: No existing arenas
[  637.908019] pmem0s: detected capacity change from 0 to 7582678528
[  637.951486] nd_pmem btt2.0: No existing arenas
[  637.978690] pmem2s: detected capacity change from 0 to 7582678528
[  638.034491] pmem3: detected capacity change from 0 to 8589934592
[  638.068756] pmem1: detected capacity change from 0 to 8589934592
[  638.107573] pmem0: detected capacity change from 0 to 8589934592
[  638.199041] pmem0: detected capacity change from 0 to 8589934592
[  638.199041] pmem3: detected capacity change from 0 to 8589934592
[  638.199098] pmem1: detected capacity change from 0 to 8589934592
[  638.308711] pmem2: detected capacity change from 0 to 8589934592
[  865.258436] INFO: task ndctl:21792 blocked for more than 120 seconds.
[  865.292282]       Not tainted 4.11.0-rc4+ #1
[  865.311971] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  865.347460] ndctl           D    0 21792  21791 0x00000080
[  865.371985] Call Trace:
[  865.382907]  __schedule+0x289/0x8f0
[  865.398556]  schedule+0x36/0x80
[  865.412599]  schedule_preempt_disabled+0xe/0x10
[  865.432906]  __mutex_lock.isra.8+0x266/0x500
[  865.452217]  ? mntput+0x24/0x40
[  865.466262]  __mutex_lock_slowpath+0x13/0x20
[  865.486238]  mutex_lock+0x2f/0x40
[  865.501470]  region_size_show+0x20/0x70 [device_dax]
[  865.523976]  dev_attr_show+0x20/0x50
[  865.539997]  ? mutex_lock+0x12/0x40
[  865.555749]  sysfs_kf_seq_show+0xbf/0x1a0
[  865.573689]  kernfs_seq_show+0x21/0x30
[  865.590477]  seq_read+0x115/0x390
[  865.605305]  ? do_filp_open+0xa5/0x100
[  865.621728]  kernfs_fop_read+0xff/0x180
[  865.638917]  __vfs_read+0x37/0x150
[  865.653763]  ? security_file_permission+0x9d/0xc0
[  865.674791]  vfs_read+0x8c/0x130
[  865.688887]  SyS_read+0x55/0xc0
[  865.703026]  do_syscall_64+0x67/0x180
[  865.719498]  entry_SYSCALL64_slow_path+0x25/0x25
[  865.740944] RIP: 0033:0x7f1fcf5b47e0
[  865.757730] RSP: 002b:00007ffca0272138 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[  865.793826] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 
00007f1fcf5b47e0
[  865.828479] RDX: 0000000000000400 RSI: 00007ffca0272160 RDI: 
0000000000000004
[  865.861314] RBP: 00000000012c54f0 R08: 00007f1fcf513988 R09: 
0000000000000027
[  865.893963] R10: 000000000000000a R11: 0000000000000246 R12: 
00007ffca0272160
[  865.926206] R13: 00000000012c8260 R14: 00007ffca0272160 R15: 
00000000012c8343
[  865.958196] INFO: task ndctl:21815 blocked for more than 120 seconds.
[  865.987044]       Not tainted 4.11.0-rc4+ #1
[  866.006393] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  866.041532] ndctl           D    0 21815  21814 0x00000080
[  866.066062] Call Trace:
[  866.077166]  __schedule+0x289/0x8f0
[  866.093101]  schedule+0x36/0x80
[  866.107348]  schedule_preempt_disabled+0xe/0x10
[  866.128397]  __mutex_lock.isra.8+0x266/0x500
[  866.150235]  ? refcount_dec_and_test+0x11/0x20
[  866.171204]  ? wait_probe_show+0x70/0x70 [libnvdimm]
[  866.195722]  __mutex_lock_slowpath+0x13/0x20
[  866.215658]  mutex_lock+0x2f/0x40
[  866.231182]  flush_regions_dimms+0x1b/0x40 [libnvdimm]
[  866.255614]  device_for_each_child+0x50/0x90
[  866.275489]  wait_probe_show+0x46/0x70 [libnvdimm]
[  866.299264]  dev_attr_show+0x20/0x50
[  866.318946]  ? mutex_lock+0x12/0x40
[  866.335740]  sysfs_kf_seq_show+0xbf/0x1a0
[  866.354608]  kernfs_seq_show+0x21/0x30
[  866.372248]  seq_read+0x115/0x390
[  866.387589]  ? do_filp_open+0xa5/0x100
[  866.405202]  kernfs_fop_read+0xff/0x180
[  866.423176]  __vfs_read+0x37/0x150
[  866.439121]  ? security_file_permission+0x9d/0xc0
[  866.461188]  vfs_read+0x8c/0x130
[  866.476212]  SyS_read+0x55/0xc0
[  866.490824]  do_syscall_64+0x67/0x180
[  866.507892]  entry_SYSCALL64_slow_path+0x25/0x25
[  866.529750] RIP: 0033:0x7f362c9077e0
[  866.546371] RSP: 002b:00007ffcc956d2c8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[  866.582011] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 
00007f362c9077e0
[  866.615492] RDX: 0000000000000400 RSI: 00007ffcc956d2f0 RDI: 
0000000000000003
[  866.649106] RBP: 0000000000000000 R08: 00007f362c866988 R09: 
0000000000000046
[  866.682500] R10: 0000000000000046 R11: 0000000000000246 R12: 
00007ffcc956d2f0
[  866.715817] R13: 0000000000000000 R14: 0000000000001388 R15: 
00007ffcc956d2f0
[  866.749426] INFO: task ndctl:21818 blocked for more than 120 seconds.
[  866.779733]       Not tainted 4.11.0-rc4+ #1
[  866.800190] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  866.840889] ndctl           D    0 21818  21816 0x00000080
[  866.866559] Call Trace:
[  866.877997]  __schedule+0x289/0x8f0
[  866.894153]  schedule+0x36/0x80
[  866.909009]  __kernfs_remove+0x169/0x220
[  866.927326]  ? remove_wait_queue+0x60/0x60
[  866.946570]  kernfs_remove_by_name_ns+0x43/0xa0
[  866.967736]  remove_files.isra.1+0x36/0x70
[  866.986964]  sysfs_remove_group+0x44/0x90
[  867.005536]  sysfs_remove_groups+0x2e/0x50
[  867.025658]  dax_region_unregister+0x21/0x40 [device_dax]
[  867.051102]  devm_action_release+0xf/0x20
[  867.069917]  release_nodes+0x218/0x260
[  867.087469]  devres_release_all+0x3c/0x60
[  867.106331]  device_release_driver_internal+0x151/0x1f0
[  867.130551]  device_release_driver+0x12/0x20
[  867.150939]  unbind_store+0xba/0xe0
[  867.167331]  drv_attr_store+0x24/0x30
[  867.184559]  sysfs_kf_write+0x3a/0x50
[  867.201805]  kernfs_fop_write+0xff/0x180
[  867.220111]  __vfs_write+0x37/0x160
[  867.236342]  ? selinux_file_permission+0xe5/0x120
[  867.258348]  ? security_file_permission+0x3b/0xc0
[  867.280189]  vfs_write+0xb2/0x1b0
[  867.295622]  ? syscall_trace_enter+0x1d0/0x2b0
[  867.317865]  SyS_write+0x55/0xc0
[  867.334608]  do_syscall_64+0x67/0x180
[  867.353717]  entry_SYSCALL64_slow_path+0x25/0x25
[  867.375047] RIP: 0033:0x7f6252c56840
[  867.391768] RSP: 002b:00007ffe36b4cc38 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[  867.427789] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 
00007f6252c56840
[  867.461738] RDX: 0000000000000007 RSI: 0000000000b49ba0 RDI: 
0000000000000003
[  867.495312] RBP: 0000000000b49ba0 R08: 00007f6252bb5988 R09: 
0000000000000046
[  867.528377] R10: 00007ffe36b4c950 R11: 0000000000000246 R12: 
0000000000000007
[  867.561816] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000002
[  867.595562] INFO: task ndctl:21819 blocked for more than 120 seconds.
[  867.625845]       Not tainted 4.11.0-rc4+ #1
[  867.645436] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  867.682041] ndctl           D    0 21819  21817 0x00000080
[  867.708043] Call Trace:
[  867.719637]  __schedule+0x289/0x8f0
[  867.736425]  schedule+0x36/0x80
[  867.751222]  schedule_preempt_disabled+0xe/0x10
[  867.772404]  __mutex_lock.isra.8+0x266/0x500
[  867.792365]  ? refcount_dec_and_test+0x11/0x20
[  867.813359]  ? wait_probe_show+0x70/0x70 [libnvdimm]
[  867.838480]  __mutex_lock_slowpath+0x13/0x20
[  867.859706]  mutex_lock+0x2f/0x40
[  867.875377]  flush_regions_dimms+0x1b/0x40 [libnvdimm]
[  867.899479]  device_for_each_child+0x50/0x90
[  867.919187]  wait_probe_show+0x46/0x70 [libnvdimm]
[  867.940749]  dev_attr_show+0x20/0x50
[  867.957176]  ? mutex_lock+0x12/0x40
[  867.973416]  sysfs_kf_seq_show+0xbf/0x1a0
[  867.992291]  kernfs_seq_show+0x21/0x30
[  868.009818]  seq_read+0x115/0x390
[  868.025295]  ? do_filp_open+0xa5/0x100
[  868.042770]  kernfs_fop_read+0xff/0x180
[  868.060784]  __vfs_read+0x37/0x150
[  868.076791]  ? security_file_permission+0x9d/0xc0
[  868.100003]  vfs_read+0x8c/0x130
[  868.115039]  SyS_read+0x55/0xc0
[  868.129758]  do_syscall_64+0x67/0x180
[  868.146826]  entry_SYSCALL64_slow_path+0x25/0x25
[  868.168842] RIP: 0033:0x7f727cade7e0
[  868.185547] RSP: 002b:00007ffc3adfdd98 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[  868.220933] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 
00007f727cade7e0
[  868.254185] RDX: 0000000000000400 RSI: 00007ffc3adfddc0 RDI: 
0000000000000003
[  868.287336] RBP: 000000000093b570 R08: 000000000093ea50 R09: 
00007f727d3da310
[  868.321130] R10: 0000000000000000 R11: 0000000000000246 R12: 
00007ffc3adfddc0
[  868.356791] R13: 0000000000000000 R14: 0000000000001388 R15: 
00007ffc3adfddc0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
