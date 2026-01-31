Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ABA28AAEB
	for <nvdimm@lists.linux.dev>; Sat, 31 Jan 2026 01:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769822325; cv=pass; b=izBfY2JNTFrfyZMiFPN5G0I60uXIn0a8R8xZrzZnoWsOvONQEEdOI8mDCqWoDaqM+qpyjyKWlCrgFkeXbtFCs4AQ2gVasjGqfBZzVglKTBCp2jKyK4mLhYohWoTW3lnfx+O9I6fn1CCJlT4u/6noiFl6Slz1XmwSGWYIUlNWmEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769822325; c=relaxed/simple;
	bh=NJyyW3LrV2W0dVysafPoC2cjKhBb+MYi76erl20GHWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ipz+ZOO2vh43FAW4iz2EE8w348y78OYAvkzsY/DO3Kwg13WFMiihw70Ob4zSVNmeuHjPjFwwSQxzWVQ4pVsqMqdGmNXgKixLydSa8+/IYc2beOt4F260yp7cpveiixgW83gt1v5t6eN11BOLyWgVnr/JeXbq7269Sg6rd5JCsRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kc6cThjq; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kc6cThjq"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a2fe9e200so26045226d6.0
        for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 17:18:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769822323; cv=none;
        d=google.com; s=arc-20240605;
        b=XTh1ol5GrH/cHZoKqZag15gmplxpfjV2JE/rzgGtEvdy3KKlWVklCgp8OUwl2sFfjI
         BmHaZmxlTbHpiAoHBMEN8PcJJmUiuFrgkZP2e3r5vhebluQ7PxeXYiY9LiyZPAz+ObjU
         4P7bmyMRyxUzsLMKurRLQppQk2VWmyKbYyC6Dx348e5zs8WegI9eL9krG6lO2iNxRsZq
         FGjVRzWZp+AzO3SK84enHR6AzSzOuvTNkY8iMS7vGfz1D0jdmG/dCX8XBkVrv1BRj1kn
         LiSe8vo37elQTGxYhXCOMzk30MPe2V5XGRsBvib5sczcxbpI9j2PAmDTxQufEjsK6V7i
         OsDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C9hrsBRNghnIovdQhJmal8FXOCZu37oJsf0hDL/41Z4=;
        fh=xzzA2lpvC2RZqtOHh13KWwHBEIwZvORaTI6hDyPp9nM=;
        b=PMT3XxkxdC6FATASi3hh4z609Pg17Ye28tk6T4jd1WMQaMKVxXzy/59RCROujsZ/HS
         oQcme+Xpj6owy8l+mncHnNB2kncLOBSaEzeRPG3A/xIqPEW963ma2EGkxonRzo1m+OEy
         Cm8kLyL2+Z/HnfDGRtmrqUHRv/Sed2QPE7NkCIwilcolYR7C9vAlX2gzB4vPmcL6DWeZ
         KvkpUxW3mxxJ1RM0Mu+m84eOfC9e4ET4fB1fJ+vRJE/nWmcFEUqLoEPq9xuQoZdICZJZ
         /hUvPsLX1I/PA5aQQASZZhawIj+IfhGOOIi23ICm0PSqAQdcY1Tl4yA+qmEw9j8yE2in
         mPrg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769822323; x=1770427123; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9hrsBRNghnIovdQhJmal8FXOCZu37oJsf0hDL/41Z4=;
        b=Kc6cThjqkSupUpC0YvZdE8gfRQlahV+TFGaEbQDroNOkUYj7CZlC9uC/zzCTg6A7Iq
         sechw+7zhQbIoRVARRWbZkRMUV18jzHdg8p7F7KJOhrVRmGGO2CqAj0t8KVw9BP12F4D
         XcKW6Z62DsN9M5VSmjVV/j095y9gvkcrjqofhVqYrVl4tbWGUNiNDsuowZqkwRX60Ebv
         GAvk7RWc/43GMlF+NKtJGULauI/pEW+ZD+ypGx8sDGZ/1KFrO/qhFsUw6B4ZRn38Dq5g
         bJ0muF61U3j4rFjNha+jOxBOHe5EN1nx5vw96st8ZBhujFjDb4lphHxPhieHyq9yValZ
         OTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769822323; x=1770427123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C9hrsBRNghnIovdQhJmal8FXOCZu37oJsf0hDL/41Z4=;
        b=QHIiOX7LYDdQqN1uu0/yRgX51ui4U/Yq+d7djSH9gYPLoxvKvYPGd49x5DM3kQTR6N
         s9BbpkKHyZSStvayKu3LFp8O2ecKgL7R1Hn1CLxyWDRAtnI48vo349mWrIjB9sFwAA0A
         ruoHiNdCPtge6OjVbOaqqIJl2D0yvWNoZ1VdljL8Ky3ldMyMJAElcZfWy4IHwJh3U/H+
         os+p8maAScy7raE3mYH4BGmj+/w4ZwUzBCQOTt+s2+pv8m/5C/5Fv01p4Q85ByweRaWF
         xhENiIUhqFkaEWCQKB1/MejIgepALaCTFFJPOIZGlvFuEAgdQJjR6B70C/Sr5X+u2Gof
         A0Cg==
X-Forwarded-Encrypted: i=1; AJvYcCVxwZ9bnZmlY2WCtn0Zm5Oo8YA1AkL9gWbRHBLZjhCRtVEvXRxvng8Be0Ag/M29NuqQT6COwAY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2oQnQNYfWNpefcfOiNRatFmMqH2822CXJB4UMyYxu71Rrs3vS
	co1/nywAg7yQlcplTTReT1Xjl1kiwB8ZWCBjGPT/MJ2vQ7if/wuRAAoE9i77TNeZWvUpgqe9t+6
	jc1xyxB2ZN9GrJs456i/NOB1tfeLINoQ=
X-Gm-Gg: AZuq6aLW0tcKqCD0qI8ACGXlQn7baZUSnvqb5bqzSI+6lSpR/anmoGuh9JVMi9LtSDm
	/sdaBA62SibrvSfkMxVNjn0zp7acTh7zW8DpdtPgpV4GTKTDA7gUex5LCM8Rm8EU2oJGrtxhQlr
	KZ7OhNds1KOZKsTdQvdeGStk5SHEdm0hlv1AURTyBhYXWWqiqrJJMirvDthsLlW9Mj5IXBoNQEA
	9C+NUSwAkYE0iCrIq89sJXH6GrXSRU2xpLFnwnYBzAX+szm0a3jJcVlRHpcaPPLag7rBA==
X-Received: by 2002:a05:6214:29cd:b0:894:2e09:335c with SMTP id
 6a1803df08f44-894ea06291bmr70047416d6.53.1769822323137; Fri, 30 Jan 2026
 17:18:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260118223516.92753-1-john@jagalactic.com> <0100019bd33f2761-af1fb233-73d0-4b99-a0c0-d239266aec91-000000@email.amazonses.com>
 <0100019bd33fb644-94215a33-24d2-4474-b9eb-ddae39b29bd8-000000@email.amazonses.com>
 <CAJnrk1Z9BuCLZv576Ro9iYUPRDpW=1euG0rQ2wC_19sBcR18pw@mail.gmail.com> <20260131004119.GA104658@frogsfrogsfrogs>
In-Reply-To: <20260131004119.GA104658@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 30 Jan 2026 17:18:32 -0800
X-Gm-Features: AZwV_QjdwrW8pUbs14BS2iG7wgbYWMrbtNkfExGV1HlyGRZYGgSvmv1QKkg5_Go
Message-ID: <CAJnrk1adQktTTv=9_G=G_QDTkEZyCQgsPDd7QSGwwTsWk_4fEg@mail.gmail.com>
Subject: Re: [PATCH V7 1/3] fuse_kernel.h: bring up to baseline 6.19
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <john@jagalactic.com>, John Groves <John@groves.net>, 
	Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, John Groves <jgroves@fastmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2026 at 4:41=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Fri, Jan 30, 2026 at 02:53:13PM -0800, Joanne Koong wrote:
> > On Sun, Jan 18, 2026 at 2:35=E2=80=AFPM John Groves <john@jagalactic.co=
m> wrote:
> > >
> > > From: John Groves <john@groves.net>
> > >
> > > This is copied from include/uapi/linux/fuse.h in 6.19 with no changes=
.
> > >
> > > Signed-off-by: John Groves <john@groves.net>
> >
> > This LGTM. We could probably just merge this in already.
> >
> > Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> >
> > > ---
> > >  include/fuse_kernel.h | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/fuse_kernel.h b/include/fuse_kernel.h
> > > index 94621f6..c13e1f9 100644
> > > --- a/include/fuse_kernel.h
> > > +++ b/include/fuse_kernel.h
> > > @@ -239,6 +239,7 @@
> > >   *  7.45
> > >   *  - add FUSE_COPY_FILE_RANGE_64
> > >   *  - add struct fuse_copy_file_range_out
> > > + *  - add FUSE_NOTIFY_PRUNE
> > >   */
> > >
> > >  #ifndef _LINUX_FUSE_H
> > > @@ -680,7 +681,7 @@ enum fuse_notify_code {
> > >         FUSE_NOTIFY_DELETE =3D 6,
> > >         FUSE_NOTIFY_RESEND =3D 7,
> > >         FUSE_NOTIFY_INC_EPOCH =3D 8,
> > > -       FUSE_NOTIFY_CODE_MAX,
> > > +       FUSE_NOTIFY_PRUNE =3D 9,
>
> This insertion ought to preserve FUSE_NOTIFY_CODE_MAX, right?

FUSE_NOTIFY_CODE_MAX was removed by Miklos in commit 0a0fdb98d16e3.

Thanks,
Joanne
>
> --D
>
> > >  };
> > >
> > >  /* The read buffer is required to be at least 8k, but may be much la=
rger */
> > > @@ -1119,6 +1120,12 @@ struct fuse_notify_retrieve_in {
> > >         uint64_t        dummy4;
> > >  };
> > >
> > > +struct fuse_notify_prune_out {
> > > +       uint32_t        count;
> > > +       uint32_t        padding;
> > > +       uint64_t        spare;
> > > +};
> > > +
> > >  struct fuse_backing_map {
> > >         int32_t         fd;
> > >         uint32_t        flags;
> > > @@ -1131,6 +1138,7 @@ struct fuse_backing_map {
> > >  #define FUSE_DEV_IOC_BACKING_OPEN      _IOW(FUSE_DEV_IOC_MAGIC, 1, \
> > >                                              struct fuse_backing_map)
> > >  #define FUSE_DEV_IOC_BACKING_CLOSE     _IOW(FUSE_DEV_IOC_MAGIC, 2, u=
int32_t)
> > > +#define FUSE_DEV_IOC_SYNC_INIT         _IO(FUSE_DEV_IOC_MAGIC, 3)
> > >
> > >  struct fuse_lseek_in {
> > >         uint64_t        fh;
> > > --
> > > 2.52.0
> > >
