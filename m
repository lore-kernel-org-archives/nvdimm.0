Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2B94457B2
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 18:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745341; cv=none; b=XaoyCh1t7nBOBeCtZS/rIcnAGTDRhuuvavEdy6c389sYWnoV9/k/35SqcOyzGVr6neGEavHn+W7gVmRzPpArWl3Yph3krCLlADTfK5HuS8i3Nt+m40mqLUkZGmoQIRwbOxwti9KaAzRTfSDJ82rokWjtAWCMOvC2oMJHCc/pGgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745341; c=relaxed/simple;
	bh=4PQ5VCJ0pj1ClQf+gL1DN0rbtJDX7VFniSFaE/SsM8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5ia9Ejsg5Q4YfrME3l70iWnkra/ersuGnvUxx8Se3ruab/XqQ+gJXk7h7VusfEYkvx7e8hu6t63iFzB1gZP0BbXQzTqKb5oT5nVuYqhGKdIMy7R971kZJWUrx8HZBH+0zo1rP5jWxs3YWvOCBJ4bZjNa7hngetvj3CBjnCwo2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=JP0xCkls; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="JP0xCkls"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-907ae240ac3so13962716d6.0
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 11:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784745334; x=1785350134; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=enIHLWVARnnU4GIJ2wcKxnnWYjtcTdK3mCRnzCxbEg4=;
        b=JP0xCklsdRv0ArApEPrDGYqjWRwJIpS2GQXf4S0kbw2VQi+dNSrJ6W6fWKA6moPAL/
         FcxMFc6aNybW6gK5XDbhyFxiHr0NZ1vdNQygpybbcgdzdba/0MOyBPMtVv7s8E0pQhea
         9UO2xR9k2DTKudg3CUwUpF+kTEs/RQGLe8SZUY+Rf+eDaMYJ3ucsmVelapMc+kTefbhN
         5+zdMFEqfvcKRNVoTw56tfvr+plD6K13aBmNCYUV/paU9QRKFpmgO1/WAOtqVbIEVTTN
         oYomgDITqQRon5DXAPKD8s/0RmsyqYhqoosLayi2sFEgfpoQhRXoOS564t3QyCO+2fAn
         z/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745334; x=1785350134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=enIHLWVARnnU4GIJ2wcKxnnWYjtcTdK3mCRnzCxbEg4=;
        b=B5RkCNVmTeMiIFBhau+kinMbZPAUHUWgSRkTlt1HkWfhKgln1PMBIjqRiM1Gle9qqC
         T32XzseSuXfbe8KjGBmWxA6rNXx516cpStobPIByqZ/Q0OgHyKG5mzpmtWXv1I/R3sOd
         A6qhlDmBh2u1a7/9TmIl97tp8F7nS99tpJMU9oZCKRR7OIOkV1tFBylpyD39dicqSFBP
         KbxEUK07ZPcVC7Rd+xYsCcl7HqkRf2PdUrcQd3w90bOAuNKqEduXHvPyJvOWXF+ZuknJ
         C8WsBMLpYqZcVMhZbB5c89OllfSqrQgs4bQ63mDIqW3KOEdDswxPLtnDZD4YS1J6t5+N
         FKTQ==
X-Gm-Message-State: AOJu0YxGvV/doGosTrPgjo9m5fqmeWN9gzqvD2kMeR83HczaGoPkIbUW
	P21ASh8Mzzuq3UC2Sv/aoFo3J1BLfDqAuGUkPx7031tKkm3tPUNsTtIMA5ap1NGUvGg=
X-Gm-Gg: AR+sD12VCYBtJ9bybHIJN/jzUjMf9U2pIeTo6gVHgFqVPeq7I83qMl15ZX2WZkxGKVn
	qUGGyt2/BMmyOWnljJ+KCBjdzpmchWsNHSg2qr3+IpG77mKNMoY4bPyQEid6r/OikntjCzrSa+J
	kN4MR+/a3yxhWcN6k+GQu6mDxzA15mPOZoOMuXN0UF33FjhXwPWi+vEjQhR/ekDzLIuz3mQh/sV
	rA/u1Clq9KE249CGuaYw8bfkOZZ71XDJhOMpgON/fqMvstuqdVfxml08iDKAXuO3ORmsVXDTw/y
	DgNC3R7YMw0H2XFwax42CXxnpEbBZsiOMxRzpK7lpGhkWMhhVjTE5JNp5lVXTxaLToaDenrAwwD
	dJgkgtoaHVc15YZ392BXAU4WXWZsGN3vXKZmaMKhhujec8UjGh4ESzGdMj9MQc5l0s+bpGvu/Yk
	0/z0qHneVBPcSlbSyOl9E9xzhK4Du7zh6BeYyHfhhZw9Dk8QrlgluLuie+osprh0A=
X-Received: by 2002:a05:6214:5a0a:b0:8f2:3472:5b33 with SMTP id 6a1803df08f44-907ca5946b5mr229296d6.23.1784745334110;
        Wed, 22 Jul 2026 11:35:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b3e96sm27630216d6.1.2026.07.22.11.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:35:33 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Subject: [RFC PATCH 7/8] dax/kmem: add the ltpin opt-in (CAP_LTPIN) for private nodes
Date: Wed, 22 Jul 2026 14:35:18 -0400
Message-ID: <20260722183519.935213-8-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722183519.935213-1-gourry@gourry.net>
References: <20260722183519.935213-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add "ltpin" opt-in setting for NODE_PRIVATE_CAP_LTPIN so long-term GUP
pins (FOLL_LONGTERM) may target the node's folios.

Long-term pins block migration and hot-unplug indefinitely, so they are
refused on a private node unless it explicitly opts in.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 1cb3384c003e3..c33dac5939edd 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -633,6 +633,7 @@ KMEM_PRIVATE_CAP_ATTR(user_numa, NODE_PRIVATE_CAP_USER_NUMA);
 KMEM_PRIVATE_CAP_ATTR(hotunplug, NODE_PRIVATE_CAP_HOTUNPLUG);
 KMEM_PRIVATE_CAP_ATTR(demotion, NODE_PRIVATE_CAP_DEMOTION);
 KMEM_PRIVATE_CAP_ATTR(numa_balancing, NODE_PRIVATE_CAP_NUMA_BALANCING);
+KMEM_PRIVATE_CAP_ATTR(ltpin, NODE_PRIVATE_CAP_LTPIN);
 
 /* Per-service opt-ins. Visibility toggled by 'private' control */
 static struct attribute *dax_kmem_private_attrs[] = {
@@ -641,6 +642,7 @@ static struct attribute *dax_kmem_private_attrs[] = {
 	&dev_attr_hotunplug.attr,
 	&dev_attr_demotion.attr,
 	&dev_attr_numa_balancing.attr,
+	&dev_attr_ltpin.attr,
 	NULL,
 };
 static const struct attribute_group dax_kmem_private_group = {
-- 
2.53.0-Meta

