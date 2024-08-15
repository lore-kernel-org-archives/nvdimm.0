Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F58CBA34
	for <nvdimm@lists.linux.dev>; Thu, 15 Aug 2024 00:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683432; cv=none; b=WvJGUf6xY+tuwRM08C8omLFQQBld5IK6oHZ0bWOP4y+dSySgXhjXUojoTViO9WvNAoaKvIrhCIeQ3Gw5hY1wpXyrWwpGPzyyHz/ma87KEkEIbBu1K8RH5EP6O7PX7gajhX5bkhcx7QpxDifRWg6c47UD3d/HHXMx3hA8v7coXns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683432; c=relaxed/simple;
	bh=368TiaxNIcxCK60CWSg8TX4WbROxX/ctY6baf9Uo4PU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y1Gq66wuf6lxlYwqfwNhO+DU3ndiiUCuv3ZS0xh7SSMYW0sKoYHuaujm7O7JNKYgvkjR1gq025h80H1tqbJprZvqsBS65xerRWfYOHvXK7ES1hsHYZ4PLKrtAXmYQKeb8VCBRHmhsxTMl0luzGjrqoJKF6Vz9/LEeBXB05ol/iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Mwi0UJjR; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Mwi0UJjR"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7a1e3223f30so3822885a.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Aug 2024 17:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1723683429; x=1724288229; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mC/qr8MXY+EwHkMGwD4N6qk5mBndc0DNrIK0ECikEHI=;
        b=Mwi0UJjRQMjyNqNLDF5EIixbPxtQztVpmSc024M3iX8yC4SpdKm9FcTsZMQ8i41SBK
         fFoOW29NtguH21JAYKheIGr/3ndWBL93ahZT0euqioyu5qUf8ybrGy46suRGJMNEioso
         K1ozsn6fBgos8bcZIbFSV20uZhfcRLEAoJ0n4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723683429; x=1724288229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mC/qr8MXY+EwHkMGwD4N6qk5mBndc0DNrIK0ECikEHI=;
        b=gNkI1dS4Q6gj4DH25OyNNnBRGXRRuX4cxDsR/LM8fZeYU7hrzf4hxbWVhW2ggrTJUS
         jCyThlEqO4IUCga++Q1V2zXLZMP2rWdpWqgZsrsuyskRnklRKMMSATVLefEAASbWs9+9
         yBrIgMmHhiYhE0FRjkYRsFD8K357Ou3/dJn05Pegqz3E9C1KZeD+lAlsPVgHLy1pDQP6
         FwOGpAD6weB2A4piLO476e5TF2nVt/M6ZqyHEvINn02uYXoWr/gjoOWZST1P0fu2E217
         MACRHLwgP0RaNW9Tbms05OSfVdLeGV5cytpG6vUAwhX8MaECuMXcytpFYW/thfAgulPl
         A4RQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiO8Htt7jlG6OYRG+d2ZILBx951LIeng691N3fLJTciE1YcPYgFx0n0JOS1Mzb/6rg2BZg3e4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzq5m8CDDT1nd7cSpI0vWjP9AVYFhqq2XcG9rKZd1FSQ5h/UXfM
	KZYGFCDfykcITtKmDDlxhanaH25DhbZv0GneWOMGiLDg0Qcr4Y6XhTRg+P7bxQ==
X-Google-Smtp-Source: AGHT+IFzFS1cAkp04Ak5eb02FF38FZuq4vN9/hrIFBugIoOlifoqQbAf2j9hy/A1dl3myUgxjXWyxw==
X-Received: by 2002:a05:622a:18a2:b0:44f:89e3:e8d2 with SMTP id d75a77b69052e-4535bb75416mr28547711cf.12.1723683428894;
        Wed, 14 Aug 2024 17:57:08 -0700 (PDT)
Received: from philipchen.c.googlers.com.com (140.248.236.35.bc.googleusercontent.com. [35.236.248.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4536a07249dsm1977581cf.89.2024.08.14.17.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 17:57:08 -0700 (PDT)
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
Subject: [PATCH] virtio_pmem: Check device status before requesting flush
Date: Thu, 15 Aug 2024 00:57:04 +0000
Message-ID: <20240815005704.2331005-1-philipchen@chromium.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a pmem device is in a bad status, the driver side could wait for
host ack forever in virtio_pmem_flush(), causing the system to hang.

Signed-off-by: Philip Chen <philipchen@chromium.org>
---
 drivers/nvdimm/nd_virtio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 35c8fbbba10e..3b4d07aa8447 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	unsigned long flags;
 	int err, err1;
 
+	/*
+	 * Don't bother to send the request to the device if the device is not
+	 * acticated.
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
2.46.0.76.ge559c4bf1a-goog

