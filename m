Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02772EA177
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318772; cv=none; b=AMlKhXSI+3lXfwAxfxb3BLundNj2bBFfCEkc+RAw+c2EmkEYUDjlojQvsT7NFgt+RN2HL7TVTk/HHWfW024EXKaWsBJzoCzKmQS+3PTQf99UyTh9mk5K5PVHWKSbgHQDoIJ1WaHmeJhtPDZ8KszQFk4ULYVvDEfU9cxEqIf87JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318772; c=relaxed/simple;
	bh=vDTdwwqFiUx+YnWL6sZwmz4ttt9jO7ABRme3mV3jkpo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nJBYebFOsgPury3hc1WXJYgVO6RAYYbg3N3LBohDD4VRrpXWpuWADJH6W9fGYFDo/jvdgL/hBUe1He2UV77B6RSACmT8kFGBkcheAD7MKIso9eamCCqmkMOavrIrOLBWaJvEpSNdDG1V7tDjOtGUMUXZ65qPoBbNnbPBd8mVrYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LEsHa1R/; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LEsHa1R/"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso2398728b3a.2
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318768; x=1764923568; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYdGxu8+S3la90e5ilLAk2WHMl9XT2MOPAJKSPmhLP4=;
        b=LEsHa1R/XXIrtn1JAd/GYr5JDdMiSEpIYHl83J8f31uEPzdORmDz/+OmZ2KvgUAkEy
         XOsx84uJXHmWZ33EUI/I5z/jEsaFhuBKVf5HtdjPn0cU0WHqePFqyABlb97zG1ESOWTZ
         X+gg8rqELMeOqXWhGFDew7jk3LmIJAIHN3yuEE3KagJWVz5kaluF5WwWe7u9VXteuJZr
         Ug+r1U7uHaj8Af+EEmyXEtgWQ1J31VdDmOcZYQ2vL4x19R9BggF9eUEZKSRAF1hgZhBn
         AmMxeu4yVF7drncWJxayzGUgt1kCfYTLWksh4zR0Lpzzag11BUtodZfeWLiMdiPVAp+M
         hJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318768; x=1764923568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dYdGxu8+S3la90e5ilLAk2WHMl9XT2MOPAJKSPmhLP4=;
        b=e9rEGcv5JDpzMT96c/JB+pl0sJKr7Ikj75xLhAYnsbwvunqk1zJPBbkhgHs4B686rg
         c+RU0KOISK9P8r+q1xxK15EUrJVHou/E9vlNcLZ0cf4ZHxYm8UaujbRqLb3/K8pJLe4Y
         RT9cJqBK5RsXL29+xKurCnUj/ROyzogHbI3RqwlXlz06EXptjNVhbdwUNtWM3vpU+tOe
         SMQnj0CcD6BAvYDw/PjMUwylZ/m5Diy+D0IN6gwOcw6roQnI408asUBCblBs7KKKRfn2
         gfxU20hhe9JzrmJiUeP/2Czv4e5axM+llkfU8dSkDX8RAqgGmeI9q+CDMIVjKgi9O7Sw
         zAng==
X-Forwarded-Encrypted: i=1; AJvYcCUqD7GkUQ4d3pkZem7QpWtwI2aHgAyAhbMF7/QQE7Z1VzL4tIFRkki+k0iBvareKZkcPGq7qww=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9mAPGWs6Xjg3VPtbXbtXwfevrIGFtbuLigfcbDZkrvCGgH+h/
	+/QoET+u76sWvlbC8T+APF7ha7QbbnhYavqCUY9wydB5vqNt1z7OWHLB
X-Gm-Gg: ASbGncv05vv2imr7+yARih7dCuyk/yaI65nuWDTrPxwaFeUT08fFbfkd5FTDHnOLF0X
	wUfNLhngXHmQ4IxUmK4BW6u8Eg9Dncyh0xL82RtuBPsMDLjxWcLf9apUXDEmpWpvFcO2aDqVSC6
	kmwmDbQkPZxWNNVcDGGOCfMef3lzS5pIpg/rx9d0EXdTj8OjyLxGZsvJkNn507JFOOh5xgNX6aH
	IwEiVGHYMH0kK198cclGaZsAjBhghReSlwNw101DxWWhP0OBAiPswwtaSlAd4Fooh42HhoWwWM2
	sL5MCdKwYCOpB/80gv1TM3jOIHcISxx/Y+kshRRJ6aXy7fQGufl/QBf5hlfCxzZHGTiUDUeauOF
	iGXo/ItC/GZtB/dbvEVdkWDkMe41/f2OrqEuejBbYewQfWvyAg4IJkzn6M2HcllqQRFE4kMOODH
	QDwSw3IjVbHkte4lzzYHlki077LQ==
X-Google-Smtp-Source: AGHT+IExXZt7YE3nF+952Md7MiVvxMbDW7G+yswwYtoDXLwvootnd7yuttY35MGv7RVbIjqP5duRMQ==
X-Received: by 2002:a05:7022:670e:b0:11b:a73b:233b with SMTP id a92af1059eb24-11cb68354b6mr8088695c88.28.1764318767897;
        Fri, 28 Nov 2025 00:32:47 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:47 -0800 (PST)
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
	starzhangzsd@gmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
Date: Fri, 28 Nov 2025 16:32:09 +0800
Message-Id: <20251128083219.2332407-3-zhangshida@kylinos.cn>
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

Andreas point out that multiple completions can race setting
bi_status.

The check (parent->bi_status) and the subsequent write are not an
atomic operation. The value of parent->bi_status could have changed
between the time you read it for the if check and the time you write
to it. So we use cmpxchg to fix the race, as suggested by Christoph.

Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 55c2c1a0020..aa43435c15f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -313,9 +313,12 @@ EXPORT_SYMBOL(bio_reset);
 static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent = bio->bi_private;
+	blk_status_t *status = &parent->bi_status;
+	blk_status_t new_status = bio->bi_status;
+
+	if (new_status != BLK_STS_OK)
+		cmpxchg(status, BLK_STS_OK, new_status);
 
-	if (bio->bi_status && !parent->bi_status)
-		parent->bi_status = bio->bi_status;
 	bio_put(bio);
 	return parent;
 }
-- 
2.34.1

