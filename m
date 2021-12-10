Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C4F2CA6
	for <nvdimm@lists.linux.dev>; Fri, 10 Dec 2021 16:05:18 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id D30BA1F3A4;
	Fri, 10 Dec 2021 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1639152316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ddmMlVrjgrULfL6Y4zT0HX4xe+Bgg96hwCyTuK5z9Wk=;
	b=Qzgg4dFN50jOwRQgFUDBHVfDdxWmctkeKSCAsCPTBLhzd6M4F44LX7H1hNhZI2VkxhTlMD
	Ww3dAIGmlfV+YzikSFJobH16P8E60fVFXUI0F1RdRtLfa2JcbFROSYTRymz8VtfiNc69V4
	nsZ3qXBqEojpEnvBF3DjLuJGFZWckTA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1639152316;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ddmMlVrjgrULfL6Y4zT0HX4xe+Bgg96hwCyTuK5z9Wk=;
	b=UTX8uwqcA6mpkIe1tk3f04NpR0WQtJiSvcY+407X55GTXv0P3TT1YcRCTSSr35KdI9i0BE
	lA5YbRjv+6YIaLBQ==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 0730BA3B81;
	Fri, 10 Dec 2021 16:05:13 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: nvdimm@lists.linux.dev,
	linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Geliang Tang <geliang.tang@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Vishal L Verma <vishal.l.verma@intel.com>
Subject: [PATCH v5 1/6] badblocks: add more helper structure and routines in badblocks.h
Date: Sat, 11 Dec 2021 00:04:50 +0800
Message-Id: <20211210160456.56816-2-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210160456.56816-1-colyli@suse.de>
References: <20211210160456.56816-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds the following helper structure and routines into
badblocks.h,
- struct badblocks_context
  This structure is used in improved badblocks code for bad table
  iteration.
- BB_END()
  The macro to calculate end LBA of a bad range record from bad
  table.
- badblocks_full() and badblocks_empty()
  The inline routines to check whether bad table is full or empty.
- set_changed() and clear_changed()
  The inline routines to set and clear 'changed' tag from struct
  badblocks.

These new helper structure and routines can help to make the code more
clear, they will be used in the improved badblocks code in following
patches.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Geliang Tang <geliang.tang@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
---
 include/linux/badblocks.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
index 2426276b9bd3..670f2dae692f 100644
--- a/include/linux/badblocks.h
+++ b/include/linux/badblocks.h
@@ -15,6 +15,7 @@
 #define BB_OFFSET(x)	(((x) & BB_OFFSET_MASK) >> 9)
 #define BB_LEN(x)	(((x) & BB_LEN_MASK) + 1)
 #define BB_ACK(x)	(!!((x) & BB_ACK_MASK))
+#define BB_END(x)	(BB_OFFSET(x) + BB_LEN(x))
 #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
 
 /* Bad block numbers are stored sorted in a single page.
@@ -41,6 +42,12 @@ struct badblocks {
 	sector_t size;		/* in sectors */
 };
 
+struct badblocks_context {
+	sector_t	start;
+	sector_t	len;
+	int		ack;
+};
+
 int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 		   sector_t *first_bad, int *bad_sectors);
 int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
@@ -63,4 +70,27 @@ static inline void devm_exit_badblocks(struct device *dev, struct badblocks *bb)
 	}
 	badblocks_exit(bb);
 }
+
+static inline int badblocks_full(struct badblocks *bb)
+{
+	return (bb->count >= MAX_BADBLOCKS);
+}
+
+static inline int badblocks_empty(struct badblocks *bb)
+{
+	return (bb->count == 0);
+}
+
+static inline void set_changed(struct badblocks *bb)
+{
+	if (bb->changed != 1)
+		bb->changed = 1;
+}
+
+static inline void clear_changed(struct badblocks *bb)
+{
+	if (bb->changed != 0)
+		bb->changed = 0;
+}
+
 #endif
-- 
2.31.1

