Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5B02D248B;
	Fri, 31 Oct 2025 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761932407; cv=none; b=TsIU5AKw5lJJyi45OaCKnu9efTcy6mYX7zixkiLAbC0l1rx9719BPLUOnGewb77Qt8db8Yq12BKBdJj3HY1b9Eb2RcLKNBXzFEXI1JSttbxkBvvHy01NUKxKEKm1LKkg8ehN3uIm6JujYd2ZMJ6QYLbIc4eg1apYzg8l+AhAO4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761932407; c=relaxed/simple;
	bh=Aidwe89A4A1Ao8mxMKyNVClrI9cTLeJUogMh2dv6L7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpCkub53Hh5osq5unHKHimg1Ezm2LR1qA22sgVxGzTGKId6eud2ieF7/Tcg2RyotBX6zB0v8OBGNM3kE870Uk0cuTFQa+OlhCIMls78wDzTjAbDWotoQiSBQ5w43p08P4tm4QIKVs3YRsMrJlWCut3u7e3DbaxUgsNJ5mMouobg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1A8C4CEE7;
	Fri, 31 Oct 2025 17:40:07 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com
Subject: [NDCTL PATCH 2/5] cxl/test: Fix cxl-poison.sh to detect the correct elc sysfs attrib
Date: Fri, 31 Oct 2025 10:40:00 -0700
Message-ID: <20251031174003.3547740-3-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251031174003.3547740-1-dave.jiang@intel.com>
References: <20251031174003.3547740-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cxl-poison.sh script attempts to read the extended linear cache
size sysfs attribute but is using the incorrect attribute name.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/cxl-poison.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 231a0733f096..8e81baceeb24 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -197,8 +197,8 @@ test_poison_by_region_offset_negative()
 
 	# This case is a no-op until cxl-test ELC mocking arrives
 	# Try to get cache_size if the attribute exists
-	if [ -f "/sys/bus/cxl/devices/$region/cache_size" ]; then
-		cache_size=$(cat /sys/bus/cxl/devices/"$region"/cache_size)
+	if [ -f "/sys/bus/cxl/devices/$region/extended_linear_cache_size" ]; then
+		cache_size=$(cat /sys/bus/cxl/devices/"$region"/extended_linear_cache_size)
 	fi
 
 	# Offset within extended linear cache (if cache_size > 0)
-- 
2.51.0

