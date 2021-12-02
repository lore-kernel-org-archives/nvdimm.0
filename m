Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCCB2C9D
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 12:54:03 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 92F4E1FD39;
	Thu,  2 Dec 2021 12:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1638449641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pvsbfNmbj9n3NmX6sav0pv2g62VPBlLiT8J9jst89r0=;
	b=Gfyi3cPBICAKIK+TYAZymtsRU+Yta2MCIQbHDV7Ilbg6kr9g8Qz79ck+zuoRyMc7Zx+YdM
	86XszjYDXXdqgnbdpoLWSzD5qdZUbAGF8z5Lwth/yRGCqLe26aQdd8YNjM6Kz2wrFaBygF
	6Ozst8Egqc/QV1E5HTlJIapsBefLhYE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1638449641;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pvsbfNmbj9n3NmX6sav0pv2g62VPBlLiT8J9jst89r0=;
	b=jk/5Ap3UmdCNQInRuLLo8D5mBFjP1bSXGjPOGkx2w61YHhEVRu4HHwPK/IvgclJY3pDfch
	ed3Dmh7F29MpHmDA==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id A7B87A3B85;
	Thu,  2 Dec 2021 12:53:56 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: dan.j.williams@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	Geliang Tang <geliang.tang@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Vishal L Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 5/6] badblocks: improve badblocks_check() for multiple ranges handling
Date: Thu,  2 Dec 2021 20:52:43 +0800
Message-Id: <20211202125245.76699-6-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211202125245.76699-1-colyli@suse.de>
References: <20211202125245.76699-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch rewrites badblocks_check() with similar coding style as
_badblocks_set() and _badblocks_clear(). The only difference is bad
blocks checking may handle multiple ranges in bad tables now.

If a checking range covers multiple bad blocks range in bad block table,
like the following condition (C is the checking range, E1, E2, E3 are
three bad block ranges in bad block table),
  +------------------------------------+
  |                C                   |
  +------------------------------------+
    +----+      +----+      +----+
    | E1 |      | E2 |      | E3 |
    +----+      +----+      +----+
The improved badblocks_check() algorithm will divid checking range C
into multiple parts, and handle them in 7 runs of a while-loop,
  +--+ +----+ +----+ +----+ +----+ +----+ +----+
  |C1| | C2 | | C3 | | C4 | | C5 | | C6 | | C7 |
  +--+ +----+ +----+ +----+ +----+ +----+ +----+
       +----+        +----+        +----+
       | E1 |        | E2 |        | E3 |
       +----+        +----+        +----+
And the start LBA and length of range E1 will be set as first_bad and
bad_sectors for the caller.

The return value rule is consistent for multiple ranges. For example if
there are following bad block ranges in bad block table,
   Index No.     Start        Len         Ack
       0          400          20          1
       1          500          50          1
       2          650          20          0
the return value, first_bad, bad_sectors by calling badblocks_set() with
different checking range can be the following values,
    Checking Start, Len     Return Value   first_bad    bad_sectors
               100, 100          0           N/A           N/A
               100, 310          1           400           10
               100, 440          1           400           10
               100, 540          1           400           10
               100, 600         -1           400           10
               100, 800         -1           400           10

In order to make code review easier, this patch names the improved bad
block range checking routine as _badblocks_check() and does not change
existing badblock_check() code yet. Later patch will delete old code of
badblocks_check() and make it as a wrapper to call _badblocks_check().
Then the new added code won't mess up with the old deleted code, it will
be more clear and easier for code review.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Geliang Tang <geliang.tang@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
---
 block/badblocks.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/block/badblocks.c b/block/badblocks.c
index c188b2e98140..f16c54925275 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -1254,6 +1254,103 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 	return rv;
 }
 
+/* Do the exact work to check bad blocks range from the bad block table */
+static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
+			    sector_t *first_bad, int *bad_sectors)
+{
+	int unacked_badblocks, acked_badblocks;
+	int prev = -1, hint = -1, set = 0;
+	struct badblocks_context bad;
+	unsigned int seq;
+	int len, rv;
+	u64 *p;
+
+	WARN_ON(bb->shift < 0 || sectors == 0);
+
+	if (bb->shift > 0) {
+		sector_t target;
+
+		/* round the start down, and the end up */
+		target = s + sectors;
+		rounddown(s, bb->shift);
+		roundup(target, bb->shift);
+		sectors = target - s;
+	}
+
+retry:
+	seq = read_seqbegin(&bb->lock);
+
+	p = bb->page;
+	unacked_badblocks = 0;
+	acked_badblocks = 0;
+
+re_check:
+	bad.start = s;
+	bad.len = sectors;
+
+	if (badblocks_empty(bb)) {
+		len = sectors;
+		goto update_sectors;
+	}
+
+	prev = prev_badblocks(bb, &bad, hint);
+
+	/* start after all badblocks */
+	if ((prev + 1) >= bb->count && !overlap_front(bb, prev, &bad)) {
+		len = sectors;
+		goto update_sectors;
+	}
+
+	if (overlap_front(bb, prev, &bad)) {
+		if (BB_ACK(p[prev]))
+			acked_badblocks++;
+		else
+			unacked_badblocks++;
+
+		if (BB_END(p[prev]) >= (s + sectors))
+			len = sectors;
+		else
+			len = BB_END(p[prev]) - s;
+
+		if (set == 0) {
+			*first_bad = BB_OFFSET(p[prev]);
+			*bad_sectors = BB_LEN(p[prev]);
+			set = 1;
+		}
+		goto update_sectors;
+	}
+
+	/* Not front overlap, but behind overlap */
+	if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + 1)) {
+		len = BB_OFFSET(p[prev + 1]) - bad.start;
+		hint = prev + 1;
+		goto update_sectors;
+	}
+
+	/* not cover any badblocks range in the table */
+	len = sectors;
+
+update_sectors:
+	s += len;
+	sectors -= len;
+
+	if (sectors > 0)
+		goto re_check;
+
+	WARN_ON(sectors < 0);
+
+	if (unacked_badblocks > 0)
+		rv = -1;
+	else if (acked_badblocks > 0)
+		rv = 1;
+	else
+		rv = 0;
+
+	if (read_seqretry(&bb->lock, seq))
+		goto retry;
+
+	return rv;
+}
 
 /**
  * badblocks_check() - check a given range for bad sectors
-- 
2.31.1

