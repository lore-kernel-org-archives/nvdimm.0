Received: from a8-208.smtp-out.amazonses.com (a8-208.smtp-out.amazonses.com [54.240.8.208])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540783C4B9F
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 17:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814921; cv=none; b=IEE/ccTW5q95kFLtCdXhaH5wB6ut9cNiQmPTy0Me0ix5T7ti1FyX83JeD8uPQUvTUadReWI3wNoOgAfc/qtgKmoBF8a6vJndMCyvbXQELWnt3dg3u791iAnzwql4Pq+DoBlovQQp6nKz4/2EvKX97NxO2/y6QdTa2egMC/r0nDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814921; c=relaxed/simple;
	bh=hHB5aw0VnqzK81PdB8lJTgAs1hZb4k+F5Y7zUXw+aOM=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=r+1zP+drJSVpBy/wOqi1yO/pp1bLMmYVaHeILO0X9nmp6L+9CokCjdWe/uF9vX4hQKzkR64igh4sUsdd40p/17llpLO5vr4vD5v5a8oPWkuw5RA8zrfOb8qPni/+o8FEREV2fFZJHtI6O3Lpi4WANFHsyQZl5P9/tZ+ucLMPUNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=J92hX2GI; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=okKbIcZj; arc=none smtp.client-ip=54.240.8.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="J92hX2GI";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="okKbIcZj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779814919;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=hHB5aw0VnqzK81PdB8lJTgAs1hZb4k+F5Y7zUXw+aOM=;
	b=J92hX2GIJXifVSLp4o7RFRp8m1ynrOm4OTDHgcwQXpk3isXAT1Uv7ao9ynL7oM7s
	10XY18Ju7ZrmA4QVQfakB08aunCFxHnpUt1ZUvLreucnlnzK5KBnCW42Ta5E/DXk+rl
	7e2Fr9hXlRVAEd/0V5fTM4pYFThEMycgsQtcZFR0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779814919;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=hHB5aw0VnqzK81PdB8lJTgAs1hZb4k+F5Y7zUXw+aOM=;
	b=okKbIcZjekxyy3ZraRJC99v5LCb5h0TmPoos+MKcQDUGbqePFtA9lZtbkwTnATIH
	1Zuf/JWlHt+IttMvc7kVBb7t4gcXgu48R3T1bBVcpZc3zqn7GOwsEMbe9xDW34ONtfx
	JjKtprGIb+cDSTN11TOaHhqGGxE8NH5YTkWUn2G4=
Subject: [PATCH V6 0/2] daxctl: Add support for famfs mode
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?John_Groves?= <jgroves@fastmail.com>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Alison_Schofield?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <Jonathan.Cameron@huawei.com>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?dev=2Esrinivasulu=40gmail=2Ecom?= <dev.srinivasulu@gmail.com>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2E?= =?UTF-8?Q?org?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2E?= =?UTF-8?Q?linux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40v?= =?UTF-8?Q?ger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Tue, 26 May 2026 17:01:59 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <20260526170148.56398-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc7TFcILV7h5r+TK67r8Gpp/8CFw==
Thread-Topic: [PATCH V6 0/2] daxctl: Add support for famfs mode
X-Wm-Sent-Timestamp: 1779814917
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e653c6c88-44f88088-8c87-4163-b88b-b3f3fc7aa726-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.26-54.240.8.208

From: John Groves <john@groves.net>

This series adds famfs mode support to daxctl, alongside the existing
devdax and system-ram modes.  A daxdev is in famfs mode when it is bound
to fsdev_dax.ko (drivers/dax/fsdev.c).  famfs is a shared,
memory-mappable filesystem for disaggregated and CXL memory; see
https://famfs.org for more information.

Patch 1 adds the library plumbing: mode detection helpers, an enable
function, and the device.c reconfigure-device wiring.  Patch 2 adds a test
that exercises mode transitions on the nfit_test emulated backend.

This series depends on the fsdev_dax kernel driver (which provides famfs
mode) and on the famfs kernel patch series.

Changes since V5 (addressing Alison's review):

Patch 1 (daxctl: Add support for famfs mode):
- Commit message: add an intro paragraph describing what famfs is, with a
  link to https://famfs.org.
- Documentation: document famfs mode in
  Documentation/daxctl/daxctl-reconfigure-device.txt (DESCRIPTION, the
  -m/--mode option list, and a reconfigure example).
- Rename the local 'enum dev_mode' to 'enum reconfig_mode'
  (RECONFIG_MODE_*) so it no longer shares member names with
  enum daxctl_dev_mode.
- Add daxctl_dev_get_mode(), which reports a device's current mode; the
  three reconfig_mode_*() functions and json.c now switch on it instead
  of repeating an if-else mode chain.  enum daxctl_dev_mode moves to the
  public header and gains a DAXCTL_DEV_MODE_UNKNOWN sentinel;
  daxctl_dev_get_mode() is exported.
- Collapse disable_devdax_device() and disable_famfs_device() into a
  single disable_mode_device() (the caller has already matched the mode).
- Add daxctl_dev_is_system_ram_mode() as the preferred name for the
  consistency with daxctl_dev_is_{famfs,devdax}_mode();
  daxctl_dev_is_system_ram_capable() becomes a compatibility wrapper so
  the existing ABI is preserved.
- Move the "returns false for a disabled device" note onto the shared
  daxctl_dev_bound_to_module() helper and drop the redundant per-predicate
  comments.
- Fix daxctl_dev_enable() to range-check mode before indexing
  dax_modules[]; the lookup previously ran before the bounds check.
- Remove the stray double space in the --mode=famfs parse branch.
- Drop the Reviewed-by: Dave Jiang tag, given the amount of rework since
  V5.

Patch 2 (test):
- Replace the V5 device-scanning test with test/daxctl-famfs-nfit.sh, which
  builds its own dax device from the emulated ACPI.NFIT bus (nfit_test) so
  it runs in the ndctl unit-test model.  Real DRAM backing means kmem
  onlining works and the full devdax/famfs/system-ram matrix runs
  end-to-end, including the system-ram -> famfs rejection.  Follows the
  existing test style (set -x logging, err/cleanup traps, check_dmesg,
  fixture teardown).  Based on a rewrite from Alison Schofield.
- Per Alison's "pick a lane to start" feedback, only the nfit_test backend
  is upstreamed here; a cxl_test-backed variant is held for a later
  revision.

John Groves (2):
  daxctl: Add support for famfs mode
  Add nfit_test famfs mode-transition test

 .../daxctl/daxctl-reconfigure-device.txt      |  22 +-
 daxctl/device.c                               | 113 ++++++---
 daxctl/json.c                                 |  18 +-
 daxctl/lib/libdaxctl-private.h                |   9 +-
 daxctl/lib/libdaxctl.c                        |  73 +++++-
 daxctl/lib/libdaxctl.sym                      |   9 +
 daxctl/libdaxctl.h                            |  14 ++
 test/daxctl-famfs-nfit.sh                     | 215 ++++++++++++++++++
 test/meson.build                              |   2 +
 9 files changed, 432 insertions(+), 43 deletions(-)
 create mode 100755 test/daxctl-famfs-nfit.sh

-- 
2.53.0

