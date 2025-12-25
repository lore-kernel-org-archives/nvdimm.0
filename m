Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCD52D7DE2;
	Thu, 25 Dec 2025 04:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766637021; cv=pass; b=YKImPJxRDxvW06Xmw2krt7NrIDAwzZobFtUIOrlfKtbTShtY3DM22zWzyhlSdYwjlcQ/QtGuM3R2goT8wvqyIPoV6E3FMTeKixgPPeoHsHbO6QJPpOK6fu+I2BsZUllM9zOsQExDCsSsEyjiAri8GL7sejshlGtvWw7tg1aWJD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766637021; c=relaxed/simple;
	bh=55SzY24ldDtSnxo2G3CrVEPrzv0tCLXJ3IqzOpti+m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amrSpWPFcBLVhxDgLi//jjDZkuBAzo4Hc9hGHgwQA9o/qYq5Oi+Fs39tVoln2aQZWg21/DXgxKO/apj0opw0NlOzeRzElM0u3gd/HZ54Ua9ATj5eBioSUktfBu9f/tbnx9f4SfiV+mvA/gLB0GhMDd5WRHObO9vXFATSipLRRd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=rPCC3Oq4; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="rPCC3Oq4"
ARC-Seal: i=1; a=rsa-sha256; t=1766636986; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZHWDmiZFm0c4mxJ2uFbJEjOeULY8CEOMRfiMOzYe/6iwim0M47iAdxDQeBDv9swr217zYqJbnLMt/MZ86MlF5FI6oQU1PMhVykDtqpWEqXCyOAT9NCOiwq9LTthdlHW4h1g3oKYBwdHZbFuH9yGkRZD8Y4varvVrS+PoKF4LN9o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766636986; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ZaLLvWs/FTLzthUovs5wPF9MHv0tJ1jLPb1vjwsMipQ=; 
	b=egylpVIkOeTX3zBZnTNKW6tXW4xNHmfKBhgypo+tBIyq9g8PzvZ9qcVRbCHMwJmOQFvrqRQ3JeR2IVOy3Pplb64h4YFhpdl6Pxsa64t9RndCJzhAJ/KA6sEKikQiomD6Pnz4aI9OpmsLuum5NRWY+pyqhCae1UyGWxLEjdtmJrE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766636986;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ZaLLvWs/FTLzthUovs5wPF9MHv0tJ1jLPb1vjwsMipQ=;
	b=rPCC3Oq4fdgUO7g2BTGN9Lu+FGpmJ1Hj38/y6pNwufKDf8AbT3mtFFQ74hMa3SAo
	Qhen/WDfBg3LK2u5E1ZsKWWzGk3X18WKiKjDzLoPmnD4miUtFxa0dur+AJ5lN8F6D+O
	WI0bBXAe58P0f4ocd/QFWgrZiQ/m5/0Kkpd4FCzU=
Received: by mx.zohomail.com with SMTPS id 1766636984247285.5202591420707;
	Wed, 24 Dec 2025 20:29:44 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: kernel test robot <lkp@intel.com>,
	Li Chen <me@linux.beauty>
Subject: [PATCH 5/5] nvdimm: nd_virtio: export virtio_pmem_mark_broken_and_drain
Date: Thu, 25 Dec 2025 12:29:13 +0800
Message-ID: <20251225042915.334117-6-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251225042915.334117-1-me@linux.beauty>
References: <20251225042915.334117-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

When CONFIG_VIRTIO_PMEM=m, virtio_pmem.ko calls
virtio_pmem_mark_broken_and_drain() from nd_virtio.ko.
Export the symbol to fix the modpost undefined error.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512250116.ewtzlD0g-
 lkp@intel.com/
Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/nvdimm/nd_virtio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index de1e3dde85eb..0d13f73ab7f4 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -76,6 +76,7 @@ void virtio_pmem_mark_broken_and_drain(struct virtio_pmem *vpmem)
 		kref_put(&req->kref, virtio_pmem_req_release);
 	}
 }
+EXPORT_SYMBOL_GPL(virtio_pmem_mark_broken_and_drain);
 
  /* The interrupt handler */
 void virtio_pmem_host_ack(struct virtqueue *vq)
-- 
2.52.0

