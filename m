Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C3A38DE9
	for <nvdimm@lists.linux.dev>; Mon, 14 Oct 2024 06:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728888606; cv=none; b=iT4EdLDFn7nuPXosUyksEwN8SMCtsVIqgNRBO8e6+RJ0zQVxko3khG3wPskkSU0NqEOnEhOWcV004NgHd4MdwvQl/Mafy4kH7debUqY4PoOB8QKKbN5IXf/WzjpRzRm75Fs1JzWZ/jIRVRrRpfyFYy0AxJGIckAyFOJXC5I6cqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728888606; c=relaxed/simple;
	bh=sij8mQmLBr227Upb/cKfVJr0KFapMnwQJyZ+mJYzfsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lXYc8KpqxFrRdTe576n03C7ockV28vH9bAH9N1ducL3B21koUl2+MET0v6A8XSSNoA2QuSRXPYdXFPFx1sERUep9zqy+xzexI+7phMNfNbwFYWeKYEF7oGKTYLtN+bQwebJ3xl8AICChKw/TJOtqSdXv9Th/3Sb1XlBGeMyF/CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Gv+9xMPC; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Gv+9xMPC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1728888605; x=1760424605;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sij8mQmLBr227Upb/cKfVJr0KFapMnwQJyZ+mJYzfsQ=;
  b=Gv+9xMPC11qGtUiY4W+vDYgM3DjGktfRHFdDR4ZF/ZSkzMX1Gems+WLz
   ITZVveLbPxm4LDS81gHEknE2E2Mo2xDATIkqf/loFxRy0tj2e/vC1kCC1
   jT09hPbBsPQl3+dmuHv5H+GMnhAO9MnN68Pm/7/Z7rENWRhAriBiEYqno
   yYmYsvmc1iNv7uDcZx0JkDNYb6oFueNncHGCZ7PA0bkB5XQCxpA42y3hl
   Doh7A5PeBrfx4thnoU0tCwEo5DUMTmP31YS1oMEzll/tEhI9uGcUc/sOF
   Us43LDnzWeidGVgXqwlDVT4LuwLuVFpnKXNNlWxFkm5VLwQzBZc1Ye2iq
   A==;
X-CSE-ConnectionGUID: /p+qDnVLQQqNUXnSPDwaSw==
X-CSE-MsgGUID: MVAaj+NgRGyz0Kh34UR1mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="178856464"
X-IronPort-AV: E=Sophos;i="6.11,202,1725289200"; 
   d="scan'208";a="178856464"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 15:49:56 +0900
Received: from yto-m3.gw.nic.fujitsu.com (yto-nat-yto-m3.gw.nic.fujitsu.com [192.168.83.66])
	by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id D4BF9CD6DF
	for <nvdimm@lists.linux.dev>; Mon, 14 Oct 2024 15:49:53 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 2865FD39CF
	for <nvdimm@lists.linux.dev>; Mon, 14 Oct 2024 15:49:53 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id B2C2E20071A00
	for <nvdimm@lists.linux.dev>; Mon, 14 Oct 2024 15:49:52 +0900 (JST)
Received: from iaas-rpma.10.12.255.254 (unknown [10.167.135.44])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 3193A1A000A;
	Mon, 14 Oct 2024 14:49:52 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH] test/security.sh: add missing jq requirement check
Date: Mon, 14 Oct 2024 14:49:51 +0800
Message-Id: <20241014064951.1221095-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28730.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28730.005
X-TMASE-Result: 10--2.745000-10.000000
X-TMASE-MatchedRID: Dkfyeyxtv0ZSuJfEWZSQfEhwlOfYeSqxa9qiaDSLgo3+Aw16GgqpO0kS
	zx2E9sLTvqbgr4tKCQvmn3xyPJAJoh2P280ZiGmRkbMiEOIxZet9LQinZ4QefCP/VFuTOXUT1Ao
	zErC5dcfkwjHXXC/4I8ZW5ai5WKlyIh+d+sRjCR9JxhRR49StWCeUEZGUktVBjH6eSSzP4B6OPu
	dWtbuMtKqZCD3DtnP8INHmxzMyXoowJcB3GTi/L3/0r3TUIHw+EWW0bEJOTAVAdUD6vW8Z1mZAM
	QMIyK6zB8/x9JIi8hKhgLRzA45JPQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Add jd requirement check explicitly like others so that the test can
be skipped when no jd is installed.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 test/security.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/security.sh b/test/security.sh
index f954aec3e25a..d3a840c23276 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -220,6 +220,7 @@ else
 fi
 
 check_prereq "keyctl"
+check_prereq "jq"
 
 uid="$(keyctl show | grep -Eo "_uid.[0-9]+" | head -1 | cut -d. -f2-)"
 if [ "$uid" -ne 0 ]; then
-- 
2.29.2

