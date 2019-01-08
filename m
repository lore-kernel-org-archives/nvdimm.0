Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com
 [IPv6:2607:f8b0:4864:20::943])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0C60211B1FA5
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 15:10:28 -0800 (PST)
Received: by mail-ua1-x943.google.com with SMTP id d2so1842688ual.2
 for <linux-nvdimm@lists.01.org>; Tue, 08 Jan 2019 15:10:28 -0800 (PST)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com.
 [209.85.217.44])
 by smtp.gmail.com with ESMTPSA id w65sm42092218vsc.16.2019.01.08.15.10.25
 for <linux-nvdimm@lists.01.org>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 08 Jan 2019 15:10:25 -0800 (PST)
Received: by mail-vs1-f44.google.com with SMTP id n13so3609244vsk.4
 for <linux-nvdimm@lists.01.org>; Tue, 08 Jan 2019 15:10:25 -0800 (PST)
MIME-Version: 1.0
From: Kees Cook <keescook@chromium.org>
Date: Tue, 8 Jan 2019 15:10:12 -0800
Message-ID: <CAGXu5jKUP9o-ZgW5Wa5-9DHeQNZ5VA3cLBCJ0P7AVkTQ5tqHtQ@mail.gmail.com>
Subject: nvdimm crash at boot
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
To: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This is a warn that I added to fail more gracefully (sorry for
whitespace damage):

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 4890310df874..1161b994b1ec 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -516,6 +516,8 @@ static umode_t nvdimm_visible(struct kobject
*kobj, struct attribute *a, int n)
                return a->mode;
        if (nvdimm->sec.state < 0)
                return 0;
+       if (WARN_ON_ONCE(!nvdimm->sec.ops))
+               return 0;
        /* Are there any state mutation ops? */
        if (nvdimm->sec.ops->freeze || nvdimm->sec.ops->disable
                        || nvdimm->sec.ops->change_key

Without it, I would crash at boot due to the sec.ops dereference. It's
not clear to me if there is a better solution than just the sec.ops
NULL test (i.e. should it ever be NULL?)

[    1.393599] WARNING: CPU: 3 PID: 484 at
drivers/nvdimm/dimm_devs.c:519 nvdimm_visible+0x79/0x80
[    1.393858] Modules linked in:
[    1.393858] CPU: 3 PID: 484 Comm: kworker/u8:3 Not tainted 5.0.0-rc1+ #926
[    1.393858] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.10.2-1ubuntu1 04/01/2014
[    1.396781] Workqueue: events_unbound async_run_entry_fn
[    1.396781] RIP: 0010:nvdimm_visible+0x79/0x80
[    1.396781] Code: e8 4c fc ff ff eb c7 48 83 78 20 00 75 e6 48 83
78 10 00 75 df 48 83 78 28 00 75 d8 48 83 78 30 00 75 d1 b8 24 01 00
00 eb b1 <0f> 0b eb ad 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 41 57 41 56
41 55
[    1.396781] RSP: 0000:ffffb911803abd00 EFLAGS: 00010246
[    1.396781] RAX: 0000000000000000 RBX: ffffffff98cf5a80 RCX: 00000000000001a4
[    1.396781] RDX: 0000000000000004 RSI: ffffffff98cf5a80 RDI: ffff94e7ed088028
[    1.396781] RBP: ffffb911803abd10 R08: 0000000000000000 R09: 0000000000000001
[    1.396781] R10: ffffb911803abaf8 R11: 0000000000000000 R12: ffff94e7ed088028
[    1.396781] R13: ffff94e7ed088028 R14: ffffffff98cf5a60 R15: 0000000000000000
[    1.396781] FS:  0000000000000000(0000) GS:ffff94e7efb80000(0000)
knlGS:0000000000000000
[    1.396781] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.396781] CR2: 00000000ffffffff CR3: 0000000150822001 CR4: 00000000001606e0
[    1.396781] Call Trace:
[    1.396781]  internal_create_group+0xf4/0x380
[    1.396781]  sysfs_create_groups+0x46/0xb0
[    1.396781]  device_add+0x331/0x680
[    1.396781]  nd_async_device_register+0x15/0x60
[    1.396781]  async_run_entry_fn+0x38/0x100
[    1.396781]  process_one_work+0x22b/0x5a0
[    1.396781]  worker_thread+0x3f/0x3b0
[    1.396781]  kthread+0x12b/0x150
[    1.396781]  ? process_one_work+0x5a0/0x5a0
[    1.396781]  ? kthread_park+0xa0/0xa0
[    1.396781]  ret_from_fork+0x24/0x30
[    1.396781] irq event stamp: 952
[    1.396781] hardirqs last  enabled at (951): [<ffffffff973f5cb4>]
__slab_alloc.constprop.79+0x44/0x70
[    1.396781] hardirqs last disabled at (952): [<ffffffff97201cf0>]
trace_hardirqs_off_thunk+0x1a/0x1c
[    1.396781] softirqs last  enabled at (0): [<ffffffff97267ae3>]
copy_process.part.55+0x413/0x1f10
[    1.396781] softirqs last disabled at (0): [<0000000000000000>]
      (null)
[    1.396781] ---[ end trace 5608ce056f09564f ]---

I assume this crash is due to be using nvdimm without any special
markings (i.e. I'm using it crudely with pstore), in KVM:

RAM_SIZE=16384
NVDIMM_SIZE=128
MAX_SIZE=$(( RAM_SIZE + NVDIMM_SIZE ))

sudo qemu-system-x86_64 \
  ...
        -machine pc,nvdimm \
        -m ${RAM_SIZE}M,slots=2,maxmem=${MAX_SIZE}M \
        -object
memory-backend-file,id=mem1,share=on,mem-path=nvdimm.img,size=${NVDIMM_SIZE}M,align=128M
\
        -device nvdimm,id=nvdimm1,memdev=mem1 \
...
        -append '... ramoops.mem_size=1048576 ramoops.ecc=1
ramoops.mem_address=0x440000000 ramoops.console_size=16384
ramoops.ftrace_size=16384 ramoops.pmsg_size=16384
ramoops.record_size=32768'

I assume 37833fb7989a9 ("acpi/nfit, libnvdimm: Add freeze security
support to Intel nvdimm") was where it started, but I didn't actually
bisect.

-- 
Kees Cook
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
