Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646E5194149
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724178436; cv=none; b=Fqd3JDc6jMHZyK4YAs4FR05l+SlFsVY/ml++NfFOr3/brS3CiXAYqW8UCII0VPCfseMdVFu5aFBE1E8zzXmDxbSZQ24yZYSjBJWY7UIZAtLrXnkir9Mtuyid3glvBZn77eZhr7QvNdSZds4y3HcfqW/ya2v7YF1H/2GJuRuE3pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724178436; c=relaxed/simple;
	bh=OUr8C2JkmxB0MuGMyc4F4q9/hhv+3paj52f05sCaNqU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=th6y8YPcXUygd1J/oXoomDclSk2zG1jAIgXrtEnRyqCqc0BltIg0+pM0h5dQ9vk69bK4bw0O/0Wv1ImZ7fZaUQEaeUfA2S/WLaJOLpiBpXwum3atF4PYh/y5vr7VMeSmqdnI3PV9H826Sp9TL7YPFVLFaXLWKVyklLcXMjiEM7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T0a8zvB7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T0a8zvB7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724178434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OUr8C2JkmxB0MuGMyc4F4q9/hhv+3paj52f05sCaNqU=;
	b=T0a8zvB7YqK08P4cm3OTnilimRyKd+N2wFsb8ogTmm4IMpbe0btZxjNvlMmneuYQQaua3M
	MpsuDsPNj1EYACrkgY7+F5wpbK1ALmqSGpsII1mf1d6HLGahKK0s5Fm0zT0uU57a/41L+E
	u4gjcTEMtT2BmtFNMyTL2uS+BW8mlcc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-5qsmMZJ6NvOC0GdoW6VwFA-1; Tue,
 20 Aug 2024 14:27:12 -0400
X-MC-Unique: 5qsmMZJ6NvOC0GdoW6VwFA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DA771955F45
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 18:27:11 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.32.128])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 670AD3001FF5
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 18:27:10 +0000 (UTC)
Received: by segfault.usersys.redhat.com (Postfix, from userid 3734)
	id 333C422ACC05; Tue, 20 Aug 2024 14:27:08 -0400 (EDT)
From: jmoyer@redhat.com
To: nvdimm@lists.linux.dev
Subject: address some open scan hub warnings
Date: Tue, 20 Aug 2024 14:26:39 -0400
Message-ID: <20240820182705.139842-1-jmoyer@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

These issues are pretty minor, but probably worth fixing.

[PATCH ndctl 1/2] ndctl/keys.c: don't leak fd in error cases
[PATCH ndctl 2/2] libndctl.c: major and minor numbers are unsigned

