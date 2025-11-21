Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616CE33AD97
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713093; cv=none; b=lCVeAwSRNS8hDHryJ/8NWdSWTLRuTrNlIfZFPL+6qjW+FaCSYsJAjJaqnLNRhCU9J/JuE9QU3YoaXSaf5oyg88rbCkw1+/5o3TwBftPh5OqUw7vDuOlxiHtwquKjzFeuMycczF5XGEkTBVA7OfqpSZCFcuBrGHLBuQPQ8s2A4TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713093; c=relaxed/simple;
	bh=+7tflVaH8x7L3VJvig23+lCVNVSwvcR4NvQ6QZjXrp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B23dmNK/a1XZZb7+i9wMoYhKggNQFhf4N10WlzvgJJYTd/d7jjnvnLMg665WlEFSRpJVI2oNcEcqu1x4Y2Nh+SG9Zx5aVFzOWtNYjr7OyVKy1A62rdMt39SsNXovW+NdOicARu1AKEPZMpT+r2F5z1KA6gIWB/6FTdf4T8ufcQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVRCLXZk; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVRCLXZk"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so2199379b3a.2
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713089; x=1764317889; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HsO4Hd5ROz+D0bqFKvcezOn2Jkcskeai3TxWpcHV0vk=;
        b=eVRCLXZkSwgPPjKI3iy1yR8NQJeSEzSkjRJjLCFG1By7Y6Q0vU6tDNA+jeGvLAlq/I
         rhExDE4kCa/F8dg1GWw3CmDvenmMqk1Sh9FjYHQA93G1n8p7Qo+iZCLtV/9Gkpn9XISF
         oncMH2984k75cw+pBqW7oTObmZ7ijjIfFJbqMXSteNuT0YZ7QWKGbFh3WjUzxI3Aigw2
         yTDatYN2WPeZuKpJFEwFAS2wWy6RZHRaieN5AOYOKtRekg+Vdu9LIipErNooq/gGsr4t
         gLUhvRdYkzo5/c+5gbKB2pIcgAj7dxvdVRYnbYDBncB7qGENS4NHGGjJX4N1f/RI8850
         OBqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713089; x=1764317889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HsO4Hd5ROz+D0bqFKvcezOn2Jkcskeai3TxWpcHV0vk=;
        b=qihbx1Gn9xU6oAKYuPiza6GX7iGjNjy/Ur9z80MMpowy3SwgQLyZDyf/Vne1sYmSac
         ZlcjOQkEbCkbA1CR8wE3y+jQqD0FcEBKe2LKqGRH3+yakTpg9eKAnU5gl/msTihq5PBB
         PeZs56PCwC/4HBLochSamFLEaII1GRKaouknIR3ZMxMPmhVt4JIOHP6Zt1ioFByc6LmA
         lwoVg3GY2jAQtGjKKHwMvrcX/jyvgpDEdWngGvXU5ZsIgkJ5wTJYtQYCpsaWPyOPjYfg
         piF+5E9oRju553BphoJFmLScAbt/cPOzXZLhL220mkE5z1BAOihutRONL2xBgIjOgxqJ
         7RXg==
X-Forwarded-Encrypted: i=1; AJvYcCXSuuDXBBj3+FxFtOK6lkQnZ3MHLAXKjeAYEWFCChfX8qyM9oXgSkP2kVrXLX91AoKHboJna6I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSaRe+p+tRA8hI3HkRaC5qI97ap/tBmufnWCbuP4D77CFRXXMp
	i1gwlGsMb8716rQKck4vcHFFIiFFoxx2RW+wLO8A3NrqDqXoYitjZPty
X-Gm-Gg: ASbGncuNFWBaweekbikbVyLgwpVLkbqX+YvbemxH9LacofSd0/mWC7et4wOK8E62mRK
	1AfkbQ421IYgkLDNWBbfESnrKeDDcLNdSOlO7BNLpjvPiFhPEwIZZA+/V4RS9z8JExqQAuRp6+1
	LlqBjx5jdHcmvoh2xqG5FerIbKEZaAm+vwR9y9pQxGd8pbWFNnoP/Mz0l5HjzBnIUDHCyMlRneD
	2cjd4vZur3p1vyfa2ZkSKex2qjrH1/+cnGKnSejbhWhdsGmhZijjtUwWI44VZZ7GVP7t0pbu34z
	tqufL8kd0MmcYziciDmr89ZUE1W2CbeR2oz5dkYV0qWqHCe4nHj1DTIsDfRw4FIA88gHS994Uxg
	dpIR8BEZhl54n5DerX+DxnIJUBHxBqZvhO4wNfuuYJHDUF9uIhVcgx07qeZUZCQvqwMNfEpbFNq
	UwpbXEGNiR4mlLkeaYcW+n9Mt3ow==
X-Google-Smtp-Source: AGHT+IFqeRBYEjCaG+tIpPdWA+qVKSXVzOiqtjGknDBSdNDUFTnY7ogPNjlccPCj95LHEh6lRlusYg==
X-Received: by 2002:a05:7022:6b97:b0:119:e569:fb9b with SMTP id a92af1059eb24-11c9d708d34mr570234c88.10.1763713089300;
        Fri, 21 Nov 2025 00:18:09 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:09 -0800 (PST)
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
Subject: [PATCH 1/9] block: fix data loss and stale date exposure problems during append write
Date: Fri, 21 Nov 2025 16:17:40 +0800
Message-Id: <20251121081748.1443507-2-zhangshida@kylinos.cn>
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

