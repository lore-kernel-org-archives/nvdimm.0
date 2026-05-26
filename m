Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B47D3DFC75
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 13:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801793; cv=none; b=iWqIW5EYMGmNtqaECEOoNrI1ViNotR6bPpkvGC7r8/ud3e9ewe4BSKcQVc9np5jxgYl5dvS3Dcx0Cwti3bEorfN1HnXJnTL1ZNaTAuNpiAiIaB+j2eIy3MBAzjQ5sNyJENZfX2kEqnpQfSqrf7c7MeNsOueGl7G0ej9mb5/BgNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801793; c=relaxed/simple;
	bh=ypIlxypoo0MqcaKrHosmayFZQHxXp3vLyQP4418RW2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjtlNUcyGQLlyQ3xQPE7PBbxrRebnzbqKF0B7AhIqWouJGUlG6/CxjuuCwz3CRKWMe/D5uXDUnsW4ZcXNXEqvGvszv5RAWu3YF18JFLt9bQkLvDRjZJ1KytzS2QKncuucJ0G4B1YqBlLgSTVSdW/6oGKBDGIfO+p5noi8b2wFN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=n6n9uNo6; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="n6n9uNo6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779801787; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=6Y4CYfAz1KoFTgmJe8Vs4uKVrzGyzI+O0j0kQAHxvyY=;
	b=n6n9uNo6qJLamRWt11PZawlnv7ECT/wPF8vWSk8uxdxgs1wIptEMmPNRjYhlUGfy2hj2VquKvfDHYYCQaVoXNKmgfmf/ErolOXoohjb/sjAIkmK8ZU3sbX+Kiws1ro8MQgXyDGuIEX6hv+DRz1WFrlajaMDPkaAbyNwd9TdgGbE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X3gT8oL_1779801787;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X3gT8oL_1779801787 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 26 May 2026 21:23:07 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: alison.schofield@intel.com,
	dave.jiang@intel.com,
	jic23@kernel.org,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	guoren@kernel.org,
	Chen Pei <cp0613@linux.alibaba.com>
Subject: [ndctl PATCH v2 1/2] daxctl: fix kmod reference leak on probe-insert failure
Date: Tue, 26 May 2026 21:22:50 +0800
Message-ID: <20260526132251.254476-2-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260526132251.254476-1-cp0613@linux.alibaba.com>
References: <20260526132251.254476-1-cp0613@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

daxctl_insert_kmod_for_mode() obtains a kmod reference via
kmod_module_new_from_name() and only stores it in dev->module after a
successful kmod_module_probe_insert_module() call. On the failure path
the local reference was returned without being released, leaking one
reference per failed enable attempt.

Drop the reference before returning the error code.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 daxctl/lib/libdaxctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 02ae7e5..ffc81eb 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -927,6 +927,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
 			NULL, NULL, NULL, NULL);
 	if (rc < 0) {
 		err(ctx, "%s: insert failure: %d\n", devname, rc);
+		kmod_module_unref(kmod);
 		return rc;
 	}
 	dev->module = kmod;
-- 
2.50.1

