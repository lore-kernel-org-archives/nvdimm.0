Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC732DF68
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 05:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779169840; cv=none; b=Jhz6hk9ZfhKYlREavA648wfmioTV6OjwCPvGabYZntk7Rfo2w+QQotRZCYGsmgePQwKQamJ+SNhvwawn32vUW7Y9DPxU894hGHXfuzeLvBufXD6N3NIO7wEePDfXWSGYw1ebbjojH3hWOSFNS5o/+mWgaCr+LysXB+ztAWDGU48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779169840; c=relaxed/simple;
	bh=XXynUxQ3LuE8fy+pLQmYNaeVurrreAUhZ7Sxgxz5Isc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VzOPXTGTYpVvSZQgAeIpZJwU8TdtGK4GNPD08jGQUGiw8ieMxCZSOs7BZGe6mqzezJeEADebbxEtAwsg9XeTlrKtjKgsGLatBe4JfLfAdmEL4wjmmccNMH7DFaxUJnfbt4GaHz3aKxsjNRwpg9xUsnBODsIBTm+18tLtiLL4+Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=HBRbgRp0; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="HBRbgRp0"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-83975e992e1so1190453b3a.2
        for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 22:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1779169838; x=1779774638; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ucHECs4zlnHCRoQL7hkpDKkM89fT0NiKrOSG8N2ICv4=;
        b=HBRbgRp0gVokcrSJlmxA+rLVkEi5FsRvXMKV/0RJhBy2Wsf+bwLkj8C1V70GVKrfVu
         ZldFJ8tCISxEDh8dRdyiBGyE6Mah4igcxwNC4yiklxo0pWMESnYzZYhZn/2R26jjZSd4
         BLf1lBsu0g1NUAwODMIVK0TbBNIivOTUN0oXJ88Ni6eF3vd5NC/Lsf6TIkTA6o4TfSps
         oV5GlpEk22RQIOuu4wRm/b3N7FWwmDJM8jceT2Y5rPhYXRMpL8jWpbXjhfYxt/15bohg
         YlpANfUrFn7cbfc9qJNQ8WJ8LVyAJ1HRVjjpn1Opbe1PO4dOtSf3nfJitwUfPH6CLcQx
         eqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779169838; x=1779774638;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ucHECs4zlnHCRoQL7hkpDKkM89fT0NiKrOSG8N2ICv4=;
        b=mBwqdxSdtPd/J//bvkHldwJhsbUmFL9HqlrkCQylyyzhqivuWqWtt4Op0bE8fHizhG
         lCWwoG4kB0TkLM5U0pqqH2STtgzNcs+R2AWaJ1gj/YSoE+6DsqyWuYPGvrJom91n63Ia
         9BwhiXxzBbMZcRpnTdoVycZG+Nwg+CtGx3QxSQFuy9spXtwlYo0JRnNKQ3Qa3Wnv498A
         dK3UgJdvEeU3WRYEe64Cz+DrSoe2Vu5vK67ecn+EOsG6X1J9jFynasw3qZFd1ZNwODNW
         6OXNuPBhBl5jjVzqAQmuH+AewfwZ1LiDGo9HYd8iCvRZMeaLpDegZ/aPb3CY6BnzqiuG
         etJA==
X-Gm-Message-State: AOJu0YzzpwRHKEfwbfVJJhBdJlruLwDru06BQ4jjeoD3xoTrI5jMfHW6
	34/5/ZMnjlIt9t3odCGYhsyVZxOoFAt6f3AmFwhTAR1kMzC48dzGC+RnYDutahqMLdg=
X-Gm-Gg: Acq92OEgXYyQDOG9LBXxs5zAWNaigHNhCKTPyvuxjCWQiEXq6K74InKnK8oxeIUmlp3
	IMPxbgV92AZkgUc4U86ELF/EQBL0vkCRlvdOeP0qZ5wrkfJu5ppysYuwPEfTYm5wiBZ3Cj88tK4
	EjRHA7U6mOHtDkpbIncjN88XWFsLiRJk7hs/aYAQbIdDlRKeIRNy+ONn1ubejR7WEpv9i4CGm1y
	elVtFNkAYqCl3WkNFnJCYikrcD6T3B56vK6/BhTETxpZP8gXGinptmsU2gRuASR3EmJnYS2Eu3X
	/YsrcJM+I+RVE0+BC+VJZ+ntLi2Jn66gDvybdGW/LbHD11qvJ8+V901aWuF8pB5/brUpCKPcxos
	jqilCsA+wDtZGHiRaEclvZtdLUaI1A0tOIkXvF8iuBplgBSes0naQ/6Omx+HloXBXJrHw+7DGfE
	NE43QGNuqEc3aNd0JA6rSt680TboYyqSD6RJ/xcHfaP9x9HOceJW6ni9TDZ8w7K019NFzwXRjwT
	o8jY60SMV1s2VqvX0/IUgXxU1WnwFlAscyEzmAS8vRi
X-Received: by 2002:a05:6a00:429b:b0:82f:d34c:ccc6 with SMTP id d2e1a72fcca58-83f33ab6689mr17997430b3a.10.1779169837802;
        Mon, 18 May 2026 22:50:37 -0700 (PDT)
Received: from [127.0.1.1] ([103.158.43.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-83f19664a59sm16818807b3a.1.2026.05.18.22.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 22:50:37 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Date: Tue, 19 May 2026 11:20:13 +0530
Subject: [PATCH 2/2] nvdimm/btt: fix potential memory leak in btt_init()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-nvdimmleaks-v1-2-592300fb7a43@cse.iitm.ac.in>
References: <20260519-nvdimmleaks-v1-0-592300fb7a43@cse.iitm.ac.in>
In-Reply-To: <20260519-nvdimmleaks-v1-0-592300fb7a43@cse.iitm.ac.in>
To: Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>, 
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Abdun Nihaal <nihaal@cse.iitm.ac.in>
X-Mailer: b4 0.13.0

The memory allocated by discover_arenas() or create_arenas() is not
freed in some of the error paths in btt_init(). Fix that by calling
free_arenas() on the error paths.

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
 drivers/nvdimm/btt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index e0b6a85a8124..7e1112960d7f 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1592,7 +1592,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 	if (btt->init_state != INIT_READY && nd_region->ro) {
 		dev_warn(dev, "%s is read-only, unable to init btt metadata\n",
 				dev_name(&nd_region->dev));
-		return NULL;
+		goto err;
 	} else if (btt->init_state != INIT_READY) {
 		btt->num_arenas = (rawsize / ARENA_MAX_SIZE) +
 			((rawsize % ARENA_MAX_SIZE) ? 1 : 0);
@@ -1602,25 +1602,28 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 		ret = create_arenas(btt);
 		if (ret) {
 			dev_info(dev, "init: create_arenas: %d\n", ret);
-			return NULL;
+			goto err;
 		}
 
 		ret = btt_meta_init(btt);
 		if (ret) {
 			dev_err(dev, "init: error in meta_init: %d\n", ret);
-			return NULL;
+			goto err;
 		}
 	}
 
 	ret = btt_blk_init(btt);
 	if (ret) {
 		dev_err(dev, "init: error in blk_init: %d\n", ret);
-		return NULL;
+		goto err;
 	}
 
 	btt_debugfs_init(btt);
 
 	return btt;
+err:
+	free_arenas(btt);
+	return NULL;
 }
 
 /**

-- 
2.43.0

