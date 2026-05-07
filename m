Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2979135B633;
	Thu,  7 May 2026 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778173884; cv=none; b=rMc2wfVRdzmTAtKUK4tluh17gCy0bRIBuNsdFcYWv/HfNU/Qncr5FDx317mNJn0okRjsdYPBnP169p4M5TcOXXUL9Twcyc1pjHOiPb+zN9hAZOypj8zqWgxPpI5oTwahRx4wwKnhdp1SQODDZoDJNLpUWs6/jni8A7MJrqOYdZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778173884; c=relaxed/simple;
	bh=j5njpFLT0KlkRXxg7H22a3fUsxoUrZy/WUinEEkEJd0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KuDRPMWUgXMl89CL4tZZ5Dpb/53fVvI5lggABjM7bWUTGLLi3l1q/W6Tkr9+ujGdfP0WYHNRFqjh1cA5kkpZC2IzM420rDk8x+Zznpc/NOqrW7sVR8q4ZmW268xOMSOZg4/NSq64jlJNSrwGJ61YRKyJxSTrurLoAzAQ/+vu7RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tuT+u6Tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tuT+u6Tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D33C2BCB2;
	Thu,  7 May 2026 17:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778173883;
	bh=j5njpFLT0KlkRXxg7H22a3fUsxoUrZy/WUinEEkEJd0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tuT+u6TzIo2JE3vyI0bddVPTpZJyXJdgP9/9Snk/ghhoe3DwaT76I6fHY8TU7IiiD
	 E67JW+7SIp+25nq5C1r2+nKau9rYoUaHwYaGMIq/YcXhqVjWpgmi75puL+rKZPhGb6
	 gfAh/yHgZKC9nID5l9yl2EMN+ObQeaPDYN3nPGdb58l5yTxPW52RliKZ0QTJ0bxqSH
	 ZcpwMIQc68oJfrV+thW/bq0jKNu/YZGjSRm0FgKE2mWPW9etEhV47KncRFkaNZi5Sy
	 Eg6oZRnIzpy8AMPlslQIgZRAuflNWNpq4j2GNv60vz2BvtLSSRqgbxJ0LkeLzRZmfJ
	 xqEduy+eQcAwg==
Date: Thu, 7 May 2026 18:11:14 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <iweiny@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update address for Ira Weiny
Message-ID: <20260507181114.345edc99@jic23-huawei>
In-Reply-To: <f63382ab-e50a-4b19-af83-a3e037a42c2b@intel.com>
References: <20260504-change-maintain-file-v1-1-6679b030d3e0@intel.com>
	<f63382ab-e50a-4b19-af83-a3e037a42c2b@intel.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 May 2026 15:38:08 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> On 5/4/26 3:38 PM, Ira Weiny wrote:
> > Update MAINTAINERS and .mailmap to point to my kernel.org address:
> > iweiny@kernel.org
> > 
> > Downgrade from maintainer to reviewer whilst doing so.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>  
> 
> Acked-by: Dave Jiang <dave.jiang@intel.com>

Best wishes Ira!

Acked-by: Jonathan Cameron <jic23@kernel.org>

> 
> > ---
> >  .mailmap    | 1 +
> >  MAINTAINERS | 6 +++---
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/.mailmap b/.mailmap
> > index b78aa092b4bb..61d101ce9696 100644
> > --- a/.mailmap
> > +++ b/.mailmap
> > @@ -446,6 +446,7 @@ Juha Yrjola <juha.yrjola@nokia.com>
> >  Juha Yrjola <juha.yrjola@solidboot.com>
> >  Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
> >  Justin Iurman <justin.iurman@gmail.com> <justin.iurman@uliege.be>
> > +Ira Weiny <iweiny@kernel.org> <ira.weiny@intel.com>
> >  Iskren Chernev <me@iskren.info> <iskren.chernev@gmail.com>
> >  Kalle Valo <kvalo@kernel.org> <kvalo@codeaurora.org>
> >  Kalle Valo <kvalo@kernel.org> <quic_kvalo@quicinc.com>
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 882214b0e7db..d30ab65ece8a 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -4255,7 +4255,7 @@ M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >  M:	"Rafael J. Wysocki" <rafael@kernel.org>
> >  M:	Danilo Krummrich <dakr@kernel.org>
> >  R:	Dave Ertman <david.m.ertman@intel.com>
> > -R:	Ira Weiny <ira.weiny@intel.com>
> > +R:	Ira Weiny <iweiny@kernel.org>
> >  R:	Leon Romanovsky <leon@kernel.org>
> >  L:	driver-core@lists.linux.dev
> >  S:	Supported
> > @@ -6426,8 +6426,8 @@ M:	Jonathan Cameron <jic23@kernel.org>
> >  M:	Dave Jiang <dave.jiang@intel.com>
> >  M:	Alison Schofield <alison.schofield@intel.com>
> >  M:	Vishal Verma <vishal.l.verma@intel.com>
> > -M:	Ira Weiny <ira.weiny@intel.com>
> >  M:	Dan Williams <djbw@kernel.org>
> > +R:	Ira Weiny <iweiny@kernel.org>
> >  L:	linux-cxl@vger.kernel.org
> >  S:	Maintained
> >  F:	Documentation/driver-api/cxl
> > @@ -14686,7 +14686,7 @@ LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
> >  M:	Dan Williams <djbw@kernel.org>
> >  M:	Vishal Verma <vishal.l.verma@intel.com>
> >  M:	Dave Jiang <dave.jiang@intel.com>
> > -M:	Ira Weiny <ira.weiny@intel.com>
> > +R:	Ira Weiny <iweiny@kernel.org>
> >  L:	nvdimm@lists.linux.dev
> >  S:	Supported
> >  Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
> > 
> > ---
> > base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> > change-id: 20260504-change-maintain-file-8f033435619b
> > 
> > Best regards,
> > --  
> > Ira Weiny <ira.weiny@intel.com>
> >   
> 
> 

