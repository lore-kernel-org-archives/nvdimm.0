Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85F92192F9
	for <nvdimm@lists.linux.dev>; Fri, 15 Aug 2025 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755270367; cv=none; b=J3hEutRMy8nle+Glxd2WTUpYd6V8wt57ese5N/w5Tu9NPtePDYDJta85nU0w8IDzF40CsuHCcvza/st599vestZdbsY2hKkkv0NrgrzT3HfUn/E0P633FVXndsYYWxYT7aqApIFMdzFpEUWHSXpzgnLgLgI6M82r2/xPDZbrvm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755270367; c=relaxed/simple;
	bh=Hv6COFjM439OcVUsu3MmySHKd9Z183npAzo+Lkk0SrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJOlqZ1mh7/82Mx7al7bcu4ZVt9QQ8Og7zzVnq4GU5BhMdEakeWJDJnQTnrQW0etGcinlhgqP3kBG2HFejRj5RzZH1Ur1SdJJPlp6cBTYswt2AiNFhM086Yl+fESR02IZMAPnh5qR+aoZr/bmE0CVtqmkzt0fx5TRVlUsyuZ/EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OIJvsDEM; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OIJvsDEM"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-74381ff668cso1129615a34.3
        for <nvdimm@lists.linux.dev>; Fri, 15 Aug 2025 08:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755270365; x=1755875165; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AMU3P7S8F7Aw6uN0IIUSqn9Ly+qBjCwhp5TaPqOj3Q8=;
        b=OIJvsDEMAxjqqLzdAhtoz4zwHxWJI4QhLF6tTT8RBzc0xBanPi4oA6R9sN/vWvUada
         Wj66+Mf+zhQ1k2t72ifIcd2yDCHhlhkktLBjFsh6bKubeUvOn7C7MMuxmF5pRgKXtm5V
         kxsvPabClCX8Y53gQeLHstR6hOyytbIu8pLNpy1VHSYE89xCo5Cqey6pNKpq7j4uBsnB
         ZG48F0TFFb18qgRPViZtOz/2xv42BbyRAsMPhGcEd9QoOCXhdUPcg5GzAxiyZEgCSMky
         Fyyc23nMTBXMbif1l6/FqecaXAVN/1sZCcedcGgYDPoCge47XeqEJK94G6x6QPtggjO6
         SduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755270365; x=1755875165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AMU3P7S8F7Aw6uN0IIUSqn9Ly+qBjCwhp5TaPqOj3Q8=;
        b=vR7i1Wpkj1cAxKWbu/+VZEh4wVyFTCyb760RAVEMMbYCB/2VJea2z6x6HG5nvj2l7n
         fOeuzhsiGJqptxKthD+6NhnRdqKKhWYzRAc0RnCCHa4BjGNWlpf5HrS6wAsh8udBIB4c
         q10XjQ61IHa50FuQUT+HlV9wK1uWj4AZJKoKlbN1Y6GhK9qw1A6j6QbpNPQJZqlNT5MF
         mhy/tigqNBx9w+ULtOUgX6I/+QwJ9W2WU0A9t8XTvEPE+Mcbbwb/dlEubhV5kXs6O/Aj
         63hqh+MLAG/mPZekt7s75ifDm3MR3oqTylfTJHdNKJOnYj4Nd8gm7toSDmdS8GvwRU3a
         Hy2g==
X-Forwarded-Encrypted: i=1; AJvYcCV+fWrPJNHZ7AMfJW8xCtGxg6IS3rP0q4hRxRw4ymNOxS2I1NO/R7fqF8fOtGCXZsgvg47y9os=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDmlEmS4XNWD+U2mjZkfqB4UC67lU33lnzxikXAQ6689vu0Wli
	WaUngU3OItzrB8Uz7gWkQXp76PJmqHAV4q33Qt4M7qy9O894moxljeXd
X-Gm-Gg: ASbGncvGkFVVKgDCeC24t6IMG494IgBBR8Qrt+kvqfo1jN2EbjVxByA+jaeG/rn6Piv
	3FJDR4sSwyTHtQgFk0PUDnCbznP8roItTOZYdy01PWKeqL5RcCYOEwBAWyVJEqHEewTHs8qkbm6
	OUedQu/maNIaCXvAH7vNlMVFLbW6p53Z/tycwskouPexRvSXzqByid5eeorS/XahHvAwbtF5sqc
	FSL1OMRSmL9LLMGTtHtU5LmefEHZM8KyVUUcSkfXE6OmIXOuyfU2kb3wTaIoZUwR167RN112reC
	To8OBwuwQ2TR2v6h1gqQ6DbcE/IYfVT8SJRSW29i4fwg6RscvQMTI/jshjZ08H+loxKzMahObme
	IguEuoBXl/qMnJzcx2WBK6SB+Ts5EMUh9oaPu
X-Google-Smtp-Source: AGHT+IExS7Qt3BoP7WsTyBTrr1V2BYGnO3GcQJg9xqGFg1jMcr6eYkPlR3LXsnRgQW/iQZY9uRNbxw==
X-Received: by 2002:a05:6830:448c:b0:739:f3b2:80f6 with SMTP id 46e09a7af769-743924651c2mr1338051a34.14.1755270364063;
        Fri, 15 Aug 2025 08:06:04 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:c95b:3a76:bbcf:777c])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-61bec13e5c6sm145880eaf.25.2025.08.15.08.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 08:06:03 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 15 Aug 2025 10:06:01 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
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
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <hd3tancdc6pgjka44nwhk6laawnasob44jqagwxawrmxtevihe@2orrcse6xyjx>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-13-john@groves.net>
 <CAJfpegv6wHOniQE6dgGymq4h1430oc2EyV3OQ2S9DqA20nZZUQ@mail.gmail.com>
 <CAJfpegv=ACZchaG-xt0k481W1ZUKb3hWmLi-Js-aKg92d=yObw@mail.gmail.com>
 <20250814182022.GW7942@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814182022.GW7942@frogsfrogsfrogs>

On 25/08/14 11:20AM, Darrick J. Wong wrote:
> On Thu, Aug 14, 2025 at 04:36:57PM +0200, Miklos Szeredi wrote:
> > On Thu, 14 Aug 2025 at 15:36, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > I'm still hoping some common ground would benefit both interfaces.
> > > Just not sure what it should be.
> > 
> > Something very high level:
> > 
> >  - allow several map formats: say a plain one with a list of extents
> > and a famfs one
> 
> Yes, I think that's needed.

Agreed

> 
> >  - allow several types of backing files: say regular and dax dev
> 
> "block device", for iomap.
> 
> >  - querying maps has a common protocol, format of maps is opaque to this
> >  - maps are cached by a common facility
> 
> I've written such a cache already. :)

I guess I need to take a look at that. Can you point me to the right place?

> 
> >  - each type of mapping has a decoder module
> 
> I don't know that you need much "decoding" -- for famfs, the regular
> mappings correspond to FUSE_IOMAP_TYPE_MAPPED.  The one goofy part is
> the device cookie in each IO mapping: fuse-iomap maps each block device
> you give it to a device cookie, so I guess famfs will have to do the
> same.
> 
> OTOH you can then have a famfs backed by many persistent memory
> devices.

That's handled in the famfs fmaps already. When an fmap is ingested,
if it references any previously-unknown daxdevs, they get retrieved
(FUSE_GET_DAXDEV).

Oversimplifying a bit, I assume that famfs fmaps won't really change,
they'll just be retrieved by a more flexible method and be preceded
by a header that identifies the payload as a famfs fmap.

> 
> >  - each type of backing file has a module for handling I/O
> > 
> > Does this make sense?
> 
> More or less.

I'm nervous about going for too much generalization too soon here,
but otherwise yeah.

> 
> > This doesn't have to be implemented in one go, but for example
> > GET_FMAP could be renamed to GET_READ_MAP with an added offset and
> > size parameter.  For famfs the offset/size would be set to zero/inf.
> > I'd be content with that for now.
> 
> I'll try to cough up a RFC v4 next week.

Darrick, let's try to chat next week to compare notes.

Based on this thinking, I will keep my rework of GET_FMAP to a minimum
since that will likely be a new shared message/response. I think that
part can be merged later in the cycle...

John

