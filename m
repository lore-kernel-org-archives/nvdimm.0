Received: from a11-16.smtp-out.amazonses.com (a11-16.smtp-out.amazonses.com [54.240.11.16])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6CE224AF9
	for <nvdimm@lists.linux.dev>; Fri, 22 May 2026 19:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477496; cv=none; b=SppsxfIaIRdv121uPueQioAlzTEE9LilOZy6NeJhvXglIFc+XdN/pt2A3F5vi2ABxWI74cZTbCxs16PSgX8/nPJMHGR11vNPsqoNG/XBjXO3sKR9VfDG0f7YSu1oZ74Be37Ls7aTAzJYCIDq7f0Ch+xRaQKgCj99qD7N4nVtVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477496; c=relaxed/simple;
	bh=GS8F3/FZCcEbrCU4MmYVe1jnbe/e3t7eS27byBqfua8=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=BKl00dRaxvx/1J3QAzoWZqYh/qpm9euLYC4sfC+w3qBhg8pEdTc1fG+F3otSjo5h7EN9Vld+/HIFYxLFvOgdz8wRmQJDNilV6+fPFLj79prCe8wvjwZUBmPK5tU9VFxgh67LQy6PD38UYaSU1CGGiW265nj+xhJpQb7AoK+yec4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=Y5E0lUH9; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=grLZ9dV0; arc=none smtp.client-ip=54.240.11.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="Y5E0lUH9";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="grLZ9dV0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779477494;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=GS8F3/FZCcEbrCU4MmYVe1jnbe/e3t7eS27byBqfua8=;
	b=Y5E0lUH9wlQ6HkgrT/9ia9uHK82aFgyOC5N/SLa2J/61gJui7zT0JNQZALfuPFlJ
	OJmxNRBSDafYRxfyHnO0dmFnLXhlVCFl/Bii8KgJe96KcDKHC2g8fek1nBGAO4nabQC
	iOnbKiQSYr+XjUFnqG2Et+bw6tzDPMGjxyJN03pM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779477494;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=GS8F3/FZCcEbrCU4MmYVe1jnbe/e3t7eS27byBqfua8=;
	b=grLZ9dV0yDA2hRHJ9Lnep6725UaZERgdu4KYIrraZbUs72+sY1VqaIyapoPOxy/m
	itMrmOuaP05UBpyc7S60qtJsp9Y2+nJ3G6Suf5KLOiTwZDGWAoMnI39e89m5ZRldaOA
	bi2+DRNTdYIHNdrAu1JjDE0PnQNCPYbizkHra3Y0=
Subject: [PATCH V2 0/7] Fixes to the previously-merged drivers/dax/fsdev
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
Date: Fri, 22 May 2026 19:18:13 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <20260522191804.79088-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc6h+7e4zSojcNRQ2wV9eJQr6w4g==
Thread-Topic: [PATCH V2 0/7] Fixes to the previously-merged drivers/dax/fsdev
 series
X-Wm-Sent-Timestamp: 1779477492
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.22-54.240.11.16

From: John Groves <john@groves.net>

This series applies bug fixes (mostly found via sashiko) to the dax/fsdev 
series. This has been soaking in the famfs CI pipeline for 2+ weeks and
1) won't affect anything that doesn't use drivers/dax/fsdev.c, and 2)
doesn't affect any known workloads - although the bugs would have 
manifested when multi-range DCD dax devices are a thing (soon-ish).

Changes since v1:
* Dropped modes from patch 6 to fs/fuse/famfs.c and 
  fs/famfs/famfs_inode.c, which are not upstream so it broke
  attempts to apply the series. Oops...
* Added patch 7, which addresses a previously-missed review comment
  from Jonathan - minor cleanup


John Groves (7):
  dax: fix misleading comment about share/index union in
    dax_folio_reset_order()
  dax/fsdev: fix multi-range offset, vmemmap_shift leak, and probe error
    cleanup
  dax/fsdev: fix kaddr for multi-range and fail probe on invalid pgmap
    offset
  dax/fsdev: clamp direct_access return to current physical range
  dax: fix holder_ops race in fs_put_dax()
  dax: replace exported dax_dev_get() with non-allocating dax_dev_find()
  dax: fsdev.c minor formatting cleanup

 drivers/dax/dax-private.h |   2 -
 drivers/dax/fsdev.c       | 104 ++++++++++++++++++++++++++------------
 drivers/dax/super.c       |  51 +++++++++++++++++--
 fs/dax.c                  |  12 ++---
 include/linux/dax.h       |   6 ++-
 5 files changed, 129 insertions(+), 46 deletions(-)

-- 
2.53.0

