Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7A6139B;
	Thu,  8 May 2025 20:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746737065; cv=none; b=HE3+SdG0X+LQ7z5w9cSkSRSt8GBUOl7s/wljIXzF7Kdt+76rMoDSRS9jcu95ErLQwxgAidoBxGpIbOAcpMG4kR4zC3B2hfhHDYjQbMflSEeyFQ7bz1iqjbE4G0omAOpeU/QohCgGh/dxplAYt0V+Is52TFiTwOPnX3iE86rD9dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746737065; c=relaxed/simple;
	bh=M5Q/pM22WtIGtn3tXeEWQ0CmNExaO39LhRuhknpTPPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jd21ff1bLARC+mBSYdX7c8wMBxTTK63Q5VzWBPJQnmiGvM1o7FEkY8TJau6n6zAfgkANRZdAnWtzd6RBYv2Jz8syoECrGHe4vyr22d4/BH4rc+LdscW0ZBgj8P4j+1yJHFvM4wR5Cat1PLrXU6cvs57vJSQ1xqpLkRIoMJ4QAuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A17C4CEE7;
	Thu,  8 May 2025 20:44:24 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [NDCTL PATCH v2] cxl: Change cxl-topology.sh assumption on host bridge validation
Date: Thu,  8 May 2025 13:44:19 -0700
Message-ID: <20250508204419.3227297-1-dave.jiang@intel.com>
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
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
v2:
- Merged Vishal's suggestion

 test/cxl-topology.sh | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index 90b9c98273db..49e919a187af 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -37,15 +37,37 @@ root=$(jq -r ".[] | .bus" <<< $json)
 
 
 # validate 2 or 3 host bridges under a root port
-port_sort="sort_by(.port | .[4:] | tonumber)"
 json=$($CXL list -b cxl_test -BP)
 count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
 ((count == 2)) || ((count == 3)) || err "$LINENO"
 bridges=$count
 
-bridge[0]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[0].port" <<< $json)
-bridge[1]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[1].port" <<< $json)
-((bridges > 2)) && bridge[2]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[2].port" <<< $json)
+bridge_filter()
+{
+	local br_num="$1"
+
+	jq -r \
+		--arg key "$root" \
+		--argjson br_num "$br_num" \
+		'.[] |
+		  select(has("ports:" + $key)) |
+		  .["ports:" + $key] |
+		  map(
+		    {
+		      full: .,
+		      length: (.["ports:" + .port] | length)
+		    }
+		  ) |
+		  sort_by(-.length) |
+		  map(.full) |
+		  .[$br_num].port'
+}
+
+# $count has already been sanitized for acceptable values, so
+# just collect $count bridges here.
+for i in $(seq 0 $((count - 1))); do
+	bridge[$i]="$(bridge_filter "$i" <<< "$json")"
+done
 
 # validate root ports per host bridge
 check_host_bridge()
@@ -64,6 +86,7 @@ json=$($CXL list -b cxl_test -P -p ${bridge[0]})
 count=$(jq ".[] | .[\"ports:${bridge[0]}\"] | length" <<< $json)
 ((count == 2)) || err "$LINENO"
 
+port_sort="sort_by(.port | .[4:] | tonumber)"
 switch[0]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[0].host" <<< $json)
 switch[1]=$(jq -r ".[] | .[\"ports:${bridge[0]}\"] | $port_sort | .[1].host" <<< $json)
 

base-commit: 01eeaf2954b2c3ff52622d62fdae1c18cd15ab66
-- 
2.49.0

