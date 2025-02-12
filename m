Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805571DBB38
	for <nvdimm@lists.linux.dev>; Wed, 12 Feb 2025 03:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331634; cv=none; b=rrm/gUUfUJBguvrjmfCUhCclbcvJ48mMDslcwDpfdMmVM1q3LdWoN001cEYsbyagFm1xMxa/qfD/YI/A7y3za3Qe0frDVx4KF0b3/TewqNvTK7hN/wSK/vZDIMtiaprNGTlvm94shHlslZ25YxJDN/CjYHsyUBj2h4bK3dWd0vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331634; c=relaxed/simple;
	bh=olWb4Ge3N8pQQvBsFlvwfp1BUggkkgscabm569GwSQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sg6cOoYqTkqYR8ejx/hl4lo5wgeiPfmiji3DZRHePjJ7/OSmMOTQutkcwA7lLqx03VddfGqD8+yTRtIsfq44r3GYWDmpqIfnFz2LORhsko+glWmETZxQrRsOq5EQumrmThHrn4fQu97nOLxPTdwdR7mvk7sta4z7mPgizgSmFmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ff2faM3V; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ff2faM3V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739331632; x=1770867632;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=olWb4Ge3N8pQQvBsFlvwfp1BUggkkgscabm569GwSQ4=;
  b=Ff2faM3VNlvHjw0rJiz5tlZCkTp2m5VFkuruueBNPU1tzeaP9RcrywDc
   1ytD7pBMUABo5dDL8GeGnpXHeQaCMOt+1QCRhzAIwOw+Hd06HdkZj+JZ+
   bbpgLzpNuVwt3AcQDAPFwBWzn/k09Md7JG/WiSk9VFPjIn3dMHAixArDD
   jyNZhX5C0mjw8OPkkitLRLgCLQdAH0E25+xcBJv7rtT872lOKXfMOW4si
   aBscqFFWgTpD0plpywlR8FRWlVNfIzJ2MhHsFrTkdDLd8hlMUf4o8nNJ0
   EwL0XGKB+0iBN+GzYS4CebZa0Bzkzvk0p3/22SaWQGcpCnqCQAqtPUWSY
   w==;
X-CSE-ConnectionGUID: DTV5EqPaQai/Z96dt0NgtQ==
X-CSE-MsgGUID: AZVFJ8MNQxOYNAY0SnWUsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="39995045"
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="39995045"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 19:40:31 -0800
X-CSE-ConnectionGUID: dZAAkGiHR2epNYeJ17q3kw==
X-CSE-MsgGUID: yrzbCPdPTyyeKGo98FhIfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112557115"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.108.39])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 19:40:30 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] util/strbuf: remove unused cli infrastructure imports
Date: Tue, 11 Feb 2025 19:40:18 -0800
Message-ID: <20250212034020.1865719-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The ndctl cli interface is built around an imported perf cli
infrastructure which was originally from git. [1]

A recent static analysis scan exposed an integer overflow issue in
sysbuf_read() and although that is fixable, the function is not used
in ndctl. Further examination revealed additional unused functionality
in the string buffer handling import and a subset of that has already
been obsoleted from the perf cli.

In the interest of not maintaining unused code, remove the unused code
in util/strbuf.h,c. Ndctl, including cxl-cli and daxctl, are mature
cli's so it seems ok to let this functionality go after 14 years.

In the interest of not touching what is not causing an issue, the
entirety of the original import was not reviewed at this time.

[1] 91677390f9e6 ("ndctl: import cli infrastructure from perf")

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 util/strbuf.c | 51 ---------------------------------------------------
 util/strbuf.h |  7 -------
 2 files changed, 58 deletions(-)

diff --git a/util/strbuf.c b/util/strbuf.c
index 6c8752562720..16fc847dd1c7 100644
--- a/util/strbuf.c
+++ b/util/strbuf.c
@@ -60,30 +60,6 @@ void strbuf_grow(struct strbuf *sb, size_t extra)
 	ALLOC_GROW(sb->buf, sb->len + extra + 1, sb->alloc);
 }
 
-static void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
-				   const void *data, size_t dlen)
-{
-	if (pos + len < pos)
-		die("you want to use way too much memory");
-	if (pos > sb->len)
-		die("`pos' is too far after the end of the buffer");
-	if (pos + len > sb->len)
-		die("`pos + len' is too far after the end of the buffer");
-
-	if (dlen >= len)
-		strbuf_grow(sb, dlen - len);
-	memmove(sb->buf + pos + dlen,
-			sb->buf + pos + len,
-			sb->len - pos - len);
-	memcpy(sb->buf + pos, data, dlen);
-	strbuf_setlen(sb, sb->len + dlen - len);
-}
-
-void strbuf_remove(struct strbuf *sb, size_t pos, size_t len)
-{
-	strbuf_splice(sb, pos, len, NULL, 0);
-}
-
 void strbuf_add(struct strbuf *sb, const void *data, size_t len)
 {
 	strbuf_grow(sb, len);
@@ -114,30 +90,3 @@ void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
 	}
 	strbuf_setlen(sb, sb->len + len);
 }
-
-ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
-{
-	size_t oldlen = sb->len;
-	size_t oldalloc = sb->alloc;
-
-	strbuf_grow(sb, hint ? hint : 8192);
-	for (;;) {
-		ssize_t cnt;
-
-		cnt = read(fd, sb->buf + sb->len, sb->alloc - sb->len - 1);
-		if (cnt < 0) {
-			if (oldalloc == 0)
-				strbuf_release(sb);
-			else
-				strbuf_setlen(sb, oldlen);
-			return -1;
-		}
-		if (!cnt)
-			break;
-		sb->len += cnt;
-		strbuf_grow(sb, 8192);
-	}
-
-	sb->buf[sb->len] = '\0';
-	return sb->len - oldlen;
-}
diff --git a/util/strbuf.h b/util/strbuf.h
index c9b7d2ef5cf8..3f810a5de8d7 100644
--- a/util/strbuf.h
+++ b/util/strbuf.h
@@ -56,7 +56,6 @@ struct strbuf {
 #define STRBUF_INIT  { 0, 0, strbuf_slopbuf }
 
 /*----- strbuf life cycle -----*/
-extern void strbuf_init(struct strbuf *buf, ssize_t hint);
 extern void strbuf_release(struct strbuf *);
 extern char *strbuf_detach(struct strbuf *, size_t *);
 
@@ -81,9 +80,6 @@ static inline void strbuf_addch(struct strbuf *sb, int c) {
 	sb->buf[sb->len++] = c;
 	sb->buf[sb->len] = '\0';
 }
-
-extern void strbuf_remove(struct strbuf *, size_t pos, size_t len);
-
 extern void strbuf_add(struct strbuf *, const void *, size_t);
 static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
 	strbuf_add(sb, s, strlen(s));
@@ -92,7 +88,4 @@ static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
 __attribute__((format(printf,2,3)))
 extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
 
-/* XXX: if read fails, any partial read is undone */
-extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
-
 #endif /* __NDCTL_STRBUF_H */

base-commit: a3d56f0ca5679b7c78090c1a8b0b9f1f9901e5e0
-- 
2.37.3

