Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3552FF675
	for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 21:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761339944; cv=none; b=aryGSRlR5PjMQ8pdR8kCDqr57Oq6nOd99sIVWHQhM7lqIvczpHqloM/3idwD0ksRz7+a3SmOOrewm4YpF4MCxUg1B+dX7c71maS6aL2GiE5ed725jDws4JjoMB4GdiKVkTFgdBIXpgGVpyY7nb5NAnrNi3CWiJ7kxDgmZsUA/v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761339944; c=relaxed/simple;
	bh=67f2l8+Y5bz8I4g91AcfEcd5o3gZzXNDXTeDSIIu4z4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ht+ZRGkRjhhaI1S+VaQPWNDq/z8KeXfiLEKNZWh0y2FIRbV+aJSE9UkgbLWk9s4i+F4pZrcTJvSvl1cvaz9LQu8DgwpnFWF9tC8NxjYl9aSz3J/F2gKK3nVsnLc3q4jl20Pl482jrhaG2PjFYXIGfkXZk13ffmdzBJqAdVvz9V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dc25As4v; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dc25As4v"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b6d58291413so225871866b.2
        for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 14:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761339940; x=1761944740; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TqJFC+NNQsYqMZ+tK6g4G5+TIVlZWFt0dur9F2fI5/g=;
        b=dc25As4vj8/bgOV9ERklhHlknHLu9HBDZ9AmYUCiCxrk9vXFHejJ1usqbyGTh3/j7m
         +yDvhAMUj0H83CaPb3sIi+OwdLZXHEoIo70Qa2t4EoIaatP8PtXVQmqcg/7O5NiW1KLu
         XbXGs19ZAzjzewgBelqcdu3QlhP5CxQuh9XwsNJym++gbPDzms9s6uGe/OULVB+dY/Z4
         D5/tIwpgaIUxLksOs7b5q9qo3Uu1MbRxUGwIKlUo6l0S3kITz1PpMEfBTW8KrOXAAxiy
         LD6vXRtIjR5kZXmKLeYVhFcihTk7BhFy17mEBciOUFozYQKAbpi6QILmzJM4ajb+p/IP
         P3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761339940; x=1761944740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TqJFC+NNQsYqMZ+tK6g4G5+TIVlZWFt0dur9F2fI5/g=;
        b=siUH920gV2GKLiR3c9uqCjZy0uMQ2iHQjepgev9nKuNyFRVuTJRhq+S6N3hXuMBhvl
         Lh/2uwcuCmt7M0Tneqgk07aOA9ZAK5KWUzd0rbYF4Dqv5jFtNk9VdYPqROQSJ0kkj1Iw
         0I3+RmNqot7V/fcvyG004kWOaPMVfTjgvshG43Idv1BDpEKMEJiw3fGT3W7jYgb6GQ/D
         2xf1vcgX4qgtbL0Qn7+4fAY6hUfdH2VbtK3E4fp/0sWDuKrgHKXi7ufnH4lfmRN9hMWV
         bglNEsqAm1qmo5dABt/VqyPEi3bQg4NAxVBc3E5xrap9CJuWdWk+mlUbKATOGv4kh0As
         Vy6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6iB+E6knQID8wMe7wOYVj5DbQGXV//nGfq2HAn7hYJpPDwZfbiFveocc9BHiaUTdLmDXtli0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXgb4ZtOuuSApjF5C8sPKiidrxf3RmSZKnhAHwRcYh4v4O1Fe5
	gCp60GxHLlWmHIgzIySfZTMF3FKZM58fOHriyUVcA+mVtOcq2A+xr6+jSrXX6Bz8BYZe0GEb6TM
	QBbdLfBNYByh3GoN5ioVcOw==
X-Google-Smtp-Source: AGHT+IFUkFD/7WIScjIdXAKYJxfPtGhIYSnvomOS/iycesQViHbcTTslx/oSa9Wf4TQ1/V2dND2DFoK462c8uo3K
X-Received: from ejzd26.prod.google.com ([2002:a17:906:c21a:b0:b6d:5f9b:1ec2])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7e88:b0:b6d:4034:8d11 with SMTP id a640c23a62f3a-b6d40348deemr870312266b.62.1761339940332;
 Fri, 24 Oct 2025 14:05:40 -0700 (PDT)
Date: Fri, 24 Oct 2025 23:05:16 +0200
In-Reply-To: <20251024210518.2126504-1-mclapinski@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251024210518.2126504-1-mclapinski@google.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
Message-ID: <20251024210518.2126504-4-mclapinski@google.com>
Subject: [PATCH v3 3/5] dax: add PROBE_PREFER_ASYNCHRONOUS to the cxl driver
From: Michal Clapinski <mclapinski@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/cxl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..90734ddbd369 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -38,6 +38,7 @@ static struct cxl_driver cxl_dax_region_driver = {
 	.id = CXL_DEVICE_DAX_REGION,
 	.drv = {
 		.suppress_bind_attrs = true,
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 };
 
-- 
2.51.1.821.gb6fe4d2222-goog

