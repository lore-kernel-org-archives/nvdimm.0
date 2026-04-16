Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D153937C0F3
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 20:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776370453; cv=none; b=bLL3uOWWyvA6BelKFV9W0HYlML0dtTiLw9dWbSikk96Y9Byp34KQH6VqHFfwsmwOUCTdoOmBgmQQ9UBHfBHcFNqTsZMtMB5pz4o3MhxxlgrMBXwkDTqvJTTd+WdIWBMhLOj0rGW9O2G6UOBipy/qzvBcJWkGgVQ6JMMqSope2D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776370453; c=relaxed/simple;
	bh=e7Fg9iUXgdaJVBpIOwk6ko7gURjRziHIJE6o8vDP+M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cOfUDZ6UV2TdBRgRHyDkX/+YdUsSc5Bs/Dez+DgIU/aAxt4BBDtyNEp4SvEwzKIXjr2St+NpfYWTMNznc5JU2JcKwk6DqqZ0EoDWdzHkeJeFMDPmYDyv82AHa4/Wt81kqPlb3lHzPrloEauKYh4RZ7mSeogtrL0VSBs99qIi0DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=p1uxz9FL; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="p1uxz9FL"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89fc4147f2eso100346366d6.3
        for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 13:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776370446; x=1776975246; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VzpFkDx1hfZFcFbwqFMS/1j2riFwDbWAqbQBRsqDt2o=;
        b=p1uxz9FLQi5KlHpjvhKh5+sBUmZBEJM+RRyVgGjxzf0kEyQ8fM7IMuQT7Ds4pAmZNE
         +roPOiAMoXfPDWcEXEWuSZhP75wbX0BS+agqZw1a0k1CN4jQQEaBNleDczWJ6b91n6u6
         IEpaHfOL967gDRzulZP35/Mjomt1thBeY2W8sYcrl8SII07wb5WAIeK1/8VbbfO8v97B
         jTH3WfZLbRt6bkoRacZRm5sDpe7HLm/sgnzoIp6BmKSYizhVu5bQ67etxibMZHIMZHB6
         j735Wh3vVgzJhDIiZCqUkSqY79ao0i2L9EOQga1MMpfFPdtgKBbAVKkwUAo3fywqNgHm
         lnAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776370446; x=1776975246;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VzpFkDx1hfZFcFbwqFMS/1j2riFwDbWAqbQBRsqDt2o=;
        b=qTXn0hQ260kB7oTAtU4UDLngRhbNJMyeKp8i8T1qs86y8gNOeHk+ackqSqBP6nOqbn
         PTF+lgWqJeq2D8o8wys5S5H/szl8vwA/JnXoLv7VNH8eGcpTeeQ/3/tAaMovn4r2Mi9m
         6fnXsdxSJsfkHW7lDc5HG2pnFIlze8dyRL50wQA5hM62Tu5IwRYo6MxmPgnLxuk8iCc+
         TBMERp/qxvb+TswgAEbVgywSNT8/nbfOsDRsza9vkTkD7iWEaGQ5uknCE3+A6XaK6QFf
         KaW0/bKigYsO57erbCG25UFVh2RnPJvWC5m9JMfnEz7O/5E0A71I82gECz6mbMd8Gd9t
         LS4g==
X-Forwarded-Encrypted: i=1; AFNElJ9Lc/0Z7EiY2Keym/1o4NDipdR3gMIWiUmDzoUinA8hbLdnu/sUmcfvpj0y8JEONk2jJAFJGGo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3dV4hgnFj4ZZgueGfWvbpTd/PZ3r97cSTKuKHnlj4kPD7YvLy
	peH/W31JaG/X0F65Uxnh9HAZsT5JQVsmJrFgUkOr3bVxwOVvgJUW4z6ffkV1KW/hxwk=
X-Gm-Gg: AeBDiet9PuZBcJ2XDEu0PJs5Wt9fAYo7qlcdfRzyyy6ol/yYh0MH7avBfkfZAHFWwes
	m7/yh4rEWbbLZ2SGeO2XU+QJQaNlG7W+ObBm+wLqGPwt8GEn1s7CfLwYzNW1GlcZJh4vsjaqnWv
	POA/VpeyLTGL9ieRldgAeAMkx9c+4qRf/6kdpPstjwp7u8w7hdnIK/1ri5IcSNbgYSvQMTHqQRQ
	vrSXH9tVsPpXqVo0ABOrgHsrkRAXexrqSM7aVvmsNefHHa0X4fK7glcnD8TNdAAy8UAFM5gKKM8
	43inZwMDq0/OBWwq9sTvw/9v3MAqaI1JbAum/y3hLoP7ww3DNri0t9t/klUySy28WWO1QfB6+CR
	XAMCy2uiIz0Rg4wzgmTSNUFVYB6tlPdNpzfKs6GnUOJ7+fxBURvv0+jxoWyhRQnULwm4v7b6tbN
	K7f6HuOkbjMjEdYEvRO0UQt7AZLZ+Jp/ZE65xPamHuS+V/Ah6FGDfWQ+1NEe8=
X-Received: by 2002:a0c:f09a:0:b0:8ae:6347:8c8b with SMTP id 6a1803df08f44-8b025ef029fmr11410336d6.37.1776370446430;
        Thu, 16 Apr 2026 13:14:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2607:fb90:ea1b:4643:9f36:3ffb:fc60:9518])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ae6cb9ee20sm43873996d6.26.2026.04.16.13.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 13:14:05 -0700 (PDT)
Date: Thu, 16 Apr 2026 16:14:01 -0400
From: Gregory Price <gourry@gourry.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: John Groves <John@groves.net>, "Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
References: <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net>
 <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>

On Thu, Apr 16, 2026 at 08:56:46AM -0700, Joanne Koong wrote:
> On Tue, Apr 14, 2026 at 5:10 PM John Groves <John@groves.net> wrote:
> >
> > There is a FUSE_DAX_FMAP capability that the kernel may advertise or not
> > at init time; this capability "is" the famfs GET_FMAP AND GET_DAXDEV
> > commands. In the future, if we find a way to use BPF (or some other
> > mechanism) to avoid needing those fuse messages, the kernel could be updated
> > to NEVER advertise the FUSE_DAX_FMAP capability. All of the famfs-specific
> > code could be taken out of kernels that never advertise that capability.
> 
> I’m not sure the capability bit can be used like that (though I am
> hoping it can!). As I understand it, once the kernel advertises a
> capability, it must continue supporting it in future kernels else
> userspace programs that rely on it will break.
> 

FUSE_DAX_FMAP is already conditional on CONFIG_FUSE_DAX, the kernel is
not required to continue advertising FUSE_DAX_FMAP in perpetuity.

Setting CONFIG_FUSE_DAX=n does not mean userland "is broken", this would
only be the case if FUSE_DAX_FMAP was advertised but not actually
supported.

If DAX were removed from the kernel (unlikely, but stick with me) this
would be equivalent to permanently changing CONFIG_FUSE_DAX to always
off, and there would be no squabbles over whether that particular
change broke userland (there would be much strife over removing dax).

While not a deprecation method, this is what capability bits are
designed for. Same as cpuid capability bits - just because the bit is
there doesn't mean a processor is required to support it in perpetuity.

They're only required to support it if the bit is turned on.

---

I think the focus here needs to be on whether this interface ACTUALLY
needs to be more generic - and whether that is actually FEASIBLE.

It's not like this is a new problem - and there are real design reasons
why John chose this route.

The additional overhead is not trivial for FAMFS - FAMFS is not doing
i/o.  He already has data showing fuse caused a performance hit due to
overhead on open - his concern of overhead on fault being catastrophic
is grounded in data.

For others it's an age old problem of self-describing protocols (parsing
vs giant inflexible binary blobs, pick your poison).  It's extremely
unlikely we will find a one-size-fits-all solution that doesn't
eventually run right back into this same problem.

I worry that this discussion is going to turn towards implementing a
solution grounded in parsing arbitrary formats and how to store them,
and that is completely detached from why FAMFS went this route in the
first place.

I question whether the actual issue here lies in the interface APPEARING
more general purpose than it actually is - and therefore inviting
attempts to over-genericize it.

Is there a world here where this is solved by a name change and a
capability bit?  I think so.

~Gregory
