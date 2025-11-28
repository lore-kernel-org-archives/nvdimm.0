Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE73F2E8B8E
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318765; cv=none; b=drs9sftereqqwkm86dj4S/+wUyPEMffZao9wAmYb2LD76S8mDgHXkYfkn/a8Hq+aZ++U7jHShlodD+roob3TKnt/cXo86yXVQDJonBkpcJE8jk7++opwbnIC5SZC11KkxY2yS53UkWUNfFT/wajjZTjeqrMNktWeHrv1imUe8HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318765; c=relaxed/simple;
	bh=nbYby2EM9de8liKCH6EPXwLAr+CXSG8jGQgCdHY1huE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n4rwibzc1cwO66wQiWoFspK68W2NsyQz/h/OMBzU5PjK4Mkfyzuik8CrKzYHmNxziIS7YDJe7f381+gAReT8pFRRkdAepeWS0mtMdP+DABbqMz+kxb+l9K3f57V1yMmfhuLTZhND+0lBv3w8Lk8NiMW7KFE+Lkkj/LkJKD1k324=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3BtgFLq; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3BtgFLq"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bc8ceb76c04so1093206a12.1
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318763; x=1764923563; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEXNzDk3PZG7Vl6bACrm82r4Ym6fDNxq87feOMpROvE=;
        b=N3BtgFLq/cvdaTHlVBJ2zwKAGS734L+NqR0I+kXcichDYbnjBlJjiURhOHahW1oKjL
         DbEF0raZm3LgoFJL+gpA5O3PU3k1gLRs/IiWClPGJgP31coEUAolCu+lwb92LlB0LrP7
         +Yw+IJcsyjhfdn4Eg7zLIp0QMvvAtkwHvUnJk7BVwpcIS4tDUtbHs6wobiDET4T6pOjH
         Vzq6PENS5HQ21n4EbxasHxfYEk3EV5rvZpGXsLGDT9HI7fXWAwR1QUeexCy95VqstBUC
         7qhaFiOz5GYvG1yHaNFW3Dz9uGSfENUIplIXP+XklRMYJ6m17jAWUYhTBcc4TLjCdN5y
         YgfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318763; x=1764923563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wEXNzDk3PZG7Vl6bACrm82r4Ym6fDNxq87feOMpROvE=;
        b=G7OatREqT3zzxgc0qjPURkJH+QslGhV0PuSC0Wihl+rLXvBeWaL7Tr3QBwe7UlZohO
         NU9oBaMPbwSc3cF7aWffw3gMeAJxr1yAyoJWA5Oc5xV+SOUS0t2YjiVJqSxtV05Q+GLn
         PhJ9Yd7XTYCv3HmYI60iXZdh/fD2ss5Vtvo7Q4U7Vx/l6l/mU0dYlcF+DQ3YiZInLz8J
         hs0++owr3O3bMPcY4tA76hyXFBDtJyNwGZrLNdlOvAK1tLt2N4UbCPPGx8KuVagA9ZhU
         0BznihxGPXwD6beswUtx+q4Xtp4G4bYqDxPjVLaWOZIAlOTbnuLBnfVdbyqd16BVXpy6
         02gg==
X-Forwarded-Encrypted: i=1; AJvYcCU5lIlvGB1dUz/iSwGZauRsklO3RcWwxDNL9d3CRRSk4uMeouA1IGRO7weibuAFWz61J2WslIg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUWRbJilSlBYoLFsrGpR1Wbw9qr9DKtTAwZgplxDx+MyOVO61+
	SKe+67haLSJqUijTo44t6hH1Cl4wrDYpwKO97vJN1c/eHG4KxmhHXSrh
X-Gm-Gg: ASbGncuuRfuL9sdoiM6wqKRhkJvyTvlpiw1SFEQxaRY/Ehnnj6Rfpkg/MHp30EW8jQ7
	KMurc89JrKGouagSOR0rX7qREs4VG6bUbB6Oau8Fwdab+oSplLdCRLBsMQ0Z0szba7Ku0+1U7LE
	Mejw0n8jiFv0hR0R2GHuF2yrfsTIw5j6nYHTfGMn/n5+LonobiJNawI+/E+u0HKt194aJlVxpQ1
	9HIxKSJ53XHWmeJ/0+r9EY77zbkqkxqwCmSIFY94p3fsMc5U2bFksqioc5xBMGOOtEZ6Vjv7PWF
	oVxt73DDW3K5p6bF/L7JStr+80tuB5WB+qngSdYjWWgAzSHZ/Mz0LGAXeOhfiwD26zYQ//GSCaf
	EVFMJ+T0IbbEOlRL4SLfsZMXUTUiHJdDcDqRJDHn39aINvaGvfYnZEp7LvJuAi6VMhL2ggNd89r
	YekON/14qeC23PfKayDLgbZJDM+A==
X-Google-Smtp-Source: AGHT+IF16ld9QNCqaVETJUBsXYjs2kY4Pw4mcEH3R6jDofKcar8TG/UX/uqF2Rs9fZ+s8kH1ElEzpw==
X-Received: by 2002:a05:7022:7f1c:b0:119:e569:f615 with SMTP id a92af1059eb24-11c9d712704mr11436137c88.14.1764318762983;
        Fri, 28 Nov 2025 00:32:42 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:42 -0800 (PST)
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
Subject: [PATCH v2 01/12] block: fix incorrect logic in bio_chain_endio
Date: Fri, 28 Nov 2025 16:32:08 +0800
Message-Id: <20251128083219.2332407-2-zhangshida@kylinos.cn>
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

The `__bio_chain_endio` function, which was intended to serve only as a
flag, contains faulty completion logic. When called, it decrements the
`bi_remaining` count on the *next* bio in the chain without checking its
own.

Consider a bio chain where `bi_remaining` is decremented as each bio in
the chain completes.
For example, if a chain consists of three bios (bio1 -> bio2 -> bio3)
with bi_remaining count:
1->2->2
if the bio completes in the reverse order, there will be a problem.
if bio 3 completes first, it will become:
1->2->1
then bio 2 completes:
1->1->0

Because `bi_remaining` has reached zero, the final `end_io` callback for
the entire chain is triggered, even though not all bios in the chain have
actually finished processing.

As a quick fix, removing `__bio_chain_endio` and allowing the standard
`bio_endio` to handle the completion logic should resolve this issue,
as `bio_endio` correctly manages the `bi_remaining` counter.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b3a79285c27..55c2c1a0020 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 
 static void bio_chain_endio(struct bio *bio)
 {
-	bio_endio(__bio_chain_endio(bio));
+	bio_endio(bio);
 }
 
 /**
-- 
2.34.1

