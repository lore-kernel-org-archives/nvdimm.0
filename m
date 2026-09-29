Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DFF4DE712;
	Tue, 29 Sep 2026 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790718927; cv=none; b=HVdHOQkcc/rH/SMEp5OaiXVEy1FJIMuvF7IHtDpwbt9xPBaPE8/O8RUhbm0fi/9aaCjFiALc+8SBVIxhiGvNJWGZIe62OCTGi8A07tAlvDjMau9phSywO4J5e3djDeZzbJsk6S882QLA+8hL3trSrfybjG3QW2PHzC2u13frGOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790718927; c=relaxed/simple;
	bh=fsDojE0qrb6FQKscLxM2Kgawwv/G1VOhGDB17jM2/PA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=m7ca45yptt0NTNeTnP7S7gG9/PZKUElsdlC1b0sYNL/thUtzM+8BjUt7aETuYYDrY9U1r3AQZEJAMCdL9lk3TYgFjl/arvfLrYpAFrAy2wHsSSXrDdJ4x868Vz7uUm/Uws1stXhRhgi5QjgEXFw4i9ivVzG8X7uf+WgCvZUHVjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZtHbY29x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZtHbY29x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFC31F000FF;
	Tue, 29 Sep 2026 21:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790718926;
	bh=ZtMvD8UW24cAPkq6jqeuJwiVtKgxnTmh2aLV8EDeel8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZtHbY29xCIYvNChST8WJsvhHY+N5rk2SbUbU5AnmjO9JrO9hHVfUnCuoeDESJ1PQd
	 rdC+KBhaOWJGebjnx2lrd97HSlAnGAPW8f/6abalPSRLnovAU+9N8jkDVZUBal0biL
	 gIMnxdXWPtaUg9rXHngTIUX8BcLz0HwvWfNkFmW0=
Date: Tue, 29 Sep 2026 14:55:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Jiale Yao <yaojiale02@163.com>, Dan Williams <djbw@kernel.org>,
 "Vishal Verma" <vishal.l.verma@intel.com>, Dave Jiang
 <dave.jiang@intel.com>, "Joao Martins" <joao.m.martins@oracle.com>,
 <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] dax/device: defer publishing the dynamic pgmap
Message-Id: <20260929145525.8dfc16723dc305a421af64bb@linux-foundation.org>
In-Reply-To: <arwxa3BryRJ-Yqo7@aschofie-mobl2.lan>
References: <20260927114736.1113965-1-yaojiale02@163.com>
	<20260927130526.a6da56f1515cf1772cb45631@linux-foundation.org>
	<arwxa3BryRJ-Yqo7@aschofie-mobl2.lan>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 29 Sep 2026 14:45:15 -0700 Alison Schofield <alison.schofield@intel.com> wrote:

> On Sun, Sep 27, 2026 at 01:05:26PM -0700, Andrew Morton wrote:
> > On Sun, 27 Sep 2026 19:47:36 +0800 Jiale Yao <yaojiale02@163.com> wrote:
> > 
> > > The dynamic device-dax probe path publishes its devm-allocated pgmap
> > > before several operations that can still fail.  If one of them fails,
> > > devres frees the pgmap while dev_dax->pgmap remains non-NULL.  A later
> > > bind then fails the dynamic-dax invariant check and leaves the device
> > > unusable until its region is recreated.
> > > 
> > > Defer assigning dev_dax->pgmap until the final devm action has been
> > > installed and probe can no longer fail.  A failed probe then never
> > > publishes the temporary pgmap.
> > 
> > lgtm, thanks.
> > 
> > > Fixes: fc65c4eb0b2a ("device-dax: ensure dev_dax->pgmap is valid for dynamic devices")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Jiale Yao <yaojiale02@163.com>
> > 
> > I'll queue this for next-merge-window as it doesn't seem very urgent. 
> > Retaining cc:stable.  I've marked it as "needs maintainer acks".
> 
> Hi Andrew,
> 
> I'm wondering why you are picking this one up?  I have taken
> on the role of drivers/dax patch wrangling recently (past 2 releases)
> and was thinking this fits within that group. Not that I don't like
> the help, just wondering if I've misunderstood who does what where.

Oh, OK.  Muscle memory?  I've handled quite a lot of drivers/dax
patches in the past, including the one which is being fixed here.  The
subsystem has never felt more than somewhat on-topic.

I'll remove this one from mm.git.
