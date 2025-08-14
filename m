Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C181A230270
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 23:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755215538; cv=none; b=KpSkuDHwxrZNigyVg7WnnycDNVD9SHCXRyWMGRjIA+xlce+Qez19xDsvMmHvc0TK+pIWOkLaox7QJHiYTM4Jo/0sv/f6eq29Rynh3csurIACqDq5UIT/IKdOyxZVdoKKigVnCC4PoBtLchHPSxvWuJIKjsEwKseJvI0Gw8RK1s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755215538; c=relaxed/simple;
	bh=FIwBp8wJXikAg8T0jVOLfvQmcs/O9AstztJ/HuCCqRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnVd20+M5ORbe6h+q2S+znZQoQqHRRhsRbcnxT5E9k0RH1B5w9cjZ0BIH8FiweeZt3gGsF5pap9qlBo5UgA1Xo65t4sskZkhPFpiegoWYW3hI6guv4ZOwJJ/HgpW3/UcbHh4EvO4CUyrohHntywlMQBi7I842juAB8ZuG9aVeak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GC/2vd+h; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GC/2vd+h"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-61bd4e301aaso234122eaf.2
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 16:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755215535; x=1755820335; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Cp39JSJVQFqGca1UhwI175ws5wjvkkGsiO7+sL61aw=;
        b=GC/2vd+hECdqtoDtvIXm31URHKihyldZ2ihJl+Ro9GB80pYkvHhFoXt7cHuP0EipGX
         DibCgPHv9eE6KK+RA7GSlj8ufkV3U6ojb32kqnASlCMPZ8sEQ2PFh1wwBXVav7V8MQcJ
         UJb7YRCjmH9cIDlReHeIzuWrwZytPmSBumOAx/p+vXoeI0+Fmszkdgqb1oQN+l4ySvVf
         F6TTMtFeXOHBohddo5ejbSzXCT3sakuWSfH0wF/zqLiN4wYypM1z8J6NEWcQvuis75hz
         k5aR1iErbswK0z5Y6wJoplzvS82IxepOgS6LBOyMTcm8Ki8qPfEMLoyeyquAGQnv9xBe
         TyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755215535; x=1755820335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Cp39JSJVQFqGca1UhwI175ws5wjvkkGsiO7+sL61aw=;
        b=M9uaRzHh2VwNQ5tgYyb3XIHd3twxFrEkEzOo2MM+FO9KzNQdr9Z7k8ER7JjpbjdYHZ
         3YzrsdLj8Lna/VqSv3z4A4SNOmDiT06/1cpBjAWBmFq20lxb5Hsi5r9xAbhtlKlDRLhh
         9ynLYpv3ffuwuviHa/vceZ7hczGwm2WGEzB8ydbBHfoy//g/6pQ2AHgCltyB2QLeV4tv
         uYx171+l5fo4n8hKwXtIIfU5mjsk32BryXt9gwmd4leCZo1vLa/7GNuaaH2+/CoJRp98
         j01+TtaXGqh300JhJTG07wTYnw8HFlZnTw651XjIG2EMPoEuH2KreDNGBzCul9wXd8E4
         CzWg==
X-Forwarded-Encrypted: i=1; AJvYcCWgArnOcJPkyFBzM6zJlirwOgISn6J0Nr+R95HjGGwdc0E6PGKvnG8Xbsm4Efoymlqj4VgmBmc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhwdtsHzJwOrxfnnv2LYUhXfw3LsRnPQVH2enbnKhrnNvChiWt
	dnNNj4ft3hV9SotBZZ1hzlmTDGnIS70b/0+FEB4Q5GGgw1uNVnvcPq+I
X-Gm-Gg: ASbGncttejlKZr5RWmR8U7Lrrk6ddpHEtNs0EWqxyPHN5EIcN2pPAB+pJ205oilMQBn
	ZudnhDVxfFlYsGk4jN22hPTeCputK0m2k6RWiYvsfdCPomAemN523NEO2VvGY1DXTaA8c6Lowzk
	QbQyLlELEkxcKVXQrqBxUA8le+3/Yak+8X9x15gMAE095P+GxquUZZapkPwNuCcwjo/y2obBHhf
	iaSmurHddRtKBfl6mtWJG01S7oFL+EAjZAniiExwa/fU6CciKaa8OAy3OYyvm+YCfJrNO5PZKD4
	Snip0kIK6WAjnwr31ZOo7sDRJpurmO98jAGVIhzfVt6hLqa7TPvgqe+JH8s60hq7cQDRiVKR9QA
	5TmGfFJW9xBtLqVQVGEk8hsG6xP4NtjAlj1xASyMAlhF4nis=
X-Google-Smtp-Source: AGHT+IGaHBl9xPsB9OO1cSHxNM9bAShZhkcOLGtZLcFtgk6aKTkPevpMjng+tcrzZPheSVo/c93Euw==
X-Received: by 2002:a05:6820:1b88:b0:61b:d55e:6d19 with SMTP id 006d021491bc7-61beabc936emr162698eaf.6.1755215534772;
        Thu, 14 Aug 2025 16:52:14 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:c95b:3a76:bbcf:777c])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-61b7caa0a42sm1980047eaf.24.2025.08.14.16.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 16:52:14 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 14 Aug 2025 18:52:12 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 11/18] famfs_fuse: Basic famfs mount opts
Message-ID: <kuarf6hiwmit3jwwe4r27dj46v64k7x52eitsaw27zfw7c62cc@nrzyjrs5kztk>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-12-john@groves.net>
 <20250709035911.GE2672029@frogsfrogsfrogs>
 <ttjh3gqk3fmykwrb7dg6xaqhkpxk7g773fkvuzvbdlefimpseg@l5ermgxixeen>
 <20250712055405.GK2672029@frogsfrogsfrogs>
 <CAJfpegspQYVbWVztU5_XFwbGaTQKe2NCm2mcui6J3qv1VDxdSQ@mail.gmail.com>
 <z56yzi6y4hbbvcwpqzysbmztdhgsuqavjbnhsjxp3iumzvvywv@ymudodg3mb5x>
 <CAJfpegsQxSv+x5=u1-ikR_Pk7L+h_AqNBW1XxM-b1G2TLPP4LA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsQxSv+x5=u1-ikR_Pk7L+h_AqNBW1XxM-b1G2TLPP4LA@mail.gmail.com>

On 25/08/14 05:19PM, Miklos Szeredi wrote:
> On Thu, 14 Aug 2025 at 16:39, John Groves <John@groves.net> wrote:
> 
> > Having a generic approach rather than a '-o' option would be fine with me.
> > Also happy to entertain other ideas...
> 
> We could just allow arbitrary options to be set by the server.  It
> might break cases where the server just passes unknown options down
> into the kernel, which currently are rejected.  I don't think this is
> common practice, but still it sounds a bit risky.
> 
> Alternatively allow INIT_REPLY to set up misc options, which can only
> be done explicitly, so no risk there.
> 
> Thanks,
> Miklos

I'll take a look at INIT_REPLY; if I can make sense of it, I'll try something
based on that in V3. Or I may have questions...

Thanks,
John

