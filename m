Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA792F1FD3
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 08:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318781; cv=none; b=Zl4qFO0oGabmOI4d6rHDzAYTkqpUzqMiJqNaBs/jgNbjyoMaJdhaHY8yU0Gfo+FNXCRstyy7r+hlipYvRBpx9BSUc0T0U4pB3PmZdMDyz9fh5XlCnrdr2OT/+QLOwp1WF41RmHVLZCWsPeJxivj6ilVoS5HpcHBbImxqFjL6SjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318781; c=relaxed/simple;
	bh=XfGf+/4TH9UT7Q+DEbtJ2829MlGgMcgOkxUS/OB2JNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gl/Y5EUPV0w9RUyxHsfN4UxQPWvA0KS+uTOdtzX39wMbQl6sibZ/uzKAoZx5hKjqA51OGWPH51acEqIJlopwjXBOQw/8A0yrV9UpPDl+mSo/OnrPqVAqQGP0+BoTE86d2LwwPN7e6sKd22Pcqvmc4e6SwcuDxJ4GxixOedsuafU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AYLy3d6l; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AYLy3d6l"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7bb3092e4d7so1642320b3a.0
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 00:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318778; x=1764923578; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hgav++xVu99AZZZMA2bV1F+Nxhf+A3QsmIfb5iyDR/M=;
        b=AYLy3d6l8pqS9y3rV+T50YmF3ZamtXqnYS68ZgS3dl0vYkV/CGZa4/lLxEI03UkEI4
         1vfV8VEkShbVDBjLcc/zqPqzZchkVqVJF0AfPlosBWpYxvA183NsvMV/aMc8Tojv0bGE
         LvAP2qTNnqkCXP3LreqEty63ALemME0sNFZzUW1rdb6S5ukvjxPf6qIDB155lxsozTDR
         BxmLo05a74H4OtJ1gz7k0IFvKOXuJVIo+flLwWMxIBvckk6AB7X1bmkPYwPBwviZgfTH
         yzBCtuHbBiadaNzPk/FyZXXSHlznsoa6hyTAhoUnkq/ZEmaY3gymtfSq6aWW6ZJeNRiC
         HD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318778; x=1764923578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hgav++xVu99AZZZMA2bV1F+Nxhf+A3QsmIfb5iyDR/M=;
        b=qc3edCtTTCn9ALdkKeZR9sud59D/gDFFyNA8olDM9zIIZ3iMN4La8gaMx2XMklqAxa
         yPqmabdfwG2Mm0UGpkv6X3PiBl/E6bCnS6W9Nv/hKEF5BIubWmJiLYqXD12Ur4dCUuPZ
         NIM6O9ZGBXgNbjDUTqrCDSc/rGUrWTn8ebCfIviaJ4uskt2wQsHz3bMCc0ca7hyPYaTW
         PKL2KGM5KqUBeAdwL+i4Lx3ioIY7apgVENaBQXYcivV3m3bApk7pGUMm0eKnmiRRgXQ2
         83lMItbxw7O6j6xfhci94nW8xwgRn5n/5TpByNgOMB5YM57c8AY+t2mrCHOtRz986t0y
         cC5A==
X-Forwarded-Encrypted: i=1; AJvYcCVbKAY4cSihsT9TVeJ/wBD/cnNxXC5oYnI2ZaMaNpiMBc6im8ifKEJUSW37raoVZcAoUF30kh4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaFmLmdu/jZtt8He24nlSG4Tfg4FWCCTtMs/tjeMKpj7Og/6VH
	UxZkcUsRS9yrUilIoj2liRRqVYlDBR7JC3VlwOCAxrOW09r9nv6zkwWb
X-Gm-Gg: ASbGncuJyZs30ehVrr1s7a4fYSCpVOlvQoOiJezWlSxfIow3OmAtzpWjvjYybUvc9UH
	cN+zx6PZOx8sCaRkxsb2I2wtj5Kjb0ce/KvYgryXXQhbaA3qFgz046IL8SJzbgjHIGsvL3S0om6
	Yr9mtTyfvCK3McYFsI2zOG73EIVjcKuBUi8qWGXTuC4nPB/lhDTvj6Wizas+eVK3nDH8SRYD1tt
	uDQYgxEfMY/9ZEQ1ra26OWYDZ8nIWmePXA3Vll6D/BMpCsRowrOYxGN/jV6EP3PnbbFeIK/t4un
	qdMGnDNtV8uH9y/N4tdPgZgdSLeBM7inS71vvqXJ2aws+41p/qbcJQQbbq91hgE0JU+R2Kbc3zv
	3tyFBqq0mnyjjxYG1PePH/YPh/RB+fsCqdW1q0XPI8I1lPzXq6oC4huEKKOvfN2TQ+rhK+NmsiP
	6SU3X6MgvyQgUibwqwq0H1Djt77Q==
X-Google-Smtp-Source: AGHT+IHuO0sAEeNowy1+oe3IeEgaIYQcRN0FMbygDOiWMPQmdT1sBtyBJY7y0vyzVSrhuxE7eNWdhQ==
X-Received: by 2002:a05:7022:5f0c:b0:11b:88a7:e1b0 with SMTP id a92af1059eb24-11c9d8539f7mr12036129c88.26.1764318777892;
        Fri, 28 Nov 2025 00:32:57 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:57 -0800 (PST)
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
	starzhangzsd@gmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 04/12] block: prohibit calls to bio_chain_endio
Date: Fri, 28 Nov 2025 16:32:11 +0800
Message-Id: <20251128083219.2332407-5-zhangshida@kylinos.cn>
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

Now that all potential callers of bio_chain_endio have been
eliminated, completely prohibit any future calls to this function.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index aa43435c15f..2473a2c0d2f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -323,8 +323,13 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 	return parent;
 }
 
+/**
+ * This function should only be used as a flag and must never be called.
+ * If execution reaches here, it indicates a serious programming error.
+ */
 static void bio_chain_endio(struct bio *bio)
 {
+	BUG_ON(1);
 	bio_endio(bio);
 }
 
-- 
2.34.1

