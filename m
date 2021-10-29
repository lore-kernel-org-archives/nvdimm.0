Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B8072
	for <nvdimm@lists.linux.dev>; Fri, 29 Oct 2021 16:16:47 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id x33-20020a17090a6c2400b001a63ef25836so1398353pjj.3
        for <nvdimm@lists.linux.dev>; Fri, 29 Oct 2021 09:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UuiRv/Aqc9KWf66Wmwy2yVHjihLskj+s11srG8q1vD8=;
        b=DDH8LvTf1NbwlDisv+efQao95HUsWm01LKrhjJ2uX5etHAjxnlYc1fVorsh9C2tZeZ
         IZjJyefUE9sV7SNEI3aifqWin72xUpU2BtMndIJi3ywQQBX2XMdIqeYY8510szP8t2sH
         kdBhiAG5maV3WHr8hudaPmgocYD17sC0B0D26/b8Pbwzr3F117FlSlFBx3SQdqHiOhCS
         AzK0mVaRm+n9lGW4xPZYMjIFamXjTmcm5QI7QOVxfQm9omv4teemj/fppXRavbXh1qYb
         2mUwDH8Lkp2dgVW/pz350uqfUJeZ+MOAK0wy10AUYRh1hsJJ2oVH6yHtRzop5uS3RMQt
         86wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UuiRv/Aqc9KWf66Wmwy2yVHjihLskj+s11srG8q1vD8=;
        b=EbgPaZ4ONU4CNquSK5V+3Howoo6FRVYSkF5z89S0BsLfJwfn/lumWRahQ60s3byRey
         MlaS6jB+q9e2GPkuAFAJnXRLKUuXfcVzoSqoQ6Kbo1POK9HYVH702aqILYiPIBpKanAd
         JtBGCqFIP60afeXYKuev47b10iiLuPaMBwUyc+1C4+5FZKylbe1hvfzML3AB7pw7F2M1
         v8jtGRkh9G5uLKBwVFOLxtZHtCPj/gFBi3OfZsKunZQ1bkOhV9zX/rnjLUK6kg7KiDNN
         QMahOn1zmd1rLX+swqImu3PdXJLpSnlZlEwWnjQH8546Du65eHRnM2epvKkLxIfMvmps
         O8rQ==
X-Gm-Message-State: AOAM531ZQ/BNnYleg2fV8PrcylJ6nhk4plkmIfdEiXcT4EyB5eZZzvhG
	7Cm1gmJbwmpckAYIuLWaFBj0N6t11eC6lrEOJb9v9w==
X-Google-Smtp-Source: ABdhPJy6oDDE8Tua+O/7LJsaoOuN022Twl1T27YRaF2rK5Jgwv2I/UmljReJn3ItDXvNR8dsDNU53ltbLhzG+bw6RwY=
X-Received: by 2002:a17:90b:350f:: with SMTP id ls15mr12425415pjb.220.1635524207375;
 Fri, 29 Oct 2021 09:16:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <CAPcyv4iEt78-XSsKjTWcpy71zaduXyyigTro6f3fmRqqFOG98Q@mail.gmail.com>
 <20211029105139.1194bb7f@canb.auug.org.au> <CAPcyv4g8iEyN5UN1w1xBqQDYSb3HCh7_smsmjt-PiHORRK+X9Q@mail.gmail.com>
 <20211029155524.GE24307@magnolia>
In-Reply-To: <20211029155524.GE24307@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Oct 2021 09:16:35 -0700
Message-ID: <CAPcyv4hL7ox5a7L7pBs-uoj_h+9F7E_nBs-qnJKBbJ7PHpWAjw@mail.gmail.com>
Subject: Re: futher decouple DAX from block devices
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Christoph Hellwig <hch@lst.de>, 
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, Mike Snitzer <snitzer@redhat.com>, 
	Ira Weiny <ira.weiny@intel.com>, device-mapper development <dm-devel@redhat.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-erofs@lists.ozlabs.org, linux-ext4 <linux-ext4@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 29, 2021 at 8:55 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Oct 29, 2021 at 08:42:29AM -0700, Dan Williams wrote:
> > On Thu, Oct 28, 2021 at 4:52 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Hi Dan,
> > >
> > > On Wed, 27 Oct 2021 13:46:31 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
> > > >
> > > > My merge resolution is here [1]. Christoph, please have a look. The
> > > > rebase and the merge result are both passing my test and I'm now going
> > > > to review the individual patches. However, while I do that and collect
> > > > acks from DM and EROFS folks, I want to give Stephen a heads up that
> > > > this is coming. Primarily I want to see if someone sees a better
> > > > strategy to merge this, please let me know, but if not I plan to walk
> > > > Stephen and Linus through the resolution.
> > >
> > > It doesn't look to bad to me (however it is a bit late in the cycle :-(
> > > ).  Once you are happy, just put it in your tree (some of the conflicts
> > > are against the current -rc3 based version of your tree anyway) and I
> > > will cope with it on Monday.
> >
> > Christoph, Darrick, Shiyang,
> >
> > I'm losing my nerve to try to jam this into v5.16 this late in the
> > cycle.
>
> Always a solid choice to hold off for a little more testing and a little
> less anxiety. :)
>
> I don't usually accept new code patches for iomap after rc4 anyway.
>
> > I do want to get dax+reflink squared away as soon as possible,
> > but that looks like something that needs to build on top of a
> > v5.16-rc1 at this point. If Linus does a -rc8 then maybe it would have
> > enough soak time, but otherwise I want to take the time to collect the
> > acks and queue up some more follow-on cleanups to prepare for
> > block-less-dax.
>
> I think that hwpoison-calls-xfs-rmap patchset is a prerequisite for
> dax+reflink anyway, right?  /me had concluded both were 5.17 things.

Ok, cool, sounds like a plan.
