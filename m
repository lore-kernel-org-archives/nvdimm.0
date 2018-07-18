Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F321C2097F544
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 19:53:17 -0700 (PDT)
From: Baoquan He <bhe@redhat.com>
Subject: [PATCH v7 4/4] kexec_file: Load kernel at top of system RAM if
 required
Date: Wed, 18 Jul 2018 10:49:44 +0800
Message-Id: <20180718024944.577-5-bhe@redhat.com>
In-Reply-To: <20180718024944.577-1-bhe@redhat.com>
References: <20180718024944.577-1-bhe@redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, robh+dt@kernel.org, dan.j.williams@intel.com, nicolas.pitre@linaro.org, josh@joshtriplett.org, fengguang.wu@intel.com, bp@suse.de, andy.shevchenko@gmail.com
Cc: brijesh.singh@amd.com, devicetree@vger.kernel.org, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, jcmvbkbc@gmail.com, baiyaowei@cmss.chinamobile.com, kys@microsoft.com, frowand.list@gmail.com, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, Baoquan He <bhe@redhat.com>, linux-nvdimm@lists.01.org, patrik.r.jakobsson@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, dyoung@redhat.com, thomas.lendacky@amd.com, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, jglisse@redhat.com, seanpaul@chromium.org, bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, ebiederm@xmission.com, devel@linuxdriverproject.org, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

For kexec_file loading, if kexec_buf.top_down is 'true', the memory which
is used to load kernel/initrd/purgatory is supposed to be allocated from
top to down. This is what we have been doing all along in the old kexec
loading interface and the kexec loading is still default setting in some
distributions. However, the current kexec_file loading interface doesn't
do like this. The function arch_kexec_walk_mem() it calls ignores checking
kexec_buf.top_down, but calls walk_system_ram_res() directly to go through
all resources of System RAM from bottom to up, to try to find memory region
which can contain the specific kexec buffer, then call locate_mem_hole_callback()
to allocate memory in that found memory region from top to down. This brings
confusion especially when KASLR is widely supported , users have to make clear
why kexec/kdump kernel loading position is different between these two
interfaces in order to exclude unnecessary noises. Hence these two interfaces
need be unified on behaviour.

Here add checking if kexec_buf.top_down is 'true' in arch_kexec_walk_mem(),
if yes, call the newly added walk_system_ram_res_rev() to find memory region
from top to down to load kernel.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: kexec@lists.infradead.org
---
 kernel/kexec_file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index c6a3b6851372..75226c1d08ce 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -518,6 +518,8 @@ int __weak arch_kexec_walk_mem(struct kexec_buf *kbuf,
 					   IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY,
 					   crashk_res.start, crashk_res.end,
 					   kbuf, func);
+	else if (kbuf->top_down)
+		return walk_system_ram_res_rev(0, ULONG_MAX, kbuf, func);
 	else
 		return walk_system_ram_res(0, ULONG_MAX, kbuf, func);
 }
-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
