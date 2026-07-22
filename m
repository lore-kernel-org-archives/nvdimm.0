Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0524334BB
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 18:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745339; cv=none; b=mirMvtvmnc32KVY+DOjCUOfQt2SKN2FoCQxI9NWtOeMqNpPHkGdI+jwM5H+yH8/Tb/T5u4oFWLqgR164sAt9rgXk3Ocpmmzoq9/RmZDlFSsap93GnBDZ+B8r/132NXmOB+ulbzpMZeTD19MQnNfBEjyrAaXbFIXOZh3mNq9cmYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745339; c=relaxed/simple;
	bh=dgzN1ml/vZNStxUoITE7Akv2HnDMQo21x61Qfk5F2Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcACVCrQarvf5zstCOKTY8XB2YzFnJp7EfrtSKb5OpjeKDvRWZMP3kVpdsz3v94ekJwVChstYftrzWmjLf/3siff2p73VmIY26zW6+syc04ulIKlk5o8WMBKCi3KTAwMjx4fPPXICDNVzZ5EAcC9718kXMTYhzn6nXC67GjrDPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=RCHaPqyM; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="RCHaPqyM"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51e4ba1cfb4so78503401cf.0
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 11:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784745331; x=1785350131; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ydg3Ew9SKlsgJPVrflLH252P+fWkz2RUOcmJ5pVt3GI=;
        b=RCHaPqyMk5PpuzZdzcktXFQ9AtKBnm9YJGnUzwwGYRT/t7IKKKvWLSPpW7AJafy2Ti
         sW5aSn44y2MiF8/atsuz0Fy+x9yG8RixDtaCafc9zIKVoU/OSO6AfvRZBSvjpoiBZuGm
         s8z9LfeIWZJ8jtdaCB5o4JGK0u4rQC5hUJVBKl1jkaAT7FK3eAL+bgnqP9ofyDz3DjSh
         flwQG3C+8XA8r23rwLLB3MSpOjDRkvMHBJS3FUKitX1/VwjfnRUp97XSPEBIPZGg0eM4
         0dUt+Xa3JzcS55vtE+odQqooz6rB0SSamlyUPaFyYh61K4dp4IVRaLXnoKE1oz+L1BUG
         xiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745331; x=1785350131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ydg3Ew9SKlsgJPVrflLH252P+fWkz2RUOcmJ5pVt3GI=;
        b=g+4NJQr/eaUNDqfdzHq2JzK/t+KdtFSXlhCZS8i2JIp+A+h4QZFsw7uyLM6fIY9j7H
         ijQ0x9PAHKc24dxgtaNGouSZa+Y8/+OKIHJJq/nBYHdjtEVbk9iQcT0jmUSPCuJndvBi
         U2D2Q0FEbP+NKS283BvadYMCclpe1uL0YWbVpt6E11NK5imoAK574D2X2nzgG2KDOCig
         8osb++6grXPqSLMgoW2CvN5dZ5KarpS6HuT+DmooOoErAOf/4gPyBMVPGUjXiE3PTnF4
         dHeJL6SZFmZAfSpk1nLa5gS/2LibK1DVsnJWKUw2eRiY9g3GYI821V69vOwRYkZ4l+Fy
         coIA==
X-Gm-Message-State: AOJu0Yw0+0KUkD+dj4spVpQGLsMBudTDwIqgD3d/bUY/x3f2Oda1DflN
	SSPL/TpK734ODKyeF6D3k3eixNyFYdXLnjRmkvevdWC+AcuGgSDWX55W3RafW8p0nd4=
X-Gm-Gg: AR+sD13ab+zmNj0s3nWjMVAeoEYmDh+EeIW4C1h+cvkfKHdSmzyNW+GcCNW/VLC7NLB
	V8oNGXJozAOXnbHf/mbL/mbEozTeQQE5md6/FYzsUxA/28B4uBZm7oQ1Y5CPwlRR120mylCbLWI
	TRHOiX0iO1FaHt+5xsgJEWffrSYHGIaM0s8S9g9WaPbt29G6HbCK0zWyMeL/KPEiRPwkjtdUQ2C
	i+cY96u/SpCxMY7XGG5tEtkWwQdfkSUWbBUTZrIBXfTEL91ArCeCH3iUC0I9c1wCx6WhvNa/pyJ
	OhcK8qQhFQXt0pGceDSrQwYtqAotHiR77bMYQRuShM1A9NgqIPElsFxqQ63ja/ARclcnqBDdvE8
	191AANHORgak2lKxBTcrcagvUDTBi/ybcCtTiUfGEokNDpKaURLZba4CjbddTFUpy3lwnpR5oUY
	bajnOWWFm6prrbTGx7sgrun7lDnUcDF6Ga0JBE83u+5di2k34EIBOlAUpA+un0EqWHmCk/OOwvR
	rTejaZc3SSw
X-Received: by 2002:a05:622a:ab09:20b0:527:6d4a:1970 with SMTP id d75a77b69052e-5276d4a1cdamr42283981cf.38.1784745331550;
        Wed, 22 Jul 2026 11:35:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b3e96sm27630216d6.1.2026.07.22.11.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:35:31 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Subject: [RFC PATCH 5/8] dax/kmem: add the hotunplug opt-in (CAP_HOTUNPLUG) for private nodes
Date: Wed, 22 Jul 2026 14:35:16 -0400
Message-ID: <20260722183519.935213-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722183519.935213-1-gourry@gourry.net>
References: <20260722183519.935213-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the "hotunplug" setting for NODE_PRIVATE_CAP_HOTUNPLUG, so the
node's memory may be bulk-evacuated for device removal.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 8023db23e2f99..3892ad44d4e46 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -630,11 +630,13 @@ static DEVICE_ATTR_RW(name)
 
 KMEM_PRIVATE_CAP_ATTR(reclaim, NODE_PRIVATE_CAP_RECLAIM);
 KMEM_PRIVATE_CAP_ATTR(user_numa, NODE_PRIVATE_CAP_USER_NUMA);
+KMEM_PRIVATE_CAP_ATTR(hotunplug, NODE_PRIVATE_CAP_HOTUNPLUG);
 
 /* Per-service opt-ins. Visibility toggled by 'private' control */
 static struct attribute *dax_kmem_private_attrs[] = {
 	&dev_attr_reclaim.attr,
 	&dev_attr_user_numa.attr,
+	&dev_attr_hotunplug.attr,
 	NULL,
 };
 static const struct attribute_group dax_kmem_private_group = {
-- 
2.53.0-Meta

