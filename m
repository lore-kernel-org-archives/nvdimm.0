Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529AA46426
	for <nvdimm@lists.linux.dev>; Tue, 18 Jun 2024 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718725896; cv=none; b=PIg1YUsAuFJjmyuXEsEBKw+n5lOG7U9yjc4gE39qPqyx4c0kM5BNOQpsPhIlEjBDxr4OI+4QBTC9ioFx5omWy/M23k2MNHWHhyGb5PAgWpKbcSz4H+Eqnw06ANEkvZmdgi+xgd3MgzAzAiWQ8aOZf/I6LL3tEzFFEqsUhlmZrmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718725896; c=relaxed/simple;
	bh=zsDwPG7tzMjzFGmeJoQG1AV2T9WH9A6kVLeIwITuy6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gRan5MyMaJpKWhjwMX/t5qn2+CUSAjqba58HCslkVrbML+2kS6QZvURiodnKZ6DDFzPQ1kDlIR04QCEoEXmZxNJWiQKFHhtz9mDey6X/V53FlNaRp/kGKvh04CGGa1bsMAsZ3w2qbpfaUagVtd/tgfoXmfic+38WePvclawxPa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=JdwSHdYu; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="JdwSHdYu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1718725286;
	bh=zsDwPG7tzMjzFGmeJoQG1AV2T9WH9A6kVLeIwITuy6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdwSHdYufZBIcz1XoKPrk/TGj0oRY8Eih1B7gx8oJ53OuGcFi2bx2dtPD87lQJ0sn
	 5TJiMafMHN1FPtKE2au/JqTWmfHiQ/gaJI/1HUkeapGdYKSDz1yJUyTNBcm5pbBNgl
	 r3I+zeJyO9JY1K0nqjNSFB58woQuCiDBaQA/n53AhvxzMDpWDMTYQaT+rIjOmHJj/b
	 RSWq5or3aY+GRlnhJcWtHlhgxuyom9AkePTj6MQkjMoGeLHBhaJ0InVRvuSgXqMjB6
	 Ejo7svBkytwJdM2zEA76F75V9ykToB7c5Jv+KjQ58D2HNARqI9TNasYDOuMx+ixhRX
	 0x31/g1CjnfpQ==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4W3WFL4tw2z16qH;
	Tue, 18 Jun 2024 11:41:26 -0400 (EDT)
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
Subject: [RFC PATCH 4/4] x86: Invoke pre_restart notifiers
Date: Tue, 18 Jun 2024 11:41:57 -0400
Message-Id: <20240618154157.334602-5-mathieu.desnoyers@efficios.com>
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

Invoke the pre_restart notifiers after shutdown, before machine restart.
This allows preserving pmem memory across warm reboots.

Invoke the pre_restart notifiers on emergency_machine_restart to cover
the panic() scenario.

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
---
 arch/x86/kernel/reboot.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f3130f762784..222619fa63c6 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -631,8 +631,10 @@ static void native_machine_emergency_restart(void)
 	int orig_reboot_type = reboot_type;
 	unsigned short mode;
 
-	if (reboot_emergency)
+	if (reboot_emergency) {
+		do_kernel_pre_restart(NULL);
 		emergency_reboot_disable_virtualization();
+	}
 
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 
@@ -760,12 +762,13 @@ static void __machine_emergency_restart(int emergency)
 	machine_ops.emergency_restart();
 }
 
-static void native_machine_restart(char *__unused)
+static void native_machine_restart(char *cmd)
 {
 	pr_notice("machine restart\n");
 
 	if (!reboot_force)
 		machine_shutdown();
+	do_kernel_pre_restart(cmd);
 	__machine_emergency_restart(0);
 }
 
-- 
2.39.2

