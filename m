Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1D5372B40
	for <nvdimm@lists.linux.dev>; Wed, 28 Jan 2026 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769626481; cv=pass; b=nZrlTQLAoWCKfMf+RhybU9BvWt225owr7qz9OB6fnRXqrKL1UbokAKDSDAcXOs9D6g/LfuG3hWlz+YTpX7+sNPvjGnNL6impQq71AU60h48HVDzJUziNjDB4/ISYnlMPcBGE0tyoP6YhCp3TtddV5Jr/NEE4P3XG1FfUQQ6gxI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769626481; c=relaxed/simple;
	bh=Iv/R1VrCmh7DPMnIVbKr+xqiK5DjA15w78PbjXQO200=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jfHraDtvhYQuuhwHnaMBbZXbh6Uoq8LNLwUzI9XvZWePEiiQR0e340WxI5PirHqUfcx+RREGQ/VQMeT2EXpjetQGawJrDJ3xIjCmnmbnA+AHhDvuJIcpGiS9yqPgwU0E1d3uaoxVpytCdhtH3U5djyes5qZtYDL51GQN7sJwMBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B8TSJ3In; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8TSJ3In"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-502a26e8711so811471cf.1
        for <nvdimm@lists.linux.dev>; Wed, 28 Jan 2026 10:54:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769626478; cv=none;
        d=google.com; s=arc-20240605;
        b=dv8y87Ox08N2/afATZwXoASTX2QJSqhdVnOtkhIg//bdhhUL1Hv3uGU9eehMTH5dJO
         E2WGbw/VEyf0arVnpM7pGDTcdW5Am965nyCi3q7IN4uIMrljfJyFvJb/aSXVAvFpOGWI
         xIypSS6bNq0CVpD1eH3G+uB+qPf00Ebw47F2UBjE2wmErcieph7ldCcDhZE4ddCirTdQ
         R8K6Q5szJrUC6ZmrUL7oSiophRp33prvrZ6onJRYCylpuVNUM5/qp8VSln9Q2GQLfBal
         1fiOxMdtXiH4FZfgyUqCa8AmSFK4HW6swfwCefOI4YJfZC+j5BYsZZLK5DhRzBWCuF9V
         0SsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EQD+zhNe2TBSVN4C+gGjdPZJybKoBQIJM5cDvqByP90=;
        fh=7QyKNVpBk0piNgfUy4Bj8UZUCc7IaPthK+zN86iwKrY=;
        b=B3xpXWdFVLgYL37moVeRCRQk++djMwzHpKfJtk3UlYEvrvVRZxBdc//gWoQAQPU17l
         wPaM9TQG/lD4iBfcdxw3yjugGM5DwPaQki0P2E4IgLbSHsjHxuDB9Q0JcFguGbCaVY5q
         mF9jfAyhWVAvfKsyEzqkKUxxUNMuOkcqRR/hhO7pk/e7JCFVVDNhMleVwX2uB37AhV9V
         ECwv9sqMhQhkCUkLhtq85x3gLFYA+S7I4saufAXZsZm3VcPV7XomD/L5BptCIZsPrDly
         LtPlX+iD4ckcaSF0YscAIfKoLmetpb+hvd5wXuRrStw5nboGF02eZwyt8PS03RzEROji
         dPiQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769626478; x=1770231278; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQD+zhNe2TBSVN4C+gGjdPZJybKoBQIJM5cDvqByP90=;
        b=B8TSJ3InfZUrJbGvEpzd0xKg95NzPO2YRxt3LMwkdqSpTtFa8AjuRYdYK2B6PRvLmz
         twfT8OwoJw3FjSDeEClyNhkCquk9dcOWVnNto2le2nToRFCwO2N7IM8vsRvuoL/0AUYt
         BvsCet1tg+KgiFKQqNdLFmH0AnxQxKTPt995oReDtnW9CGSRZwBBtC/VgTGhEuCv1o81
         VUZSCTiRtUEzg83u4cTpjtN+Bo5qf4yIgRn9iwFAbbYGfo2G07pxY6PiSLvRuMnyvBkT
         MXMzmVaipyppkJJd4sm0vXP6O1Q8zRCkdMFaSTmt674+m1OXufHVZLUJDMYOFL1XBq6E
         0J2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769626478; x=1770231278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EQD+zhNe2TBSVN4C+gGjdPZJybKoBQIJM5cDvqByP90=;
        b=BSDSGw47pLwrB1GpeCS1D1D+S5vtI5WsJlhB9pivlmEbCs8LYsdfw0e79BFJ7eW8yS
         0DF/Qv5YL6PEslSbciOLLFDqtZQguxI/ReXeQrXEWBOHuPKSirr2tmu7e+4BTdTbAYws
         ke/TfH5J4QJ+3J1pcyEOaCul7nyoQKZF1vWElSyUifVRQ34mmcodWgmM/hz0UB/AT3hX
         KQ4h9pPi9L+sPsg8+V9deo/SKYEhSSWoY+UvJ8180P/XTZ3KH3f03VhMHm/CDpEH0yne
         WUIgI5tp1HDh+PD2zpjeasVvXp3CeLxASdja1WVJo013qxR7O4HX4kwHSoyU4fbuWDA7
         l8Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXQ43wTHbbVqx2PcVLLx4j4eaux9fWXMiADoUqk1cL9QYr+PQ6p9nzAZWlUaxPSwGv7buuCX/8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLbQxx5ZFNesa8bjUpiRJ1DMXez9i0SFYMaRsqOyqQWZKnvcqv
	tMdYTkDQrWHEfyjrUNBPd8tKSvuXgf8VP2kQMy9iJiOhK8VQ5A4JrcMRZpb3nsik7anzTTn/aAa
	80cCmk4QCcMNAY/GtzOPHECN3gAJtxOc=
X-Gm-Gg: AZuq6aINP4NTl61ExB9Bl5HKCrwElVvoDUt+NDGAlITRajsVGvt3ZQ+5GtSEqOPtcad
	71vy4e7PKqrU3Kj7nRjHYJQUlfTR9a9JJKQNhC1w8NS98IcdUhWsTswULFHRhY5q2FVPPL+vaa3
	VQLYKwXBa6P8Nfr4BsH5t2kUTTY1Clt79ockyhKdZ+mbeOAi+BN9k45l0b2iZf2Vxz6FyVUs6oi
	veaqJpBwxczAn2JIS8carpdPV1IBeX51rzew5/JKuC7Z5gwTyUnP4Ahito8nDEbnIznVg==
X-Received: by 2002:a05:622a:1b91:b0:502:9b1f:ca4f with SMTP id
 d75a77b69052e-5032fc14d15mr83239651cf.84.1769626478464; Wed, 28 Jan 2026
 10:54:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260116125831.953.compound@groves.net> <20260116185911.1005-10-john@jagalactic.com>
 <20260116185911.1005-1-john@jagalactic.com> <0100019bc831c807-bc90f4c0-d112-4c14-be08-d16839a7bcb6-000000@email.amazonses.com>
 <aXoarMgfbL6rh6xi@groves.net> <CAJnrk1bvomN7_MZOO8hwf85qLztZys4LfCjfcs_ZUq8+YBk5Wg@mail.gmail.com>
 <0100019c05067b3b-b9ab2963-ace5-481f-8969-c11f80a74423-000000@email.amazonses.com>
In-Reply-To: <0100019c05067b3b-b9ab2963-ace5-481f-8969-c11f80a74423-000000@email.amazonses.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 28 Jan 2026 10:54:26 -0800
X-Gm-Features: AZwV_QgXH_eGEFbh8Ufwurz5i77r71GDNcEX490YVb0oLl5TmaOznNxDkpKSA1U
Message-ID: <CAJnrk1Y6HayeS-C3sOEOc_CgaS_K=SedZNpHASAXAkgZyp3Xsg@mail.gmail.com>
Subject: Re: [PATCH V5 09/19] famfs_fuse: magic.h: Add famfs magic numbers
To: john@groves.net
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, John Groves <jgroves@fastmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>, 
	Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
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

On Wed, Jan 28, 2026 at 6:33=E2=80=AFAM John Groves <john@jagalactic.com> w=
rote:
>
> On 26/01/27 01:55PM, Joanne Koong wrote:
> > On Fri, Jan 16, 2026 at 11:52=E2=80=AFAM John Groves <john@jagalactic.c=
om> wrote:
> > >
> > > From: John Groves <john@groves.net>
> > >
> > > Famfs distinguishes between its on-media and in-memory superblocks. T=
his
> > > reserves the numbers, but they are only used by the user space
> > > components of famfs.
> > >
> > > Signed-off-by: John Groves <john@groves.net>
> > > ---
> > >  include/uapi/linux/magic.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> > > index 638ca21b7a90..712b097bf2a5 100644
> > > --- a/include/uapi/linux/magic.h
> > > +++ b/include/uapi/linux/magic.h
> > > @@ -38,6 +38,8 @@
> > >  #define OVERLAYFS_SUPER_MAGIC  0x794c7630
> > >  #define FUSE_SUPER_MAGIC       0x65735546
> > >  #define BCACHEFS_SUPER_MAGIC   0xca451a4e
> > > +#define FAMFS_SUPER_MAGIC      0x87b282ff
> > > +#define FAMFS_STATFS_MAGIC      0x87b282fd
> >
> > Could you explain why this needs to be added to uapi? If they are used
> > only by userspace, does it make more sense for these constants to live
> > in the userspace code instead?
> >
> > Thanks,
> > Joanne
>
> Hi Joanne,
>
> I think this is where it belongs; one function of uapi/linux/magic.h is a=
s
> a "registry" of magic numbers, which do need to be unique because they're
> the first step of recognizing what is on a device.
>
> This is a well-established ecosystem with block devices. Blkid / libblkid
> scan block devices and keep a database of what devices exist and what
> appears to be on them. When one adds a magic number that applies to block
> devices, one sends a patch to util-linux (where blkid lives) to add abili=
ty
> to recognize your media format (which IIRC includes the second recognitio=
n
> step - if the magic # matches, verify the superblock checksum).
>
> For character dax devices the ecosystem isn't really there yet, but the
> pattern is the same - and still makes sense.
>
> Also, 2 years ago in the very first public famfs patch set (pre-fuse),
> Christian Brauner told me they belong here [1].

Hi John,

Thanks for the context. I was under the impression include/uapi/ was
only for constants the kernel exposes as part of its ABI. If I'm
understanding it correctly, FAMFS_SUPER_MAGIC is used purely as an
on-disk format marker for identification by userspace tools. Why
doesn't having the magic number defined in the equivalent of
blkid/libblkid for dax devices and defined/used in the famfs
server-side implementation suffice for that purpose? I'm asking in
part because it seems like a slippery slope to me where any fuse
server could make the same argument in the future that their magic
constant should be added to uapi.

For Christian's comment, my understanding was that with the pre-fuse
patchset, it did need to be in uapi because the kernel explicitly set
sb->s_magic to it, but with famfs now going through fuse, sb->s_magic
uses FUSE_SUPER_MAGIC.

Thanks,
Joanne

>
> But if the consensus happens to have moved since then, NP...
>
> Regards,
> John
>
> [1] https://lore.kernel.org/linux-fsdevel/20240227-kiesgrube-couch-77ee2f=
6917c7@brauner/
>
>
