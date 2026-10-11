Received: from mail-dy2-f6.google.com (mail-dy2-f6.google.com [74.125.229.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CE344A3EF
	for <nvdimm@lists.linux.dev>; Sun, 11 Oct 2026 13:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791724825; cv=none; b=Kt1+qNLJ1rQ4iAZnmk5O2fb4j/EnwBjtbB/muHQh/bjhzbulGkpdhJ+F370hdl9vlfiY10Rgf7WeoTpSWTNzumz9hY7YC3Wfjl83Xn24TCv0cFjnhaPfjuZx+qaROQpJydVqEr4buvoICAi/mWPFwVP4MvXArlTMBJthhJ10cno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791724825; c=relaxed/simple;
	bh=uXYPY6h1yD2YP8cgMDGftsU7ylCzXryuv3bVUW6VD3E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mZ1w/CLjMovVNv0HOFh8trr7GFiUDvs9kHDe5UoGmO0ktG89Z0pEeCJvVjXJlrzlM08Ji3qqt1CdMACsySXT9mXEF9B19Zf7rakyw0vZ+NI1bBKtxYt5vUTlCa1X9h20mQy17z9+NRH9RGjd8kezhIxsnieXfgMw676c2EmrZVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDuBP51X; arc=none smtp.client-ip=74.125.229.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDuBP51X"
Received: by mail-dy2-f6.google.com with SMTP id 5a478bee46e88-3537f63c9e6so609369eec.1
        for <nvdimm@lists.linux.dev>; Sun, 11 Oct 2026 06:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791724823; x=1792329623; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RC5wNxG5OvZ7QX4c7CG14p2PybaZXqw3gD9axjHB3VU=;
        b=CDuBP51XmSnRkvEg8NbJA/JTY2pZp72ms0Gj6bZOFCMfaprMaLf2LGt/FAHWZVgHqg
         tDZ2JgsmbT5n/1umrYipncsTa+day1eT9wPK+oOmJaKWkwaoi0dSQ0vUvAHUtpQ2WTRY
         AuZ4Y1+g8pKj5RMR0BTPTOTtaQ/5RHoO573I0K9O8m9cbiU2PCaFnmIRpFDAo1Uesyfu
         zUaggGMDmrxwlCObdFm+n1SjTqVtyD5Mrlb0mIoBfTvGPyx44XAU1l5wI8A8/LvJnVCV
         VQGu/FGet3EikIhTIdty0M7y74sGzBvR762l85mF8/OFkbWfdT7S0NGfmCWdOlVtkeSM
         u4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791724823; x=1792329623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RC5wNxG5OvZ7QX4c7CG14p2PybaZXqw3gD9axjHB3VU=;
        b=wSZw/WZkz9dTgv+o08CTN5uYHO0UBCVRIbKHScEFSx0m2A5TOY042B6qS5sjJBo6p4
         CGz1tot7IuuBs9p+vx9PIXOXCJ7xoa5brMCjemPDEr/XuN3+BBFnZp6zo1r6VIBM4n4D
         9w/ijgL3k/jRHEoiCls26szVXX9axYsH3a1CoAUHYJ5DUOl3mM5IjvaxaY+njdxuK6ql
         GMyvDCuUt/DyRrRrdyL7Y4w9ZDFrdZLM/Sr7pGbGBrFXn63mu0fKa7Fw73Ii7tLswzrN
         PUgF5ergOHWvmrzBemrEUn1SGun/TlbQpGnUV0ylz15NzXGNHqdrkqA63/pZ8W6vnrZV
         bWqA==
X-Forwarded-Encrypted: i=1; AKwUvBwtWJPbKgh8Zwyzv0fd8Q0nEHB0w6sHyh6IjHhgvJlOpJ0r/cJPJ1awaOIpQCwA0jwJ1DrLUq0=@lists.linux.dev
X-Gm-Message-State: AFq9FYLgWGfnvwGUjxviaI6fEsIaA8hXbN4s7H7Pkk0lcflLQCWdlg9Y
	82jNpYw+GNxAclHgZIGd/CU2YNzKjVk6IzjgFvU86hiMoiJSfGTslXhe
X-Gm-Gg: AYBFou3FKs040hJKGwcE9TMRhBuhbn7Dne8rOg2za3biNk2UDBbcKIddKVAKD3Wptxc
	paf24X1P/KJCPl2/ssTXvUJA26zZ+S9iOeVI+5xyaEeJ6TTB8fY7ekx0GBfg8GSq7hFMTo+jiMq
	fT5a/u62psEkUvqgZ+RjWKZJdbT38fxYTG5E+7ktwWxzxz8YfDxpCMxpLtOCJka5oTfxAFKFl4h
	JTSVv9E/pFWPtX2TjdAm0/K2xA7M5Rxhnv+UX+SGuGAb/ewZrD4mzqm+dGWKDLzc1YMwOzQ5ktO
	Up9n38qNYyJXrGZsVWRB0zcIhL+83wJAVefmejFksKC6xFfg/5W3dzTWXVgOu/q7FDuHmBRuFzD
	Py7jGHlMYt3MGQoKU15sDbKajkS3Fu6+/+9zSrqEPQ6lz+S7QiBiA0v7S8wYQT25Bi1pc0rsbF1
	Uxs5m4do2VDBYa6Z5rxyhJyQeQUhzM2GZclWTnLG3EBpJjd0sYg2OMl8ASzwUGpFVcIdYzbxqrg
	d6AbRsqyI/Xh140xUYEK5OZigEboNzthceSrqlBZ3NwZgGjPqivokzd6NKDQgJrQi9QOw==
X-Received: by 2002:a05:7022:1605:b0:151:94a6:6f5f with SMTP id a92af1059eb24-16a5fc917b4mr10950183c88.10.1791724823038;
        Sun, 11 Oct 2026 06:20:23 -0700 (PDT)
Received: from localhost (ec2-18-143-158-86.ap-southeast-1.compute.amazonaws.com. [18.143.158.86])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a1becb11sm20136059c88.4.2026.10.11.06.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 06:20:22 -0700 (PDT)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev (open list:DEVICE DIRECT ACCESS (DAX)),
	linux-cxl@vger.kernel.org (open list:DEVICE DIRECT ACCESS (DAX))
Subject: [PATCH] dax: fix dax_core_init error return code
Date: Sun, 11 Oct 2026 21:20:17 +0800
Message-Id: <20261011132017.31131-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

dax_core_init() mistakenly returns 0 on error paths. Change the
error return to use rc so the actual error code is propagated
to the caller.

Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---
 drivers/dax/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 45f84b0eb909..0f35f65363ee 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -723,7 +723,7 @@ static int __init dax_core_init(void)
 
 	rc = dax_fs_init();
 	if (rc)
-		return rc;
+		goto err_fs;
 
 	rc = alloc_chrdev_region(&dax_devt, 0, MINORMASK+1, "dax");
 	if (rc)
@@ -738,7 +738,8 @@ static int __init dax_core_init(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
-	return 0;
+err_fs:
+	return rc;
 }
 
 static void __exit dax_core_exit(void)
-- 
2.34.1

