Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D5915B4
	for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 04:21:08 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id a11so949269pff.1
        for <nvdimm@lists.linux.dev>; Tue, 10 May 2022 21:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jl1GZmm7QuKAbToF+dPGx7IgxaH6ShvhQAX01HB3wCc=;
        b=ltUc6hKbTACE4zlFPJKf6Z+hO3WQcTTeuwKVHECbtUXdc3XEatIzd0n7tiO638vGBN
         d/gZVhxS756AE2mPE3v7qYCixusH6wSltbX2Thocw8XnHb21P3uuEQBLfUeJnIrOH4Eb
         u58jlZJltai+LVOH5tktxfMFkiDVx3LdYDF539tWHb2I/zqOJOpnW3wOvkCZGgcpn+Sw
         MGS3qyclt4YGl06g+pdoTt82yqLPYimOr49UnkrgN4o98xHzmXwhJL/1vydGGNGYpLjh
         eh/n2GFpyXsYuS+ZkiPitXl6gdr0JSVEkfwkCEd0sbz377Yo6JrzXqqW4AOxftLzp6Tm
         I2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jl1GZmm7QuKAbToF+dPGx7IgxaH6ShvhQAX01HB3wCc=;
        b=aJCOq0pyhRX7f6EKTreuXxH6ZuhBvCqGJHdnlabA3liXRTy8TyoPbv/UG5uKKwBH6r
         kHKnLbMeESSwOGjVf93J7ZrV0nHHkbw1GP9lz7iX1aLiYJF7RiHP+lPuphYmyEzHKhvN
         9IF36DVDw8rGVUOsntgSCkiLPdexktsjfpM9xH6KYuXeWw6Qgl/mK9ZCSBZ8wdyTWkJW
         uD6LoWSN8kn/KpDxRX1K+Bk4K+mj1qPKZF50ICUntkDhDxYucxdr5UCR7e+UIXpd0wRG
         WkLWb+CiVRqZY2Ea+7TnP612Sy8cb4zR5R25bsft1bC2JL6Deo+kUcnNfpzOu3gpLnPX
         2CDw==
X-Gm-Message-State: AOAM533wmDKLZ3JOUQEUsaK5xZV4xrnYK3gYyxBHrYR4ytpIMJ8hSYui
	mNl7DuXoDfkq2flDcLz/ABW22lmZ5KXYe/c7sCzGnA==
X-Google-Smtp-Source: ABdhPJw956CGNInPJoX0Sue0mYEmFyYdP4GE5ILyG00rRUkMD+8mKrIiV5I/p/QBznNriBkyTAqhRy7FXF8Omnk+4mA=
X-Received: by 2002:a05:6a00:22d4:b0:510:6d75:e3da with SMTP id
 f20-20020a056a0022d400b005106d75e3damr23699430pfj.3.1652242868060; Tue, 10
 May 2022 21:21:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220511000352.GY27195@magnolia> <20220511014818.GE1098723@dread.disaster.area>
 <CAPcyv4h0a3aT3XH9qCBW3nbT4K3EwQvBSD_oX5W=55_x24-wFA@mail.gmail.com> <20220510192853.410ea7587f04694038cd01de@linux-foundation.org>
In-Reply-To: <20220510192853.410ea7587f04694038cd01de@linux-foundation.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 May 2022 21:20:57 -0700
Message-ID: <CAPcyv4ip6N6jvdb3LRjPnVr6xaFjiVg1OCE95pu9RiMG5_VNPw@mail.gmail.com>
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Jane Chu <jane.chu@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>, 
	Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	Naoya Horiguchi <naoya.horiguchi@nec.com>, linmiaohe@huawei.com
Content-Type: text/plain; charset="UTF-8"

On Tue, May 10, 2022 at 7:29 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 10 May 2022 18:55:50 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
>
> > > It'll need to be a stable branch somewhere, but I don't think it
> > > really matters where al long as it's merged into the xfs for-next
> > > tree so it gets filesystem test coverage...
> >
> > So how about let the notify_failure() bits go through -mm this cycle,
> > if Andrew will have it, and then the reflnk work has a clean v5.19-rc1
> > baseline to build from?
>
> What are we referring to here?  I think a minimal thing would be the
> memremap.h and memory-failure.c changes from
> https://lkml.kernel.org/r/20220508143620.1775214-4-ruansy.fnst@fujitsu.com ?

Latest is here:
https://lore.kernel.org/all/20220508143620.1775214-1-ruansy.fnst@fujitsu.com/

> Sure, I can scoot that into 5.19-rc1 if you think that's best.  It
> would probably be straining things to slip it into 5.19.

Hmm, if it's straining things and XFS will also target v5.20 I think
the best course for all involved is just wait. Let some of the current
conflicts in -mm land in v5.19 and then I can merge the DAX baseline
and publish a stable branch for XFS and BTRFS to build upon for v5.20.

> The use of EOPNOTSUPP is a bit suspect, btw.  It *sounds* like the
> right thing, but it's a networking errno.  I suppose livable with if it
> never escapes the kernel, but if it can get back to userspace then a
> user would be justified in wondering how the heck a filesystem
> operation generated a networking errno?
