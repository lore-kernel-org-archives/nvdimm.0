Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C7B43440B
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 08:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065565; cv=none; b=Dfa31k0F4viHo0CTuoYPbfuBsaOUvgPrc7DYdc8d+iyolfzn+3iT6TCWmZX/uC+heouQYMCFNGwiB/c9AvUUPEI6ScINNWBnBCeTBF4ZZsKqY+LcJE+o+9vSy9B3KGJdknuSuR8oN3zZYlnJMygiOlYZIGdSU+IbEhiE0emViIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065565; c=relaxed/simple;
	bh=RIOE3frsVNEF/09JlwDYf3SmDs4Wsp08R0Ba5pjSn4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPEHTMHNl/BeLRWrOSS5B5c3MvjEH0gVxNXow7jY1rPF4y9CnxAR0YqZWgpyEhiey8U5nR8R+qHjtlyEtGZgjlbOuntqd54ja9twDI5OSafot1AT8f22jpc7qv6LYjgTPYIqH0YNGWdFo1IzmjrZcMHWei80rmrohQ/eW/9eaWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NHvr7xEK; arc=none smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NHvr7xEK"
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc750a1482fso714463a12.2
        for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 01:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790065562; x=1790670362; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WvGiIb4KIaeapLTxfhgArk7ORGg9nzESK+ScS9ezaus=;
        b=NHvr7xEKYUayE6EhKP3To27VuwIp9IVEU0qFM/FLqkAJa7H3uK8YFr8IcO4jAAre13
         Zpxo/nUMHhicxeUJtboE41kN7ZsEspw3okgMdFweugTxZ2cnDZlNmBc1OlemkbaPc/Cb
         uJ2+Xc2P5WwYfbE0vBCCs3YaOuEY7zSEfhKIRdjkegcSIhqOxKPbmUOaAAvEPh6ThOxf
         gjt3g5jGzE41T7OvWdBHOQ+ol1nxSk2ZS3CG/DACFBX/xRCqlI0YlsGLToTDjiqWLSXP
         3wKi8ZD8dnQIbJsp4iKy5jLu0CPamK9sWrwg+9xLKo3OGLkPfeV252fz3v71S/TCNoCF
         lV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790065562; x=1790670362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WvGiIb4KIaeapLTxfhgArk7ORGg9nzESK+ScS9ezaus=;
        b=mYtSbWWHI+dczeJpb6a8yNJ6CwsYcrxbTjJ8wmnq2dKBmctAs9O9N8ciMoV2h/seMq
         DPRrIY1WEHWH4vZ77XEStnsMx/81rDvPPD1FBEB1X2ju8pRjPqvJRd8PvYz3VyOdGGP5
         493d0tiz4zOuNAioshvBkKpHzSha2AU/ZzR41sj5E9WTsFVkA1tpE78HmajHZP65mW0U
         Trg0gh33JSDCSG05OngvUJmP/utYaJ7dg/tPBFQlKTXVe5l381uAZMOY6qNg3YNPNpKn
         5D3dadxuLwrkwdy9nI8z0eogr7wFldx5+DKqvFOeof3tnaNdFdSTAScw/vyDGhZmijqn
         9Cfg==
X-Forwarded-Encrypted: i=1; AKwUvByEDyUpEWv5/Izg71gQSOv3mYoR9625ROqF4y7g85S5mB+IjiMgyTqv+uYdwoD7zrwRZeeKYh4=@lists.linux.dev
X-Gm-Message-State: AFuF++keL52xS7iWmq99esWamls73CyQAUIwciMikQ/dKPNSBywS5auM
	Gdfv+VcbNgS81ykE7G9+WEpEYtbvGRYySBjjlt0yyzV3vV4Wib+Dqi+0bI/DWVpYtsk=
X-Gm-Gg: AYBFou0pRPIg9TrEHsxECf6I5ZCCl1wcIh1EBkpdXal29tlNGeP1sAM4raMUxDxKKd6
	rPzRaqhkVFK59MGj1J0pZwfvKrA4ae3RFu1GoAP5eNMbeUn0XNXdvaAJhZ4id5nmS7ua+pbUD2+
	cdvUqYQj0JNeY19rg0PWOl2UjtXGODGWhNNfJFN0O/B3aWLz+24N5VNyNT7An9w3zUBOlHLFkmC
	x3gUShoiFcU1Er46Yn7iXAMrwYuqoKnMiYjdCInb2crLYxAPsnIv80HFmKiYERIZyj/QS7dRgxv
	7R+NxNQNrGw1I3aJWSJGAWAiQb0Ru87+lbfn7tunv9IOsLuywD3vtqJhw2u+r3V+91tvZbddT90
	f04NcX52mNoBuumk4l0ltZDeV0qZrLHrvhTAv9pklgiMr+0l2qfS4UybZcDSR5KA1Zs5P9b1m0n
	EtH2kTbskSkOeSq5eFxNE4PGUybKYSsr9auqM+IRwrO+5zUEvhLfwbTVWezoD7EBIE45A8WjT11
	7izPOuzN/Qo3kTHaHo=
X-Received: by 2002:a17:90a:e7cc:b0:39d:f2a1:3a with SMTP id 98e67ed59e1d1-3a0730c5dfbmr453487a91.15.1790065561735;
        Tue, 22 Sep 2026 01:26:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07385e516sm223056a91.0.2026.09.22.01.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:26:01 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2 1/2] dax/bus: fix mapping attribute error reporting
Date: Tue, 22 Sep 2026 16:25:50 +0800
Message-ID: <20260922082551.874901-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260922082551.874901-1-songmuchun@bytedance.com>
References: <20260922082551.874901-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the DAX configuration locking was converted to rwsems, successful
lock acquisition leaves rc set to zero in mapping_store(). Two error
paths can return this stale value: an unbound region driver and a
misaligned range size. The sysfs write therefore reports success without
allocating the requested range.

Return -ENXIO when the region driver is not bound and -EINVAL when the
range size is misaligned.

Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Return explicit errors before Device DAX range allocation
  (suggested by Dave Jiang)
- Move the patch before range alignment validation for independent
  backports (suggested by Dave Jiang)
---
 drivers/dax/bus.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index b809e1a264af..e40c25401cf0 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 		return rc;
 	if (!dax_region->dev->driver) {
 		up_write(&dax_region_rwsem);
-		return rc;
+		return -ENXIO;
 	}
 	rc = down_write_killable(&dax_dev_rwsem);
 	if (rc) {
@@ -1201,8 +1201,12 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	to_alloc = range_len(&r);
-	if (alloc_is_aligned(dev_dax, to_alloc))
+	if (!alloc_is_aligned(dev_dax, to_alloc)) {
+		dev_dbg(dev, "%s: size: %zu misaligned\n", __func__, to_alloc);
+		rc = -EINVAL;
+	} else {
 		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+	}
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
-- 
2.54.0

