Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8883009D6
	for <nvdimm@lists.linux.dev>; Sat,  1 Aug 2026 19:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785610942; cv=pass; b=JziYvYSZRI613yYXeEwDGs+W8WOXNXPmwRNKVRqtFd3vhO8XNpcxqELhdEzYIuF4XJpg2ER9L87EyEu14RO+N9D8OJOgAcljhpGpmfaQQ0qiSvb0NRXJsqNuaMpYh8XtymjIiaX/tkV9T6SBFHMzn8KjXZ6h/KJLpptNiKhSb+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785610942; c=relaxed/simple;
	bh=nivli2INTpQAZY/8TzmpQ6V0d9mAXZr2We8tZu0CLGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HXEp6U3iApwO/YYck/d+1K/KeJfTPlw9Y8adu++w3inOQYBDyM/s6N7k4n3HOJrtko3EXH0PuEWIR90Y+3raAzSS7qc34Syq8jGySMiKTD24rEZXclplO+cxjeKYfxaMiYMmcJwhFGoqALDBcD97+d9tPPYeGHJUfXWVLFO5If0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dv/sV+Nz; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dv/sV+Nz"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6983f20a8bfso3527335a12.1
        for <nvdimm@lists.linux.dev>; Sat, 01 Aug 2026 12:02:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785610938; cv=none;
        d=google.com; s=arc-20260327;
        b=dgTYZGNhSiK0hHpj2/QF3iQDbzne9SX8xAt0MrfZ8fFxhra6mqyK9IE7IiBNYDv57z
         obTCeegpUxY+0W+tMxu4yAxxDVy/XJo0QHUKVaAZnsNPYe5pXxhg2MgkrDEzN8fBSeUp
         UZqUcurAa2QpPEiPljvqK+YNqRdBzrjC+KKBLUuJTX4L+Ji9YULYOFT0F9nkIzZjLKxu
         +1/FYNhL9WlWoRE5ZCITzKExKSyF1PE1lx/RU6XQmDM4SsDyDr+JlYcbVi3eqUZVyxj+
         7odSNNoFvbvCApsZLPtzfo430CTtZjj7U59IRVKehLk8wx2xJKMcLyubIkQYu2n4E3vv
         tHIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nivli2INTpQAZY/8TzmpQ6V0d9mAXZr2We8tZu0CLGU=;
        fh=pMEKTWubFA9iBsl0aJZyFJFcdYZDn4yTtYWPNosbdCk=;
        b=kzJq0Z8lu4rhcoF6hwk9+WXwcx+aLD2RjiXqUSG28PEi+8VixV0m8Plpu3ODmealhr
         ab1g8wXAvUuTVM7LR4cK12wMenxbYPsgVlIl8XZKwZR4BkRFy2icYXg01mOaeBWBPQpG
         ib6daTmMbm3ajhVb5YJP4s5baY1IDzHzad7f0PWWWRf2oIZ1BTpJ0VMkOmfelPqH1wT8
         nXcGCbyItnOYAnIVr4dl1XgLKxNZY03sMDtgX13ukaZSU+FZvlLrGwZlu2HX6exTZmg6
         r0DW9qeuBXSQalOqpCimfkG4XNZzd2Ze26VDESkJFhHNoLEvbwJist/4ed+TpR6m6kdi
         PGCA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785610938; x=1786215738; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nivli2INTpQAZY/8TzmpQ6V0d9mAXZr2We8tZu0CLGU=;
        b=Dv/sV+NznOyhu/4CxFrXIogvlUcEGaWGd0AY9bAZRBabjqUESS/E5wlUp73rMTRsbe
         9+ylHXogwoQzEKkrSo0q0pvPNv8XyYURvKWwry1NqdIA5s7qjhby1HumOM3ByBm7g1A6
         9JEsxNcFKG98AEvbRfqbnTterlKhPCn9H2FhKVosWPjhAoBNleU/L9bJw3EEWCpZvHSC
         hw7M65ULw+kVw3xsjlpGYZVXnWbkg92Z11BCRlOmN3BH8eSq/J/u5TYmsbAvdN2OUaR4
         zFVCwRCncdvXLOV1vftwf2aNDkDK0V3outmTwZIvaUCMd4PSXy9IrU97jVKWSnaIdGEL
         C3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785610938; x=1786215738;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nivli2INTpQAZY/8TzmpQ6V0d9mAXZr2We8tZu0CLGU=;
        b=hq3ATeiA6rVTtuxVfAt2kgDmepxKJHJJhltcu7XJvR+a4aDksIBnH/BK8Mfzjm+ZtN
         xoEjRgBoK/3F3FtIAE1hVaHKQ/gVXi9rbRVEdbFG5g9jVxb2SYwluRbTfgVWgzY5QGsE
         A9W0EMfTpYmOGI4+jQNSZ1vitBPo//XqOBg07ikhPkR4xLpE20Oxc+yojrKsEWUO5zlI
         Yg0WMPy0dfcdAwKQjxscig3HG8k17PMZzjhZp2sEehecbbrYJOpE+Q0CISIL/Hz4+gBq
         eM/EJpXti5QgZon6wflP3DmMh2X/7Uc2lQGnrU1mNg6qC6hoqISjLsPmRuGWvtlFY0eE
         6CHw==
X-Forwarded-Encrypted: i=1; AHgh+RrMIqou5f0GgnvV+6RSsIsqyJfqppCAX+EviH+12zDrXUq3sJB76Cb+UD8snOBzNoyOviyMnGY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx15rgLqDzyd8etQUcA9Ze2eT6bnYMNKeeW2BaLeoZGF3AHtyV8
	1dnv6KqeFLdYvclM9a+vIiV71ltO5Qf/y5LZ3nV8fzChnKuFJV//jgirNnLqSVPMqFiaXp9swjV
	2RbH/Gm9ieAn29eRLwt1QZtwoMTn8TGI=
X-Gm-Gg: AR+sD12I7NV4rg+efwOcPv7VV9bbcZ543ebc/nlTmJXcOrli9jjpSQogAXr3J31I+Tg
	bT3uXZYVIvG8r9edQBXuMGl4WYbiuPv4thvZ2lUzdigyz2vxkeGvC6+PUSQ9dkvkPL0/1DJOt3T
	LnK8OPbMzKhPmmZ0Lyq8E37f5KHVi5twB2z05z56WTIngo0z2OH1xfhAbTx+j0F/Skw2L4f8xXY
	Q/r28zV9Apr0Y+dcY2vEFM7MGz61xp64xWBK3kFPQ7eFp8N1Fj/rKYh+v6erRIL1+nLnIGuKDxT
	JttPBPOCckW3IAwXZbc68Nl2D1GLrf8TpshugPYrKbFdvYY=
X-Received: by 2002:a05:6402:449a:b0:697:de29:c802 with SMTP id
 4fb4d7f45d1cf-6a0a7ccb364mr2898579a12.18.1785610937994; Sat, 01 Aug 2026
 12:02:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720034358.68714-1-john@jagalactic.com> <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <CAOQ4uxiEzP2e=cRw-AiGxtSv6WMSA5yR3cmgrF97s7ggU6wzqg@mail.gmail.com>
 <CAJfpegt9PwHksYhsQZeCsW0eooXVVihyieTpeHMmC-+Pq8BWaw@mail.gmail.com>
 <CAOQ4uxhuivjMMt_Dm3VwKmOhHg7ZHdAww6j6jp+RMjPoRde+bA@mail.gmail.com>
 <CAJnrk1Yat+SEr=SmZXwUt9y2WcC0VEC4KUpPrkrRSjMEmx42WQ@mail.gmail.com>
 <CAJfpegtnja6tkOnNPD2WZxu14Dd+UM9AvynsVB_E268iSXLbkQ@mail.gmail.com>
 <CAJnrk1a9mR-6hFie3hfFRgWTkrhJMVx4j9e7WGnjTRFuX2iJOg@mail.gmail.com> <CAJnrk1aj4B-T14SMTZhst2XsjOkKWStUj_0cjwHswgYWWuaB4w@mail.gmail.com>
In-Reply-To: <CAJnrk1aj4B-T14SMTZhst2XsjOkKWStUj_0cjwHswgYWWuaB4w@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 1 Aug 2026 21:02:06 +0200
X-Gm-Features: AUfX_mx0nmQgWA50AjJPZwCEcEACcDvMhxSi5YeCpVu2bWW7aLZWp00XQH36_Y0
Message-ID: <CAOQ4uxhop5bzpDxiqSdfHS8JyUASfAmpsmuhrpq7Ey28jATVsw@mail.gmail.com>
Subject: Re: [PATCH V11 0/9] famfs: port into fuse
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, John Groves <john@jagalactic.com>, 
	John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>, 
	Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 10:59=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Fri, Jul 24, 2026 at 1:23=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > As I understand it, the merge window for 7.3 closes at the end of
> > August. Just to summarize, the only things needed to get this into 7.3
> > (besides addressing the Sashiko comments) are:
> > a) replace FUSE_GET_FMAP with FUSE_NOTIFY_EXTENT_MAP (will also be
> > good for famfs in general, saves an extra context switch)
> > b) remove FUSE_DEV_IOC_DAXDEV_OPEN and reuse existing
> > FUSE_DEV_IOC_BACKING_OPEN (logic for this already supplied in Miklos's
> > patch in [1])
> > c) remove "config FUSE_FAMFS_DAX"
> > d) remove FUSE_DAX_FMAP capability (not 100% sure about this, but
> > since the only thing added to the uapi is a new notif type, seems fine
> > to exclude this cap flag)
> >

FWIW I'd rather keep the explicit negotiation flag and make it mutually
exclusive with FUSE_PASSTHROUGH (anything else)?

This will allow us reuse of fuse_passthrough infrastructure with less
concern about mixing the two use cases, which at this point seem
like two different use cases.

Thanks,
Amir.
