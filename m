Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E2133D6F4
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713104; cv=none; b=BkiWXr112pNXY8rqYWGZg8jSXHOAiNEYpIOTXiSlW3x9JKufMvZa83a2mXD3EtviABghU5VvUGKX5+FFB7H1eWG+ah2pBcayqQ4UrZOHQTNTxgiqPGZk+fFXYbbqsDNTq90xFJ0x4yG8HY1xHCOoMrEii+vDfal5ylfTcMNQ/qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713104; c=relaxed/simple;
	bh=GyhI/g6BT2jDyrnrno9j5u6Y8zL8PZ/BqiyLx603u+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZFo9SxjNdCh/XcaEv+X9/UhWdAJgipX5bPvUvCYnq2y9ngNSXQ3yVDcz/gglkd3uWnFz3c7eHAiGDy885avnxgxr/bASypISSrKHEPWRsigRRCDlr8rP5PTidPdqx4EDdJ3oJ1t5Hte9aEEXLNrn5zHXBeNun9iGoCMdSnc7LMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LSXLmb2T; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LSXLmb2T"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-11b6bc976d6so2581317c88.0
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713101; x=1764317901; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KXggH0+b8/rP3aYBPWiHo2+gkYlGyUfzMd+zPzEVv4o=;
        b=LSXLmb2TII/vBPRbQW1OoRGloQwPGNXm59LGFOVFRkqPXcEf3rAnWErfiZOsrWJGLa
         RJr8JV7qnk/x2qHGc6bXHW/0d7ykKHgiEURdqB1rXVRGZWQrV370ixHhkjMFc9fkmSYN
         Bf0ZJIYfvd0sOxilJPymkiS5NbNIazYjFO584C6TilYbuiufku94rPCSkc1etLyMMlwf
         rkvwDYcJlHuIcs8KTNfOzoA9ULAS0wszn4bIHSWxws+pRTuRCq0rHIAhs8GxoGAPlshL
         Pp38FLNLaO6/T2jDDitFrwiUUP/B6efP5HjCIt24H9dquU86fKzt4y4X761iIY9jr4+U
         uB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713101; x=1764317901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KXggH0+b8/rP3aYBPWiHo2+gkYlGyUfzMd+zPzEVv4o=;
        b=WXNFGRfWN6dE5yblbPnIyN2U7Ujq6xeioc3O1yfR5Pa591vje6CDbpL9Nz6b3yaBlL
         m6Z4cjw1KHZ8UuWIGF0WL+ENIXVjBdv+pXBgZ1h2C2kdEsYGuCAWBjxeWjoxGNtySzhC
         6K7j/Ee1HzhhWNqgOjBPbBEuThKUIKS7+g4uiLf6NBk+67nhUVMNU5V+lRUfy54swFWW
         kRYoERVgHnMLS09F1TsOWA7d5JOidvRfxHF0uNNpiEicbIWVHJiPub+ulWhBbRrmMmHw
         gRtZLh3oA78psF8xpTdchyPCaXOAdvRfO0VIHwTVXODEcGc6ZXP4Cqd19ct4Wu0KbAzK
         g2Sw==
X-Forwarded-Encrypted: i=1; AJvYcCXDhVvEPQD2iaQK9L12C3REnWIVUfskJeD+2Q/YIMZFxWm6+GL0msPBR72dzTL8kajPbBl+TUY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxiwfAPtk8zSyAvoNdKKb4J/MYIw0w4UJ+EZfU9V6U5bZcWjFX
	SAdaodwdVNSCJjOF4UnBr93/mcC+bUvnHe1/MyqzN6CfR8wpXyn1KiFl
X-Gm-Gg: ASbGncsCJEh1v/w9CsU8Oeh/UZpHIUjO2kPkiDAW7ogmkgQTO3fK9huahiUotndvsnp
	asBqFIbj8RegcVGNDdoGCP4BcK8tgVTasoe6aWmfcpLZKVf50pgIbMbDFtFRTFafrW5T+BBu3Ab
	P3H5Aui2yjClj3XuVAVodtUPII8k/8pZm0HLWdxh4sIrOOfaNehvcwEMGQl4XZcd+ihyR7uM8Y3
	oclyJB6p8P3uFev71Rtq6OX+rRDwp6ssnkBsecENhB+SlGiJoFTM7OQj4GA/RWbtxzfWQYbcCT1
	HdXeI0sN57HjLwMC/bta/GlSl4rOwH19WR7XThqa112VeudyDSkwwd1Mcu2ecbth9md1e07D9zc
	mDRyzppBHQP38GETO60jh6XeSTaqSbV/MEf2cwaFUKYHrOosA4vL8OJWbIvmZyKtvZc5UP2PdlK
	a9vNj2knW1mIf6bm6LW+0UeM6aJXwcsxkyxWe2
X-Google-Smtp-Source: AGHT+IEZ79TJZoTtjlwZLisOIZ0dGAr2lEGHTXQQoCt+6eH8PV20aIRNYUKQ7CDTkbiFuInj7IJvjw==
X-Received: by 2002:a05:7022:1e14:b0:119:e569:f86d with SMTP id a92af1059eb24-11c9ca96a9cmr324319c88.10.1763713101474;
        Fri, 21 Nov 2025 00:18:21 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:21 -0800 (PST)
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
Subject: [PATCH 5/9] block: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:44 +0800
Message-Id: <20251121081748.1443507-6-zhangshida@kylinos.cn>
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
 fs/squashfs/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index a05e3793f93..5818e473255 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -126,8 +126,7 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 			if (bio) {
 				bio_trim(bio, start_idx * PAGE_SECTORS,
 					 (end_idx - start_idx) * PAGE_SECTORS);
-				bio_chain(bio, new);
-				submit_bio(bio);
+				bio_chain_and_submit(bio, new);
 			}
 
 			bio = new;
-- 
2.34.1

