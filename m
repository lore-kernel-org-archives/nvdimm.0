Received: from a48-179.smtp-out.amazonses.com (a48-179.smtp-out.amazonses.com [54.240.48.179])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C6C3FFD
	for <nvdimm@lists.linux.dev>; Sun,  7 Jun 2026 19:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780860754; cv=none; b=YJ2i2P1Wk7mEoWL+I8uBJnHCb3dXGOd701gnYl3BrY5D7Eo9Gc4M6hWSzxYeA3vMI01zT3LFqBSo5XURIsYQgqnoVdhkGH1yHJtSN+IAh8vml6Jm9zDUha8Iv3ESzpO4zcHbNNhZzkxzVPv7pWCwDi6oEuw9/8cyb7Hi6V/B3is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780860754; c=relaxed/simple;
	bh=jt8Aj0XIoUivbpwTIcdaYSD25WtNq6BIuZR1ziWfZe0=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=RDeMoqnVCJ+mmPQM+RIbd+IUaHtY5e1V2eFS95rFll6aTO6RD9r94FgMkPXHUuYRLu7/xe23VdLVwkgatkurFf93oLC38jCwvpVkcRoiR9BnqcUEunDSLuQiQoCzG0jCi7V+vOujoOWY6NpGjRg6k8GZBng548ijZdLFFgRGkcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=CpVLVpKg; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=CNWNqItN; arc=none smtp.client-ip=54.240.48.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="CpVLVpKg";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="CNWNqItN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780860752;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=jt8Aj0XIoUivbpwTIcdaYSD25WtNq6BIuZR1ziWfZe0=;
	b=CpVLVpKgWfXsumK32PV+OSPxUipVIHCX/GA8GpkYJUYCrTmid5ud5lP7z8B/INjc
	SBHGlHb/ear4mecVA30WUxWuqwOdXrkhgPcn4Okc3UzxIVg1UvnQm10fK+hcVpXaBs9
	vyrQ7L0i3EywErIEZMeymBh9xTq1P2JNsYSQo1UM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780860752;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=jt8Aj0XIoUivbpwTIcdaYSD25WtNq6BIuZR1ziWfZe0=;
	b=CNWNqItNO5wZEQr4bau0YhELU+mBy8YwTZeLQBKlRmG8qIm6xiyqnqSnheSibC/P
	WFOETu+bWjdxUq3hkrG3ztzx8QgwOe4BWG4WcxcqwLEGXyn7yc0eZogje8BaM8Ljkhj
	QAkxWdA01Y2WTLfyWJCfTzS7ka4sNjnWqUEz3kNU=
Subject: [PATCH V4 0/9] Fixes to the previously-merged drivers/dax/fsdev
 series
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
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Sun, 7 Jun 2026 19:32:32 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <20260607193224.94244-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc9rRhSPXw4ZdTQtuvnkZG9OrQIg==
Thread-Topic: [PATCH V4 0/9] Fixes to the previously-merged drivers/dax/fsdev
 series
X-Wm-Sent-Timestamp: 1780860751
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.07-54.240.48.179

From: John Groves <john@groves.net>

This series applies bug fixes (mostly found via sashiko) to the dax/fsdev 
series. This has been soaking in the famfs CI pipeline for 2+ weeks and
1) won't affect anything that doesn't use drivers/dax/fsdev.c, and 2)
doesn't affect any known workloads - although the bugs would have 
manifested when multi-range DCD dax devices are a thing (soon-ish).

Most of the series is confined to drivers/dax/fsdev.c. Two patches
touch shared DAX core: patch 7 changes fs_put_dax() in 
drivers/dax/super.c (used by ext2/ext4/erofs/xfs, though only
holder-passing callers, like XFS in-tree, will see a new warning if
they misuse fs_put_dax(). 

Although patch 8 adjusts the dax_dev lookup API in super.c / dax.h, this 
does not affect the above file systems; they use fs_dax_get_by_bdev() 
instead.

Changes since V3:

- Patch 4: Adopted Dave's suggested refactor -- factor out
  fsdev_acquire_pgmap() and defer the dev_dax->pgmap assignment until
  probe can no longer fail, replacing the goto-based cleanup. Did not
  carry Alison's V3 Reviewed-by due to the rewrite.
- Patch 5: Also remove the now write-only dev_dax->virt_addr field,
  per Dave's review.
- Patch 7: Fixed the WARN_ON() to tolerate holder_data == NULL, which
  legitimately occurs when kill_dax() clears it during device removal
  under a live holder (per Dave's review). Wrong-holder calls still
  warn.
- Patch 8: Kept the Fixes tag -- the exported symbol itself is the
  hazard; stable kernels carrying the export should want this fix.

Changes since V2:

* Patch 1 (comment fix): No change. Responded to Dave's question about
  the dropped precondition -- the new comment correctly covers both
  callers; fsdev_clear_folio_state() does not guarantee share==0 before
  calling, so the old precondition was no longer universally true.
* V2 patch 2 (three fixes): Split into three separate patches (patches
  2-4) per Dave's review.
* V2 patch 3 (two fixes): Split into two separate patches (patches 5-6)
  per Dave's review.
* V2 patch 4 (clamp direct_access / remove cached_size): Dropped.
  Dave's analysis correctly showed the claimed bug does not exist --
  dax_pgoff_to_phys() already enforces that the full requested size fits
  within a single range before returning, making the clamp a no-op in
  every reachable path.
* V2 patch 5 (holder_ops race): Use WRITE_ONCE() for the holder_ops
  store; add WARN_ON() on the cmpxchg result to catch wrong-holder and
  double-put API contract violations; fix the inline comment, which
  incorrectly claimed dax_holder_notify_failure() consults holder_ops
  only when holder_data is non-NULL.
* V2 patch 6 (dax_dev_find): Add dax_alive() check under dax_read_lock()
  after ilookup5() to prevent returning a device that is concurrently
  being torn down by kill_dax().
* V2 patch 7 (formatting cleanup): Drop incorrect Fixes: tag; add
  Dave's Reviewed-by.
* The series grows from 7 to 9 patches.

Changes since v1:
* Dropped modes from patch 6 to fs/fuse/famfs.c and 
  fs/famfs/famfs_inode.c, which are not upstream so it broke
  attempts to apply the series. Oops...
* Added patch 7, which addresses a previously-missed review comment
  from Jonathan - minor cleanup


John Groves (9):
  dax: fix misleading comment about share/index union in
    dax_folio_reset_order()
  dax/fsdev: fix multi-range offset in memory_failure handler
  dax/fsdev: clear vmemmap_shift when binding static pgmap
  dax/fsdev: don't leave a dangling dev_dax->pgmap on probe failure
  dax/fsdev: use __va(phys) for kaddr in direct_access
  dax/fsdev: fail probe on invalid pgmap offset
  dax: fix holder_ops race in fs_put_dax()
  dax: replace exported dax_dev_get() with non-allocating dax_dev_find()
  dax: fsdev.c minor formatting cleanup

 drivers/dax/dax-private.h |   2 -
 drivers/dax/fsdev.c       | 126 +++++++++++++++++++++++++-------------
 drivers/dax/super.c       |  80 ++++++++++++++++++++++--
 fs/dax.c                  |  12 ++--
 include/linux/dax.h       |   6 +-
 5 files changed, 168 insertions(+), 58 deletions(-)


base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
-- 
2.53.0

