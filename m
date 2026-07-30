Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5067C3BFE5A
	for <nvdimm@lists.linux.dev>; Thu, 30 Jul 2026 20:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785445170; cv=pass; b=i4BhLqQUzh5btDEfppoQHo3UP/k0t+pYtC3rW+g8fPwoXOD/VD8Lz9Yk5MySAxlWbXxjAz+jz+LJrZ8b8DwojO+WFPpyWhjTS/WJYwVeDSV19mcDW8y9zzhIbtI9+tEHinbB85F3Gbiemqxf2XzDEM54+R3K6j4kdxYKyCIfdPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785445170; c=relaxed/simple;
	bh=TjfWFjcumtGogPzfLKW4RhkCh9Rhh17DgLYBpsrtvDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T5gRv1Ei2PfPrJ12qambXyCpPAPetr0oTfRkH2+M38Q2WSA2LornTEkSopxfCYNpTxJP05pMDMQJq/hWyZN76/6yIXsJDF8kWokJUarh5inzeAo8uERkGLaAeRIxV8Hna6/zhCFsZyZ2wK2nOxe0jApsUp4X4XiaC55aw1Kf/1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qUj+xBkt; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qUj+xBkt"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49550ec592cso7807465e9.0
        for <nvdimm@lists.linux.dev>; Thu, 30 Jul 2026 13:59:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785445166; cv=none;
        d=google.com; s=arc-20260327;
        b=QGobdrbBNL3UiW4upvRrRztApH2cOXn8MJBj/tBFFDy9zYn/bP28L6G50xFwfnJhQJ
         92hO2XqpMLqCrx4/LQ8I3eEppfAQcRVfRr5Bb4LqJNUp5Dpj3gJ+YXTShX9vdWS9Oj71
         N5ftPmPzdYTIipeNPQgFMHCHmC+Z516y6IVEjqinuoZUZ2jGXFHzSYIaspOkk0xojBMX
         aI33ttqr9iQ90XJFoGD+w1bWMo5k7xOhJXQjwpZAk2MH77t1DRKdKW8MWtm3jd/6/9SE
         YMZzoLMh4NAXw9U/5hzTTu64KVNuZ1WRwiMxYO11XqmGZvnjz7jFONiDEjLPWiwGIvHp
         x0gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TjfWFjcumtGogPzfLKW4RhkCh9Rhh17DgLYBpsrtvDg=;
        fh=u4J8rL4lReXEjizbuz5mTe3Qx7E51jtb2iqhW65zZzM=;
        b=IGVCgAWFc47ab4poObUejaxkOL+q7glR4Lg8MJkttrQhH0cmM6J7uv79vgJfqgql1o
         pWCj1OAYJq0TBLRDfLqI4P4b4inmqHvG2YIxvF1Tc3SSWARXznDTUt0c5pNMUztyxxF+
         tDgCsh5H3zRbcyYvLKlNe4EqkPUt4YmbNpCpbjbiXf+Djfr76fPqrpVbmmTvltOJ2FMO
         zLGEd2roASBgvy5TStFTCIS4nX0slDZtbbwSwdahm6h5Ev+uPPWuFY6oEEq/nt23wLur
         BOVYodAXeuMMi1R4amCMKu5miV75YSBFOwJuZ3FjSC2TEBFaJyA8tCyNSXdKYYYsK1Cw
         Ymeg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785445166; x=1786049966; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TjfWFjcumtGogPzfLKW4RhkCh9Rhh17DgLYBpsrtvDg=;
        b=qUj+xBkt1s+FJCmxbwynogwR7jNaEiHV/5H1dI8NAaPJkWFswmJTRG2xzdVR4uPHH5
         NX5xX+CEJ60gGdxsv6mNftLD8WrSIJ7NJpNDlp2v53zPyeuTR97CKPAvU3LHUesfujPY
         v07hPmZtBWnR9TdZ5sUWWf4YxZOlGEu6wcvp1G77zji+8A7UqY5eY8iJJiMhDDgQoy3c
         wl2XUSuBfRmqV4NgLKXFpE6boisCsI7xuoiAWRqHtTNi1NIf84WmQa9gMEbxDIxPaYLd
         zbm9oZ6ehJ9i0no7m1ll1iiBafRmlYef5p0abtPIPdaa1Pi9nas8qJMvHC849Bpjrq46
         PgHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785445166; x=1786049966;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TjfWFjcumtGogPzfLKW4RhkCh9Rhh17DgLYBpsrtvDg=;
        b=IDsW2mhqzf6GFzAG1N4U1sG1V1/05BwSDaETDeKpA0pItv1PZD9cFY6gSJT88gUBa6
         cwXzqDHF3ETxTTPkCxnhOHLrq4gH60AYhELBrdxzqgLLrGeorCBBxhmuSxRL0blVOXbO
         fr1eBOQML8TfXMuXUOqsgZJDwJkWFDg7Wz3k6SFAo4hMjGRyFS96oD2q3Rylk9NkneSV
         JBUsZnY6J7Y8KBTKyrQpEe/bot26APTInN/b5WEtthwK/35HL10jIQVLCsxXaWCQEvSs
         bnUCLsmZgskQdegxTAAUs1ACLHuJwsv74Cq6xqLekuQPdOHsSPRpbK1H1VQj95YWqh3B
         MQ8Q==
X-Forwarded-Encrypted: i=1; AHgh+Rpcbfs+a8vWngCPN0XhvDGKCkH1cMfFMrWt3bEyQX6PJiXyYf3JDZDZWwLs1baXtluKXEgyFIg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFcof0+YFdha0qqOha7LVfc8kdL2G8bdqjeIwR8ukzA+6hLruM
	S16oDQmmwMZUvEw+Fj4gDbU6wNW1vnmrJDidJNbceNfOsxFOquUFa1tCUahzdPiBkRj+vlsKMla
	mAsSH9+SWFLxhzd41zuLDxaFVJfj5zWA=
X-Gm-Gg: AR+sD10Y7SsQSub8F0VRUoL7tnL2N2h+kK6TNqoMqdBjwOmm7Fg/zoKDcwUSU21knYX
	0Kjc4VsYUJvXdAqbA1xGKlzHaODWeOycjg6kUoq/7/0COnwvRvpU62iHYUTvUNPttdROyKatkbj
	EJlve/a3zd34CmzQOhDE8mvNb/GFNPvIMdS4LptPQ7flEVMBbg5PtK2hk/ZQ0yLMB/W1IMS1VAA
	2u52EXthQgN89YboNkdB2r4f/gms/DWx19bgzKaIHhtUkrseywlO472jUxnwh1llBXiw8RK3iAk
	G0kUIN/VWHSEsrtI1aYr+34DDUOSIuyFEu+8csU4SJTfepOMMAdvAk4RB68myi0HN5Ovg/YkHfH
	c14o0YQeyUyIcbkraW2HZb5zp
X-Received: by 2002:a05:600c:5641:b0:495:50b6:5a6d with SMTP id
 5b1f17b1804b1-49804c4cc7bmr22571485e9.12.1785445166339; Thu, 30 Jul 2026
 13:59:26 -0700 (PDT)
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
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 30 Jul 2026 13:59:14 -0700
X-Gm-Features: AUfX_myiGnqGNN965xypoyGuHF_KvdnF6l6Z1HdJgtyCUEVPa6_UpbiR6bYul1c
Message-ID: <CAJnrk1aj4B-T14SMTZhst2XsjOkKWStUj_0cjwHswgYWWuaB4w@mail.gmail.com>
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

On Fri, Jul 24, 2026 at 1:23=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> As I understand it, the merge window for 7.3 closes at the end of
> August. Just to summarize, the only things needed to get this into 7.3
> (besides addressing the Sashiko comments) are:
> a) replace FUSE_GET_FMAP with FUSE_NOTIFY_EXTENT_MAP (will also be
> good for famfs in general, saves an extra context switch)
> b) remove FUSE_DEV_IOC_DAXDEV_OPEN and reuse existing
> FUSE_DEV_IOC_BACKING_OPEN (logic for this already supplied in Miklos's
> patch in [1])
> c) remove "config FUSE_FAMFS_DAX"
> d) remove FUSE_DAX_FMAP capability (not 100% sure about this, but
> since the only thing added to the uapi is a new notif type, seems fine
> to exclude this cap flag)
>

John, is your intention still to get this into 7.3 through fuse? If so
and if you're pressed for time, I'm happy to take on the items as
follow-up patches to your series, if that would be helpful.

Thanks,
Joanne
