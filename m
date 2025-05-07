Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B46153BD9;
	Wed,  7 May 2025 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746636382; cv=none; b=A/wKX22B92V4i+DX/RYE75fQYoXj6akXDHRtkAN+izbV14LLZfJeLT6cYCKvtK/GFErRRZLBCks8AhfbuNzCNt389HffTZg2nkM52Qau+VmnoLk4z8nxossfQFUo9CTBQqro6dasFcG9/ok/rWgXsrEEyZhtfz4v6n7UPS3TdQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746636382; c=relaxed/simple;
	bh=OBWVduvWR+I8XfrtoMjegIgenaJgCDzEvkTk7/FFpc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZFVkz2P17xcSiz85XVB6kaiMmy8umKcmaiPTdaSJxXpJwZGw/a/YgFYydxa8V4eh2pZrk4oBAThfMW5FEte0niziaWaPTTjFdviDnSQGTOV4a2PAcoEGhw7OED00c4R84X0ZQsvEiO+sHx2SX1zt5nLADGZ/0Tdk4ZqvSu2Ufas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DC0C4CEE2;
	Wed,  7 May 2025 16:46:19 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH] cxl: Change cxl-topology.sh assumption on host bridge validation
Date: Wed,  7 May 2025 09:46:18 -0700
Message-ID: <20250507164618.635320-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current host bridge validation in cxl-topology.sh assumes that the
decoder enumeration is in order and therefore the port numbers can
be used as a sorting key. With delayed port enumeration, this
assumption is no longer true. Change the sorting to by number
of children ports for each host bridge as the test code expects
the first 2 host bridges to have 2 children and the third to only
have 1.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/cxl-topology.sh | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index 90b9c98273db..41d6f052394d 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -37,15 +37,16 @@ root=$(jq -r ".[] | .bus" <<< $json)
 
 
 # validate 2 or 3 host bridges under a root port
-port_sort="sort_by(.port | .[4:] | tonumber)"
 json=$($CXL list -b cxl_test -BP)
 count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
 ((count == 2)) || ((count == 3)) || err "$LINENO"
 bridges=$count
 
-bridge[0]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[0].port" <<< $json)
-bridge[1]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[1].port" <<< $json)
-((bridges > 2)) && bridge[2]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[2].port" <<< $json)
+bridge[0]=$(jq -r --arg key "$root" '.[] | select(has("ports:" + $key)) | .["ports:" + $key] | map({full: ., length: (.["ports:" + .port] | length)}) | sort_by(-.length) | map(.full) | .[0].port' <<< "$json")
+
+bridge[1]=$(jq -r --arg key "$root" '.[] | select(has("ports:" + $key)) | .["ports:" + $key] | map({full: ., length: (.["ports:" + .port] | length)}) | sort_by(-.length) | map(.full) | .[1].port' <<< "$json")
+
+((bridges > 2)) && bridge[2]=$(jq -r --arg key "$root" '.[] | select(has("ports:" + $key)) | .["ports:" + $key] | map({full: ., length: (.["ports:" + .port] | length)}) | sort_by(-.length) | map(.full) | .[2].port' <<< "$json")
 
 # validate root ports per host bridge
 check_host_bridge()
@@ -64,6 +65,7 @@ json=$($CXL list -b cxl_test -P -p ${bridge[0]})
 count=$(jq ".[] | .[\"ports:${bridge[0]}\"] | length" <<< $json)
 ((count == 2)) || err "$LINENO"
 
+port_sort="sort_by(.port | .[4:] | tonumber)"
 switch[0]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[0].host" <<< $json)
 switch[1]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[1].host" <<< $json)
 

base-commit: 92d5203077553bfc9f7bf1c219563db0fc28e660
prerequisite-patch-id: b16d7a7db948e38a7752c12bdaa34116b5967e00
prerequisite-patch-id: 35769202bdba1fed259c072ca7ef279c075131e7
prerequisite-patch-id: b85fc29353224d045e8793c99829f4b372095629
-- 
2.49.0

