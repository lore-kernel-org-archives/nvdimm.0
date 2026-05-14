Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB932989B5
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 06:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778740368; cv=none; b=L4SWrZBpMNU5S2pVDnJZZkonXNUOaEhSe3QbOFX+znWoe9xDpp4C9s337Um/y7z3xqaOxWqFqGnG3t2Cm4JefAodIt2TRh9nr3pYdnzal+fAd6/W3Hdqh7tnCBVg9sMkfd0AEmq1jKUBCkoRuDUJUc6oix5t8gelw8wObyCaOJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778740368; c=relaxed/simple;
	bh=X1hE7BqOV+Uqb+Xv1LjAerDWx2AOiGdZmKf2szJBjC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGPUVz9fNPeQBXmyqLxOij3U+gnGfnQ+6auSd/O2FojcNBznsweTf2sDO+R7aL7GKHfIx/TSqpZWJ3f5jK3ZtI6zmU7vWsZASnq9KffDQRXuBESAs8RpPgUoJGC1Hqrw1BiESFTP1TK+dsym3UVmAtqZbMsPXklTOyBd6LfY9S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=IrsieS6S; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="IrsieS6S"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778740363; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=i3qMHxMDc252UMMxPYNRur2jE3phdXUdPBwsiIr0UNk=;
	b=IrsieS6SIeGNcr7v9pdAruI3iXS4g8fcg1P7F3SoFz7I6sDyS3YyvKxPJYHvJ5JdkVS9N6oZvz7BqyDdvAXqjQW4klea3FIFP+YSUa14Xei6ghsgwR8SdltHJUWnn8Wl41SYxF/F7qhGu1An271QDfcmMvC0+GlzbSsk/b5XOzo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X2vwT82_1778740362;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X2vwT82_1778740362 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 May 2026 14:32:42 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: alison.schofield@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	guoren@kernel.org,
	Chen Pei <cp0613@linux.alibaba.com>
Subject: [ndctl PATCH 1/2] daxctl: fix kmod reference leak on probe-insert failure
Date: Thu, 14 May 2026 14:32:33 +0800
Message-ID: <20260514063234.86439-2-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514063234.86439-1-cp0613@linux.alibaba.com>
References: <20260514063234.86439-1-cp0613@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

daxctl_insert_kmod_for_mode() obtains a kmod reference via
kmod_module_new_from_name() and only stores it in dev->module after a
successful kmod_module_probe_insert_module() call. On the failure path
the local reference was returned without being released, leaking one
reference per failed enable attempt.

Drop the reference before returning the error code.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 daxctl/lib/libdaxctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 02ae7e5..ffc81eb 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -927,6 +927,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
 			NULL, NULL, NULL, NULL);
 	if (rc < 0) {
 		err(ctx, "%s: insert failure: %d\n", devname, rc);
+		kmod_module_unref(kmod);
 		return rc;
 	}
 	dev->module = kmod;
-- 
2.43.0

