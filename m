Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5672E83F
	for <nvdimm@lists.linux.dev>; Fri,  3 May 2024 20:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714769712; cv=none; b=pFhZTKtFN+jHoLqFlsgyOAsjJKV0rZ0ChWrBYeF66LB/g+G6anBCHKhBABljctOuzAn8z0WqEAMddyGdVd35RQK9v6ng3JpqpzJMDU6EDfxlI72rc+5G0+tnLRfTSUOBkzhEmidqvBnTSDxJc7II5YKSvOPDyZ+TvUnxgoMThi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714769712; c=relaxed/simple;
	bh=TySOaYvtiDubn4OiFci+FOQ0fzfp7jgcGeR4UoRwwO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J3K/vF25y2rcfMrALWlL5LMAIykNKZBjTSF7w6io65qNmbebjI0ucP640FwhqaucLzvNv+P3IzX8dD2ixpTNHQ08/Ix98XryZBOlxU670BhXCKZ5a4mJpAKM5oKLQHdb4AM3V17fevX7ZE7CKRChrt9AKaZOvNh2EkKbBdG6EAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MrfzPbsk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MrfzPbsk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714769709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2SKVRu9IYXK1vWA8iKiLPq8WQ+fJK9aW5aGkYUZjjCE=;
	b=MrfzPbskuhnUthU3pGaG8F2tMuflH0niE4hBtrftPCpRMFPDZUSztZRHQYIu4RaLzGBfIx
	3hPnmPE6X2aB0YcG155CeB103fEa08g0cql88sOgZ4YuVcA7xanZiOe21RzGbQoIOByWwI
	i5/iTMtZDjUX9BxNc93d1dLEGUFqjYk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-8ZIiMeg9Opqud_xOmppMLA-1; Fri, 03 May 2024 16:55:06 -0400
X-MC-Unique: 8ZIiMeg9Opqud_xOmppMLA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A75D834FAF;
	Fri,  3 May 2024 20:55:06 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.16.155])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F00A8492BC6;
	Fri,  3 May 2024 20:55:05 +0000 (UTC)
Received: by segfault.usersys.redhat.com (Postfix, from userid 3734)
	id 9661C22B0C65; Fri,  3 May 2024 16:55:05 -0400 (EDT)
From: jmoyer@redhat.com
To: nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH ndctl 1/2] ndctl/keys.c: don't leak fd in error cases
Date: Fri,  3 May 2024 16:54:55 -0400
Message-ID: <20240503205456.80004-2-jmoyer@redhat.com>
In-Reply-To: <20240503205456.80004-1-jmoyer@redhat.com>
References: <20240503205456.80004-1-jmoyer@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
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
2.43.0

