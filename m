Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DABB33CE87
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713101; cv=none; b=o+wlHmo0IrZEmkS0Die2mM5SFihg56INwWvk0926IihNaXENtsbIhVQSkulQho6Au52aHidBtBz5XRF9uAIX4Ws3NYF1bYt00d+1RRkIv5ItpLHpEanNRrdWv06+D0alenQvlhO45aaArNYJJx66BA8K66oN9zoYEe+8yhxlkc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713101; c=relaxed/simple;
	bh=tcwWQ/Mm+gFAO+0q/5/zfPas5QNJ1LyCpxuvQ1Cp8pM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gpQhnOJoBPxVoScONernOtonA1PfrEPB4SU4ueZbvvc0eOm5E8H2abrCVlOv+bVGl0NUgn5qaL6TlgmI6hU38d4DinbJeISWR6eB2JpQd/AGJClplLqQyby3EVOwfHPcb87BsH7sxXbkn6mfHrZcCRXW0abm3y18XeeFfc/UTTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eNI1+Y/w; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNI1+Y/w"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-11beb0a7bd6so2461946c88.1
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713098; x=1764317898; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ti+pzdwk6nGkvRYiXxAYuzkkiit15aTQXXZIirIbYng=;
        b=eNI1+Y/wPjmnjeU9vEFxd3nWV6NqcqXaxUaU35gah+kfTRYZZTTsx3jCSs7f+lX+pM
         zEtHKWJ3iWi8cSyoim7uKM3dIgNCUFo+lMgTXJ5+Ch5P/jhrplCdUYaSLQTgY4UvzrKH
         3v101FcTZDdsLXuBPqJv0eCI3NXw0NUjmOfE6FN870zfw/TvKcHNPsPLibS0PsF61Nx2
         mICHaYXaG9Kgg/lIickWb+HsvirWnO5JV2j6EnRtjagHmI5ih1CGoH4D6nR9I89uMy0e
         26XS8R/pT1BYfz8eqsOyXkhrbZQFo0Mqv7A+rgQV0ANJuXyRBj/xojtlM99UvNvjst1r
         lIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713098; x=1764317898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ti+pzdwk6nGkvRYiXxAYuzkkiit15aTQXXZIirIbYng=;
        b=LcQQpsryEq990/gW6hVATOSGY7+nCe3eqakH5s+2v9PcuMXHeFN+dz4U+HhC7o5oxE
         LowKQS2xr7AOsbZhH09J0IHqQt2CZ8lD6uWtPUckI363k/z62UgpxndrUFM098ao/udO
         M68n9QlJbXX/HS22Mqcj08a460pl6LoUvfViik8qbSJ8lwAxzdQD4cXk7MO3rdh2I2co
         xla24t4JnMhvAGiHtRKEndi5ya2wi9+J6UbsCql1QDf2lnJyahTMyFLmGgZupGNADLFo
         S030Qw2JAqOIamryt3OdHFKF+PcSLAeQJSfnsd+9V06HeQQ2cK/KRiZmI6TsaG7STK8Z
         gU7w==
X-Forwarded-Encrypted: i=1; AJvYcCUKuXXx1vzQ/aEVYLfquMntSxvTWy6i5fEm+e7w0E6DPf+shzAdbcBtKzzta/vKwqNkImtM9uE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1TTHZ/IyZI+DxBj88QR2HuAKPStgtRWZUPJ2m+1h02VE9vjiH
	RoWmjJZLouTj8Fce+p1p09PtkASRPhrnjoPPPnOd4eYQ6OiWF3mTzGr9
X-Gm-Gg: ASbGnctcIZJ7Y2rbhaK42h+iquQwsXQtpuHMWHXIF7OwWEvMbLhrVUokP/8z7tCkFu3
	8non2Czs1w1JhExu0g7wI7rBwHSjiIw+0CHoGXjo6qClKgNpFom/Or2Co4/qsFh//owndCmndC3
	0uTnNcXq3QczehZQAylieI87TOlsWBdDkVel1zie2BMrzaavA4Srf5bQQKNLlKG//AgdkC7o76S
	lyMtYm8wd6reFPW43Cj7gdAtnvK0khisnVb0p/2OawuZvcqwHj2B2UzHOxXTmlDSArmPxYmXXfW
	esK1C1SNh4p05by3pAw+8A9lTluMWLM7fuxpif+I0TvAzlx62GegYa9KxqxQKyC6hc4nmRpL2ZG
	qD3f16aQJt7PUi1UHY8VYc7Yeqa3isDsr4iD5+Xa9WSjZRJX0pKX9KyJv2OPeS9T6mY1AzgITlX
	RDrsf2f9JNJl/R/oPj56wWy/ti+Q==
X-Google-Smtp-Source: AGHT+IHOO8G/RNP4+N7h+q+3n5RC1e80lk0gJCjZ+Jmb8LlUPm7c2u0245iVMv+KJKdve3qFM22yaw==
X-Received: by 2002:a05:7022:ec8a:b0:11c:2632:b7c1 with SMTP id a92af1059eb24-11c9c8a63a8mr515277c88.0.1763713098073;
        Fri, 21 Nov 2025 00:18:18 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:17 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 4/9] xfs: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:43 +0800
Message-Id: <20251121081748.1443507-5-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251121081748.1443507-1-zhangshida@kylinos.cn>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/xfs_bio_io.c | 3 +--
 fs/xfs/xfs_buf.c    | 3 +--
 fs/xfs/xfs_log.c    | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 2a736d10eaf..4a6577b0789 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -38,8 +38,7 @@ xfs_rw_bdev(
 					bio_max_vecs(count - done),
 					prev->bi_opf, GFP_KERNEL);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
-			bio_chain(prev, bio);
-			submit_bio(prev);
+			bio_chain_and_submit(prev, bio);
 		}
 		done += added;
 	} while (done < count);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 773d959965d..c26bd28edb4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1357,8 +1357,7 @@ xfs_buf_submit_bio(
 		split = bio_split(bio, bp->b_maps[map].bm_len, GFP_NOFS,
 				&fs_bio_set);
 		split->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
-		bio_chain(split, bio);
-		submit_bio(split);
+		bio_chain_and_submit(split, bio);
 	}
 	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
 	submit_bio(bio);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 603e85c1ab4..f4c9ad1d148 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1687,8 +1687,7 @@ xlog_write_iclog(
 
 		split = bio_split(&iclog->ic_bio, log->l_logBBsize - bno,
 				  GFP_NOIO, &fs_bio_set);
-		bio_chain(split, &iclog->ic_bio);
-		submit_bio(split);
+		bio_chain_and_submit(split, &iclog->ic_bio);
 
 		/* restart at logical offset zero for the remainder */
 		iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart;
-- 
2.34.1

