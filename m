Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4412F22
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 07:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7G8J3RPmwqONc2HXCUGJwHrFv6lx9mr3fODzxz3GZ8Y=; b=uUYieNnJaHfU8LFV1HvS+chCMy
	jcAqrinM6uesfhHoQXNQ/yIbALOtnqg/X7rgXJFF6HmxAU0+4dzexPBN2EnDi2dapZPLQOWgiAeOf
	tzVORYmrL7VdJLyW6S053AW0DDzF7ZmU1dwjhi7rK+HqXEtwduphWLaaWJ2i9FXW1FL/pTVPhl6u3
	LE+m2AisM2E2hg6ORWM9biX6jJgiGfqln2ncrqHbXOopuoXLSc1S3T1+fNmZtbayRnW6HXsAIFF0m
	nvn1VGJiJ6QqjxIbHtJmIW7tSVeSa7IIbBXeRBYA674ZY5WukXl78wQ6Z+MIK6VEYF2kn6OeA5Q60
	+XxfFLEg==;
Received: from [2001:4bb8:188:3efc:8014:b2f2:fdfd:57ea] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nI3t3-002s0C-1N; Thu, 10 Feb 2022 07:29:05 +0000
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
Subject: [PATCH 12/27] mm: refactor the ZONE_DEVICE handling in migrate_vma_pages
Date: Thu, 10 Feb 2022 08:28:13 +0100
Message-Id: <20220210072828.2930359-13-hch@lst.de>
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

Make the flow a little more clear and prepare for adding a new
ZONE_DEVICE memory type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/migrate.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 30ecd7223656c1..746e1230886ddb 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2788,24 +2788,21 @@ void migrate_vma_pages(struct migrate_vma *migrate)
 
 		mapping = page_mapping(page);
 
-		if (is_zone_device_page(newpage)) {
-			if (is_device_private_page(newpage)) {
-				/*
-				 * For now only support private anonymous when
-				 * migrating to un-addressable device memory.
-				 */
-				if (mapping) {
-					migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
-					continue;
-				}
-			} else {
-				/*
-				 * Other types of ZONE_DEVICE page are not
-				 * supported.
-				 */
+		if (is_device_private_page(newpage)) {
+			/*
+			 * For now only support private anonymous when migrating
+			 * to un-addressable device memory.
+			 */
+			if (mapping) {
 				migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
 				continue;
 			}
+		} else if (is_zone_device_page(newpage)) {
+			/*
+			 * Other types of ZONE_DEVICE page are not supported.
+			 */
+			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
+			continue;
 		}
 
 		r = migrate_page(mapping, newpage, page, MIGRATE_SYNC_NO_COPY);
-- 
2.30.2

