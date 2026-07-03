Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE013D093E
	for <nvdimm@lists.linux.dev>; Fri,  3 Jul 2026 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783086955; cv=none; b=F2saRyDOW+8pAI5BP41V4mdEgDkSyzXKIhxOccTxZ1VmwWBbBMvtEOPB/8owEPBWXg9UqXFhdtDI2JSpyulKJXHm1fWxtKhf1sniuXouclrPeCOiBoQxqLqgpQj3qyu9tsTc8YRQu3CTx0Y4EXllf1HjYhN+oWxbUOlRWBrvmvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783086955; c=relaxed/simple;
	bh=c7QoemBplk762Mqi9bT4cCZDXxBt2XV+uhwPlOpiVgM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MpKDMYZiuNhAtncM63GQEU8/LD1nAT+dvjlHmDiYyS+JV41JgXUw92oRwZQw1V0U8bk0s7RsCp5/kKrlANVofBBlrP618squweqdt6wM1SpLpjFAmyKCHzrYJJk+rWyMEXlhoZ8ETrpcRRCZmHW1bHf6nXAyLd6NwWE86EoVnCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rTg9HJ+S; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTg9HJ+S"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-37fdee9276fso702499a91.3
        for <nvdimm@lists.linux.dev>; Fri, 03 Jul 2026 06:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783086953; x=1783691753; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BJMENLToTUHqriCNJNskYp7DzZMWsbfXaZUpesqSU/U=;
        b=rTg9HJ+ST5nhu24ODEeMMe7ZdJWih2SklcuIrMBF1AGC9EVpjDnKaOJsAJt7LHKgQc
         5At3NNc0BlmPZKzCFcMHNp13/P3y1AnDWsyA+ZD1vg5KHTu474x8YGZ1TXwqt5Wl7wO7
         NmOtdzHxQCAj7LvOqF3JBVZvRytmwofw7QCEUg+Z28rmau7juUwN3W5AjiMu3HaXvi8D
         JJv323Yvmdi9RDTfNuILNfhncR1/06IT8lx/RJ7nxZZcAzEXp48eNR5Hugkh1kq7VHsm
         JLbU4KgE7WyED5uFHbFoSC2z2QpIlWJbz5In3zxnUsz2BtrfZA8cwFsIAcWe9AWwScxe
         Yelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783086953; x=1783691753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJMENLToTUHqriCNJNskYp7DzZMWsbfXaZUpesqSU/U=;
        b=ZRxP1gkhzQzUbF3H0CbhxPD7huvUacKq4x+FZBLh6CG4YivyuvJzShw49g4PpngE0D
         kyW9V/c8gn/DxLgIWNeg6B84JzJyNB/t5Zj/ldo24ZWEI2ycVldh/9i2iQNqiwNl2wj5
         mRACIJGloPyZMyGwNhLL55AadirdWDkEaxPI+J16Ivsn7M/ao0HQs4kE3mOK+KQaqWPI
         soE55qT+03ymdzfRpGjZO53lSAoWY2n+PTvRL1PHJoFMmG4IOrG9IcTyGM1vpiQY1MqP
         rb4HHj3x0FblI+58ZoXuubimlBTUB7KkMpifuZqEsm1AVEYKbWmrgRGqHxYdHlL/tsLX
         aIBA==
X-Gm-Message-State: AOJu0YwO6+e8J6bYcaQlwZPXJmJJov3/PXhhE0Ar5/C0e89XbS0ugA37
	XDtJBeL0Ng7ommrHofsTXXOZdG0erCoG4MAKjkrekLz+1Y16OUiTa9v/
X-Gm-Gg: AfdE7ckwcFAaQ/CPsHsf2JYZ4etaAZCv+iA34h98EZfZyOkI0sa85j4Cw80PHS0wXnl
	cGuyweS2VHw8T7aFfShTn+I6Y6k01dWug2jQj3OJzqWJWTIP4jxZzDfo6iJUsiqWmsOmFg4SuDa
	umL4/L4rZaPla5hlzuPfkFukTK4CkpH7kh0mxphBYh0SFIff+6284zbYTIRxU1MWTqfqV8QWgKg
	3L8beJiQLFOX69dEYTiAhFCc+sSvDaBRvLgwGt/kYskQwZYjPzd+vvZBULV2kBUjs16Xxx4F1pK
	3cFlNC2Qzj8/oKaQSHIoWYZTQ755lshrOB+RmUpbRupF/Af13o7D9rlZQkLS/Uhgp3d+0DDJ6sN
	cnuFc6dWEzqfLmgo9GjsEoGS4IFhzowjLd+Bgfpyx2JXwtN6UT+XdCW86/UXn8CBmUTQh3kjx9J
	WH1hhd0e3DHw==
X-Received: by 2002:a17:90a:e7cd:b0:37f:133a:3e02 with SMTP id 98e67ed59e1d1-380ba74883fmr10291045a91.0.1783086953150;
        Fri, 03 Jul 2026 06:55:53 -0700 (PDT)
Received: from ubuntu.. ([2405:201:8026:213e:4288:f1d2:acae:80f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb80f5csm30995649eec.15.2026.07.03.06.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 06:55:52 -0700 (PDT)
From: mdshahid03@gmail.com
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mohammad Shahid <mdshahid03@gmail.com>
Subject: [PATCH] nvdimm: ndtest: remove redundant NULL check before vfree()
Date: Fri,  3 Jul 2026 19:25:13 +0530
Message-ID: <20260703135513.75840-1-mdshahid03@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mohammad Shahid <mdshahid03@gmail.com>

vfree() safely handles NULL pointers, so the explicit NULL check
before calling vfree() is unnecessary.

This issue was reported by ifnullfree.cocci.

Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
---
 tools/testing/nvdimm/test/ndtest.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 8e3b6be53839..2051ad5d4882 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -376,8 +376,7 @@ static void *ndtest_alloc_resource(struct ndtest_priv *p, size_t size,
 buf_err:
 	if (__dma && size >= DIMM_SIZE)
 		gen_pool_free(ndtest_pool, __dma, size);
-	if (buf)
-		vfree(buf);
+	vfree(buf);
 	kfree(res);
 
 	return NULL;
-- 
2.43.0

