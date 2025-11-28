Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9402E8E13
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318791; cv=none; b=WWweLD3CU+9RQPfnKnuNTZ1/fVvJwg30ZcuhRhiBFVhyjtE31LeC0CDEBp+N3x5kKwWnjXSOSeUWkQyMP70bQWiQge9TSydpeBNYK0PjhCNoUhkG49zadOXsTVgVneuY2qeDgdgdhxICeIJHJrujQG1DzXZM6TcKsWGxwEKtoH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318791; c=relaxed/simple;
	bh=eIesZROL2LjNY0DrQ6P8R8b1cwhdKxEhWtmo1wbXnYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lk4SzM2AssnHlEWGciG+qyvsCDvhCU6dC/9GVcRadH+RsGdEHP0K7OgsaZg36ycGzy2+P51WVAGMcqh5J+BZtflbpnpTFEs9LLacwjn7J3en4pr88PTkgj1TV8WK2ScDHk5N0/C/fy3vy4tq4+jvnnyHedXmEyIto2Nuat9+WZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/Tctji+; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/Tctji+"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so1826097b3a.0
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318788; x=1764923588; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PAlkzqFb5MzFCJaoNDunPaLLzQJH14gDGKiKCNGaT3E=;
        b=M/Tctji+zir8RrMJa02kHnbrPuoppwKNRP11A/OWIxzOrDNDFfeYfPrJqH8NOFr3Lg
         U51Lkt9+FdI5+MGSKkwWfVBD15CQfETA++ib5U3O1lwSsBsVVL0cFEbU4bdP4JhGtgNN
         fjA83q1t8qymBzzqEhqfHWVLzfPkaQrbj66xnfpTfj3qhP8YOs6sFe+ztMQWGgiJX+CJ
         oTeL3k19OeEYtlWOMcFqsb51c3ThLwd8sdwyPwaJSmEAgOwD2rfkqtbQ9m+qWhxqhGpe
         XWCcvSJn2o9qL7D2Bm5O4tfXWwEN0oAVkq5V05AQfn6449WZgMHygL77ft0IAnedO2K6
         1/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318788; x=1764923588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PAlkzqFb5MzFCJaoNDunPaLLzQJH14gDGKiKCNGaT3E=;
        b=h+C6ZBPb81m2GjIVIgEHdBTxeB/dn0maFH4g33k4fUprfhWvfIzapTTg4advyeTOuj
         ca+5MGHlEfd7nRBzJ0FtMRdrBTu4LqrwOdWLrysOZvW/klw2nGEUlYyhED6n6LZ4QyjK
         ReQJQqr4kNnZV6eb6EQlb/WlLjrfF2khHJmCSTNMBI3tvWAV4leufTJDuLpLoh8Foa/7
         pqEUyPz15kraEMhtH0FJoEzHa5RqEolbyaQmWQOM1SHUpmOvjUNnapzdA5ASr+0Cf7cS
         Z1a/PrFMFT5OVu82ofXn6/xCyaxzm3xCQIkkNKBMQohe6/SvqCHpWU47hebu+1Vqqylt
         vVtQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4dtEjz/o/JhzvNphshc+J5n5Kc/4eHc0jWsnXl5vtEkvVg91i7rr8j00cGqNefkhUnDLr3gs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOizwcyz4eMgBg0M5Y4uLIahwmUokZ7I/N5HjZ5Plf7ZtVdB1s
	UaSmxap4VQcmpgFPdaksuDVOwX3Y5A0IOLfa6fYJYFUwt0huu5ckpjDe
X-Gm-Gg: ASbGncv8VSOGQgtuTeO6xz6XxGF3CgLqyV4p6VWf19nuhNYe8tEzx7GhuTukeQRHxCl
	qicV8AwziKpV44tp/KW0KGtxbTYlTDLl/neO63guUgpYUzsdqOK+hEixWlo2DNIKB6JD28wuZPw
	YlwJD/TYMVhqxgTQzmix+T5R3GA9cqz1eHlyxncv3pRUgZdjIc+E+uxMkxUJmCNC09CdUXgtS+F
	xW3XtS65LzuLCCmOBo3KBB9G9XhYHmmnjMyd3TvpJqNVySYS+/ctIbMIs9Qj1s7iBUpY8RMNHy1
	wHTG9IvopyKG6YN1CKv9zJ62XD8gYgUjlDtZ5jnT5IALkpHpJzJkald4qa9hdGWG6Dk6/g08gMD
	6TTZ6hBOxqS1zKFt+uRwMxULookvkYIL/dMb58kR4+dJ+NoWvJbxyCE4H/JLiceS8jfep3hOyh0
	JVO67EY3oCt4fS/4z65FKekb3jTQ==
X-Google-Smtp-Source: AGHT+IFIaFCQuKpxcLcZ63tEcOt0hGjrfoUQN9LWUQ2kBfICDUhGuL68J3zsB+mI5c6KDSWUdB+sFw==
X-Received: by 2002:a05:7022:670f:b0:11a:4016:4491 with SMTP id a92af1059eb24-11c9d84c6f8mr17988575c88.24.1764318788462;
        Fri, 28 Nov 2025 00:33:08 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:08 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:13 +0800
Message-Id: <20251128083219.2332407-7-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/gfs2/lops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9c8c305a75c..0073fd7c454 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -487,8 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(new, prev);
-	submit_bio(prev);
+	bio_chain_and_submit(prev, new);
 	return new;
 }
 
-- 
2.34.1

