Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D460A168
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 00:12:16 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso4726844pjm.4
        for <nvdimm@lists.linux.dev>; Wed, 05 Jan 2022 16:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O5SiWExPLldaEfWo8lBT3rXCxgET/LcnPrCSIpHHBGY=;
        b=Bq3tbFj0hQ4W0bZUht09ZhxVqUleX9C8+RT6vooive/TZHMenBfn2h9ba5rAepK8JR
         u45P/p02Sl1548csvwm9DUxhoFiN9Z/NvtPVPQ2ndKB8LRHEKBy+d3+LSBdXNuUXGEJm
         SawqfZprxK+VpI5grQlefZ/TXCgpEusljjCTfd01AZLksR4hzneHwkFC+xdaU4gXkiak
         5kkrFu3di7XcwM+7rImHqHHggj5M2LaDQZJUq733NKbfxWv54vq6AGgrVKxKbiF1T5sD
         VodQG0B5NQwF1cbjRV/Vnk9nRRM349Q3VP0BMj2jzhrRf+3sfngswHWxe/v0q4Exl3yo
         lo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O5SiWExPLldaEfWo8lBT3rXCxgET/LcnPrCSIpHHBGY=;
        b=FcpwdE7mlEKD0P/RsSVNyhHmFmfsSPrll0VRXPTvlf03xmXU3cwLvmkgVRq0ppQ4tx
         i98ZLE8NtGt1Z8yZadFeJBVculirFYO3N5/alBpW+LvMl4HU3vIAk+dkSZlB18jWz9sy
         J3oa2wJPMB3ixG6x5F7V1onjeb6vcqEotg4Kcycjy6KxkZG4Nri7ANuJ53gkaMDKfH0O
         4/RI0nU7j7sqliJCSnA9VMhzsigJexS+xLh6IAbQculHwl8ux2x3wIR6qHmhyzxSvoMt
         KYUYW9F5hU8fVjE2sJwAup+wdqduZosi2JJ+ksU2vvmr87G1mjphHyO++L8EGgXD6ynv
         qjgA==
X-Gm-Message-State: AOAM531kwb/xfAdk5pde/WXbxArQKs/5pjDcjCE3vJFw65BQ3S7K19FF
	NSDyeHdgjiKvQYdSZ9fJfjSFmVDxLjSXTuZfvj5Oig==
X-Google-Smtp-Source: ABdhPJzy4aXmWdEyOp/zErYWN3Ia55r7xQeUNljZBrq2+3BZwPZ5oD55Al+wNqk/tcS+EUPIR/EaCp9SNGZdIGsCntE=
X-Received: by 2002:a17:902:8488:b0:149:8545:5172 with SMTP id
 c8-20020a170902848800b0014985455172mr42149927plo.132.1641427935261; Wed, 05
 Jan 2022 16:12:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211226143439.3985960-1-ruansy.fnst@fujitsu.com>
 <20211226143439.3985960-3-ruansy.fnst@fujitsu.com> <20220105181230.GC398655@magnolia>
 <CAPcyv4iTaneUgdBPnqcvLr4Y_nAxQp31ZdUNkSRPsQ=9CpMWHg@mail.gmail.com>
 <20220105185626.GE398655@magnolia> <CAPcyv4h3M9f1-C5e9kHTfPaRYR_zN4gzQWgR+ZyhNmG_SL-u+A@mail.gmail.com>
 <20220105224727.GG398655@magnolia> <CAPcyv4iZ88FPeZC1rt_bNdWHDZ5oh7ua31NuET2-oZ1UcMrH2Q@mail.gmail.com>
 <20220105235407.GN656707@magnolia>
In-Reply-To: <20220105235407.GN656707@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Jan 2022 16:12:04 -0800
Message-ID: <CAPcyv4gUmpDnGkhd+WdhcJVMP07u+CT8NXRjzcOTp5KF-5Yo5g@mail.gmail.com>
Subject: Re: [PATCH v9 02/10] dax: Introduce holder for dax_device
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, david <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 5, 2022 at 3:54 PM Darrick J. Wong <djwong@kernel.org> wrote:
[..]
> > Yes, I think we should just fail the holder registration and
> > DAX+reflink unless the FS being mounted on a whole device. I know Ted
> > and others had reservations about moving filesystems to be mounted on
> > dax-devices directly, but hopefully the whole-block_device requirement
> > is a workable middle ground?
>
> I think you have to be /very/ careful about that kind of statement --
>
> Take ext4 for example.  It has a lot of statically allocated ondisk
> metadata.  Someone could decide that it's a good idea to wire up a media
> failure notification so that we shut down the fs if (say) a giant hole
> opens up in the middle of the inode table.  However, registering any
> kind of media failure handler brings along this requirement for not
> having partitions.
>
> This means that if ext4 finds a filesystem on a partition on a pmem
> device and someone else has already registered a media failure handler,
> it will have to choose between foregoing media failure notifications or
> failing the mount outright.

...good example.

> Or you could support notification call chains...

We ended up with explicit callbacks after hch balked at a notifier
call-chain, but I think we're back to that now. The partition mistake
might be unfixable, but at least bdev_dax_pgoff() is dead. Notifier
call chains have their own locking so, Ruan, this still does not need
to touch dax_read_lock().
