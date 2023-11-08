Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B61C8C4
	for <nvdimm@lists.linux.dev>; Wed,  8 Nov 2023 04:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I66+S1xP"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1cc4d306fe9so13908975ad.0
        for <nvdimm@lists.linux.dev>; Tue, 07 Nov 2023 20:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699418764; x=1700023564; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AccMyh+RlaZEsXK1ML+1emsIzpOUjcybMBaau+EZXEI=;
        b=I66+S1xPO5Dtki+UwxnDL/JjLxnkV6Gr41qJhEDjRSMc5jSqqkPs2iIN14VwSbhGSk
         9qRj2fyj4erSlAiqTUr/Qz6ezV4/ZLUQksYfOyq4O8f379LuHRxEqFH1U5xto1kIJGfZ
         Mt8WuJeRsvLPz907fuspCSqh01T0oJyFaQ1z1KfVqOTvpZEQrBY+Q5xQawadgdf7y/5f
         qLTsz6gMM3HVlHllE5BLAH0y99lfhC0rQvRny33VKJeCGnFWhhtAdHfgsebuoe4MDVJd
         5jKK9adKiCGdiKlbV9yxjoLuXHO7mD6byGOfaNoWPMq84DetuQQjd7WpFg3RXH4BG56L
         blug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699418764; x=1700023564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AccMyh+RlaZEsXK1ML+1emsIzpOUjcybMBaau+EZXEI=;
        b=jVkxvkfUZCstPtoUXWEgWHmvMFdszsrhtXya66TrtcMxjmhVikrmPbnQ0DYEuIifJ0
         ht0RbaX5lsUHHI92RFXHXoLWg2gG5uwPyVKIK7ownGlEq7bmo+IRVd3xsbktDOyPqPdQ
         /GRLMz+wAw4YPdF8V3uYksc00zAEi7ItYUbkaUa7ob9Uyd7+2gsj0vbV9iqPNBiwJ0Ql
         X5JPlmSQcR8n1qyp9eI3h/TR9gIzyNt30Pe7vLcoQ2Ep6bokwGOuxAAIm20vkuEPySuJ
         Zcstnt2zqTq4DJSNI49JglebtiUAEL8DtIpCDzBmAtR2O2ojWfpYX8AZJYOBjmUPPim/
         W3YA==
X-Gm-Message-State: AOJu0Yx4aUVbAXQmBrX94TIH83gWPdSTaIDgPWLzqMdg5OggzSFzqKtu
	mFFRJzkcGxqKUb39cCmI0JU=
X-Google-Smtp-Source: AGHT+IHTBdEucosqnOg7K+garwd4Fwx8/Q/fzzgOpu7ehbtJq8I2JmalwcBjZ5QvjkrmGKJFEj/H8g==
X-Received: by 2002:a17:902:d2c4:b0:1cc:277f:b4f6 with SMTP id n4-20020a170902d2c400b001cc277fb4f6mr1000152plc.6.1699418764403;
        Tue, 07 Nov 2023 20:46:04 -0800 (PST)
Received: from abhinav.. ([103.75.161.208])
        by smtp.gmail.com with ESMTPSA id n15-20020a170903110f00b001cc32261bdcsm666079plh.248.2023.11.07.20.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 20:46:04 -0800 (PST)
From: Abhinav Singh <singhabhinav9051571833@gmail.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Abhinav Singh <singhabhinav9051571833@gmail.com>
Subject: [PATCH] fs : Fix warning using plain integer as NULL
Date: Wed,  8 Nov 2023 10:15:50 +0530
Message-Id: <20231108044550.1006555-1-singhabhinav9051571833@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sparse static analysis tools generate a warning with this message
"Using plain integer as NULL pointer". In this case this warning is
being shown because we are trying to initialize  pointer to NULL using
integer value 0.

Signed-off-by: Abhinav Singh <singhabhinav9051571833@gmail.com>
---
 fs/dax.c       | 2 +-
 fs/direct-io.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 3380b43cb6bb..423fc1607dfa 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1128,7 +1128,7 @@ static int dax_iomap_copy_around(loff_t pos, uint64_t length, size_t align_size,
 	/* zero the edges if srcmap is a HOLE or IOMAP_UNWRITTEN */
 	bool zero_edge = srcmap->flags & IOMAP_F_SHARED ||
 			 srcmap->type == IOMAP_UNWRITTEN;
-	void *saddr = 0;
+	void *saddr = NULL;
 	int ret = 0;
 
 	if (!zero_edge) {
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 20533266ade6..60456263a338 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1114,7 +1114,7 @@ ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	loff_t offset = iocb->ki_pos;
 	const loff_t end = offset + count;
 	struct dio *dio;
-	struct dio_submit sdio = { 0, };
+	struct dio_submit sdio = { NULL, };
 	struct buffer_head map_bh = { 0, };
 	struct blk_plug plug;
 	unsigned long align = offset | iov_iter_alignment(iter);
-- 
2.39.2

