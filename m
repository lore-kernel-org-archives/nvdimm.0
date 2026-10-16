Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ACD456E0B
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 21:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792186987; cv=none; b=XUmaZpad9uDy4LO2qcGEw1zJDLpBMtawsmWab4GyY3L7o7tIMgpJaSEgCKM20MwKPK6nANitObmks8d1kVPCpLLKt6pyMz3GYbbyvWMkEpxIWrYWNOHJQn2ESPfH9QLiCyv6SVQZ1cF+lObUJW+l9BHStpdvzN93ypt5StXASfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792186987; c=relaxed/simple;
	bh=hckdEyUJ8XXReuziTgLHvj1aSK3PhY7w+gNx7VOLcMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+dEU0IrunD+QyMv0gYf+l3IiTC5l+uifq9P+ozCdWSoslPF2oz371wwub0zS4rx8LMPrQlgN11lTGyIYEX2Jo4DYexQJqJH4Jx6I1xT1hk+oaTD/VvknOjGxP1Ej/bw6M6gcmlIdNBIrb82ccFz0O4BwHQMgzwizo36sQ0Ae6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=NaVzGw73; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="NaVzGw73"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f1cf92c9eso31041785a.0
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 14:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792186983; x=1792791783; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SOw+IILdCxMEGN7nWIcZs76snWj85SrKxmlvxOvNYy8=;
        b=NaVzGw73bjfrgDI7JIKUC97H8aey241MKDgAoMpOL1yNQzP0IuHOWTmynw9Jj4qdBd
         QkUmO0EQPsT/h03z8LNj6Fg+5HOIe/68N9TkIMXYTUz9sAC7CfGoegNbefrEBEBRRTMh
         zqMcn6Ami3AirigbWZOXsQo5/Nh3Zwo8xXBmTCBgcWPlaLh/2Y7bt7AaCsq31CKcV0+o
         aRoXPeoBuaCo9WTsYYaaXZCyw7pTGBIjD7GP+LAilBTrNG1fihoqCxYX/eb3Y3f+35vZ
         3BbjUewZ4aKUGlG+Se6nFDohtkDmqzqJVU+LZyvhG+LC7j/w1srV30Eg+m12h4hGPexB
         AISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792186983; x=1792791783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SOw+IILdCxMEGN7nWIcZs76snWj85SrKxmlvxOvNYy8=;
        b=2uDmmjE7UDFicM+yDhanq98XT/hxpBt0bAsOSkErG3/8JM9v0iJ64YkZpate6iP1Nv
         xH8Kg+ZaPWoIuxzrQ/zpyrksgy13XZ3eV5X1s2F4emN2G5AVTtEdM5+O3J1B6AIXHyQ8
         XNZs4s2F+B5xAGnajMglu/7X2+YHEE3RQK9wmaGH4wIbBVPhWw8oSaIjHThm3AhFc1LR
         pZYJD5F4xLk4MaUjk4aroA0FSP3xdrLy1Fncfiez7WmeT4/vrbSDZE63UEvZKp2ZX/Q6
         yonRwjy/R0m82x5JVshwsJsT+bEl13tNIdqAPvYI8MuXSMdtPLpNRo8o5iqlrNB5raHE
         vY8Q==
X-Gm-Message-State: AFq9FYL60TVpIqWeGb+WCxBSx9di3Q/+xjCjxmATJosIORnA+kz1Wsv6
	9T1rZAcRs8oWVh6c4MHtVEphFR6jeKzeFm/g1frXr2trAdBmkmuACuV4JJdpBQXOyuqeMEBC4Zq
	QuFYvYAU=
X-Gm-Gg: AYBFou0K6X5A2C3Hd7G3Pe1NxAbexioZ76lgRFAh9bjGuvBVYsdWhf/CFq6xH7jQQYj
	AT5ukXR9RYQY45sA5+AeIUNom0Hx8IaaKmQSkQxia+/rfFpNc1mtV9ZnDtxH4xiOm7c/KorC2NR
	4jpmQt+8dqGyYWCeea65TP30q6xdzo/hhRSczvL7GWCZxUZdR3uVWIcTP7b3rO+23Z+NABhswEG
	aEyDsWSS9le8tCt+0D8fFfnvPZOmMDRQznvWPzFKKb+ayCY5iYWsJkQkEP90OGNz9gCgNRyJpkz
	gR2FQQAY1GmxAcgSa6zRZ/iA43UYiSyJrlwxGowkzWq9FJK8z8kxGzBXQwzMt6GmkxJH4H/p7e2
	3ndj8fKf5w/eh/iHf5kKqqbVND3779zvp2WhOQi0q3LRAFecTQsme+feXU+gfXY6NrjKvGIROPR
	K9Sj/7WJZSwVHOSHjZffHJQENp7n6UXbJvs3azGrvd0ZH4SVoJUxaVbIaN+GAh+lVdE9vIkv50L
	7P2PdS80N0W3xKIxL3Qp4DGHOY/lTVPo9AZ7UUfM/2tdGrOZwd5R35OgkYp
X-Received: by 2002:a05:620a:371f:b0:939:a199:45b4 with SMTP id af79cd13be357-93f29d394a1mr199987685a.39.1792186982404;
        Fri, 16 Oct 2026 14:43:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a8ee1sm312622985a.34.2026.10.16.14.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 14:43:02 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH 6/6] test/daxctl-devices.sh: cycle offline/online to cover unplug and replug
Date: Fri, 16 Oct 2026 17:42:48 -0400
Message-ID: <20261016214248.443247-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016214248.443247-1-gourry@gourry.net>
References: <20261016214248.443247-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gregory Price <gourry@gourry.net>

Repeat the online/offline pair to cover onlining from 'unplugged', and
check that offline-memory unplugs an already offline device. After each
step, check block counts and, where present, daxX.Y/state and the
'hotplug_state' reported by 'daxctl list'.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 test/daxctl-devices.sh | 53 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/test/daxctl-devices.sh b/test/daxctl-devices.sh
index 659428d..cdb13f6 100755
--- a/test/daxctl-devices.sh
+++ b/test/daxctl-devices.sh
@@ -67,6 +67,40 @@ daxctl_get_mode()
 	"$DAXCTL" list -d "$1" | jq -er '.[].mode'
 }
 
+daxctl_get_online_blocks()
+{
+	"$DAXCTL" list -d "$1" | jq -er '.[].online_memblocks'
+}
+
+daxctl_get_total_blocks()
+{
+	"$DAXCTL" list -d "$1" | jq -er '.[].total_memblocks'
+}
+
+check_memory_online()
+{
+	local total
+
+	total=$(daxctl_get_total_blocks "$1")
+	(( total > 0 ))
+	[[ $(daxctl_get_online_blocks "$1") == "$total" ]]
+}
+
+check_memory_offline()
+{
+	[[ $(daxctl_get_online_blocks "$1") == "0" ]]
+}
+
+# skipped on kernels without daxX.Y/state
+check_kmem_state()
+{
+	local path="/sys/bus/dax/devices/$1/state"
+
+	[[ -f "$path" ]] || return 0
+	[[ $(cat "$path") == "$2" ]]
+	[[ $("$DAXCTL" list -d "$1" | jq -er '.[].hotplug_state') == "$2" ]]
+}
+
 set_online_policy()
 {
 	echo "online" > /sys/devices/system/memory/auto_online_blocks
@@ -100,7 +134,26 @@ daxctl_test()
 	"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"
 	[[ $(daxctl_get_mode "$daxdev") == "system-ram" ]]
 	"$DAXCTL" online-memory "$daxdev"
+	check_memory_online "$daxdev"
+	check_kmem_state "$daxdev" "online_movable"
 	"$DAXCTL" offline-memory "$daxdev"
+	check_memory_offline "$daxdev"
+	check_kmem_state "$daxdev" "unplugged"
+	# again, now from 'unplugged' where supported
+	"$DAXCTL" online-memory "$daxdev"
+	check_memory_online "$daxdev"
+	check_kmem_state "$daxdev" "online_movable"
+	"$DAXCTL" offline-memory "$daxdev"
+	check_memory_offline "$daxdev"
+	check_kmem_state "$daxdev" "unplugged"
+	# an already offline device is unplugged too, where supported
+	if [[ -f /sys/bus/dax/devices/$daxdev/state ]]; then
+		"$DAXCTL" reconfigure-device -m devdax "$daxdev"
+		"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"
+		check_kmem_state "$daxdev" "offline"
+		"$DAXCTL" offline-memory "$daxdev"
+		check_kmem_state "$daxdev" "unplugged"
+	fi
 	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
 	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
 	"$DAXCTL" reconfigure-device -m system-ram "$daxdev"
-- 
2.53.0-Meta

