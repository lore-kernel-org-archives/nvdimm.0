Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2928B2AEEE
	for <nvdimm@lists.linux.dev>; Fri,  3 May 2024 20:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714769710; cv=none; b=NaD9XyGeRPDIqGa0eMxHxqJigdbRw3s3g2VouUgD0DYbs9yPHWDbkcqW7Vt4oR1wjc/dtZFHYk0as+rRqk1bVdA1PLWINMGIEdLgIZqQw4iJApkn1yF5ZM0dFY10IqUSbqxTqXIPr2bcZsxaGTxmA3tvBBLBfIXncnFnJiWPJh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714769710; c=relaxed/simple;
	bh=8bmKKGIvBU3vFi9IDrqZuvSNw/63iF7jBSmhvkv9pgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e1AZ/3s7JV0goHsPgjq/kb6r4rVjt9S1pZvBcEEvSSkmXwJZwjV1LGT9DUztJHYzrGxMcrUHejkwQ/EwwcjfCp7mAWuQ6YPiU+hWSGFvagUrTXE2inUFf+D6IKg/3nQ7Z2JiHHbvK7z/0XqsqTgK3UyQIYxiGzN7oHte3u7+Pc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mg3ytctq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mg3ytctq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714769708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0XAqQg5UTwgYoO3YHPxjIROLrELT1T8YZe2qeJ9e1xg=;
	b=Mg3ytctqui6VkPpqh9wYqC86/j+kW4WLsAgnnTe39EKnKlnRUxQeNXN7n7E6UKvRDjLfRD
	sKOTKE47Nu9zu2iXf5A7Qz8TwLpwOn2peQ/4hdge7L4E4bei+V/lbG3mnTiMdR9A2MuGRS
	in/qOsOg8iw1UdXlqsZav1bsgguqgUk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-PuB1KeXAPvupgosdwu2ZZQ-1; Fri,
 03 May 2024 16:55:06 -0400
X-MC-Unique: PuB1KeXAPvupgosdwu2ZZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAF3B29AB3F1;
	Fri,  3 May 2024 20:55:06 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.16.155])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 956CBC13FA3;
	Fri,  3 May 2024 20:55:06 +0000 (UTC)
Received: by segfault.usersys.redhat.com (Postfix, from userid 3734)
	id 3E99822B0C65; Fri,  3 May 2024 16:55:06 -0400 (EDT)
From: jmoyer@redhat.com
To: nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH ndctl 2/2] libndctl.c: major and minor numbers are unsigned
Date: Fri,  3 May 2024 16:54:56 -0400
Message-ID: <20240503205456.80004-3-jmoyer@redhat.com>
In-Reply-To: <20240503205456.80004-1-jmoyer@redhat.com>
References: <20240503205456.80004-1-jmoyer@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Jeff Moyer <jmoyer@redhat.com>

Static analysis points out that the cast of bus->major and bus->minor
to a signed type in the call to parent_dev_path could result in a
negative number.  I sincerely doubt we'll see major and minor numbers
that large, but let's fix it.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 ndctl/lib/libndctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ddbdd9a..f75dbd4 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -710,11 +710,12 @@ NDCTL_EXPORT void ndctl_set_log_priority(struct ndctl_ctx *ctx, int priority)
 	daxctl_set_log_priority(ctx->daxctl_ctx, priority);
 }
 
-static char *__dev_path(char *type, int major, int minor, int parent)
+static char *__dev_path(char *type, unsigned int major, unsigned int minor,
+			int parent)
 {
 	char *path, *dev_path;
 
-	if (asprintf(&path, "/sys/dev/%s/%d:%d%s", type, major, minor,
+	if (asprintf(&path, "/sys/dev/%s/%u:%u%s", type, major, minor,
 				parent ? "/device" : "") < 0)
 		return NULL;
 
@@ -723,7 +724,7 @@ static char *__dev_path(char *type, int major, int minor, int parent)
 	return dev_path;
 }
 
-static char *parent_dev_path(char *type, int major, int minor)
+static char *parent_dev_path(char *type, unsigned int major, unsigned int minor)
 {
         return __dev_path(type, major, minor, 1);
 }
-- 
2.43.0

