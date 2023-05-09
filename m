Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0148F17FE6
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683644161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XOJx9+x+7tJAybiBj2lUMnhUakSRjofcffpSd5QHORI=;
	b=N6sqG7KSs3rZO29GzKmrLE7ArUDJnoB1ZTtwT+Zek08fumr9l/b24js5IMMby6tdRT1QoT
	iFyM2KOgb/wLzLemM6D78rp+9DjBJDjwWhTOAU++63VAfLCJ7bvSrtmV32p/vtiN7CLCWH
	lZzCgCHrE9GKGwIoSCPMr5g0jvjwZvU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-08gD4YPNMp20nAwzBKfAnA-1; Tue, 09 May 2023 10:55:59 -0400
X-MC-Unique: 08gD4YPNMp20nAwzBKfAnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79EA5891745;
	Tue,  9 May 2023 14:55:59 +0000 (UTC)
Received: from fedora34.. (unknown [10.66.146.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E2AC463F88;
	Tue,  9 May 2023 14:55:57 +0000 (UTC)
From: Yi Zhang <yi.zhang@redhat.com>
To: nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	dan.j.williams@intel.com
Subject: [PATCH ndctl] typo fix: ovewrite -> overwrite
Date: Wed, 10 May 2023 07:00:04 +0800
Message-Id: <20230509230005.2122950-1-yi.zhang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Fix typos in Documentation/ndctl/ndctl-sanitize-dimm.txt and ndctl/lib/dimm.c

Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt | 2 +-
 ndctl/lib/dimm.c                            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index e044678..72ec96e 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -47,7 +47,7 @@ include::xable-bus-options.txt[]
 	label data. Namespaces get reverted to raw mode.
 
 -o::
---ovewrite::
+--overwrite::
 	Wipe the entire DIMM, including label data. This can take significant
 	time, and the command is non-blocking. With this option, the overwrite
 	request is merely submitted to the NVDIMM, and the completion is
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 2b6e8a5..f9dde2f 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -853,7 +853,7 @@ NDCTL_EXPORT int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm)
 		dbg(ctx, "%s: overwrite complete\n",
 				ndctl_dimm_get_devname(dimm));
 	else if (rc == 0)
-		dbg(ctx, "%s: ovewrite skipped\n",
+		dbg(ctx, "%s: overwrite skipped\n",
 				ndctl_dimm_get_devname(dimm));
 	else
 		dbg(ctx, "%s: overwrite error waiting for complete\n",
-- 
2.34.3

