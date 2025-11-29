Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5902820D1
	for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406921; cv=none; b=oCXag9dFQjxHDNAGTLizllYkrfJn7V3UWBOO5f8pPnBJHiZ/UEMKCAcPA3THvwKd1cOASwApqMAOBEjBjo3C2+HXYME2Kgy/M7iVuolrFMPkv3uWrRIbNf6oBezMMpr+ls5El3aG5n2ay+M1M+2z/KITLyXSggkiHga06I/hFmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406921; c=relaxed/simple;
	bh=rZqecGhzp3NmtFjaYLSNOTM+/xsMiNIYX8VY+Bn+fL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DxAwLghx6zIxkDAgHudNKSWJBjci1gCfDOiX7AX8XDp3ohh2GRfI3SM4aT38tRgIvvE8LHLoZ00BBkqs2R2n85jPNaK6n2EmqpWUkiAy3ZuYjBW5rithcB1MQa98TQOXNpf/JkKng4/1IbTpdj81VlWFToVIF2WyKiTpxZaQ+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLVjtbWO; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLVjtbWO"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b6dd81e2d4so2441237b3a.0
        for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 01:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406919; x=1765011719; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=XLVjtbWONINt0EaUILQJJejxF+KjlAUjJY0U88Ja87nbAgztL6jG5NiivvCxrpFNB/
         sr+QE8iiFKgqoYEDHqCmMYX1GN243XbODcPpzEjxD/ZGlXc4ZvW0nX0BowuKjFk9SyTw
         jQGiRoD2Q6wz9wXdZ9tE/eCgQMWW1cqHC7daX60+7pJbU022ZSdA7RjaAqMWKSWQRhBs
         9lvSKBvuxjit+Dn+xpBciXPrnfeG4Cj0JKKGJESaRlKLKVr2z9lB01OrdtwjDbwJcipc
         HH2fuJeR6b8VyFc9jrlC/M/vshg2JXdfAUSlPHuRIr/u2zncY268FD95l1zKIwRaCjmQ
         +tLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406919; x=1765011719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=qPpmS/Spl1gTWcfxx86u1nQZhEWRQZ5FGFKZJ6RzpeDp4PbnP+7UYFSWhzw5jNsNYH
         VL14yVCtvwSKhdhR5HZffJfNrRY04/9kq3xmIQ7r5Ff1n6Sp81hoNmx1oC+kChAnXy4z
         v/eXAIIkuId2+ePe+a3PIAs27AegYwr/CmYAr7r1iQ98C//9J5SsRjllNajFCUO2WiEd
         qxmEOgg+raw8ljidc7gDnRl7h8fvCuRs+ytWO/S+duO6u0jzorkf2KbcE2F+wmDX5DjV
         t57l4IRQOyvQOcOwCA+laYEttNNaYD///hSm2ATMI11733IMbxCxW7JS5hITV4I/XhE/
         3ESg==
X-Forwarded-Encrypted: i=1; AJvYcCWsVdahoUebYG+fUUd2B9aEs1JsT5D8w9LHvknK4uxxPF/2y0X+7reHAKVYWD81jYJ8/4v7ID8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxiPPD4yskF36avq4BWKdBRmSQUyqh/oqmF4yg/zPg8J02ZvYjS
	JFVSfXPhG7XSPv+KOdthIGw+CJK4PAlmYepYTY5vozD+Q+86LqLESR+y
X-Gm-Gg: ASbGnct5f8mMCIJ1hCjCnXufNxadKxvV5mwQKok49SM8qV/ckUBQx2QgIGgcywiPsyu
	dsBklZACkTkVainnc20RGmEz09sbKnKRWTkDywRhSJeFPkYuBABFs6moJOitKA1TS5HepQKoBkW
	qNk0CW2CZgUgzGrDZlijGh3ngVUSMx0NvgUHn7FdZGlJrkggttBWD3u/6MvhSTnvwpVPj7799C8
	DcWKayoLCm9DL/V58mb9o31adOLmV+HwzTf1Lo20HMHiwfKo+pCmkv0wxmoTQaKtW329SYrxY53
	/vNmfEGjFw+23Y5+N/9BYLp/07bfyl5neXLcMKavsQBJnTSbC1JeRD4KY4/vrxVZeVhHuD/vDfk
	Qf/Mw13pesF6y20uzEb6meSXCx4ilQOI7T647aau9M/DmBWE1c8qHXplbUkCJzPsSrN0tvj4nsV
	71rZTv11RFgbqbS+C60yt5NqcMS8Bq3drbMMlw
X-Google-Smtp-Source: AGHT+IFdL+OyABUQodQSrM5NvvO0TZqbCFx6Z3c8afGQwuwppQB6YRBsN5vK+YoTkxr7MD5m+Dfwkw==
X-Received: by 2002:a05:7022:41:b0:11b:b1ce:277a with SMTP id a92af1059eb24-11c9d8482b1mr17983636c88.28.1764406918534;
        Sat, 29 Nov 2025 01:01:58 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:58 -0800 (PST)
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
Subject: [PATCH v3 5/9] xfs: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:18 +0800
Message-Id: <20251129090122.2457896-6-zhangshida@kylinos.cn>
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

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

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

