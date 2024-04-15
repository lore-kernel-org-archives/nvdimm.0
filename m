Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B890347A7F
	for <nvdimm@lists.linux.dev>; Mon, 15 Apr 2024 10:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713176373; cv=none; b=FppUPfAnzzZWsng8u43PAa1W0Q6oQjvFweArhKkyMGD+50Gb5sBpON/WQP0/nbZt3zMWUzRSkwSKOnvvZLNqYBnQp2xh+csevUdzZvIdWwcLHeTcUkTBgDnxRModMtbQA+dDTBOUj5LrnDXwUG40rAUHnFmsIK6pMgUMI16/FFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713176373; c=relaxed/simple;
	bh=z0lUnRnJ20hdiXpMZRnobdIYEG92hyGdtmMXMY7UjPw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=EDrYc+fkkwB6pGCDkFYItfrSUFdG1evTSkfVtphFFlJpZutK0S4DaPODf5MWccViBqMQSzgA5Jfw0dhzpSZY6FN4twiAYYdh64HZZdIpTIB3U0nk/IUlTZDuXvrCnHXD94LD60tG0+hbumfoWUwaaH4CGbqwwOhLqXEPBkU7FSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h1vrMuST; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1vrMuST"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-343c2f5b50fso2280972f8f.2
        for <nvdimm@lists.linux.dev>; Mon, 15 Apr 2024 03:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713176370; x=1713781170; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KG194EJK11CX6gvo6DvtRQREQM8gMc9FVpOEjalH2pw=;
        b=h1vrMuSTRvKFUwE6TB2fDhEY4q3U/2qRiRWISQuqU9QdOx/20YPQFvgFRzFwTCJ+x2
         c9Nt5xQfONNrc0bsiF/QPXHmHp3Jc/WuccBZICSiXoLICYNhcMukcKXH5lJCgPkNPVA5
         Vs9y3A3IKtz2NSmUWF3A20V4zbtkIoSyQFBWww+fFU5fOz8iSAQqY1FbWLR8nRI+FlDQ
         t4YzL2rrDSUjvmo5PAAf6noCpxoiOWQyW4gQW9SKy8EgA9rx1bpJayLMGi+fY52p9j/K
         ll8gYMZCVCmzD4DmQMbi85jCXT+TXIEsY6UIdAFB14SzosM4/KSV4qfV0I//A/7LrQU6
         q5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713176370; x=1713781170;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KG194EJK11CX6gvo6DvtRQREQM8gMc9FVpOEjalH2pw=;
        b=v+6RGVqdlmI4R3t+P/5il88l811e05mlR9D4PoYyAxUXyIGmwREgKucTiCfohjkYp0
         bylQioi1sRUM+Qdf0q1t/YvF7pj8TSjO9a9tbE2ncczZc5n8mJQde9jn2I5LrIY3u5WK
         DH7tbIHslmEJT+U+InVi1kXh9plMt9dD2FUzHsA+uqrfuYRRbtDGtU2vKC0WnM6aQkxO
         /Gz+/MJnfO/PsN6FQbHSp8pPXNsCcl5iUxX/By+t9mk75UVP7d8omTwyW+rSWegu+8Ec
         Ppjma1VIWwuwqZ9ZU72/eiVVHU/loDW3aKgksrEXYGbD4yht0y35itgMEt0Vd6WikZA4
         zQFg==
X-Forwarded-Encrypted: i=1; AJvYcCVQK37LJMgQALM16aSbnDT/Wi4lLjbCY7vre/N41GGu2OhaA9L6L/YOXvbaWfUvjmSjkW3b8KmZEngedHXIHqMkyyzB8oMx
X-Gm-Message-State: AOJu0Yz4Fb3qcBXWJU7PFiAkkMzf4RHHyAuaTtMzmZXLCy0/E6Vo+1CH
	ucaSxOeubQM5BQGhGCVxSWMscil6oFYl92EIDJneJig43T28OOw7OJdqq+v3
X-Google-Smtp-Source: AGHT+IHVtzOXafYbDUSuB8izRSCQlP6f8luo9hqQkPhmgEpooak5Fh6B4tfYcWAFBqOPTX+Ekapr/w==
X-Received: by 2002:adf:e80b:0:b0:345:f96e:39b4 with SMTP id o11-20020adfe80b000000b00345f96e39b4mr5327672wrm.8.1713176369944;
        Mon, 15 Apr 2024 03:19:29 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id k1-20020a5d6281000000b003445bb2362esm11629201wru.65.2024.04.15.03.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 03:19:29 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] dax: remove redundant assignment to variable rc
Date: Mon, 15 Apr 2024 11:19:28 +0100
Message-Id: <20240415101928.484143-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

The variable rc is being assigned an value and then is being re-assigned
a new value in the next statement. The assignment is redundant and can
be removed.

Cleans up clang scan build warning:
drivers/dax/bus.c:1207:2: warning: Value stored to 'rc' is never
read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/dax/bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 797e1ebff299..f758afbf8f09 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1204,7 +1204,6 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 	if (rc)
 		return rc;
 
-	rc = -ENXIO;
 	rc = down_write_killable(&dax_region_rwsem);
 	if (rc)
 		return rc;
-- 
2.39.2

