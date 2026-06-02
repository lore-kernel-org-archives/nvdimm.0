Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9A3357D01
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 07:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780384918; cv=none; b=g0+PzTKMNyT96y2Zu2z/L09cf+cHw/Ih+4kevpXRbi3wRwuEht1IjC0ausBtJ4Bj/d1wdYDl6QtMAqG5niviJ9jvSYwDbtX0G84E7T8AuTt2W21YHWy6ajFpwFr/fblp/KWfX31F4Ud2GuDbqQJbNPnw7ManY6btKRAnWP4gEbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780384918; c=relaxed/simple;
	bh=w7tP9fKpuSQmCy7NYtaD0k2nekKXSXAf38fh5MMgVr8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F1le+BhK0ztpYMzwARAa6LwmQ5UoQE5MWiM6uC+RRdhsjTsymV+CrJQIZ+sVnwZQB7Cung3RrHGVKTCR6waLRo2ddtQmJGN2pAhzUIRgHwPVZygM7FAYvqcBp6rDyTAwFQHB/3KTiRMJcPYgKY5t/akMxwJVsdt1sBa0WL1WmeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=U9TXoKy8; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="U9TXoKy8"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E7874D0F5F;
	Tue, 02 Jun 2026 07:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384410;
	bh=0qtKkckt9JyUfNuorH5TPUvvCM0+T6UIOHmjMyEJuIc=;
	h=From:To:Cc:Subject:Date;
	b=U9TXoKy8bydOm/pB7jK9QzuMctLVKJB4ktSSjzPQi+i+j8sTGV0drs4RBpxeE2Sjo
	 RoMD99yfnZ2kPt9WKe2MfIzhrBeyINbBpFfp6qhjNpRIkmuR2E1R2YBLinHLChGmtf
	 8daVng1/FTEMqeLDiy1XWycaTB5WQpoaEhRAqq1o=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v5 0/4] cleanup: Remove NULL check from unconditional guards
Date: Tue,  2 Jun 2026 07:12:49 +0000
Message-ID: <cover.1780064327.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unconditional guard destructors have dead NULL checks. The lock operation in
the constructor would crash before the destructor ever runs with NULL.

- Patches 1-2 prepare guards that legitimately handle NULL.
- Patch 3 adds __nonnull_args() to guard constructors for compile-time
  enforcement.
- Patch 4 removes the dead checks.

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23834334, chg -0.23%

Changes in v5:

- Renamed __nonnull() attribute to __nonnull_args() to fix User Mode Linux
  build failures (kernel test robot).
- Dropped Acked-by tag from Miguel, since I renamed the attribute.

Changes in v4:

- Re-worded commit message paragraph about nonnull "compiler-enforced
  verification" (Miguel Ojeda).
- Fixed GCC documentation link for nonnull() attribute (Miguel Ojeda).
- Placed nonnull() before nonstring() in
  include/linux/compiler_attributes.h (Miguel Ojeda).
- Picked up tags, where appropriate.

Changes in v3:

- Audited usages of DEFINE_GUARD(), __DEFINE_UNLOCK_GUARD() and
  DEFINE_LOCK_GUARD_1() to make sure NULL check removal will work correctly
  (Peter Zijlstra).
- Moved NULL check into irqdesc_lock unlock expression (Peter Zijlstra).
- Added compiler-enforced nonnull() check for guard constructors.
- Converted nvdimm_bus guard to class.

Changes in v2:

- Expand commit message with detailed reasoning, why the proposed
  change is correct.
- Rebase on top of locking/core.

v4: https://lore.kernel.org/all/cover.1779286416.git.d@ilvokhin.com/
v3: https://lore.kernel.org/all/cover.1779116497.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/20260512071510.92451-1-d@ilvokhin.com/
v1: https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/

See also [1] for relevant discussion.

[1]: https://lore.kernel.org/all/afCS4d4YccQFtvpi@shell.ilvokhin.com/

Dmitry Ilvokhin (4):
  nvdimm: Convert nvdimm_bus guard to class
  genirq: Move NULL check into irqdesc_lock guard unlock expression
  cleanup: Annotate guard constructors with nonnull
  cleanup: Remove NULL check from unconditional guards

 drivers/nvdimm/nd.h                 | 7 +++++--
 include/linux/cleanup.h             | 8 +++++---
 include/linux/compiler_attributes.h | 9 +++++++++
 kernel/irq/internals.h              | 2 +-
 4 files changed, 20 insertions(+), 6 deletions(-)

-- 
2.53.0-Meta

