Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7309E2F36
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 06:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/NCdUINdSDF5KM2Tb0Dq1i00on9a3wMEZ1QazdYyuYI=; b=ooIei4pfJnCYjgGG+26anfZyxt
	7RPGv8eBlOliwSMzx5DHbMG1ml8zLJe9WG/7xmz++kRingnQ+IvxnuJTHlPCs1Hwm0do7LNzBLi48
	68VBDLLuGuVYNK7Iw0TK6gyltfjGMgLQ72FXo3g7g+myJm1KPzOnKffgXxRtNjKsiKuk2IQ1ZLCAh
	d0FhUJIcuwhbbJ05Q9J4VNkVt+7xskowLyUjFLZJ3GHD1iZ+b7MwEfcwP/jO5gGmbPetBVX4fWBLv
	zknna1w060pYHr37Om6EfjDULgdFda5Q+HPWdA3z5JG8pwz8w19XAjipmSILOVQe8fO6fqp2mXlbq
	P+0uB/VA==;
Received: from [2001:4bb8:188:3efc:2cbe:55d7:bb63:46d2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nGxaL-0099Ok-Pz; Mon, 07 Feb 2022 06:33:14 +0000
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
Subject: [PATCH 8/8] fsdax: depend on ZONE_DEVICE || FS_DAX_LIMITED
Date: Mon,  7 Feb 2022 07:32:49 +0100
Message-Id: <20220207063249.1833066-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207063249.1833066-1-hch@lst.de>
References: <20220207063249.1833066-1-hch@lst.de>
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
---
 fs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/Kconfig b/fs/Kconfig
index 05efea674bffa0..6e8818a5e53c45 100644
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

