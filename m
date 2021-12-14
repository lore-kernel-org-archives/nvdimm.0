Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA57A68
	for <nvdimm@lists.linux.dev>; Tue, 14 Dec 2021 16:41:39 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id u11so13952939plf.3
        for <nvdimm@lists.linux.dev>; Tue, 14 Dec 2021 08:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t/nnzQN9F5r4zFSkk8iYiBeWCGCkT6Dn6wCuQkQZ9ZI=;
        b=dZAHZODGRVbZR2ysy2aU8tziv8EUSVJ4G7lyxIrGTVAuZTAI+h8NEwG8q7Ti0dmlRz
         FUs67aDUBnh6oEQuwW9klnzG6whuDB0WHzvC+u6KewQCpZ3qzZkQxOjXcIwIOakbw+W8
         0IPx5KqHgVMSuYrfYVo/3t/drPQ+jE/inPZaZAe65sMgMfC0QFbD7dio6ED/HtOLm8GC
         OtyfjDtD51vI1WL0SiPHAHoYFrmLR9/1Ewk0VndBGOMrtBOrC2Xs+YWkZlTmM1nQ+fwf
         xp9G/2UCykZKzSIljzl9L8OafZyAgDu+6bByD3Jg+aWM9iQLLGlyuMF0JKsj5Ok6ufkJ
         np+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t/nnzQN9F5r4zFSkk8iYiBeWCGCkT6Dn6wCuQkQZ9ZI=;
        b=WiFrm58CNtxsXC+f3Hrlp8zHcIVvyxZtGlqzFVJbJCRupA9fdfIDhaUbubTUKdQz1L
         ICahyTQHTYjenKX1LGL3MA/r/nqzlMBAJsccwfksv5kVbUQ4mouNQQIHduXtAyRY/pE3
         qhD6pHYBbkBrf/+e9Qr20/MkTOX0bXHiEfmGYL5Ed3zjnNbm9yo7hkxu3M0TB4mjAIla
         0OACa1MoAFTO1jhBdtW0MUasj2D3OY2UlCOp0ewJHa/Nh8Db/MvJeMk4F3/CJ9T52Rx6
         tAfybNYHiuNKWfiubZrQiE1vY+7s6mzzm8exRqLFgYwRvnOrWJnYLik978OULGJMy6Zz
         TVDg==
X-Gm-Message-State: AOAM531SJQlh8mizjR5cnclJZiwwMOxmr3wdegsG3z7Ox5dHa6Gk0uzn
	Ed9sfSWjL8EGw9iBxYOq5Mlk+UET2qXVjOOa0/oZwQ==
X-Google-Smtp-Source: ABdhPJw+O9j0H9UWQxoVKDQYePJLlAtoMN+dCn3S6Q/xMAfRBDp6O2XP6nSywAkX3lUHqDKzBphvkGiQvj7Lgmg0w8E=
X-Received: by 2002:a17:902:bb87:b0:148:a2e7:fb52 with SMTP id
 m7-20020a170902bb8700b00148a2e7fb52mr124861pls.147.1639500099392; Tue, 14 Dec
 2021 08:41:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-5-hch@lst.de>
 <YbNhPXBg7G/ridkV@redhat.com> <CAPcyv4g4_yFqDeS+pnAZOxcB=Ua+iArK5mqn0iMG4PX6oL=F_A@mail.gmail.com>
 <20211213082318.GB21462@lst.de> <YbiosqZoG8e6rDkj@redhat.com>
In-Reply-To: <YbiosqZoG8e6rDkj@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Dec 2021 08:41:30 -0800
Message-ID: <CAPcyv4hFjKsPrPTB4NtLHiY8gyaELz9+45N1OFj3hz+uJ=9JnA@mail.gmail.com>
Subject: Re: [PATCH 4/5] dax: remove the copy_from_iter and copy_to_iter methods
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	Ira Weiny <ira.weiny@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 14, 2021 at 6:23 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Dec 13, 2021 at 09:23:18AM +0100, Christoph Hellwig wrote:
> > On Sun, Dec 12, 2021 at 06:44:26AM -0800, Dan Williams wrote:
> > > On Fri, Dec 10, 2021 at 6:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > Going forward, I am wondering should virtiofs use flushcache version as
> > > > well. What if host filesystem is using DAX and mapping persistent memory
> > > > pfn directly into qemu address space. I have never tested that.
> > > >
> > > > Right now we are relying on applications to do fsync/msync on virtiofs
> > > > for data persistence.
> > >
> > > This sounds like it would need coordination with a paravirtualized
> > > driver that can indicate whether the host side is pmem or not, like
> > > the virtio_pmem driver. However, if the guest sends any fsync/msync
> > > you would still need to go explicitly cache flush any dirty page
> > > because you can't necessarily trust that the guest did that already.
> >
> > Do we?  The application can't really know what backend it is on, so
> > it sounds like the current virtiofs implementation doesn't really, does it?
>
> Agreed that application does not know what backend it is on. So virtiofs
> just offers regular posix API where applications have to do fsync/msync
> for data persistence. No support for mmap(MAP_SYNC). We don't offer persistent
> memory programming model on virtiofs. That's not the expectation. DAX
> is used only to bypass guest page cache.
>
> With this assumption, I think we might not have to use flushcache version
> at all even if shared filesystem is on persistent memory on host.
>
> - We mmap() host files into qemu address space. So any dax store in virtiofs
>   should make corresponding pages dirty in page cache on host and when
>   and fsync()/msync() comes later, it should flush all the data to PMEM.
>
> - In case of file extending writes, virtiofs falls back to regular
>   FUSE_WRITE path (and not use DAX), and in that case host pmem driver
>   should make sure writes are flushed to pmem immediately.
>
> Are there any other path I am missing. If not, looks like we might not
> have to use flushcache version in virtiofs at all as long as we are not
> offering guest applications user space flushes and MAP_SYNC support.
>
> We still might have to use machine check safe variant though as loads
> might generate synchronous machine check. What's not clear to me is
> that if this MC safe variant should be used only in case of PMEM or
> should it be used in case of non-PMEM as well.

It should be used on any memory address that can throw exception on
load, which is any physical address, in paths that can tolerate
memcpy() returning an error code, most I/O paths, and can tolerate
slower copy performance on older platforms that do not support MC
recovery with fast string operations, to date that's only PMEM users.
