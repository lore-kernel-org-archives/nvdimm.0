Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB972FE583
	for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 21:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761339940; cv=none; b=MiPTVeVZluEPtyWGWgaPHL73+bqkWEB8QNvYMPAK9SfLoLOjixDpcESpbafbkSlAMJMtJWJ8Pe/LvXiisYcYer7hKxtiUXKDf+JCaPNRyafqTwcA/p/p7HO5a3aNLTx/nVuzhiWyhW6Hfw3uOpjnCQWaiY2eLO7Uq6U9755LG/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761339940; c=relaxed/simple;
	bh=iZaLtX3BgeruWBIIuF6rywebvdAOWRxMNZoMuebQSVQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jomHdcd/WbjIdkntYzZ0V2QQtCRvaIvH0MQvU/0mRsYwHXVojK2GCOf9PzHo6VqKDJ/D/uWgcrtgaP6x/yyBwb0HvY6OBvigTxX7hFayljSvBzrWQvFd1s14FxF6oWY26p2pwjMVgUxLWn0gfQX0q0TnP3Bn5ix5srEhpGPme3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yPtYb6UM; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yPtYb6UM"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b3cd833e7b5so279418966b.3
        for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 14:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761339937; x=1761944737; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ds0NdqUYXASBVzHzkeWNidjXkrqGljV6rpvXJEwlSc=;
        b=yPtYb6UMuPTEVAUPsmDaxlLYeL54e/a2BzMoT9TbyL6VIJTg9zXud6yYB7hLrejSPd
         LUSzMQAdOY33qXQaD17NCD0b/3o4V06RvyzvUZI9CwawHSuDO/pH6eLkdSpRrP3JhBX8
         XI7T0pnquff1PsDdVZvQUjsLsOG5cYl7O/xrPsJmWfS4sEwABL1Vbv9sGPtHhz+HhPyL
         5lnFrjDulMRI6qdBzFl7ztCe5Jzq3hUM9ju33sSOtFCp8UJu1x+IB3XtFkNfVoIqck+D
         PirCVK3ruXbnHkej0QNWaKgiFxHBz5GOsg49AvHb9jbBX4pH6YQGC51d5+GkhcUDQNXN
         Hldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761339937; x=1761944737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ds0NdqUYXASBVzHzkeWNidjXkrqGljV6rpvXJEwlSc=;
        b=QJpg6cvC8mURUeNKbnAiNsPKSBtlv50mOKX8bfUN4Ml2m/yy3XdGBKO0ucC7shq90n
         DVkxv3EP+8bEmvYI1loe3jQRdXlRbM6t0b1nenvwZfHI4BW2DQbcyJnfp1cCCtm28qCN
         NbnhlpGgFIPsoQxAH+GSS1xymsdfgwIqRl+ex7a+JAKev0CXpBWPW73w6U2Nq4uyZ82G
         SDoim5rkOnPMr6iVDOd/khHU86uw+qdXj9F6Uo8qbVle18hx43YKbXZu38A5mHyfucr8
         oqNEDdYlN+Bv4BfNXLWw1M5eiBMfhataTYVSyMrFq2RPLfTb+uV6vdvhhXqtcoVckeNs
         JRcg==
X-Forwarded-Encrypted: i=1; AJvYcCVRf7u/fllWJJpx2u5XkCuMxL9/r77STfR/gdytj5/u6cdUHTl6q/WCd4wK68vDbMUVzijnjyY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHek9qI/PhlnEgbLIgUZrvGYvCVrSD6LuYHdKKZn54mSe+kMQh
	1oDF3HexDX5b6ZOrYlkw8SVUFNcxQBjqQjf5CP4gkHBzmjYkSjws30VzjvfdctC0PF03jJy080m
	ZNQogywnJVlGIytB1sKwn8w==
X-Google-Smtp-Source: AGHT+IGFm0bKZf5luxEJnL4z4gMCnARfFasz39nHCFyvwVkRdTLaWDrTQIZRmknslrT4lvlOpHdDBmT1yTh40GS+
X-Received: from ejdm12.prod.google.com ([2002:a17:906:160c:b0:b5b:905b:ffa3])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c28:b0:b3f:f207:b754 with SMTP id a640c23a62f3a-b6474941139mr3593500766b.30.1761339937274;
 Fri, 24 Oct 2025 14:05:37 -0700 (PDT)
Date: Fri, 24 Oct 2025 23:05:15 +0200
In-Reply-To: <20251024210518.2126504-1-mclapinski@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251024210518.2126504-1-mclapinski@google.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
Message-ID: <20251024210518.2126504-3-mclapinski@google.com>
Subject: [PATCH v3 2/5] dax: add PROBE_PREFER_ASYNCHRONOUS to the kmem driver
From: Michal Clapinski <mclapinski@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/kmem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..4bfaab2cb728 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -274,6 +274,9 @@ static struct dax_device_driver device_dax_kmem_driver = {
 	.probe = dev_dax_kmem_probe,
 	.remove = dev_dax_kmem_remove,
 	.type = DAXDRV_KMEM_TYPE,
+	.drv = {
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+	},
 };
 
 static int __init dax_kmem_init(void)
-- 
2.51.1.821.gb6fe4d2222-goog

