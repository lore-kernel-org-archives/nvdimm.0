Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14DB225415
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768155877; cv=none; b=YC0+Mmj0EMID9QmGC4tQ16VZ11Kdjr/93vno8Zn5o/Jt7Ow5THE1ts3F4SM6EdzWcPhqVFkLgMMeWcNcaxIpx+cDfFo20BhBQPQp8FgkHN1j5HO7FiqK08WTlKltnCI8ZR+VNh6HRFoM6Md2A61J3CvM3PmdFWbmV5AP2ZbvmBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768155877; c=relaxed/simple;
	bh=wuZGY6SRlUzNFhhRYK2DoKN94QfIw6eNulOP0xDDvY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IPrGRM/XL0Muw7FqNiYhUm5IMv/3jtFFVi6vPLbKBhVgKZITcDIxdGmtcqEHlgzmp03As1Dvnic+VqO8JuK3Ot4kkFGTsHS8jvbFsmwRf8Ur8rjvnL4BKI1zvT7pwJjRoOzMZLTmiJTe8DnlL+JIQ4XjrT09jF226DJCUZqSSJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OESnCjP3; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OESnCjP3"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-3fff664b610so984548fac.1
        for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 10:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768155872; x=1768760672; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R+GSc2GBWlyyKLR953NpzcUC6v/+T5KZ51y3NFrwZfA=;
        b=OESnCjP3TWNhw+uRc464WEOYmkJNJYwIyC3Mtt5O6394YZOiNjRSJsqVyDl8+dYpgc
         T694jxSg2tyhPeqOIKx80RYb3Qu6No3Qa7BUzrBzhF01Q3m+U3px7J2Jk3dz+tOHjZJ2
         IjSMM6r2STCXqdsRw1tEH9q0fSj1Qt0ud1xUQOUIiLnaQU/pZNvKWehMhfbLSggasfGy
         MR1TYEKYohVPkYtZHNVi6craA111mQsklPKEZdND/T7juiUZJJrlB8He+7c3rZDkokoY
         6V76u0CVlIwyx5kc+v6PBP8meP49e8T+UDuRyENy0LhNF3lrJsBk0Zi38wbxlrXO9/QD
         pe5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768155872; x=1768760672;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R+GSc2GBWlyyKLR953NpzcUC6v/+T5KZ51y3NFrwZfA=;
        b=vyyMPD4g0lqn9mtMtzcvbDRd5ELjpyNnCTOHNw3Xd0ep1RObmMMFQve0YkJ0O0Ispn
         YUtFwkGHPW4a4y97b7QElS1tZQ96ser/1soOQJ5YcXz0NZsGq7vlwHKi8jdIXBu0dLrY
         OQg1DXgg9koO1y6+Ohi4MYBJfF8VWOXlgWXgbaZAasFy55TAvoUYaktEvpYVemZ3cYt4
         odXe2kiiPWQJ2mO4T65aqoQaTasP9y5vH3fET7YToY8TH/fx81oRZrCZP9tV1zlnIniv
         orX8GuCsLhjwFFudtYyrm21/J7RR1DpYUsTW0RKqHyHRvOn+dc3zzUej+THDWKAKVHxV
         7B3A==
X-Forwarded-Encrypted: i=1; AJvYcCVLyMLDFYrYQVAV/AAkcBZA1iDPGFWSiv5wj0wgbLjuZLw8fuohrujaNWtH09OL20uYJh4mmek=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAsQt/Nk10I2mQrEXcab01imTyO7dHgzP8VbEtx3DYP0jYqzOZ
	wbNJAtBX2S1ZkDg4gUhiJWfEn7oq72vSZ281Awn4gAyLsBZ0/FKTithh
X-Gm-Gg: AY/fxX7ts4g05Pi8Buz10O6kXQXRWqweXeMPB5gnNK1chgQvtceB8jXb8Np+F4OxeRC
	gKRIbUnJ6FRdUOs0QmS5EMPjQNaqEfiRNp+xObskp2iLO5XrcX4jq3RBiTMK3XXZTVU3Qh7h/T0
	YZeo6tyGZDWOa4SQ+pFrAAqMgKPJSNmFaYLxCJFSM4u0nudI3izinXGM8dcTQ2zi4ltgNiFKbdl
	d4YxnfH9L5ZzqGPnIJoDbwWFSVZROUfcyMS2gkdrJw+ytkvo5e1JLyRVKq31XQpQFWc1axxZas5
	p37r9zI/I9HS2sk33HuTQIK5K5A/OP25AdjBHURzQUHDZL+ARYyU7v5a7SVTRRqr+1Bq22MncXP
	0mF55UXrb8m63IokPKsMUmlENje8yo0oEb1A5pV6uWJsr+9TIFGxMp2SxwgkHdYEiIpWlSzPFNk
	/3tcVlSr53P6No9HNWeKIUHWZQn0BCew==
X-Google-Smtp-Source: AGHT+IEvvggI2mJmOtqFQTAS39y6eV7fvRie7hl/ldDRYe8R5GovPjr7x7SyKxaIKesqgZD+L7TFNA==
X-Received: by 2002:a05:6820:1694:b0:65f:6601:b342 with SMTP id 006d021491bc7-65f6601cbd8mr5456330eaf.7.1768155872287;
        Sun, 11 Jan 2026 10:24:32 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:cc0c:a1b0:fd82:1d57])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48bbc0desm6567999eaf.2.2026.01.11.10.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 10:24:31 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sun, 11 Jan 2026 12:24:29 -0600
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
Subject: Re: [PATCH V3 4/4] fuse: add famfs DAX fmap support
Message-ID: <2mr7vou7zeauqypqq3xay6wdmc6g2havk2e33cfphwylu7dnit@qk32hbe7zgy3>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153443.64794-1-john@groves.net>
 <20260107153443.64794-5-john@groves.net>
 <20260108153148.00001e63@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108153148.00001e63@huawei.com>

On 26/01/08 03:31PM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:34:43 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Add new FUSE operations and capability for famfs DAX file mapping:
> > 
> > - FUSE_CAP_DAX_FMAP: New capability flag at bit 32 (using want_ext/capable_ext
> >   fields) to indicate kernel and userspace support for DAX fmaps
> > 
> > - GET_FMAP: New operation to retrieve a file map for DAX-mapped files.
> >   Returns a fuse_famfs_fmap_header followed by simple or interleaved
> >   extent descriptors. The kernel passes the file size as an argument.
> > 
> > - GET_DAXDEV: New operation to retrieve DAX device info by index.
> >   Called when GET_FMAP returns an fmap referencing a previously
> >   unknown DAX device.
> > 
> > These operations enable FUSE filesystems to provide direct access
> > mappings to persistent memory, allowing the kernel to map files
> > directly to DAX devices without page cache intermediation.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> 
> 
> > ---
> >  include/fuse_common.h   |  5 +++++
> >  include/fuse_lowlevel.h | 37 +++++++++++++++++++++++++++++++++++++
> >  lib/fuse_lowlevel.c     | 31 ++++++++++++++++++++++++++++++-
> >  3 files changed, 72 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/fuse_common.h b/include/fuse_common.h
> > index 041188e..e428ddb 100644
> > --- a/include/fuse_common.h
> > +++ b/include/fuse_common.h
> > @@ -512,6 +512,11 @@ struct fuse_loop_config_v1 {
> >   */
> >  #define FUSE_CAP_OVER_IO_URING (1UL << 31)
> >  
> > +/**
> > + * handle files that use famfs dax fmaps
> > + */
> > +#define FUSE_CAP_DAX_FMAP (1UL<<32)
> 
> From the context above, looks like local style is spaces around <<

Fixed, thanks!

[ ... ]

John

