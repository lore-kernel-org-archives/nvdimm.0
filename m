Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DA9342CBA
	for <nvdimm@lists.linux.dev>; Thu, 21 May 2026 07:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779347903; cv=none; b=OE0GyOC26VTrOem+B6ChlR3OdkQXXCH0Qr1QU7NFjEJ+wZu3eSRb1LzMvkvUqN7EQw9gKrDLqwrhzPXvLtVF3f1Ge7zcJjp3wuuQdqdyO1AsNbpx+7gqd6VLbvRjSLbG5JAWGFuzqyZPW1w0+aAZldu3FJqUXOHrmUQqU/A2XMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779347903; c=relaxed/simple;
	bh=75g6sSQ/lrb9ilJb7+DXotnUnUUesyJWpcPEDhFKzHY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eDsC71sni6NzCvT/00anTaxPz0Xoon9BP5peW88AizLIHLsuR2sfaGdhA/szXdgh8Z3hSfHavZJbsJgMBVY70KTvns0uvoqJcsfHDURk9KxmaoQhZ2kVpSmXSxK0rHMzjPrMtJVCkT9lxHxODWaRKCMQtg2qBoZ2l4SCiPLoiHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=m3aCTD9G; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="m3aCTD9G"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 61CFED0925;
	Thu, 21 May 2026 07:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347900;
	bh=lI9FQx8ShFhvPIZrLKYCCXVlmy7Lwsl7O7ulvfACmMI=;
	h=From:To:Cc:Subject:Date;
	b=m3aCTD9G4ehzIQeFoi/FvKLPBsCJ1EHAnXHzvu+GkPTPKU1Zk+FZFIiyHJT5NN9/O
	 4xaFY9WoD2K4oG+bVVLIOmpRg2kvfbya+1X0j9jxwpPcqJZ8iQCnBl913Er6ON+ZoW
	 +Rk2N6/Z2GuHOK+P5ltQMW+1IAbMAm3uuBxwc9V0=
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
Subject: [PATCH v4 0/4] cleanup: Remove NULL check from unconditional guards
Date: Thu, 21 May 2026 07:18:00 +0000
Message-ID: <cover.1779286416.git.d@ilvokhin.com>
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
- Patch 3 adds __nonnull() to guard constructors for compile-time enforcement.
- Patch 4 removes the dead checks.

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23834334, chg -0.23%

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

v3: https://lore.kernel.org/all/cover.1779116497.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/20260512071510.92451-1-d@ilvokhin.com/
v1: https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/

See also [1] for relevant discussion.

[1]: https://lore.kernel.org/all/afCS4d4YccQFtvpi@shell.ilvokhin.com/

Dmitry Ilvokhin (4):
  nvdimm: Convert nvdimm_bus guard to class
  genirq: Move NULL check into irqdesc_lock guard unlock expression
  cleanup: Annotate guard constructors with __nonnull()
  cleanup: Remove NULL check from unconditional guards

 drivers/nvdimm/nd.h                 | 7 +++++--
 include/linux/cleanup.h             | 8 +++++---
 include/linux/compiler_attributes.h | 6 ++++++
 kernel/irq/internals.h              | 2 +-
 4 files changed, 17 insertions(+), 6 deletions(-)

-- 
2.53.0-Meta

