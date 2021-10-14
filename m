Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1582C80
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 17:50:10 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id np13so5295383pjb.4
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 10:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxMwCOQC0YdnJMfBTtrw73j7Po2etBW+G2sHBxcCjWs=;
        b=QH7GRT/SpH58c1RQtll53kBjddBVU5mBBMjaxMqXnQinf9VD8Ze+ZD8FeNmWLnaMT0
         fv3H2osimP7Qx0VswZonCrDR/2P8RrcydFhjeLKXIYdy3p1wEcucuPhWqaxP+9UeIeox
         Gtj8T1YHBs3opq6wwUf6rGPirXifVhSb7LlUrqbJMWL/KKHC8Thxf+Wx85GeGSXQvJEf
         3HZwoHL1ukOewHHxeOBK4vHLq9Fa/zUKhcYzWcXvI0OBFWuTH9ziJotoxd4c0UXKRgID
         K85bacTjtWuW7q6fYQq1UidUyEzUkgLv3Pzvn89ptmogeucqI5Bqxh+hVO4iX8vgV2F8
         SK7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxMwCOQC0YdnJMfBTtrw73j7Po2etBW+G2sHBxcCjWs=;
        b=W/JhARVTOX2QuYphEHvgMAkWoQDKLbXS8P7DZo7eDNPVFBT+X8lXarlnsf7bDRBIyf
         kIG4OiTmEhrEGpoVZWM3LdU9J6Z/VwoKOyEho+eHgCRFnIx62HXZ0yE/br5E2hN4uq57
         XBi4T+rMcat6KA2NUIPNCqchY1/HRZ2PzODN3MlwdtZbdnY+PyZP7u93NFMXcGBK8aMj
         SzdtR0HnuAW+ULnYenxce7oUrtd6PP2EVD57XNA7UE3KMMblMTad+06mHxlSDuHzkhZy
         /E4w+Mmb5Z32TmZ5vTJ5kDE4F9bqlAfDv5lTOwBUBH2/fLMZwRt6o9hoEAUjL1iW+y8O
         DkDg==
X-Gm-Message-State: AOAM530iJxEIZtKAOr/WD2bsJ3U7JoJTMR464WNbZytbd3OyLbz00473
	d/YhBtLZFho/sDlklyvw5Qm6RE7ICTf9cWuHt/moVg==
X-Google-Smtp-Source: ABdhPJxR85BHTUgh2B9uDC+TU+JJ1acvNOU62PyXU7qBjG5Frdg+JsyNyE07dZVp+4pMhLw33L5iuz3apaa8nesG34E=
X-Received: by 2002:a17:902:8a97:b0:13e:6e77:af59 with SMTP id
 p23-20020a1709028a9700b0013e6e77af59mr6249033plo.4.1634233810499; Thu, 14 Oct
 2021 10:50:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210928062311.4012070-1-ruansy.fnst@fujitsu.com>
 <20210928062311.4012070-8-ruansy.fnst@fujitsu.com> <20211014170622.GB24333@magnolia>
In-Reply-To: <20211014170622.GB24333@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 10:50:00 -0700
Message-ID: <CAPcyv4gGxpHBBjB8e23WEQyVfo4R=vT=1syrJXx1tWymCDV51w@mail.gmail.com>
Subject: Re: [PATCH v10 7/8] xfs: support CoW in fsdax mode
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, Christoph Hellwig <hch@lst.de>, 
	linux-xfs <linux-xfs@vger.kernel.org>, david <david@fromorbit.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 14, 2021 at 10:38 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Tue, Sep 28, 2021 at 02:23:10PM +0800, Shiyang Ruan wrote:
> > In fsdax mode, WRITE and ZERO on a shared extent need CoW performed.
> > After that, new allocated extents needs to be remapped to the file.
> > So, add a CoW identification in ->iomap_begin(), and implement
> > ->iomap_end() to do the remapping work.
> >
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>
> I think this patch looks good, so:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> A big thank you to Shiyang for persisting in getting this series
> finished! :)
>
> Judging from the conversation Christoph and I had the last time this
> patchset was submitted, I gather the last big remaining issue is the use
> of page->mapping for hw poison.  So I'll go take a look at "fsdax:
> introduce FS query interface to support reflink" now.

The other blocker was enabling mounting dax filesystems on a
dax-device rather than a block device. I'm actively refactoring the
nvdimm subsystem side of that equation, but could use help with the
conversion of the xfs mount path. Christoph, might you have that in
your queue?
