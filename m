Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7942F22
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 07:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JF4vxivs61H3BQ2kwEvqaObshMiGuhjwB0Vb6uVLhnQ=; b=pWH9G4R3FuFCi6BPR8Aydszuy2
	aVX1hsx3Q4Yx3NId7eCffi0fH+/Us5qYuZbEIvHJuojBPQx8fv7FveMHHGPrJB5WwM/STvQ99GSd9
	fsMGwLYVaj6y59WU64LRi7qS5ePWSiHI739n4y/4nQGRH4J+6Q1M8gNgQnFUkeD5Hz88KXRMsN6GZ
	AiXORMzot//UeikmdcFwmLXTc+dZb3uY7Q1fD9N/UlSAFzo56Xg8a319X3Iixge9JDzj3UN04L+O+
	/wahWZFtx/GqzxDHceLTJRONLXZYBZ39iI+ESHxbRxCmRpNQAwJ2xKTKPn+MfOfrLiTL/8mO3nDKn
	rSsF4MkQ==;
Received: from [2001:4bb8:188:3efc:8014:b2f2:fdfd:57ea] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nI3t8-002s3W-TU; Thu, 10 Feb 2022 07:29:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>,
	Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Alistair Popple <apopple@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 14/27] mm: build migrate_vma_* for all configs with ZONE_DEVICE support
Date: Thu, 10 Feb 2022 08:28:15 +0100
Message-Id: <20220210072828.2930359-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220210072828.2930359-1-hch@lst.de>
References: <20220210072828.2930359-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This code will be used for device coherent memory as well in a bit,
so relax the ifdef a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 6391d8d3a616f3..95d4aa3acaefe0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -250,7 +250,7 @@ config MIGRATION
 	  allocation instead of reclaiming.
 
 config DEVICE_MIGRATION
-	def_bool MIGRATION && DEVICE_PRIVATE
+	def_bool MIGRATION && ZONE_DEVICE
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
-- 
2.30.2

