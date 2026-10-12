Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FC449B1F2
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818345; cv=none; b=jRaye8H0SgFTxW4flIYaJNhvBWbmbFBtmMHRNyGrCJ+ljkBf5sY6bsCwkyxdGQkMDG3RqqT1pem+PzlHqfgNWE7zsvTHQs0w0AMydVdmFmf4blqCeW6e5TUpJQoFRO0g4uOENBnXGxrFzJgvqvvWuAoqc0TJTXD7bWOYXD/5it8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818345; c=relaxed/simple;
	bh=zCThCBQHEg7zoILpu1wZQQI8Pc820V1e/n5FVw5TliA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VK/OlvZhBeixaouYw82cvExp3qmDGncHnsWWNSNJ1oi2FsVk8JtkFTTHjT+EZw6JrWNsrEmWX86jkG74ioOQ4JKs1XzmKrTWKOSrXYgBZj6YDg6lXfZHwtrCzVSpI2JGSFKAD/FuvQzArYHeFPhkJSJKOZtVWk56vnws26vBpHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mYPqfWLv; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYPqfWLv"
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-8897e83332fso1658580b3a.1
        for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 08:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791818343; x=1792423143; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Smdsi1BCXFX0leS6t8zLips+J1KQ1pukbcy1pEKTRmY=;
        b=mYPqfWLvhMN59iOryCtNl5JG40GSztCQ+8BR2TEqNAmpAZgpWzTB+cPgBdQuyQK8/x
         y41WD/YL3Vza6+IMawMpEioVr2rios59G6ye1ASQfsjtAcGTMgkBPlJfoy1e58fh/YNo
         +g4wkpJCil9h2QNZzOzfhNsh3O1hQ9OQ/pBV/eeY5FCMXJ6t+qJXddw1zjAukhMhz0ca
         Bde3iTshw7qJiIT6chLFVJOI0kz3tSqh/QN6+3HDUfOuxzr8ctFu9N5Rh/hS33GG2SUW
         VZSnBTMrs6NN7R5zyqzhiYLN7RxHTQ8yr/XGYMdAXAmXwHIExGmp652dqGlry637p9Sd
         fa1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791818343; x=1792423143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Smdsi1BCXFX0leS6t8zLips+J1KQ1pukbcy1pEKTRmY=;
        b=ZJULkfVwtQlxbD3mg5UGtwxq8w3N9A7X4yQQh9CGFG6F1SdvUk26k5g/FThd+5lBIy
         Awjyn6OQjBYOnmBGNmIU0nERYhQoUe+OKrsWZzrb8nRBaBCV1au+syhF/2XYoifBo5Qg
         KXJ8GgAYyfB8cEF12fQYIhSjBvWLYo9P5WB8esQ/5RBREXTgGJsgDajn+u9C9eY01tCD
         gNkLh8oPp7MLPXHOGM05o9Qp0mYr9xrz5rYQeHXbSwKq/jxdRm6DoqihgYpxRA/xTe4W
         6wy6FdSFsjl0aYGcjLx7jhelFgKsA5nOpSz1cQupqLKeQkOzqXiqNqh8Gpx6SgK5WiP5
         IApQ==
X-Forwarded-Encrypted: i=1; AKwUvBw5NJ38at9iJuLCseXI4Xjd+OFgJC/x9EQMrKIJuQdHialSHFDgDUiUEiCIuTtINh28kp2Chxk=@lists.linux.dev
X-Gm-Message-State: AFq9FYKZnP46oR3dKAP5gVA8KSvFRlrwV0JpSpvSkOIKFVaZYCY34qv2
	FYyjssdXsfEWF6jiuws8OVhiM+jxepCYQ/Geppca5IADchC1Fdp/C1Nw
X-Gm-Gg: AYBFou2Um8bmYp+1m5vt3J/ZHlS7/tWfFF0GsTgkvWX5HqZJ59wwiy7GowRwA41ei5a
	9iF7oo/35Yx28kGvKbn2Q9qR4btKvQqYqmy0KLyz8TKrKo/6ZVqlb70Dhw8Y8QL+nxtoiBl2+EV
	l5At3sdYpahDmfn98sMK8JHGWt42V13x0P5Cax1JFOv8iaQ3rxFnUmfe11bsI/dfkGoB0zlD65n
	PXDb3pS10yCnLBSRs/caLlMCds6YY/JZAr8zkr2B/IrxwuUlCfdgoqOnQ0RdK0IdcyfM/X9Waox
	JTmcAYkFxssaqJJ+brGlkKH90BeLlVxmcud22M+ul4K/tDui6ul8oE3Xi7+1c4/FN+3gnziiU2r
	bz9081Dd4E9PStqMHdwhSfK96DdBTh3P6EZrpLKp8etuHjyOa7jdlBxUor84xhP0RbS1Tz5wIIU
	alhSoGo0bab6+NRzk/ufAZCK3sioIprE1rnr1KLy8YstFwocOiCSBDl9iIJ70tlkvgkUgcWqe1C
	fw1GApDqkwunNEdWe+lu8yrmMtIchiYM94NMs+Qb8ip3CvO5OsdkoYEAdM=
X-Received: by 2002:a05:6a00:c08e:b0:898:776e:eed6 with SMTP id d2e1a72fcca58-898776ef151mr3214615b3a.34.1791818343199;
        Mon, 12 Oct 2026 08:19:03 -0700 (PDT)
Received: from localhost (ec2-13-231-150-91.ap-northeast-1.compute.amazonaws.com. [13.231.150.91])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896b68ef2easm4191976b3a.7.2026.10.12.08.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 08:19:02 -0700 (PDT)
From: jianyungao89@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jianyun Gao <jianyungao89@gmail.com>,
	stable@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev (open list:DEVICE DIRECT ACCESS (DAX)),
	linux-cxl@vger.kernel.org (open list:DEVICE DIRECT ACCESS (DAX))
Subject: [PATCH v2] dax: fix dax_core_init error return code
Date: Mon, 12 Oct 2026 23:18:57 +0800
Message-Id: <20261012151857.22534-1-jianyungao89@gmail.com>
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
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
---

Changes in v2:
- Drop unnecessary goto label, keep direct return for dax_fs_init() error
- Add Fixes tag and Cc stable

Link: https://lore.kernel.org/lkml/20261011132017.31131-1-jianyungao89@gmail.com/ # v1

 drivers/dax/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 45f84b0eb909..210f4af479f0 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -738,7 +738,7 @@ static int __init dax_core_init(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
-	return 0;
+	return rc;
 }
 
 static void __exit dax_core_exit(void)
-- 
2.34.1

