Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF99DC2FD
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 00:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780620827; cv=none; b=LgRzA0IVECv/6NYX6qk/SrLHxzsCquQ9iR6fGRXSQDnpNEAsYHK2/ZXA5QyETsnvZzbj+pB/V2akvH3AnUKwRP3aJN3drAw5wJcYfEPIQRme/3svrmnBclgiXxz3LQfidN4Q5M9jLQPHbcBOoHh3Fx9aTJPNdgG+X/u7WLtOrF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780620827; c=relaxed/simple;
	bh=PFav5VD2/Lbfe2U2C3+G1yrwwL6GfFTbD3BIzNoEnag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=erNIzfiicT0F0tYTGlLiF5cta6/RSNIf6ncQe8CJnckKGN3Ml83Da0tUx4QICgAQ6Nf3rqS9N9zJngQoxd/PmFDv3UG5UubsmRsz743Q9YhNqVZsVgrqCFOXKWPxZWwotwLsU+sxk8kHiqHzb+NgO7Jk1+LeP/GYoalRnqG4eF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=iFEFXGup; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="iFEFXGup"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5175b6c4e19so15188281cf.0
        for <nvdimm@lists.linux.dev>; Thu, 04 Jun 2026 17:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780620825; x=1781225625; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c/lu4bYahy0yJMEjoPlQrT63mxbKgUzB2AcPTpyaOp8=;
        b=iFEFXGupNZv+fauvWfKQHjarHo4GT/vmS7dYOxAdBEsq5dIQOQ/rDALdjrk8vq0IX1
         0wkX3hLSmmSGK9AQwCi/Z7jUnyPg86EQEC5rKHwwOvmRCr58+ymypmIvXoNiwLBu4V8d
         zUL3oUVFLqo1Q0ACT0XZYCxnKwv7oUP6C6101tNMmvTbBlAhYooXnna7y1+LLAqIovWJ
         hZn7UTMk8OR3WPVDELW2Wp3CNEgoYZ99WxfuYCAr2Ab4vnpufwL/upV8mrCOdIMGKKg/
         7fBl2HZl3OHJhY8tPwiO02oPKVS37J+tXCi4y1vGfebkREIYnIpik3ySfXeQZ2wPXMrg
         Tf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780620825; x=1781225625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/lu4bYahy0yJMEjoPlQrT63mxbKgUzB2AcPTpyaOp8=;
        b=KtwjV9XModov47RzaZgYUdxXTTeW86sCsbYJKc/phZUOr58szq+2zjR5WsCqOV/3df
         S+F7DJpWS9qLJAwGHU0c/mdKX8MGQ6rWOHKaJbb7t4kze/eNXNvS4FnzaFxs66IeCUAm
         Fy8NJEXgBxhk4gRVIF/XLoMKUTkCczAUurXS+qmdPq6w5FamL4r1kbjNQ1QrkJKWGUl/
         Rsk/ednpa0gevAqjfKYLIfbUOjS1Y/O6YkJZzPOQoKao6FEXzVQ15qyvSxY4SKcNz5M3
         nooEoYesGcYE4iCrM55b9/2VG866SprszOQkdNiyqpsvcR+I0HX/khEagAQz8tAvoP2V
         mKhA==
X-Forwarded-Encrypted: i=1; AFNElJ+Mt2jjdr5POaISy+d5b7d5cu94AFcNSURW04EP31fGBiwEQRD0RXag12b6lgFSS7ax9ZWCTfQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7nIPhCyaRUeRS8ITi989N4O+18NWRttfp0ffP5t3Wil5SHSkN
	KXHZhlhSI+g9Wj4fyyQJPTXt9rv+8dHxwXIeBE6UQxZ9lm6wzYRa2cVGcFkIvcQS2mE=
X-Gm-Gg: Acq92OHn7zsmgvdpde9theA2SPLvjUO8RotY5xNumvILorh5uvRpLIookm1SetVpNhP
	7GoTFbF45waSM1r8OkIZy5JgVgSBA74jWiQM+x/lxL6oqXNmdL3ntxsZx+Mfin0x7te2Tgx3Q29
	62VqYx8p8TnVBZ4vplFQkxX9+CRg9g1IiperTnd035aIo3Z9NlBDkEtZKVM/mVlyGrQf3HLBmB0
	LqSPn2uJ5AMp4NuEoh0v8V2dizv0VPiF/cFZGq5qkUZQ6mmU+g1VuWAqeGQ0Iq+4Uy/HgsaAjP3
	l4zQ9WAcJC24ZcMfMihWmlBreHBjEffRcm+mFTpgh8MwNEw5Poa7zIGpw+eGaud0NkZ3WA7LzcG
	CK+T/RlqFKtyPd/c6dCWcuq6cR80SsNkxfOEf5ZgU0BErMok0L2OT/J+n1DNBXrTO0otZCA5yrZ
	Ac0/JpGW/S2FuSb0U3jaYdCdWeu3CCugZIN/vyVg==
X-Received: by 2002:a05:622a:251b:b0:516:c9f2:a9f0 with SMTP id d75a77b69052e-51795c6b1dcmr17503151cf.30.1780620824662;
        Thu, 04 Jun 2026 17:53:44 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-51775da6f41sm63506761cf.22.2026.06.04.17.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 17:53:44 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Dan Williams <djbw@kernel.org>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	nvdimm@lists.linux.dev (open list:LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] nvdimm: ndtest: reject wrapped config-data offsets
Date: Fri,  5 Jun 2026 00:53:36 +0000
Message-ID: <20260605005341.2051848-1-sam.moelius@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ndtest provider validates get/set config-data requests by adding the
ioctl-provided offset and length and comparing the result against
LABEL_SIZE. That addition can wrap, so an offset such as U32_MAX with a
one-byte length passes validation and then copies from or to
label_area + U32_MAX.

Validate the command buffer shape, then validate the offset first and
validate the length against the remaining label area so wrapped ranges
are rejected before the copy. Report the rejection through the command
status field so the DIMM ioctl ABI returns a nonzero command status
instead of faulting.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 tools/testing/nvdimm/test/ndtest.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 8e3b6be53839..1df93f5e4cb6 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -207,9 +207,15 @@ static int ndtest_config_get(struct ndtest_dimm *p, unsigned int buf_len,
 {
 	unsigned int len;
 
-	if ((hdr->in_offset + hdr->in_length) > LABEL_SIZE)
+	if (buf_len < sizeof(*hdr) || hdr->in_length > buf_len - sizeof(*hdr))
 		return -EINVAL;
 
+	if (hdr->in_offset > LABEL_SIZE ||
+	    hdr->in_length > LABEL_SIZE - hdr->in_offset) {
+		hdr->status = -EINVAL;
+		return 0;
+	}
+
 	hdr->status = 0;
 	len = min(hdr->in_length, LABEL_SIZE - hdr->in_offset);
 	memcpy(hdr->out_buf, p->label_area + hdr->in_offset, len);
@@ -221,10 +227,20 @@ static int ndtest_config_set(struct ndtest_dimm *p, unsigned int buf_len,
 			     struct nd_cmd_set_config_hdr *hdr)
 {
 	unsigned int len;
+	u32 *status;
 
-	if ((hdr->in_offset + hdr->in_length) > LABEL_SIZE)
+	if (buf_len < sizeof(*hdr) + sizeof(*status) ||
+	    hdr->in_length > buf_len - sizeof(*hdr) - sizeof(*status))
 		return -EINVAL;
 
+	status = (void *)hdr + sizeof(*hdr) + hdr->in_length;
+	if (hdr->in_offset > LABEL_SIZE ||
+	    hdr->in_length > LABEL_SIZE - hdr->in_offset) {
+		*status = -EINVAL;
+		return 0;
+	}
+
+	*status = 0;
 	len = min(hdr->in_length, LABEL_SIZE - hdr->in_offset);
 	memcpy(p->label_area + hdr->in_offset, hdr->in_buf, len);
 
-- 
2.43.0

