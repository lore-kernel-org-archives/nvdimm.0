Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5603B10E0
	for <nvdimm@lists.linux.dev>; Sat,  5 Jul 2025 00:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751673999; cv=none; b=JMUX9ho0LGcTbpOyHiNC7k+xvk6mml7MFdhqZNWtq9ybZ+omtN6m30/V3G84QALlH9psjIEnJRwOlQMZycvu1GTNMbTYhzBHGHC2KPgpW/3Jo2WqiT8sg3hDPSHc0uvfns4/d4uPQcDFO2ajP2C1jTS+wFd5dMxfO9jr85Idud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751673999; c=relaxed/simple;
	bh=g/709Mz80eEkm8+UShjp6F/2B9qEEZzVuc/3q6jnrzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n41F6mRHeHgtsdCq04ZhpROhoAToCwMzZ3Z55TXJcom8KTO6kcPbF8dC1ze88UpFHuQu78r9KH2PG7xAa/c9Yt8iJRSs0OIH2ApLliHqhVAZsaUBHY+hYDhMiThrisSMfSwjjg9YiW/lMsctF1wOuPysVSbjF/rXXZ3UWmk+GzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mN0+3WZL; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mN0+3WZL"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6113f0cafb2so759737eaf.1
        for <nvdimm@lists.linux.dev>; Fri, 04 Jul 2025 17:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751673996; x=1752278796; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TwTWoqkPV7gyMrYquUEBim6LYd65earG3U1YSwgWTMk=;
        b=mN0+3WZLw9jasXJ4zM4Y34GjlGm60A3Q96VpekntXoeKlirLGdkVzwIIEg8sV8uSzi
         No0j9p244MnZ4rPccVOYym4ZAmMD/ri3dfFRck66KYlgXizNnZfM5BX21qTm6HZxFN8J
         5MYJnTJMefVXB40zqiue2MXRsUOTfgLC3pT8SVxwc7fKy2DuvW1dLFvNEc6n6FnKm7wt
         nIhUvQ7YfhlwoEGCg3AqHPcdkkYuR5lxRO/u0g5sl+/AIvHPaGSZtJNasvGnTFvzTfrp
         8lz4R/1VYO11T4KI7LmN2nAZGaOxXKHMjGWf1ZEhYp+K72UfCVpt5q79h0HQOn9VlPeE
         mlsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751673996; x=1752278796;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TwTWoqkPV7gyMrYquUEBim6LYd65earG3U1YSwgWTMk=;
        b=sM9FVFWQrw7AqVdCsJhlqBw5u/TZymHA7DiJBGKyjEUB9eDJ+G4M8dpohvt7iWRvZ6
         a0KW+NIPzkte9MRLcGNSKRpbyDR+0J4lZnYVtQHrNJ3wygBFLKVmWa+Agx4OLDL5kT5s
         SNvrtExmuIA7rn7J9sFE8uYnYICQDjZYzznWY1yEDUQoh1vWaEtx8k9j4ay9VAfYXc1R
         yoby2ItiRe0/02P02Nj+I2Hc47Db2WvPxqG5mXr9u2ssde8DZHfrunFIDkyat8+lrcot
         ziVkXY3k5vR5C8yV5fWlKioEq0zijkfD7iMCaP/2RMr8SMuOc0YzPKdZ++NZ7euS1qGO
         KSgA==
X-Forwarded-Encrypted: i=1; AJvYcCX7ot+xlB4lYdpJy3OGjys7Q2BvL9nkiLins/N4xtjP8g/+FrghoqRASWCKb/7KVKcvxsgxFgQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YymIYhD+B/4BenXn6Frj1qrkVeJkPQKUZ3q+qn69PAhQF3oMv7K
	boMsQvEqtUWO78U8kN29v4S5DRNQirhRb7g25Y0bZcf1lx48o1XagIwC
X-Gm-Gg: ASbGncuGp/ivCFa8eMST9GQpE9g65iKvGqrhy2n0n6MoTFa18IzvQXAaSBvb0S9qGha
	wiV2PLdXjjIZfZ93A1JpBkt0+DMLUuRauTJtepL6IwZwwV9UJ7jOtcXnpe+zgSAESUjlmmG8WNO
	8DS9TculPTXVnSC4+8hJ+J0EdKOEFESs606r9hKhB2w+b42A/hANuIRxhm+3ZZnGtLVt0rvEcQq
	7oD6GuNIv06brnzURFMveqi3gBTLFd2FxJj2ZWi6JMaqWe3a3uACflyMFJfL0Iu50ySJqu5Bfpe
	oqbpg0ufutTLDXQafDcHeHdqQhci3Zgni/mz0jcNTgYquR+VAXHxacSm5dNVO/LXx8w2QDzVGbO
	K
X-Google-Smtp-Source: AGHT+IGGepiWMq8fUxN8wR+DXLW7IkcNmsN4ClsJREkHtU4D+josD6m97IlCmcwRCouZrTUZPa8LRg==
X-Received: by 2002:a05:6820:2687:b0:611:e31c:5d23 with SMTP id 006d021491bc7-61392b6ebf0mr2741583eaf.4.1751673996244;
        Fri, 04 Jul 2025 17:06:36 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:5cca:28eb:68f3:4778])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f73518fsm570731a34.12.2025.07.04.17.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 17:06:35 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 4 Jul 2025 19:06:32 -0500
From: John Groves <John@groves.net>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <gwjcw52itbe4uyr2ttwvv2gjain7xyteicox5jhoqjkr23bhef@xfz6ikusckll>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-13-john@groves.net>
 <CAOQ4uxh-qDahaEpdn2Xs9Q7iBTT0Qx577RK-PrZwzOST_AQqUA@mail.gmail.com>
 <c73wbrsbijzlcfoptr4d6ryuf2mliectblna2hek5pxcuxfgla@7dbxympec26j>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c73wbrsbijzlcfoptr4d6ryuf2mliectblna2hek5pxcuxfgla@7dbxympec26j>

On 25/07/04 03:30PM, John Groves wrote:
> On 25/07/04 10:54AM, Amir Goldstein wrote:
> > On Thu, Jul 3, 2025 at 8:51 PM John Groves <John@groves.net> wrote:
> > >
> > > Upon completion of an OPEN, if we're in famfs-mode we do a GET_FMAP to
> > > retrieve and cache up the file-to-dax map in the kernel. If this
> > > succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.
> > >
> > > GET_FMAP has a variable-size response payload, and the allocated size
> > > is sent in the in_args[0].size field. If the fmap would overflow the
> > > message, the fuse server sends a reply of size 'sizeof(uint32_t)' which
> > > specifies the size of the fmap message. Then the kernel can realloc a
> > > large enough buffer and try again.
> > >
> > > Signed-off-by: John Groves <john@groves.net>
> > > ---
> > >  fs/fuse/file.c            | 84 +++++++++++++++++++++++++++++++++++++++
> > >  fs/fuse/fuse_i.h          | 36 ++++++++++++++++-
> > >  fs/fuse/inode.c           | 19 +++++++--
> > >  fs/fuse/iomode.c          |  2 +-
> > >  include/uapi/linux/fuse.h | 18 +++++++++
> > >  5 files changed, 154 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > > index 93b82660f0c8..8616fb0a6d61 100644
> > > --- a/fs/fuse/file.c
> > > +++ b/fs/fuse/file.c
> > > @@ -230,6 +230,77 @@ static void fuse_truncate_update_attr(struct inode *inode, struct file *file)
> > >         fuse_invalidate_attr_mask(inode, FUSE_STATX_MODSIZE);
> > >  }
> > >
> > > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > 
> > We generally try to avoid #ifdef blocks in c files
> > keep them mostly in h files and use in c files
> >    if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > 
> > also #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > it a bit strange for a bool Kconfig because it looks too
> > much like the c code, so I prefer
> > #ifdef CONFIG_FUSE_FAMFS_DAX
> > when you have to use it
> > 
> > If you need entire functions compiled out, why not put them in famfs.c?
> 
> Perhaps moving fuse_get_fmap() to famfs.c is the best approach. Will try that
> first.
> 
> Regarding '#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)', vs.
> '#ifdef CONFIG_FUSE_FAMFS_DAX' vs. '#if CONFIG_FUSE_FAMFS_DAX'...
> 
> I've learned to be cautious there because the latter two are undefined if
> CONFIG_FUSE_FAMFS_DAX=m. I've been burned by this.
> 
> My original thinking was that famfs made sense as a module, but I'm leaning
> the other way now - and in this series fs/fuse/Kconfig makes it a bool - 
> meaning all three macro tests will work because a bool can't be set to 'm'. 
> 
> So to the extent that I need conditional compilation macros I can switch
> to '#ifdef...'.

Doh. Spirit of full disclosure: this commit doesn't build if
CONFIG_FUSE_FAMFS_DAX is not set (!=y). So the conditionals are at
risk if getting worse, not better. Working on it...

<snip>

Thanks,
John

