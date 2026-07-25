Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4417F25B094
	for <nvdimm@lists.linux.dev>; Sat, 25 Jul 2026 04:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784952106; cv=pass; b=r7gKA+qt6yV2TOBUjW13qtEmeEAp5CiuuTTTaAHNuhvI9HGwxfyRYWTOQHWPaNMINpThh+eE4ncyfub5EW85RydccgStNqwWnF+3d4X+NeOUBeO73lPM+DAyJ4ejja+iMXe4gWwBSjbgRTXIu03HxOgwCrvYU4SjAdvzd3er4ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784952106; c=relaxed/simple;
	bh=fNC8wElaBgCywizq8gsw7GvnGpxJrTKPY2EQunJ50fQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mUqQn+/mNlh+TObpWCPAfXD4ClXFuX0Joh34HFLae7PvH6keG4kR8nD+Qsc/FS5pTmHnubqBSSJ9XdvBVS1/SDyJQAU6caaUOnI1mMJUQrSsbCZhjSXpGk0tJMwJQaRgnXEEFj01mbIjTxLCxln0kMybJSwkCpy1TdMHO/uQyY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=O2DhqZ0k; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="O2DhqZ0k"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c0ecfaee7so8879941cf.0
        for <nvdimm@lists.linux.dev>; Fri, 24 Jul 2026 21:01:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784952103; cv=none;
        d=google.com; s=arc-20260327;
        b=O4m5Llt7pi3AIzmaahdGJvmuqll9W/Y/+bd7Hr/U4ki3OlF48/2qD/h8zKjMlplGkw
         7EV8PHyA5ELp4ftRycPYq8CONufMMt0aT8cC9Z6HKRu3KDmIfwtY4EVCS0xzEgGK3WNz
         6NU+Kfi3dzOIrXqHP2i0RafQoKbnRhHZLdD54ggCB0SKGO1qK7gZ02xtjg11vr6WLtPG
         de9B5urUQAEDFajqtQXfCKYS+Y5jrxE83pCuY0dQ1TO6oqII56uiAB5Qv0L4vSz4bHYE
         1+lxKrK6AysyxV5S4/M3WPZ+mOta92WIp0raeonGfzShNxrbyBJ7ttON9R94SQYHizi0
         NjtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CzPMjf6pORP572iHiiQv3possHTxsjbSzVUS0tfn1HU=;
        fh=ea+t3qf0GAx8lckc6TMPFqgYcZD5YQU41RK14t1PBaM=;
        b=bDNhao36QR3qn7m8vn158hhn5NPJna1szwm4V1+pDgdqCCZv6xrcWTfj1tUtUR4HmL
         fHmFpM/fH5gyJ4K31nJld7QKwMmtYNyPiEK36O+pNbwvceuH64dUk5oR3aAP/mBUpoMy
         /H5D2S+RmsNPtRqqPCTWWRJidzZA4yz0/lAhcyywFGyVkzrLXlpaTqdlteWe4kTrvfM2
         NSHWlEhLiXn3AQUs3x2iVXGTRsa3zesIuAJ9qTBCjCREaQbSMaQDnAjUsnX2qhepuYQv
         ldMsp9lfDkgXbdnF3BEtHUDpbFxKiPebgxpp3/bu0Q7RDclIDxOY7ezBL4eI4b8Cyh5U
         jcjg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784952103; x=1785556903; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CzPMjf6pORP572iHiiQv3possHTxsjbSzVUS0tfn1HU=;
        b=O2DhqZ0kZTf9mGFscZhDUZtEF2p0Kiwltncd/zusqTv5JHaFoL7EyW1VQ8JlJDbElM
         kMiMbQm4swIlTePAJBvw5JqVC/N2BKdHjTq18BRHnIYuWh/7abDFnz2oMnsKvAXJ39qb
         pbN5fnA6kVCkp1iy8N7cUGhm8l/o4BQmBMges=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784952103; x=1785556903;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CzPMjf6pORP572iHiiQv3possHTxsjbSzVUS0tfn1HU=;
        b=eCTB7RD8yABS4I8dr9j7hSaLUZ2cooJFDZOjI9c0Qs//NonZ+h+v/ht6ftlN6JjL7R
         hUljc1BlCR3Fo0M5N5JDLvKmv0//WqQdXfnG38M/7yeyBX3AaPlniAd/muIHGDqqUjrC
         twvFp50VctbaPotkEasxZYiZ2uQqAgp0x1ZHFsPs1gJWHvQyqwHc7+ms6871VG2el/sw
         iPj2nmQ2g2ty6C/FdG47os43YswlseqpS5xiI8gnrcjF2GT4SK75vPfJYgRkvi7rcL+S
         O62DOwzkCmbQPZUoVBbZLnSD1Q289SJ7DaROmDWWywoD14pe6itvg4qzry3MyIo3N01X
         bhCw==
X-Forwarded-Encrypted: i=1; AHgh+RqXZvmHXJ7ZelD5vf4+2FNRgp/WCLypKIPNDXpbVtbBcver2OxFbWQx970ZR1xH9jMjPDOA9VU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1gv2cprbl/0yGsSUQUknYg0vbU3nuUGISazFRyi9UzMAoZS2R
	l5LIv4lmnkrPeQwYN99lp+vY08yOiwPVudOBRZ1vtNH9fu0/s2tGe1kv17HkknaJZW/LlL2QBNg
	Sy+KbYuq0m05jeBIjX5Ng+x8aQe0WxC7xMii9h6sDrA==
X-Gm-Gg: AR+sD11hUgOFtrBiJsoEkMQ6PM/6dEx3e9IgjPnk8GsTuYvX3wuJSu3J+i2+BsWJrQF
	V/BffvcvVzaSf7MmObWFYtHqLGQd1AReiNvPDRhRN/zBr1nK8Bild2ECYOSTU8TuPHphciazt8D
	wKCXqdaUphVjZIBTJcUnXQYjVcIFsZyEPTmoOT4FYfLLb5TI7yZWOuv+uoXGKuO6lVqZWLcGpQw
	35Y2sTxLZ0D13eLuntNm2iIdPB0L5FaKecWe8a4keeZl/3DRN6cx2t8ti8yO7+U1AKHXJN/t8JN
	a9Q7tcoNuFD1SCc9
X-Received: by 2002:ac8:5c90:0:b0:51c:7b12:6001 with SMTP id
 d75a77b69052e-529a8714e88mr10045521cf.77.1784952103086; Fri, 24 Jul 2026
 21:01:43 -0700 (PDT)
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
 <CAJfpegtnja6tkOnNPD2WZxu14Dd+UM9AvynsVB_E268iSXLbkQ@mail.gmail.com> <CAJnrk1a9mR-6hFie3hfFRgWTkrhJMVx4j9e7WGnjTRFuX2iJOg@mail.gmail.com>
In-Reply-To: <CAJnrk1a9mR-6hFie3hfFRgWTkrhJMVx4j9e7WGnjTRFuX2iJOg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 25 Jul 2026 06:01:30 +0200
X-Gm-Features: AUfX_mxAcvr2jX4Ns3aulDhtsSqUabRQhwz0VnV0bbRi_FBtOFn1nR0cN_FIRKA
Message-ID: <CAJfpeguEptz4sEXq=pBWPFop--1kTDu5p2yZnCyzXcrZ28Nekw@mail.gmail.com>
Subject: Re: [PATCH V11 0/9] famfs: port into fuse
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, John Groves <john@jagalactic.com>, 
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

(Replying shortly as we are starting now on a two week journey.  Won't
read email during this time).

On Fri, 24 Jul 2026 at 22:23, Joanne Koong <joannelkoong@gmail.com> wrote:

> imo these changes seem doable for making the 7.3 merge window. I'm not
> sure how much bandwidth John has though. Maybe one idea that could
> work if John is completely slammed for time right now is having the
> changes requested above be a separate followup series someone else can
> do and then this current series (after the sashiko fixes) and that
> series can get landed together in the same merge window.

I'm all for it.


>
> >
> > Maybe the striping setup can also be done with a notification.  The
>
> I had interpreted the FUSE_DEV_IOC_STRIPE_OPEN patch as implying that
> the mapping gets forwarded to the kernel through the backing id in the
> open() reply, which I think is how Amir had also interpreted it. I
> didn't like that the striping mappings got sent through an ioctl while
> the simple mappings didn't, but I think maybe the patch was not trying
> to suggest that and I had interpreted it too literally. I like the
> striping setup through an ioctl - I think it makes sense given that it
> is connection-level instead of inode-level.

Yeah, the striping setup is on a different level (like we have with
regular filesystems).  So I think it's not that bad that the setup is
different.

Thanks,
Miklos
