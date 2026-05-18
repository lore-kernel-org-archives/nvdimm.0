Received: from a8-18.smtp-out.amazonses.com (a8-18.smtp-out.amazonses.com [54.240.8.18])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7817C2EA48F
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 21:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140117; cv=none; b=MTgfOf9WmDDPFhtHLvaK2aZuOuSmgy9A/VEnUqPIWUgHSS64z8lXZ1UjdvH1I5hFZi4yGChZ7TRmt0o5PT8EYTXAcFut3uokVee4BBkJ7j4XqMbcTmIrlvHutY12BG5WBZL0jVRtqPkeoZ9fVQPCO/kc1nbswFRXkX1AJi85Wxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140117; c=relaxed/simple;
	bh=pLYMabLoDdzxXBCQLb+R1SqG9wVhoGJ02VQqkwbRrMM=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=Cl+hgpFJQtRbb+bJe9BP8VGNDVeMdpocbtK6k1QG4iRRdOupO677GtZqd/Vve8Nr+NWep0q+kQqY4UmSs4KhU5CyiCaqu0o8v64x3QVl3VYKEB/VhoF9i1E8WJXbf+Y3O8DkdJwlLn5dgWfhFR5BhZGVtUrrQ1eLlrB6pP96w60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=SFH7TaRk; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=KHMgY8X4; arc=none smtp.client-ip=54.240.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="SFH7TaRk";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="KHMgY8X4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779140115;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=pLYMabLoDdzxXBCQLb+R1SqG9wVhoGJ02VQqkwbRrMM=;
	b=SFH7TaRk1X94VtisrJml72nfgZTjPboKo+NPeXllQGYqj3R+CRRywrK48newBt9c
	F73ZsGsQp/5LYwoFjFqxl/U4cwhJk/S4LtXIC8QioJ7E8y/RE9YxvjED1hlBGlUNg04
	IO9z7sMNJp3hUcYdlsAmRrclT1MbCcolmV6Plges=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779140115;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=pLYMabLoDdzxXBCQLb+R1SqG9wVhoGJ02VQqkwbRrMM=;
	b=KHMgY8X4IEcTfV1DoWG9EKJw8ABzYCnfFDWTsyiIv9XsJVL6UFc67+6LFPz4Hdvn
	+SihEq6MfaUVrsemNwWKchqgQ0w10GCU7KjmUAHtV0gLaIJuUotKDycxN/BPs11dSL+
	6svgBUpUdd67ZnhT2xvn4YMquD7wK3Y6WIXVvdik=
Subject: [PATCH 0/6] Fixes to the previously-merged drivers/dax/fsdev series
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
Date: Mon, 18 May 2026 21:35:15 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <20260518213452.31205-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc5w41mkJXxS0+R8GcNdWTTpRlkw==
Thread-Topic: [PATCH 0/6] Fixes to the previously-merged drivers/dax/fsdev
 series
X-Wm-Sent-Timestamp: 1779140114
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.18-54.240.8.18

From: John Groves <john@groves.net>

This series applies bug fixes (mostly found via sashiko) to the dax/fsdev
series. This has been soaking in the famfs CI pipeline for 2+ weeks and
1) won't affect anything that doesn't use drivers/dax/fsdev.c, and 2)
doesn't affect any known workloads - although the bugs would have
manifested when multi-range DCD dax devices are a thing (soon-ish).

John Groves (6):
  dax: fix misleading comment about share/index union in
    dax_folio_reset_order()
  dax/fsdev: fix multi-range offset, vmemmap_shift leak, and probe error
    cleanup
  dax/fsdev: fix kaddr for multi-range and fail probe on invalid pgmap
    offset
  dax/fsdev: clamp direct_access return to current physical range
  dax: fix holder_ops race in fs_put_dax()
  dax: replace exported dax_dev_get() with non-allocating dax_dev_find()

 drivers/dax/dax-private.h |  2 -
 drivers/dax/fsdev.c       | 85 ++++++++++++++++++++++++++++-----------
 drivers/dax/super.c       | 51 +++++++++++++++++++++--
 fs/dax.c                  | 12 +++---
 fs/famfs/famfs_inode.c    |  2 +-
 fs/fuse/famfs.c           |  2 +-
 include/linux/dax.h       |  6 ++-
 7 files changed, 122 insertions(+), 38 deletions(-)

-- 
2.53.0

