From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: multi-threads libvmmalloc fork test hang
Date: Thu, 27 Oct 2016 19:22:30 +0800
Message-ID: <20161027112230.wsumgs62fqdxt3sc@xzhoul.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


# description

nvml test suite vmmalloc_fork test hang.

$ ps -eo stat,comm  | grep vmma
S+   vmmalloc_fork
Sl+  vmmalloc_fork
Z+   vmmalloc_fork <defunct>
Sl+  vmmalloc_fork
Z+   vmmalloc_fork <defunct>
Z+   vmmalloc_fork <defunct>
Sl+  vmmalloc_fork
Z+   vmmalloc_fork <defunct>
Z+   vmmalloc_fork <defunct>
Z+   vmmalloc_fork <defunct>

dmesg:

[  250.499097] INFO: task vmmalloc_fork:9805 blocked for more than 120 seconds.
[  250.530667]       Not tainted 4.9.09fe68ca+ #27
[  250.550901] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  250.585752] vmmalloc_fork   D[  250.598362]  ffffffff8171813c     0  9805   9765 0x00000080
[  250.623445]  ffff88075dc68f80[  250.636052]  0000000000000000 ffff88076058db00 ffff88017c5b0000 ffff880763b19340[  250.668510]  ffffc9000fe1bbb0 ffffffff8171813c ffffc9000fe1bc20 ffffc9000fe1bbe0[  250.704220]  ffffffff82248898 ffff88076058db00 ffffffff82248898Call Trace:
[  250.738382]  [<ffffffff8171813c>] ? __schedule+0x21c/0x6a0
[  250.763404]  [<ffffffff817185f6>] schedule+0x36/0x80
[  250.786177]  [<ffffffff81284471>] get_unlocked_mapping_entry+0xc1/0x120
[  250.815869]  [<ffffffff81283810>] ? iomap_dax_rw+0x110/0x110
[  250.841350]  [<ffffffff81284c0a>] grab_mapping_entry+0x4a/0x220
[  250.868442]  [<ffffffff812851e9>] iomap_dax_fault+0xa9/0x3b0
[  250.894437]  [<ffffffffa02b15fe>] xfs_filemap_fault+0xce/0xf0 [xfs]
[  250.922805]  [<ffffffff811d3159>] __do_fault+0x79/0x100
[  250.947035]  [<ffffffff811d7a2b>] do_fault+0x49b/0x690
[  250.970964]  [<ffffffffa02b146c>] ? xfs_filemap_pmd_fault+0x9c/0x160 [xfs]
[  251.001812]  [<ffffffff811d94ba>] handle_mm_fault+0x61a/0xa50
[  251.027736]  [<ffffffff8106c3da>] __do_page_fault+0x22a/0x4a0
[  251.053700]  [<ffffffff8106c680>] do_page_fault+0x30/0x80
[  251.077962]  [<ffffffff81003b55>] ? do_syscall_64+0x175/0x180
[  251.103835]  [<ffffffff8171e208>] page_fault+0x28/0x30


# kernel versions:

v4.6 pass in seconds
v4.7 hang
v4.9-rc1 hang
Linus tree to commit 9fe68ca hang

bisect points to 
 first bad commit: [ac401cc782429cc8560ce4840b1405d603740917] dax: New fault locking

v4.7 with these 3 commits reverted pass:
4d9a2c8 - Jan Kara, 6 months ago : dax: Remove i_mmap_lock protection
bc2466e - Jan Kara, 6 months ago : dax: Use radix tree entry lock to protect cow faults
ac401cc - Jan Kara, 6 months ago : dax: New fault locking

# nvml version:
https://github.com/pmem/nvml.git
to commit:
  feab4d6f65102139ce460890c898fcad09ce20ae

# How reproducible:
always

# Test steps:

<git clone and pmem0 setup>

$cd nvml
$make install -j64

$cat > src/test/testconfig.sh <<EOF
PMEM_FS_DIR=/daxmnt
NON_PMEM_FS_DIR=/tmp
EOF

$mkfs.xfs /dev/pmem0
$mkdir -p /daxmnt/
$mount -o dax /dev/pmem0 /daxmnt/

$make -C src/test/vmmalloc_fork/ TEST_TIME=60m clean
$make -C src/test/vmmalloc_fork/ TEST_TIME=60m check
$umount /daxmnt
