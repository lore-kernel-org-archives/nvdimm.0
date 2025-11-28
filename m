Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E112F7454
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318787; cv=none; b=GtNGt3OorFgd9opQ7kJB5RPgdHlRGT4CJwLuppb6Ru9+ML3tSHHtaxVauDxWrNwJU8qZXz/erKJHpJs8JMdFiYyq89OO6rkr+9ozv2RB9ULHGCz9Eu8eYUF3I8PblPByUxsBvNeYyzqISbOHLOlffwz5pfzonngeiMBTSeEfPWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318787; c=relaxed/simple;
	bh=+kdxszjTpaHcpdO+OsTg3+9Bb8a87RQlO+SGH8oGptU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YI68f6nUqbR1ERfOJoswpjjk+u3U0QHzEG4VAVf9+s3MmnJ0Zz95BTEBjXwGzLCgkD9P93Tnzw8L0jZxm/FmYRGCyLYk11NBOIFffxjZKGjPJ6NWh8/N3HUhRLcMpSSd86/iHjtc6SE+QyH2+0CtM2dG/mgRFQnxyyeZnSf8OqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XqG4gacU; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XqG4gacU"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-bc29d64b39dso1002539a12.3
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318783; x=1764923583; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOTI9zrIzg7zm0suBs1FvPesu0SkZxT8M/7CVofybKk=;
        b=XqG4gacU9SZIdL3nRR+pIDFwdfQAQYW26WeggPlmgHk91pUMHvWR1y5CsH+rPw8UeB
         cL1Nsf9IDY/mUKAvyJmVzT/UcMj4Faxcv/YQRAr4lGt3cmy5QNFF/CAtURb4WZ/Jav21
         rxnEtlNu3UXu89Kr02dKhykQp6/02H3LV9XOsDV+eFMR1lalfO5gimckJ7/NAzfCVcQS
         PpdTS73u/VC/tNzY0Irygas+BUZt/fBRuGod0AEkE8ZKifZMBTCIcg/PbHyRiCz4r1iH
         ezC+0zlovmt1GYTFv4oQkTTHIazidHbKomV8yeFh4geRr75kKqmKOuzom4A2r+i9KyZM
         PImg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318783; x=1764923583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WOTI9zrIzg7zm0suBs1FvPesu0SkZxT8M/7CVofybKk=;
        b=GUB317VgvH0Av1x6yNGrcILjRs8/kw/uoIi2lLiL29C6t2pvN2syYsTpQSCrlyvBhE
         RGyIC74swAFSpg5/rKhy1YlrD0z7CXmKPfKnqQaqS/ijwt6ah/TKt0EB0TylybDvpkRm
         uHZUsugP5OglxkdXgVQ529/4+c7Doy+wMI5TC2CF5eeIKo651Xmm7KAJB7lOZYusNHGH
         VoPgZTeo+XwTy8odYPAOeN/Wm8P+Nudx2dkumBA962cHCghxbeGs5g0vZatAw7EXDaJj
         4cLv+/H8MF43/bAK2L9Ni0EwepoiBTeZv0umdF9+Ard/7rJmbKrynNPXmoWOI9AWMurQ
         z3NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlJjyIVah9OOtDqJlrBZ4xWDid+lxn7PjJ4jFGCw/rzhdyZJZglLWEEFPcxTrZ+xvTgK49m/0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTtdvlqJ0ILjy4wRUmabE9ye7zPl15dmiAC19d0Uw5aVoSz+QF
	+Q+HZkmKBfZG5FmmrE5nhI80I1PA8SfaAGoOLOFI87SLhUirHuqykFDn
X-Gm-Gg: ASbGncsuD4MidlghN/rDTD4eETZTtVwpunJKz7d1Op772/4lSGIdPiy+tD556BvgyP6
	IFb7wF80MIrZBMao6nwn4zkFjd53LZUS/DDtTILg4+k81fYhBYDxelJaR72p23/QwFR3yTNVOfd
	MDK48j07XSMAwBLzOkYNy5AO/H0pWOeu2lbygAcHZumuMrYtA9YgdMHzcCeYU+Feq5fe+ZkyX73
	lC/dejXWK73HGRIyuQmp7Hmuj/a4vUAAbQf7IYK7mTG8lEH/0yf2L5C3INnV7+qd4Ap3WVvXcCf
	JO98gCBLHx/+EKAixsm4kzVVmtrFA63OFrcwl8JPJqD+3VX+aHu3WdLbA57n3HgbwXhVNjxpU1U
	7UPPCB8eeQNZan4K9QBqYzipRi0YGmK3CJsFldK+K1wJcJ1YSCnAFH3My8ii1+7jqwVc5YILVrv
	bZWZSMH/jhU/WiUDhtrhNRa7l9xw==
X-Google-Smtp-Source: AGHT+IG9KZ7rWCO0ABhUceCtzlD+O/EyLZjlRlvHPaAHNjz6G3IYpmLI91Aw7ItyMwREv8ZXa06T1A==
X-Received: by 2002:a05:7022:671f:b0:119:e56b:91f2 with SMTP id a92af1059eb24-11c9d870411mr17435747c88.35.1764318783005;
        Fri, 28 Nov 2025 00:33:03 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:02 -0800 (PST)
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
Subject: [PATCH v2 05/12] block: export bio_chain_and_submit
Date: Fri, 28 Nov 2025 16:32:12 +0800
Message-Id: <20251128083219.2332407-6-zhangshida@kylinos.cn>
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

Export the bio_chain_and_submit function to make it available as a
common utility. This will allow replacing repetitive bio chaining
patterns found in multiple locations throughout the codebase.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index 2473a2c0d2f..6102e2577cb 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -371,6 +371,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new)
 	}
 	return new;
 }
+EXPORT_SYMBOL_GPL(bio_chain_and_submit);
 
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
-- 
2.34.1

