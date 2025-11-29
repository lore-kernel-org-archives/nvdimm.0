Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA2927F727
	for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 09:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406916; cv=none; b=OUYDzLFt2TmsLIq4BJTmK3+NXlO15lAQkO9FikV+caMoSL1IWVLxBhEmCuzqkZ3ZVCh4YkNNr+d5lIvskppWIgleahk2h8wNNtX5tIho+9fFrw0B6qZjZ9uANSQWZBJXS2Yslqm/4BDWJBXoqmNCERkGqe4uLpFFSpgAC+NuZ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406916; c=relaxed/simple;
	bh=pDPxpgP4y7Y34S846UZ5pdageZyT3VDirSvStDnHRd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rPlVDdiVJzI0lVxujps1ZC2Zc2c/63548aYvH4emtNZAMQ2TVuTrDYNYdCnhvgunQXO1/jsXiOhfPcVE9mIUHFGwGh8JaBq5/93Y11zXLLB8KmvNB0CUP58AnWlDeJqzezS1Capg3XiNed6G3s7PWtVZMQtFCkuEYhCdeBkqxEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C2YqC761; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2YqC761"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3410c86070dso2120475a91.1
        for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 01:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406914; x=1765011714; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8NoibJSiNHVArlLUK5xHvDn/GmQ96N4NjNkgGx3wcU=;
        b=C2YqC761RRTtyWTafyi0fvX+mfVMRgUn1MtR+FG4FixD/fh5+R6Ni9FwZYRtEX4cjg
         z7dVEjRJhj1mHe2ky2gztcsKF5nBdhDjRDRanFQPe+LyMKnu/pPx1Vm0N+jCXm3QD0+5
         gYxIBcBsyn50pAx43SLabSp3hty5DNrWfi9DnGXy5O+UrCDi9s9OlGVgcJedsFWHHkMm
         d2R8G6w+w+97luYXy1Mgpp5+BaUYpJ6rjf6x/ulqReFNpqdwaHruFWWwyr7A3HTpxkPs
         1b0h2stj/O/03OT+KWq7ATTGyy8CAm9eiyaiukk24rSckIpbS301Y2PYIj292legny9q
         03VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406914; x=1765011714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t8NoibJSiNHVArlLUK5xHvDn/GmQ96N4NjNkgGx3wcU=;
        b=LPVQVefkZlMQTT2CTQiwKqApOcwajQcK6rp/d78ZuM0QQnurwH6093g9ZodpZJnLI8
         XCxPcH5dZOIaqI/OgtPbP5Z2Nk88qbdlDKCgRqSWGLNYNRLOvOEzgjLnCWy3pZeQRz4k
         xmoH+OgQ4lchCbyS0FYWnlwQZAOzmU2EkC9bnUPpODk4ojU/+1TPuaba665A8bKvgjls
         mAHI47hccpUpFnw1R8BE91rmwAwLkig4JZD6PPmDf02QyTcvCqADhwVmE5DxkU6qmGlo
         Yxi1i5BwUEmm6pVEu5DKv72fJWMpzQCYcoOspPjGHGN4gQTsCr/no+GCjGpsyyfTR2bB
         m/0g==
X-Forwarded-Encrypted: i=1; AJvYcCV02f+z1b9BhFHvdCEwhuNnc5KQYd8Ro8Hd7XxH2wNzzotQaGNOfJj7l3MXXponu+ENBwFkt7Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YynutlpLYLIntRygs/vyuroFLqUXuRrpmN6p498/Vemm+2lCIs8
	RrtZgsTAr1Cb9vUcYZbuV7R8xJUXOYKnGz/Cx/Onpfszr6XGBY+AIx4t
X-Gm-Gg: ASbGnctvliVA2sZC7U8gWwOXb0jQVb9bEUJJ8BjNVYacRXGiOlf8jjToBGX5LVq9Q00
	X91e+GiPm5opbX4NIt7/BzCj/lJvp92Gycb8E8ZKW7gRFv5Eqs/cB9nn0pHWRHnWpy5BWF9fycB
	2oUAxwGisdm7Sl0rbY5Gq/cB1qLzmvTVyynhkeZ8aCllVeczery97MA/dmRh7p6XWevwsYcK4qY
	lq/XIRfeB1NlMhtzwpYU3n4ApIs/kMNj2DFWICCEKQoVPxwfcaMeXGDgYk7CjBWuaNlR0LuySKs
	VY2Sr3y4e1qdjfdpYyErT/4cz/s6CnN1QtzskcM3C6+xYefChuJebQuFZvpXOIgSALrfLcyatip
	33+/lgivg+LwuHwcoETLyhIgZJEk9Rq/AyP1DGCMzROfHw9DWD0r+Dmu3qT3FMoptNnFv/QN5qf
	e5s0gfAyCP9iqp4msivFrmW5Iv7bbUjW0lLORI
X-Google-Smtp-Source: AGHT+IG2wahiB2PBWVfrDNRf7p52lLBDrzQQGimm/4V6gX8Dcmjw91342gxhdzWR3iErnl9Stx9Lzw==
X-Received: by 2002:a05:7022:3c84:b0:119:e569:f277 with SMTP id a92af1059eb24-11c9d864eddmr16724097c88.32.1764406914041;
        Sat, 29 Nov 2025 01:01:54 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:53 -0800 (PST)
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
Subject: [PATCH v3 4/9] block: export bio_chain_and_submit
Date: Sat, 29 Nov 2025 17:01:17 +0800
Message-Id: <20251129090122.2457896-5-zhangshida@kylinos.cn>
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

Export the bio_chain_and_submit function to make it available as a
common utility. This will allow replacing repetitive bio chaining
patterns found in multiple locations throughout the codebase.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index 097c1cd2054..7aa4a1d3672 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -368,6 +368,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new)
 	}
 	return new;
 }
+EXPORT_SYMBOL_GPL(bio_chain_and_submit);
 
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
-- 
2.34.1

