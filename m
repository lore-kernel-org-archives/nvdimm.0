Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B1541837E
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 02:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791858688; cv=none; b=KlJu+V4W25BGy4TiRsOyhSpWheedovhTvm3i9+J1VPFSyZLHqJdFBPS1fcmrHm6sEzwyoeh8qoOPtRoIXR61x7FvgoaUuVKZCJkZWQ5nzGWnjFt756lnuyiSBUfzPh2JbAjrlOpJDkWdB05QVhx0HdXR0Ibz6LRb3M5uqdYKvq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791858688; c=relaxed/simple;
	bh=v5tONA2LxrOLSUjqd88pbtiKH2gaZjORspEuhh6aOns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oyIteaUimHNC+jkChFWmNlgRpZjWyRAtZttElgjHbtwFf+MTHz730veSV47LMqUvYRhgaBTLnqmwHzI8n4PL/mMm2f+zcpJXOhTT+Onp0ub1TedA4wpX/iRy+hiyN7g7+s8fDSGG7nv/Op9/JbzQHgVNI16FRKXytMN17iAUe54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pGf/Af0V; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pGf/Af0V"
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3ab86ae9b80so984109a91.1
        for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 19:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791858686; x=1792463486; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v5tONA2LxrOLSUjqd88pbtiKH2gaZjORspEuhh6aOns=;
        b=pGf/Af0VKYaeRlLmvRuD+4HM2ZJYwQbOi9E/UWgoDJxAwa/yBk6XdysbGPzqsNbTjR
         5+XnMOv/YSmQK2OkhZcp5DRAwx0yAcF+PX6jpP9Rzp+iCDaItPuqQkKEK2cF7mom7I1q
         jdBykPmVMNmmr8mMqyb145wau73k+I9J/+asKK3jd2Ps7TngnEBlbRjOvPU210omCO5i
         sTRUiuLfmJ55emCClM+KPKpajCrnqjYLYnm61Wh8/nM0DXLc1h/8yqRVuBNfBqBGEIPJ
         gv68iJ0X8rAFI0jjJXoiFnKxxH2jFi4GxRhg0bjzv1ZM7Pi39WDTAvBwFv22EFnBDXH5
         RoKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791858686; x=1792463486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v5tONA2LxrOLSUjqd88pbtiKH2gaZjORspEuhh6aOns=;
        b=G87HMIOPMgOk4a042+bsOLzHvGvjSzyikA4oZeNf0E/GR0q7Lm0Ga4CkiMsVkVus3C
         HN0CKEk4BkGey2kneq3KEdisOmMY/ZWrUyFCwWwNEuusHJaUrVJ6qMAZNXlL1KH6igPe
         XK1OOuwJidnr3OnH5XISdiktD5V2JEAlpvSU/ZX/kJvISTslJMr05sk2hsSTeDYOaqvj
         26N35CV6dl7GEqI4MCc6+aL+z7JORNiJs2D5baLSAIQVmm4Ycxl1pc7qzU7l1ydeUExs
         LjEcUcvkwNEj5WEjVCwpEMiL/bIKufetVNZYuBDS4/yZ+KrDq1QBWKiGnaNTqzR0Ab47
         fs/w==
X-Forwarded-Encrypted: i=1; AKwUvBzOS5smLzDRTYd23p9hF/db0c8O5eUrw8izfKGIoV1VXtgKSKBTuj4X4QOTP+SuLY/4JIqf9hw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLaEwdcoaImDsXC3K9TYKHi4QYKSNUFOtCu/77DAffSAZBN2LwG
	k21MrEVuEZOnzh5iLdDxwxJL5qH8exKzEzCIv61NKQ9UYQ4X7neNCIva
X-Gm-Gg: AYBFou1UwBl+cMWy3mRdkvXXfX7mmRUQkYgYIb5A8ithn2tbbpJj9FeEkQ1ubqxUIZE
	W5Eqn3zHbmi/eejenMtdMwTp/dwyH5wOdZeHAfXWCXoXFfmJh0CvmXygL0hD/PNGVMq5ewlnafR
	L5BFr2mDWSiOS/4Fy1WPogt7jZiyqd5ALA07FXSrFRV2BWNkT769oQhOhnXwkmp1hei4QR6EBcx
	yCa0Sw8N8B5QqqLo5rtNmusdwJDHYTZ5x4yy/tXXR1xyJz+dqPZvd8L5XokGJez+0tTsQMtohdT
	2oB64xA71opDIeZPZt5y1djclhyzN31ObXu8f8xyeRv5mL5XIr73Rzr9fK8s7cEywPeoVRgqZuf
	qgorb/y6CdDIOJdqoxAZknnpYeiJQfiKvg0qbVnYoRX5CELBMByS7FFc00ALSEu9X2+FN3baE3d
	IaUrbxLKGEcFLMU6J7FltCxKXD4UyQK4gNXo983IYmcc/hUaPZLZqvK0f203f+IG7z25LVnhwfI
	KYcrz8kubymTi37BRcsDINF4KMfijpe9XnEAsGOvQ4dFOMX3NnavvZiLl6jS83/OwDZABxv5tjo
	sz3uF2N6hRRaqoRnX01DGzM+5hyPs+Ys1jb84ppd
X-Received: by 2002:a05:6a00:8019:b0:886:84c7:72b3 with SMTP id d2e1a72fcca58-897c78d79d0mr9188887b3a.26.1791858686286;
        Mon, 12 Oct 2026 19:31:26 -0700 (PDT)
Received: from localhost (ec2-13-231-150-91.ap-northeast-1.compute.amazonaws.com. [13.231.150.91])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c310738dsm4513065b3a.16.2026.10.12.19.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 19:31:25 -0700 (PDT)
From: jianyungao89@gmail.com
To: songmuchun@bytedance.com
Cc: akpm@linux-foundation.org,
	alison.schofield@intel.com,
	dave.jiang@intel.com,
	djbw@kernel.org,
	joao.m.martins@oracle.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev,
	nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com,
	Jianyun Gao <jianyungao89@gmail.com>
Subject: Re: [PATCH v3 1/2] dax/bus: fix mapping attribute error reporting
Date: Tue, 13 Oct 2026 10:31:21 +0800
Message-Id: <20261013023121.11036-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924025035.1265035-2-songmuchun@bytedance.com>
References: <20260924025035.1265035-2-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianyun Gao <jianyungao89@gmail.com>

This patch also fixes the mapping_store() error return issue I reported.
The fix looks correct to me.

Reviewed-by: Jianyun Gao <jianyungao89@gmail.com>
