Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353D12E7BDA
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318823; cv=none; b=IoI6SDppB0Xng79XYs4nF0OHxpMI2ATio3lZpR2bRjZYYWGODj77pSxDt020ZihPhjPvnh30JRqeixezR6srIPT0cn/hvuS1QZol7q/eb65mprVfpeUnbOVFTXXMVTsWnTYdCBWfngU0I2DFkPjqLrsoU5kPJuROhuUPlmsAzcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318823; c=relaxed/simple;
	bh=HTuaf3JKiz2KHLk/jbQPL7NkOb05byK6j+tq4J3zrGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qFflAwhAaRI7kh5DRGHpoxLVEnO+Yfpi4Ajs6JLE/o5eTnzYYx9ytbj/EEgbzGboFn1+hzwBZfqFDtBsSklIcORzDdiRJe540p3B8sbwdzGq8zlxD6nfvPq+06ddSD2ScByJKgGTd47jyuGk8693y5ou1+rDoKbRL8ykOiinUtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SYJ7GAme; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SYJ7GAme"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-bc2abdcfc6fso995603a12.2
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318818; x=1764923618; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JuZTiXTtCfnBMrxTr4djU8x13PVqvGl4QPuQVkzEeA=;
        b=SYJ7GAmeEdS8ECds/Mx2umdfnzhizauVV/jrQ3jwPmuX1L+WvRK6172NUEKe01eVcS
         dT/D1EXbpemUIblLAUGfHxPCWaT/vOEPR4VDs+FV6//OVcBXcBzjN2htjX5t0UY7j7un
         6HYJaMexBEAjekQWHBx8As78AdDacsNhFoEncV/WltITY7speVDSb7CwWw6I51ER0cwg
         BKblSgGoMVb6APfwiBiiAvheyD+CPe0qURr0THAo/39yRNgoJdVbYp1COmPso+NUK9IF
         GCM06OWuUpjtsl9IaYZ9SF4TmWsI7rdKZA8s6RWUjJ83WEe8gA6GVKcmWVUHTXQcXAZg
         y4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318818; x=1764923618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9JuZTiXTtCfnBMrxTr4djU8x13PVqvGl4QPuQVkzEeA=;
        b=eQXDHDIovZKVbJ1STYL0hrlW6U8+xO1WCaTG1xb3DA2QIAi3DN33i8px8lf+0qaQLk
         s7DCAzMs1qifLNYD1HdKzEXDxI8LoHp3j+6A+jm3UmA7pQAvQNxRXOkqZ8CenLZZHTvC
         HcwvtoowadsXakd3Yi98E1tCLcptPDhu0zxn4a7+k0A78I66KayEtmJeES3bpwu4HQtU
         uIbjRQ/WweQzXBMXtbbtGzfXvxiTOBE6miEaGPI5jwfXdZdSSoxUCCKyq7CIuv+E+rir
         0b2Hpwfr0DvmwYCSbNgFfEzP29B+TOrNRE0j5PjV3YlPOQz/7tP3BT6h1SLMEmNpEcaC
         oWIw==
X-Forwarded-Encrypted: i=1; AJvYcCXcsm1/aR+P2DtQe6kzqyV3ok5pek8jOU2qzBIGP/LBIlgkcgEAFDEDxYdh1+ZlIyJvDatUxaY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzomly9PQAlaRY89SO4lP5RI+h0M5f+lJJMwXn9RiCLyPEbcots
	OPmKVURFaASONpURSxAWlqj/dNz1TsIDWMn6zzG/2xGsk99VAtGJQTeh
X-Gm-Gg: ASbGncsJ4aXiPjypWPzXI1K+HapHVRAzk3WA3ynt/MeJ//+CytJYeU4zMqOBgUlYcD3
	Z2QMlqUtKdhXjvi+p+VhlbA8fQCDHarv1KIEZTvZcQwBznoDV9JH9R3pLoaElangEcsz4vJEyEj
	6pJTmKKv9TIDn9Rh8BBxG1myi7ZK01kjQelJMY2WKLyVVjMSivtq25hSkEEib67qWoA+3xGeOld
	7bmBMy1hoxaBmHHnCoFgG+ZmxsqasCTjNoYiMoYVQiyflSB5go8r/6tZ0V/e9THeQQVxCZw3rnt
	ReBEO9r0FpsGAoRO3sJUvFtnSHGlJhvtNe1jdz+oGSTmQSthNvqqTKBfD9l93TQcC1qsOdX8KwV
	I1dUpzysoYpv6dSF+NTATkZs+w7+cVzWUmpHI94qUlkVEJXe53Kr06vugeSj5w88ROCd5bIpztD
	fz8JyRyVLWGltOKq00U28u0MCWmA==
X-Google-Smtp-Source: AGHT+IEiYKFOm1UmbHzu9Io+L0ipF/pftCo6ih2XEqCkxPLrZNrFMt6HrxgMvpe9BJ/P01XRe5CPUg==
X-Received: by 2002:a05:7301:162a:b0:2a4:3593:ddd7 with SMTP id 5a478bee46e88-2a71953bfaamr12018765eec.4.1764318818087;
        Fri, 28 Nov 2025 00:33:38 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:37 -0800 (PST)
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
Subject: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio chaining
Date: Fri, 28 Nov 2025 16:32:19 +0800
Message-Id: <20251128083219.2332407-13-zhangshida@kylinos.cn>
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

Replace repetitive bio chaining patterns with bio_chain_and_submit.
Note that while the parameter order (prev vs new) differs from the
original code, the chaining order does not affect bio chain
functionality.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/nvme/target/io-cmd-bdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca60..4af45659bd2 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -312,8 +312,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 					opf, GFP_KERNEL);
 			bio->bi_iter.bi_sector = sector;
 
-			bio_chain(bio, prev);
-			submit_bio(prev);
+			bio_chain_and_submit(prev, bio);
 		}
 
 		sector += sg->length >> 9;
-- 
2.34.1

