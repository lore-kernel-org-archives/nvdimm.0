Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F923207A0F
	for <nvdimm@lists.linux.dev>; Tue,  1 Apr 2025 15:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743521184; cv=none; b=AUULCgcTuX2BW4RO4iTxbw7vTNndLqECUPH4rEw0/CVropGMBnnoDaIRkkUD/oIXmHjqSepHMW/PpKReyY4oGtNNe12vIZCTrKvYpTEHOkgkzHRibSScuK3et/jwACO+FUBTZmcEJRN25RPzv+uVs2naf0jcMe0PU5e6TVD/P18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743521184; c=relaxed/simple;
	bh=vFboLmEFuu02I4h6m3CmT8LvPhmuOPFsnUOV3jftNu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxPpTMQQjkgV3bIquMb5H/+1XyNsFK3o0zyV+1PN8vo/oQ3LVSeTo4fdS2iUBKdE+gp5hk0zcPF5pgz1YwsoP57LjIKMDQi6/RkSpmpvNR2Hma1pli9RL9VwI1KCDQSjxJjAVAdR1lBhZ2gaX3lm0GmjX7fdH25pyQ7X4WH59Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=sOfsrnmB; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="sOfsrnmB"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4766cb762b6so51806741cf.0
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 08:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1743521181; x=1744125981; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xCIQqA4ZGzk9QkSYxmyLd6ZmAQH4PEoYwFtk60P0jAg=;
        b=sOfsrnmB0d9wnb6VnL9+OxLC+7yw2eFPcR00pjYX1isb0uaFv4T386WZqwUlj/iSMh
         Jz15beYqWVZLJZlLJtOjry//NQqeCdIPbaO3iAnPHluCsB2aT5wmZFk/jIjrE/oMu6s5
         BN7sblOeBV1gUNuujeiFD9Hw1lP6E4v3gXdNmJadxD76YyYluw/qcuAhE8PfcylS4hHm
         RXqOrR7kntCezlI20AiXjnOqQitXjtXWqFZqx9KdwpJgVw6TEO96AtvyQRN1f2+liEKF
         AjZX3/WIlgVVAK1ZFR4mCck7l0JRyjmyB0M6SjahmuMMu800R0eohxciXkwP6slDAOHk
         Y2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743521181; x=1744125981;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCIQqA4ZGzk9QkSYxmyLd6ZmAQH4PEoYwFtk60P0jAg=;
        b=PPQm/DRP8AvXgwDAkKTQTl6mNtCKdC9VoGamZmOez5ttJX5dG468cY1GUIkU82tjTK
         h2Y4W05SfZUIlUgAgbWxSrAFNktXl81Jsq2Jbnsziaer1xQFK/yeYCMLfibajIVb8Bx9
         71iihrppclp5whACvEOXdFNEav587d2l1dhSBT8NPwfxdQluyoezKshyYUqGtg9RyDzH
         pl8VKCSodVbKIbhP9dMPwtScd+QEC3oVqykVDge5bDlBLEP4ylCeXHYP3YSz5EKDi1Mw
         k/hHERu7MaEBfzKi2pOWIx0nrFyXxTrQ4jpNIuJ9/OAoZXH1E47rtCTEcvM2kli73T8R
         JAVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWT7pGzUUwShjqgZF1c0VuNrfOKFHijRn3LNQ+PEylUo5be3UGln/UHMtXeZB+TEVA4Vo0IpxU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/shFWJgXR+VsIt/awlSlaun5GEvyjZwZBmuLz74j6VMdftXgS
	EaI9uT1c+DQ9oC1OJ7J0Q3FZZcUKATETeLqthmBfxcWbZjgRXQeQKWlhEGDp6Bo=
X-Gm-Gg: ASbGnct1LexqjpBDcoPdvfY7h4fxzByotbQ+CjXZf4brw3b2gwP102AE+r6XUGyobXH
	DWbRmB4rs+zYAhJc6QCK/5JR7ShvDKDWQSJYBYwgsXXvNZ3TYohVYMm3VLBmWvmLpVx1buNYPkQ
	TYT79ppH7ppQyk7MXrmicjfqSDQ0pAVvaSJvTaamyu+4+FUeGWxlOU+v++/zYHBpd0SISSe2mfu
	ESCNrM90wld3rnWWhbWKqZFLXQTyeWb5TZ8VNJDi7C2DCycuwAKPXqprKFmnZXM+0xjHy/YFRTh
	f9ufTJurNFbRmk5k+68QNhHQKHyiwg/t7GfLuilB3Op3RrwfhtAugnOAymONJs+ze5YHG6fYUrQ
	umZg2pQKJ2CHlxVwPoFWgwLnyQdk=
X-Google-Smtp-Source: AGHT+IHzkThr7Aq5f4/8WZu6xqfIvqH1zUuQXxKYJ4v0IT0w+E6rcLFyC2loEB95SdAcliC5w56vtg==
X-Received: by 2002:ac8:57cd:0:b0:474:f1ef:3a54 with SMTP id d75a77b69052e-479039b2455mr4837241cf.9.1743521181535;
        Tue, 01 Apr 2025 08:26:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-56-208.washdc.fios.verizon.net. [173.79.56.208])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47782a7aad7sm66913571cf.35.2025.04.01.08.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 08:26:21 -0700 (PDT)
Date: Tue, 1 Apr 2025 11:26:19 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: dan.j.williams@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <Z-wFm_zwDZy6jvVz@gourry-fedora-PF4VCD3F>
References: <20250321180731.568460-1-gourry@gourry.net>
 <Z-remBNWEej6KX3-@gourry-fedora-PF4VCD3F>
 <3e3115c0-c3a2-4ec2-8aea-ee1b40057dd6@redhat.com>
 <Z-v7mMZcP1JPIuj4@gourry-fedora-PF4VCD3F>
 <4d051167-9419-43fe-ab80-701c3f46b19f@redhat.com>
 <Z-wDa2aLDKQeetuG@gourry-fedora-PF4VCD3F>
 <a65fd672-6864-433c-8c82-276cb34636f9@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a65fd672-6864-433c-8c82-276cb34636f9@redhat.com>

On Tue, Apr 01, 2025 at 05:19:28PM +0200, David Hildenbrand wrote:
> 
> Yes, it's valuable I think. But should it be a warning or rather an info?
> 

dev_warn, but yeah I think so?  A user expects to get their memory in
full, that means we're slightly misbehaving.  I'm fine with either.

~Gregory
