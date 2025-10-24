Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC92FFDD4
	for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 21:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761339946; cv=none; b=C7jWaJK5eow97uzLc+LB1iz5PK3ZJsnD58VQYcLQw5xbf08Aj3ySrcIPHeyKaVZQ4i+oTcXxvHzD9dikDPlSMMATPnueS8g8puJr8Q4fZxozXX+ThJb4C4/0dwbiPc7DmV4+bmMF92kTzicJWidQ4WuTX0/sQAYziVNWADotYTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761339946; c=relaxed/simple;
	bh=Sk7FXCfhyYx52fhTC+oVdW7154ngTvS7Nom9mMmbUho=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nsJ9GMSYvDg5WxoIWJgz4kk1pw47vgR+5rz8xrsxKrTzgippHpOaXNzNzXRldiNaNW5W5aNUTVRPwv0ueZjqqUyzTeoK3r2p0LCd7ukMbjMvLPzn4SL966PKCsSOTE0ZGTPXldICjKiz/Gs15ZTFXLmrmQmxLSUPC32r8XelZCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FLSnVnfe; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FLSnVnfe"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47113dcc15dso14236455e9.1
        for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 14:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761339943; x=1761944743; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cr+Cy44AYBoCkgjbDfs6NtFid05XxsG/awplIO2CaC8=;
        b=FLSnVnfeRwhkAXeU4jM8bs3AysJ3vLIWs9CeHTS79kTgvdS7Lbq6KzaatbsdXitpvt
         sDdOqKnPuKH4apwtr/5PqO2VrnS3Hv+DMTM3DaLgjjOXMyTH0GkLGrk1SswXD87OEdbM
         KRI83MPuYufHiaayEEpgCQaTFWvFABDx2yrP8GXLVldsS2v0poFNJqVngqRXuAsfAvJR
         DsygiZbQKSOexF6GNpPJcmOi8ToYpGt72943M6KGHLFtbbofYQ4V/OMviWdhj5tICqFm
         78guXcGT+tTxJrsDRXOCiu3VLiRNEI3cZHI+pb843d1l6MCHW4fSe81eSBSTfue/w/WB
         Ui5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761339943; x=1761944743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cr+Cy44AYBoCkgjbDfs6NtFid05XxsG/awplIO2CaC8=;
        b=MxPq8GyyhmuAPRzhzslJ7CvkJTnStvycJkzhEwXLZX83N6t2CerMnONbTW5JkyTw6D
         phpiAdOelHEI9JJcuG/UjwbX/D/7UdC0bRsLA8ZCLAxb80LCWM6kFuFRashurVvlw7b5
         Noh6s+abq37SnBAx8/LJHu4gR85oGlZsXh8nlOS0psEOApdyH03cxUrMlGTilvvDfKZb
         eivuZwQ/zkrIMXCQ6zZBCXYbOy9rak1zw1uCLFmK320204SxfUK4aaIz1B1Eu3+d/rSS
         B3NplA/DVU1wUIUzLnUMK+MjDzsTiCIqrtopDJ/z8ajJmb96IXHD5qCQp+uh2F31tNrl
         eR0A==
X-Forwarded-Encrypted: i=1; AJvYcCWMxcouZSkLNzsxK3BhQI3E/nYXktW2Une7tnzwXs+ABmSg81g2H6PZ2y9+IKbHY0zmrmcHlas=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnhSZEj1vMPGAtBta0WCQ0KJPu6m8nhu3nlEsxajXSTucRnL2Z
	Yj55BqnjnZInNH3c5Do+XmxBOHjs8i+TNn7T8/5aTFUEOdmuJft5WYJZLVVMKcYB1cbRhjOskaC
	Os4a7IV+MrUoPkaK7/3bmVQ==
X-Google-Smtp-Source: AGHT+IE0VF5/lk9M0gB+9FwFwSpgfvP2xoVnB0QJD8xhVyJZbghsyqA7z63NaA5pNd/HN1prAz26F2QKnP+cnxCu
X-Received: from wmwr4.prod.google.com ([2002:a05:600d:8384:b0:46e:3d73:fc5f])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b0c:b0:471:58f:601f with SMTP id 5b1f17b1804b1-47117912389mr234934035e9.30.1761339943347;
 Fri, 24 Oct 2025 14:05:43 -0700 (PDT)
Date: Fri, 24 Oct 2025 23:05:17 +0200
In-Reply-To: <20251024210518.2126504-1-mclapinski@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251024210518.2126504-1-mclapinski@google.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
Message-ID: <20251024210518.2126504-5-mclapinski@google.com>
Subject: [PATCH v3 4/5] dax: add PROBE_PREFER_ASYNCHRONOUS to the hmem drivers
From: Michal Clapinski <mclapinski@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/hmem/hmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index c18451a37e4f..5a6d99d90f77 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -45,6 +45,7 @@ static struct platform_driver dax_hmem_driver = {
 	.probe = dax_hmem_probe,
 	.driver = {
 		.name = "hmem",
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
@@ -131,6 +132,7 @@ static struct platform_driver dax_hmem_platform_driver = {
 	.probe = dax_hmem_platform_probe,
 	.driver = {
 		.name = "hmem_platform",
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
-- 
2.51.1.821.gb6fe4d2222-goog

