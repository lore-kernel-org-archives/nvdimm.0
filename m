Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319CD68
	for <nvdimm@lists.linux.dev>; Thu,  2 Dec 2021 12:53:38 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id B355B212BC;
	Thu,  2 Dec 2021 12:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1638449616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CaKt3AAiYOiLQUcAfiSVA37cWQrPsZbhnJ2vAXDHCUo=;
	b=OBl0GZMftS5o54FuwFvVFDeiPewi9yDAhD/Z4aqwSjdrg0BAghSkXXEkiM2EDSti5B97Iw
	iOsize4HnqpTwXRV1Vj/zAPXasSKC1FGmDfus8rtx31I9b/FfG9m07G4LbFq3ADzIiwdLX
	1kWPQzr1V91mEf/HgvHMxYaIBZhvz2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1638449616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CaKt3AAiYOiLQUcAfiSVA37cWQrPsZbhnJ2vAXDHCUo=;
	b=DtaLGpYYaMOQMLIsGHyhE9EM4/A2pMdGGJvAuKaEWHHy7XpwGJHDJqEDbNn4ljijkqYw3+
	e+wlGMwkRG15KLDA==
Received: from suse.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 6EE33A4098;
	Thu,  2 Dec 2021 12:53:31 +0000 (UTC)
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
Subject: [PATCH v3 1/6] badblocks: add more helper structure and routines in badblocks.h
Date: Thu,  2 Dec 2021 20:52:39 +0800
Message-Id: <20211202125245.76699-2-colyli@suse.de>
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

This patch adds the following helper structure and routines into
badblocks.h,
- struct badblocks_context
  This structure is used in improved badblocks code for bad table
  iteration.
- BB_END()
  The macro to culculate end LBA of a bad range record from bad
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

