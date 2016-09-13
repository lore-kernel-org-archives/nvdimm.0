Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x22b.google.com (mail-ua0-x22b.google.com
 [IPv6:2607:f8b0:400c:c08::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B7E9C1A1DEA
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 19:30:17 -0700 (PDT)
Received: by mail-ua0-x22b.google.com with SMTP id v13so4237369uav.0
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 19:30:17 -0700 (PDT)
MIME-Version: 1.0
From: ryan chen <ryan.chan105@gmail.com>
Date: Tue, 13 Sep 2016 10:30:16 +0800
Message-ID: <CAC1QiQHNz7sgf=GcCmqLE-VQT4BxmD0M-XSaQqKL-ADqRt4pcg@mail.gmail.com>
Subject: Panic when insmod nfit_test.ko
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi all,
Recently I'm trying to check the testing suite of nfit_test for nvdimm
on 4.8-rc5, and system got panic once insmod nfit_test.ko ,
I've checked the RIP, I guess it panics due to NULL
nvdimm_map pointer, i.e., accessing nvdimm_map->mem,
so I have a question that, should we check the return value of
alloc_nvdimm_map if it failed:

--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -171,6 +171,9 @@ void *devm_nvdimm_memremap(struct device *dev,
resource_size_t offset,
                kref_get(&nvdimm_map->kref);
        nvdimm_bus_unlock(dev);

+       if (!nvdimm_map)
+               return NULL;
+
        if (devm_add_action_or_reset(dev, nvdimm_map_put, nvdimm_map))
                return NULL;
But why we got NULL nvdimm_map is still unknown,
please let me know if you need any information. Thanks.

Ubuntu 16.04.1 LTS robotech

robotech login: [ 2662.730895] calling  nfit_test_init+0x0/0x1000
[nfit_test] @ 5888
[ 2662.788659] nfit_test nfit_test.0: found a zero length table '0' parsing
nfit
[ 2662.796969] BUG: unable to handle kernel NULL pointer dereference at
0000000000000030
[ 2662.804896] IP: [<ffffffffc0522aa9>] devm_nvdimm_memremap+0x199/0x280
[libnvdimm]
[ 2662.812448] PGD 0
[ 2662.814499] Oops: 0000 [#1] SMP
[ 2662.817663] Modules linked in: nfit_test(OE+)
stap_39aaf7155948312a34c3fda4c85b1126_5881(OE) nfit_test_iomap(OE) nfit
nd_pmem nd_e820 dax_pmem nd_blk nd_btt libnvdimm dax(OE) asix usbnet
nls_iso8859_1 snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_usb_audio
snd_hda_core snd_usbmidi_lib snd_pcm intel_rapl snd_hwdep snd_seq_midi
x86_pkg_temp_thermal snd_seq_midi_event intel_powerclamp snd_rawmidi
coretemp crct10dif_pclmul snd_seq crc32_pclmul ghash_clmulni_intel
snd_timer snd_seq_device cryptd input_leds serio_raw joydev mei_me snd
lpc_ich mei shpchp soundcore mac_hid parport_pc ppdev lp parport autofs4
i915 hid_plantronics hid_generic i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect psmouse sysimgblt usbhid fb_sys_fops drm hid r8169 mii
pata_acpi video fjes [last unloaded: libnvdimm]
[ 2662.893231] CPU: 1 PID: 3428 Comm: kworker/u8:1 Tainted: G        W
OE   4.8.0-rc5+ #3
[ 2662.901272] Hardware name: Gigabyte Technology Co., Ltd. To be filled by
O.E.M./H61M-S2PH, BIOS F1 03/11/2013
[ 2662.911228] Workqueue: events_unbound async_run_entry_fn
[ 2662.916588] task: ffff950692c3aac0 task.stack: ffff950647e90000
[ 2662.922530] RIP: 0010:[<ffffffffc0522aa9>]  [<ffffffffc0522aa9>]
devm_nvdimm_memremap+0x199/0x280 [libnvdimm]
[ 2662.932506] RSP: 0018:ffff950647e93b68  EFLAGS: 00010246
[ 2662.937843] RAX: 0000000000000000 RBX: ffff950657696818 RCX:
ffff950692618300
[ 2662.945011] RDX: ffff95063b343540 RSI: 0000000000000282 RDI:
0000000000000282
[ 2662.952179] RBP: ffff950647e93ba0 R08: ffff95069f29c4c0 R09:
ffff95069a803900
[ 2662.959348] R10: ffff95069a803900 R11: ffff95063b343540 R12:
0000000000001000
[ 2662.966513] R13: 0000000000000000 R14: 000000ffffb63ac0 R15:
0000000000000000
[ 2662.973681] FS:  0000000000000000(0000) GS:ffff95069f280000(0000)
knlGS:0000000000000000
[ 2662.981809] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2662.987586] CR2: 0000000000000030 CR3: 0000000118f5e000 CR4:
00000000000406e0
[ 2662.994751] Stack:
[ 2662.996779]  ffff95063b343548 ffff95061b758400 0000000000000000
0000000000000000
[ 2663.004281]  ffff9506920ea818 ffff950692618318 ffff9506955a3000
ffff950647e93be8
[ 2663.011779]  ffffffffc05270a9 000000003b3a1d20 ffff950657696818
ffff950657696818
[ 2663.019275] Call Trace:
[ 2663.021739]  [<ffffffffc05270a9>] nd_region_activate+0x179/0x290
[libnvdimm]
[ 2663.028827]  [<ffffffffc05275a3>] nd_region_probe+0x53/0x1c0 [libnvdimm]
[ 2663.035563]  [<ffffffff9f2ab990>] ?
sysfs_do_create_link_sd.isra.2+0x70/0xb0
[ 2663.042649]  [<ffffffffc0523b15>] nvdimm_bus_probe+0x65/0x110
[libnvdimm]
[ 2663.049466]  [<ffffffff9f5609e4>] driver_probe_device+0x224/0x430
[ 2663.055591]  [<ffffffff9f560d6c>] __device_attach_driver+0x8c/0x100
[ 2663.061893]  [<ffffffff9f560ce0>] ? __driver_attach+0xf0/0xf0
[ 2663.067669]  [<ffffffff9f55e5a7>] bus_for_each_drv+0x67/0xb0
[ 2663.073355]  [<ffffffff9f56064d>] __device_attach+0xdd/0x160
[ 2663.079040]  [<ffffffff9f560e23>] device_initial_probe+0x13/0x20
[ 2663.085074]  [<ffffffff9f55f812>] bus_probe_device+0x92/0xa0
[ 2663.090759]  [<ffffffff9f55d395>] device_add+0x435/0x6a0
[ 2663.096100]  [<ffffffffc0523142>] nd_async_device_register+0x12/0x40
[libnvdimm]
[ 2663.103525]  [<ffffffff9f0a43e7>] async_run_entry_fn+0x37/0x150
[ 2663.109474]  [<ffffffff9f09b41b>] process_one_work+0x16b/0x480
[ 2663.115330]  [<ffffffff9f09b77b>] worker_thread+0x4b/0x500
[ 2663.120840]  [<ffffffff9f09b730>] ? process_one_work+0x480/0x480
[ 2663.126875]  [<ffffffff9f0a1958>] kthread+0xd8/0xf0
[ 2663.131777]  [<ffffffff9f82045f>] ret_from_fork+0x1f/0x40
[ 2663.137204]  [<ffffffff9f0a1880>] ? kthread_create_on_node+0x1a0/0x1a0
[ 2663.143761] Code: 41 0f c1 47 38 83 c0 01 83 f8 01 7e 4a 48 89 df e8 2d
f6 ff ff 4c 89 fa 48 c7 c6 c0 28 52 c0 48 89 df e8 8b 1a 04 df 85 c0 75 13
<49> 8b 47 30 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 4c 89
[ 2663.164032] RIP  [<ffffffffc0522aa9>] devm_nvdimm_memremap+0x199/0x280
[libnvdimm]
[ 2663.171657]  RSP <ffff950647e93b68>
[ 2663.175164] CR2: 0000000000000030
[ 2663.192806] ---[ end trace 36b4fc6662c45075 ]---


Ryan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
