Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788EF2FBDFF
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318796; cv=none; b=cz6pP8GQinBKvaH9neWz+zP6Qpn61C8F9hchhmGTjfjMqVMhuo460d/cVxDHSqJDmnLqiso58N3LjISdaRqVCPHiNOcp29lTaT57gyzwTPL2odXSkVGg5F57RKIUoT/RHN2QK4oUiF2Brxe8BpQXb8Kpgx/xnc2kqyDisIgc4AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318796; c=relaxed/simple;
	bh=rZqecGhzp3NmtFjaYLSNOTM+/xsMiNIYX8VY+Bn+fL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QXIebt30746wvv85gxT1QYcI2ewYmiHZibov7RsDkxc6xAwTamaK/9DL+1Nm3OVNuhuXm6XHPAvrmnB+TzyE1lbPvgZiGxcyBET6KrcLXv1MU3Imvps+Ouyh4wFYLmVktZjzCKXnKfJV1e+O9MJxHA9g4MNLW3XPAO8xnqfQCqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bXY2A42u; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXY2A42u"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2956d816c10so18872925ad.1
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318794; x=1764923594; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=bXY2A42ud7FBQH3qIL8mEKigYEUsXDv08OcpyyfwlHCN+WwgpxwGjpFCzMGygZe/ci
         6WtbWfx7bw4V/CdvNKygCmnFmW0uDUSwWHiQCVnZO99G8gEfp/PwYDPCYh4nqhgkLJLF
         kptmi/fYwt8iswP3QtE1XQxlQ5PDBjH48rWXV0eFNbYz0tA3pBDzcfp26T8xkQEShzch
         LkCiokuVM7/ALhx2yhf7X6L3h4aveM9abHomprowb4yGsyi18IUKj8pCPUjM2r9bEQ1n
         dixORu8Gk7KfZjI8ovxCHWTEjZB94/q5Co7YowrrFktI93tFPni84ZaT8tO/pmzLTq8l
         dF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318794; x=1764923594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7vHs8yXaPj8mv/GRmviioQ8omsZI2Wqns1LW2Ikl6c=;
        b=uVkFOsDWCi0Gsi6ap5WDj8kxQfSKpHczJcSjQdu0ePZTbKtmdFFPoRIRKj3pBg+RNy
         ONspOTBpQlNRg9o7rIJ2WFzMG9Xa1+EmMP9IfRmFiKkcN2Lngq7NgaIIt+El6R3dvu0N
         fLdKDTjCvnvbeWHqr4s3XkrWNCWiL2PAfVTNTcV9Qq2dXFBmKmttTJMPuikjXPMLyBPV
         1nltWkZK6C32C80ppDMIsr2Imii/PXOpN6bHvz1rpiA4J7PZKwkdHdzofkNmeoW6qspw
         kHxR/Z8bt9OtrVgcauontVujcDYepBcg/C86HLN1JZel7hqACvGxCr4M3lvfZHOrJxnH
         7Iyg==
X-Forwarded-Encrypted: i=1; AJvYcCVLplHu5frZk8ToW3P70CZpMXzt1qDUfnAtO4G8E0eTPhWjo41ypq+2PqSfyeMAPVQ4TqemmwA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcapfdmVyJHN1H6VR7sneuDl4nhgBAL9btpX+SKQ1lGZQYcWvy
	gHopuOkDPR/e16jPDz/gSILP2qKu2MCtSJqvdtZT8z7/AnBqpDCgVtjw
X-Gm-Gg: ASbGnctDCvTMY/V5AFKgRHIfN84l0Wi3e9ePBTuB5DH8EdE4wQmcc2oQoOCYNvZrBxs
	vaGmMebd1iHkW2MruDibMghNsKJ8IBsn7F0bSWqKGdErAlRF6opInVLHH50H9X9nzLrSxhPO5IY
	hkgAu1BH0xIFPJJsG6CmKqmhLStqgHnre/ewPp2IMSquptThV0yeCM4rhylaBlSMqAnjNMqJ6UE
	toQms3I7KFfnK52cUT6RHf4gNa4K83Tqt/M2c1+ZFueb8ZHyqfWoXpPBGVuJwj341CPVGtRuhBF
	xu8nWsRuL+zNrrS1iiW78dF+o+DcmFOGHlddDOdGC7Oj9zMYzCWIKT1QoOKo3dpRbwJm5lKgCMS
	vVgyXT56IEiUHH+Ty8Gj6tek2VpPZI5tr4FVtvoJOsF1Ve4iFxaWsJyydSxsY3GN5Ta3KH56NSg
	Q1/6LMQoaX7g5zta3OVhHkjP6GIA==
X-Google-Smtp-Source: AGHT+IGKjtGYvF0Bq9aksrL28VuK/U2PkCtZPwPR3BXXqxprAsbvk/b9CT8/yxSPTU2xDb2fwzHbRg==
X-Received: by 2002:a05:7022:41:b0:11b:b1ce:277a with SMTP id a92af1059eb24-11c9d8482b1mr15434117c88.28.1764318793604;
        Fri, 28 Nov 2025 00:33:13 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:13 -0800 (PST)
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
Subject: [PATCH v2 07/12] xfs: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:14 +0800
Message-Id: <20251128083219.2332407-8-zhangshida@kylinos.cn>
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

