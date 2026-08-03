Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5086F3AFAEA
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 08:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785747156; cv=pass; b=OR95+z8gxUsuM479LZKa4TzyL8xhmD6ITYI/2as1hFJREUS+y2GsRYweJsPNrSiVjRP4KS2VG4lac+7wXCZaewNUh87+gGCg6wPiNiR3ZLynFfhV4QHxCjgZXV7mqu793x8RY9owc5RGzp7QIsogGSe6TV7MxOmGbZOAwkbWrno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785747156; c=relaxed/simple;
	bh=gqu0R7zR0Hsq4p6SL2JusMkem4aahjhzej3fzwamL0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oQQLPx9An7F1FFm/ncbumtuOOUmK7VCeO3orcNVkQTVsukECwTBZi/+ZxLz8cU1EZW3+dWCWPOKmIN2r4Wn+FvKbNIl+9RGHuaKwFQ1vtk4/gX9SXKZka+Lhdvn35kM2Nqj35o4MPSeO3V2Vx+fQV6Hi3sDwO06SO87VdTKbNiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c00cn8kd; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c00cn8kd"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a051b73866so4980839a12.0
        for <nvdimm@lists.linux.dev>; Mon, 03 Aug 2026 01:52:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785747151; cv=none;
        d=google.com; s=arc-20260327;
        b=ahkslwFUqzSOEWje/BqG4LzSwOYgSI3d+604fK8kVt4So+dYSvgBizqU2MyMenzs6s
         UqeKs3GdlJ3sexT5pu6hvrVQFqJN3l3Md3ql/B5+LWKLeyJ1nosQsS+7V2G8xwNlaQRT
         UmEH1YMAhdTeQgmtJe0Xxa1XuR6k/9Ycw4KRcd3TaV/1tEqunXz268qNVowdHim1+RjL
         FvBBK5heOoj0OXFO55lbHozRJvqPVapvPkFG7E1Ug3jCD/tY3RhLDqIz9poeZWn6pYkR
         CWlkT4t00QC0fpojRI126nTrJkR+llHlnpoy+EcVdfru2GoE0NQNZe7chomGrpFeMw4V
         VXpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gqu0R7zR0Hsq4p6SL2JusMkem4aahjhzej3fzwamL0U=;
        fh=Rom6XyKs33uTeRpSLazcvQ2bkCohdNNoxYlH9U1Zpdw=;
        b=KZXanfujZU1WuusNUfUBTRw7lvP/xpnzHkB0kLN7cq7NLTy6OBCDopw0KxHt1GbDGF
         csPf+6XifabU7gHyFxvw3S5JY8jpoeo4KMPJFXKwEQrspnVgJGP+KPrQlEEeP/1I15J+
         VJL8PqdVXMbpm3xdzAsl9UWpyugPqky+sd3ceSY253O2xCeSJDMoYyDKi+nHbImrfp/x
         qAyk6YG12eTLR9NUjecsHrK4CuAnPy+Qqu4OBc8/ZSjKQy3wNp7gqcGBJTx+DIv+88YE
         6o8L7sqPUmcwZql6WbZ06u8AIxYULnMU59/wRB/Bpfrkh5A2PIpvs5HvzlghOUTHb19E
         pxWg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785747151; x=1786351951; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gqu0R7zR0Hsq4p6SL2JusMkem4aahjhzej3fzwamL0U=;
        b=c00cn8kdyWwlwlr3Dj48Z0AY/NCrpkxZghbI/d60GzNxkV+nC2IESqISqx1MMbKb+B
         lX+IisrE8QoY2voPsPFrvJczfcZhv4SozptTilA9l1PAC/vtEsa+IGtlOLVcEUr/pu2S
         Vw0XGLJszNoxtJyK6VcIg5JU5g6aurNMwRMuUJBt5wcKcBsf20mxEmPhNbQQVBHK3eqh
         plRJ7S2HcTExn8mzSA3AwOVVvUWbGjx+htkLn2WbaCuxBzf1Wgg2g2yiUVdmFeFFXDpk
         15NUxQHMRv9k1bg2/Md175jaVRJ8rdFdmuchXvSs00rxnsJt77ma2xvL4OdSpQZDxMJ/
         tP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785747151; x=1786351951;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqu0R7zR0Hsq4p6SL2JusMkem4aahjhzej3fzwamL0U=;
        b=s1al+rZZWOnKY74xMYGrzjclAgRyTwsard0OcQ+Vb2MepK4KrMCqn4hBwl6/M2+Dwr
         i8Pqc1wOQBJ9k32I7tlxjbrZKaJlHN5Mai5r0LjSUlbhidTPrBEeF7W9+3hp5N2MfwZT
         rMzMJiClP4gOci5/ZRMByGPqBSpPGRuQu1gReQx8A9alAAtWS6rOmBn5y7kDwM4DOIKO
         28cSGewm6XiyYo1iW+pymJ0ujT5mX2hZh0LjGgnAhDyTTTRNvhGmY/RH6bdxNmErdRKj
         eqGaC/DWP+0xDb4WynJPhQiWslmP7/BKSZa/0x/J3MixZHblfA6Pjspr0FCYEsCau0lm
         EavA==
X-Forwarded-Encrypted: i=1; AHgh+RqW5sR4rVTT2uAu227FoOu0IPwSHaH+mrqyPN150/tJw2Ik0xxDLk1WJemFu6Wt+pSOW15YFaM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfoxmES5g1p3vHjgqpnrUKfq4nRBymbbkmuST2o6XzfKrghIPk
	/zN0Jfj2uTbDZlqjBY2gvqMfk3vt/ldLJ5tXpifAUmczgcztaWCEzaQxagCdjCyQy/GZ9cJ+kb7
	AAa0j3Q/AAwz3he/LXPFCli1h8d6K/Kc=
X-Gm-Gg: AR+sD12UESExlLkQx9nisbFoP+LdeRbHX/xrF3FLleb2t5hV+wBUQgHK7rK6niK971L
	WtRBGuG3BHoO1ebgQQq2OTjc48uDw9EmfxhDR4rt2w5pr0fLj9MbdtfrqHH40J6g9lz9pCwabqt
	KntpL2lDX/QQpjEFHUwk73hTmhGR2YwpG9wihH1l3oF3W2aU6TE3pJ+5cIcIjz9ZFiO6dJLe4Ha
	agbv5DD+EsNaEDRW0oQmQKIfO2cM7MVJrEPYipIjdFYB4FZEfMTYaLyxhc7Jrj7Zpj8ja154SED
	WBStMGN3jFVzpZ6ZmMDFgtBWueit2TttJg5ETzV1k+f/kQ==
X-Received: by 2002:a17:906:6296:b0:c15:b67b:523e with SMTP id
 a640c23a62f3a-c1fe7ef886dmr753138466b.19.1785747151231; Mon, 03 Aug 2026
 01:52:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803022730.75731-1-john@jagalactic.com> <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
In-Reply-To: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Aug 2026 10:52:19 +0200
X-Gm-Features: AUfX_myBTyPHpMQ4dIR86ct8epUOnbu5tszSaYGQfG-jc8Xn7HqO1PF8uWIUaCE
Message-ID: <CAOQ4uxhpkP7FsjaqqVO2aDSKCJ9yc3WKms6dncqnDuwGxqthng@mail.gmail.com>
Subject: Re: [PATCH V12 00/12] famfs: the Fabric-Attached Memory File System (standalone)
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <djbw@kernel.org>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 4:27=E2=80=AFAM John Groves <john@jagalactic.com> wr=
ote:
>
> From: John Groves <john@groves.net>
>
> This patch series introduces famfs as a standalone file system, as a pivo=
t
> back from fuse/libfuse, for which the porting effort took close to a year=
, but
> then the review effort started with almost a yearlong delay, and then got
> messy :D [3].
>
> However, after years of maintaining famfs in both forms (standalone and f=
use -
> the famfs user space works with both) I think famfs makes more sense as a
> standalone file system - and some influential maintainers have privately
> expressed that opinion to me.

Hi John,

The decision about standalone famfs is left to vfs maintainers.
I am only going to chime in for the fact checks.

Generally speaking, I find your summary of the famfs odyssey very thorough
and mostly accurate, apart from the few bits I will comment on below.

You do bring some valid points that are worth considering, but I would like
the facts to be laid out correctly for the vfs maintainers when approaching=
 to
consider standalone famfs.

>
> The most important thing to know about famfs is that it CANNOT be used as=
 a
> general purpose file system. It is for enabling file-based byte-level acc=
ess
> (including direct mmap) to very large (e.g. 100TB) shared/disaggregated
> memory appliances - which have become available during this long process,
> and which are in need of Linux support.
>
> So famfs cannot be used by anybody who doesn't know why they need it; Mak=
ing
> famfs standalone means it can't affect users who don't use it. And my sup=
er-
> mega-corp employer (Micron), as well as other memory companies, need it.
> We do not intend to abandon it, but imagine if we did: fs/famfs/ should b=
e
> removed if the memory companies can't be bothered to maintain it.

It does not work this way.
When vfs maintainers accept standalone famfs they accept the burden of
maintaining it whenever vfs internal APIs change even if the filesystem was
abandoned by the mega-corps.
That is the code of the push back for adding new filesystems.
Removing the fs and breaking deployed systems is not an option for the vfs
maintainers.

>
> This code base has been in active CI and used globally by early adopters =
and
> testers of disaggregated memory. I believe it is solid.
>
> History (skip if you lived it like I did :D)
>
> Famfs was introduced at LPC 2023 and LSFMM 2024 [1] as a standalone file
> system. The fuse odyssey started at LSFMM 24, but I think it's time to
> bring that to a close. The first fuse/libfuse patches came out in April
> 2025 [2] - adding a substantial amount of complexity to the famfs user sp=
ace,
> and controversial complexity to fuse [3].

This alleged complexity to fuse is attributed to the BPF idea that was shot=
 down
pretty quickly. It is not on the table right now, and representing
fuse maintainers,
I don't think that any of us perceive famfs as adding complexity to fuse.

On the contrary, the sentiment in the review of v11 is that the bits
added to fuse
for famfs are possibly useful for other fuse passthrough use cases.

>
> The fuse community was uncomfortable with the new metadata and fuse messa=
ge
> formats that famfs needs, going so far as to suggest that famfs use a BPF
> program as a vma fault handler [3] to avoid the need to pass famfs file
> metadata via fuse messages - an idea which, to my relief, was definitivel=
y
> shot down at LSFMM 2026 [4].

Again, bringing up the brief BPF design detour is irrelevant to the current
state of affairs and this argument appears over and over in your proposal.

>
> In that session, I was preparing to make the pivot-to-standalone argument=
,
> and there were others in the room who support that - but Miklos stated th=
at
> he was not opposed to merging famfs as it stands [4], leading me to back =
off
> of the standalone pivot at the time.
>
> However, 1) that is not how the recent patch discussions have been going =
[5],
> and 2) I have (not solely on that basis) come to the conclusion that famf=
s
> makes more sense as a standalone entity. In v11 [5] I dropped the
> controversial famfs interleaved extent (exploding fmaps from well under a
> page to megabytes),

It wasn't an ask from fuse maintainers to cripple famfs.
In fact, Miklos has posted a POC patch [7] for striping, which you
did not respond to at all.

> and there is still a push for adding an intermediate
> virtual backing dev layer that famfs does not need and can't really live
> with. I could go on...

I would really like to hear more about "can't really live with"
because Miklos' patch looks to me like a logic equivalent to standalone
famfs interleaved extent, just a different UAPI, using the abstraction
of virtual backing dev...

>
> My argument
>
> Can we make famfs work in fuse? Yes, if we can agree some things that hav=
e
> been quite challenging to agree on. Should we? I think not.
>
> I think famfs adds complexity to fuse that will not likely see constructi=
ve
> re-use.

As I wrote, this claim is questionable - it does not match the view of
some of the
fuse maintainers.

> And I think fuse makes famfs worse - significantly more complex, less
> adaptable to change, and less performant. And famfs files are memory - ac=
cess
> needs to run at memory speeds! In short the risks out-weigh the benefits.

There are definitely pros and cons, but if there was a measurable performan=
ce
impact we would not have been having this discussion at all.

AFAIK, the performance impact was with the briefly discussed BPF solution
or worse IOMAP upcalls, so those ideas were dropped immediately.

It is very clear to us that page fault performance is critical to famfs.
I fail to see how Miklos' patch for striping [7] adds significant performan=
ce
overhead to page fault and seeing no comment from you on this patch
I am guessing that you never tried to apply it or to measure performance im=
pact.
Am I right?

Look, IMO, your main argument for standalone famfs should be that famfs is
simple and would be easy for vfs maintainers to maintain in the future
in the unlikely
case that it is abandoned.

The way I see it, the main caveat with famfs-fuse is that it takes a toll o=
n
you (a considerable toll) to meet the requirements, but to be fair,
Miklos already
wrote a pretty decent POC and you were offered help from fuse developers
with the remaining parts.

However, the claims about performance overhead and complicating fuse -
I find those inaccurate.

Thanks,
Amir.

>
> About this patch series
>
> I've called it V12 for recent continuity; there was a V1 and a V2 standal=
one
> in 2024, and then V1-V11 were fuse (call this selective consistency).
>
> Famfs depends on the 'fsdev' dax mode which landed in 7.1 - it will only =
run
> with an fsdev-mode (aka famfs-mode) daxdev as its backing device(s).
>
> Patch 01 is a fix to the fsdev driver that is needed by the rest of the
> series.
>
> Famfs Overview
>
> Famfs exposes sharable disaggregated memory as a file system. Famfs consu=
mes
> shared memory from [usually shared memory] dax devices, and provides
> memory-mappable files that map directly to the memory - no page cache
> involvement. Famfs differs from conventional file systems in fs-dax mode,
> in that it handles in-memory metadata in a sharable way (which begins wit=
h
> never caching dirty shared metadata). So a famfs file system can be mount=
ed
> from multiple nodes, provided they have access to the memory.
>
> The key performance requirement is that famfs must resolve mapping
> faults with minimal overhead. This is achieved by fully caching the
> file-to-devdax metadata for all active files.
>
> Famfs remains the first fs-dax file system that is backed by devdax
> rather than pmem in fs-dax mode (hence the need for the new dax mode).
>
> The famfs user space can be found at [6]
>
> [1] https://lwn.net/Articles/983105/ (Famfs at LSFMM 2024)
> [2] https://lwn.net/Articles/1020170/ (Famfs at LSFMM 2025, with patch li=
nk)
> [3] https://lwn.net/Articles/1068686/ (LWN coverage of the patch thread)
> [4] https://lwn.net/Articles/1082687/ (Famfs at LSFMM 2026)
> [5] https://lore.kernel.org/linux-fsdevel/0100019f7d9fbe81-6cb16662-2522-=
47ea-a152-fab0ee3d9b35-000000@email.amazonses.com/#b
> [6] https://famfs.org
[7] https://lore.kernel.org/fuse-devel/20260601152327.2069787-1-mszeredi@re=
dhat.com/
