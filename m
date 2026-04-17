Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CAF1F4C8E
	for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776454528; cv=pass; b=e4GpR618dRdZK2iuGKgB1EV6E8u/BrsOmpV1vn5KkhMGms8enXIdxOnCMXqZbCNWiM+/qb/i98blsY742/TJ7RNInX2uyWS2WHQMiUSoIb1tNisMMdhDzkaag03rLFSn0otTP/vp/HpDaZBqCThDgkE6vKJZ8zBUVB23mThUnkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776454528; c=relaxed/simple;
	bh=EPXnTicHxjO3r0CVVtRWh3D1dZqlAPTDXfoysvtgqqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ADeBKMSKQhSr5tKQnGON2/wopi0C1Z58NwSdcB8leckY1IYke5RUpJ0Qur2xBDUiuIgfVNLq2gxRzhdKB2spaddxcxmYG5+rfK9U4+EtqIJYcmm79SgAm+cwa01FouQrWAWqU5QF3afEBcsZ4gDgwvzvJ6+9u/oquvVvZCQOzDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AJtcuV9N; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJtcuV9N"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so898110f8f.2
        for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 12:35:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776454526; cv=none;
        d=google.com; s=arc-20240605;
        b=CfDFo59MyLBFhwwJkzdMpXxBekSUDUY5NJBdor8zqAMz+1Agaicgy4qTsvW98ubNS5
         GqvS0UIxisgbJuVCTIeQDX0Kdve+VPWukAP4d61igIEKLQkYcaPs6C9HooO+4LAJovUy
         jsMqr0cOC32RHW8EkLHnZ2I2UrHNO9twH/90IVfrmfOSywXbFv/iVJc4LCEe9Q2VuGqe
         IfjiL+CVSs+DWP8SEhuggkrettLW74schbe239oLcqwDVu5Ps3DjRKCi6A+2RkvtRxj0
         lG7e9omYHi+dsamLRiturXNq80RZPs3J74iA+qdU1BKdot0c7L9sXCYBVAjqULELSXJa
         lwKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BKQtLrK767PS4V8iaYQzHGGgM/KC0ExoAgrnjJyr8Lk=;
        fh=wG+GNYH7/7pUsYyEC0xdPPVK/m+e9lVWLK6W9ldYCY8=;
        b=GvdvJMm6a0FM5GP339poj+d+umFFBfeW0miwo7MMczTWvcIaD3Ays+vFfuFOvkZdRM
         +wAs3FKRgsk8mSGrTCeely9pFcxM4IZOaFH6j70rFEPqIllKu4JdiPim80ZfMEFDEavF
         de8oUMnrrsnlUPC80DQbsnMXHgRUA4Xt8tj28MDi+mhvFFp8tWJNMVyrJogZmvOwVuE9
         7R+7HY9rS6x9YuMm25nFFNfHg/MVv5/uz+vaoNWjHXRv7m4Mo6V7njQHxIUd0FevA1yB
         smmeYm+7+ItfH+fp2MkE+SGsf4lQxhrntUhDnXdBHMhT1gV2Upd6kbmg7qGJ50hhBwIR
         nrug==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776454526; x=1777059326; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKQtLrK767PS4V8iaYQzHGGgM/KC0ExoAgrnjJyr8Lk=;
        b=AJtcuV9NWajI7N4EZ6yZuSyudjzLvcrxnIlyftYtHQliiYoCDnGbUOpSDkJ4H1nd05
         bdxNLXGAojrsIc32v/UTTaXp0QZLRPnTaMHdGySg0pKXOz7S0A8lclVbEy84JaO8XR4E
         b1IAXOdtUmeO5NIE+NAn6DwIs2YxmUiJ9S/j14ENWgJm3W0Ze0a+q3CwZWGod5aVPTvK
         0kLleWMbZw3ewEi2Qm9vjW5MmBzOSxtqV69uvFu1qH6v3I4r5yjXT/9j5NdDoLRia54F
         PcgsbonP9ddtjPWuwTHPR6HjMLq+pC1nRavSwtWWNLUkd+QvlwsvGjA+Luc1/+9/NtMY
         BeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776454526; x=1777059326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BKQtLrK767PS4V8iaYQzHGGgM/KC0ExoAgrnjJyr8Lk=;
        b=lAfuDdu5DjU48rOmgQ9AealetHnnjNXI5tcbv5Zp8kzlUzjn8r3l8WscMiKB2KOXt6
         ll1zo3bhH3FflKkSyxPHrslm7aLp0TRox3lnMxpNYaJsrx+DnkZFYBpWbKExKovm2dYK
         S8oqoxX4pnD2eeAaNJgL432T4y6D+VV58KKq/n2thnjce4LF3p9IFATDpkjkE8l7xjpl
         bCdmLsUM/9NWUisUYPBz6p4xLTIi0+0id2uXYUe6F83LyVVLsskHA0i1ElyupFk8ouRF
         ymjHkQCNSiXcjrt1gvX39hXJNDDqPGUyxCWu3WPEU+FLPu3W2d25nJyya8rvKS1VdWhz
         D/Fw==
X-Forwarded-Encrypted: i=1; AFNElJ+OGoEtWFJlRwPghqbuiQOAizPPQKvUfOZkRWAZlmXd7ipQ3Rwqq/Dg8BkEiKukFwab0FRFo+0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLP3K/F3NocuN64fn/bigCym82Plc1d8A98cQHWA5KOg3YPMYC
	7hZlH2wxYIV8CuOIQkkaAaCTvJYxN9IQpIJavP7+fRaHx2+MONd3KQ07pAy/ZiStjYRtq+DAhjN
	dwgtRgmAHi8Vogy/U8m7I4aiYfA6lZ4M=
X-Gm-Gg: AeBDievEMjgQd3ExM9XCIlxSGmZD/Kku6g+1DD1E7qRmtThc/67Ir4NOUviedQL4qPb
	nRIZ6F6oHx74wFUlgiY5QF7cBEtjy3RaZY7S+Qu9gnHI7lX+KQ/xoSylp1bQhnrIG5PhwT/bnWZ
	CNRq+gm7NsXtFPvIybSSzfXTFXvOrV4QInWSCJL7narbWSWZpQMRm/h5qL8N+7X4R3rW6gaV/Di
	RRHLJsRhMb/pe0fsYcIM45TTsBzAfI+novaiP1G9XPDGjcDXeqQT1HgVN1uK7Ox5giGdtIB9ETq
	MfZL/kc0u5Qf3tJS
X-Received: by 2002:a05:6000:4283:b0:43d:73ff:fd59 with SMTP id
 ffacd0b85a97d-43fe3db9bc9mr6846919f8f.10.1776454525489; Fri, 17 Apr 2026
 12:35:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260331123702.35052-1-john@jagalactic.com> <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net> <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net> <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com> <aeHpjpNN4TliZOyp@infradead.org>
In-Reply-To: <aeHpjpNN4TliZOyp@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 17 Apr 2026 12:35:13 -0700
X-Gm-Features: AQROBzCmeJrVtq6kS88NntBxYwuWq2p8m5V_NUCivAWMbSPdKuP6DBJLkBWNmVk
Message-ID: <CAJnrk1a7idWN4UNpW0P-X4xeBKOkhnR+Mvfo3QW38OfShiwpKw@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, John Groves <John@groves.net>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, djbw@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 1:04=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> This is the first mail without annoying and pointless full quotes,
> so chiming in here.  Sorry if I missed something important in all the
> noise.
>
> On Tue, Apr 14, 2026 at 03:19:36PM +0200, Miklos Szeredi wrote:
> > On Fri, 10 Apr 2026 at 21:44, Joanne Koong <joannelkoong@gmail.com> wro=
te:
> >
> > > Overall, my intention with bringing this up is just to make sure we'r=
e
> > > at least aware of this alternative before anything is merged and
> > > permanent. If Miklos and you think we should land this series, then
> > > I'm on board with that.
> >
> > TBH, I'd prefer not to add the famfs specific mapping interface if not
> > absolutely necessary.
>
> Yes,  fuse needing support for a specific file systems sounds like a
> design mistake.
>
> >This was the main sticking point originally,
> > but there seemed to be no better alternative.
> >
> > However with the bpf approach this would be gone, which is great.
>
> So what is this bpf magic actually trying to solve?

It is trying to avoid having famfs-specific implementation details
hardcoded permanently into fuse's uapi and kernel code. I really like
your suggestion of adding generic stride/offset multi-device support
to fs/iomap. That is a much better solution than bpf.

Thanks,
Joanne

>
