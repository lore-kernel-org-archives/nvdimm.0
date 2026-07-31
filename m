Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950EF3D9027
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 08:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487797; cv=none; b=IjueT8S+Q2j3SHlwSQ5I7COL0f3+Iv3zTY5sTwlhPQ2x+o51rl6J+VnW/N9pEI5GAGgQ9G53UAmFhlsRPZQyF9f53Rx3GOW/o3Ob7ec5oNSFHaUqy1QsiqFlNIYtzJwCOLDyMDwAEB8No8Wsym3S1aui1GgMRiAXuaOobAkneTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487797; c=relaxed/simple;
	bh=R+n9YLqadG6TAOwmEwxUSZn7a9bCX/tKzpwXMlqPam0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFYbyaolJSiAWED/H7o4SQeu3AlqeLLYkdYl25BMAa/XSUkiS2va3iPhG23+zFpIj2vMObeD4k/xp2JtJYaD/nvKox38v20ZuLf+2Nh9Ci63TtYsgYKhDyRcSliu9rb4U9s5VqJbNvO6Xx6bgwCoMjWU9vm1LZdAkB4QhzCP54M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eFRfYe+C; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eFRfYe+C"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ce7d2adef4so10437885ad.3
        for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785487793; x=1786092593; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TzK1wNsapURaE+L5SdIvNiyOu/fP48evIRM0DvEwwV0=;
        b=eFRfYe+CcD8OPwv+ysroSuE9YkVYY85U3JTNAkNFmDJnBvqEqK+s5antbJ8U3UXSQf
         3udvMB9ks6tLege004xNlpieyG9JWgwtNFUHv6DR8enaT2HLXdwvkf/ewHd2QjIldL/v
         59w3x7WfWJkI7r8KcGIZRuABuwCadITXf1QbJ6TDbNTuCbIhSzIVVXrsmxyo4Ygbqy1Q
         qkE5lzeFzn7VlyqCWLs0kooqqMixCBEFKmQ2r1c3UlIVzZhoMBAecBqF5LHxsXFk36kj
         wJSJ+hxW5qdrZxGNRf5O+MjJK5/XoctIZiR43GUzcUdH7cpMH/SgNLcecAbSxq1V9Tok
         Lziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487793; x=1786092593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TzK1wNsapURaE+L5SdIvNiyOu/fP48evIRM0DvEwwV0=;
        b=pQP05sz0VbA1MaKK0jOSuxWON2PJTGP5F1lLZQuFGvT7iKaoX/Dg3kcZNhrtAS8fC3
         3vWoyLjDfjKFOpZFa5/SyEfWMD/jSMnAaAsDpkq/wWFpXS1Twb42HhJpNbFKqOq3gWrk
         MIz+YbVaYdLvgDURbrX99XeVEMQHZkR6Zczxe4kK5tg3g3CZDDQfBsYPmV+JKSL5HMjh
         SqZyMmRQ8tpTx5YmvuJbMtx/NE84MTbGhu8ihrM/+7LF1h+ddoy5UgRSVZkTZG4uV0WG
         C1OQe0sMovRcHvIQ3VNB4ICtEZ4w2GCabjcvjSusMj2hBOfs7gIRbqDWjPvIINxKYl1b
         HULw==
X-Gm-Message-State: AOJu0Yx9TecBG9TwJdbVSAhWi7y5AIhwt5/NkWKVbD5vLOfcbII35mRy
	ItsAhaJ38eOqajUUEe9yxPdQIE0WrXm8KOzW1DCDpWekqFVVFpYguX8A
X-Gm-Gg: AR+sD10kKXJSMCu9u+9yR9GEIr+OhRhHUpm9/QG5SIVZcrAP6Z2MPpH+UuOJTr2kbhq
	RXYRA0LNSYVCthYRVYKcxxbF1wdSIgZwBfK11O4nuvddq1bKGu/VudWjsc5wC5LB9Hm7fqUzmbK
	ICpIxGnXr1yaBhmPYIxsNE2iQAfUzrts/gxWPV6deYxQRS9yE7xpDMlTiUnSX/mpu+hmetNvm6E
	p/LdCkWc5q1dQDnscxHtpiZ92ZXKxqjztkNhs1PtEdnotGEXf4CnIX7Z1BlQewE7eTLYPTHxg0p
	YBvNyncb6Plyh8TjvRQaTNjjfDyc2x7lY4mEgRzF4zU9/U+XqK9SPgfzlVEo2GJkyVSHJ7s+rJr
	GO5O1g9cOmcKC0L6cx1EeDkI5ek8H5WvurPVwvOqJHv/YXY550xj0VEOQc4Mm2rORISVmdy11H4
	8NwtRIveFOZL2udKlKoOoik+HELsEdJBeSb5XFIZOQ0OV3BUQYtEAI03l4lfJTJ6nUeLfBIJqfJ
	laTanCovVXW7pm5kJqTq484XThyFUBQeCEIdbp20t9z
X-Received: by 2002:a17:902:cf43:b0:2cb:3f63:7c3e with SMTP id d9443c01a7336-2d046ee5b90mr11692545ad.35.1785487793307;
        Fri, 31 Jul 2026 01:49:53 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5abaesm2708425ad.27.2026.07.31.01.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:49:52 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>,
	Dan Williams <djbw@kernel.org>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v12 5/8] cxl/pci: Factor out interrupt policy check
Date: Fri, 31 Jul 2026 01:48:10 -0700
Message-ID: <20260731084901.1512819-6-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260731084901.1512819-1-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Factor out event interrupt setting validation.

Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
Suggested-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
---
 drivers/cxl/pci.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 8e122de1876b..df13fb8802c3 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -639,6 +639,21 @@ static bool cxl_event_int_is_fw(u8 setting)
 	return mode == CXL_INT_FW;
 }
 
+static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
+					  struct cxl_event_interrupt_policy *policy)
+{
+	if (cxl_event_int_is_fw(policy->info_settings) ||
+	    cxl_event_int_is_fw(policy->warn_settings) ||
+	    cxl_event_int_is_fw(policy->failure_settings) ||
+	    cxl_event_int_is_fw(policy->fatal_settings)) {
+		dev_err(mds->cxlds.dev,
+			"FW still in control of Event Logs despite _OSC settings\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
@@ -661,14 +676,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (cxl_event_int_is_fw(policy.info_settings) ||
-	    cxl_event_int_is_fw(policy.warn_settings) ||
-	    cxl_event_int_is_fw(policy.failure_settings) ||
-	    cxl_event_int_is_fw(policy.fatal_settings)) {
-		dev_err(mds->cxlds.dev,
-			"FW still in control of Event Logs despite _OSC settings\n");
+	if (!cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
-	}
 
 	rc = cxl_event_config_msgnums(mds, &policy);
 	if (rc)
-- 
2.43.0

