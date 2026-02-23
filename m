Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F043793AA
	for <nvdimm@lists.linux.dev>; Mon, 23 Feb 2026 21:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771883409; cv=none; b=ZwHoF8NtQLvv9GrmyfcW1dxLy7wYVpxKP8c3kel6n4z2Da44UU5LiBKB/xCOd4KOijHZpCQHFBHlxR9z4esuWYy3zHGDURP8FhOe/o1+G54hoLuQdxhpy/ghI+d9y5k5xS0I4BEO9fuOD/BgYKCIaCo77fLBtpKTTJTMDE690zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771883409; c=relaxed/simple;
	bh=tsu5t58A+hMh/4asnfpFiFvLKn8I7QPQPIJMQz5jv9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CevHH6AesfjNfZ26w0IO0RRSOPdflrbyIop6mf7cf+PJ55CdPCczfXILogWTXpojHDrPGUnvjf3gTH8/RAa4iR1mEd2Ouyxaw+dK/f3WhbW8I+qtvjAGNe4lZzJlfYyfS+MWzPZaE3jc1Zx+bNAKM70y9weONlSLQKm88mNdn5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Kurw2Jxz; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Kurw2Jxz"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fKZJv6q7Tzlfl6N;
	Mon, 23 Feb 2026 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1771883406; x=1774475407; bh=Ajgnl
	lR+MAKnHgOp9bP7UiL+cgWY3NepNSM8pwLzBp0=; b=Kurw2JxzNNvFvsaQnxoQv
	ndq7r/pFT1QNwmUymxnn4h4O8+20MWvZ4ZW689a2tKBzQFQYEsxm0BzdhuTZsn85
	hyDf2PP/c992NF7iwcQrVWJ6cnHVNQL6Uq+HMbpVw88MCnoc+WTyZCO8rQH2jNEc
	crK92575kPaCvmWFfupnQqwPZGh60FmaoZNcbLWNReOOuu9y/JCVKjyQr+9pA7Y3
	oMnof+JnkutmbHgLfOgibw1EYL+hylqY/IpaOremlff9+orylpEBWXJmA1psohQ+
	oQ3WOXsjLV7Jpm2S77B+oEYL+jY7tWKxN363qeUrC7ejeHGJJn8JXfaR4r/KCwCe
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ei2wJ7_prsfs; Mon, 23 Feb 2026 21:50:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fKZJr2q3Vzlfl5l;
	Mon, 23 Feb 2026 21:50:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH 04/62] dax/bus.c: Fix a locking bug
Date: Mon, 23 Feb 2026 13:48:52 -0800
Message-ID: <20260223214950.2153735-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
In-Reply-To: <20260223214950.2153735-1-bvanassche@acm.org>
References: <20260223214950.2153735-1-bvanassche@acm.org>
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
