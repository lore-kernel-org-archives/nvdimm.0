Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494139A7FE
	for <nvdimm@lists.linux.dev>; Thu, 23 Jul 2026 07:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791624; cv=pass; b=QjvD/KZD2FjAd5W6G7AMYJkqoUi9PvzHDsnl0pfG5wr9oEWO99VOSQnUow7+5+Aot2cBXOsPVOJMIpyqmqRn2404ys+6DzDNXOloGxS7q5taTUxERSTTYZDcj9uAMNOoJq40T69HqOf5/D+L7wRX2tn+FCrR6GS0n7vSdWAP6do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791624; c=relaxed/simple;
	bh=b//sUnMrNPrgR6EPqqnROk2FSBW3tccYwHVa9XOhJ0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bY7G7Mz8h4gOE3CK548+MrEaTPsX7P64D6tUJduB/grbZabMciXXqrmxTFtUwAcqycNSPK9LasHkut6rhRxqQe9kLkJUwsPKSLpOlTRRbn+TjbNc+lplAlTHWo+n4s7V467b1Kx41fzCxh7/ICgWMG6TAWiuDQnEkbvpmihCPwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ifwqHt/W; arc=pass smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ifwqHt/W"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e50a650a0so25670985a.1
        for <nvdimm@lists.linux.dev>; Thu, 23 Jul 2026 00:27:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784791621; cv=none;
        d=google.com; s=arc-20260327;
        b=aPcVDPZj4b7BKfk3KmDAevBGceA5lr2xxg0x8Xx5QsYohMSYu0SkuzkA/TcrQd58VY
         JDZRsu0P99gJ3VEvSfPO+tO8ZZnfvhRJjG2SA9I2+RtqOWiDRJTLiFXKmQDhpLeArM0r
         xaAi+BIN4hkXD7fKVzcCLM1+v3kyyVTlAbf7rgQzDyTV82pTsRzxhBeJmp06dS+wZlFm
         zGpuiEFp3cVEzNohzzr8Mup7JpS0qojSNJ6TUUYz0OajriWlt2y0Tf2rZfmoEA9heEEZ
         antNnxDyCqQ9GKW97x+A7MvpMaGVng/ZRjxQRRd63LnRLTkFiy35tcU/J1AzwZmACLY1
         z+XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fxFO3X4XqUIh2d5y311IhLxWE4w0WxZ2aZSjb8KpjAY=;
        fh=BNtIZQGtYEM0zyEvXQupciKbnAEUQqT7at4qXJiEi6I=;
        b=G80rAsaNhdMyxAlha77tadrJMbbuINQYJdGjNeEdS46gkMxMbcq69nCMmknV31EHdo
         h5fVXTYFEnIy5D8GL71QA0WRl5xa+8/qcBm33efQW1CvIzrTNkqBBz0B8ntIE+yjt/Hj
         7s0i+UQdDy5zjONtD0MLFLodROA+8YYji4I5+sIKOorfzkLtYfzAQ9BBbdAZyY32P+sU
         AYEwstUTs48BOSfG6Xo0WE8q0ahWEM6joh1bbTIYZ3efdXS/MuQJPpqlGK8hohhN6gXP
         6A0nXsWeUBRoSFqEozZ4q5L7+bUny5Mfxo5G+LF2E0GtLzxadOpgUIl3wzbASh6R8hDA
         L1hw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784791621; x=1785396421; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fxFO3X4XqUIh2d5y311IhLxWE4w0WxZ2aZSjb8KpjAY=;
        b=ifwqHt/W55wPd4Lnq0xdWNU8ww+SIa2oD7hSl6nSREaB5EAY4iFGq5HvxsW+P+/RQY
         ADRskkgt8XnCb3S86alVGZ6F9IIw8H1saT0UpKZkZ+0+bHqrx/+iTGR1IrKjM+9GAbQa
         mQhggvNoAvv3yS8a/MP2GOmsgUuMzuEAzZGmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784791621; x=1785396421;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fxFO3X4XqUIh2d5y311IhLxWE4w0WxZ2aZSjb8KpjAY=;
        b=C4LMDn+UkfHPAPaLW0cdN5Ghcu4OOsgPypulvq5Ip7th7WAHcAxE59kZV3rsGYPalu
         biGZdAyWF9w4Ltje/97h7ZIzXS1fAMUkBy/tnInNI+WkNbsigN4h1x6VjmwQHEqPFIaJ
         flid86J6xl5UL8C2Roa+GBfB8iUWO8HUQI0S0rMztx/uKoEkXTPWsXkw1byzMXsGYa/0
         HG2UGRdg+gnFe90BKM3e+/B4jrmQG6A+cYLo33YJZLgWoe70utMDiTw/eHznly1GcCZA
         jWSyedOQvDxNG0EP7dD+LSAIedahcOPTgpWBns2v2cMFFfT9xouHKnOrPsdiLUaFyifQ
         lGMQ==
X-Forwarded-Encrypted: i=1; AHgh+RqccrydB0VOaTAXy1Iuy2Y2P+EW76ZMquLM5NmneMJlFt/HjbLF0+jf3fskXaWFi0zY+M5qOhE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyM4InJGqHPwvzSeY7foqOEhbAPYRgyVN5r60cKSuRzx0agcUA2
	1c0rxU0uaGQ4zjWyJlXwm1lHe8SUlBH9YJRU9ut4YH9JiQaVGupysmOienHn8j03tokpHB0bQwh
	44l1iWK8Tj81H8EubKKDdOf9LAJCuS4RBVQtDF+daqA==
X-Gm-Gg: AR+sD12MSQID3ZhaRli2AcGW/smuJZXRGg53su1bM9qvLLyAJoYLbpMKU1h+h/LjVb8
	bWOPSElxj3qi5bDoFZl74+1KYsxKFu94/DaFg+Yi9mGmPjS9N6S6WuCY5uVc79g4gTQWEjIsCwk
	4Na3I+yw2Kmdzl2aOjmyO0VpErCDrf3xrhvTo18Jo+l7rMyFLgLRytFedTlJv3cAJtYnHsUPwhb
	EdefKnKGVcjpt0Ea4+55hceGGaEJgAg/HjZDufzAJA43z13fy1fQW1pu4RmXzORhQ25vhrbLEA7
	4ozDXVMM1NlXF/H3bg==
X-Received: by 2002:a05:620a:2548:b0:92e:bc28:5479 with SMTP id
 af79cd13be357-9310384ec50mr192569785a.2.1784791621432; Thu, 23 Jul 2026
 00:27:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720034358.68714-1-john@jagalactic.com> <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <CAOQ4uxiEzP2e=cRw-AiGxtSv6WMSA5yR3cmgrF97s7ggU6wzqg@mail.gmail.com>
 <CAJfpegt9PwHksYhsQZeCsW0eooXVVihyieTpeHMmC-+Pq8BWaw@mail.gmail.com>
 <CAOQ4uxhuivjMMt_Dm3VwKmOhHg7ZHdAww6j6jp+RMjPoRde+bA@mail.gmail.com> <CAJnrk1Yat+SEr=SmZXwUt9y2WcC0VEC4KUpPrkrRSjMEmx42WQ@mail.gmail.com>
In-Reply-To: <CAJnrk1Yat+SEr=SmZXwUt9y2WcC0VEC4KUpPrkrRSjMEmx42WQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 09:26:50 +0200
X-Gm-Features: AUfX_mzfzrRwI4hZxEkdZS2OluMEiPX8JQa0b2ZxVMGEYubjhyQzQWfbCHdsQ4U
Message-ID: <CAJfpegtnja6tkOnNPD2WZxu14Dd+UM9AvynsVB_E268iSXLbkQ@mail.gmail.com>
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

On Wed, 22 Jul 2026 at 16:43, Joanne Koong <joannelkoong@gmail.com> wrote:

> I had the same impression as Amir. The FUSE_DEV_IOC_STRIPE_OPEN patch
> [1] right now is only for the interleaved case to handle striping, but
> imo it seems a lot cleaner to make FUSE_DEV_IOC_STRIPE_OPEN a generic
> interface for handling any backing layout that corresponds to a
> backing id, and having the simple extent case go through this same
> infrastructure / path. Especially since John's future patches for
> adding the interleaving will go through the ioctl, it seems nicer
> server-side as well for famfs to have one consolidated path instead of
> needing two totally different ones.

That's a valid point, but I still feel that those things are different.

Striping:
  - always static
  - size limited by the number of devices

Extent map:
  - may be static (famfs) or dynamic (general block fs)
  - size is unlimited

Doing extent maps with an ioctl makes it clunky in the dynamic/unlimited case.

> If not the ioctl, what did you have in mind for a generic interface? I
> think anything else would have to keep GET_FMAP, but maybe I'm wrong
> here.

Good question.  A NOTIFY_EXTENT_MAP (similar to Darrick's
FUSE_NOTIFY_IOMAP_UPSERT, but multiple extents) would work, I think.

Maybe the striping setup can also be done with a notification.  The
original reason for doing  FUSE_DEV_IOC_BACKING_OPEN() out of band was
to prevent security issues with writing an fd with plain write()
syscalls.  This issue does not affect io-uring, which does not use
write and so the ioctl can be completely eliminated.  But that's
another story..

Thanks,
Miklos
