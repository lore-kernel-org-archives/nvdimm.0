Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AD23EA76
	for <nvdimm@lists.linux.dev>; Tue, 18 Jun 2024 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718725896; cv=none; b=VtbfwChWklivfxCFBzb9JmgStHK3IiM+Wq8Kr89xeptkLqKYxhMDGJQADRSZVlUZ2VL9ObU7zbs29t/VKPNivG1ZprwSRZFZ22/M0Y2oEREE80kLiGYEhTQ69SxOWYwErOyMHJP1Au2VcX8tkHjcMbM68s95ZsUou2/Kkayza1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718725896; c=relaxed/simple;
	bh=z68f1glzn8W2C+bMjjEW4ShrQhXTjCIJIGeZFccSLPY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gSItBqnScDcn8Fc4W7rUEqLeT0F3oYez9m5kox1KrZSDTKyyo0TYXmohxJw16AiF2QvmyQmuxWzx+RBmT7YxKaYXhzD0iPI5RK2knAhN2QFkNSlVZr+6uqdOkY3fl5DBhGYrNazyO9CIW0685Ef25MwwNB3wu65WnN+MBAv+Wdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=ruPl0PEK; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="ruPl0PEK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1718725285;
	bh=z68f1glzn8W2C+bMjjEW4ShrQhXTjCIJIGeZFccSLPY=;
	h=From:To:Cc:Subject:Date:From;
	b=ruPl0PEK6sazyyfliImMeV4N/RZ2w8trQpW+3BuxpBgfY74vvT/HTIXHFg/jkFBQc
	 /uBO2xX+9egDFU5OrOj2KpijQr4ZUW5T+4hy6xikS7DNQecF40c7bVg/Cxc/LZoDSp
	 DYjYYdqNCSUbc0Rz4MVpOFUjPlXBIuXLohSoA+4D5d95W41rtitl5ImkDQZdJfEjkB
	 hSBVD6dG4LDuD+4rA29R9WFRnnKK6gQKolTmEr5i3euC7TvREsV86F0zeU99zuak82
	 vZQ07ATaYtykem/C52Uzhjjt2JgKx769WJm5J/bFWPMniHwGcaJojALjUvaobuC0+Z
	 oS+lXuzA5GT4A==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4W3WFK0rrfz16Vj;
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
Subject: [RFC PATCH 0/4] Flush nvdimm/pmem to memory before machine restart
Date: Tue, 18 Jun 2024 11:41:53 -0400
Message-Id: <20240618154157.334602-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
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

Register pre-restart notifiers to flush pmem areas from CPU data cache
to memory on reboot, immediately before restarting the machine. This
ensures all other CPUs are quiescent before the pmem data is flushed to
memory.

The use-case for this new notifier chain is to preserve tracing data
within pmem areas on systems where the BIOS does not clear memory across
warm reboots.

I did an earlier POC that flushed caches on panic/die oops notifiers [1],
but it did not cover the reboot case. I've been made aware that some
distribution vendors have started shipping their own modified version of
my earlier POC patch. This makes a strong argument for upstreaming this
work.

Link: https://lore.kernel.org/linux-kernel/f6067e3e-a2bc-483d-b214-6e3fe6691279@efficios.com/ [1]
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
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

Mathieu Desnoyers (4):
  kernel/reboot: Introduce pre_restart notifiers
  nvdimm/pmem: Flush to memory before machine restart
  arm64: Invoke pre_restart notifiers
  x86: Invoke pre_restart notifiers

 arch/arm64/kernel/process.c |  2 ++
 arch/x86/kernel/reboot.c    |  7 +++--
 drivers/nvdimm/pmem.c       | 29 ++++++++++++++++++++-
 drivers/nvdimm/pmem.h       |  2 ++
 include/linux/reboot.h      |  4 +++
 kernel/reboot.c             | 51 +++++++++++++++++++++++++++++++++++++
 6 files changed, 92 insertions(+), 3 deletions(-)

-- 
2.39.2
