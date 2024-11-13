Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2447C1632FD
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 21:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731534666; cv=none; b=ZcG0j6KqgH3UtM5v/cNF0A1dFSCPnX848KxsW+nZA64EPm6KljaOlB6ALgH65lw9aB0oIeHxlYpf/N7ju19rb7J5n5JGkipvvzqOR99hykuxFw4U0Z4KIDKyUzEZTkD0o821qjxTMMg0dn3KWBlMLKvO5qxzXKFJyfwbjxnVZvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731534666; c=relaxed/simple;
	bh=x3oJzUHssHrauD3HxCgh5lzfOLNeXU+uwd0SXiM/W6Y=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=S/wIRdIvvFj4vGHk7k/xKpFkShGsZ1Y7KnMj2lQAtDLPJdOnAuFHxSeasJGpak1FVlfRtcJ1a2cLXufwtVD4GBnUqmaeCSsbHQEeltKrSQ3IKGUrPQP1jXuZZuPgF1on1h+ST0ySsPF0l1Y/cvf+TzuVUD9IPzZxmgg5XrHHgU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cFXGuUmz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cFXGuUmz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731534661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FLiWivbjrVMAYPqMk38pBDsHGqNv7ezJsyXQtKmn+GQ=;
	b=cFXGuUmz2YTonTHHqGNZ4JD2VYPRQdJajs5l5YXZEVAcUH/4uk2ie6AXc5VPwXMhmdl9+l
	tdrWh/EjKLogaHvNTobLxRPAJ1hlJhCtHce9YD6oruoVBcs+BHsl3txm1OPzSgru51sHpv
	OGeGVyq0sROvwtuURi49cO6qUbcS8po=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-xSoSDivIN1qnW0Sdqv6OWQ-1; Wed,
 13 Nov 2024 16:51:00 -0500
X-MC-Unique: xSoSDivIN1qnW0Sdqv6OWQ-1
X-Mimecast-MFC-AGG-ID: xSoSDivIN1qnW0Sdqv6OWQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A10D19541BE;
	Wed, 13 Nov 2024 21:50:59 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.65.176])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61CA819560A3;
	Wed, 13 Nov 2024 21:50:57 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Keith Busch <kbusch@kernel.org>,  Ira Weiny <ira.weiny@intel.com>,
  Keith Busch <kbusch@meta.com>,  <vishal.l.verma@intel.com>,
  <dave.jiang@intel.com>,  <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] btt: fix block integrity
References: <20240830204255.4130362-1-kbusch@meta.com>
	<6734f81e4d5b9_214092294be@iweiny-mobl.notmuch>
	<ZzT8O_yvAVQDj2U6@kbusch-mbp>
	<673519f07bf7c_214c29470@dwillia2-xfh.jf.intel.com.notmuch>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 13 Nov 2024 16:50:54 -0500
In-Reply-To: <673519f07bf7c_214c29470@dwillia2-xfh.jf.intel.com.notmuch> (Dan
	Williams's message of "Wed, 13 Nov 2024 13:28:16 -0800")
Message-ID: <x49bjyipzup.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SzZb5U9kDP58VmquEIbgjuANwTs00of9behsL55ktZk_1731534659
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Dan Williams <dan.j.williams@intel.com> writes:

> Keith Busch wrote:
>> On Wed, Nov 13, 2024 at 01:03:58PM -0600, Ira Weiny wrote:
>> > Keith Busch wrote:
>> > > From: Keith Busch <kbusch@kernel.org>
>> > > 
>> > > bip is NULL before bio_integrity_prep().
>> > 
>> > Did this fail in some way the user might see?  How was this found?
>> 
>> I think this means no one ever used block integrity with btt. :)
>> 
>> I found this purely from code inspection because I was combing through
>> bio_integrity for a completely unrelated problem. I was trying to make
>> sense of how other drivers use it, and this one didn't make any.
>>  
>> > I think the code is correct but should this be backported to stable or
>> > anything?
>> 
>> Up to you! It's not fixing a regression since it appears to have never
>> worked before. You can also just delete support for it entirely if no
>> one cares to use this feature.
>
> I think most people are just hoping that filesystem metadata checksums
> are catching torn writes and not using btt. For the few that do not have
> a checksumming filesystem and are using btt I only expect they are using
> 512 or 4K sector sizes and not the sizes with integrity metadata. For
> the ones that are using the odd sizes with integrity metadata they
> obviously do not care about the integrity data being transferred since
> that never apparently worked.
>
> My vote is delete the integrity support, but keep the odd sector size
> support for compatibility.

More generally, does anyone use btt?  Should we start the deprecation
process for it?

-Jeff

