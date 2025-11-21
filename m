Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD98340A49
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 08:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713116; cv=none; b=r93Scpvg2RaOlyK2tO/FJ5ALKLp274eqKDVa18tKLBCYo6K8tIUlwBWTUV9B1msTdzM36hDBsGBy0VSAIqFu+ourGFRdxPJIBV7puEiAeFCc4oakV2F46LTsQnVwKhhjLf3gfHGqrlZdYfY9deYdMaw6tdqVSTsiwsw2fDDr0kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713116; c=relaxed/simple;
	bh=EqzE5eAUrOzw5wQ1NpDCM3tWSo+9dLaAmuNQNwJKJDw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OYP2K94VWZtrnuyacn409sAEe4j7OfgM77PTtrTOpxmH3RYMLP5HVb7zjMea7NPCDhoGEppWOn85L2mNET5O1lOPpx2sW3mJscazVle3Cn33yE+xqGlEcAGYRfQMrESxyPAYg9pRrOT9ETvDM+37gibpvYBE4Tq9sNXAPJOPkaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G25UJC0/; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G25UJC0/"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b55517e74e3so1284674a12.2
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 00:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713114; x=1764317914; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yt1oIqGxOTrmRU0wY5Kf2stOafiOCOsnZEA0d2AzsC4=;
        b=G25UJC0//DH7ctuSypLo6dh4zliaOaRLsJKbJziaiExnxZGaz2DTbSj4+M/sPm5PUd
         AgeOExl78tR9vvnst6SQiasUWbqpH5eyN8Vqj07kcP4cWNCWL2A+WD8O4SX4ZhwDomOO
         hPaHyIRVXp9xbhedIS4IQ6JMgDucCD2i73IUBvXxt34qvmqe4FvlFVvzcED5T3wNFZxC
         4bsdQB/HiiXup7XogK5HNeQ3pRRe8j80tydIVI7CkVCZyKrrZlaB5hhKQD/UTB3Et+fh
         HwBhXnmPdeE/ftCepDE+E4ork90JoSnA6tkhI0vIcLoxc++AAvNS8Gl0CMyd0yyHW/DF
         uRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713114; x=1764317914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yt1oIqGxOTrmRU0wY5Kf2stOafiOCOsnZEA0d2AzsC4=;
        b=PDgHkh14sWJxa2hXGw2h/ME8QHlwERJkWYYkPEiFizG5QIOLMlmmbBPnA/HHkOAiPR
         s/6RIdF+riwLWcWQlrbxoIRWm8HmpFP70ExpdkbklCITi+VzxytQispp2KODqrIoa9gM
         /Aw36CAanjLxzxbTaincl9Zev1JwkvvLIbG4YV54mUxb1hXyHL3VLqR4o+XjSc9L2qr2
         635+rEDNbeYAj/mMdwXSBBMltm5u9sJUHc7M7RDTyhz7XwJDFcTZT5tC/4InUgyv5v3r
         7LQxtmgBbe8HxsIKEJ89CBfu2zOeejRNCTnfCelTD8qcjgMBMJCWyP2/uIjMmuZ25D6K
         xc9Q==
X-Forwarded-Encrypted: i=1; AJvYcCU4TpACoiKIvsUytmoUvqfPablUNAvBlCinZ69nxbjHWTakjzIfbX/psmWajtGV+Nab5es2WLc=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywaiqgwn1dbC5SqWkgabiZ6cwWYYFe08P3DUHxzetuFPIP9QOgo
	3amWn6K2M+ZNYejWztXC5/EtmFu6aFuH8+BLrNgXbIsqiP/QHzR3Xeyg
X-Gm-Gg: ASbGncvwr4OfTf+dW0rZmYcGGr86DUSyiEGrN37I2UT4ykr3wf2MM3MWAVmSJdebqR/
	b1DJitvUjtpAnXCkOMi8TdhgdRT7yAwGcR9xMStVwiid/IDaAmJrwgLWc3WU4W9UUCDaAVClEOo
	ZECEigy6lz91CCX0SpCRjMeID2dd7xeNuL1awUQZH6D8KY41IZtkg5X+lCFXkUv++JjIBG3QX3f
	zvFqbYgnY6xoXJxtiAS4/Je8i4gKyb9m1nuePVSGP2G0EKTJcL+GgOT1DdfRMs/sd8oSpNetagT
	5zs6yI5TnwOq2kxeIy2aqAhmmWotLX42ANkB0S7Xp5Ui3j4nKlcUr1gcfCHXPlsc8B6Zt7NeizZ
	OMSPuJr5gTjywbc3l0HiPTdEkz2owzkwD3HKSFOekrC+XQOXJPTO9Lihac8Ou7Vxm097se/8SXP
	DjRcpFfvnOfuDKIJMWVJ65g4CQUl3yT9GYBXFe
X-Google-Smtp-Source: AGHT+IGjQz6D1HhxF/O38ExwwmQdYex30Wle92q1+zy1HDlDdyzSrgD/kMDXWQtHpmE2DiVpd2L90Q==
X-Received: by 2002:a05:7300:238e:b0:2a4:3593:c7c9 with SMTP id 5a478bee46e88-2a7194d07b7mr663198eec.9.1763713114130;
        Fri, 21 Nov 2025 00:18:34 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:33 -0800 (PST)
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
Subject: [PATCH 9/9] nvdimm: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:48 +0800
Message-Id: <20251121081748.1443507-10-zhangshida@kylinos.cn>
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
 drivers/nvdimm/nd_virtio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa2..e6ec7ceee9b 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -122,8 +122,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 			return -ENOMEM;
 		bio_clone_blkg_association(child, bio);
 		child->bi_iter.bi_sector = -1;
-		bio_chain(child, bio);
-		submit_bio(child);
+		bio_chain_and_submit(child, bio);
 		return 0;
 	}
 	if (virtio_pmem_flush(nd_region))
-- 
2.34.1

