Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A908AD0
	for <nvdimm@lists.linux.dev>; Tue, 15 Nov 2022 21:41:22 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id j73-20020a25d24c000000b006dca101748bso14328726ybg.14
        for <nvdimm@lists.linux.dev>; Tue, 15 Nov 2022 13:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X2q2jXZbiR4aVk+j4cgzelsOGwbnws5+6EO0kS0q+IE=;
        b=bc8gszccDarK7qqwempMPNtbikI8jkIOiq/wh6VybGdCVg6NwG/Nx85IKREmkFRuKU
         wShAc4YefT81y8pFMR1rxelAe/RRgfpvpPmNlQEZEKpzo+c1M3/C7NJnGgjkinSTAxWr
         qVKQ3wauGSA/Lewwmgqvq9e006mGZVpXq682GvsurpiaXjeSpHA3QRJTFqPGwKqgTeOm
         YpeAyY7kri8DeFOmUx37xDNBusgu4XbtjicarUdIsq0DCAcH6Us3YD5wihN/jH4yP30k
         7W198pKVPpm5ebcBI9A8BeOfWYWFyoQiE5lu9Q9bZIYmQ82aQhzPy9WzzxM2O19DPRLm
         ZrRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X2q2jXZbiR4aVk+j4cgzelsOGwbnws5+6EO0kS0q+IE=;
        b=x+sUkjLO/ijypQXCFIsbD6KwPawDpppbTaTOdeCJ9cWEHT4sWSOjA2f+Rek/PPZB56
         BsE7EGbTZTdsaSWnvSvDXMr1i44QCRBZZUjzwCgyRpY3/OjEOqtPJxgNmW8W9lWph0rL
         nDuQehJDNv8/HADrwf0pL5XVgiYcrImoC4JcxNxznOl8l+4CpwaEI61D1c9dWjcYorrj
         IuiJKRZlWXNKs74+Al5mupuq0WoozTPWfKKJYGcqWguqoRwRFixF8t+tkDLlX0+JjhLe
         wtdouRRuZEgu8r5U8PF+JXH2XK5fNxqtrPdZkqf0IuO60hgvYTlrzn+bUDS4gtOGKnCV
         5vWg==
X-Gm-Message-State: ANoB5pkHSmZe3IDNSqjUcM1EE+V0a/zIGgeXuIx1VO3JLAAYKRk/+yWL
	kqrANfaYU7mbkjUk76x+uUPqgGAuwnoZ
X-Google-Smtp-Source: AA0mqf7GgKCoXOCi2F46eSyK33OlF+GBC970TPtJzlizq2rWCFH+aPNwsJ8Zy7KnDh1jhzu4fIyuMGmvV68G
X-Received: from sammler.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:43cd])
 (user=sammler job=sendgmr) by 2002:a25:41d7:0:b0:6cb:8949:fdbb with SMTP id
 o206-20020a2541d7000000b006cb8949fdbbmr18613201yba.328.1668548481659; Tue, 15
 Nov 2022 13:41:21 -0800 (PST)
Date: Tue, 15 Nov 2022 21:40:36 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115214036.1571015-1-sammler@google.com>
Subject: [PATCH v2] virtio_pmem: populate numa information
From: Michael Sammler <sammler@google.com>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mina Almasry <almasrymina@google.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Cc: Michael Sammler <sammler@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Compute the numa information for a virtio_pmem device from the memory
range of the device. Previously, the target_node was always 0 since
the ndr_desc.target_node field was never explicitly set. The code for
computing the numa node is taken from cxl_pmem_region_probe in
drivers/cxl/pmem.c.

Signed-off-by: Michael Sammler <sammler@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Tested-by: Mina Almasry <almasrymina@google.com>
---
Changes from v1:
- added Reviewed-by and Tested-by
- synced with mainline

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
2.38.1.431.g37b22c650d-goog
