Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B52E5B27
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773885142; cv=none; b=kl9fwW/X0mh/1oplWxU00688p6/hWvmURK581UvfKCKPgCkwkRglzxiYk5kTBd2fCBzVdIO4kBAcAFci8nUSgcPDj7V3jOnHE1j7fG29A6e9mHs7TLysGgPdb2JK1/yS+jCjvY6OPQwBysYKZHMg+W8ImFl4pb0Alz8klGpXgVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773885142; c=relaxed/simple;
	bh=rgC9DStqBfJFT1UlDGjnvr7xudC81up4XbpM8FM5Oao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sG4Z8+9nL4vERxn22v+83/AxWhiakK3+wOmHqBoP1HL6V4BDp+TpBTHcFxkt+5D3pZn1WjQUpLZ3iTF648rG7VN+U263QqvViqEt089L/ajrYYspYWS/h2ZBTpxeRU6487HtWOHZRZAn6ayzkr+cTOKgDj2PCKua2Q+Amt7r2qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c05lxN2P; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c05lxN2P"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773885134; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=BJ1i82gFeJikQlAcESElx1QhVYIhcLwM32ZM99x4Nlw=;
	b=c05lxN2PifQndtPJ2vGwIhAicPtEd6w3E4b8oNq47zTFMh9brb7SeEh0shT3fLYJAr88jn23ClRPyyz5Av30fBilqSJvVC71aj9YRSzxIfBCb4rYHVc5bXkk7LcOB4i5B6bvhjE6nkEaksNRzHGbZaDYVZvgF3cgOZKYDNhPuQo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X.GZWIo_1773885127;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X.GZWIo_1773885127 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 09:52:11 +0800
From: cp0613@linux.alibaba.com
To: alison.schofield@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Chen Pei <cp0613@linux.alibaba.com>
Subject: [ndctl PATCH v2] ndctl: Fix missing key_type parameter in ndctl_dimm_remove_key stub
Date: Thu, 19 Mar 2026 09:51:49 +0800
Message-ID: <20260319015149.13719-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Pei <cp0613@linux.alibaba.com>

When keyutils is disabled, the following compilation error occurs:

  ../ndctl/dimm.c: In function ‘action_remove_passphrase’:
  ../ndctl/dimm.c:1030:16: error: too many arguments to function ‘ndctl_dimm_remove_key’
   1030 |         return ndctl_dimm_remove_key(dimm, param.master_pass ? ND_MASTER_KEY :
        |                ^~~~~~~~~~~~~~~~~~~~~
  In file included from ../ndctl/dimm.c:25:
  ../ndctl/keys.h:51:19: note: declared here
     51 | static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
        |                   ^~~~~~~~~~~~~~~~~~~~~

This patch fixes the issue by adding the missing key_type parameter to
the stub declaration of ndctl_dimm_remove_key in keys.h, ensuring the
function signature matches its usage.

Fixes: a79375a9b0cd ("ndctl: Add  master-passphrase removal support")

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 ndctl/keys.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl/keys.h b/ndctl/keys.h
index ce71ff2..b60c209 100644
--- a/ndctl/keys.h
+++ b/ndctl/keys.h
@@ -48,7 +48,8 @@ static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 	return -EOPNOTSUPP;
 }
 
-static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
+static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.43.0

