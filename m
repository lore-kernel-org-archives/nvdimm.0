Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB93D3845B3
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 15:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163852; cv=none; b=rXMeHpruJ/cATkkVBB9197UU2Y4tEriC3FUAxHTztKyi9rKaBNhjR1xNyu0wEYSkVlX/zWHkyGX6Y8Pa6OHQb5YB2ZAZEqVY27qqZlFyvhCdjnvSOYtFJkvUkEi56Cmp/eyxry5m18/AA8XAyfytcrkvI4de2/OKyEzhUWNJqXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163852; c=relaxed/simple;
	bh=AMn+xnR9hCYE91pZuVzz0iZ7IzoIrx1xBUWmAYY8/sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=dJ4NZ1h/T41VLGapPFvNlNzvQyLOHIVOhRlytqR9T32giIIA8D+FoW7KtRBHqPCZ5h+Tmv63j4yQNLcWCVovU2yvOlzMAXblhgO8B27/pzS5mYn+qJ5EIbDx3HmkaHvg/JMWeFb5l+IZbrlBuSPrn4Zu09ZiiBMgzWcX/FrXJ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J43XhuFf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J43XhuFf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792163848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3YoLdvr5Z3l3Hzqb5bH27bGqI1NT3+cZcFrMWvQlNUM=;
	b=J43XhuFfVutPr8H8f4fqPFI7Vzu5nj66m2KY6VwHm4SYBgmYEdILTdC+e461ttF5mc9Q2S
	EHdnUfs8gtH+RTvu+RJEAXJkfu9sTpc45LllijZHzqgGgD1aA8STXK1AkLfYNMM6wVPf1D
	LVt5970wuvgUHD1/TO4gFNCQz6tpmuk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-iKeSj0vuMzKLL85qUFOhPQ-1; Fri, 16 Oct 2026 15:17:25 +0000
X-MC-Unique: iKeSj0vuMzKLL85qUFOhPQ-1
X-Mimecast-MFC-AGG-ID: iKeSj0vuMzKLL85qUFOhPQ_1792163844
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a1721559b4so634225e9.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 08:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163844; x=1792768644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3YoLdvr5Z3l3Hzqb5bH27bGqI1NT3+cZcFrMWvQlNUM=;
        b=N3QblKlpPSzEeZfV6MYHbN7Fqf6yDp2EEJPfDGMEncg8EfZtMfrY10uk2VDLf0PasG
         enHLRMswMhIxQXQfvYbgf3l7baU3AHLZovpkbTMDy0N5fNWYrjO2hg8UpQNomV4AzPM8
         BEWlZSTNvTNKmE34ZkHHiR/pLbzvLxsGguqO+5b0NcWSLvR31aSYmm0lweWStE4tGnEI
         PT3esP7z7n8uakxYwcCYPmA/m5oDW23ly8+oTcRavn+p7mHyXlUauNJdEad5dLhWLoAc
         CLeaCU1pBqdjub3GO8YIOLndWnEoAR2vLLF4xpf76lsl6na+01ie7SxcPFaoidt3nd+m
         ljZg==
X-Forwarded-Encrypted: i=1; AKwUvBxWqZYudUIQca7zt2AtQuWH13+bvQEKak9ft0q0ZAqV87xPxI40lMf40vTxSHqtjkn09VJt0JI=@lists.linux.dev
X-Gm-Message-State: AFq9FYIR2Mj+XeskbZEY+/OYYbzT2OJ7HrJs15fDvARt8E26G3u/jP99
	X+MTgE4BW07CztKhVK87w6BXfDDw+qhMLRyhT5LrflDdh1Gbo1SqbvWGKcT08HWjFpeXyhZBkQ1
	ujAyiuzapyg7pzNLOiMg4q7EW9ZCuYj8Y2r7K93C5XmimKwql2zgpWU4mpA==
X-Gm-Gg: AYBFou05/F7mc61VBvb8UOOVbHGWo/z/DKJ+nGYX+uIoYXJh6dAtCIiTA19CWNg0PQX
	zaqhuqUHXx0z0/AyzkwkD61HYubb3fgCmzwnXrgI95bpwkCiIzO7+92hFXGhnVu3J2Hi/gOVmdq
	gl672v/s+7iTc/zwpwfkjbK6SDyN4NnMzPQXF6yehe2/iKjXDagScQialKinCrtRBO97Oea7uPz
	BRuMk7B3ulEPuyMujnPA8IKIKq/4/COGFupSryf/5CxGc19pUVAASB5tVEaDaRSQVI8UBPPsNfD
	tV9AwayoT9GanFmoHwXuwiLorj5hY8kX+yBnkMP1bkJLqg0uWJFPl3SDwn4afC5bu8upUKozlVH
	i+1nQNr1K1UfB3H0fCIW6Yg==
X-Received: by 2002:a05:600c:3555:b0:4a1:d52e:c2d9 with SMTP id 5b1f17b1804b1-4a1d762c1bdmr2093875e9.23.1792163844137;
        Fri, 16 Oct 2026 08:17:24 -0700 (PDT)
X-Received: by 2002:a05:600c:3555:b0:4a1:d52e:c2d9 with SMTP id 5b1f17b1804b1-4a1d762c1bdmr2093325e9.23.1792163843743;
        Fri, 16 Oct 2026 08:17:23 -0700 (PDT)
Received: from maszat.com (85-67-2-18.pool.digikabel.hu. [85.67.2.18])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8de7230sm64621665e9.14.2026.10.16.08.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:17:23 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: fuse-devel@lists.linux.dev
Cc: John Groves <john@groves.net>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v5 02/10] dax: use READ_ONCE() in dax_holder()
Date: Fri, 16 Oct 2026 17:16:29 +0200
Message-ID: <20261016151638.2962413-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261016151638.2962413-1-mszeredi@redhat.com>
References: <20261016151638.2962413-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GJbuO6xGHPBjXJaywnSBZdQdS91CKRT49EaC8TczV9A_1792163844
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

A future fuse patch will utilize dax_holder() in RCU context to make sure
that the holder can't be freed by a racing fs_put_dax.

This patch just makes sure that dax_holder() works properly in such a
context by adding READ_ONCE() (equivalent to rcu_dereference minus sanity
checks).

Fixing XFS is out of scope for this patchset.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 drivers/dax/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 25836f389bde..76e8d3654629 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -642,7 +642,7 @@ EXPORT_SYMBOL_GPL(put_dax);
  */
 void *dax_holder(struct dax_device *dax_dev)
 {
-	return dax_dev->holder_data;
+	return READ_ONCE(dax_dev->holder_data);
 }
 EXPORT_SYMBOL_GPL(dax_holder);
 
-- 
2.54.0

