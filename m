Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C131F3BB5
	for <nvdimm@lists.linux.dev>; Fri, 23 May 2025 00:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747960210; cv=none; b=LFGwDMf5Ksr/7+4XGgz1btXPfLly/aSb5yM2gl2jRkedtEhtP0BMjTfz6cpdpQnEM3lLsEz3/0UrZLPZntNdbsDQRjT1apG7jRb/0PXzC2r4UFph0PhMJywX0wWpGMN5xAHFHVxxeQ42F43tKuy9rIhmiIIku3im2qVuh6b6TYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747960210; c=relaxed/simple;
	bh=Wl5YfiDuVTh4ATPHm/VPfxVkWv4VXMTmqAwd1VupLRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbXxxvLzoUmXCuzQMw/x2YDho8NG896CLNN3ATXf5R5LK6zBJVa53cv5jXiM8DfC+V6QEo7mGJmwjAxHufa5pbm2ZZlRw1NwpU+eP193EIv6gyCKB5r39wyiO/liwo8rAeHmajRMSRbQDppI8Up3eiNuCVAvXdoe0oQi0aCxHnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hgCCN4we; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hgCCN4we"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2cca475546fso5294715fac.1
        for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 17:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747960206; x=1748565006; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l3DeqVyXhMjUkCDgLsB9zplddhMp4wWfdmMvRjbrEdM=;
        b=hgCCN4wedkPn6Tb8cPR4LbYlUdNEHfFkxWvXczxA4LRoTcrcG9BZNyPWeYA9IGH/qc
         pT2RtyCt6/iDc6quycQ/XToyewC6usLKFnmXObv6dbBxDoejvPmI4wjC2t9i2IYtcJ7l
         FKNC79SMEhiWBW7ftb3vvIIz1D+eHgI1xW+aJkkw6LvNZq3A89lhNm0YvcIFwZPU4Xy3
         0DFfSK7PRaPYDsxjyf0yjY4lV4EOSXGsYKUHRsO1w2rI03duXXERO8I7NyK9TWivdAVt
         +9QMTkdc/dUKbvD7aA1giSPQKhCfgjWtRzqlxaD6BNqVAoRcu6HtcHG0WUbPpxBz/Uar
         pw6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747960206; x=1748565006;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l3DeqVyXhMjUkCDgLsB9zplddhMp4wWfdmMvRjbrEdM=;
        b=a1DlBAk4g3kFNx3sHTzFCi3yvv/NuwWcoyraknZfkrlvPt27uWBYWdzmH30KSe5bM1
         N22eW5rxr54yZUfQeG7b+NMWV+N3Ch8giNnOBzhzDUlEdg2iZNGFtuINhX1dMg4rbmV+
         LVA1t+1neN+HbWJdIJleqB2oUQi0B3d9bDh/huMsYbqUgm748j6Sa3zhp5DpqwdkgMOF
         yuwpRuJvoJSS1an2zXAZhdrKITj/f0YuMW6GRyuKeUg1lwxDZvGi+JvyWkQGZl6dGO8a
         1N0ycsRwdoidOCeh8R2wRoqcH5d10rgCodVUsfETeTpFXa9WLeKE9JLhRNKDk0a4JHfU
         yXwA==
X-Forwarded-Encrypted: i=1; AJvYcCXV+YIwW4dMBk2Cs66zFaRUfV+wFazhoeoU0atVA9tguFSTZmZMwnqmGuoljMkKouLpLt2vRlM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzQU4bmi208Nr8gudeDTbhoP/KDOQw7EIrLVy0dlppQYjAq48r
	Bt8b/l5SOWFkTL2AFISnjLxZjchGzBmGz5br73g5wlCxkc8yES9ghmka
X-Gm-Gg: ASbGncvMxGDoHC8ircZsC1WPeupNRyT/x0rTOzpioM3vyVyxExwQzGURkDtfBakQ0/D
	RYsBMvfFjJJqNpXqq1TjlGA9KkaUvSaA+IkTep5ZXbUJVj1XsqYqfKgQ59YB7XY4r/ga5vCm3gK
	Cic3HSC8hg1IEFAbIELgvbHLdfzEhITRknJ4PmJdaVFZQYNk87Xno/uWj18kz6om+Kv2l4qe1ne
	Gm1mmhTvXMplIo8ccL7+IH8nXo/5bQKudVOi9fBtbmH0+Vd8MnqcCINL48W0Lq11QQKYdO9fSTU
	/h+XyinWJrN6R3pUXnrAXcuLnqtP7DSpCZ3cjnylI4yZC5GDnKopyIbSSqOYLQPcMQ==
X-Google-Smtp-Source: AGHT+IGzkPKh4ltsHgJ3DC9EjVHlO8KxAU5N7rqWDv9531QCEztz3JUTMJs31ibfrfp+x7mffoOdEw==
X-Received: by 2002:a05:6871:aa14:b0:29d:c85f:bc8c with SMTP id 586e51a60fabf-2e3c1f50b50mr17123684fac.36.1747960206336;
        Thu, 22 May 2025 17:30:06 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:5d18:dfdf:ed52:cd5d])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2e3c0a9e02dsm3339566fac.35.2025.05.22.17.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 17:30:04 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 22 May 2025 19:30:02 -0500
From: John Groves <John@groves.net>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, 
	Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC PATCH 12/19] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <dgt4gpgpc4f3455rxdhztvnbmewdo3yw44b7mbs4tj2bt2x56n@dr5txuwm2c37>
References: <20250421013346.32530-1-john@groves.net>
 <20250421013346.32530-13-john@groves.net>
 <CAJnrk1ZRSoMN+jan5D9d3UYWnTVxc_5KVaBtP7JV2b+0skrBfg@mail.gmail.com>
 <xhekfz652u3dla26aj4ge45zr4tk76b2jgkcb22jfo46gvf6ry@zze73cprkx6g>
 <CAOQ4uxj73Z8Hee1U7LxABYKoHbowA4ARBFDv434yDq+qn5iMZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxj73Z8Hee1U7LxABYKoHbowA4ARBFDv434yDq+qn5iMZw@mail.gmail.com>

On 25/05/22 05:45PM, Amir Goldstein wrote:
> On Mon, May 12, 2025 at 6:28 PM John Groves <John@groves.net> wrote:
> >
> > On 25/05/01 10:48PM, Joanne Koong wrote:
> > > On Sun, Apr 20, 2025 at 6:34 PM John Groves <John@groves.net> wrote:
> > > >
> > > > Upon completion of a LOOKUP, if we're in famfs-mode we do a GET_FMAP to
> > > > retrieve and cache up the file-to-dax map in the kernel. If this
> > > > succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.
> > > >
> > > > Signed-off-by: John Groves <john@groves.net>
> > > > ---
> ...
> > > > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > > > index 7f4b73e739cb..848c8818e6f7 100644
> > > > --- a/fs/fuse/inode.c
> > > > +++ b/fs/fuse/inode.c
> > > > @@ -117,6 +117,9 @@ static struct inode *fuse_alloc_inode(struct super_block *sb)
> > > >         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> > > >                 fuse_inode_backing_set(fi, NULL);
> > > >
> > > > +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > > > +               famfs_meta_set(fi, NULL);
> > >
> > > "fi->famfs_meta = NULL;" looks simpler here
> >
> > I toootally agree here, but I was following the passthrough pattern
> > just above.  @miklos or @Amir, got a preference here?
> >
> 
> It's not about preference, this fails build.
> Even though compiler (or pre-processor whatever) should be able to skip
> "fi->famfs_meta = NULL;" if CONFIG_FUSE_FAMFS_DAX is not defined
> IIRC it does not. Feel free to try. Maybe I do not remember correctly.
> 
> Thanks,
> Amir.

Thanks Amir. Will fiddle with this when cleaning up V2.

John

