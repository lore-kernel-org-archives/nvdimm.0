Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C6ABC1A1E86
 for <linux-nvdimm@lists.01.org>; Wed, 26 Oct 2016 08:52:06 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [PATCH v2 2/3] use a nocache copy for bvecs and kvecs in
 copy_from_iter_nocache()
Date: Wed, 26 Oct 2016 10:50:20 -0500
Message-Id: <20161026155021.20892-3-brian.boylston@hpe.com>
In-Reply-To: <20161026155021.20892-1-brian.boylston@hpe.com>
References: <20161026155021.20892-1-brian.boylston@hpe.com>
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
To: linux-nvdimm@lists.01.org
Cc: oliver.moreno@hpe.com, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

Update copy_from_iter_nocache() to use memcpy_nocache()
for bvecs and kvecs.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <x86@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
Reviewed-by: Toshi Kani <toshi.kani@hpe.com>
Reported-by: Oliver Moreno <oliver.moreno@hpe.com>
---
 lib/iov_iter.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 7e3138c..71e4531 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -342,6 +342,13 @@ static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t
 	kunmap_atomic(from);
 }
 
+static void memcpy_from_page_nocache(char *to, struct page *page, size_t offset, size_t len)
+{
+	char *from = kmap_atomic(page);
+	memcpy_nocache(to, from + offset, len);
+	kunmap_atomic(from);
+}
+
 static void memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
 {
 	char *to = kmap_atomic(page);
@@ -392,9 +399,10 @@ size_t copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i)
 	iterate_and_advance(i, bytes, v,
 		__copy_from_user_nocache((to += v.iov_len) - v.iov_len,
 					 v.iov_base, v.iov_len),
-		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
-				 v.bv_offset, v.bv_len),
-		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
+		memcpy_from_page_nocache((to += v.bv_len) - v.bv_len,
+					 v.bv_page, v.bv_offset, v.bv_len),
+		memcpy_nocache((to += v.iov_len) - v.iov_len,
+			       v.iov_base, v.iov_len)
 	)
 
 	return bytes;
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
