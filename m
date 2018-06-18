Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4D2420968900
 for <linux-nvdimm@lists.01.org>; Sun, 17 Jun 2018 21:51:36 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id BC1F1AC017D
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 13:51:28 +0900 (JST)
Date: Mon, 18 Jun 2018 13:49:46 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Bug on ndctl ? (failed to create namespace: No such device or address)
Message-Id: <20180618134944.587E.E1E9C6FF@jp.fujitsu.com>
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
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

I found a trouble when I use a box which has real NVDIMM, and tried to
configure namespaces on it with ndctl. 
ndctl failed to create namespace when some namespace are created, and destroyed.

Does anyone can reproduce this problem? I hope this issue will be solved...


Here is how to reproduce...
---
1) Make some namespaces on a region.
  In this case, 4 x 30GB namespaces are created in a 250GB region.

$ sudo ndctl create-namespace -n "hoge0" -m fsdax -s 30G
{
  "dev":"namespace0.0",
  "mode":"fsdax",
  "size":"29.53 GiB (31.71 GB)",
  "uuid":"06be449f-794c-4574-900c-dd1be8c8465a",
  "sector_size":512,
  "blockdev":"pmem0",
  "name":"hoge0",
  "numa_node":0
}

$ sudo ndctl create-namespace -n "hoge1" -m fsdax -s 30G
{
  "dev":"namespace0.2",
  "mode":"fsdax",
  "size":"29.53 GiB (31.71 GB)",
  "uuid":"fcce6b79-be23-4fff-a4b5-17f3154555a2",
  "sector_size":512,
  "blockdev":"pmem0.2",
  "name":"hoge1",
  "numa_node":0
}

$ sudo ndctl create-namespace -n "hoge2" -m fsdax -s 30G
{
  "dev":"namespace0.1",
  "mode":"fsdax",
  "size":"29.53 GiB (31.71 GB)",
  "uuid":"59a7e231-ad54-44a3-99d7-cb760d7e5cb6",
  "sector_size":512,
  "blockdev":"pmem0.1",
  "name":"hoge2",
  "numa_node":0
}

$ sudo ndctl create-namespace -n "hoge3" -m fsdax -s 30G
{
  "dev":"namespace0.3",
  "mode":"fsdax",
  "size":"29.53 GiB (31.71 GB)",
  "uuid":"fa8d6951-b83e-4093-872a-1a815d2d864e",
  "sector_size":512,
  "blockdev":"pmem0.3",
  "name":"hoge3",
  "numa_node":0
}
---

2) Disable and destroy -the second- namespace.

---
$ sudo ndctl disable-namespace "namespace0.1" 
disabled 1 namespace

$ sudo ndctl destroy-namespace "namespace0.1" 
destroyed 1 namespace
---

3) Try to create new namespace without specifying size.

---
$ sudo ndctl create-namespace -n "hoge5" -m fsdax
failed to create namespace: No such device or address          <-----  !!!
---

(I guess ndctl tried to allocate namespace by available size which is
 the -total amount of free space- of the region, but nvdimm driver
 needs a contiguous free spaces which is smaller than the available size 
 in this case. But I'm not sure.)


In addition, kernel shows the following warnings.

---
[  695.183696] ------------[ cut here ]------------
[  695.188855] nd_region region0: allocation underrun: 0x0 of 0x1400000000 bytes
[  695.196873] WARNING: CPU: 32 PID: 1975 at drivers/nvdimm/namespace_devs.c:913 size_store+0x879/0x8d0 [libnvdimm]
[  695.208231] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables sunrpc vfat fat ext4 mbcache jbd2 intel_rapl skx_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ipmi_ssif nd_pmem intel_cstate ipmi_si intel_uncore joydev mei_me nd_btt ioatdma dax_pmem shpchp device_dax iTCO_wdt iTCO_vendor_support ipmi_devintf
[  695.287872]  pcspkr mei nfit intel_rapl_perf ipmi_msghandler i2c_i801 lpc_ich libnvdimm xfs libcrc32c mgag200 ixgbe drm_kms_helper igb ttm mdio ptp uas pps_core drm crc32c_intel usb_storage dca i2c_algo_bit
[  695.308355] CPU: 32 PID: 1975 Comm: ndctl Not tainted 4.17.0-rc7 #16
[  695.315439] Hardware name: FUJITSU PRIMEQUEST 3800E/D3858-A1, BIOS V1.0.0.0 R0.2.0 for D3858-A1x             06/14/2018
[  695.327477] RIP: 0010:size_store+0x879/0x8d0 [libnvdimm]
[  695.333405] RSP: 0018:ffffc0a9c6d97d38 EFLAGS: 00010282
[  695.339236] RAX: 0000000000000000 RBX: ffff9a24eef1bc08 RCX: 0000000000000000
[  695.347201] RDX: ffff9a24fe21ca40 RSI: ffff9a24fe2165b8 RDI: ffff9a24fe2165b8
[  695.355164] RBP: 0000000000000000 R08: 0000000000002122 R09: 0000000000000007
[  695.363129] R10: fffff0b5a1dd66c0 R11: ffffffffaea41ccd R12: ffff9a24f7b50ff8
[  695.371091] R13: ffff9a24f85f13c8 R14: ffffc0a9c6d97da6 R15: ffff9a24f85f1000
[  695.379054] FS:  00007f8977650780(0000) GS:ffff9a24fe200000(0000) knlGS:0000000000000000
[  695.388084] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  695.394496] CR2: 00007fec422c0140 CR3: 00000008333bc003 CR4: 00000000007606e0
[  695.402460] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  695.410423] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  695.418386] PKRU: 55555554
[  695.421405] Call Trace:
[  695.424143]  ? __kmalloc+0x5a/0x210
[  695.428038]  kernfs_fop_write+0x10f/0x190
[  695.432517]  __vfs_write+0x36/0x180
[  695.436414]  ? selinux_file_permission+0x11d/0x130
[  695.441762]  ? security_file_permission+0x2a/0xb0
[  695.447011]  vfs_write+0xad/0x1a0
[  695.450710]  ksys_write+0x52/0xc0
[  695.454413]  do_syscall_64+0x5b/0x160
[  695.458505]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  695.464143] RIP: 0033:0x7f897693d7a4
[  695.468131] RSP: 002b:00007fff7aa5e0a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  695.476579] RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007f897693d7a4
[  695.484544] RDX: 000000000000000e RSI: 00007fff7aa5e0f0 RDI: 0000000000000003
[  695.492509] RBP: 00007fff7aa5e0f0 R08: 000000000000000a R09: 0000000000000000
[  695.500472] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
[  695.508435] R13: 0000000000000000 R14: 00007f89776506b0 R15: 0000000000000002
[  695.516399] Code: 50 48 29 c5 4d 85 e4 74 4c 4c 89 ff e8 01 66 12 ed 4c 8b 44 24 38 48 89 e9 4c 89 e2 48 89 c6 48 c7 c7 20 0c 41 c0 e8 07 b0 c9 ec <0f> 0b e9 8e fd ff ff e8 8b b2 c9 ec 48 c7 c6 00 f1 40 c0 48 c7 
[  695.537470] ---[ end trace 91e4a4668f52f7dc ]---
----


This warning seems to be the following line.
---
static int grow_dpa_allocation(struct nd_region *nd_region,
                struct nd_label_id *label_id, resource_size_t n)
{
        struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
        bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
        int i;
  :
  :
                }

                dev_WARN_ONCE(&nd_region->dev, rem,                                <----!!!
                                "allocation underrun: %#llx of %#llx bytes\n",     <----!!!
                                (unsigned long long) n - rem,                      <----!!!
                                (unsigned long long) n);                           <----!!!

---

Thanks,

Yasunori Goto



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
