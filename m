Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B80B72
	for <nvdimm@lists.linux.dev>; Wed, 27 Oct 2021 23:37:13 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id k26so4216030pfi.5
        for <nvdimm@lists.linux.dev>; Wed, 27 Oct 2021 16:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WMTMh4JidQFbMhcZT2VkZGNAi1C8CcA8jtm6BrftSss=;
        b=6OnySiysF1hhuv+2jxJ9FfAfSmA8y9LXelAKat7WynBZQg+6PZ/Y6CL3zM18cMG3JD
         GEnUquiuE3quJvpTuotuNPBGhT162UmD7avG0jDOAcziSvLYUVDywCngB4p3fQ58ZM0M
         zEqOMtq2uc82z3Hyo8SHcJ4wrgy4SICUQMJg3EUzEQ97cTDTxpAJL+ZjXMrC9Pd6Yd4I
         Hv+o6S8B5+bjhFZmSyXmvoK3vkD+a/tR7V2R1bzY3az6V1C7tt1S3O/yFi5MScIMNOJo
         whD2gxewZ5pTPcAORmeXbNAMaeToO/lIBwIX5Bv5eefUsLjTlEzVx3onl1Zq5iL+vzm0
         cGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WMTMh4JidQFbMhcZT2VkZGNAi1C8CcA8jtm6BrftSss=;
        b=QRpDCo+rhOsEIffqmfwY0XHDz3eUdTIdFwh79wBvCV6ZEB5G1Fi1Gj4nt2PNedgnJ7
         tTysRhItuEvVeQgvtIfNiogjcOoFVUzUfJK23Pw4p5aUr+tGYeAt1JhTdHiaGG3ZRw8T
         fE6CoMIfFFp0rqk5RYCBBKWfFW/nxgEcKD1lKOjo7ackEJ8V+9pNjEdQyvKel7P+kaBU
         CbT4YEklOnl1az1h9/6ZUUYPfIY4ADu7fZLMW2AHmDsBDCddsqw5UGG2SvIK4IRplzM7
         Tja1OtSjafgRL5RkP8oCmqnSAZdgl2PoMgzm1uklg6cB8jgMODibvcavnkhjyf0+8HWd
         Q5XA==
X-Gm-Message-State: AOAM530SkYzIZw+1E09ur4PFqxIOM0TYPMCDRlh2XuhxS7UYDVwPhWTP
	kEoUrRzqFOVMlrBrLAut56K+TJ9mNDVfkyPe6r9+MQ==
X-Google-Smtp-Source: ABdhPJxcsU50q4uGsTOaoj9w67NPN0ee0O0WC5tw2bEynUFc2bhlW22w0QMQKH9wvcSAfLnnolzJDk1LCiKsNt9RVYY=
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr608862pge.5.1635377832818;
 Wed, 27 Oct 2021 16:37:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <20211018044054.1779424-7-hch@lst.de>
 <20211018164351.GT24307@magnolia> <20211019072326.GA23171@lst.de>
In-Reply-To: <20211019072326.GA23171@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 16:37:01 -0700
Message-ID: <CAPcyv4hbLur8rN40zaqmBw7VH37FoPAzvj-U_NT7Lk2-v5JhSQ@mail.gmail.com>
Subject: Re: [PATCH 06/11] xfs: factor out a xfs_setup_dax helper
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Mike Snitzer <snitzer@redhat.com>, 
	Ira Weiny <ira.weiny@intel.com>, device-mapper development <dm-devel@redhat.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-erofs@lists.ozlabs.org, linux-ext4 <linux-ext4@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 19, 2021 at 12:24 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Oct 18, 2021 at 09:43:51AM -0700, Darrick J. Wong wrote:
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -339,6 +339,32 @@ xfs_buftarg_is_dax(
> > >                     bdev_nr_sectors(bt->bt_bdev));
> > >  }
> > >
> > > +static int
> > > +xfs_setup_dax(
> >
> > /me wonders if this should be named xfs_setup_dax_always, since this
> > doesn't handle the dax=inode mode?
>
> Sure, why not.

I went ahead and made that change locally.

>
> > The only reason I bring that up is that Eric reminded me a while ago
> > that we don't actually print any kind of EXPERIMENTAL warning for the
> > auto-detection behavior.
>
> Yes, I actually noticed that as well when preparing this series.

The rest looks good to me.
