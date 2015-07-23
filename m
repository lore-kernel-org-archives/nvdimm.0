Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] x86/panic/reboot: Flush processor caches during panic/reboot
Date: Thu, 23 Jul 2015 11:33:30 -0600
Message-Id: <1437672810-9641-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: bp@alien8.de, linux-kernel@vger.kernel.org, x86@kernel.org, linux-nvdimm@lists.01.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

During power failure, Asynchronous DRAM Refresh (ADR) flushes
the write buffer in memory controllers into NVDIMM, but does not
flush processor caches.  While the kernel and application code
need to take care of processor cache flush, they may not be able
to do so during panic or reboot.

Add processor cache flush (wbinvd) to the stop-CPUs interfaces,
native_stop_other_cpus() and nmi_shootdown_cpus(), which are
called during panic and reboot as follows.  These wbinvd()s are
called on each CPU after its irq/APIC is disabled.

  - panic()
    + smp_send_stop()
       o native_stop_other_cpus()
          o stop_this_cpu()

  - native_machine_restart()
  - native_machine_halt()
  - native_machine_power_off()
     + native_machine_shutdown()
        + stop_other_cpus()
           o native_stop_other_cpus()
              o stop_this_cpu()

  - native_machine_crash_shutdown()
     + kdump_nmi_shootdown_cpus()
        o nmi_shootdown_cpus()
           o crash_nmi_callback()

Note, the cpu offline path, mwait_play_dead(), already calls
wbinvd().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
---
 arch/x86/kernel/process.c |    2 ++
 arch/x86/kernel/reboot.c  |    5 +++++
 arch/x86/kernel/smp.c     |    2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 397688b..3a1f381 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -320,6 +320,8 @@ void stop_this_cpu(void *dummy)
 	set_cpu_online(smp_processor_id(), false);
 	disable_local_APIC();
 
+	wbinvd();
+
 	for (;;)
 		halt();
 }
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 86db4bc..5ef4d4b 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -737,6 +737,9 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 	shootdown_callback(cpu, regs);
 
 	atomic_dec(&waiting_for_crash_ipi);
+
+	wbinvd();
+
 	/* Assume hlt works */
 	halt();
 	for (;;)
@@ -780,6 +783,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 	smp_send_nmi_allbutself();
 
+	wbinvd();
+
 	msecs = 1000; /* Wait at most a second for the other cpus to stop */
 	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
 		mdelay(1);
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 15aaa69..41e7ca8 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -244,6 +244,8 @@ finish:
 	local_irq_save(flags);
 	disable_local_APIC();
 	local_irq_restore(flags);
+
+	wbinvd();
 }
 
 /*
