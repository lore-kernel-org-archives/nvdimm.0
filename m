Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C5F4F798C
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 18:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745341; cv=none; b=ti+fhdCRxg/4BglGKf+22lsTMO02Mh5V6ZUNAeLJSdi9vEYmHG/zM0RCsQvNHcdoHg+PoWSG/1oG8h5qXK6Ei3Ow8idFXzKhjqP4CRuqlc6tHxg3MFcgxdlxlqeiz6ZPvokvFbDM/UaXS7CN8X8AjtpW0C47Xq6+p+o6QNLJJ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745341; c=relaxed/simple;
	bh=aZvh7cjs8n0vwVyW1NeCATzVIIYdYHctZyuk2o8ZeXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pe0bfjpbTQGMeIihGYxPgusb9nv7l9CrZcGg5K3hYtXiPjB1jzWhBYvo8etH+JfWUmGTPfBry4Zy3hFDyvaZW+QVSxVuhxgrIJSMqTCJrw0X4ZLYrOkkU9hVV0ZnOM3fdngLetFk32s6tj2rWWVLwhonM3uHFCxPDFy82TljNCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=FQhpeSYL; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="FQhpeSYL"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8f256eaedf8so153004016d6.2
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 11:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784745333; x=1785350133; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=omLFyYU+0hOal/m0+vDT5H6Y4PKzwMuevbEHJKxRO6c=;
        b=FQhpeSYL2h8fmF8OX9MNYhNsDMinT5TYZmTqPXJcRJlLwFhAu/jVSoDvllg51Gbch5
         FzEyqu2c9FhuwFgmddDaB9QacvHvm6JEJAJdNS+3gfqZVJQBIR3lfb8Gmg9YSJ9tu4lS
         5D4F5ZvvL1+HSR1N5bx3Z5HeDqapwrktOy+Yic6WBTQ025xwcOQdwAfFfuTDtARXxioY
         FAZiy3DJnEmZF9+8OV22dq4baVkiBv4npyuelOSW/uTHlPSa/O5TybBdDrtxKrB9XTin
         RCOINBEpRcSCqhskhgZkA8UIFYgay85R4asNCziwr9uwf/Qp3vcKaIAqUJupHJsDOn+D
         HGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745333; x=1785350133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=omLFyYU+0hOal/m0+vDT5H6Y4PKzwMuevbEHJKxRO6c=;
        b=TF+sK24KosKF/yehD9iZVc+7UK4rQViViaZmW35wLnEhcdbhuHq/uQS5UVD5RqgWWe
         7+LhVOk/fTXwVPuPemorG0i4tCEmw8uO+lqN1/f5Lb/D6dtZsrHmj18+piT80oQeqeor
         rG4zXPHVVivDdzd2secWfDqAHan3CJmPPyzwa6ag5WkPzwcVmsuAgoZvfjh1dfyHkVDH
         YmOn+M0D4N2EiIOAY+3l83Y9Es4CFuLscbdYRwEx+BmgyNfrJ8IRx+6Q/kqODpEhOwgC
         8s0I2WFSBlpjQP1w59ifXTcpnUvrdXKCv+YZTPKxyUzyuDrVhi9Yzy0zbdKAgQCGnqHl
         VOvA==
X-Gm-Message-State: AOJu0YzXueAoUxATCk6zGG0iDbGtrotHVWiRHp2Aeu4IEh8JKXX5g/33
	x/oUb4RfZTBUUl0CA/gVlmVS0656zHj/2do07gFN/ysCVWZECltljHzgTB0Z2rQgfQc=
X-Gm-Gg: AR+sD13CrPiQNwhuEPhLVANNBjE3NPPMsaGL0NlJ1IIJEW5LB5jIeeGNvxVy52etoHb
	0zOkX+j5nWR8ayfGVlJzDpwfg9+Jjm3oJkcoRWFneb3jpwW9aokp5sCGR3sGVNsifoGbAQap2V0
	3Oe/znQ2xDDohsuQ6z64eFR5Pe91JSxTwboXoo4mDyEwCGBnsPagt6Tt4isfMAy5AfvtIwrX19z
	S8D/AVAlD20iq7KtSdAhUIxeHDM46fStpKm/+bcZpF9R3wRrvZ36KyN1yvyRB1IW9Vuvl+VVOm5
	tarkh9a2aUgcqRGlEmlLmxTy9TQVhnz/dMmTDJVdk/p00zWY/r2BBqNoxKFPt1+jbAztHriJzq4
	d/2vnCNlxWBp4YsrXVrtYGNlE+T3N2dw33b8IdMVVcdpNYfbUtlaVNPjbKumRt4eUbNvzKWFyG+
	3EJeID8pSUQgdn5JwFCAauuIVzF4Z+mEzZ14OnnR1YDP/8BTf5ziaJDe9U0VPcwxX56QhjkiViz
	w==
X-Received: by 2002:a05:6214:3c9f:b0:8f0:2fca:8246 with SMTP id 6a1803df08f44-907ca56c5femr164246d6.52.1784745332786;
        Wed, 22 Jul 2026 11:35:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b3e96sm27630216d6.1.2026.07.22.11.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:35:32 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Subject: [RFC PATCH 6/8] dax/kmem: add the demotion and numa_balancing opt-ins for private nodes
Date: Wed, 22 Jul 2026 14:35:17 -0400
Message-ID: <20260722183519.935213-7-gourry@gourry.net>
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

Expose the two kernel-NUMA capabilities as separate per-device sysfs opt-ins:
'demotion' (NODE_PRIVATE_CAP_DEMOTION) and 'numa_balancing'
(NODE_PRIVATE_CAP_NUMA_BALANCING).  demotion additionally requires reclaim,
enforced at hotplug by node_private_register().

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 3892ad44d4e46..1cb3384c003e3 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -631,12 +631,16 @@ static DEVICE_ATTR_RW(name)
 KMEM_PRIVATE_CAP_ATTR(reclaim, NODE_PRIVATE_CAP_RECLAIM);
 KMEM_PRIVATE_CAP_ATTR(user_numa, NODE_PRIVATE_CAP_USER_NUMA);
 KMEM_PRIVATE_CAP_ATTR(hotunplug, NODE_PRIVATE_CAP_HOTUNPLUG);
+KMEM_PRIVATE_CAP_ATTR(demotion, NODE_PRIVATE_CAP_DEMOTION);
+KMEM_PRIVATE_CAP_ATTR(numa_balancing, NODE_PRIVATE_CAP_NUMA_BALANCING);
 
 /* Per-service opt-ins. Visibility toggled by 'private' control */
 static struct attribute *dax_kmem_private_attrs[] = {
 	&dev_attr_reclaim.attr,
 	&dev_attr_user_numa.attr,
 	&dev_attr_hotunplug.attr,
+	&dev_attr_demotion.attr,
+	&dev_attr_numa_balancing.attr,
 	NULL,
 };
 static const struct attribute_group dax_kmem_private_group = {
-- 
2.53.0-Meta

