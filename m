Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4C73A963A
	for <nvdimm@lists.linux.dev>; Fri, 24 Jul 2026 20:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784924611; cv=pass; b=WjJ9IDTFC3ADcAK9CNA4XxP9EDz9y076YHbXzQ5WUbJy4WCvDYN11uYoj5Q7rh+6ti0+qhXhlCMw6MYnQwTnl9/2HpK2cerpvPL7j+FQ+T1LoA1Bt+iQL8qxyurA4cqII8oZhGF7IiFOml9NJ5FoFVsrjReqdigEOqxRFTRlnSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784924611; c=relaxed/simple;
	bh=CLvryJlgtOkpD04dLgTszNnfnuSEyddIT/JzxgCf0Xk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f44zIi+5m7VbJqJLsmo17rs0LuozHFyW/EFJI24OKgGywX8VS/IjDFRY+iZGY74BykrI/CieFeOJ3PPEpjEvpM8DXyJizADD0KnrtCmlzXRHjoW6gy3tT/xK1boXXa9vhMnZY3iPUhiKPSx8yrkJTik4P6XFnvBucZQx/owrfTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OCB3We0Y; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCB3We0Y"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47de008b020so567002f8f.1
        for <nvdimm@lists.linux.dev>; Fri, 24 Jul 2026 13:23:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784924608; cv=none;
        d=google.com; s=arc-20260327;
        b=Iy4XegQjlxTbXXK5kxFHL8yya9/hjYlDErltpoyoyMSaAz+IThUUmfE2B0oIe2C69H
         H52xZ6IVEkvVAn5JXjST94CSsugaAPZy+396ul/+wMzEpxFpBmrSaeKMENBMcZdKqK1J
         uW3S6cJUS5XFOHPTkHoRynZIwrtVyMV34zwmfKhv9MZ632pR5JazbCGeG3iq0vG4t6o6
         4qadNY6wrupTiqVpKjVuDAipQi5UqjnnLDeLUuX8SopNwj2OLE7yMcSijNx5R2A8yu/W
         HacTGEsTYV5BB8JMVw5RfGz9UQpDJiuoJW6iCodOVdE8pDXP+vUENMzVE3ewgo5vmXNo
         3YLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Khp2FCMG1fPFWK/vo3BDeHUm3k3OSQAePpUYhFSlseQ=;
        fh=URiAA8zTxWNCSJ11NXYbRytTKcOL1kDyg6qkMtZIkZA=;
        b=CdXaW2jkcHi2nRyGsIKdkGAtNLsWFymxqMmwp5GvbF6xfTRN+K/nx1d/J7voEunUt5
         K4tH0WXByzLRlIWua6GemflGjUp5auZn+/VegXOa1ixV6I/h6UjTmMjd1/YuMch5Teh8
         SEzHRKv//HoBFRu9SiApMGButzrMpVRceAfvzu2J5AJAl31IflP4YbVAgyzfZkKPU3Nf
         XuO42SW8tqpIFwyG53AjrLt31eiRnHY6vwpog4oFs1vmw9Gsd2PL8T63wR/B70ayiFXP
         ZpbQDhEjR5Ya5QY9gq+z8vzHHxVTcxwkOFVpslIuhpdniFWtl14Ux+E1HmgEQNmaL2L+
         ZJXg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784924608; x=1785529408; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Khp2FCMG1fPFWK/vo3BDeHUm3k3OSQAePpUYhFSlseQ=;
        b=OCB3We0YP2BymY5nV3t+OYiWGNjAIOhJA8H5DaXbjWzI7jeo6lhwvKQSMHImqS9ltb
         ewmKyQ5YDd1bO6XwT3W+px/UyVqUnAwzRbZbAp48SoZ4OJctajODJyACk8HSfpnNaJ10
         ief2ewsrcgbLIYog4uHm50aAyI4ZG+ea/kSSYWlzQ7UL0tOet3k09kZxaO/q5f9xJpjz
         nWSBEeyOTH0uJoCOhgofRvB6ZhIQOg8LuBV2PwK6l3tOZtNMS7Kuf4U4Ip/80aeUxn7H
         pFx9kxsM44VijLvnisb7UTdsF++Hx3b+MfqEwyU4s2LnhHljiQ+Rg7xrkygzDrkgkz1u
         gasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784924608; x=1785529408;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Khp2FCMG1fPFWK/vo3BDeHUm3k3OSQAePpUYhFSlseQ=;
        b=KTkTdw8ubRJCVMTCG5Ed5fQu5zXXCcqgu40Ku5UhGVl2O74Lg7PffvFi2p4G4s2Yj5
         nHmYgMv+AbY5kfgJ4uX9umRxiFIJzNDHbgk5WFEwMms7aNA0LPZhWT541glGkDRv2ELR
         vaQu3KWUVwybVc1F1PMbJaW6bD3Azwj/Gksjnugj4SrYUcZo2y2zcPP8m8XFtyU1Q6/v
         ckNRHrPzF9cTgFVJJ9bPbf1Fbyk6yFq8gw/OKDWne0tkqWsiDt77WpUHQtKMDQB36ln8
         glV6/+bAqmValblLDpHvOH3VOeBhDWVtfbqLMeVuRyWr9SLM/cKKdEpxH65HhjGJf+c1
         FnSg==
X-Forwarded-Encrypted: i=1; AHgh+RoUJ+QoEsqPm3uAKGnu849d6fyhW2AEwSKDboL4in3Ijz/uj8Jk1SSRLNYBNmHcaFa+uPCPyck=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwG9mKogQeGVW7ObI3/waRrB1n3x/0yQAG+pd57qdqAgbBYdjn
	G8P6lBAvzsfRm7HWBudeJL4S+WCYpT3ME7p8A7BwWa4ggeN/41EcznS+98j2V9txojJkwtT1yRD
	BDF/ErDHCAyUVXIV7pXfmyN0NGb6EcDg=
X-Gm-Gg: AR+sD11wNAG647cUIQTnW+34qIpqg+kUKb27BqjJbmai6ioEDL/l76IQX+zQdCN6C1v
	H0vAZuukvgCrCN+Yt/cBq9UNIeBOqKLwd+JJkVbi9MUTEZrxNJc7QMUnecLWxhmbzLchy0JuYEe
	ghcultRBAIQtzKqQmFJzklaunxfrb3S53IPFSZuWNvf0eTT93PH9al1MZEFs3IKuMKCutOrtJNd
	HZGgUK15SWfhmQGAaQAgc2XrK0ibWZXGokXxWt8IhNE+xZUwSSpLchVZK9WTwh/lkQN44nvMHMy
	vW5ffYgRV5Izumka5ZEXq6GHu2BdLk04C9suAU3nsm0E2fNjDEbm
X-Received: by 2002:a5d:5c84:0:b0:47f:8554:a341 with SMTP id
 ffacd0b85a97d-47f9cddd94amr2609691f8f.13.1784924607527; Fri, 24 Jul 2026
 13:23:27 -0700 (PDT)
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
 <CAJnrk1Yat+SEr=SmZXwUt9y2WcC0VEC4KUpPrkrRSjMEmx42WQ@mail.gmail.com> <CAJfpegtnja6tkOnNPD2WZxu14Dd+UM9AvynsVB_E268iSXLbkQ@mail.gmail.com>
In-Reply-To: <CAJfpegtnja6tkOnNPD2WZxu14Dd+UM9AvynsVB_E268iSXLbkQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 24 Jul 2026 13:23:15 -0700
X-Gm-Features: AUfX_mydRGom_LxmLbEq9SuIROw4SCUO4oftMjn0zu5GW5N5sw4eN8rSuSzGEXw
Message-ID: <CAJnrk1a9mR-6hFie3hfFRgWTkrhJMVx4j9e7WGnjTRFuX2iJOg@mail.gmail.com>
Subject: Re: [PATCH V11 0/9] famfs: port into fuse
To: Miklos Szeredi <miklos@szeredi.hu>
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
Content-Transfer-Encoding: quoted-printable

(sorry for the delayed reply, was OOO yesterday)

On Thu, Jul 23, 2026 at 12:27=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Wed, 22 Jul 2026 at 16:43, Joanne Koong <joannelkoong@gmail.com> wrote=
:
>
> > I had the same impression as Amir. The FUSE_DEV_IOC_STRIPE_OPEN patch
> > [1] right now is only for the interleaved case to handle striping, but
> > imo it seems a lot cleaner to make FUSE_DEV_IOC_STRIPE_OPEN a generic
> > interface for handling any backing layout that corresponds to a
> > backing id, and having the simple extent case go through this same
> > infrastructure / path. Especially since John's future patches for
> > adding the interleaving will go through the ioctl, it seems nicer
> > server-side as well for famfs to have one consolidated path instead of
> > needing two totally different ones.
>
> That's a valid point, but I still feel that those things are different.
>
> Striping:
>   - always static
>   - size limited by the number of devices
>
> Extent map:
>   - may be static (famfs) or dynamic (general block fs)
>   - size is unlimited
>
> Doing extent maps with an ioctl makes it clunky in the dynamic/unlimited =
case.
>
> > If not the ioctl, what did you have in mind for a generic interface? I
> > think anything else would have to keep GET_FMAP, but maybe I'm wrong
> > here.
>
> Good question.  A NOTIFY_EXTENT_MAP (similar to Darrick's
> FUSE_NOTIFY_IOMAP_UPSERT, but multiple extents) would work, I think.

This sounds great to me.

As I understand it, the merge window for 7.3 closes at the end of
August. Just to summarize, the only things needed to get this into 7.3
(besides addressing the Sashiko comments) are:
a) replace FUSE_GET_FMAP with FUSE_NOTIFY_EXTENT_MAP (will also be
good for famfs in general, saves an extra context switch)
b) remove FUSE_DEV_IOC_DAXDEV_OPEN and reuse existing
FUSE_DEV_IOC_BACKING_OPEN (logic for this already supplied in Miklos's
patch in [1])
c) remove "config FUSE_FAMFS_DAX"
d) remove FUSE_DAX_FMAP capability (not 100% sure about this, but
since the only thing added to the uapi is a new notif type, seems fine
to exclude this cap flag)

Is this correct? I think with those changes, all the
famfs/fmap-specific definitions will be cleared from the uapi.

imo these changes seem doable for making the 7.3 merge window. I'm not
sure how much bandwidth John has though. Maybe one idea that could
work if John is completely slammed for time right now is having the
changes requested above be a separate followup series someone else can
do and then this current series (after the sashiko fixes) and that
series can get landed together in the same merge window.

>
> Maybe the striping setup can also be done with a notification.  The

I had interpreted the FUSE_DEV_IOC_STRIPE_OPEN patch as implying that
the mapping gets forwarded to the kernel through the backing id in the
open() reply, which I think is how Amir had also interpreted it. I
didn't like that the striping mappings got sent through an ioctl while
the simple mappings didn't, but I think maybe the patch was not trying
to suggest that and I had interpreted it too literally. I like the
striping setup through an ioctl - I think it makes sense given that it
is connection-level instead of inode-level.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260529134302.1989958-1-mszeredi=
@redhat.com/
