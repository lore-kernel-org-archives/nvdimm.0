Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F7E1493B0
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710195; cv=none; b=baE2eaB3ir41thEEjtCezs0Oan/XcJHVrcdeU+geIpRJ5hImXDB/VwCnawKtgZKXG0eX2og3iAqZXbvIR0FhpRwwtDTTW1gEBZa7FsEm29c7rbWDqthiAhZHuK2WFY4MX79Wrqy289eyWzB5gDizeR9FHYNQrfUDmMBsF9+Hld4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710195; c=relaxed/simple;
	bh=VoCzY5krde0vG9xzX7YuziwxGBvoU+0AQ32A7C7kBBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rc12CMDCscTPWgX+1xIacHHt/IRxMjAfBsgc0Hkn/JWbdHNrUsH9mJD3PnAT1AHgWE13pJvzY/Or562vY4kAjJR//Mu2Szgy0XdvkDNn90ZNyJfnohPppNEnDuK4pPbFl9TW0PCgZYpEzWKB61jtpPQQ1i8nemefmW9dmaOpJCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DCZ0M97W; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCZ0M97W"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-21e3c16880fso564440fac.2
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710192; x=1709314992; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+jGr2qgI9ixdABJ86GK3tMFCGdZwdm8K72HznrZ7mbI=;
        b=DCZ0M97Wyk3yUjpGH4O9BmlPuXi69KPXE0p67P7BVwGZBlGu9f0mKGY8biSdf6LEt0
         z/YD8UwyR2In1136zLugYf09hto3Hoc7XP027fuhYrh/ROtLFUjxAbKY2H3q7GPXuNzr
         bAE7ekLWNdBZMwa3TweXpfSRdm+vIOM+8Lh/FwjviKY7Jp90mQm8hLGyUT927PCYM4xc
         MmQDqswlKCVnRGJwFyG1ZGv7vLrkQQ72gmFXAu709GHmU/EsMioXoMr/GBCbmFYf5BJk
         idltiexVbe45O6KL1VMA9C3GsAtxM92He3x+Lgs8R2aEAAr+DESfKFrVdpv5kQY3W8Qg
         s3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710192; x=1709314992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+jGr2qgI9ixdABJ86GK3tMFCGdZwdm8K72HznrZ7mbI=;
        b=njQtwFQBwWK6uc62JC41p9FZGmm3xCs7rZ5/EWCNoKPEqe2FKx/d3g+BAZVINuXg6p
         xpuWgszU1YRjzybs5ge4cInFH1k0ZqI4oJjDDFRnRgdw0n7WhcEUZNNoexjgncIQXb+N
         PeVkES2HwuLtWcdirIhCmCXWS3tz+XxObr71M1scpGwGnvVRyHppvzQTgXnpjB1ZvJ84
         uUdi2OOLGgYhzxOcI73f6FZdwUgYMO+nWZI+gqFIMO9Is8EZGZObbO3h85AwN5umaOum
         BeHjozWUCBYrFd0pRWm9xG7ymjyK4j/H/05I1s8zVHbSWcuKqvHunm0Kj96ck+pRn0nO
         J5eA==
X-Forwarded-Encrypted: i=1; AJvYcCXwH5tHDL+wvDTAzmBqTfzEV9pDrPdxqfDQiS7RvMLeLJCw2dxt9/VOSUSYpDvMEvbDdVoyDJSBKALJQafqBeOoDURcW/r/
X-Gm-Message-State: AOJu0YwN8ThCjxf6VJip5irb9aMFeAiCMJ9yNLgHWkgCNOAcHV+AN8kB
	rVMPUZ8SQfMH7kbXby0w5m/UbnwXwaS6f6ZgohgK2MxYWXz3EXcg
X-Google-Smtp-Source: AGHT+IHXbrGyG5qkT8Cy2XG92vn+Onolbp2qVyL5iQ2JVI9EfiggCFq+5eaMS2dVqFrORwDcrGzuZA==
X-Received: by 2002:a05:6871:431a:b0:21e:6716:65c4 with SMTP id lu26-20020a056871431a00b0021e671665c4mr576037oab.26.1708710192669;
        Fri, 23 Feb 2024 09:43:12 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.43.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:43:12 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John@Groves.net,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	John Groves <john@groves.net>
Subject: [RFC PATCH 19/20] famfs: Update MAINTAINERS file
Date: Fri, 23 Feb 2024 11:42:03 -0600
Message-Id: <451185e79c5b848d94eddaa3e778b834f7a35657.1708709155.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <cover.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces famfs into the MAINTAINERS file

Signed-off-by: John Groves <john@groves.net>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 73d898383e51..e4e8bf3602bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8097,6 +8097,17 @@ F:	Documentation/networking/failover.rst
 F:	include/net/failover.h
 F:	net/core/failover.c
 
+FAMFS
+M:	John Groves <jgroves@micron.com>
+M:	John Groves <John@Groves.net>
+M:	John Groves <john@jagalactic.com>
+L:	linux-cxl@vger.kernel.org
+L:	linux-fsdevel@vger.kernel.org
+S:	Supported
+F:	Documentation/filesystems/famfs.rst
+F:	fs/famfs
+F:	include/uapi/linux/famfs_ioctl.h
+
 FANOTIFY
 M:	Jan Kara <jack@suse.cz>
 R:	Amir Goldstein <amir73il@gmail.com>
-- 
2.43.0

