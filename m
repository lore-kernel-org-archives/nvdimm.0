Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D0B36D
	for <nvdimm@lists.linux.dev>; Thu, 15 Aug 2024 00:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723681845; cv=none; b=eHMQUYx4efm8o8uO0OzBYCbEb8Zd2Td2tAgCAHYvHBIv1du6BpdV3cp8AHqQPoO2+XEBtX5vhMf6xxR2JwFPZLidYzs/YhipojCR26xXTD4ERJ4DtPaV3k2wRVVkOguAWkMxz+lHX3rr+wR0l+48s67X/3tBNr7mjvnRekY67to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723681845; c=relaxed/simple;
	bh=Ha8WGJZY9OeF9s3cQPyRaZDQfFYebanex3oH+X5N4aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PWGIftBAODn5aq8TG5yfDyYOD1X81M2qdPhEG5jfvKs2JOcZJ6e3E+BWZQMLh5q1gN3uodmclJYJs83M9E6aUjrmAhv5uWFZNZI8hF2GEqg6lTAj1efgfUj8BI8AH1B68Dm407tG5AI8iUUt5GW13sjRLoB8ogrfTcOD9IZ3YSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ZTjgpO1+; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZTjgpO1+"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6b7a433857aso591666d6.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Aug 2024 17:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1723681842; x=1724286642; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UwqWhO+Cug5+cipPscPPeRPr4g13PnMC1hmaB4oZB3s=;
        b=ZTjgpO1+Fm1Dt7V+YRhtjBvK5VVkjIc9ONimie8Ajr98PwL47xoj727e4da6HZgmZl
         knw6o27c20fd5hFeVclibf1DTTflUMBu0LwpH0Z6xlw68X+pOP+BT7oLXX6CBY91K2eI
         SSb8N0uhpxcvOEaiqhMFfZSQI9BgIDz2/1DmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723681842; x=1724286642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UwqWhO+Cug5+cipPscPPeRPr4g13PnMC1hmaB4oZB3s=;
        b=vbq1UeFcvCeG4WhCkxIZjGzfiCGeUQe23dVW64Wl/W8Mul1zd7XHD6aSEXYX0wcQ+L
         SNqJzNcIA7tCjpjL8PTlGHYczDxFDBlVef1rDLUJl2t/gILF9wT56WN5mZ36dIK6T6pd
         o+YQfcZDJx4FQogrGjraE9oz3i7+Bb4MDh69MunpmsXE5CCqaNn9Q7/NDb8ugD9xvae6
         Falv6kolw1oRAob8wYnA83mN3cRSQjylPzeTOPNCZyxFwYUR5PtItFKPJtI1o8jffwe9
         Np8jAfpz8nCKmmTwggKrTENrpSKQ029+qhqwQ7cRdPmfbTOKL9AyQS0Db1AjjJCRQdDf
         bPMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoD8AzITjm1iM5GCIXKBwmQqWH5fUcNdVr0dJoAfokeEgQg0H6rXUBJwAD4n+hgcM8QYtpLVx9OlH3rjuEoYzcnoFCAE1x
X-Gm-Message-State: AOJu0YyKiTWdRY9AymVYPF0ZuZtMW1ZNvX6ANF4bkmvt6kCTLdKThv+u
	pCAPp8/RavPudPKGk82yeW4pHz38rkr+ktNMtbkyTQZQKHp8Z1q8WtLc8VzkcA==
X-Google-Smtp-Source: AGHT+IECq99oEeNU6c2XicrDKqlBtwmbkES/pMaQwdndLSfaYiJNLKbdNT5f3tSXhMqpKC+4qLQKSw==
X-Received: by 2002:a0c:b542:0:b0:6bf:6ef7:c636 with SMTP id 6a1803df08f44-6bf6ef7c721mr6354386d6.0.1723681842121;
        Wed, 14 Aug 2024 17:30:42 -0700 (PDT)
Received: from philipchen.c.googlers.com.com (140.248.236.35.bc.googleusercontent.com. [35.236.248.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bf6ff0dcdasm1921136d6.140.2024.08.14.17.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 17:30:41 -0700 (PDT)
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
Date: Thu, 15 Aug 2024 00:30:34 +0000
Message-ID: <20240815003034.2315639-1-philipchen@chromium.org>
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

Change-Id: Icc1d0a4405359fb5364751031589d15a455f849b
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

