Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882E8219C2
	for <nvdimm@lists.linux.dev>; Fri, 11 Aug 2023 17:07:08 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id D17A51F8AF;
	Fri, 11 Aug 2023 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1691773626; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NUtLWYOt/N0Zd+DrnCnKgvDs5nxMVmo5oDzyzTa98BY=;
	b=Q9AJPYKaY6NSu2l4DYrV6cG5lO5+g2UXvPn7Q25RmlRxmNkuK+d2fH5XfaXC3A2DkS42y9
	x6GBOUG/uhT6/ci06FcJMqoHofHdpckqbR/295CXb45+9+A1SfKPkvDPGDkKznLLrQcnVK
	neTKQFmwWClbSZxhLEGdecY9f9Cz234=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1691773626;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NUtLWYOt/N0Zd+DrnCnKgvDs5nxMVmo5oDzyzTa98BY=;
	b=Ohj2cjqsgprh4EfFxMv8KuBLcPiNSqpEbiEg1Wy++5SoFHT1iu5Pbs6mPtellD0O8BNYZ7
	f3ALkgZgomMynRBA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 149882C142;
	Fri, 11 Aug 2023 17:06:58 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Coly Li <colyli@suse.de>,
	Xiao Ni <xni@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Geliang Tang <geliang.tang@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	NeilBrown <neilb@suse.de>,
	Vishal L Verma <vishal.l.verma@intel.com>
Subject: [PATCH v7 1/6] badblocks: add more helper structure and routines in badblocks.h
Date: Sat, 12 Aug 2023 01:05:07 +0800
Message-Id: <20230811170513.2300-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230811170513.2300-1-colyli@suse.de>
References: <20230811170513.2300-1-colyli@suse.de>
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
Reviewed-by: Xiao Ni <xni@redhat.com>
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
2.35.3

