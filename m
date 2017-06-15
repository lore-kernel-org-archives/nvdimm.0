Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 03C4321C8D637
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 22:03:11 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B585EAC02C9
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 14:04:21 +0900 (JST)
Date: Thu, 15 Jun 2017 14:04:16 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Panic when make check for ndctl
In-Reply-To: <CAPcyv4imhz5b1znjn1z9ak9aMijYmbJqZ5xcL5YT_b420jhnTQ@mail.gmail.com>
References: <20170614114155.6D1E.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4imhz5b1znjn1z9ak9aMijYmbJqZ5xcL5YT_b420jhnTQ@mail.gmail.com>
Message-Id: <20170615140413.5955.E1E9C6FF@jp.fujitsu.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> 
> Care to resend this as a formal patch with a "Signed-off-by:"? I'll
> get it applied.

Ok!

-----
    Fix the panic when nfit_test.ko is used.
    
    The root cause of panic is the num_pm of nfit_test1 is wrong.
    Though 1 is specified for num_pm at nfit_test_init(), it must be 2,
    because nfit_test1->spa_set[] array has 2 elements.
    
    Since the array is smaller than expected, the driver breaks other area.
    (it is often the link list of devres).
    
    As a result, panic occurs like the following example.
    ---
      117.741905] CPU: 4 PID: 2233 Comm: lt-libndctl Tainted: G           O    4.12.0-rc1+ #12
    [  117.744461] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
    [  117.746310] task: ffff88041d685500 task.stack: ffffc90002b50000
    [  117.748198] RIP: 0010:__list_del_entry_valid+0x6c/0xa0
    [  117.751084] RSP: 0018:ffffc90002b53d60 EFLAGS: 00010046
    [  117.753142] RAX: 0000000000000054 RBX: ffffc9001700e000 RCX: 0000000000000000
    [  117.755955] RDX: 0000000000000000 RSI: ffff88043310e0a8 RDI: ffff88043310e0a8
    [  117.758745] RBP: ffffc90002b53d60 R08: 00000000fffffffe R09: 0000000000000382
    [  117.760801] R10: 0000000000000005 R11: 0000000000000381 R12: ffffc90002b53d98
    [  117.762949] R13: ffffc9001700e000 R14: 0000000000000000 R15: ffff88041beefc08
    [  117.765000] FS:  00007f7d70082c80(0000) GS:ffff880433100000(0000) knlGS:0000000000000000
    [  117.767300] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  117.768962] CR2: 000055c0db522cc0 CR3: 0000000422156000 CR4: 00000000000006e0
    [  117.770975] Call Trace:
    [  117.771716]  release_nodes+0x76/0x260
    [  117.772797]  devres_release_all+0x3c/0x50
    [  117.773981]  device_release_driver_internal+0x159/0x200
    [  117.775494]  device_release_driver+0x12/0x20
    [  117.776763]  bus_remove_device+0xfd/0x170
    [  117.777924]  device_del+0x1e8/0x330
    [  117.778943]  platform_device_del+0x28/0x90
    [  117.780129]  platform_device_unregister+0x12/0x30
    [  117.781483]  nfit_test_exit+0x2a/0x93b [nfit_test]
    [  117.782858]  SyS_delete_module+0x171/0x250
    [  117.784044]  entry_SYSCALL_64_fastpath+0x1a/0xa5
    ---
    
    Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 tools/testing/nvdimm/test/nfit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index c218717..548b6d4 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1943,7 +1943,7 @@ static __init int nfit_test_init(void)
 			nfit_test->setup = nfit_test0_setup;
 			break;
 		case 1:
-			nfit_test->num_pm = 1;
+			nfit_test->num_pm = 2;
 			nfit_test->dcr_idx = NUM_DCR;
 			nfit_test->num_dcr = 2;
 			nfit_test->alloc = nfit_test1_alloc;
---
Yasunori Goto

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
