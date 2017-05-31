Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 269FD2095A583
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 09:19:48 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/24] MAINTAINERS: add uuid entry
Date: Wed, 31 May 2017 18:18:26 +0200
Message-Id: <20170531161826.23243-25-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

I'll keep maintaining whatever little changed we need here, with Andy as
my designated reviewer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bdd1fe5..660c14729205 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13463,6 +13463,17 @@ W:	http://en.wikipedia.org/wiki/Util-linux
 T:	git git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git
 S:	Maintained
 
+UUID HELPERS
+M:	Christoph Hellwig <hch@lst.de>
+R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+L:	linux-kernel@vger.kernel.org
+T:	git git://git.infradead.org/users/hch/uuid.git
+F:	lib/uuid.c
+F:	lib/test_uuid.c
+F:	include/linux/uuid.h
+F:	include/uapi/linux/uuid.h
+S:	Maintained
+
 UVESAFB DRIVER
 M:	Michal Januszewski <spock@gentoo.org>
 L:	linux-fbdev@vger.kernel.org
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
