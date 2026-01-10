Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5B118DB37
	for <nvdimm@lists.linux.dev>; Sat, 10 Jan 2026 19:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768072692; cv=none; b=BRqYnWJJRwmvI4eGLzJNBemegoHjHQDA1E7T1a6PdLSmzKaxFnlSbU9yDvsTgaZ72rM79EbXlMBMq7qCpKD1+rrXLVZ2rSOW2w8Rd78wSddwu5lVatd8Crag6W76XfrHMFumiJqtnZPKtZB5yrzebzZrECZLBB0nE8sd1yCziMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768072692; c=relaxed/simple;
	bh=bGr4IMxuoPSV/rGQsuBeMGpMFNxbYa6U9ZhzkPYCYbg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YVbGSDU3PgqGHLiJuS1HPT4+lIweH9tIFJJtLWjjbAC7q23ykvsKw/yt3nxs8PvUkK2k0KKmxSfd+aZNG1b5b69MeH2+5GYLyTJ9CuXYqD0LHZlSwH4osNOMKYwonIWW4OYuYIFIZeG08P5dfY3c47CwSfvDgjodnRslRNH1k7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R8RPcubn; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R8RPcubn"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-656d9230cf2so2741909eaf.1
        for <nvdimm@lists.linux.dev>; Sat, 10 Jan 2026 11:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768072690; x=1768677490; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=BEjUF7Vc4qXiTNlca0j1dqWD5DavB0AzDPTyw418Ev8=;
        b=R8RPcubnatWTTWWo85aHaBeadMBI1TVrp6qlVje3U6vC+pvzJoOObaJpLFdNU8WH9Z
         GoXLvMaAwBunI3GUmY6GrGJ6G0HfG6SqAHAORsPmEmdFyQx1S88vve6NGLt0jNruKAls
         c/jtVobbECDV/ByLc5zXT5g11uRy6BduFHokV4MwyZfBHQQFQdSVq2xf1Q5uoiEK7A7D
         UZtxd0gXyaRwyCdN9BOljaa1bannA8GnJ/YuyBix5VZ+vcp2UtFxYihRLrhyRaOL0Xfe
         D+THh9txQ+u74CURUC+fHjlnu/bATulMnp2s8rCBrnXM9N6CzG9S83N7fKxMbe6CXeDw
         +Kxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768072690; x=1768677490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEjUF7Vc4qXiTNlca0j1dqWD5DavB0AzDPTyw418Ev8=;
        b=OTAMvR0zW1ApiPCl6SUDqSTeUxRwLigehHndTIwJ3V2wJd8rhP6UKvyB3eqlRwSDdf
         UV2771HiIa1Kv+XG7YcSs0iQRsZaGrM7Tt2RyKT1sNHyapSqQIbc2n4Ty4dm4doY5rPW
         vUqJFncTAI3JbybP9yf/rlIWnReEIOmr/zU6XKY+bfrXBdHcikXCK7G78YyNGFMlpDpy
         wqBAmNwb17nFzBlWWHWOkfVqTCkxGbn5sHnUQB62Y28MysryGwz3o4UHQFMomwoMwUkn
         neQW3NiCBiQOpRcrL85T0EEG1SdHAw/eBJ+1DYHJPRCT+ysJly+HhcpMTsGHlRuHj8MG
         pQWA==
X-Forwarded-Encrypted: i=1; AJvYcCVz2zxBtmmJ96XOAFv0cDiQJ5bBOo/OS8P1Hq7HJXZ8SIS+Xoch7h9TqqiBaZrpp76Sa4eIyoA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwwXu75BEPv49OAXj4SbxYjyymj3L6Wv+AnoZf+Zkescj/vnwJ
	NpbJd1qd/fAsnJKrOmLFOcbZwHZvq0PvEBv9T2hG6T6fS92Z4EgIGZBR
X-Gm-Gg: AY/fxX7LPGdeOnCyh7+c7KUbpAManDVW7tqgs5gKAKuywYD7XC94w4px0Qb7Mh127LG
	Urd6AzhfFvbK5NrbNkkjWrcB6k04Y/YiESJg9UJLhq3gVGQjYV43qNxv1Cg3CJ43EFNlStUkpGQ
	22jdzpNJ5u2cla4JUW7pSSre0M0Y/o1I46yozJvmYvYRzcoyCOEFPRq/KzReE6LQaUbtjeZkji2
	4mUK2yELAE4mjt3cXcxwJNBBVbiZ8BDLXgBd4PPT+uNnw+OBYSePjeG9MJCHCgXTcIAwd5oHwQZ
	cDkbhTDJhBZUmcsXFnBvkXA2Vhbi5qFjjd9DwgIp7+AXJa5EaEf3Z3XxEa39UDHJq2Hk9YPkTIe
	4bI3lo+Vkt8j2V564W7/vNcH5YyPo2L11zmC7Iuxz11RGx/a+VmxrspvfqJghwhFIrNB0KaDdQg
	qrn0v38wDYwW/DcEhQ/Bmcs9Lpxi9ccH1w4/h9bf1wIg1Z
X-Google-Smtp-Source: AGHT+IEWrVmsDtSwCaHlxvcwwleGHry670J1sFrzbV2lGxKsnW+rkn8uvAhPl9HF13Q2e3f5Yn1hDg==
X-Received: by 2002:a05:6820:80e3:b0:65e:9097:3ee0 with SMTP id 006d021491bc7-65f54f74a47mr5503700eaf.44.1768072689894;
        Sat, 10 Jan 2026 11:18:09 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:7d36:1b0c:6e77:5735])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffb279e939sm8066273fac.16.2026.01.10.11.18.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Jan 2026 11:18:09 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: John Groves <jgroves@micron.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V2] Add some missing kerneldoc comment fields for struct dev_dax
Date: Sat, 10 Jan 2026 13:18:04 -0600
Message-ID: <20260110191804.5739-1-john@groves.net>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the missing @align and @memmap_on_memory fields to kerneldoc comment
header for struct dev_dax.

Also, some other fields were followed by '-' and others by ':'. Fix all
to be ':' for actual kerneldoc compliance.

Fixes: 33cf94d71766 ("device-dax: make align a per-device property")
Fixes: 4eca0ef49af9 ("dax/kmem: allow kmem to add memory with memmap_on_memory")
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..c6ae27c982f4 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -67,14 +67,16 @@ struct dev_dax_range {
 /**
  * struct dev_dax - instance data for a subdivision of a dax region, and
  * data while the device is activated in the driver.
- * @region - parent region
- * @dax_dev - core dax functionality
+ * @region: parent region
+ * @dax_dev: core dax functionality
+ * @align: alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dyn_id: is this a dynamic or statically created instance
  * @id: ida allocated id when the dax_region is not static
  * @ida: mapping id allocator
- * @dev - device core
- * @pgmap - pgmap for memmap setup / lifetime (driver owned)
+ * @dev: device core
+ * @pgmap: pgmap for memmap setup / lifetime (driver owned)
+ * @memmap_on_memory: allow kmem to put the memmap in the memory
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */

base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.52.0

