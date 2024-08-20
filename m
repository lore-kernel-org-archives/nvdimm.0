Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFBD1B86F1
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724178436; cv=none; b=NVx+T41MdYHScKjQv35Oy1ijD0wsSyJLQfaYdgG0qorVAKbB8fIl7zFPyL5twT+4UMVw2hJzd2RbFSLfRIie89mWsokSZs7ZjuVnSFbcpcDIAxOpAMrf1pR1AJSibHw70B11EHoKomib4z/QLFUshWFZIxG9unuE3Tx/ZsNcW88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724178436; c=relaxed/simple;
	bh=X7gnnKeMXGNArynnYsg7QWUU1vE5aGlRUDOmiCeKWjY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igN97MDO4r927O7gRB//RGH4W02mtVXZVkv7nj8pkgXqvjIFz5h1WLIoBc2iTsA2GxRs1UDIg0RzY4JolqlWiMQLUfpezaTCAhuEnivovRjZXUWAgB+SoJtfdVfdyrYrsVczP5fAwyWAsHgp9SLD7z4YoQ/aYGRqGHwvt2uUN7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CSMhv2hB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CSMhv2hB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724178433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RDYdzBsedMT1L1pG5g9sJB2OVOSY8UR/9G3iq9yt/kk=;
	b=CSMhv2hB8tbWuAf2e7dTu1377UqQNycXYnEyLUfR9aUaD/NrQixOq/SG3uOj8hESJnx2Uh
	ejyoeL1C1IbWPodUAoKaTUZQ9/49mpTyYwtPmzHSF9hVvpHyYviaekKZMe/8tbwuMDnMwi
	bLjxNr2T3xiW97CQC5yP39AhV4OpWfI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-KA-xPZ9nPpevu5y4J1nwMA-1; Tue,
 20 Aug 2024 14:27:12 -0400
X-MC-Unique: KA-xPZ9nPpevu5y4J1nwMA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E12D71955D4E
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 18:27:10 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.32.128])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BEDD1955F21
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 18:27:10 +0000 (UTC)
Received: by segfault.usersys.redhat.com (Postfix, from userid 3734)
	id 350D622ACC09; Tue, 20 Aug 2024 14:27:08 -0400 (EDT)
From: jmoyer@redhat.com
To: nvdimm@lists.linux.dev
Subject: [PATCH ndctl 1/2] ndctl/keys.c: don't leak fd in error cases
Date: Tue, 20 Aug 2024 14:26:40 -0400
Message-ID: <20240820182705.139842-2-jmoyer@redhat.com>
In-Reply-To: <20240820182705.139842-1-jmoyer@redhat.com>
References: <20240820182705.139842-1-jmoyer@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Jeff Moyer <jmoyer@redhat.com>

Static analysis points out that fd is leaked in some cases.  The
change to the while loop is optional.  I only did that to make the
code consistent.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 ndctl/keys.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/ndctl/keys.c b/ndctl/keys.c
index 2c1f474..cc55204 100644
--- a/ndctl/keys.c
+++ b/ndctl/keys.c
@@ -108,7 +108,7 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
 	struct stat st;
 	ssize_t read_bytes = 0;
 	int rc, fd;
-	char *blob, *pl, *rdptr;
+	char *blob = NULL, *pl, *rdptr;
 	char prefix[] = "load ";
 	bool need_prefix = false;
 
@@ -125,16 +125,16 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
 	rc = fstat(fd, &st);
 	if (rc < 0) {
 		fprintf(stderr, "stat: %s\n", strerror(errno));
-		return NULL;
+		goto out_close;
 	}
 	if ((st.st_mode & S_IFMT) != S_IFREG) {
 		fprintf(stderr, "%s not a regular file\n", path);
-		return NULL;
+		goto out_close;
 	}
 
 	if (st.st_size == 0 || st.st_size > 4096) {
 		fprintf(stderr, "Invalid blob file size\n");
-		return NULL;
+		goto out_close;
 	}
 
 	*size = st.st_size;
@@ -166,15 +166,13 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
 			fprintf(stderr, "Failed to read from blob file: %s\n",
 					strerror(errno));
 			free(blob);
-			close(fd);
-			return NULL;
+			blob = NULL;
+			goto out_close;
 		}
 		read_bytes += rc;
 		rdptr += rc;
 	} while (read_bytes != st.st_size);
 
-	close(fd);
-
 	if (postfix) {
 		pl += read_bytes;
 		*pl = ' ';
@@ -182,6 +180,8 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
 		rc = sprintf(pl, "keyhandle=%s", postfix);
 	}
 
+out_close:
+	close(fd);
 	return blob;
 }
 
-- 
2.43.5

