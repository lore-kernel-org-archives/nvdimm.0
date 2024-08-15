Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E1610FF
	for <nvdimm@lists.linux.dev>; Thu, 15 Aug 2024 01:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683823; cv=none; b=EDBa5xMZHo0tX60WgW+0qV8HViiKNUXVB4AarNHKiDKOLpygNyEfcl482er+wLGpu7gVldrGJFolrFeS0q18CouxB63bNgJhSBP6zqZC0MlMnZ1OvJWlm9N8FG6VDbUrkPbCOMtNtm+5xc6l/eyEUtc20CwzyofrCaIx0UpFfBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683823; c=relaxed/simple;
	bh=cUxt0up1TK679P2htGrK886ysRT04vOMzqU3A8VSJ8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ec9jj3ycpZ8sKkahF+8Spb8TUNN/dQUDHLTYQ8IiO+yVpA+GzmXwlzeJoxidcGgcPoJ9Dh03vJ44QXsC0/3so0RLP3aCtIORnDjK67SuWzH6hTOWq1UZsQ/RUkr+si2+ywpmoSDn41NthWNRUiRtyYCKmz9uFE6BK3CSvPWfZIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mcyCmLhe; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mcyCmLhe"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5d5af48b48eso33024eaf.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Aug 2024 18:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1723683821; x=1724288621; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=khMHVPKCTDHVonG/wiILjKhvjw+3YZpJ69x4MahYmgM=;
        b=mcyCmLhew9Lrn0JTBFwbjd2V/H9beIalWdATfg76Axsi81mC7HjSeT4++a4bXcGD5A
         vshcE+ZVS3rjQGoXo1CWtzKFEAEBtI4AyTU2HGVHjnnICh70ZkmqM3EVtFJjhN1IlF2M
         6c3IVbGQod+Zd3IYUu1e+OwMik8DSx+ZXcoA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723683821; x=1724288621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=khMHVPKCTDHVonG/wiILjKhvjw+3YZpJ69x4MahYmgM=;
        b=JdpCaoxY+DnIIPJwq7BPh51yjsADA81j2jk70PoUpkh95BGJYkaBwtM+23+yr8Ye4D
         1C/w96TAC3+PQBDd6HZfGrU/wGuw1oM7r2U0TPsYpd4BIL/CIXPKxv+9DRjZqS+vTWwe
         eZ93V5UqRJfyz8Ow3ZphCRUqSX8UGNofWkYrJ75XzTKoPYgAtbNxXVNoeuiyzwr1sYw1
         e/M6dy5hwUEK6sYVG+nGuDO7W83kx9Vp5iU8LgBkDNvgIOQblj8kconybFfNU+B+Lq/s
         v6K2Aaee4t53rjKCzmmo//PjY1M0hkGxlx2UCGEF7SwLqWrzwurQ0JcIi+IqzeNGtAWa
         gsPg==
X-Forwarded-Encrypted: i=1; AJvYcCXnbDALeHXX7G7fpbfpXg6IgEl8dWrDQurIrOAkrqYWSk6HE+ovvtVRR2WPyBh/Sgy4VSl+Mj8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/GGFA05H36VRqWL66KVvo2WFSLUx0lcC0nR6M1ydJn10tIknL
	9QqTJyTTgEpgy0D8hMgBgvt+RasShA98BRG9d0x7w6vtMvnotYP6jVqbOY+H9pfUwsV7HnDKoH/
	MmA==
X-Google-Smtp-Source: AGHT+IF+8XgKQDkaXk0vfQAks7fyXcwVXvAv57Id3YITxLxh/ZxwgsaZs42QqdKu7qhMO+nTdLC4Iw==
X-Received: by 2002:a05:6358:4883:b0:1ac:f436:c8ca with SMTP id e5c5f4694b2df-1b385ac1c24mr111855755d.1.1723683821360;
        Wed, 14 Aug 2024 18:03:41 -0700 (PDT)
Received: from philipchen.c.googlers.com.com (140.248.236.35.bc.googleusercontent.com. [35.236.248.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff02c7e1sm24485285a.15.2024.08.14.18.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 18:03:41 -0700 (PDT)
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
Date: Thu, 15 Aug 2024 01:03:37 +0000
Message-ID: <20240815010337.2334245-1-philipchen@chromium.org>
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
Change since v1:
- Remove change id from the patch description


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

