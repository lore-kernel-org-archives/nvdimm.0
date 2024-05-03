Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3ED134B1
	for <nvdimm@lists.linux.dev>; Fri,  3 May 2024 20:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714769710; cv=none; b=psFJPAz7MWBEBq3r540rFDYggY4y8gJoUSH7obBCLQHCNhFgWuOAtPWdX2Jymjvrs7uDE9/IxhqaBzvrztalMmExnj3KmTadRD/2oR7BbD4cRCgjeH3mKNIKbEwPvjMB+x2Q8wcHm/VMhGF5I8F70ifPt4MeK+LdhngUuhiqQq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714769710; c=relaxed/simple;
	bh=+yB6BJelwpgEBKwtB1IOYn7fncj2RpzYuPINLeTon9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p2gKWLAr4OGeXNgFWVKdfxINmpWbflnHpDf6zbAmernox+8UufIheLh4RJBbNMXXa9bjQBPTartcKxRRGgTZXh88Srfa7lSi9G6mMDE0FKmw8J7UAWbK31g3ZwXk+vuFGmo7fjDDSSfxGypjh+YcKYqKvksbiJpqQe/daUgaM7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d8eQZ3iR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d8eQZ3iR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714769707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aNstZicyJC8i+67/ZKBPJ8ku16cq20XQ4k424dd9oRU=;
	b=d8eQZ3iRIABvAFmZGtQ/AXZfYHC5HcSCEvdqKLo7yJIGXZ3Dtx9pkDmXwRbPcX6+upLsWz
	AkQPzWLP8yI/YtPHSpvazQmXJ3QcEUL2zvd1/00rnRlf66fMoHxCNBXl/CnwI+COcLjIPV
	urF1icp8QeUO262ruumW/mecKpjNA4g=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-210-PBSSdDCbOV-s0_MkjpwKcg-1; Fri,
 03 May 2024 16:55:04 -0400
X-MC-Unique: PBSSdDCbOV-s0_MkjpwKcg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71153380009E;
	Fri,  3 May 2024 20:55:04 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.16.155])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CC915AD140;
	Fri,  3 May 2024 20:55:04 +0000 (UTC)
Received: by segfault.usersys.redhat.com (Postfix, from userid 3734)
	id A241422B0C65; Fri,  3 May 2024 16:55:03 -0400 (EDT)
From: jmoyer@redhat.com
To: nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH ndctl 0/2] fix errors pointed out by static analysis
Date: Fri,  3 May 2024 16:54:54 -0400
Message-ID: <20240503205456.80004-1-jmoyer@redhat.com>
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

This series fixes a couple of minor issues flagged by coverity.

Jeff Moyer (2):
  ndctl/keys.c: don't leak fd in error cases
  libndctl.c: major and minor numbers are unsigned

 ndctl/keys.c         | 16 ++++++++--------
 ndctl/lib/libndctl.c |  7 ++++---
 2 files changed, 12 insertions(+), 11 deletions(-)

-- 
2.43.0

