Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67FE274B5C
	for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 09:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406903; cv=none; b=mSaj8yoZ47EMLqhOjuv8/D7e7j41EgdLulLBoNrsV3NXuLOyM71ccaPKaJ2lzMcCUGsD20M3cO2ti2thG+tYQNyKi4ndPR03KNlZH25NARYPOGPAF/P8nss9EzgMfKCUzNMRIxAqj2zVhI/UxrTTcrCPZ6YVc7McOEmrNepEOgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406903; c=relaxed/simple;
	bh=JLIdNXPMejF737Jv1xzF5GicNRibkuRDb9iX4pmjoI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OsK5Sp0zG0YYa0LqQFLehzzCH/YwG/x/Sqj8YYozpWEATe6NuUvoF0fMVuBWdDIao0w1fqKXAUA+r1gOqajel7c8d0NWEw6CM9NBGnl7ThOvRLxGM6kJ07CnqtaJZhhkV2QqJCq5+NzylBG/ey0M6dpCumBYynuGYL8newW0/x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M6a4y1ab; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M6a4y1ab"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7ba55660769so2181587b3a.1
        for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 01:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406900; x=1765011700; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=M6a4y1abV/WzvZ3r4zY8larKIGFwqUaJUw86JNHPP6XZWflt7Voamr3OhWGKUATPvt
         DktUsOndfhgAKbxDLs0AlCHLN1MSQn0/QsyKFReYO7yp05LmziT+ryAJQngLW7wlv9b9
         pEPm2u6j3ma+zqFXK6Ty9uzaGDweejp67+O6tHYItJLvXGk+BXAR3grL68nejKOWFti1
         ZgE9s5AT7MzKo7diZkGIEceXEhBGtBFVgiKSqHPRMFeY4OQ5Zsi1yyuNyI29r4UnkwJh
         w+5yzaKQ8GRtajv6GvcemKb/z2tcbFgyPUgJE2rstbw40CmRJcq05S6qKCbMD1XnsSEB
         GkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406900; x=1765011700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=EE7xkjYUdKJqHLrxTlPQbsMjSAUgV8rk0oyfae0h6fxKwLyNqsKPGQuYL2KtNBu5fC
         mfvgX57MjN3ilsL6aRO6tjtUrgvG4uOAoObgxh/x9AivAK6PrvZ53yBxn36eyrrGRni1
         kpKB0pd8nqFEdkENRVQW0jQsXtjULJ+ELQvq3uNJWmn5TQ4w4yS+H+W20gaMgChgVSue
         azoTShgMaEDO8HRyNmNn2MnjN43k9QlhRTLls59RE4vdDCbgfF1dP7HurTKjyCuqmN5t
         rNFZ+lylGGx4kJckNpG1EmxKICSzLpO/jQU8AfFIW15hQ/moruerih3X7e0bn0+znV7P
         rHvw==
X-Forwarded-Encrypted: i=1; AJvYcCW9PWMqMhmfhPoikd4K1gj7Urs8U1oN+Tpqv8ZYWTChbUe6L5oiVIqn6Okf77+0pKGoBMFnTqE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8PRB7zOWv9qGVQjsy9Xv2tKimHIge+9+WHtHG/A0BEZCFc85G
	r18Nuj3r4xJTL5u7+Ne8uanlDanYV/kvP2yOBHLG7nOXa/Je9FL1O9U+
X-Gm-Gg: ASbGnctWp0rgstuLFOBSufPCNKjnEnM/TrMYe53pogiBktgPPD1oEfkrPjKpK9et0vk
	IooTv/S0T7NFJ3TCFDyIccWsy3MQx+Ecibd0VutsPVb1jtNSjNwlt/sekTDtm0bWVUwzlOkrovu
	f2gH9ZXggEpeUyYsUa9hQAn3WKCajreSbfjNpT9bQ/MKPPtsAkcO990igepGD864Gu/BB1y1cJo
	fsjPc/4WyHJ5opu1ntiNQrz7E0nBjGozpNjc1A7gW5eX/kr7O6u+TB+J85dEnudWa3vi9+oWYKf
	Djw+fNJ1w9FpuVbCc/9H+WC0wGX1Mf3sc32ogz/LL5OJVlpqoze4dAOlpUbY/W6ki/OSQPgTlIW
	Wf+ukRgP80a5A66KvvushiY5gHwrPjNveobVJtLtFxPqvB1KeWEtHy0qNekztxWKPk2OkhHW8Sn
	f7ZhQzhPuswMJEXVIicXBg6kdhlT6SMZhIgiSc
X-Google-Smtp-Source: AGHT+IF9fpUjxnsoJ856uo76C4AbEbv+isvtq3QMxPEeI8s0lui+ms4Diwary4B5eKv1gtl0O4hKMQ==
X-Received: by 2002:a05:7022:ec0d:b0:11b:9386:825b with SMTP id a92af1059eb24-11dc87b150cmr7316305c88.48.1764406900072;
        Sat, 29 Nov 2025 01:01:40 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:39 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 1/9] md: bcache: fix improper use of bi_end_io
Date: Sat, 29 Nov 2025 17:01:14 +0800
Message-Id: <20251129090122.2457896-2-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Don't call bio->bi_end_io() directly. Use the bio_endio() helper
function instead, which handles completion more safely and uniformly.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde..82fdea7dea7 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1104,7 +1104,7 @@ static void detached_dev_end_io(struct bio *bio)
 	}
 
 	kfree(ddip);
-	bio->bi_end_io(bio);
+	bio_endio(bio);
 }
 
 static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
@@ -1121,7 +1121,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	if (!ddip) {
 		bio->bi_status = BLK_STS_RESOURCE;
-		bio->bi_end_io(bio);
+		bio_endio(bio);
 		return;
 	}
 
@@ -1136,7 +1136,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    !bdev_max_discard_sectors(dc->bdev))
-		bio->bi_end_io(bio);
+		detached_dev_end_io(bio);
 	else
 		submit_bio_noacct(bio);
 }
-- 
2.34.1

