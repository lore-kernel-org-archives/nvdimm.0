Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794896918;
	b=WwOhsGjY0WKxRribOI2VyRQbXNJggzc9yDPjjHYW83ZnOQ07sqXzdVR9d+dBZw0eh5nZ
	 r4A/xdoEdngyzsPOQrky97o0OTaCq8i3YhaX6mMmrbTRnBmj98Chkvd33gr2myctE9373
	 bHQDi2B53js8bJ7lR73MsFQE48cZXZhhPXFcdOXii0ap1p+6jsZqcCRCGKlSbMDeHNsio
	 Yn/Wcf+5/2kvRw+yiRCDahcfyPl4FE/jjOr67USkYSbUeionzGofSiVysA9KKtikZzW/I
	 9KWB0nTY4Xy4pSMK1c767D1GH+2cdEmX3AoUnNx3b4H3UoJjE+rRl5OeT2SVJz7L63w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896918;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZWEFNSiqBA+KdDL8LB4Ve5NM0J1Eicqc5YMwL3AE3zE=;
	b=UhNfBODRPvYARNI94NUZ66iSTlsfrGU/HGRLsetHMVHSZYTHacgWtlZXt4DRUki2El2f
	 yL6r9qLsP8zQr7eokSPPeBQshlN+EBDpjncTn0c0CbRI5/RWIZ7/xyKQ9jToi03dwfhdW
	 wSUDOuwVC8rwm1+kXimJ4pgcHEcZNjCJLwrSAGuoqWXMQe0IZEDHOapaVzNu0vVJBbJ0P
	 MDcYGmpYGD8P2/h2ut01SkwfSU7/ir1LWHzzP6wByHUWEKu2BIc6nvxxRsKwS9Fxxw3o7
	 2GzIEgV1/SV1aVps5WpYsOE+gzANjbMuAkqnVnVV3DkLXGPfBNextLSz8LmYCdwhUew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i3gQpYHY;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74CC606A31C
	for <nvdimm@lists.linux.dev>; Tue, 17 Nov 2026 06:28:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C74CC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i3gQpYHY
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b179528d56so2060799a91.3
        for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 22:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794896917; x=1795501717; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZWEFNSiqBA+KdDL8LB4Ve5NM0J1Eicqc5YMwL3AE3zE=;
        b=i3gQpYHYEHhHBwFki2wTl2l8XtZQG2OiTwNbol33T2IevxnYDGFo4FL6Zh+1KPqSNc
         4dF1ysBafS8+uXRCAMfZjgpjKFmB0tDLItfiI0XyvuPkxXGgPl0j4awcWuWq22uwx4Hd
         U4BcUkCsp0JlPuaPQH7Gnk0BIRjohLjRGjmFu2/wTOVbQ/3jsGqPx07DK7IyVl+JdXMV
         WrMkrLk4I0zsKeanGQEoUi0ghZ1neOvX5Jrf/gzP/AEfFGEpP4bKfQMpgyhHeNBKdERk
         CcQMCmoA9JC9Aw2IWLHncvce+/tQMQJ4K9pilNIwcw1+jOn/V19e3kc6lpgJm0Z3ahLK
         9kzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794896917; x=1795501717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZWEFNSiqBA+KdDL8LB4Ve5NM0J1Eicqc5YMwL3AE3zE=;
        b=BuUVniQWCP3GsMrhpm5JEe1fA4c9+KtOud1FAc3Q7xj0tzM05b7/R1NjbIYP5V0fU9
         NoDBCl7DO3adcEU9O5Bd/aBL60R09sH3yybc5KlwoKJsmJx2dsOIqNaLc7K4hRVR4CIr
         r8GWsjhyeBbggVgfHfLe3WongsRFGvwQ5dw7vWrowOtGc1a4S9KLIsKFfVi1bWpJjTn9
         fW95K/Nhx1+ppo95jCsFQcgfq8eYSs9ZDw96fw6N1S1JQb4dunVdyIc4Cm8yu5De5iA7
         JOrz/R6oPqzTb+v8rNIqR4UvrTb2NFwRLHPmUDvMocelTrOnGY8cCScnne0+HsvcsKY+
         JYEg==
X-Gm-Message-State: APuU4Z/vCyd2NxFm0dBb3clmN+sa5g+StxcRhmSlm06LaV93VYjKYSr8
	bsc1F47PER66g60CG1ZGycXrsyAThYz41Xuj0W77l5Q/+Tc6X2mPxUFe2lIbZZsm7DBx5CAS
X-Gm-Gg: AZFdTZeOx5uVBMoiCTWw++Q338LUjw594xs1UF6AmoSOK5t29tHWDO3A5mrYYrSa++7
	lUg7pVqjzPpnJLeQ4CcemfNdBcMvXyg+vQ2trVNWeSVhcHYwtnFuS/gpZVVvwrfhbI5ci2XIr6v
	jQC6lzVI5sUzUxfBTTLw8QcvCHhXb1YuyRU70FWfFM1YZgBczc1CBHdVd9F/Tect08Hos/Td6st
	vvFndh/kWKgvP8eYyFwKGRTv3qw3V5dPWzeP7PV3EBVBhxCluQLqPNZHoamplOW9KlOJKkXKhO0
	xiuxIkfQzvwuNrjHjMeMS35TP74fQfwCQMMmsYuvZsgcbaYSC8gqUX8S+MCBjkfRwGBswOIbaOz
	XeRnRQ3goxFO9C/fcSdYBdcbEue+4P43mDrxCq2b9eEsNGoUN2IAlBgmh8b8ZL0i5nq0QAg+jdV
	U22Dx6UaOv9JcGvb0hhsGeKuJkSI4xB729u2RVhof+OGaIdy3u9/0M6Q45BeariN4+qgjrEiHBv
	S56N6VQoLzTSLtYC8smDMqWQJ/maIajInPXF5zRHXuEDz3Jmchzgy2j8k19LWC/21/oy1ICyv9F
	oIxtHX0vv2pIkF8fet1DZQaXFAi2k2CZ
X-Received: by 2002:a17:90b:4d8f:b0:3aa:fc22:8ab4 with SMTP id 98e67ed59e1d1-3b1b0a1ef17mr11609736a91.29.1794896916891;
        Mon, 16 Nov 2026 22:28:36 -0800 (PST)
Received: from Yee-680G4.lan ([46.16.129.105])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18851ecsm4956170a12.13.2026.11.16.22.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 22:28:36 -0800 (PST)
From: YeeLi <seven.yi.lee@gmail.com>
To: nvdimm@lists.linux.dev
Cc: yeeli <seven.yi.lee@gmail.com>
Subject: [ndctl PATCH 2/2] ndctl/filter: parse the current token in util_*_filter
Date: Tue, 17 Nov 2026 14:28:08 +0800
Message-Id: <20261117062808.4004617-3-seven.yi.lee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261117062808.4004617-1-seven.yi.lee@gmail.com>
References: <20261117062808.4004617-1-seven.yi.lee@gmail.com>
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

util_bus_filter(), util_region_filter() and util_dimm_filter() split
the identifier string with strtok_r(), but then parse "ident" instead
of the current token "name" with strtoul().  ident is the start of
the strdup()ed buffer, so every iteration parses the first token
again.

A numeric list therefore only matches its first entry.  For example,
with a dimm whose id is 1:

    util_dimm_filter(dimm, "0 1")    -> no match
    util_dimm_filter(dimm, "1")      -> match

The same happens for --bus, --region and --dimm lists; name lists
such as "nmem0 nmem1" still work because they take the string
comparison path.

Reproduce with a small harness that calls util_dimm_filter() with a
dimm named nmem1 and id 1:

    "0 1"    -> no match (expected match)
    "0 2 1"  -> no match (expected match)

Parse the current token with strtoul(name, ...), and compare the end
pointer with name when checking for a failed conversion.

Tested on the target test system with harnesses for all three
functions: the original code fails for "0 1" and "1 0" as expected,
and the patched code matches for numeric lists, hex ids, name lists,
"all" and rejects trailing junk.

The bus and region helpers have had the same bug since 56b6e85
("ndctl: refactor bus and region filtering to utility routines").

Fixes: 4c9185d60c0b ("ndctl, list: add 'filter by dimm' capability")
Signed-off-by: yeeli <seven.yi.lee@gmail.com>
---
 ndctl/filter.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/ndctl/filter.c b/ndctl/filter.c
index 5b810dc..e6e9aba 100644
--- a/ndctl/filter.c
+++ b/ndctl/filter.c
@@ -31,8 +31,8 @@ struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *__ident)
 		if (strcmp(name, "all") == 0)
 			break;
 
-		bus_id = strtoul(ident, &end, 0);
-		if (end == ident || end[0])
+		bus_id = strtoul(name, &end, 0);
+		if (end == name || end[0])
 			bus_id = ULONG_MAX;
 
 		provider = ndctl_bus_get_provider(bus);
@@ -72,8 +72,8 @@ struct ndctl_region *util_region_filter(struct ndctl_region *region,
 		if (strcmp(name, "all") == 0)
 			break;
 
-		region_id = strtoul(ident, &end, 0);
-		if (end == ident || end[0])
+		region_id = strtoul(name, &end, 0);
+		if (end == name || end[0])
 			region_id = ULONG_MAX;
 
 		region_name = ndctl_region_get_devname(region);
@@ -146,8 +146,8 @@ struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm,
 		if (strcmp(name, "all") == 0)
 			break;
 
-		dimm_id = strtoul(ident, &end, 0);
-		if (end == ident || end[0])
+		dimm_id = strtoul(name, &end, 0);
+		if (end == name || end[0])
 			dimm_id = ULONG_MAX;
 
 		dimm_name = ndctl_dimm_get_devname(dimm);
-- 
2.34.1

