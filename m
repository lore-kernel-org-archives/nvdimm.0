Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D745347AD
	for <nvdimm@lists.linux.dev>; Tue,  7 Nov 2023 17:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RFIUWXsX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699378103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=WhtIXInxNBQN/hFhaImZ0/3B/0C/wSvNg6di6wgUqOs=;
	b=RFIUWXsXrpNdtYBYKQ39DFlVkMXWH9fPpstu5zV11lBrAMMdrVjDDqXnz8d8IlwkY/mr+u
	pq41mOr1+scTLVfk3qBhnp1araKjEijaze8j/1WPStovDgxVm4EgW5yZM8w+o8+Pxsxtgg
	Nx+UmaPmgKhzEjkyoDoCZBM/hPwD9Aw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196-Q7mnPsUmMJGrgS5e6XLyzQ-1; Tue,
 07 Nov 2023 12:28:21 -0500
X-MC-Unique: Q7mnPsUmMJGrgS5e6XLyzQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A2E31C07826
	for <nvdimm@lists.linux.dev>; Tue,  7 Nov 2023 17:28:21 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.8.211])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09D3E492BFD
	for <nvdimm@lists.linux.dev>; Tue,  7 Nov 2023 17:28:21 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: nvdimm@lists.linux.dev
Subject: [patch] ndctl: test/daxctl-devices.sh: increase the namespace size
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Tue, 07 Nov 2023 12:28:20 -0500
Message-ID: <x49fs1hwk0b.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Memory hotplug requires the namespace to be aligned to a boundary that
depends on several factors.  Upstream kernel commit fe124c95df9e
("x86/mm: use max memory block size on bare metal") increased the
typical size/alignment to 2GiB from 256MiB.  As a result, this test no
longer passes on our bare metal test systems.

This patch fixes the test failure by bumping the namespace size to
4GiB, which leaves room for aligning the start and end to 2GiB.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/test/daxctl-devices.sh b/test/daxctl-devices.sh
index 56c9691..dfce74b 100755
--- a/test/daxctl-devices.sh
+++ b/test/daxctl-devices.sh
@@ -44,7 +44,10 @@ setup_dev()
 	test -n "$testdev"
 
 	"$NDCTL" destroy-namespace -f -b "$testbus" "$testdev"
-	testdev=$("$NDCTL" create-namespace -b "$testbus" -m devdax -fe "$testdev" -s 256M | \
+	# x86_64 memory hotplug can require up to a 2GiB-aligned chunk
+	# of memory.  Create a 4GiB namespace, so that we will still have
+	# enough room left after aligning the start and end.
+	testdev=$("$NDCTL" create-namespace -b "$testbus" -m devdax -fe "$testdev" -s 4G | \
 		jq -er '.dev')
 	test -n "$testdev"
 }

