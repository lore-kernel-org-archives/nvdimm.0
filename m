Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F63D34F48F
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 05:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779169836; cv=none; b=Zg7zmT06/5Cx7BzlV/zMt2LQf781RNZvKiyNWKymC0LEkWz8wSZb8yJLCS/ft5rjjAoKdM/Kw2DbT/h114E7bRH/pDgssOFUC8Koxoou1T72gNEjg90yJN/NEmxYuS2wbNAbCLHJjuFHn3Ge9rRaIU9bYJljEKdxhOylLEPgGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779169836; c=relaxed/simple;
	bh=fdE73B+2YhgOK4WP6xc0MqGEBiTChQklgG2pvC74mI8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sKDG/qnu9oXsd2qRHNWIBBKpuxAnQ0KKpD5NFG/67yU33rVhGh/QDx4/R4HLMGsjd4vnaVP4ycPkyfu4Eb+Te26kQWenpzwS5MHujlic3xODrii0jwACzHGd7nhKgnaiCaDVSlCB+JQ4YSBdKXIxdClClN9bHZCVlap9bub/Hxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=nLFPiuR2; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="nLFPiuR2"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c70c112cb61so2605428a12.0
        for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 22:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1779169834; x=1779774634; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LBYQ1uikIhLCyfxlPUgX6NngwrO0Hp4sxqZIGIzdtpc=;
        b=nLFPiuR27SE4gZvAueKN4bK3MCjjjWIYJGlNdE59J53DLYUg4BA307xZ9bYavq7fRZ
         akMT04/GEYtdAkAw+hFQ1489+yDK0kRO5bXHIkGZVBjx9eRMe4wCECyYlW7aTabJD79b
         kfM3E/g0vk7j9D6x5ilNn6yxLriidF9QtvCN6X6Fm1PvNFY7157mQ0C7H4Ggleyjnv+s
         ZFGvL5avjDKPiK/D5D/E+YQBFXConVACatQ2CL5TH4naNsRJV9Zt/XQpK3W6bCj0xP/Q
         TOcdVa0tb0cWO95gBnOmrubL8vIbsntJadLU50FA2gt6b1H6ewcSenW/zUR2RJK7+nNb
         vX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779169834; x=1779774634;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LBYQ1uikIhLCyfxlPUgX6NngwrO0Hp4sxqZIGIzdtpc=;
        b=ECo3Iy7Ik7dpVZzl8Dh0R88SqoiCelWO6BxQQ/oVoCoA7eVEmaoxLAhIrkPHkGwkAp
         EmA1qmddhzAl3kosEeqE6PCEMdDTMYgZPAAX+/9eZmwqLQfucZNZr2DOI2HC2NW7blST
         Pff73ouaB/s0LLPNqg/oaNTSPjOcotihhapl/l6YECXAREEJnNvL1Htoc0iZQxg2OqQz
         ooWBiF3abVWJpSm+srLFSkjAZGzzEgNts3rQpnweLfycpU4fh0KvYtVS6n4EYrtdEhYG
         xixOs/74JCe3/41dHy7Ez4qOmDht+tiyYZGbaiaNtRO4PPGfRB97hb45dUVvmNFSLSUj
         kO6A==
X-Gm-Message-State: AOJu0YwN8vDQrX581+pzRDAYgvbJRjHUfHbm9o2UzTK++vfA3BeowmYI
	qOcy7bUJBJ8orE483rBzSxXw2uK+DiRjQTxIrdDXvfA0v0jMsA5juQjXapvWknMH/No=
X-Gm-Gg: Acq92OFXwBfH8+RC0ezB9nIlSiMfsUI3GwK4WilNGrVcDsoFpgW/i63SsAJfwhDiH1w
	SXlCwqq++zRECxDdLyQFMbgZQ4fRMrZLhiYaHjULoKBYm6732l6ADsm6mdMv/ojioXE8s9c8+gE
	bukik5iTIbOD9jJPtxN/bLXOM0q+T7TjZWHBX5GdsbxwpfqlcZKdlwkbwQSIjOpqj50ktqoS4cR
	tlmyLOpmA5d04DuBXoEsOIYToQbpuT/npSEz2pdgysbEcQD6w7YI39DVm5BEsPRymRAaCRTNXzx
	u7LRcBTBHFJ25inF1acGNiDuh3h8A16CHY4cyyjb6Y+Hy6mD33ux+lJ32w8t+2rzuuvmKWPdGOn
	0u6bX3ETmItc/W7htGsQM7CSEWBj5R9sG7LTwVfHDmtMrla/GDqwAlSVZI46Fu/yjeMfQdCO4Lu
	vh5BIRSu9qbYG4dsYAYWHClq8RTN9vEQXuEvpLqbfvHrGlrmSvxk88Vc/JTtwbrZN9uGS47YhqC
	kzV06sZJMPw086iQwMExHa5ah8v3dkQshZtCJiKZ3D3nue0JT04FPs=
X-Received: by 2002:a05:6a00:8088:b0:82f:6858:3f6 with SMTP id d2e1a72fcca58-83f33a2f288mr18205430b3a.0.1779169833930;
        Mon, 18 May 2026 22:50:33 -0700 (PDT)
Received: from [127.0.1.1] ([103.158.43.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-83f19664a59sm16818807b3a.1.2026.05.18.22.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 22:50:33 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Date: Tue, 19 May 2026 11:20:12 +0530
Subject: [PATCH 1/2] nvdimm/btt: fix potential memory leak in
 discover_arenas()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-nvdimmleaks-v1-1-592300fb7a43@cse.iitm.ac.in>
References: <20260519-nvdimmleaks-v1-0-592300fb7a43@cse.iitm.ac.in>
In-Reply-To: <20260519-nvdimmleaks-v1-0-592300fb7a43@cse.iitm.ac.in>
To: Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>, 
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Abdun Nihaal <nihaal@cse.iitm.ac.in>
X-Mailer: b4 0.13.0

Memory allocated in btt_freelist_init(), btt_rtt_init() and
btt_maplocks_init() which are called in discover_arenas() is not freed
in some error paths. Fix that by adding kfree() calls to error path.

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
 drivers/nvdimm/btt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index fdcb080a4314..e0b6a85a8124 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -919,6 +919,9 @@ static int discover_arenas(struct btt *btt)
 	return ret;
 
  out:
+	kfree(arena->freelist);
+	kfree(arena->rtt);
+	kfree(arena->map_locks);
 	kfree(arena);
 	free_arenas(btt);
 	return ret;

-- 
2.43.0

