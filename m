Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E439B37A4B7
	for <nvdimm@lists.linux.dev>; Mon, 23 Feb 2026 21:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771883516; cv=none; b=iKJysQHK6HKOvFOXNLGuMxo2yzXAM/Y7F51B5iPlSVFh5kOWJAiE2EdO21tBqP/kjZ12kKK7bvTPdesy7A341DrKKRBRm/7uCSkd2wgqWd5kEm3t+d39DbpjD5ub31w8xzPWyaY9N//gTPs11j0SIz7VYAXmtJItLoup5ULvQ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771883516; c=relaxed/simple;
	bh=tsu5t58A+hMh/4asnfpFiFvLKn8I7QPQPIJMQz5jv9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zzq3kf+IbOuHXj0vG9BD5g3lQe55hCJqidr1mFR/lTgDkBI7j6rzs9ZfGMPTtj2gRppdpXgc5vw4gOzBcVklqJz2/hffqdw8LXar/43a496KGuG869OKr2Fcho27Qxb+3Cp0QtPmuLd/b4MFjowB0h9abuqkWsC6W0xA4+/o1JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hN03osf8; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hN03osf8"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fKZLy3NJDzlh1Wj;
	Mon, 23 Feb 2026 21:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1771883511; x=1774475512; bh=Ajgnl
	lR+MAKnHgOp9bP7UiL+cgWY3NepNSM8pwLzBp0=; b=hN03osf84O8qS2LO/wrES
	VjQyx7447Bx6I6QMZc0tRxfxX3fPCwunK/1sY4e2YsJpmvQzskc9SafjBAUJ8zsi
	E7pPYQg8z11cvhOLUqc6OKqRthSetQ+0RDAkMDdy4im+elqOVWCUtG8XolzO6amD
	ysrUCmmQcEgNUMg7yCNCReuqFS7vNeYWw7f7u6OkabMmfua7ApDdAOZTges5/rgn
	fKqvp4SuW6WVLKULtmqjn0lgr1bRgrV/pTYQuWAqz5/zhsJP2L+gFSMSlFvUkCYA
	5604sEojcdlI00YZOa9ZuZrsONAzB9PluMm4L4dReS+783H46ZJkwDdE8m8bZXVn
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SAN_puEll8YD; Mon, 23 Feb 2026 21:51:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fKZLp26NGzlfl6N;
	Mon, 23 Feb 2026 21:51:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
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
Date: Mon, 23 Feb 2026 13:50:19 -0800
Message-ID: <20260223215118.2154194-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
In-Reply-To: <20260223215118.2154194-1-bvanassche@acm.org>
References: <20260223215118.2154194-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Only unlock dax_dev_rwsem if it has been locked. This locking bug was
detected by the Clang thread-safety analyzer.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a loca=
l rwsem")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/dax/bus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c94c09622516..ebd3806c34e5 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1117,11 +1117,10 @@ static ssize_t size_store(struct device *dev, str=
uct device_attribute *attr,
 	}
 	rc =3D down_write_killable(&dax_dev_rwsem);
 	if (rc)
-		goto err_dev;
+		goto err_region;
=20
 	rc =3D dev_dax_resize(dax_region, dev_dax, val);
=20
-err_dev:
 	up_write(&dax_dev_rwsem);
 err_region:
 	up_write(&dax_region_rwsem);
