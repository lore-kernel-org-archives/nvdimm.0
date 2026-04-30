Received: from a8-40.smtp-out.amazonses.com (a8-40.smtp-out.amazonses.com [54.240.8.40])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373DE31F9AD
	for <nvdimm@lists.linux.dev>; Thu, 30 Apr 2026 15:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777563225; cv=none; b=IGUzCgM7CY30cqhA+DCdrOGH12ONb24KaOW5qLkLkSCobNWYzss7SyN4nHp3PhUlbEzJeVeNFS19NsfLARaqMReXS5snI1yvrK2jFlM8fKZg0oZtUbgRRptHGLuHRWmEnqKIVWX45ORd3CA/YEZc8+GK5ooXPzlliHWA1dNs6qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777563225; c=relaxed/simple;
	bh=oj2XVF6FdPCuPa+ba0OgiaDH0x216zjEbA8mmR+9qtA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=NsYFmNECGufLVXyHCi2Y9GEX7EYiZhLtA8XyB1+HHZ2HlxwgI805/iEt3KHugcjxGt5N/IruvJNIDzo8ua0MQK+RRYo9wTXMoPrl1ie3FjdxAdHdY6s4NDIZAw++mWz+em0Kmu2rBv78TTgxxlr1VOaokG/62NSbB0Bdc5dWAqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=I33twfbQ; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=UvPrGzw+; arc=none smtp.client-ip=54.240.8.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="I33twfbQ";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="UvPrGzw+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1777563223;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=oj2XVF6FdPCuPa+ba0OgiaDH0x216zjEbA8mmR+9qtA=;
	b=I33twfbQtNcNYKx8zBvXtTu3VCAFG+8J6LAviQiC/02ZuJlGI1SjHfBFoBLJNu3d
	rA1nH2j6MOsVQ7zA54XwZi4IhYJO12BUzhqp0MKFBCrWKxJWMEM3tKetfROS00be6Vb
	f+Q2/kSsg57UFs53t/5vlADZ9arNWVruSNTshdjY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1777563223;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=oj2XVF6FdPCuPa+ba0OgiaDH0x216zjEbA8mmR+9qtA=;
	b=UvPrGzw+E5FLaIYtxBsgUoTMevRwamqoZyINzzEQ3DcV3tw/SCpoUXllerCgEfU2
	9U+LdaPmhOWwKssw1UkfbRRg7CVk5kAWnNqGlnTev8CZMjXigoqgN6gnGs1wGg+wSZi
	qpgAqh8w7uKVVOcnnGCTNl2bJr1HHfZhRzQoB0Nw=
Subject: [PATCH V5 0/2] daxctl: Add support for famfs mode
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
Date: Thu, 30 Apr 2026 15:33:43 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <20260430153331.84139-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc2La5yYcpNuZmSk2Q3QomIwRoLQ==
Thread-Topic: [PATCH V5 0/2] daxctl: Add support for famfs mode
X-Wm-Sent-Timestamp: 1777563222
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.04.30-54.240.8.40

From: John Groves <john@groves.net>

This series adds famfs mode support to daxctl, alongside the existing
devdax and system-ram modes.  A daxdev is in famfs mode when it is bound
to fsdev_dax.ko (drivers/dax/fsdev.c).

Patch 1 adds the library plumbing: mode detection helpers, an enable
function, and the device.c reconfigure-device wiring.  Patch 2 adds a
test that exercises mode transitions.

This series depends on the fsdev_dax kernel driver (which provides famfs
mode) and on the famfs kernel patch series.

Patches:
  1/2 daxctl: Add support for famfs mode
  2/2 Add test/daxctl-famfs.sh to test famfs mode transitions

Changes since V4 (addressing Alison and Ira's comments):
- Consolidate the per-mode driver-symlink lookups into a single static
  helper daxctl_dev_bound_to_module(); the three mode predicates now
  delegate to it.
- Use PATH_MAX instead of a hardcoded char[200] in the mode-check path.
- Use path_basename() instead of basename().
- Emit a dbg() message when realpath() on the driver symlink returns
  NULL.
- Revert the json.c change that reported unbound devices as 'unknown'.
  An unbound device is reported as 'devdax' again, matching the prior
  behavior; the configured-vs-active distinction Alison raised goes
  away.
- Add missing fprintf(stderr) "disable failed" messages in the
  "already in target mode, just re-enable" branches of
  reconfig_mode_devdax() and reconfig_mode_famfs(), matching the
  pattern used by the disable_*_device() helpers.
- Reword commit messages: clarify that the test is in a separate
  patch, drop the stale "json.c shows 'unknown'" line, and replace
  "Fix mode transition logic" with "Update mode transition logic"
  since these are extensions for the new mode rather than fixes to
  broken existing behavior.

John Groves (2):
  daxctl: Add support for famfs mode
  Add test/daxctl-famfs.sh to test famfs mode transitions:

 daxctl/device.c                | 132 +++++++++++++++--
 daxctl/json.c                  |  13 +-
 daxctl/lib/libdaxctl-private.h |   2 +
 daxctl/lib/libdaxctl.c         |  39 ++++-
 daxctl/lib/libdaxctl.sym       |   7 +
 daxctl/libdaxctl.h             |   3 +
 test/daxctl-famfs.sh           | 253 +++++++++++++++++++++++++++++++++
 test/meson.build               |   2 +
 8 files changed, 436 insertions(+), 15 deletions(-)
 create mode 100755 test/daxctl-famfs.sh


base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
-- 
2.53.0

