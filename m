Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A07A45C16
	for <nvdimm@lists.linux.dev>; Tue, 18 Jun 2024 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718725896; cv=none; b=pECqqBMwpXoecuTdrh2mIY4w9L6HzJbPLBz2dLU5hQ/KTrbK6ODC8ayrFedUnb+gwMX0T/CDynMaCc+heCAIUfNGyTSjX4zkGI6WupJJLkG/G1r1hWjxYaboZvGQ4Cwj9v0E4aFEHEWFqlYMZn7n0UB7HHSxrfFghOZGgyAfhts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718725896; c=relaxed/simple;
	bh=EC4aqitERxCehlbxkC0+MICQzxA9puJoMAcU63x/ppQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JEuocg6d+VolNd+h+fqRDgKT8Yvk+iewlwkeAZJmYmN4FMXr0sqMP3UkxIzYu/S6X0zF8dSgsPrxTB7NyKrj5CR+/0CwPfo9PcY/KsCY9jtScwLlKI3ZwUrPx/Pd+oLqorvB2ene6IVbJpePOlGhrDRuATUgLurfN1iwuKkYJVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=PbLw1o/q; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="PbLw1o/q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1718725286;
	bh=EC4aqitERxCehlbxkC0+MICQzxA9puJoMAcU63x/ppQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbLw1o/q0ac0JhAzMHAQOtpU6u6hhhphom/imkTrN1lbbDJ7bPUizbKpcFnISjWi2
	 AjjbVwuCJxj4zv8YT6DHab0xJO0glqLjLdgCGLAjWZQ3KKWJt1cMbnpaCFxS7Kmpt/
	 3R2g2E7F9m0QdjWiULG1fPDdjpYK2/BwuvDq6OxUUxO0odHN5O75SQfHID3Zai2uH2
	 S76+zYWU97obK98s5lAMDZ/7ig0iE0wiDL2Y8TCFvN+8hVIHyJcNXXwXMnTZAjQDWz
	 Wg9XUfip1k7A8LUS3y1dqY0QOZOs6xADKHlMHieGrET5DMvGEd/F6vBXCQwHLVlvTC
	 A8Qegl7XPsMVw==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4W3WFL28PNz16Pn;
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
Subject: [RFC PATCH 3/4] arm64: Invoke pre_restart notifiers
Date: Tue, 18 Jun 2024 11:41:56 -0400
Message-Id: <20240618154157.334602-4-mathieu.desnoyers@efficios.com>
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

Invoke the pre_restart notifiers before emergency machine restart as
well to cover the panic() scenario.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: nvdimm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/kernel/process.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 4ae31b7af6c3..4a27397617fb 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -129,6 +129,8 @@ void machine_restart(char *cmd)
 	local_irq_disable();
 	smp_send_stop();
 
+	do_kernel_pre_restart(cmd);
+
 	/*
 	 * UpdateCapsule() depends on the system being reset via
 	 * ResetSystem().
-- 
2.39.2

