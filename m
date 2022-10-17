Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B89B4699
	for <nvdimm@lists.linux.dev>; Mon, 17 Oct 2022 17:11:41 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id p5-20020a25bd45000000b006beafa0d110so11013902ybm.1
        for <nvdimm@lists.linux.dev>; Mon, 17 Oct 2022 10:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZZNYuYnYhhKKqBDOIhr6XrGGyufP89bX5HYBhar9JwY=;
        b=YbUppmjpRzqgtYxWUA5/kXQe7wLwR7bCxLD/Ud087xEgKvIJshznwYZ4ZySrPfiZqn
         NxPSZ7EowQM/sHlFZOX2x2lSL6MGX0S70RowSh9F/i25a8yimUcordRjJY13eKpkNL7I
         ZtpHVvEmKqv8c5yrrNFcuSnEls5TW5Y9H7zyF+A94n6o14llTh5SS9JFL70+NiikDYco
         jwXio2ChZpCZWGy1nESgUyuRIgIj8CICzFRbEgGs/ELtb7VLKL75je0H0VGQQaCoCvSI
         DYoah7Nm+WhHOWcY6X4AYZLkRLr3VhJTY0M92KhuyYW0+3/mptpvWZfVLX5MCDD95XUz
         GJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZZNYuYnYhhKKqBDOIhr6XrGGyufP89bX5HYBhar9JwY=;
        b=LChGljDIgej6L/z1UmOamXtxinHWG0BJu06E6kQVRvbW2Aw3uQAh8buIYo7nFu5eIh
         cGoCy5GU5hQJryexB2tHeHKYIpr9TdfqgpAQXnMninGEFD+xRETTqFY0e+ZNRtBlTiL3
         tN/8aXEYAOozqKqdzM1ba6JBulH6JgGdYqT5Kx/d38VnZ64aTsPyMqYuh8hIZ5xJQKPf
         9NUjjVcYztuxG9VAsmnAVsfaIfWxhnmvpcxdL6HKjYO+Cql2iS+9XN25vCGZmPr2UCtT
         leRrb1UdIRJirj9UuTQoBJeFvclIjwRJj1EdSRGKduG1k0EuK83/9WtO+Wxdp4QVYSy5
         fVEA==
X-Gm-Message-State: ACrzQf0dzbpAgL5jQt39BfyVI1F4lT7eHI8VMaFMJBjE5f0xc8S9YgoJ
	0CvYFWiASJmu6i0AVm88mZk8rF2/ChNt
X-Google-Smtp-Source: AMsMyM7YOldNijFyOMuXUwg2kVVAvEcwSoCVIPvkBVzy61RYTe1Jweys9WJQUIGmaqzg2pJsVOINFZyKfCXP
X-Received: from sammler.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:43cd])
 (user=sammler job=sendgmr) by 2002:a05:6902:1022:b0:6bf:eda0:f746 with SMTP
 id x2-20020a056902102200b006bfeda0f746mr9381400ybt.368.1666026700542; Mon, 17
 Oct 2022 10:11:40 -0700 (PDT)
Date: Mon, 17 Oct 2022 17:11:18 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017171118.1588820-1-sammler@google.com>
Subject: [PATCH v1] virtio_pmem: populate numa information
From: Michael Sammler <sammler@google.com>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Michael Sammler <sammler@google.com>
Content-Type: text/plain; charset="UTF-8"

Compute the numa information for a virtio_pmem device from the memory
range of the device. Previously, the target_node was always 0 since
the ndr_desc.target_node field was never explicitly set. The code for
computing the numa node is taken from cxl_pmem_region_probe in
drivers/cxl/pmem.c.

Signed-off-by: Michael Sammler <sammler@google.com>
---
 drivers/nvdimm/virtio_pmem.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 20da455d2ef6..a92eb172f0e7 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -32,7 +32,6 @@ static int init_vq(struct virtio_pmem *vpmem)
 static int virtio_pmem_probe(struct virtio_device *vdev)
 {
 	struct nd_region_desc ndr_desc = {};
-	int nid = dev_to_node(&vdev->dev);
 	struct nd_region *nd_region;
 	struct virtio_pmem *vpmem;
 	struct resource res;
@@ -79,7 +78,15 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	dev_set_drvdata(&vdev->dev, vpmem->nvdimm_bus);

 	ndr_desc.res = &res;
-	ndr_desc.numa_node = nid;
+
+	ndr_desc.numa_node = memory_add_physaddr_to_nid(res.start);
+	ndr_desc.target_node = phys_to_target_node(res.start);
+	if (ndr_desc.target_node == NUMA_NO_NODE) {
+		ndr_desc.target_node = ndr_desc.numa_node;
+		dev_dbg(&vdev->dev, "changing target node from %d to %d",
+			NUMA_NO_NODE, ndr_desc.target_node);
+	}
+
 	ndr_desc.flush = async_pmem_flush;
 	ndr_desc.provider_data = vdev;
 	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
--
2.38.0.413.g74048e4d9e-goog
