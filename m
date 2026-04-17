Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36C73612F6
	for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 09:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776416834; cv=pass; b=TtRI7jk6AwFxchi2rT9wVBxgQ2AjIPh7pdPK6yuVS2XIM3QEEuuUyry146FotiCMMQZ2lTugAa08ktxgTdQEDTGnSRK6GZZG+tkoSQhwc1U/JQnC5AGZmS6UqqSV8d/AT3Sw/5TpuicgwFSuhcYyyVBSENgfI0TSs/Qg9eOQq5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776416834; c=relaxed/simple;
	bh=5c9bOfL9xX1M5qYLTtO6chvkErafEILwQ1Vq/seoipk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ExutuLRPYjtezWQhZgc2eFS2hg+PFWe58xWPZrTD8GFzi99Z25UxUYYi1A/YDmjyCxls3L1wfNwpWAdZ+89NZPrmWZfS27RYRmJt06lUSJ73u0zzmSs01cNXuhy3MzsKNEcOzxfT8vKgvo3EH8vAhkSEVG8iGf3kHWddYAoHMbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X7FR1e/c; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7FR1e/c"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9c11eba219so58384066b.2
        for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 02:07:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776416831; cv=none;
        d=google.com; s=arc-20240605;
        b=J89TMds49w2Uz0YJYcMRq+9otCNGC+hDkwONJnvva2msu4nzdWE+B/Bg6vobx4FmIr
         0n5WaDliDgjeSkGmHE+MhbTGgOzVWPL9WxJp1YjDgj0l94sHKAnTssrgvAs2GpU9eyfc
         fLIXTvJ+T5SYIvzBHmCoNMZhl5YgUufHnFTEHCGsbu3uo92RKsk1n9HHE+fEDuTOIw1c
         SOEZiHoRfEbPiZbBGlo8z2AC+aBfxwoBxAQ5w3jy8mhwRv3iXO9sBSMu3MNVBglMjhz/
         ZzzfCsOyj/32j4iR9qUzWtIOUOAeUlMuFWnfdktwH/0H3mFwBFIaH8MPPK/R43LIzj1S
         dIfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5c9bOfL9xX1M5qYLTtO6chvkErafEILwQ1Vq/seoipk=;
        fh=MsIaF4hG9fHhVJllZNSzfLt5yfJWifhvC0I97Sq3yj4=;
        b=bG7Dg8dp20Dgse6JnKjJdXLkZy4pG6GcRZoVHybyynhm7f8IfaZc1wWHN6LikBHuXP
         u4Dkrscx3CxPBdH6F30gSkoIVI9DFQGHb1rmh3FNYyfXB2cOJrUcccJRQIvOzC9uZAlK
         WMWoGyqc2UvMEKlbdevyDEdp1ii5S/Sq/HJFn/GspW4VTHdjMvuFNmRR+nIIKXcS7WrF
         RQmnO+/PDATklgyUp3n2N1Owoyx5/PrbeLTPD+opJACu+UGwI3wP8XxpHOGvAggIDBoE
         Sis/IWkCT5E3s3SgDD38ZBDfnvy8xyeTJ3VKekI79DJWu6+qXU9R3kzlC+bB8OvngJri
         lOIg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776416831; x=1777021631; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5c9bOfL9xX1M5qYLTtO6chvkErafEILwQ1Vq/seoipk=;
        b=X7FR1e/cIrZ4HLNtx8Rr009+tBWudFxGfyRN1lF9Lq6Tuipn5nq+euvaEfsezXUa4a
         9F0N/bapVS8NmS1GgNT00xtqyQSQavQdCKgN138b6WXEhUjXll0hjn3UhQBwcdreaufu
         svqP05KqCCuquhaNCsCh5BuyZP8yA5yQIqAMKL6sDFckN4zBYOuTuuq0ZryrBeJQDPAU
         /57MwAnzRP1UBkGh+sph8BzkGLYpXTgt9TVPw1IAH4qtX+pSRfZLc42Qgz6GzFBHq/+V
         fvGPGNPgmw5VDt/Sk2wIamhqkU9ahqworoKdQ+Qg1UWjnDeJf02xZNUDBzl+Z4vknNNr
         tocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776416831; x=1777021631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5c9bOfL9xX1M5qYLTtO6chvkErafEILwQ1Vq/seoipk=;
        b=DSWEyj3HJivJxXwGXT7vmCgBMu6J9WErXf1qyolFVPENm0emQBdx5VkUGtmKnK2HV1
         dFviUfgZENEMP7jZgnfFVkSFs+oltNykm9RU9h6feunW58E/Qw/yi6bnkW1F0pGe6E7Y
         nG1AS8WEHKxmfk3OowiTETpmlQnaZbiKRMEBrgjVP2y7p4kYAbet4xAQHzPagZnrsl/G
         +I0Iji50KTcWgzd2FpH+LgoZHCKO95cHeoTP7TxpLfW4fgft5StAed+Me2PJxq1A6Ltb
         fYz94LDMGrUnYvp/fckkLq2By6HfCfEj61ij8wpZbwbo/1Wv5CQPisFWCVU4wMV33jUK
         snBQ==
X-Forwarded-Encrypted: i=1; AFNElJ8B2Blurtg4Wirlhbmz6rkgm/lMIuD4P13oRSgdViXI96aewd9D4fEt8ADOviRk78OjTD+KsKU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLGJfmkTKAk6hL+xyGoPdQTsdDrRVOHKfi7cv4NTawov23mhAk
	jIqlL7n8cyoAUt9ayCF4Sca9cZb1qouNxZnsCAaZmhjNpCZDM4nCCfw2kwkAkgusrNNfhcqz++W
	u1FK8FkDDgK7jeM+8/9XC7SCjCU5AVuU=
X-Gm-Gg: AeBDietXGJISc5y5EFG9AHHUBB5b1vT9KriQbjx/WVbiK6dPCYDew8n4f/bY6UZMOHX
	dlQn2BK5NnsgiJt6RfggE2qVSyBia5P5qGoWpJ+7Y6tcSMLqkzdsRhE5LWmSJdK5KRrRvHJ6Je5
	IhUP97aP8KXoTnaPyRaQ26S0md9NgAGsKtaLMcG748aqBZfo9gDnloOi3zM11QGRTaFrbnuKRwc
	E2CDt9SMx3nA8XLBqgnAJ6dP7LgNWU2XBgckEIX5dCGl0pv3NttdbbooyE8uA6WmuNhF09wRVxK
	Bk59yT46AWP+Oaex67xSvxKYmwKkghAgB0aTzQIi4I8fj2Eu0hYw
X-Received: by 2002:a17:907:742:b0:ba3:55bb:c380 with SMTP id
 a640c23a62f3a-ba41afe9047mr107433166b.37.1776416830641; Fri, 17 Apr 2026
 02:07:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <adlBcwJjLOQDAR65@groves.net> <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net> <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net> <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F> <CAJnrk1ad6t6CJV+xnXwhoNHrHYA3htuaVdDq47FeT60cPBzj7g@mail.gmail.com>
 <aeHXQ2EW2ivlLb_N@gourry-fedora-PF4VCD3F>
In-Reply-To: <aeHXQ2EW2ivlLb_N@gourry-fedora-PF4VCD3F>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 17 Apr 2026 11:06:58 +0200
X-Gm-Features: AQROBzD2EP6ID8hIkZ19dTfzX26KpQgRIz65UgWPtyN4gSS439LCb3U6ka7SEj4
Message-ID: <CAOQ4uxhXTTyySG3tXnqNnP0edbbwUxfeeC7=CypDSyw_Mod48A@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: Gregory Price <gourry@gourry.net>
Cc: Joanne Koong <joannelkoong@gmail.com>, John Groves <John@groves.net>, 
	"Darrick J. Wong" <djwong@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, djbw@kernel.org, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 8:46=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Thu, Apr 16, 2026 at 06:24:02PM -0700, Joanne Koong wrote:
> > On Thu, Apr 16, 2026 at 1:14=E2=80=AFPM Gregory Price <gourry@gourry.ne=
t> wrote:
> > >
> > > I worry that this discussion is going to turn towards implementing a
> > > solution grounded in parsing arbitrary formats and how to store them,
> > > and that is completely detached from why FAMFS went this route in the
> > > first place.
> > >
> > > I question whether the actual issue here lies in the interface APPEAR=
ING
> > > more general purpose than it actually is - and therefore inviting
> > > attempts to over-genericize it.
> >
> > Would you mind clarifying this part? Are you saying that the interface
> > and logic is *already* generic and usable for other dax-backed
> > servers, just that everything is *named* famfs but it's not really
> > famfs specific?
>
> Yes.
>
> If you just find/replace "famfs" with "dax_iomap", the structures
> here don't really seem all *that* crazy specific - they're just
> optimized for memory speeds instead of I/O.
>
> There is a circular nature to this - FAMFS figured it out first, in
> what we think is a reasonably generic way, but we can't know for sure.
>
> John, Dan, and Darrick have all proposed reasonable ways to hedge
> against the obvious fact the interface will not be perfect - which
> incorporates your BPF proposal along with a reasonably straight forward
> deprecation path that's not always possible in other arenas.
>
> All that while solving a real (and novel) problem.
>
> That's actually pretty damn cool.
>
> I would urge you to consider these proposals earnestly.
>

Apart from your suggestion to replace s/famfs/dax_iomap/
the fact that this logic sits in fs/fuse/famfs.c (or fuse/dax_iomap.c)
is the other big architecture issue.

If this logic was to be placed in fs/iomap/ as Christoph suggested,
I think the rest of the UAPI issues could be sorted out.

In any case, considering the sheer amount of discussion on this thread
I have scheduled a cross-track FS+MM+IO for Famfs and DAX iomap.

I wasn't going to include Storage people at first, but since Christoph
mentioned that stride/offset iomap could be useful for block iomap,
I included them as well.

Thanks,
Amir.
