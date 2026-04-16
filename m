Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282FC39C00E
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 10:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776335409; cv=pass; b=XLlG2o32R7LcQjibP2ZpvFnhr7TDiwmN3RfZZ+bGqUDwXm0o+wJYD2QznnOrTy0g8cNFPlqqroMqPJpNfA1SX2lQzHE4IJKRjwPTmaexl20LxG9ybh+VXc1Rw8F3GdA8hUTDxq6eAdXWOzlmpduDT14EiRYS4j62ncoqDfYPElo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776335409; c=relaxed/simple;
	bh=waJiDzOo49cMRleBM9fFS7wM9KT+ZlkCB7xqbkKrq9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vBpxm5ragwokL/XJiwz5ISsN/Ho2vbeytBA9EmYdeJuh4dAaQJS4ps2h0O1JsNOBa/YszKaQmzgNSJaA0WLzFX7WeKlwbAx01msZUqEfmUISCT0S8a/DxUKDfJT+RkFP86snJX4oqqRT/aDClHfC9prhdXecquGlDNPkhlQRDyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T84RsxHx; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T84RsxHx"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-67251e91bc8so785211a12.1
        for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 03:30:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776335404; cv=none;
        d=google.com; s=arc-20240605;
        b=K9UvpYFYLBgDsGzxqnK86S0fGK38VGuPq7g1d+hG4lY0/SeNtL72JXUB82r6pDaAIf
         ozLqOujczNG/6rTxXeykrP2V28pb18to5TjNyJb0rtC7sU0j4bwbqhU2RVoWld+/Vl8m
         itO1LVoAcTzH5t6h2fuZMdgnBwOcNK1du/kIXe6MgRI2P//6rrv1Ijcn8zdLiUQUTb9X
         60xZAFRtLM29dzoj0RPriRxbiJQ5A/JN/pTxBo0CQeqVi2yKHhZAkY0UoFIJUFELwzpb
         X8ndNCNZwbdcbsl6cdyz3Apahy3cBf2nalCUCBLNtbNuZycs7GIBIiNjCr/050NPuZVs
         149Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O4x/p20rCdbt363tjV0+ABHeJuaMLyMj2lG+gRWDekg=;
        fh=2JdrAf7ftKFpscgc7UE1gGOSDjvjz2IYRs2+Imu4TVM=;
        b=D7kVbk2k24J77si9uR+BP5ODqI+AotXFcfN176GIz3czuGbzY5wSdwniDmRtHkgarI
         7EOU+AgtcRoQumleWa564OsNrAcN6lKDrUPsNsz4GN9RBlcWf5O65Jf69CjUEauB+Qch
         K4F8Yx/iWFnYec1/FhoQNnBy1pfRYDMZU/w7030IU02Ko3ljxbN0CUb41Rde+knvsLvJ
         2HoBiuMgoYXLenMiTSe8+T/JHP5A3+IhUzZ/qij6Z/bAUBwhswJK6Aykcb9Pxn3KVcCa
         yX4eW1YpQ/IEwdAmok2j9aTcPQXCERqmdtaN+aGu1a2lbROhPAwpp0f1QpMaiNlge3ek
         FedA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776335404; x=1776940204; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4x/p20rCdbt363tjV0+ABHeJuaMLyMj2lG+gRWDekg=;
        b=T84RsxHxh/lk8QkcHvGwR4S3vTKDFOLgHArd/JMpAgXU54jxKHMdFzep9owQwgGoAM
         J3WZu2mG7PBPY1mhfJsBJzfZqYxTudRozXnRuFRa8+7hCbczwwbQERnygZEbDbVp5L41
         hEsGbdF5e+tfwGWXcEe0fZE3UEF8UWQDx1szmo5JSlETJx/pGPFfJCkfzV2Hbg5gONgU
         WnZEtQIo/lpMWzrwvnPDt/OxYUsk2wXOkPmuGKVaN/yY/qFrP723JG6b5RlI0oQMrWU5
         bLKmK5Ob65QMz1bYshokTp5vywgAUFUlEwR/n3hMCH0P/RzlF1KTlrwm3L+0VARKexY5
         OlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335404; x=1776940204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O4x/p20rCdbt363tjV0+ABHeJuaMLyMj2lG+gRWDekg=;
        b=Gdnx7P7U2nenPH8hsqdHCOO45J1J1tys0wh2RFdpWyMyr9U7W8hJ2LmeKiAdrbz/TQ
         QsdXOjVQ+wbI+R7HvfDeClSiVOQVrD9dkbZaSfzrBK2wkHAxqi8cUaVTuYxn+DNHJlcJ
         7Ow4SaIjc8YMasNX+/XQC6tHSuLUHmjBOKonYqzLGxrAHc/e3cvsMN9mgUGj9wGUEWP+
         3ZlRlNS8oyOpceoJKCnWKL56mGw+lbGyBMD2cWZfLb3US1WKk0kOipZBcRYt0ztHTaWF
         uAR9l70wsweCQ1cu2CkcCtj+rIcd8QrY/xgSQVtFKIrF61ULiYbMYSkN29JceOGdFQQC
         FXFQ==
X-Forwarded-Encrypted: i=1; AFNElJ+1rfYpnaU8JgPjNmrpNTJciR4687E7vQY7vclsUz/eeY73P6JTQSzrr+To5ky14F0kfywiGfI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCpCRBX/iYl1FTAmyE0qkaxCNSAAChRBvzfywA3peop6xH2RpR
	b7g3Gh6I7ZxVWjT3NoXlLbJPJ58GtUxeyakK+iloseEDVRPblm1dUfsizTqEhNJ1FcVhfnU7L0w
	WkB/0KW92YJr1WP+n1u7YO+g81exytDo=
X-Gm-Gg: AeBDiesqFkONMEpMlWSA4jN1Vs+L9zEiEzRtiKP/ixm1cfjDQLSrGiHUle7Tga5uqZz
	2OSBSRC4mVNYWbUIByIIwT6AgCKccRA8lQfQNiA7DnToKftgZrxnWh2cRkmYR70t179b7WkwjRd
	RyR9XOrdIRvDvbr9r+o29LEicGcOf6BSlARZD6bzO3jzL6XF+ZIT1GNu538auGiBi3qNrjXCgSs
	Glq/nCv16173Y37V59BqWstQBsagxqRYkRsJZKGVeroueGhPjceEcMvjDg/oWez/dI1tk92ZmAl
	SVFbcohLlXLbZrdjsfMR38vQdi59CAEmQI7Zd78/WMEKRYoGag==
X-Received: by 2002:a05:6402:1bd0:b0:66e:103b:6350 with SMTP id
 4fb4d7f45d1cf-67271085617mr945994a12.7.1776335403710; Thu, 16 Apr 2026
 03:30:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413062042.804-1-huangsj@hygon.cn> <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
 <ad4EvoDcAKE2Sl4+@hsj-2U-Workstation>
In-Reply-To: <ad4EvoDcAKE2Sl4+@hsj-2U-Workstation>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 16 Apr 2026 12:29:50 +0200
X-Gm-Features: AQROBzC-j8c2wDPnYX4NqzriRAjav7sQoMIZaVyLzvRZ8lq-CJThcPkUuW_xSxI
Message-ID: <CAGudoHGLaoc+CoBPNCvFRYojnj+6E_Lsdv7NaJWxFMoHezemMQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	muchun.song@linux.dev, osalvador@suse.de, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-parisc@vger.kernel.org, 
	nvdimm@lists.linux.dev, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, 
	yingzhiwei@hygon.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 14, 2026 at 11:11=E2=80=AFAM Huang Shijie <huangsj@hygon.cn> wr=
ote:
>
> On Mon, Apr 13, 2026 at 05:33:21PM +0200, Mateusz Guzik wrote:
> > On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
> > >   In NUMA, there are maybe many NUMA nodes and many CPUs.
> > > For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > > In the UnixBench tests, there is a test "execl" which tests
> > > the execve system call.
> > >
> > >   When we test our server with "./Run -c 384 execl",
> > > the test result is not good enough. The i_mmap locks contended heavil=
y on
> > > "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can=
 have
> > > over 6000 VMAs, all the VMAs can be in different NUMA mode.
> > > The insert/remove operations do not run quickly enough.
> > >
> > > patch 1 & patch 2 are try to hide the direct access of i_mmap.
> > > patch 3 splits the i_mmap into sibling trees, and we can get better
> > > performance with this patch set:
> > >     we can get 77% performance improvement(10 times average)
> > >
> >
> > To my reading you kept the lock as-is and only distributed the protecte=
d
> > state.
> >
> > While I don't doubt the improvement, I'm confident should you take a
> > look at the profile you are going to find this still does not scale wit=
h
> > rwsem being one of the problems (there are other global locks, some of
> > which have experimental patches for).
> IMHO, when the number of VMAs in the i_mmap is very large, only optimise =
the rwsem
> lock does not help too much for our NUMA case.
>
> In our NUMA server, the remote access could be the major issue.
>

I'm confused how this is not supposed to help. You moved your data to
be stored per-domain. With my proposal the lock itself will also get
that treatment.

Modulo the issue of what to do with code wanting to iterate the entire
thing, this is blatantly faster.

>
> >
> > Apart from that this does nothing to help high core systems which are
> > all one node, which imo puts another question mark on this specific
> > proposal.
> Yes, this patch set only focus on the NUMA case.
> The one-node case should use the original i_mmap.
>
> Maybe I can add a new config, CONFIG_SPILT_I_MMAP. The config is disabled
> by default, and enabled when the NUMA node is not one.
>
> >
> > Of course one may question whether a RB tree is the right choice here,
> > it may be the lock-protected cost can go way down with merely a better
> > data structure.
> >
> > Regardless of that, for actual scalability, there will be no way around
> > decentralazing locking around this and partitioning per some core count
> > (not just by numa awareness).
> >
> > Decentralizing locking is definitely possible, but I have not looked
> > into specifics of how problematic it is. Best case scenario it will
> > merely with separate locks. Worst case scenario something needs a fully
> > stabilized state for traversal, in that case another rw lock can be
> Yes.
>
> The traversal may need to hold many locks.
>

The very paragraph you partially quoted answers what to do in that
case: wrap everything with a new rwsem taken for reading when
adding/removing entries and taken for writing when iterating the
entire thing. Then the iteration sticks to one lock.

The new rw lock puts an upper ceiling on scalability of the thing, but
it is way higher than the current state.

Given the extra overhead associated with it one could consider
sticking to one centralized state by default and switching to
distributed state if there is enough contention.

> > slapped around this, creating locking order read lock -> per-subset
> > write lock -- this will suffer scalability due to the read locking, but
> > it will still scale drastically better as apart from that there will be
> > no serialization. In this setting the problematic consumer will write
> > lock the new thing to stabilize the state.
> >
> > So my non-maintainer opinion is that the patchset is not worth it as it
> > fails to address anything for significantly more common and already
> > affected setups.
> This patch set is to reduce the remote access latency for insert/remove V=
MA
> in NUMA.
>

And I am saying the mmap semaphore is a significant problem already on
high-core no-numa setups. Addressing scalability in that case would
sort out the problem in your setup and to a significantly higher
extent.

> >
> > Have you looked into splitting the lock?
> >
> I ever tried.
>
> But there are two disadvantages:
>   1.) The traversal may need to hold many locks which makes the
>       code very horrible.
>

I already above this is avoidable.

>   2.) Even we split the locks. Each lock protects a tree, when the tree b=
ecomes
>       big enough, the VMA insert/remove will also become slow in NUMA.
>       The reason is that the tree has VMAs in different NUMA nodes.
>

This is orthogonal to my proposal. In fact, if one is to pretend this
is never a factor with your patch, I would like to point out it will
remain not a factor if the per-numa struct gets its own lock.
