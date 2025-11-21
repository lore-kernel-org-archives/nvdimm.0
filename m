Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E3C33FE00
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713113; cv=none; b=suWQhLhZgM13/oG6Cr/O5MMlYuAuJiLxY4V/fUqmwUXFtSRHVOFw4kUhVXjPDH4zuwpsVC7i4utc/sfRLVpTIApm1vUgVgq+K/MPIQbahgUyharB+IZTC2wp+qMd3h9mIyrYWgDCL51czdUuEOwYB3Lw6I1X/AnXBZ80xk9GGGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713113; c=relaxed/simple;
	bh=a7LSL2iwilO1NB088738btanTUaCE2U990irg/c2KQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VTEK8MoIsD3Hm2ITOlICIWZ27XMWCfMeadWhRYEykslN9G5y1YIKHxvt9c08+7COOcE2fjAUGwM8SIxkUuQVMD3jH0VExM5uMAcfoloe01V7xb5zBdHK+UW8eUDUnp3xlNStX3KHsLy1KSqaHntpExWvOGcVL9dMoWSWQbD/PvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HG1khWBk; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HG1khWBk"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-bc09b3d3afeso989126a12.0
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713111; x=1764317911; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IqJVIkHeBy2QrJ/910C594A/mOhcsYvy9xKzTt/nypY=;
        b=HG1khWBk5LXl53K5NDYrTW8VCTVBPEir7KvA5lKQ7Ee7yU4g1MAsQYyXZ9OcjuxEIa
         73z08097waazSMlgyDUpPNvt3u+aCJAOhutIDFm1Ltv82Dt7DH8Gf6YIS1KyojmqTiag
         Nw7uRMOgZXXg759DKRL1izLmL64IIAO8Q3cVFHStJn18Jbe1hAYE7QHTix8BcKlr8UP3
         zyII4M+5GmKkEwqrbdu0aUF2YfTzaNlVuXXNF5zBMj/TPavDaHU41gaQJsu4YT6ekXp2
         H542hg/KeRt1OWU9ACiGazw9/sbhnJ3wcqJxYWiYJhnfELIyKZ8tIV4SPQKUvMlmYLIq
         k01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713111; x=1764317911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IqJVIkHeBy2QrJ/910C594A/mOhcsYvy9xKzTt/nypY=;
        b=EKshu/coVoDWl2CzGUae5G+F0oUZpbx9rDl8cVgsbfDnlmR/dH5AK8RZwlINA2M8pI
         IzsGzgCaA1M3I7KHeV3rrZC4znUz+XqQEXW4UVi50niObX3zHHFJr3BlVug9BBpF0nmN
         JSJ8bJtpl6AaRpY7OdmgMTHKvvkim0Kh2eSNfn3JVL6k2n8wkUQUd4Ldo8M4fiO50H4x
         1cz7gJOvJzgN0Xq4INTHE2mRmmU4U2EslUPDkMxSBdNwQJBAZYOJ18QwvMNeFRKCPR37
         Smnd5FiAZwmXPfJEej2zXf0ldgxqdIfuWNIjhqINlaOtgRFZIZHo1kTFqSKr3o2JN14K
         1Ghg==
X-Forwarded-Encrypted: i=1; AJvYcCW2fsGG25i9NyrSNuJFP8Is6rfdDDPu5Mcs9YNPs5X7mxEoQCXUiEyS8JveQrLcGMQNX8LGvxo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDK6n/sKbN8ShyT8dZfTcQfP8km0PmUskS0fSoV3cv04jsdx4C
	ZtUqPAZorEFINGdwexkZuZtNjXQE0Cx7JXK6kG/YnY/RIqz2RxV/VkVM
X-Gm-Gg: ASbGncvU9dbXaNl1IF4ZV1KdYHML2tWUPQVhp8TTJZRfrNlKT1Dmhj2iQ26ysjFNDPi
	kRGJMHLczJ810wvXa2Kj4t5527tOOdu6vnu6M+tmWBIDpWuoEh+FU5BDhwmW0pY05khVrKY/00T
	abtmSx/1hWYPejhBEHOyiTj6xAEMnRNuinFr5AjLtYNkdt2kMCIdvpjy9L7X3A8FuE4jqDxpNi+
	Qd849NRYdwzsk22qt6mfsubbTSoTfegd0mpcktQHTSJPfp2L7m2xUdg5gJpfIxkg1CjF3pfP2QH
	0zsHKC1JyFnm+7xyCroA/idhzvXjvHbev676sqM/Qd+ncN9i61vuyjHyx8dwQ5JO4C+6jqsUfky
	kcOiFrSNdNOcYtt84uWgXIT4A6jZeLf3HSOiPrRkEMYchL7FDu07aGXF4sdumMVBDnV6GBzBbAa
	2ZJ4sfYkyMY8ty4QmHBLIEEdlxzw==
X-Google-Smtp-Source: AGHT+IFWgtWuJbeRkMQREJ+GB1+CIl1owO0q1AKLfdba/kSV5Dme/s+uE/AHBWMGMV79yRIBfle0AA==
X-Received: by 2002:a05:7022:628d:b0:11b:9386:8257 with SMTP id a92af1059eb24-11c9d87a334mr448835c88.44.1763713110905;
        Fri, 21 Nov 2025 00:18:30 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:30 -0800 (PST)
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
Subject: [PATCH 8/9] nvmet: fix the potential bug and use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:47 +0800
Message-Id: <20251121081748.1443507-9-zhangshida@kylinos.cn>
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

the prev and new may be in the wrong position...

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

