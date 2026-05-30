Received: from a8-208.smtp-out.amazonses.com (a8-208.smtp-out.amazonses.com [54.240.8.208])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B5E34EF07
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159804; cv=none; b=WUzuf26r5Ga4lbE0bSWg+GLUopgkbf0Farev8JvYRV2NG+1sfAmSC94hvz/kZVDgApYKZ71I3OCO5giS/jjMAs25V1gm3K752UtQrk8MwA8WkUD23CQjRBiKUo4x9ZShaZhgeB4ojmyPvTWKZcksDw052nMhjavENKUBvAhHxmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159804; c=relaxed/simple;
	bh=aJgpOXWo6TMioWluhbVYAPCxFneaCuvwJria7OxLR5k=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=rmda3tnIH7Y71snjbFQ1TitW1DiAGXO0WggvLn2UV6b/3c+QXyMN2R7ncRbPJkqiAyJTsVjjJxwY2bxdA1lomjAVnn8vKaa2GdIS0Ub9Ge2dbUizGcSTqU3i900TTt1FM++aSr5Ct5m/C5hY7vFNMlKGd2cZf3uHtbCaqbxzfIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=h90A0QNT; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=OkI37pKe; arc=none smtp.client-ip=54.240.8.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="h90A0QNT";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="OkI37pKe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159802;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=aJgpOXWo6TMioWluhbVYAPCxFneaCuvwJria7OxLR5k=;
	b=h90A0QNTUKrVpM/EtaiOYn5NwXxEYOgL3P0cqSb0qfBqeGLcEUDfMTH51Qdp3b+n
	WekDuqK40cLROCYNNEZZYXEihvE4ojfi2A/IcHYe1z/gXyZ1BD+Vs2AKimZDNt8Z5ir
	d0nTevn+/8OddjROP0K1qGz/x67V2oTLyacFRDLQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159802;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=aJgpOXWo6TMioWluhbVYAPCxFneaCuvwJria7OxLR5k=;
	b=OkI37pKeVgOCAayjXeo/igJ1He2jMNPetOf6LkhcCJrRC4SqL6z21+PdIUwB3S+r
	FiaMFoPU/HrkHT1xe9aetjF2c0HwDBklAaAzq4R9aM5TWg5UILNW7ZMoA8ATGcg2AU8
	Tcm/JKKt+YMnIJ8y3eWHKgyflow62BgzJwnGFgOI=
Subject: [PATCH V3 0/9] Fixes to the previously-merged drivers/dax/fsdev
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
Date: Sat, 30 May 2026 16:50:02 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <20260530164953.6578-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRa7vroVK8USxmz3hlONeiu3Q==
Thread-Topic: [PATCH V3 0/9] Fixes to the previously-merged drivers/dax/fsdev
 series
X-Wm-Sent-Timestamp: 1780159800
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.8.208

From: John Groves <john@groves.net>

This series applies bug fixes (mostly found via sashiko) to the dax/fsdev 
series. This has been soaking in the famfs CI pipeline for 2+ weeks and
1) won't affect anything that doesn't use drivers/dax/fsdev.c, and 2)
doesn't affect any known workloads - although the bugs would have 
manifested when multi-range DCD dax devices are a thing (soon-ish).

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
  dax/fsdev: clear dev_dax->pgmap on probe failure
  dax/fsdev: use __va(phys) for kaddr in direct_access
  dax/fsdev: fail probe on invalid pgmap offset
  dax: fix holder_ops race in fs_put_dax()
  dax: replace exported dax_dev_get() with non-allocating dax_dev_find()
  dax: fsdev.c minor formatting cleanup

 drivers/dax/fsdev.c | 81 +++++++++++++++++++++++++++++++--------------
 drivers/dax/super.c | 73 +++++++++++++++++++++++++++++++++++++---
 fs/dax.c            | 12 +++----
 include/linux/dax.h |  6 +++-
 4 files changed, 136 insertions(+), 36 deletions(-)

-- 
2.53.0

