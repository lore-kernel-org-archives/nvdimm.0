Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265B32F9A
	for <nvdimm@lists.linux.dev>; Thu, 29 Apr 2021 21:49:03 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id u21so102138677ejo.13
        for <nvdimm@lists.linux.dev>; Thu, 29 Apr 2021 14:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RFtRq0o7RuprUm0fy/T67jArYpo21Pztk91Azl3wjtg=;
        b=o/cixS4CRZbDd83SPuQAK5YD+6j6vn3+ZYtnu796vMPM6nom+Z1jgBXU4vyshs+v3f
         bDjNTCv01xfBDTyicwEtiODcRTWLY31i4RgME9kkxdGatHmND3jM21krUgJb78tqSdQs
         k2jTufyxLr7TxuvRfTEb9DVFx80f0EFkh7cZHFSWa2Dyc4M2JmT4m2ht72MhLtPDqdOJ
         HNy3RTIwTT8fEiBVrgz7XzpKdHsRWWroGMsvR7Wx1d+NjK0B1bBWQ4rNIHuIq5WPFxLF
         8XokTE/X6+yjnHYscZtoLGF1i2Du976C8nBBmdR43TMm7ZF8p9Qoq+m69mHnPgSuOYSG
         Avig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RFtRq0o7RuprUm0fy/T67jArYpo21Pztk91Azl3wjtg=;
        b=BVHqDx2hjwoWE3zm52OCEPC0v69JXvq7CxWQ4keUosvYsLxtUdhjl6DJDnyKJQc2hb
         kEpaG14MfEUW0Q+1dzelDd3lmbfqeHkFZKdtx87dJPQdjN1L9MwEtlkc7iztqXz9fMo4
         4SRWzZNFd+7tXWsGtCsYrx2Z2COYmRFizNE/NIRrV3vmoJQbBJ7cdFLjOWPTUy6wDptj
         GEbf5VQHLckChiIAPhaJxBrD/IoNlxs0quJzbj4xnP71d4ELq08sgBc4Pe+TeyGg3W3e
         IhgslUaII+XThWS9xcVNnU58PQadFtqE5K3LlLwUUROiSizXvwExYAtGNmkAkWKE/+GE
         vZhQ==
X-Gm-Message-State: AOAM533S8zuD/GCD5jtKtciGSTOwSV4g6sH8OUwloBVEr9lns7ohigJy
	fV+ejYAXs8lBJUx3lFcg7mZFxegoHkepmCgJmFyvlQ==
X-Google-Smtp-Source: ABdhPJyQyU2O0jYpRlsyCFt2+GwglBHD3jjZ9N0ybhOUD/OLmiDsbhRN5TleXQ8e/c27SblrD1RT9jPTyfcx7blZeA8=
X-Received: by 2002:a17:906:18e1:: with SMTP id e1mr589642ejf.341.1619732941590;
 Thu, 29 Apr 2021 14:49:01 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <161898872871.3406469.4054282559340528393.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87sg3bd8iv.fsf@meer.lwn.net>
In-Reply-To: <87sg3bd8iv.fsf@meer.lwn.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Apr 2021 14:49:00 -0700
Message-ID: <CAPcyv4iDhrueShBUYMNAtUwMBmxtfrqOFjzoQ7KpN4aTTWrVpg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Move nvdimm mailing list
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Ira Weiny <ira.weiny@intel.com>, 
	"Oliver O'Halloran" <oohall@gmail.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 27, 2021 at 8:58 AM Jonathan Corbet <corbet@lwn.net> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > After seeing some users have subscription management trouble, more spam
> > than other Linux development lists, and considering some of the benefits
> > of kernel.org hosted lists, nvdimm and persistent memory development is
> > moving to nvdimm@lists.linux.dev.
> >
> > The old list will remain up until v5.14-rc1 and shutdown thereafter.
> >
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Cc: Oliver O'Halloran <oohall@gmail.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  Documentation/ABI/obsolete/sysfs-class-dax    |    2 +
> >  Documentation/ABI/removed/sysfs-bus-nfit      |    2 +
> >  Documentation/ABI/testing/sysfs-bus-nfit      |   40 +++++++++++++------------
> >  Documentation/ABI/testing/sysfs-bus-papr-pmem |    4 +--
> >  Documentation/driver-api/nvdimm/nvdimm.rst    |    2 +
> >  MAINTAINERS                                   |   14 ++++-----
> >  6 files changed, 32 insertions(+), 32 deletions(-)
>
> Would you like me to take this through docs-next, or did you have
> another path in mind?

Thanks for the offer, I have a few other nvdimm related bits for this
cycle, so it can go through nvdimm.git.
