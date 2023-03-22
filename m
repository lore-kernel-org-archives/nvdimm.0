Received: from mail1.bemta37.messagelabs.com (mail1.bemta37.messagelabs.com [85.158.142.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215981FB1
	for <nvdimm@lists.linux.dev>; Wed, 22 Mar 2023 07:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1679469985; i=@fujitsu.com;
	bh=wnDZD3GHYg7T5GB7lHGE7xKZFABxHfpVwsbEGh1UPM0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=uiRf2bT2i4SQSglzUlQtaLWp36SYyIClX14zXDpyGn99aXdMZgLi16s1hKdUgQ0L0
	 3zHxejre4Widy4DPQgzpNnsVWXpZRcKAP62m9Kjk6BxCPJAwyzCuESybj7FFoxiXap
	 Iue0f0+kITJhgEb+ndM+Pxi45/Jndk9Fs3J6a9vunKVItHdLJTSPesjw30OufqRUpP
	 Y/aqvZVkI5D+64YEcAtB/7dAorUKpSViobrZkCbAmPwZvxgzvH338OsNMM3SVbt/ad
	 jnHfT4/T99jImSqjjWtkxU6KKWQbR+iKxXRpUUxPm+nW+m1RGdlogvon8wiOnp3YUH
	 IWhRI5+XDw28w==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRWlGSWpSXmKPExsViZ8OxWXfBWqk
  Ug5VdzBZz1q9hs5g+9QKjxezpzUwWe/aeZLFY+eMPq8XvH3PYHNg8Nq/Q8li85yWTx4kZv1k8
  XmyeyehxZsERdo/Pm+QC2KJYM/OS8isSWDPeXlnMWPCRvWJZw1f2BsZjbF2MXBxCAhsZJR6u+
  MjUxcgJ5Cxhkji6hxEicYxR4umMucwgCTYBHYkLC/6ygtgiArYSi2+fYQSxmQWSJX58WwhmCw
  t4SXyZuxGsnkVAVeLnhkdAQzk4eAWcJbatkQQJSwgoSEx5+B6shFdAUOLkzCcsEGMkJA6+eME
  MUaMkcfHrHVYIu0KicfohJghbTeLquU3MExj5ZyFpn4WkfQEj0ypGs+LUorLUIl1zvaSizPSM
  ktzEzBy9xCrdRL3UUt28/KKSDF1DvcTyYr3U4mK94src5JwUvbzUkk2MwFBPKU7l3MG4su+v3
  iFGSQ4mJVFey3CpFCG+pPyUyozE4oz4otKc1OJDjDIcHEoSvE9WAeUEi1LTUyvSMnOAcQeTlu
  DgURLhTawFSvMWFyTmFmemQ6ROMSpKifNmrAFKCIAkMkrz4NpgsX6JUVZKmJeRgYFBiKcgtSg
  3swRV/hWjOAejkjBvDsgUnsy8Erjpr4AWMwEtjpshAbK4JBEhJdXA1GH69Y3C2o3s53i+BJvl
  HJj4wXDdj5tJhbePbP+QtuLeMQEjb0uWMgEjpYxHC7meWEvPfrBsy50J5RmH0y3efVP5N9FWf
  MP894/Y3pcrhH47Flal0RyzK3z6lI9zvlzWfjxR+87koNjmifm58+SZNJc9TWZrap7y0ExGf8
  2+ruzMN5teWG2sDVz8TmPzj+0brPbcXNT56NJipVsHPr9cWD1dbH1Etr3mS951/LWuQdMrQjL
  f7Dy7OmlZUPeFW+H7m5QEnjcuCdlxVHPa3keetr6seXeTbfjOxrCdSdtxc8a8Re0/1h/un7lX
  gqs8uP0e26FbH/OXpzy8+CSW7bD3NNm8zWG+rx3m2axMbIv9kLFGiaU4I9FQi7moOBEAmJaxw
  nADAAA=
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-8.tower-732.messagelabs.com!1679469983!87011!1
X-Originating-IP: [62.60.8.179]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.104.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 1604 invoked from network); 22 Mar 2023 07:26:24 -0000
Received: from unknown (HELO n03ukasimr04.n03.fujitsu.local) (62.60.8.179)
  by server-8.tower-732.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 22 Mar 2023 07:26:24 -0000
Received: from n03ukasimr04.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTP id 64174156;
	Wed, 22 Mar 2023 07:26:23 +0000 (GMT)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTPS id 57876150;
	Wed, 22 Mar 2023 07:26:23 +0000 (GMT)
Received: from 5296b475fe58.g08.fujitsu.local (10.167.234.230) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Wed, 22 Mar 2023 07:26:20 +0000
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <willy@infradead.org>, <jack@suse.cz>,
	<akpm@linux-foundation.org>
Subject: [PATCH] fsdax: dedupe should compare the min of two iters' length
Date: Wed, 22 Mar 2023 07:25:58 +0000
Message-ID: <1679469958-2-1-git-send-email-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.234.230]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP

In an dedupe corporation iter loop, the length of iomap_iter decreases
because it implies the remaining length after each iteration.  The
compare function should use the min length of the current iters, not the
total length.

Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 3e457a16c7d1..9800b93ee14d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2022,8 +2022,8 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 
 	while ((ret = iomap_iter(&src_iter, ops)) > 0 &&
 	       (ret = iomap_iter(&dst_iter, ops)) > 0) {
-		compared = dax_range_compare_iter(&src_iter, &dst_iter, len,
-						  same);
+		compared = dax_range_compare_iter(&src_iter, &dst_iter,
+				min(src_iter.len, dst_iter.len), same);
 		if (compared < 0)
 			return ret;
 		src_iter.processed = dst_iter.processed = compared;
-- 
2.39.2

