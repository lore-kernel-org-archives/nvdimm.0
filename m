Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0983859D9
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529855; cv=none; b=IBUy3dxUGXGx6bjax0OJAsEHdLU0/IicoYcFi/KjHt0PfyvmgiwSl7KzWiGNWdsdu8auC0zpBhg5KgHzDvqt1ohZVKuLBNWsxIvsg37HD1Ydokk9d1oH/huErJMOgj3b5I1erILNNKdmYHyBQr6Aya1szDIwOTgBqKH87tjZPXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529855; c=relaxed/simple;
	bh=tV9eVPzA4alBVC2GhOgYHNOWGjBFnMKU4PywOkoIUEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+tKPebjmq4HOW160J9zal55nVbtnIPqag12/tRfYUW5UFxWHz0MgzQYvJlFgMRv5WhC3bVZpjesgmPcnrKSV3C4SZLThg+4hDmov59+/TZZYyjdhn3uLoO9WbSbxsu3W9+zY/g/+tPlxXDWpwzr1pjqXo/JFazCAOqNUL/z9Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iqGMcGJP; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iqGMcGJP"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3045c195251so976523eec.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529853; x=1780134653; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MwPUwyjbFgIHmeBuVl0MOj2c+NoiA0doE1ZNsHpwIe8=;
        b=iqGMcGJPNWDF/6loH0W21/SdPNxXnj/NaVuatTrS3VXwZh1IwQKzpTnLDCfd2nBvSJ
         +xhjkcm03rD7hI6r3/yOtrs5w5ZtHbmOgEdqVXWeUGCKH5YRs3xPEsRfb/9NXrJ3ozt3
         rNVQeisdQrcurvG3wBrc9zMz6XeDD5msCMKhPhddtB3VjtpIce0PiuBgGhKCmFvETV2P
         AGcwdDHRXGrlapaTsdTIZ1GYAZX5JSQjGqgML6eCqyLrG8hZLb/pfvCnhyOp+FCpB2HX
         UAUVfMBaIFUsReakmETCHyR1pkqOAK6tBzegi8U6i7dg9bMk2Lb6+oNtVDTHkEvRgbiA
         Oujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529853; x=1780134653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MwPUwyjbFgIHmeBuVl0MOj2c+NoiA0doE1ZNsHpwIe8=;
        b=rFxoHfu9q/3OnrhL9k82+H4l5aZ7PkdmAZKpKzPTdFt66vqOjZLmuA42WsvaOoZtxE
         UWH0faIgBv30SEjNy2Mt7Z2u+PSHRan/YpT2Je0T7apKHFn01WG0tSOvXEcTuGGCiZ7e
         JhztNJiPWEz+8lDXvnHuXwPZO6VypZNjYVljYA6D+3w7Akmt7FBd8ikVczjnFnnZWkwB
         tQIGLMtiKZy7x4EZ+0RwcnK1M4J44qxGARb9onoSnMAq8ibQ7PR4j5db2FH3486QiFwa
         QB3oaws6OWIn01SY6/tfgNlNFBeONT7iPYN+7/+usvIJd3OCEW7KlaJr+Sz4cVVZ3f5P
         S3xA==
X-Gm-Message-State: AOJu0YzlhY/xveKFV600luIE1ZIpb8cW1dhqrC1P0uMh/stFALI9fscx
	ApIxi6nJ/d5dxYcxXvuchZR1n0UbP2Uz7xYzql5TsD/efkpg4mmKY73E
X-Gm-Gg: Acq92OHAG+yViKSZ7sxKK9/7Ij5pOUBjpPMNoL3Tb54MgsO4rcaU/qSdr8iaVX3V91f
	M1mmH0tiVEL1+hua2SZrxB2lsauguLK/HTqZnKAV1PYIMyheewqOk0tk/V+LUXosqX2OIR+Q6/y
	u6wpsbeTTR7E+qvMw1sfXQfuKReS7AHlPhz+QyoMz+Sg0Nlys1JoY6nUWY9pSBfFpav8J8jb7ns
	9STTk/rbQ5dqsMDDGfFRzPILTYuTVbPfQFiOm4usUv8Rcqzr1FgEZakzCf2WQaweSz60n1d2cS2
	+voOIeD6DLzhgnyBXCR2b7R8lZt6bluD7RFeW1z+vaYHUKG8a3XYhvbmIK1cRP5Mr57Jy1aALAh
	AOy+bS+O12v5sqAW7HbanrJNiHS42ZBMo2oRbvl6R8Sh+6QabTSlKsaZKZaRNrzrd0TAjjNxyB5
	b9JeZp4YnHf+2+0BAyEB9mJfjo/PhiUE04asLpYk/cIHv2WUkoh2aJzH9bbhGwe5udl3RdPbmJw
	IE+7yBtyX62eF438w==
X-Received: by 2002:a05:7301:ea3:b0:304:2e9b:8f56 with SMTP id 5a478bee46e88-30449144693mr2991479eec.31.1779529852750;
        Sat, 23 May 2026 02:50:52 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3045225b7b6sm4595756eec.25.2026.05.23.02.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:50:52 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>,
	"Jonathan Cameron" <jonathan.cameron@Huawei.com>,
	"Fan Ni" <fan.ni@samsung.com>,
	"Sushant1 Kumar" <sushant1.kumar@intel.com>,
	"Dan Williams" <dan.j.williams@intel.com>
Subject: [PATCH v6 1/7] ndctl: Dynamic Capacity additions for cxl-cli
Date: Sat, 23 May 2026 02:50:36 -0700
Message-ID: <20260523095043.471098-2-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260523095043.471098-1-anisa.su@samsung.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

This series can be found here:

	https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13

CXL Dynamic Capacity Device (DCD) support is being discussed in the
upstream kernel.  cxl-cli requires modifications to interact with those
devices.

A new partition type 'dynamic_ram_a' has been added which cxl-cli
needs to know about.  Add support for the new decoder type.

With DCD regions may, or may not, have capacity.  The capacity is
communicated via extents.  Add region extent query capabilities.

Add cxl-test support.  cxl-testing allows for quick regression testing
as well as helping to design the cxl-cli interfaces.


To: "Alison Schofield" <alison.schofield@intel.com>
Cc: "Vishal Verma" <vishal.l.verma@intel.com>
Cc: "Jonathan Cameron" <jonathan.cameron@Huawei.com>
Cc: "Fan Ni" <fan.ni@samsung.com>
Cc: "Sushant1 Kumar" <sushant1.kumar@intel.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Dave Jiang" <dave.jiang@intel.com>
Cc: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes in v5:
- iweiny: Adjust all code to view only the dynamic RAM A partition
- Alison: s/tag/uuid/ in region query extent output
- Link to v4: https://patch.msgid.link/20241214-dcd-region2-v4-0-36550a97f8e2@intel.com

--- b4-submit-tracking ---
# This section is used internally by b4 prep for tracking purposes.
{
  "series": {
    "revision": 5,
    "change-id": "20241030-dcd-region2-2d0149eb8efd",
    "prefixes": [],
    "history": {
      "v1": [
        "20241030-dcd-region2-v1-0-04600ba2b48e@intel.com"
      ],
      "v2": [
        "20241104-dcd-region2-v2-0-be057b479eeb@intel.com"
      ],
      "v3": [
        "20241115-dcd-region2-v3-0-585d480ccdab@intel.com"
      ],
      "v4": [
        "20241214-dcd-region2-v4-0-36550a97f8e2@intel.com"
      ]
    }
  }
}
-- 
2.43.0

