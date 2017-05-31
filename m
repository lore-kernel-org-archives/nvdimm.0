Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BBFB21AF39C0
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 09:18:19 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/24] nfsd: namespace-prefix uuid_parse
Date: Wed, 31 May 2017 18:18:09 +0200
Message-Id: <20170531161826.23243-8-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfsd/export.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index e71f11b1a180..3bc08c394a3f 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -486,7 +486,7 @@ secinfo_parse(char **mesg, char *buf, struct svc_export *exp) { return 0; }
 #endif
 
 static inline int
-uuid_parse(char **mesg, char *buf, unsigned char **puuid)
+nfsd_uuid_parse(char **mesg, char *buf, unsigned char **puuid)
 {
 	int len;
 
@@ -586,7 +586,7 @@ static int svc_export_parse(struct cache_detail *cd, char *mesg, int mlen)
 			if (strcmp(buf, "fsloc") == 0)
 				err = fsloc_parse(&mesg, buf, &exp.ex_fslocs);
 			else if (strcmp(buf, "uuid") == 0)
-				err = uuid_parse(&mesg, buf, &exp.ex_uuid);
+				err = nfsd_uuid_parse(&mesg, buf, &exp.ex_uuid);
 			else if (strcmp(buf, "secinfo") == 0)
 				err = secinfo_parse(&mesg, buf, &exp);
 			else
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
