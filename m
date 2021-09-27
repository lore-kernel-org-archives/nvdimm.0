Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368873FD6
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 23:14:57 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id s16so17361202pfk.0
        for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 16:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yklOyy30D62v19t7f4DS6gYqmLXHdu1oIrAz/DF1m/E=;
        b=XVqqMZgvRWXvCBguR3iF0XZYGmEtnzuU1gy3Bk6lAxYOi62v5AeKqLXlXcuoNvsmEw
         R9Nw+iLqx4vjMiLegeWJ4LjHGKsYELG1zVTBrCPcLegOEax4P4zLoeOgVZSfEbIiNUSd
         YvGF7oyZ+6ke/vXqL1XCccaBFoPK61QSFC9tz3b8WcbJCgHXOsPmQW2JvDVGl3lFVMkl
         LwfcxW/buLUOe/v1UZAjeoETg0fkL3VYkPeVWF5VRjRgB5wDRHWUfk5yArp+rr0svYtu
         BwI7DFXP5PBnIUwuxDGWtQSGzbAOpXR1gqOx1OAXlPCDBUu5GgtaWq53sNmEk2d1nO8O
         i/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yklOyy30D62v19t7f4DS6gYqmLXHdu1oIrAz/DF1m/E=;
        b=VdIPmR0RdUI9SrGWHeou7+U3WP0sFFC1+wzUXwqTs0cq0DLAp94hk25My9ZbMzCUtW
         glB6ShgtClylPQCelISEHbWYyL3JcQz0c/Evtf+2L89WZoAb5Q2/7kl1O4Yf2ppNcjVR
         753JkYcsUYAdO8Y4un0mVCWKHVen496K5uyJFT714RAZV3MNntNqzYf0xJBHfk1KlJj3
         v45RxVS4qDaMGqcg7l1j8aedIHzz788brdULpUTliBfgz6VWIoSjCG87YI/0ktVa9NMU
         1jy0vZPvh6qFQbAmpR3hlhG7dxSgUeqDvHLn1+lPcsbkNw8RBIMkOXhPB4nalNkth9PE
         /VDQ==
X-Gm-Message-State: AOAM530crCbUhAA6iohiPGpEfyhtdlDBMjyESTFVmCgCas8aLI3xfz3j
	nJGpWN0/6yuim08W8rfJMFXH3jXtRnmksVp5YVLpIw==
X-Google-Smtp-Source: ABdhPJyhWl093lPVzlkES7mn7oFLNORaprmrPwbT9BKAFkKYfowUUrVexS8J6403Wp6pLWvkiOpFd35mu7KrR5i7c2Q=
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id
 b140-20020a621b92000000b003eb3f920724mr2189120pfb.3.1632784496737; Mon, 27
 Sep 2021 16:14:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210927061747.rijhtovxafsot32z@xzhoux.usersys.redhat.com>
 <20210927115116.GB23909@lst.de> <20210927230259.GA2706839@magnolia>
In-Reply-To: <20210927230259.GA2706839@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Sep 2021 16:14:48 -0700
Message-ID: <CAPcyv4j1jSSQNBw991_PPu72Q3he=ctYpaLTSh3AjbJ5nA3UVQ@mail.gmail.com>
Subject: Re: [regression] fs dax xfstests panic
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Murphy Zhou <jencce.kernel@gmail.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 27, 2021 at 4:03 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Mon, Sep 27, 2021 at 01:51:16PM +0200, Christoph Hellwig wrote:
> > On Mon, Sep 27, 2021 at 02:17:47PM +0800, Murphy Zhou wrote:
> > > Hi folks,
> > >
> > > Since this commit:
> > >
> > > commit edb0872f44ec9976ea6d052cb4b93cd2d23ac2ba
> > > Author: Christoph Hellwig <hch@lst.de>
> > > Date:   Mon Aug 9 16:17:43 2021 +0200
> > >
> > >     block: move the bdi from the request_queue to the gendisk
> > >
> > >
> > > Looping xfstests generic/108 or xfs/279 on mountpoints with fsdax
> > > enabled can lead to panic like this:
> >
> > Does this still happen with this series:
> >
> > https://lore.kernel.org/linux-block/20210922172222.2453343-1-hch@lst.de/T/#m8dc646a4dfc40f443227da6bb1c77d9daec524db
> >
> > ?
>
> My test machinse all hit this when writeback throttling is enabled, so
>
> Tested-by: Darrick J. Wong <djwong@kernel.org>

Thanks Darrick, I've added that.
