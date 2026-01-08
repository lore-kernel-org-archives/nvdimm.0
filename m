Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D5044CF3F
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 13:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767878754; cv=none; b=js9pqS85wd+IKzAp5fK+e5JSJ80ANu/NwupDNrw7y2RS4slrQVl5ldRvhdzZTKeY3cualtfLZrdTPbx3u/jsbx/hXX1V0Nxt7LaNbIPosqxHad5w7rAsJOLvR7kqKrLPw1mjgKf2ALhh5NeIdIJFJ4SQ7pI+Rbqtp07qjnuI3CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767878754; c=relaxed/simple;
	bh=jwFf19PSHKXwdf9bEk3kZxmxUld0e6v3BgfnWrHCUjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TF7syvtligVvJ3cwsLHkm3NJnpzmvUMEwqt6SmPiVvEPf3oBqiKreBg7L0zjHZ80vjR0AIHi4tAkSNHAEXYmpu1t1GWskbZVnKNeItYq18miutrelaD4QwYEg6qjftmmSidEMhmvhvKYslZ/Yc/P4hEddnHurR2XyOallI/7h40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IMU3x3H4; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IMU3x3H4"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7cdae63171aso2224870a34.1
        for <nvdimm@lists.linux.dev>; Thu, 08 Jan 2026 05:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767878750; x=1768483550; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E49XAlEZRJNJzFNz0O0SAsxb11w6Gi0a4fcPebK/tXg=;
        b=IMU3x3H4zlmX5fNZV2Gd9+n6V0lrbOltUEcuQKxy5KwqPzpOZ3IR1cRJuccTWr63Fo
         AmbBBFdxz6vGEEP6NFJiu64DmJKL9zZPqrWJxPPlJANCLr6uvJmdHs/4rMFeCFilZBhM
         t5mnsy6BYVyNgbugc40aj/Oh1voNf/kMag/VseXM6nd9UP8CLiotfdKAXawHEf0PQJI9
         hMBpsP1an82dbSIlvgCRMKTmGN06RXWyhz2NfZPVs/kDTlj9Nfq2dgI6fPTBTWQNvbAp
         fWJj2bwCurO3qf3q4o8gPOWrrZ9ARVF3AHZn0/YuyS77EFf6f3VQ6L2WfJHvUdEhe/63
         eusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767878750; x=1768483550;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E49XAlEZRJNJzFNz0O0SAsxb11w6Gi0a4fcPebK/tXg=;
        b=Mg2T+ofQxMh9ee3R5ppjh55q8hhKsjsyfD03/DmG7Vlc9oVUCPRkKSpvGgYW4wRC79
         JjmOxQqKWsQ5hlAC9HXZeJJuHo4+k9uXYUclLzHDOD3ByMoqvWPMEhUgtDHEr9yn5kj6
         eOT/aGzw+IOtyP5mvOpnoNXmyJXTv5H2YsGjm5zKPMP6THevWdSGjetMfLx+5Dd7Bj2C
         70Fp1aFbRKvJXnfA9CZjrlp5eQYjR7VY+9Vs+yiIPL8U5sADWLBKcNS9fvHIpf6LN6MW
         GnQlKJHAtsqkIriNuoEqIdgETEcmLFzFWKQwr2A0/Vm9uy/mo7ADGWGh8ZtGoo5i0BSp
         DA4g==
X-Forwarded-Encrypted: i=1; AJvYcCUk1Nza1TYFSX4bre8l+7pETxYvRIXIZdmjZdx9OiM/hPMSd3cfrB+ABUeDCrPMjS/ZoFYKIdk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZP9puGz7hsUWSYNTec2ZjR+4IWTKx+d9IYfLXfuqO/vF2t9JS
	iSU3H9j5/5osYRcE/b1KPw/hW0+nNimfs8AYIEygV8imP1ZiJy7Tb2YB
X-Gm-Gg: AY/fxX6OJv5fBCmrjiCi3Re4Q7P3i7Q9SLDzJIxLgOOmL3bTLCLD5lpHGQKKzFeY64a
	tVCgRG2bbPJgYwEqRUJsZY3Xbx4+pDoiG3ZJD6lJsQ6/aaPfxEoutWeVhy9k5p2B4t4in/RZPtj
	azwU95jfQhNaEoMR/DiXnf/w0MgX6lfagOChwQrnj7V5et9VFQ36wt3JfdQcRo5bPsuzWC7JZwF
	gB4XzGunEDUS1SwUk6FDXSRr4tP93BBLPpWHy6Booohin5+gTYZYvaGS3K3Ah12TApltczio6dJ
	fkOQkrdnLNbIPFaJ2NvSQnA5RIiz3rVFAH9ySoEVyawf9owJGcANHdoR57vtpWN+yg742azc00I
	STXYgWFm8Tc2s8gUFNfGQhR49aVF5JhxB6FZViHacUItZGV6wj+L7F94459XybVPEj7R2tFGmJT
	kDSRencz5GP+lOUPwfxv3q+h/bb3nHAg==
X-Google-Smtp-Source: AGHT+IHiefcf7btCQSFUKrAxCiXJ1hW45Y0S4Hc66MlrtJ5LVsP42OyHRUDsrUHUXG45rEL7nC8tMw==
X-Received: by 2002:a05:6830:411f:b0:7c7:6850:81a2 with SMTP id 46e09a7af769-7ce50b57c2cmr3718104a34.24.1767878750143;
        Thu, 08 Jan 2026 05:25:50 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:902b:954a:a912:b0f5])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce47801d63sm5317503a34.6.2026.01.08.05.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 05:25:49 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 8 Jan 2026 07:25:47 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 01/21] dax: move dax_pgoff_to_phys from [drivers/dax/]
 device.c to bus.c
Message-ID: <3kylgjwvrdrfe5hcgqka2x2jsgicnnjssdpjrqe32p6cdbw33x@vpm5gpcb5utm>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-2-john@groves.net>
 <20260108104352.000079c3@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108104352.000079c3@huawei.com>

On 26/01/08 10:43AM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:10 -0600
> John Groves <John@Groves.net> wrote:
> 
> > This function will be used by both device.c and fsdev.c, but both are
> > loadable modules. Moving to bus.c puts it in core and makes it available
> > to both.
> > 
> > No code changes - just relocated.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> Hi John,
> 
> I don't know the code well enough to offer an opinion on whether this
> move causes any issues or if this is the best location, so review is superficial
> stuff only.
> 
> Jonathan
> 
> > ---
> >  drivers/dax/bus.c    | 27 +++++++++++++++++++++++++++
> >  drivers/dax/device.c | 23 -----------------------
> >  2 files changed, 27 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index fde29e0ad68b..a2f9a3cc30a5 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -7,6 +7,9 @@
> >  #include <linux/slab.h>
> >  #include <linux/dax.h>
> >  #include <linux/io.h>
> > +#include <linux/backing-dev.h>
> 
> I'm not immediately spotting why this one.  Maybe should be in a different
> patch?
> 
> > +#include <linux/range.h>
> > +#include <linux/uio.h>
> 
> Why this one?

Good eye, thanks. These must have leaked from some of the many dead ends
that I tried before coming up with this approach.

I've dropped all new includes and it still builds :D

> 
> Style wise, dax seems to use reverse xmas tree for includes, so
> this should keep to that.
> 
> >  #include "dax-private.h"
> >  #include "bus.h"
> >  
> > @@ -1417,6 +1420,30 @@ static const struct device_type dev_dax_type = {
> >  	.groups = dax_attribute_groups,
> >  };
> >  
> > +/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c  */
> Bonus space before that */
> Curiously that wasn't there in the original.

Removed.

[ ... ]

Thanks,
John
