Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A8737E304
	for <nvdimm@lists.linux.dev>; Mon, 24 Aug 2026 06:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787551296; cv=none; b=ON2dVLEs5ElVunTiiWUzlFv2WMbBmUxxhreFnX5AC0DkAOX+5To+eHnNaEoGgwWkrXVHuD2tFffIbgh4NR/kT6o0IEHJSQfCDFuAnvQXC0sLWskNCUmNWJAL1e974bGzf2mGU677LPYbFtRlm9FEWyrps9B5p1eARgS6dcKygww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787551296; c=relaxed/simple;
	bh=yAExTnD/6sHbPyBlq8UQCphOUIBnBA4uhXlnhV32iCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DO9V71TEVv/VRkEzaV/s+SQA0SNntEb8i0KYOAt9pmAD58VXwmHTUboKHexxAChGIG46nkjEctO8iwEDQUQA0b5AjhIdHPot3Aivg1R/L6MDufsSR3bBFRBS6PWGf8vBoYBSLOYbGCo2n+6TfwhXUG9cmNYCwaq7NccjnqSUizU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YkjbFcD6; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkjbFcD6"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7ee125ec926so3359313a34.2
        for <nvdimm@lists.linux.dev>; Sun, 23 Aug 2026 23:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787551294; x=1788156094; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gpm6zCO2JAQz0/FH0uq/+6yxEFK8TYfovI1Zuayc2Bk=;
        b=YkjbFcD6clSuEST5NHcGdc37cbPP89hm0hDVJdg1esOOQ2u9BEnGKfLfyNi9VVNq9P
         MqxAF1WV1TlF38reyIPfCuZhwiM2Lz4T1wISqo4vimWZH2AFHerP8L7AU57GpFNfznWp
         zUrHCzu89j8OftSPYCIEnRZvk+T1YE5B7LIXYFqhQUhpAftzsBF+aSZDxrsi29X3u/eP
         n6cOcUlUVAoROv4LMxAuNdJ7Wje+ip8PQbuqglGAjgHA6/25icxXbxe42MUJ/uhndS5W
         xacrTypgJ1J1nKKORIMV9/2l3C1q0Ha9T/W9BYo0y5Zuz7iJhFdxr1H5+d3LkNpqtKgO
         fEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787551294; x=1788156094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gpm6zCO2JAQz0/FH0uq/+6yxEFK8TYfovI1Zuayc2Bk=;
        b=ih5N0PIkN09qUXfJ1umKALin1afccyX5I487nUjBXm/TdRKPjTpeHIlzd4DOzXsthw
         41axAZAXfsVP56viVVxH7DqBLZkbxMm1vvIjP8wbGu7GXlJHURNvY7gxqzmOGsBbqWzM
         wbv3IDHxTOiyYkpQY2TQV1N3Qxj8/wE5TCJNv1W16JVJQH49zH3QWNlQHOnZq6rQKWo4
         IzefGsF5i2vPw5gFlKDaLbRnzGGr5isDm9CN5w4FXIwRGeVzheWSs1RZ0IR8Au2Itvdx
         8r4sxIvAKsmA8ZsR1znb3pM99mv08ytC0T5IIwopStVI8lo73qGi2TPqj3jHAwYU7Njj
         AMlg==
X-Forwarded-Encrypted: i=1; AHgh+RoJmPVirM37v2lrnL8uMhJ1rW8g3R3lpYK20maxSjGKlAfmWp5mB9YZkpH9IqRlg4XFkPH7eB0=@lists.linux.dev
X-Gm-Message-State: AFuF++mxM2ZLjlR0zX3R6NLxVrUsJT6R+pbTbWXS95xZzY+9dql//dpE
	b+QW2kkFbRl7boONvcB0dCS3S/Z25FuYt7UhNUDvJtufDI8fyzcK/ca+
X-Gm-Gg: AR+sD13COmmBxchNqeqNNEkmfbjzV0JZ65JDnrvkkfgSp/I1Vxplh4jZTRitZTyNvyu
	wDu4VNPdlS/jlmc3erKnFsjbcOgi0hwP1VdgWq7jXfflsHiCnGyU6vVSdJJHqz10ujev60LQmbp
	41CnR2U+BMdOsMKFPmKtnwSnY1giVru7E1FTo8QBTwoaZ7D1+XSsk/RFZlEIiIRfs2JcCpyLPtN
	qnTr2tMrVkiuIZ4j+YfLS4vriKIR8snzEGGWD/L/Nm8Tfsmv2r2X39qF1e/OEyaBf6VLO5NzyPs
	xu//yqJwOva5V4vG3YwIEOrG7GOAFi861acthTVnMmFMO4ADPk50/4zFGHV1z/QPn3COcJ0lzOq
	5+nU5gCQm0GAVxix8G/QWOEtM21SFslmKu7hNstiv9XHLgmZ/LT/UZ8ng3f4Zp1zmYfLaRMF6fG
	Y4Rt3eE/TnCt8lJalPZoJsYbjZiMnSXAbwXdDaOOdsyXVT88PW0xc/s9K4PV353ZYwKBKAuN1nh
	tsKKtMWYyMa2LK5dV7rMw==
X-Received: by 2002:a05:6820:4b17:b0:6a1:77ce:1b09 with SMTP id 006d021491bc7-6b1591cf1f0mr23760202eaf.6.1787551294202;
        Sun, 23 Aug 2026 23:01:34 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9236166sm22501895eec.28.2026.08.23.23.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 23:01:33 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Cc: iweiny@kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nvdimm: pmem: fix gendisk leak when badblocks init fails
Date: Mon, 24 Aug 2026 11:31:13 +0530
Message-ID: <20260824060113.2330468-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pmem_attach_disk() allocates the gendisk with blk_alloc_disk() and only
hands it over to devres at the very end, after device_add_disk() has
succeeded:

	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
		return -ENOMEM;

Every error path in between either has nothing to release yet or jumps
to the out: label, which drops the last reference with put_disk().  The
devm_init_badblocks() failure returns directly instead, so on that path
the gendisk, its queue and its bdev inode are never freed.  The disk has
been allocated before this check since the check was introduced, so the
leak is as old as the check itself.

Forcing the branch and rebinding a namespace 64 times shows one gendisk
leaked per failed probe: disk_release() is never reached and bdev_cache
grows by 60 objects.  With the goto, disk_release() runs on every
attempt and bdev_cache returns to its original size.

Fixes: b95f5f4391fa ("libnvdimm: convert to statically allocated badblocks")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/nvdimm/pmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 30a51c365ce8..648fc7d66063 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -563,8 +563,10 @@ static int pmem_attach_disk(struct device *dev,
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
-	if (devm_init_badblocks(dev, &pmem->bb))
-		return -ENOMEM;
+	if (devm_init_badblocks(dev, &pmem->bb)) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
-- 
2.43.7

