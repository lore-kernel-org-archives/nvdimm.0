Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FDA2F53
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 07:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=g4R46gxOBBvI5SzAZGkoErOxT4NbCl1fR3NTnxGuvaE=; b=YrXph2q6NJ2GhVCoKu8uYzfHMn
	vZu/MecqvUVq742Ix3fn104EOr4vo+7lp6nbPvnnERPdAPYqCkG4RDXYCsARmWTKGP78hIq0H5dWl
	KvdTYzrICcr+hyNcaDh6C337UnLOMgJhoVAZUqNbVdbzoZ2xKGWnm6ZM/93AUcRV/qxBYvF8h/WH1
	xYL38kHWs1w5jL9qX4niDsVryE7nMla74N7bhHmHQkW3eWlh1G91EvViJbPd3g4CzE0eas46Bg3Gr
	8Vaurq41JfiCOAi1bPe/FnuUyR4rYfIiqsHBM+MtvRD79Qa5DMzDnx2WtHl1XjXckz86KJ2uW/vyE
	9TLlvmNA==;
Received: from [2001:4bb8:188:3efc:8014:b2f2:fdfd:57ea] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nI3sr-002rrA-TC; Thu, 10 Feb 2022 07:28:54 +0000
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
	linux-mm@kvack.org,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 08/27] fsdax: depend on ZONE_DEVICE || FS_DAX_LIMITED
Date: Thu, 10 Feb 2022 08:28:09 +0100
Message-Id: <20220210072828.2930359-9-hch@lst.de>
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

Add a depends on ZONE_DEVICE support or the s390-specific limited DAX
support, as one of the two is required at runtime for fsdax code to
actually work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 fs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/Kconfig b/fs/Kconfig
index e9433bbc48010a..7f2455e8e18ae2 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -48,6 +48,7 @@ config FS_DAX
 	bool "File system based Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
+	depends on ZONE_DEVICE || FS_DAX_LIMITED
 	select FS_IOMAP
 	select DAX
 	help
-- 
2.30.2

