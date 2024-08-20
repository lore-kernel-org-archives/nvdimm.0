Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A781BA87C
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724174583; cv=none; b=mx7yWnQLKi+dbYgy70g+uMTHMpon9G4Azhli3AaXls64BF3+sHXUwIJU07Qa7yFW9vajjzAxHhX2OemtdDONRHM+I7cHbQfOJ7mffxYOidV+tJ+Ud2WftH00gDhp3/7r1DjhaEGK4Muh420zQxjn2fiioLAeH+XsRqO/wzdHeCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724174583; c=relaxed/simple;
	bh=WoePu1j9VOd2T7GWO2R+V03LjT4GKPVJ+35Dd/6RTPU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MGR6LeEEwkxRlQ2yRofZsqM3SZ1hkJOv7wkDvBUqaShDIPHrOd7Py9JzQhjLZoS3W5EeYPTAV1IKX8hiRlPrwv+GxO0jcfs2W8N3vWLJQRMa8l+r/ltGoo4lpdSSgnu3DHJh/Qn8Fsu5x3uS3qCc6Yfh1qGqfnDvOGCyPa79MWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=EjCOZ/IP; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EjCOZ/IP"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7a66b813847so55138485a.2
        for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 10:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724174581; x=1724779381; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nG3sk+SGqgopURDWRpSLqodBy9lchgvdy2diDegZ/Gw=;
        b=EjCOZ/IPRXHDBh/CEWA69lfZ459gye8IXG9xm9B9kW836akv7RI51XG3iKq2ggH342
         D9C9AuYafYCMZYdRIMBAj9KvGzq8hS6/B/iQ89kj90xKlnuDTeQTShj//3odWHnIZpwG
         j4EH7qGlP286JLD+g4hI4c+QEML97EmpDnmkE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724174581; x=1724779381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nG3sk+SGqgopURDWRpSLqodBy9lchgvdy2diDegZ/Gw=;
        b=G7JEQCTpjiY+XP7mb4auuS7H4vVqN7B2MEqOJQvXZc7nWtbmDhdj/Gk55cM8Htsx1n
         Ivj2uJhhAelgVxDHtPGB/aBP9r1LRklFsE8Z1nkccVJKi52BPEB4xWjkZLadEqo0Bvf2
         WOWMdE7067vdvNtrWS6vyk5MD8e6KXTbQuyBulU9QxiduCI0VG+R3y95+n04UcF8xNVT
         wd74f3sQ2x5yn7KRuZy6+VO9+AP+28lKj+D7Hbj7hKapVQvyDrWP5CmQGqcfsnZf0HkJ
         ANUh0DXS9bgVPP/xrLL1pMsP15KgMYJQQvBQyF1QFlvOAc2MSpdNBVlXruONnRKa7kyq
         BMaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpiSUARoQZpjEHqxH5mWY8lef0d2Z7nVE7wR/ZOka/NHAslxrzYQx9IT43frlpqb2VXVaT3kY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhDvRcTeZjnzRv1RInWEd2CaEtI63pEN5vDmIAqhT8tgTkUN/e
	1qG9gBJFgCO3KnAxe3Xy36TVyijpLv07wJCS0lHzJRDrKnPg90KmwYdcY99LcA==
X-Google-Smtp-Source: AGHT+IGLC0VAnx3ACOqPL6vui1/41GTnaKvRUKl8IQ/H2tHfiWeItGJfBZfdI5j/ZjUY1Sk7SMbEsg==
X-Received: by 2002:a05:620a:370e:b0:79d:7ae3:4560 with SMTP id af79cd13be357-7a5069af85bmr1549222885a.55.1724174580540;
        Tue, 20 Aug 2024 10:23:00 -0700 (PDT)
Received: from philipchen.c.googlers.com.com (140.248.236.35.bc.googleusercontent.com. [35.236.248.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff0e42e9sm545390885a.88.2024.08.20.10.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 10:23:00 -0700 (PDT)
From: Philip Chen <philipchen@chromium.org>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Philip Chen <philipchen@chromium.org>
Subject: [PATCH v2] virtio_pmem: Check device status before requesting flush
Date: Tue, 20 Aug 2024 17:22:56 +0000
Message-ID: <20240820172256.903251-1-philipchen@chromium.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a pmem device is in a bad status, the driver side could wait for
host ack forever in virtio_pmem_flush(), causing the system to hang.

So add a status check in the beginning of virtio_pmem_flush() to return
early if the device is not activated.

Signed-off-by: Philip Chen <philipchen@chromium.org>
---

v2:
- Remove change id from the patch description
- Add more details to the patch description

 drivers/nvdimm/nd_virtio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 35c8fbbba10e..97addba06539 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	unsigned long flags;
 	int err, err1;
 
+	/*
+	 * Don't bother to submit the request to the device if the device is
+	 * not acticated.
+	 */
+	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
+		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
+		return -EIO;
+	}
+
 	might_sleep();
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data)
-- 
2.46.0.184.g6999bdac58-goog

