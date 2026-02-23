Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C5F366828
	for <nvdimm@lists.linux.dev>; Mon, 23 Feb 2026 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884090; cv=none; b=THzQKOgbiVv5puJQaNiKLoVjLCl0h9/E7XqlleynmbB1fkfZSR5c7sCA1t60uTxncsLZ2YxFAvkuBe8GblnoY9e5O/N8Mrs4fPMHOiPd0l4oITdN9QWPqHu2C52sTDpfQC55QopdK2wYc6Z/F3UcSMhuKYnidGHHEBkKMWEqV9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884090; c=relaxed/simple;
	bh=et4A89mJqfVdQvmY84nIwmJpvLyzoFSg4L2NjpABKEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlRTYznZcwMUJA3owgV5mSwLxZHyq2ZCZ9EoRiDQVjxmK2KouP+71Xp4my919C2H7SawMdiTNtu70n/7CL6W+yD/I425q9EvaoIKoZYePFCbU04ClurK8KOI7KfKJ2uhbKjdLSFTsvL/kk630CifQWkDOyBJRQgIflT8F+9aLZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L4nn0tqK; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L4nn0tqK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771884087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ihR1R6qtYFotNkG8urg8ayZDiQkcIjBq1yald6oMYsA=;
	b=L4nn0tqKIs33QjZ7YmRyDR18t9hv+a7VrN9T+Q1UHKlVRJw5JBx+MvqAeOhxG9yIJy3aNi
	xfwWuPiHGI+NhUvXsuwTXqqG7e8/ux/je9xw4upJRoeztst57tkhd26IzF9fZImoYdQI7a
	5zgRgmO2MS/P00vUbDj3QVt0rydhjZE=
From: Bart Van Assche <bart.vanassche@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jann Horn <jannh@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH 04/62] dax/bus.c: Fix a locking bug
Date: Mon, 23 Feb 2026 14:00:04 -0800
Message-ID: <20260223220102.2158611-5-bart.vanassche@linux.dev>
In-Reply-To: <20260223220102.2158611-1-bart.vanassche@linux.dev>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Bart Van Assche <bvanassche@acm.org>

Only unlock dax_dev_rwsem if it has been locked. This locking bug was
detected by the Clang thread-safety analyzer.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/dax/bus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c94c09622516..ebd3806c34e5 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1117,11 +1117,10 @@ static ssize_t size_store(struct device *dev, struct device_attribute *attr,
 	}
 	rc = down_write_killable(&dax_dev_rwsem);
 	if (rc)
-		goto err_dev;
+		goto err_region;
 
 	rc = dev_dax_resize(dax_region, dev_dax, val);
 
-err_dev:
 	up_write(&dax_dev_rwsem);
 err_region:
 	up_write(&dax_region_rwsem);
