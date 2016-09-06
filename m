From: yizhan <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernel BUG observed during ndctl Unit Tests on 4.8.0-rc2
Date: Tue, 6 Sep 2016 14:36:37 +0800
Message-ID: <cf9db200-7197-0036-5b6b-aa8b025ac77a@redhat.com>
References: <448644206.3016525.1471849509227.JavaMail.zimbra@redhat.com>
 <488108969.3025505.1471852323338.JavaMail.zimbra@redhat.com>
 <CAPcyv4jAOZ0tQWXpU3SMhytTPEmXvbSpPc2T=RKCVeeP-1Ks-A@mail.gmail.com>
 <4a567c42-3434-a558-5bff-8b482c754259@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <4a567c42-3434-a558-5bff-8b482c754259-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org



On 08/24/2016 03:45 AM, yizhan wrote:
>
>
> On 08/23/2016 07:08 AM, Dan Williams wrote:
>> On Mon, Aug 22, 2016 at 12:52 AM, Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> Hi folks
>>>
>>> I'm testing ndctl unit test on 4.8.0-rc2, always can encounter the 
>>> kernel BUG, anyone can help check it?
>>> I have list all the log below:
>>>
>>> http://pastebin.com/JUiEGQUE  -> devm_nvdimm_memremap+0x18d/0x280
>>> http://pastebin.com/MmazZj3K  -> kfree+0x56/0x170
>>> http://pastebin.com/4kbucxPy  -> kfree+0x56/0x170
>>> http://pastebin.com/kBsBicFM  -> kfree+0x56/0x170
>>> http://pastebin.com/CaVKTYzc  -> strcmp+0x16/0x30
>>> http://pastebin.com/pFWYWTDg  -> kfree+0x56/0x170
>>>
>>> Another server which have NVDIMM:
>>> http://pastebin.com/y25QT2Dz  -> __kmalloc+0x9d/0x200
>>> http://pastebin.com/z6xp2Usa  -> kfree+0x56/0x170
>>> http://pastebin.com/eqmiqivN  -> kfree+0x56/0x170
>>> http://pastebin.com/jA0RHSbf  -> kmem_cache_free+0x65/0x1e0
>> Can you send your kernel config and the full log since boot? When did
>> this start failing?  I.e. might it be possible to bisect?
> Hi Dan
>
> Finally found below commit introduced this bug by git bisect.
> 7bfe97c tools/testing/nvdimm: add virtual ramdisk range
>
> Below is the config and boot log:
> http://pastebin.com/TnLA5abh      kernel config
> http://pastebin.com/WDvjmH47    kernel dmesg
>
> Pls let me if you need more info.
>
> Thanks
> Yi
>
Still can reproduce this bug with latest 4.8.0-rc5
[  402.501425] nfit_test_iomap: loading out-of-tree module taints kernel.
[  402.682944] nfit_test nfit_test.0: found a zero length table '0' 
parsing nfit
[  407.818445] nd_pmem namespace9.0: unable to guarantee persistence of 
writes
[  411.881093] BUG: unable to handle kernel paging request at 
ffffeb04001f21e0
[  411.914752] IP: [<ffffffff81203946>] kfree+0x56/0x170
[  411.939037] PGD 0
[  411.949104] Oops: 0000 [#1] SMP
[  411.965429] Modules linked in: dax_pmem(O) dax(O) nd_pmem(O) 
nd_blk(O) nd_btt(O) nfit_test(O) nfit(O) libnvdimm(O) nfit_test_iomap(O) 
nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache intel_rapl sb_edac 
edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm 
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel 
lrw gf128mul glue_helper ablk_helper cryptd ipmi_ssif nfsd iTCO_wdt 
iTCO_vendor_support sg hpwdt hpilo auth_rpcgss pcspkr ioatdma ipmi_si 
nfs_acl lpc_ich shpchp dca wmi ipmi_msghandler lockd acpi_power_meter 
dm_multipath pcc_cpufreq acpi_cpufreq grace sunrpc ip_tables xfs 
libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel serio_raw tg3 
hpsa i2c_core ptp scsi_transport_sas pps_core fjes dm_mirror 
dm_region_hash dm_log dm_mod
[  412.301477] CPU: 16 PID: 1951 Comm: lt-libndctl Tainted: G           
O    4.8.0-rc5 #1
[  412.337398] Hardware name: HP ProLiant DL580 Gen8, BIOS P79 05/06/2015
[  412.366477] task: ffff8810567cc380 task.stack: ffff881057ad8000
[  412.393089] RIP: 0010:[<ffffffff81203946>] [<ffffffff81203946>] 
kfree+0x56/0x170
[  412.426805] RSP: 0018:ffff881057adba98  EFLAGS: 00010286
[  412.452199] RAX: 00000104001f21c0 RBX: ffffc90007c87000 RCX: 
0000000000000000
[  412.488005] RDX: 000077ff80000000 RSI: ffff881057adbb00 RDI: 
ffffc90007c87000
[  412.522869] RBP: ffff881057adbab0 R08: ffff881057adbad8 R09: 
0000000000000000
[  412.554930] R10: ffff88017fc07ac0 R11: ffffeb04001f21c0 R12: 
ffffc90007c87000
[  412.586984] R13: ffffffff812f6156 R14: ffff881057adbae8 R15: 
0000000000000000
[  412.619183] FS:  00007f9c0a713780(0000) GS:ffff88085ee00000(0000) 
knlGS:0000000000000000
[  412.655536] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  412.681360] CR2: ffffeb04001f21e0 CR3: 0000001042fbc000 CR4: 
00000000001406e0
[  412.713390] Stack:
[  412.722366]  000000000000001d ffffc90007c87000 ffff881057adbb74 
ffff881057adbb50
[  412.755570]  ffffffff812f6156 000000000000001d 00000000810cba60 
0000000000000000
[  412.788496]  0000000000000000 0000000000000000 0000000000000000 
0000000000000000
[  412.822277] Call Trace:
[  412.833915]  [<ffffffff812f6156>] 
security_context_to_sid_core+0x186/0x260
[  412.867033]  [<ffffffff812f83d6>] security_context_to_sid+0x16/0x20
[  412.898278]  [<ffffffff812e60c2>] selinux_inode_setsecurity+0x72/0x120
[  412.928125]  [<ffffffff812e618d>] selinux_inode_notifysecctx+0x1d/0x20
[  412.957585]  [<ffffffff812dc3a3>] security_inode_notifysecctx+0x43/0x60
[  412.990427]  [<ffffffff812ac252>] kernfs_refresh_inode+0xa2/0xe0
[  413.020435]  [<ffffffff812ac31d>] kernfs_iop_permission+0x3d/0x60
[  413.049525]  [<ffffffff812369a4>] __inode_permission+0x64/0xd0
[  413.075774]  [<ffffffff81236a28>] inode_permission+0x18/0x50
[  413.101493]  [<ffffffff81239d5b>] link_path_walk+0x30b/0x600
[  413.126994]  [<ffffffff81238086>] ? path_init+0x1f6/0x340
[  413.151317]  [<ffffffff8123a14f>] path_lookupat+0x7f/0x110
[  413.175933]  [<ffffffff8123bebf>] filename_lookup+0xaf/0x190
[  413.200997]  [<ffffffff8123ba63>] ? putname+0x53/0x60
[  413.223639]  [<ffffffff8123beff>] ? filename_lookup+0xef/0x190
[  413.250047]  [<ffffffff81202474>] ? kmem_cache_alloc+0x154/0x1a0
[  413.277021]  [<ffffffff8123babf>] ? getname_flags+0x4f/0x1f0
[  413.302405]  [<ffffffff8123badf>] ? getname_flags+0x6f/0x1f0
[  413.327767]  [<ffffffff8123c076>] user_path_at_empty+0x36/0x40
[  413.353934]  [<ffffffff81230ec6>] vfs_fstatat+0x66/0xc0
[  413.377461]  [<ffffffff81231501>] SYSC_newlstat+0x31/0x60
[  413.401858]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0
[  413.430018]  [<ffffffff811395eb>] ? __audit_syscall_exit+0x1db/0x260
[  413.458637]  [<ffffffff8123170e>] SyS_newlstat+0xe/0x10
[  413.482238]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[  413.510359]  [<ffffffff816f8b21>] entry_SYSCALL64_slow_path+0x25/0x25
[  413.542055] Code: 00 00 00 80 ff 77 00 00 49 bb 00 00 00 00 00 ea ff 
ff 48 01 d8 48 0f 42 15 d8 96 a0 00 48 01 d0 48 c1 e8 0c 48 c1 e0 06 49 
01 c3 <49> 8b 43 20 a8 01 0f 85 f7 00 00 00 49 8b 43 20 a8 01 0f 85 e2
[  413.628559] RIP  [<ffffffff81203946>] kfree+0x56/0x170
[  413.651651]  RSP <ffff881057adba98>
[  413.667275] CR2: ffffeb04001f21e0
[  413.682239] ---[ end trace bd155b1b1dec867c ]---
[  413.708253] Kernel panic - not syncing: Fatal exception
[  413.731959] Kernel Offset: disabled
[  413.752663] ---[ end Kernel panic - not syncing: Fatal exception


> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
