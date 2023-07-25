Received: from insect.birch.relay.mailchannels.net (insect.birch.relay.mailchannels.net [23.83.209.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE425381
	for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 03:51:32 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 303FF7A095A;
	Tue, 25 Jul 2023 02:32:16 +0000 (UTC)
Received: from pdx1-sub0-mail-a238.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id BAFB17A0DA5;
	Tue, 25 Jul 2023 02:32:15 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1690252335; a=rsa-sha256;
	cv=none;
	b=N0B+5rutyBNQs9RL3SCw+giIHYIihXkkuV1Xm/p1sxjvnYZvaVy1E8eGGdyTTRp4UFlgCN
	CD155UDhD3ViRC6XVYCdkHHJkL8AZ4WOgz4fmTzDxgvIJNrhhySwV1zxtmjoRpxdlpoRyw
	VHSoMmndxohF0xLU2VskBgwlh+zj+DwL22MsutCBc4AyVudk+pq7JM4n/EPNzpj5PoxvEY
	rgCDxsGQP78/1xcbPIcIHLADeGYbp1ZZy38de8I1z/88DcwCOZYIWW7uVoBpLUIEALRUNl
	m+vizFpx4Lai3B8iuDwhT+LLUIVGwFWHTH6XFnAMBy5RWOmI49efeEKg8xqqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1690252335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=vIffOyHWUajXXyDkcdL4xL9IhUhevqQb6E/xmdaqZw4=;
	b=dW0C9Gc9zjz0N9Ss4yfd/4MQ8BOWtD2U63sByanEBwGc3ekCgeIipgRn/y7BC1muXk3uhZ
	qeuL+Vh0/vE5ocNuDww+sSetif0bG9Yewar4yEXRR9o1b7JARTRBPGKrbJokw24MfR7WOG
	ei/uW7bkCgFOPLs1jj4lkv113tBB4pzUXJMLWU4IWTjj57ZtWNCIICWMyi0xW22gikTE5Z
	dy6RcntoEsEiKdYJEJo+tgMvzJ0Nt6a99rpEXbU+Sq04EojBNw88AAufXj9scJOncUiWhf
	fC7nCIai2QChLnuxC5OvvgjxWntnV1i8uYBo8ecZazXZQnPp0Hz1LB/xNfElPQ==
ARC-Authentication-Results: i=1;
	rspamd-86948d5c96-g5jjg;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Sponge-Lettuce: 1cc2ec1b2b926199_1690252336021_938143172
X-MC-Loop-Signature: 1690252336021:3210302020
X-MC-Ingress-Time: 1690252336021
Received: from pdx1-sub0-mail-a238.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.107.136.40 (trex/6.9.1);
	Tue, 25 Jul 2023 02:32:16 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a238.dreamhost.com (Postfix) with ESMTPSA id 4R91JZ40jSz6s;
	Mon, 24 Jul 2023 19:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1690252335;
	bh=vIffOyHWUajXXyDkcdL4xL9IhUhevqQb6E/xmdaqZw4=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=Q0Nz/qXUrxrKqbxvACYpUn0M1LCkU8U+NvwiWKHsDIf+baYb7Ba9ZxW8LKRb5y8Va
	 rn5VeKiZQXJFQmKLgwSVb24vKKnBNxKLtIT+eIguje4ZBbCqH50G24itwE4xzumoCY
	 iHaDNQvdSKBkTl1TQGBmO984FmFKHHKVJs+DKYAUMq3HFaShf0W8FSJBM8t4RhR4QV
	 bGo8gkt5FAhxUme0AfPcxDqkmhl9DbzjmOyWba5SmQ85NEw2Uq8ZatzsvwHCSmMxQ1
	 p5nELNRdf0o5Lv8EPpoQAD80Rk96g6JkZ1X/h/UdL3xxVv4exCU6URIJf876jz/b6S
	 AQ3BqCqXvSdWA==
From: Davidlohr Bueso <dave@stgolabs.net>
To: vishal.l.verma@intel.com
Cc: dave.jiang@intel.com,
	nvdimm@lists.linux.dev,
	dave@stgolabs.net
Subject: [ndctl PATCH] ndctl/security: fix Theory of Operation typos
Date: Mon, 24 Jul 2023 18:54:57 -0700
Message-ID: <20230725015457.31084-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Noticed while reading the file.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 Documentation/ndctl/intel-nvdimm-security.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ndctl/intel-nvdimm-security.txt b/Documentation/ndctl/intel-nvdimm-security.txt
index 88b305b81978..4ae7ed517279 100644
--- a/Documentation/ndctl/intel-nvdimm-security.txt
+++ b/Documentation/ndctl/intel-nvdimm-security.txt
@@ -4,7 +4,7 @@ THEORY OF OPERATION
 -------------------
 The Intel Device Specific Methods (DSM) specification v1.7 and v1.8 [1]
 introduced the following security management operations:
-enable passhprase, update passphrase, unlock DIMM, disable security,
+enable passphrase, update passphrase, unlock DIMM, disable security,
 freeze security, secure (crypto) erase, overwrite, master passphrase
 enable, master passphrase update, and master passphrase secure erase.
 
@@ -115,7 +115,7 @@ This is invoked using `--overwrite` option for ndctl 'sanitize-dimm'.
 The overwrite operation wipes the entire NVDIMM. The operation can take a
 significant amount of time. NOTE: When the command returns successfully,
 it just means overwrite has been successfully started, and not that the
-overwrite is complete. Subsequently, 'ndctl wait-overwrite'can be used
+overwrite is complete. Subsequently, 'ndctl wait-overwrite' can be used
 to wait for the NVDIMMs that are performing overwrite. Upon successful
 completion of an overwrite, the WBINVD instruction is issued by the kernel.
 If both --crypto-erase and --overwrite options are supplied, then
-- 
2.41.0

