Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795401814;
	b=Y5ptAm+76IpNNKmQLeTqkYS7Sq7DKfHLCgpG0q7gYpa4NrTrtOdU+PF3rNIdJtyHw2EB
	 x9lcXmtVcjgPA8Ka2bKXZDoGMamZ6PrMIit12VFwOZjXcHr4PhfuTQXT3Jua6HGq70Lri
	 9OUpQW0C6NVZOLNnU3/s0fGpcsNcWQMG1Rv06kngVXg+d3+cmmzYU/OFrJLjIxpZraEW1
	 wLMHeKXoBlOJSELgyRr3af/zWBii8jOH5ZmQTg50nr55LkSgC+faxEr1FK0SRobbK+4b5
	 ZNpZDdwwqQp7oYCeZI9rraXYEpvnKakVAM1eJYHdlYztUW7qVBoFQTHOAQJ7y0m2Csw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795401814;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=edLt5Tq/BLcPWiJ/50P772+XAlfYh5g07EE3TpZCGKk=;
	b=rnP9lmfmC9kZ2iFjs2o1cQaQgnujvItBpVwo8z2Ps8slnReMyktcTBCPQBCJ7vG2Ati6
	 zLgVaiVtAnjmpXFJ1eynCrEQuhyUNIyxygSf+/Zf9t9Kd1MpmIYF97T/HBsfw4Rr2RIVw
	 0oX1vGGQnh3he7H31FtGnYrAeEqnJ2KGWsrpO72NiN+zgd3JVgIOPyKi6QRQchMeyMrhj
	 U87vfoXrG4MEQ4AdGmBhITBpIa/Kb8oMQmINNcsGDx53Xoig0cuA4a4+DPO2bwNkim9eZ
	 elJJ4ii9tPIxeLr07rKbZwNVkNPizH7VsTjno4bJxQCSBPEea7OzlP1znMb2w8jWXfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P9ZipiCh;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD22606A31A
	for <nvdimm@lists.linux.dev>; Mon, 23 Nov 2026 02:43:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BD22606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P9ZipiCh
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so20975045e9.3
        for <nvdimm@lists.linux.dev>; Sun, 22 Nov 2026 18:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795401813; x=1796006613; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=edLt5Tq/BLcPWiJ/50P772+XAlfYh5g07EE3TpZCGKk=;
        b=P9ZipiChzDS25/bVYz2T2QgxZDsQYV18b6ZEMU2idUtTb2z1gmMMItZyNSZrnU4Hv9
         Lb65gRADHb91B34uf7P1OJYCJWJviSFU6fd4mi5RSWgrO+6e5j2RzCtZ/uxUnMAjTX9x
         M+ir5QBu7Nsi2C+XZkpzUvB7BdKAOfo3US565vgSe+8POe+txXPl5oWNduMLw2w6vLI/
         k19bYuIti0BbMvaVp0Zyfk2se1uI2C/WvZVnSHmgyiHJKbWUcyWJPmJoDi4MoXcN5p6D
         KjANkiHAfJDAOTHCdN26CWjgp3w/ofiDBEVX2GOIr7Xxv9EazUs3ZVeRfew5asWhSYkZ
         kutg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795401813; x=1796006613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=edLt5Tq/BLcPWiJ/50P772+XAlfYh5g07EE3TpZCGKk=;
        b=DDypf7I8MSbQtPchoUFZpdlfER+HuDauKxEmnp7gmeiYRWowUCRVqwKFglCI8uiN5I
         H9hvqej/WJt76U17ndqx75UgjB/WMY6MZg86vnw0HXuDnXJB6DiiKhjkj1Jwtt+YnZOQ
         YKEYjykcx65bJOzcKLnPpYI570Ta8pWrmKGOJFIcifuaKeCpTo/EWP3z5n6/Mc8cttWK
         WbEIjYSbJBbtKWEDmVQVAln2QrAVqAwq1qQdLeicI1IVsXyHwxVH4pqRfnqoh4UG0Vsr
         6Usc/CLMI0zfH2lnfhpO6G78i9AHe8BR9Ea3FE3PvzCXieJo4V3YVjEbooUF8UeWcfio
         PHRw==
X-Gm-Message-State: APuU4Z/dB/HbKvm4153px2ApNiPPIQgz0NWWEKJ/59qavstUeXFtHhoO
	Esgrh0sd6/v+Jhvl5fGMhTN4cFesjSDX+Pk19rh9hSS/Vv/L7pedGmQSWuX6aMVE7bKnzA==
X-Gm-Gg: AZFdTZf/398/sxcozqP2vXyiGjG/Wo5Oo/CPgM8i9OTUThh3AJz2t9NhN1hBNypgBWN
	PaaX1e7FPc6jJvatgi2E1X3sPqfn+gvQsm7+myJ6iS4LmKAFR9wfMnjJPTE7YuUGmPinUmbWwFc
	JgiurpyYcLq6Gn5QD0oahbfvSNO4/ZBwe4UogpFYdNMthpbigfZHnckYmf7zUto0uQ1PrPMseS0
	h64fjY5mcyvDEQ3CaUoqh28j3OpCiprrP/Nj2aoKeS6svXgqlZPV3OLcQqgpZTTfNJhMzYsTVFF
	33vq0SmdI0SuHjxO4mnZ8zu5llloelraZ/udpkakk9Ym3PB8iEeAe2pF57vVvRuNXBm5/mQvErN
	/kgUO57VIg8GvHQ23QTpvUsZ88EClXCW40HO1gIr2GfE3XFaDGHPXelBDSqQfbSz6V1CdVe5U2r
	1tQbmQa99gkSGug51IfgrKCi8TQA20DmqMvjYZ58VIVRS+l/j6KOCHfmcmI7F7QMHy7FExEUi+2
	R7GChQLRl3j9h6hfoxAkN49JhPGvojfhlinSKNZd6GDsfMpwEpPQBQdZEnZT7NakT4x7Kzfqv5/
	JVLXFUEh3PYdsmoi0uTZTHGBW//B8gBaSr3L
X-Received: by 2002:a05:600c:4e0d:b0:4ab:e27d:e241 with SMTP id 5b1f17b1804b1-4bb88922c6amr196520605e9.15.1795401812683;
        Sun, 22 Nov 2026 18:43:32 -0800 (PST)
Received: from Yee-680G4.lan ([178.162.242.209])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8849247asm307444625e9.7.2026.11.22.18.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 18:43:32 -0800 (PST)
From: YeeLi <seven.yi.lee@gmail.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	yeeli <seven.yi.lee@gmail.com>
Subject: [ndctl PATCH] cxl/filter: reject trailing characters in identifiers
Date: Mon, 23 Nov 2026 10:43:25 +0800
Message-Id: <20261123024325.2321309-1-seven.yi.lee@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: yeeli <seven.yi.lee@gmail.com>

The CXL filter helpers parse identifiers with sscanf("%d") and
prefixed variants such as "mem%d".  These conversions stop at the
first non-digit, so a malformed identifier such as "0abc" or
"mem0abc" still matches object 0.

Reproduce on a system with CXL memdevs and regions:

    cxl list -M -m 0abc        # matches mem0
    cxl list -R -r region0abc  # matches region0

A typo in a destructive command such as
"cxl disable-memdev -m mem0abc" can therefore operate on mem0
instead of failing.

Require the whole token to be consumed by adding a trailing %c and
checking that the conversion returns only the expected fields.

Tested by building cxl locally and on the target test system.  Valid
forms (numeric ids, devnames, host names, "all" and lists) still
match, while "0abc", "mem0abc", "region0abc", "0x0" and "0.0" now
match nothing.  The same matrix passes for the memdev, bus, port,
endpoint, decoder and region filters.

AI disclosure: the analysis, reproducer and initial fix were produced
with an AI coding assistant (DeepSeek V4.1 Flash, OpenCode).  The
submitter reviewed and verified the change and added the sign-off.

Signed-off-by: yeeli <seven.yi.lee@gmail.com>
---
 cxl/filter.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/cxl/filter.c b/cxl/filter.c
index 5d634d3..bff4409 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -53,6 +53,7 @@ struct cxl_endpoint *util_cxl_endpoint_filter(struct cxl_endpoint *endpoint,
 	char *ident, *save;
 	const char *arg;
 	int endpoint_id;
+	char c;
 
 	if (!__ident)
 		return endpoint;
@@ -66,8 +67,8 @@ struct cxl_endpoint *util_cxl_endpoint_filter(struct cxl_endpoint *endpoint,
 		if (strcmp(arg, "all") == 0)
 			break;
 
-		if ((sscanf(arg, "%d", &endpoint_id) == 1 ||
-		     sscanf(arg, "endpoint%d", &endpoint_id) == 1) &&
+		if ((sscanf(arg, "%d%c", &endpoint_id, &c) == 1 ||
+		     sscanf(arg, "endpoint%d%c", &endpoint_id, &c) == 1) &&
 		    cxl_endpoint_get_id(endpoint) == endpoint_id)
 			break;
 
@@ -90,6 +91,7 @@ static struct cxl_port *__util_cxl_port_filter(struct cxl_port *port,
 	char *ident, *save;
 	const char *arg;
 	int port_id;
+	char c;
 
 	if (!__ident)
 		return port;
@@ -112,8 +114,8 @@ static struct cxl_port *__util_cxl_port_filter(struct cxl_port *port,
 		if (strcmp(arg, "endpoint") == 0 && cxl_port_is_endpoint(port))
 			break;
 
-		if ((sscanf(arg, "%d", &port_id) == 1 ||
-		     sscanf(arg, "port%d", &port_id) == 1) &&
+		if ((sscanf(arg, "%d%c", &port_id, &c) == 1 ||
+		     sscanf(arg, "port%d%c", &port_id, &c) == 1) &&
 		    cxl_port_get_id(port) == port_id)
 			break;
 
@@ -213,6 +215,7 @@ struct cxl_bus *util_cxl_bus_filter(struct cxl_bus *bus, const char *__ident)
 	char *ident, *save;
 	const char *arg;
 	int bus_id;
+	char c;
 
 	if (!__ident)
 		return bus;
@@ -226,8 +229,8 @@ struct cxl_bus *util_cxl_bus_filter(struct cxl_bus *bus, const char *__ident)
 		if (strcmp(arg, "all") == 0)
 			break;
 
-		if ((sscanf(arg, "%d", &bus_id) == 1 ||
-		     sscanf(arg, "root%d", &bus_id) == 1) &&
+		if ((sscanf(arg, "%d%c", &bus_id, &c) == 1 ||
+		     sscanf(arg, "root%d%c", &bus_id, &c) == 1) &&
 		    cxl_bus_get_id(bus) == bus_id)
 			break;
 
@@ -334,6 +337,7 @@ struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
 	char *ident, *save;
 	const char *name;
 	int memdev_id;
+	char c;
 
 	if (!__ident)
 		return util_cxl_memdev_serial_filter(memdev, serials);
@@ -347,8 +351,8 @@ struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
 		if (strcmp(name, "all") == 0)
 			break;
 
-		if ((sscanf(name, "%d", &memdev_id) == 1 ||
-		     sscanf(name, "mem%d", &memdev_id) == 1) &&
+		if ((sscanf(name, "%d%c", &memdev_id, &c) == 1 ||
+		     sscanf(name, "mem%d%c", &memdev_id, &c) == 1) &&
 		    cxl_memdev_get_id(memdev) == memdev_id)
 			break;
 
@@ -432,6 +436,7 @@ struct cxl_decoder *util_cxl_decoder_filter(struct cxl_decoder *decoder,
 	int pid, did;
 	char *ident, *save;
 	const char *name;
+	char c;
 
 	if (!__ident)
 		return decoder;
@@ -452,8 +457,8 @@ struct cxl_decoder *util_cxl_decoder_filter(struct cxl_decoder *decoder,
 		if (strcmp(name, "endpoint") == 0 && cxl_port_is_endpoint(port))
 			break;
 
-		if ((sscanf(name, "%d.%d", &pid, &did) == 2 ||
-		     sscanf(name, "decoder%d.%d", &pid, &did) == 2) &&
+		if ((sscanf(name, "%d.%d%c", &pid, &did, &c) == 2 ||
+		     sscanf(name, "decoder%d.%d%c", &pid, &did, &c) == 2) &&
 		    cxl_port_get_id(port) == pid &&
 		    cxl_decoder_get_id(decoder) == did)
 			break;
@@ -668,6 +673,7 @@ struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
 	char *ident, *save;
 	const char *name;
 	int id;
+	char c;
 
 	if (!__ident)
 		return region;
@@ -681,8 +687,8 @@ struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
 		if (strcmp(name, "all") == 0)
 			break;
 
-		if ((sscanf(name, "%d", &id) == 1 ||
-		     sscanf(name, "region%d", &id) == 1) &&
+		if ((sscanf(name, "%d%c", &id, &c) == 1 ||
+		     sscanf(name, "region%d%c", &id, &c) == 1) &&
 		    cxl_region_get_id(region) == id)
 			break;
 
-- 
2.34.1

