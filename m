Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CCC221578
	for <nvdimm@lists.linux.dev>; Wed,  5 Nov 2025 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355322; cv=none; b=g3eOgioAHSkWO2vH8yeh2O/liRMSuA4HVcaevh1fcxkK7l2GL/TYSPzxAFSuyAGrfAHUKXv+0CT3VqRk9jzkx12iNqJUMWKBwVi+KcNCCJIIfDTEV6GhD+5t5I8cY3iKIDiittb7NWMgei+Il+x5KDeCM6gC5dMY6Z/D5jQhCYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355322; c=relaxed/simple;
	bh=Hf/rfLR96qfpPUUD2e/foDC8QeKSEdcQO3QrgpjU9tc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WxPAIKyIhubwvuVewygz8NkboUNTruDEGVbeHi5nQqCKWATStRVB6HegOz983a5GZxsHbdOQOLB/uh3zOct9xt8Vyw7V0182qt0SsrrFxxe10XRnd12xoE6g+uQXcjFkOC61VIbeHUz+VTmfH/HqsQ0Wq6zWWmT1+dzAUSYSLoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SzuiG3qa; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SzuiG3qa"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-429b72691b4so5944351f8f.3
        for <nvdimm@lists.linux.dev>; Wed, 05 Nov 2025 07:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762355319; x=1762960119; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=itio/ZsVwLCabLmzfTJkSF00ft7NW0DfrxBlVBCeKeY=;
        b=SzuiG3qaosLXHRPcKcfm8hUy+5HbN3kJYUpEpo+d+G9KjW4MpCVle5PA9IYjw+nwJr
         D40cBkRzPhipaksblpQ8Hng0JycRjTBiClkAgOeEqMUvT+CxjQFodpFLwBkpX73xfws4
         vNOP/cQNGS+ATorbw3sPXGPhrKrY8Lkw+ljdnDs0VDz2UZWwrgvyz1AxtwikVtfRbg+x
         309bfZeZHcw+8e4cd6ljoW1l60U0P4jTKy4cJpWL9FLSoLLEEsz78JDPrvpmVBj+68fr
         5qsAPPBkUXf9okL/jh4ykW1mlZYrcpgd14JFzUB9327WLiBJMzPc418pXeaPl2a9DoSu
         s/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762355319; x=1762960119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=itio/ZsVwLCabLmzfTJkSF00ft7NW0DfrxBlVBCeKeY=;
        b=B63RnzIb5ajmgcDw/nw2mpbBIXNPZ+U1g92mjNm0Rjo0dpLbB7KV3aWP925FCxG8V1
         zPOmscxjtocCLJtzvof0J2CHH/RsFv4FFDCH8PXKqYmk9dlEB/u+z6qaDvYwhIq/akyd
         OYkKRmAoMiYlX0Z5ao5qgtgs8jUTkcpZXzclr1jAlWPZO2uo87isbABUuvWHagewb5Bt
         o5hCvomREway/NPKyps4DDA29LOM8ZLbJZatcIj0bjT/tZ4DUSy9HsXK2XKLLCRAHh5Z
         45ic8BBGQ4WS8Z+7KB0Aq+1oZ5fpLa2PoBhnbfp3bAVvfNXzjnpOs89UGG0TneWL00im
         4s6A==
X-Forwarded-Encrypted: i=1; AJvYcCVE0RTB45vrXGxpjzzt5u000Y9nrETeP4wO8JWtxFaq1LX32/kUh55gIxEuUkbB8H66CoXIwwg=@lists.linux.dev
X-Gm-Message-State: AOJu0YysRW57WtegzZrg+mfTMLlStvb3l9MlzGXcXoc5wpBIkvE9xDjc
	xwFsTaTS33ptXQZVjGLtdcUXDPhj6Y9SQimiBhvUVFFNTktEXKB3WqJNDDJA5Rd+LdE=
X-Gm-Gg: ASbGnct3GiJCSomtpkmzpllHRjTTy04Maf5VdOIKKw4dc/Bkla9enX+u5ZLK/dggv7o
	vOI+ursuYGP0J0NS8vDIfntZjPe+HR3XdLrY+ILJy7g5xfQB0LxYkleLxY1X97hjcSiWzXxoK+F
	cYw0KsrhzQPQnfGQcchx8Fewb4C9NPxMRz9OopVi6Rs/VT2Ah8CAzwvJTKLsOH0XHRXZ5waEfbN
	VVq/Xq0l7/fS4vWttvHtSxpiXax0hLW7wPa5z1WVtbTqBFgdLrgAEN1rsrvGfifF/UumcCgQ6ju
	Uf+XTEAd88bZEC1TAikdfFiG1TsrnDu91rk5TA7xqgp8vUvOnqeaDS7ZHB9fwelsqfeuqYY+f5+
	h3Uq06P7Q/wXn75opXK7dOH95DBATVQ0+adsUe5g0rdAj1whlPZRFvImDORpqeHetc2fHrNKDls
	H7YDUWBBno+89RvS7nJjRSVFzPmkJpvlFHzA==
X-Google-Smtp-Source: AGHT+IHyjVa1GIzRPu08WXNQml466hsDkpEFv1Tr9nN3l1ce6eu3HfF96OLNZcs85q5I7sclBYcfoQ==
X-Received: by 2002:a05:6000:64b:b0:429:ce0c:e67e with SMTP id ffacd0b85a97d-429e32e516amr3160567f8f.19.1762355318901;
        Wed, 05 Nov 2025 07:08:38 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc19258bsm11750758f8f.12.2025.11.05.07.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 07:08:38 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH] nvdimm: replace use of system_wq with system_percpu_wq
Date: Wed,  5 Nov 2025 16:08:26 +0100
Message-ID: <20251105150826.248673-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistency cannot be addressed without refactoring the API.

This patch continues the effort to refactor worqueue APIs, which has begun
with the change introducing new workqueues and a new alloc_workqueue flag:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

Replace system_wq with system_percpu_wq, keeping the same old behavior.
The old wq (system_wq) will be kept for a few release cycles.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/nvdimm/security.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 4adce8c38870..e41f6951ca0f 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -424,7 +424,7 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 		 * query.
 		 */
 		get_device(dev);
-		queue_delayed_work(system_wq, &nvdimm->dwork, 0);
+		queue_delayed_work(system_percpu_wq, &nvdimm->dwork, 0);
 	}
 
 	return rc;
@@ -457,7 +457,7 @@ static void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
 
 		/* setup delayed work again */
 		tmo += 10;
-		queue_delayed_work(system_wq, &nvdimm->dwork, tmo * HZ);
+		queue_delayed_work(system_percpu_wq, &nvdimm->dwork, tmo * HZ);
 		nvdimm->sec.overwrite_tmo = min(15U * 60U, tmo);
 		return;
 	}
-- 
2.51.1

