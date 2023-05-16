Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F093C15
	for <nvdimm@lists.linux.dev>; Tue, 16 May 2023 04:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684210404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0hKFp8N2zG083/9Jdp9l+Uvt5Oe4jI9OliEkkd772lg=;
	b=SP0HgxhOZ51xmYL5K2maSJ66fC1FMn1R4l31dbVyQx87a6u0Q86bA3RrYIs2PJjEfJG0Lh
	6wUVXuCNoGO7KrBdBD9vuc2apBFX0x61LO5yyKf1bpYe9xhFCiHmiWBOerqXuVRjmgemSm
	6JvlKA3sH2eaLPJzP7sEkb2gZ5cmDb0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-75r72HiVOp2v7R6TvJheKA-1; Tue, 16 May 2023 00:13:21 -0400
X-MC-Unique: 75r72HiVOp2v7R6TvJheKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A31D101A54F;
	Tue, 16 May 2023 04:13:21 +0000 (UTC)
Received: from fedora34.. (unknown [10.66.146.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D343740C2063;
	Tue, 16 May 2023 04:13:19 +0000 (UTC)
From: Yi Zhang <yi.zhang@redhat.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com
Subject: [PATCH] README.md: add three additional config to config item list
Date: Tue, 16 May 2023 20:17:30 +0800
Message-Id: <20230516121730.2561605-1-yi.zhang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

CONFIG_NVDIMM_SECURITY_TEST is required for nfit-security.sh and
cxl-security.sh.
CONGIF_STRICT_DEVMEM and CONFIG_IO_STRICT_DEVME are required for
revoke_devmem.

Ref: #240 #241

Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
---
 README.md | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/README.md b/README.md
index 7c7cf0d..3d125ad 100644
--- a/README.md
+++ b/README.md
@@ -70,6 +70,9 @@ loaded.  To build and install nfit_test.ko:
    CONFIG_NVDIMM_DAX=y
    CONFIG_DEV_DAX_PMEM=m
    CONFIG_ENCRYPTED_KEYS=y
+   CONFIG_NVDIMM_SECURITY_TEST=y
+   CONFIG_STRICT_DEVMEM=y
+   CONFIG_IO_STRICT_DEVMEM=y
    ```
 
 1. Build and install the unit test enabled libnvdimm modules in the
-- 
2.34.3

