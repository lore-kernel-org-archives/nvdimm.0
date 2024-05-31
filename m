Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39264CDF9
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 06:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717137087; cv=none; b=Hormmka4zrOLDywKYfQGZW3BdW9EXmBtHf2Z9Tfj2Ji8Tm3qPG/ErmnLpTXwY1H+gBV9BDXMTQo0/L9hYb6ozasBDUsmmcea9dzTqab7Z9zi5zO3S7gIysnLPYnYAVOJ+D8aGivWd8YJSddnKzW0KZhBRUTuqs08fY1zwKeXKys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717137087; c=relaxed/simple;
	bh=IWtEyx9i9yRl2EuhAPC3tSYXvWNJsQwLilJxpMUryM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o+xiTZqSBwtHKn9QU7qXPLr4tkUC+titC9d0sd6TP7GjQDPH12uvXNVdu8zKvxZ3NiDDF7XRHjMqZxaaKAtAmW+qGBpKLHXl/vU9TFJ6PYWx3IMswqyAAYao8l1+cLY3PUcKSGR+b9xANAplu/dTEGWuVf/w3osu12aHqbsZROE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=dZUJAdxO; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="dZUJAdxO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1717137085; x=1748673085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IWtEyx9i9yRl2EuhAPC3tSYXvWNJsQwLilJxpMUryM0=;
  b=dZUJAdxOYojykUum5/XTZcDI15+LoQ3ut7xtNX/oTr4vlv8RTbSGInEK
   z5nNokT2jWSiYJsWzGFDDAdrfH9MHEMHr7RZAlR7rFOVoC+BpZBBTaXLo
   B4UrvJAbRW7KeBZqwRfZwB9YP6MpSjOhq/qd9PjP8kBnafYIAeD/f6u4H
   rvMkDYRKwjmw2gZLxj5GQkzsaDEtKGzWw8xJkd03qdOmbhxoC9oPBg325
   hCHdNhybLNlasXU8oxVpAD5KQLMgr2pZT0gZPgf+emY/l3qVJ3lloaKtF
   UC6C0IghXvFa0Fe0IGgQRCwncO/bvr72XXEJ0gvg+siP1fzbJ9cMHbzVS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="160911299"
X-IronPort-AV: E=Sophos;i="6.08,203,1712588400"; 
   d="scan'208";a="160911299"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 15:30:14 +0900
Received: from yto-m3.gw.nic.fujitsu.com (yto-nat-yto-m3.gw.nic.fujitsu.com [192.168.83.66])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id E174AE8529
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 15:30:10 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 1E239D21AD
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 15:30:10 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id AE88222CBFB
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 15:30:09 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 480C51A000A;
	Fri, 31 May 2024 14:30:09 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v2 2/2] daxctl: Remove unimplemented create-device options
Date: Fri, 31 May 2024 14:29:59 +0800
Message-Id: <20240531062959.881772-2-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240531062959.881772-1-lizhijian@fujitsu.com>
References: <20240531062959.881772-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28420.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28420.005
X-TMASE-Result: 10-2.488500-10.000000
X-TMASE-MatchedRID: MqppGi75AUUZHQl0dvECsQvBTB90+he+MVx/3ZYby781Y73PdzvXZLgn
	iNV4jJPwIvrftAIhWmLy9zcRSkKatSzTDssIplz246cXaPycFZt9LQinZ4QefCP/VFuTOXUT3n8
	eBZjGmUzkwjHXXC/4I8ZW5ai5WKlymCV4gU8lWsz/1hbP+Fqh7eqMnXegSEdr91jBQLI4BNGvFg
	1FCaEoYEjUuO4XeawM8DNMIbJZpozv341GSeLuQr28gjTZvH6vEWW0bEJOTAVAdUD6vW8Z1mZAM
	QMIyK6zB8/x9JIi8hKhgLRzA45JPQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

RECONFIG_OPTIONS and ZONE_OPTIONS are not implemented for create-device
and they will be ignored by create-device. Remove them so that the usage
message is identical to the manual.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2: make the usage match the manual because the usage is wrong.
---
 daxctl/device.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index ffabd6cf5707..781dc4007f83 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -98,8 +98,6 @@ OPT_BOOLEAN('\0', "no-movable", &param.no_movable, \
 static const struct option create_options[] = {
 	BASE_OPTIONS(),
 	CREATE_OPTIONS(),
-	RECONFIG_OPTIONS(),
-	ZONE_OPTIONS(),
 	OPT_END(),
 };
 
-- 
2.29.2

