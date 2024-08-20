Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF6F1990B5
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724178436; cv=none; b=EBIpZR0/8YMTIrpctbVuVs26iHhA76DqT/9M1rP+khJ8UdZG+Rm7xjLoYuDxL+7sdh+1eDRUPkj7q8b2OQ8l8BIR+MyykT1Q1pZ5hdGSGvhpRztamuyeZLoZhnulrbAzS+mfv9+VKYM4mzruv8/labmMsyt214kz9BIRioBBsow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724178436; c=relaxed/simple;
	bh=r/0VVvIh1ICVoRY8ZnDee3hXMlgEX26A6icGSipczhw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lZ+Jrj31Zm3j/plS6Gfp2P1rIvlguj6+tPI2meySG8xajHs9HBgJ1WUUp3RZg/sXefE93QlpCwFqp8wHjZBANtBcENJxfphapZTYq5GYeaTXh7wBIyhk3iiZVazJ2IdpZZg7bEPWt3y/fCg2ISSDhRokhWc7/zkUGXC59W8xqtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Id7GJg0w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Id7GJg0w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724178433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KFjd8rs2HCbyk4O3ZbMEg6FulInHI9ojnAFErBM4d08=;
	b=Id7GJg0wr2yTgCXpUZvla5JoX/jRGBh1zKw3YhicFNjyXvMYNRc0XNA0BfRJvrufLv4emP
	TTzvVEPlkhsrEvHHPzrfYHqnVYVvh4y9iTn3pN0b5OyyPhQk1tWxUSVogYdwRdOw7ihtRz
	fHkjLbFA88JUd384K5MPQU7eOz4uZtI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-uDG6S43QNSKnC-C4aaEp3g-1; Tue,
 20 Aug 2024 14:27:12 -0400
X-MC-Unique: uDG6S43QNSKnC-C4aaEp3g-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C2F71955F42
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 18:27:11 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.32.128])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A8941955F54
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 18:27:10 +0000 (UTC)
Received: by segfault.usersys.redhat.com (Postfix, from userid 3734)
	id 371EC22B0C5A; Tue, 20 Aug 2024 14:27:08 -0400 (EDT)
From: jmoyer@redhat.com
To: nvdimm@lists.linux.dev
Subject: [PATCH ndctl 2/2] libndctl.c: major and minor numbers are unsigned
Date: Tue, 20 Aug 2024 14:26:41 -0400
Message-ID: <20240820182705.139842-3-jmoyer@redhat.com>
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
2.43.5

