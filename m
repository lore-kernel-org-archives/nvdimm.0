Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84052690D4
	for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 20:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745439793; cv=none; b=q2CgeduTfTTReKhXMu3WMnyrQJqrxaxF+b8R8IRukTSW6gw6JgBu7m5aQ2Acn0d1fj7unSpZRur1Dl9OF5cyq6rNU1/5KH6bbBTnyYyvQKQ12I3ajwL8pvoiuv9av9eOLyh9maVfdhWLt3i4efmOIzXUd9oDTAbbZYh8QX974Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745439793; c=relaxed/simple;
	bh=9FXiIL8sGXQRZbcF0o7E4cI6TAMvfaP3y1StfzQkbXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XzjyFmHnFlPPWgutBLHvGL/4Hwd2H7DbtExpUHqjEmxRZjFz2RRSlaEhgshgKPg7Ctg6D8DHzf45VqHCXci0fc7StqyhsrzzgV3Pb1cmhUkehvy3bvYVWP3Q6cTqUWPWRPsssTiWwiM5WCiEgbeAKPh81EsOLpxDE/0oq5XtkFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fZ/g+PqI; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fZ/g+PqI"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3f6ab1b8fc1so168520b6e.0
        for <nvdimm@lists.linux.dev>; Wed, 23 Apr 2025 13:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745439791; x=1746044591; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=97lECeIymX5vGttM40ZC9LxwILKEadxdlNBvDo4t1iE=;
        b=fZ/g+PqI92GHEI9/Q65EcXgdJCOA8vnf1D6MImjtHL1juXxa8coUZYKmKKhMQQWry7
         sI5oJwA5sOr7rVV1Ir+1OUhVcDXi8F7TfE9M/3R7UV9osIeOf/4sqLACR1DsnyCYGE+T
         xArNe3hj06x7rFdl1T9EBzybWgJpR+obNxSu2idij8pf9c7WNngZC9mhCWaXAmZvbTHD
         4Lzl+t65WKJQ9j4UT6v1Xyz43NXfdJa9ydL9AesBlzkwFeSciZp8VtnoWY1haVyuvRyF
         K0AUbxNlhooVzvLgkfsukOk40bwEh+01FjE/CJ59/vd/jOyX96gAjcEWQknnFr4a7f2e
         YzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745439791; x=1746044591;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=97lECeIymX5vGttM40ZC9LxwILKEadxdlNBvDo4t1iE=;
        b=OeAM1E6EF5DAWJlZwxvrxCLxxxAUvuVjzttvuzC1u5Pb/jP15nbIwxIXftsIp5yBRR
         wRWq9AsY7aNlWnV01JB4wLm+bDPQDWR+Lkx/9N+CJBRnOow+t5l7B/8lfMWhr14Eny35
         ATrB58T4JDQda49wnNcOVmLXwD8XJgwAcF+rJpXw8zWJOifNBOpPG1bSlap7BNOoSRH6
         qhr6xl+m041C/nB7Vc1uuXzdR1DcHOnBxDEOgCdX/RToaL0e5oNcvCwvCLlozfR8373X
         IjmEaP6cZQKd//qA5gQ8Zij4I7Hp6nvYl/TWhJMLLsqOhAOZrGrZBoz+FRLjayoa28W0
         lHmA==
X-Forwarded-Encrypted: i=1; AJvYcCXzHyPclUOlYeoCR1Xqf5ZUAnwGKhdIgO0UZRSjrJZvagCAyEVRJ9ZkSTL50C8bKOzDvDc1dcg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUY2YDsXNDUrVe7yDW+GpCP00OOHYTaGwDvv3RoY0zgKa3LXmd
	wo3X1zgtpbfB+qnVa1VhzjEabtJVV07dx1rAPS0QLXCrL99d9wTs
X-Gm-Gg: ASbGncsaeBUhQXR2DrUOcQnjwQyO7UK8JazA/UgE461yBRvsWqagyfeI1/XXp/9/ADs
	WCmeRhY0bMyOfMeBRKDROLLN/ljo5+RnFmkiMb7jWKM+UxSv+/PIP4YpMN3opB9KljKhL9E9P7j
	FgVidA4sAEvlj3zLY16hR3P1SylcdhLj8GUsPfXB7ol1N+U5LYFKS25irEiSvjLalvfaWcC97up
	9gaJN5TJM5y6ozFVnOTZgzkQp/YWxe6JHcT9xOo0EOnDPTvupAV8KX67eG3l/jNDkEYavvj63SM
	FzVBrs4K/0ojTF3a6EWPiOL3rENMqO0HSLgrgqQel7e9w/zgNWR1InrR9Zjv
X-Google-Smtp-Source: AGHT+IGEiSY1ULEDyb+dL3+puS1rpFXM4in/5b9Ry3B8H9erXdcwyUm6OyQs+f8oqghalhCsVGHxEQ==
X-Received: by 2002:a05:6808:384a:b0:3f9:56ff:1468 with SMTP id 5614622812f47-401eb2570bamr216304b6e.24.1745439790720;
        Wed, 23 Apr 2025 13:23:10 -0700 (PDT)
Received: from Borg-550.local ([2603:8080:1500:3d89:44cc:5f45:d31b:d18f])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-401becc2294sm2790759b6e.0.2025.04.23.13.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 13:23:10 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Wed, 23 Apr 2025 15:23:07 -0500
From: John Groves <John@groves.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredb.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC PATCH 10/19] famfs_fuse: Basic fuse kernel ABI enablement
 for famfs
Message-ID: <qjwm7z3zr4njddcbnt4dqbl3zof4nck5ovfysdopeogcmizsn7@7fei7dldwe6x>
References: <20250421013346.32530-1-john@groves.net>
 <20250421013346.32530-11-john@groves.net>
 <CAJnrk1aROUeJY2g8vHtTgVc=mb+1+7jhJE=B3R0qV_=o6jjNTA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1aROUeJY2g8vHtTgVc=mb+1+7jhJE=B3R0qV_=o6jjNTA@mail.gmail.com>

On 25/04/22 06:36PM, Joanne Koong wrote:
> On Sun, Apr 20, 2025 at 6:34 PM John Groves <John@groves.net> wrote:
> >
> > * FUSE_DAX_FMAP flag in INIT request/reply
> >
> > * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
> >   famfs-enabled connection
> >
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/fuse/fuse_i.h          | 3 +++
> >  fs/fuse/inode.c           | 5 +++++
> >  include/uapi/linux/fuse.h | 2 ++
> >  3 files changed, 10 insertions(+)
> >
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index e04d160fa995..b2c563b1a1c8 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -870,6 +870,9 @@ struct fuse_conn {
> >         /* Use io_uring for communication */
> >         unsigned int io_uring;
> >
> > +       /* dev_dax_iomap support for famfs */
> > +       unsigned int famfs_iomap:1;
> > +
> >         /** Maximum stack depth for passthrough backing files */
> >         int max_stack_depth;
> >
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index 29147657a99f..5c6947b12503 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -1392,6 +1392,9 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
> >                         }
> >                         if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
> >                                 fc->io_uring = 1;
> > +                       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> > +                                      flags & FUSE_DAX_FMAP)
> > +                               fc->famfs_iomap = 1;
> >                 } else {
> >                         ra_pages = fc->max_read / PAGE_SIZE;
> >                         fc->no_lock = 1;
> > @@ -1450,6 +1453,8 @@ void fuse_send_init(struct fuse_mount *fm)
> >                 flags |= FUSE_SUBMOUNTS;
> >         if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
> >                 flags |= FUSE_PASSTHROUGH;
> > +       if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > +               flags |= FUSE_DAX_FMAP;
> >
> >         /*
> >          * This is just an information flag for fuse server. No need to check
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index 5e0eb41d967e..f9e14180367a 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -435,6 +435,7 @@ struct fuse_file_lock {
> >   *                 of the request ID indicates resend requests
> >   * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
> >   * FUSE_OVER_IO_URING: Indicate that client supports io-uring
> > + * FUSE_DAX_FMAP: kernel supports dev_dax_iomap (aka famfs) fmaps
> >   */
> >  #define FUSE_ASYNC_READ                (1 << 0)
> >  #define FUSE_POSIX_LOCKS       (1 << 1)
> > @@ -482,6 +483,7 @@ struct fuse_file_lock {
> >  #define FUSE_DIRECT_IO_RELAX   FUSE_DIRECT_IO_ALLOW_MMAP
> >  #define FUSE_ALLOW_IDMAP       (1ULL << 40)
> >  #define FUSE_OVER_IO_URING     (1ULL << 41)
> > +#define FUSE_DAX_FMAP          (1ULL << 42)
> 
> There's also a protocol changelog at the top of this file that tracks
> any updates made to the uapi. We should probably also update that to
> include this?

Another good catch, thanks Joanne! Adding that in -next

John

