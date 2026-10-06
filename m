Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C0949E14B
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 18:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791309690; cv=none; b=MY9537KokeVTJLaENKoma9zEKtuyP7hDnhPvs1MlCXZp3FXodGn4qED9uZ0Lp0MgnGh7xRWekrcct/Hx4XTeEPM1XiuvgfaiwhDjlV+8kjRaksQjbGvbL3lIgCOLxQEA1xQMeeZLgooTdrCNErT6Mu0A3R7fFTRCEKs3r1LOfhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791309690; c=relaxed/simple;
	bh=fgSnuoTru0M1RdnWdJ3W+h1U533c9s6oWqTxjipvO2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=bY7gYUMbL8bAky0aR/LsL48+lwu7E7Od0bWkhyv+7uGjwELLEEVNUGSF+LYQlLiV/K96DnbICEeZ018ylqnUgyCtroKPdavCbzW5HTpSznfY0BrOzicU2l3Kb/szyRJbETkahe/HeOYchXEjSQLcx1xbTb6ynBeOUQvwCswsbDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CzKWICa1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CzKWICa1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791309687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yukm86LJzzz9J8hnEhUh3B7rrcrjSUe6dcN4L+kFZ5U=;
	b=CzKWICa1XP+uwMYpqnLeDCPrILTHueDudBBDm3qTnzzI0LVwlSe41we23fu9QoYaI9HJJ1
	xosUEMqPF7BbXXfTZ4b/rLskRb/f17PMFYIseK3PeA2PER4rHj4Ds0Lox76luwUcXBhXWr
	rVtxTzvQsMWQtcQP4GdXlcc3zsoS9q8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-lrsN_U1sNfGBX3OAKdnwzw-1; Tue, 06 Oct 2026 14:01:26 -0400
X-MC-Unique: lrsN_U1sNfGBX3OAKdnwzw-1
X-Mimecast-MFC-AGG-ID: lrsN_U1sNfGBX3OAKdnwzw_1791309685
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6ae551724a0so2410656a12.2
        for <nvdimm@lists.linux.dev>; Tue, 06 Oct 2026 11:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791309685; x=1791914485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yukm86LJzzz9J8hnEhUh3B7rrcrjSUe6dcN4L+kFZ5U=;
        b=XZ3YsqCJOGHVqT7bC6E4eQtPCJ+oMo6zdpAGGWKsYl1i61C8cB8dV8W1135Azv9I3u
         pcXcPsgXvR4Jv/SoGU7B6wgFUBZjT2+SUwgxevibT1ZCsweCqmq1AU7W5lBYAcJWf77C
         JzMTuDNFZSr3zw6/Rly7WjRtQ/TiNamja3u3mT3E5U+GXqYc2BJK66lMN3tbObPa7Mm/
         48nRHxdSI/kEfsJdXcG+UpGYdizU0nk6vCv9mhxkD2ZtvGxnbR4T/1heZEWsvO3GwEKZ
         CUARt7i13/Z1D+AF9zpbqcNg6vOMK4zBzus2uvW7o6iODuQfXcr5HbtHE0DQGVMtbR3f
         FMDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzDh8WoVW5weEBEfMlvXnFm1BL4CJDu9k7teRpuzU+o6x0D7ZTCDe8KrqzfgdZDCZIQ4o8z54M=@lists.linux.dev
X-Gm-Message-State: AFq9FYLx18RXSi29byXpcER9yB34wY5dbVT4rTovGhwKigWQz0GJMiUV
	32t+bzG+M/qDXDEh3YQ7iGLEez49CnvWtQUlVn1F2rERd+iONposmP8M7Hxj97qaromhB6u1bGe
	a479Xb0z/Dt65XuS2zCqnhdN2CPd+LXrSKbqnXRrRR29899fCzNb+JMoIaw==
X-Gm-Gg: AYBFou33kAVuk31Ae1fi2d6NMrEJW65gwIMNwHvG6am8QGjuvGhGhQn37lnuiD5XoVO
	2BJqupogj6k4CUDiObOrU92ieGDGc72NTqHb3mSkvndqoLUr68iLtRRY4LKUiYZjyn/r3U68TrA
	zP+keQ5yWCDKv/C/8ZlyIzw+XGXPE0qVx0cVbtcl+Z/fkZPtnK2yat0LsBemA5Mqc4BrQ3SCuwN
	ed9ClNXYiexbkpQ3AlVL6j39iTDU7La+IS1Isu9LAAA3QMJw0Md0h7bhpTkNkYdUw++x7t+iZ98
	zeSOOqm0bggveVr4iUMAHTj52Uq6Q7evwbccBy7RfCC9tlX3+bOxaixykucS026wGfhJtw/hxRa
	owDBHrs/pbHdzqhUztDXJ1gbu+/j14r1nrRKscSFdPfUiWP/cSB0NHx8r
X-Received: by 2002:a05:6402:1ed6:b0:6aa:e3f3:c9df with SMTP id 4fb4d7f45d1cf-6afe29d4fbbmr2351545a12.20.1791309685071;
        Tue, 06 Oct 2026 11:01:25 -0700 (PDT)
X-Received: by 2002:a05:6402:1ed6:b0:6aa:e3f3:c9df with SMTP id 4fb4d7f45d1cf-6afe29d4fbbmr2351504a12.20.1791309684437;
        Tue, 06 Oct 2026 11:01:24 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (188-142-152-55.pool.digikabel.hu. [188.142.152.55])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb01e5942sm5056684a12.9.2026.10.06.11.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 11:01:23 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: fuse-devel@lists.linux.dev
Cc: John Groves <john@groves.net>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH v3 2/9] dax: use READ_ONCE() in dax_holder()
Date: Tue,  6 Oct 2026 20:01:07 +0200
Message-ID: <20261006180115.1425232-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261006180115.1425232-1-mszeredi@redhat.com>
References: <20261006180115.1425232-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3Jvns9mcXkdzMX0NzTY6gFSlS7UeIdL3s4xA_8ifEkI_1791309685
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Make sure that a non-NULL check in callers remains valid even when racing
with fs_put_dax().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 drivers/dax/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 824e1f6df378..0a440f8b42e4 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -677,7 +677,7 @@ EXPORT_SYMBOL_GPL(put_dax);
  */
 void *dax_holder(struct dax_device *dax_dev)
 {
-	return dax_dev->holder_data;
+	return READ_ONCE(dax_dev->holder_data);
 }
 EXPORT_SYMBOL_GPL(dax_holder);
 
-- 
2.54.0

