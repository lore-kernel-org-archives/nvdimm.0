Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88605221FDD
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 15:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755184775; cv=none; b=IRIyrAIUFIfjVy5KeOk2QY8AuQ2bWphPFlzrUDHwQ3AHYwEdsu0/3zzU/5uGuD7UG3Ly0hqwevn8AkjOs4bawdk2x4qRI655Pk9WRLpx5YE55Dlr2XyeNPqhBU5SYWpypUW/JXBjFVUfQyWJOgbfXrl5fx7uBRyAhBBhVxgNFIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755184775; c=relaxed/simple;
	bh=w0w0dvsu6k/K6PwFlV7vPpkTwV9o99ZgnYkwYYG/8s4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dlAfRquq0DlAYkhM23GJ2j4BGpdbVLG+VeuxoDU0rs74xW5VQuhFpIA5KRwFQm+Jd8qmv691OzQHPlvZxjVqYBSMAq8ffhAb5ZG8Z3FDWwtXcd6w5LSUAYS0qcm7LTLfO/M9Oy4ugqZ7S923Ajjxeo8Lw4PQ5CUO4WEfD2yXJMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=h9d/Rv2W; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="h9d/Rv2W"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b109919a09so13704121cf.0
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 08:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1755184772; x=1755789572; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EA1ZvFf+qWrndIFVkpDd7IpLWJx6+2D8DPmrDSfzpF0=;
        b=h9d/Rv2WaegXit3bWXTvJw/Q5Ct2VgU1Z0w03byJBE+3N7ZIRYPRPkBuYf0g5/Nqgw
         0MkbLsxhYTVHhj8035WQ2btX1ORPuqYamIhjzOgbUUV4+ltJxjhUuHgtQsB3L1rBmZbl
         ytpuC9V3rLpHuTi557FKvhswzjSTwoWPqH2JU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755184772; x=1755789572;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EA1ZvFf+qWrndIFVkpDd7IpLWJx6+2D8DPmrDSfzpF0=;
        b=BW6AZt7L6Z3WwsBZ3Bf8TTkcAdALUKXx+IB8zU+ZYePAKd2WM3aaRCZoABEFWNbsrW
         SmXX9IAorabDyPlonp8rSfXj4nhpIZS6FUJwsGJUm1b+kQRtE+P3vUMad/niKlL5UQf6
         sg+Fv0Nglw6Q7Kk8LrDKzl2NMEXv0unzvLYFoAKPtMMyNQtyZXYBLAocU6D4Y/e7RK/z
         pksLHlIhwCGRXku0cqQb2IBP2dvueHpf8pjIB9Do5qQeOv/yJUrM9yJQyamIQcOKDZQW
         vGGuqqOaTCwga5VJWk0koCLUCLtIsdFsS8++1MyRNvQFr95893Tsjn65NYn4Fwuw/RVW
         OJIw==
X-Forwarded-Encrypted: i=1; AJvYcCW779bXYbVSak8LsC5vWZXPpyIm/Zr3B+MfyfUhcEVftpPl3HdoVS42DRmwlPsxXLnJrQhlQ+8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQt5VRssn2YGI6fM7vtL+1zCz0cuFQ2IldVNrqEaUh2F8xoLiw
	DmbHuOfAYFaDNOc6Qj8EmQOIqGJMjItKc3r3ShhCoSVIMsi4YGHpf9nOzTBEMPSkZNryyfdb7ow
	qXa2y3xJUMy8BqNcuxWmW+kWhxti3xEjyuO76Tsr85g==
X-Gm-Gg: ASbGncs1HJ7e+wOw95GsqtHRkDNMfB0yocGEAUgGTcQoen0CIKdVj1lYKe0KKb3iUCJ
	mh9NYLvFbtCc8aGBsUwx4l1P/7m/Mc5aBNRVS0Ma5G798U/PmIBzgr1numCW8NjCnvUhb3qn9Mi
	Yhcf4DE/v49QCnH9L86J+VEMdUZbfjVPgbL/gViwKRu4Po+voCOHR9wjZXdS5faYSOObPiq7eGF
	VIVYVfs
X-Google-Smtp-Source: AGHT+IG2qa/e3q/lS7fdE17E/mieIqz9XZskfeQdm0xkHvlzBuR85dHk6whip69ESAWWHza3LlnZuCoCgfbTex8i3Ho=
X-Received: by 2002:a05:622a:5c9a:b0:4b0:7327:1bf5 with SMTP id
 d75a77b69052e-4b10a958412mr55498911cf.6.1755184772275; Thu, 14 Aug 2025
 08:19:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-12-john@groves.net>
 <20250709035911.GE2672029@frogsfrogsfrogs> <ttjh3gqk3fmykwrb7dg6xaqhkpxk7g773fkvuzvbdlefimpseg@l5ermgxixeen>
 <20250712055405.GK2672029@frogsfrogsfrogs> <CAJfpegspQYVbWVztU5_XFwbGaTQKe2NCm2mcui6J3qv1VDxdSQ@mail.gmail.com>
 <z56yzi6y4hbbvcwpqzysbmztdhgsuqavjbnhsjxp3iumzvvywv@ymudodg3mb5x>
In-Reply-To: <z56yzi6y4hbbvcwpqzysbmztdhgsuqavjbnhsjxp3iumzvvywv@ymudodg3mb5x>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Aug 2025 17:19:20 +0200
X-Gm-Features: Ac12FXw8eO26MUJ86ncWZmuTB9wijlUFGNEwkcMvFc2CD_KfkHGAKLg17yDdXIs
Message-ID: <CAJfpegsQxSv+x5=u1-ikR_Pk7L+h_AqNBW1XxM-b1G2TLPP4LA@mail.gmail.com>
Subject: Re: [RFC V2 11/18] famfs_fuse: Basic famfs mount opts
To: John Groves <John@groves.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 14 Aug 2025 at 16:39, John Groves <John@groves.net> wrote:

> Having a generic approach rather than a '-o' option would be fine with me.
> Also happy to entertain other ideas...

We could just allow arbitrary options to be set by the server.  It
might break cases where the server just passes unknown options down
into the kernel, which currently are rejected.  I don't think this is
common practice, but still it sounds a bit risky.

Alternatively allow INIT_REPLY to set up misc options, which can only
be done explicitly, so no risk there.

Thanks,
Miklos
