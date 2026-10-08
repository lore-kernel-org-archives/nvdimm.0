Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EFC3793DC
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 11:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458417; cv=none; b=McAObJz6545YCgN6NhtlS5EJbFb/LJWP/e8+uHgVEAeTIm8caqEnaatftvN8gUYF+3hwbHllBBLiFXQoT6FfGHKTGEsibFgdHQRiaDTZm+W8aWO+nIeSWOJzTi74ePIQ2S5+AXwPqtIo3Gx31G6OhWfnB7C4y0sr9nQ1ME/u7FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458417; c=relaxed/simple;
	bh=B3VgAzE1fV6NLyqOFguVSmI0qJqk/diBymVTA99Hj50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=OLAtrdtC1uRde8v8a1n5f1Fy9mDPAOCSa8JbGKkFOumT+M1Z1XCK0UPiRZKIswjxbCg6BMc0v5tbkeKS4w2HbEv3X1DiE/y/tvQ+JTBlUMyi52+k+BoW/makjzcaejUwkGTLF9T5D83h4u5etEuLXPeVV+EmmbjF6nBOVxnqI80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KkuZyxm7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkuZyxm7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791458415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eic19mjHB9HL/L+XEW5Q/d+IffJBXxfVI0tTJopOLKE=;
	b=KkuZyxm7yc9gtUKSqENx7WhjQxmHH+IFdpkIXer59H/zr38/CKMkjH9XWos1uvTitThDRa
	3sNWlEKVIM7QaTw+7SoQGn5xWrukpGLMZYhYs6ayhXz/eHzp4CQXXO/DRcVKnwVDF1rKRF
	c/K9583fu3Sg+VzLRwez18sF5NDDzlw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-Zkv9X8zxPA-0k-dDFn9ILw-1; Thu, 08 Oct 2026 07:20:14 -0400
X-MC-Unique: Zkv9X8zxPA-0k-dDFn9ILw-1
X-Mimecast-MFC-AGG-ID: Zkv9X8zxPA-0k-dDFn9ILw_1791458413
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c210c66672eso233903566b.2
        for <nvdimm@lists.linux.dev>; Thu, 08 Oct 2026 04:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791458413; x=1792063213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Eic19mjHB9HL/L+XEW5Q/d+IffJBXxfVI0tTJopOLKE=;
        b=hTyqAMUZD1y3/3TOBaqGKolSvKl7KlhqZ/79JHc8NpBjtMG8NN4xKVw6n1HVWSO5Tx
         PZ6dg9sako9IP8gyncdZ0rJV2CBzKToNx3isWm674mudmvstA1WzPjF0l00a+cHx+XkJ
         2z9qcRfm0BOqUdt5hFC3NoiMcO1haw7wGIDx5972lTggwc5FIu086hBbKkBGHn3Vw6Nh
         AFhgVLdXtqeMz8xMyTpqImP14ScJMGBPzzGX5zc11CT/5HpVwRgE9BLf5ePB7EcoKW/S
         mGPq7GidG0xnyL8HgVB0Frc4bcwrtf06emst2dKkyn3jvzLIUg10255dkVCBOfFfzwOP
         4g3Q==
X-Forwarded-Encrypted: i=1; AKwUvBwohI37Zy6BYFcnEtddBMJgTemY6NEBmJYhEDkcrOwulhKHmT3RKA3+KAEE8Wa1+5xzwJCvBqQ=@lists.linux.dev
X-Gm-Message-State: AFuF++lBivX9td5fq4FKU30Yq2sCHXMLajmHn0AVCENnXAAR3rh8GJLe
	j44lBujtg6U3052gtuF1Z8MBJMHMvQRyVW8nNi44TWdbDEFA4Tgt5cIcqwFmcnFo21Gy0/DUGwi
	m/BhQ8n7XioOnx6KE1g8C+z4n6FORrc4AwE3Z6KYD+mwvr3H1ZzLpuQ9wkg==
X-Gm-Gg: AYBFou2gqX+5ylWKPafdHs7Oyv9TuSd0drFfTYsMp8i9JKxvE3g8Nl2fuwd4BMsJfWR
	X54hE0Mb9GZam9gSIEXr8DccTbVglFnpZ0ME4HBiTyZ3mqg71g62IrMSSvDVQAcOA369egLUMhg
	ax5anCjcBQvqzOkrUE+hANSeNl7SGe0BIer0QWY5s4eHr3zA8zYnaECwpqXElurkr7X+sMrE7R4
	VxgGzfl8xASV1GwL6qBUd7x7lWEDS8FWphC7jVUBXp9y9R4iDjpPoZBcZhZH3DIZfyJ2ujJitwS
	wWRJ7hDQnub3JOmaOLaZLTdYwfO6edemNpuCVEgxZmF504t+EjBv/dj2XkLI7ALQLGgc+BQjZyT
	/+41LQbfbNruZuEGDZt7hrgFK8lELR4jjHXCBUvZnOTQMb2nG5wQqltIp
X-Received: by 2002:a17:907:1ca2:b0:c2e:969:a4b0 with SMTP id a640c23a62f3a-c317c11a3efmr469399466b.38.1791458413044;
        Thu, 08 Oct 2026 04:20:13 -0700 (PDT)
X-Received: by 2002:a17:907:1ca2:b0:c2e:969:a4b0 with SMTP id a640c23a62f3a-c317c11a3efmr469397066b.38.1791458412617;
        Thu, 08 Oct 2026 04:20:12 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (188-142-152-55.pool.digikabel.hu. [188.142.152.55])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c317c2fae53sm204251866b.49.2026.10.08.04.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 04:20:11 -0700 (PDT)
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
Subject: [PATCH v4 2/9] dax: use READ_ONCE() in dax_holder()
Date: Thu,  8 Oct 2026 13:19:53 +0200
Message-ID: <20261008112004.1899560-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261008112004.1899560-1-mszeredi@redhat.com>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PZkWXVliBJA-kR7lKrCQj8JxV_nd9X9L7x-EcOSh6q0_1791458413
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

A future fuse patch will utilize dax_holder() in RCU context to make sure
that the holder can't be freed by a racing fs_put_dax.

This patch just makes sure that dax_holder() works properly in such a
context by adding READ_ONCE() (equivalent to rcu_dereference minus sanity
checks).

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

