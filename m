Received: from a8-156.smtp-out.amazonses.com (a8-156.smtp-out.amazonses.com [54.240.8.156])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98A2408603
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539624; cv=none; b=WpD0+CXdKOXu9p4TRtIb2P7zdWNpjgUnbqIgIi1fn5uriwH9PpLo9rNSMciE72zeRYqgr567GfdXtDh64kA1T+FdHs1K/KvaDjAlcVLXkHA1vJwh67MAVQZQz33Qkkh/6u0N5fL4fedE72wLyM+QNqUwE/1LTI8tQPQdufaHh9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539624; c=relaxed/simple;
	bh=aJfKGGbKIwZVaE6xn3WTQW2oBGJ0JEBmYwkBOPnWUsU=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=jlYEijtm6crWvyNq+FfK/iRFtM2+2DA4QUm797LHBaqYzTKoTy6sbhkvPSGLz1Wtbgm9M4ltoI/yGMGFGmSHuubOJyIrbxQ9dn6UXoRCZ19YnLGr7Mj+wJIEv9Y/O3AjbSerVi85qrPSK7X7SdJ7sREVHbQkCFYUrj6b559GWfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=g3vH1bkb; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=YOoFEp5k; arc=none smtp.client-ip=54.240.8.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="g3vH1bkb";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="YOoFEp5k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539621;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=aJfKGGbKIwZVaE6xn3WTQW2oBGJ0JEBmYwkBOPnWUsU=;
	b=g3vH1bkbI6fFt3dM5rFOyNpYm5pr1xvjpFiY+EZn8BP6SahsxfPAA8TS0YHzeJyh
	tIGbD9e3rm4j+aOmb2UZcXmLHeINzqcxzG3rZasfy5W7t550dmkE6erlIBzPjp/Z9dL
	DLyaVr9lvV6E2EnKuScksdw5WtRUttTp/NXIMTRE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539621;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=aJfKGGbKIwZVaE6xn3WTQW2oBGJ0JEBmYwkBOPnWUsU=;
	b=YOoFEp5kWuvz+pRRxeuzKz30OD+zyvfWoRzX47RpUACm60rOebzJZePaaXtqRWEM
	ef5UPdh4JrkgqQ8LNvEkLRjizfHJvC3boJtxbx/t1A5WY0TW7xjotKWlQWxIw08L/7/
	Z8seygVHWJrE6sknfVtxVBckxLLNFNv1rgdvZo+I=
Subject: [PATCH V6 05/10] dax/fsdev: clear pgmap ops and owner on unbind
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?Christian_Brauner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?Richard_Cheng?= <icheng@nvidia.com>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 15 Jun 2026 16:07:01 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com>
References: 
 <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com> 
 <20260615160656.17533-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSwAADER+
Thread-Topic: [PATCH V6 05/10] dax/fsdev: clear pgmap ops and owner on unbind
X-Wm-Sent-Timestamp: 1781539620
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc094b6e-fc163bde-0396-4a33-909f-fb88e740be27-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.8.156

From: John Groves <John@Groves.net>

fsdev_dax_probe() sets pgmap->ops = &fsdev_pagemap_ops and
pgmap->owner = dev_dax, but nothing ever clears them. For a dynamic
device the pgmap is devm-allocated and freed on unbind, so this is
harmless. For a static device the pgmap is the shared, long-lived one
owned by the dax bus (kill_dev_dax() only NULLs dev_dax->pgmap for the
non-static case), and device.c's probe sets only pgmap->type, never
clearing ops/owner.

So after fsdev unbinds a static device the stale fsdev_pagemap_ops
survives on the shared pgmap. If the device is then rebound to
device_dax (MEMORY_DEVICE_GENERIC, which installs no ->memory_failure),
or the fsdev_dax module is unloaded, a subsequent memory_failure on that
pgmap dispatches through the stale -- and possibly freed -- handler.

Register a devm action that clears pgmap->ops and pgmap->owner on unbind,
symmetric with setting them at probe, so the pgmap carries no fsdev state
once fsdev is detached.

Suggested-by: Richard Cheng <icheng@nvidia.com>
Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 0fd5e1293d725..68a4369562f70 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -127,6 +127,23 @@ static void fsdev_clear_ops(void *data)
 	dax_set_ops(dev_dax->dax_dev, NULL);
 }
 
+static void fsdev_clear_pgmap_ops(void *data)
+{
+	struct dev_pagemap *pgmap = data;
+
+	/*
+	 * fsdev installs pgmap->ops and ->owner at probe. For a static device
+	 * the pgmap is shared and long-lived (owned by the dax bus), so
+	 * leaving fsdev's ops behind on unbind would let a later
+	 * memory_failure -- after rebind to another driver, or after this
+	 * module is unloaded -- dispatch through a stale or freed
+	 * ->memory_failure handler. Clear them so the pgmap carries no fsdev
+	 * state once we are unbound.
+	 */
+	pgmap->ops = NULL;
+	pgmap->owner = NULL;
+}
+
 /*
  * Page map operations for FS-DAX mode
  * Similar to fsdax_pagemap_ops in drivers/nvdimm/pmem.c
@@ -306,6 +323,11 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
 
+	/* Drop fsdev's pgmap->ops/owner on unbind so no stale ops survive. */
+	rc = devm_add_action_or_reset(dev, fsdev_clear_pgmap_ops, pgmap);
+	if (rc)
+		return rc;
+
 	/*
 	 * Clear any stale compound folio state left over from a previous
 	 * driver (e.g., device_dax with vmemmap_shift). Also register this
-- 
2.53.0

