Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542CF46435
	for <nvdimm@lists.linux.dev>; Tue, 18 Jun 2024 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718725897; cv=none; b=ZPr45qbGjRvp65zRyhOeElYblPuXUuyOOTcC9gTb+CcTXQxCpLR79auJCKXHUGQF5xxidToyOdOIeARN2C/SFM+8IkVrnaLRAIbfR4H0FnXco1TW8FZslLaOhbSsUbQ62JE/CvOUKaTg26fNA4wbI2d7q5nDcKmCmRmJa7PkEZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718725897; c=relaxed/simple;
	bh=jTsRXZWDrdZtdx6WmpzbW/Nftt5x+XgMG9sQFaT8uLA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gufQfHf2uJ6pBxlkCvp527N8CvCtxoGrsBCTOC3BLMJfcZoNu+xwc7qXDjhvadbJKCX5cSEkvRl3Bv+MsksAS0j9ceCnGCex3IYHQu+upHWg0Jtkfk8AovQunN/OgI6HczY0/XHEjLdKVgelwIIt/r2Eqed6DrAqhHH4wy4Pf1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=BdmTw2rV; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="BdmTw2rV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1718725285;
	bh=jTsRXZWDrdZtdx6WmpzbW/Nftt5x+XgMG9sQFaT8uLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdmTw2rVkWR9+JJqI+o4JX5VlLiPCM1FILZZebXr7UYTqaAu4ZgXN67HxRBAqLs3o
	 uiqycDFqGX5WMcgh/bQb1YaJ+Vo1NA56c+ymHFoL809xggEiEZUBhnctZY8sLWR7fH
	 uE+Q+8PRam0T2BSpjnZyiPCZ5b3/PZqMZLkekmC9qI5smi6e9hysqUdHJKchOWsfDl
	 +jv5pkhTpQylxH8Bi7utC+Ag+o+T7LBRqlqdpTHDLeHeYhPbg1dWH8hPrHIeQZ5zfM
	 SNccLW3MpIavcOg/dFWT2LbKxwTkj9/ktR/kx1qU8Z7IaTxxDMs+tYaYWMpzoX6H/f
	 bVZR18PU4rfag==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4W3WFK3bDsz171G;
	Tue, 18 Jun 2024 11:41:25 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 1/4] kernel/reboot: Introduce pre_restart notifiers
Date: Tue, 18 Jun 2024 11:41:54 -0400
Message-Id: <20240618154157.334602-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240618154157.334602-1-mathieu.desnoyers@efficios.com>
References: <20240618154157.334602-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new pre_restart notifier chain for callbacks that need to
be executed after the system has been made quiescent with
syscore_shutdown(), before machine restart.

This pre_restart notifier chain should be invoked on machine restart and
on emergency machine restart.

The use-case for this new notifier chain is to preserve tracing data
within pmem areas on systems where the BIOS does not clear memory across
warm reboots.

Why do we need a new notifier chain ?

1) The reboot and restart_prepare notifiers are called too early in the
   reboot sequence: they are invoked before syscore_shutdown(), which
   leaves other CPUs actively running threads while those notifiers are
   invoked.

2) The "restart" notifier is meant to trigger the actual machine
   restart, and is not meant to be invoked as a last step immediately
   before restart. It is also not always used: some architecture code
   choose to bypass this restart notifier and reboot directly from the
   architecture code.

Wiring up the architecture code to call this notifier chain is left to
follow-up arch-specific patches.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: nvdimm@lists.linux.dev
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
---
 include/linux/reboot.h |  4 ++++
 kernel/reboot.c        | 51 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index abcdde4df697..c7f340e81451 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -50,6 +50,10 @@ extern int register_restart_handler(struct notifier_block *);
 extern int unregister_restart_handler(struct notifier_block *);
 extern void do_kernel_restart(char *cmd);
 
+extern int register_pre_restart_handler(struct notifier_block *);
+extern int unregister_pre_restart_handler(struct notifier_block *);
+extern void do_kernel_pre_restart(char *cmd);
+
 /*
  * Architecture-specific implementations of sys_reboot commands.
  */
diff --git a/kernel/reboot.c b/kernel/reboot.c
index 22c16e2564cc..b7287dd48d35 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -235,6 +235,57 @@ void do_kernel_restart(char *cmd)
 	atomic_notifier_call_chain(&restart_handler_list, reboot_mode, cmd);
 }
 
+/*
+ *	Notifier list for kernel code which wants to be called immediately
+ *	before restarting the system.
+ */
+static ATOMIC_NOTIFIER_HEAD(pre_restart_handler_list);
+
+/**
+ *	register_pre_restart_handler - Register function to be called in preparation
+ *				       to reset the system
+ *	@nb: Info about handler function to be called
+ *
+ *	Registers a function with code to be called in preparation to restart
+ *	the system.
+ *
+ *	Currently always returns zero, as atomic_notifier_chain_register()
+ *	always returns zero.
+ */
+int register_pre_restart_handler(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&pre_restart_handler_list, nb);
+}
+EXPORT_SYMBOL(register_pre_restart_handler);
+
+/**
+ *	unregister_pre_restart_handler - Unregister previously registered
+ *					 pre-restart handler
+ *	@nb: Hook to be unregistered
+ *
+ *	Unregisters a previously registered pre-restart handler function.
+ *
+ *	Returns zero on success, or %-ENOENT on failure.
+ */
+int unregister_pre_restart_handler(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&pre_restart_handler_list, nb);
+}
+EXPORT_SYMBOL(unregister_pre_restart_handler);
+
+/**
+ *	do_kernel_pre_restart - Execute kernel pre-restart handler call chain
+ *
+ *	Calls functions registered with register_pre_restart_handler.
+ *
+ *	Expected to be called from machine_restart and
+ *	machine_emergency_restart before invoking the restart handlers.
+ */
+void do_kernel_pre_restart(char *cmd)
+{
+	atomic_notifier_call_chain(&pre_restart_handler_list, reboot_mode, cmd);
+}
+
 void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
-- 
2.39.2

