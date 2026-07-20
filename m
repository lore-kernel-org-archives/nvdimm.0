Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75033E00A1
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 10:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784542073; cv=pass; b=Xw6mNE+erJ6hcaAMJLpZDdhPNhysO8vTRDTb9qlzdUly6Ye/z/H2nNt+8f1TGCWAukgsB9JYLXhjbYSpaiqk1c57AJ5q2P2QnhO6T0rYyYNye9+nHcIrLLOFBlyjOLDFyCzhaRxQj+83P+2NGwbs03jHVzgVwFP9wTHiePU9FJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784542073; c=relaxed/simple;
	bh=0rQxBYeUI9kccjQsg7LlbwcyM5KH4xYI/FlafZxUfTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DkFT57d9N2XIe7skeEgeIv33YuycDHTUlRigRvwD6LnnUW3spyj1OrTNUU0Ko8EfqXb2ccfHj7k/fnqVIvVy/+xX55OEQp5JXGLv3FPDeOPkc1Ui9EhSawqHhZg7TAKnjDn5MwOq0VDg+wYv+BZkCsSHnZmQ10Ztp3TgKu0jeII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wy0K3d4t; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wy0K3d4t"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-69c5f6f7a40so8816082a12.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 03:07:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784542061; cv=none;
        d=google.com; s=arc-20260327;
        b=AC8/xspuSgjW/E3klUl2xW/yI2HfGhhnSJtBwVEtIHpEx14Z1MBut4PWVYo0t1pUoq
         AEXmeL/XmeBgkPyo5+sjzzv51dtrllv1pZ0GXIVDg/oynEDS58g/uGUKhd0ISNi2Xz9Z
         2sCg1tWOJGq3Kfb7BFObTssXeYx9pfo/aWJ/4EGuFJ/3Jz3/9rqz6zy1LqqBm9VdPnLi
         5pZszfRhkEaOTyhLsxnhLD9oAh8PemRo5aIPQiaEcfvyftC1ZtO99qhLQqLN5eG8q8tj
         XZMxQ6CCa1c6Q5/ziddBpsusDzztjDTIEneyGHiJkcA3SQUdJWdKPlZ8yVSOG/ViCa3V
         1Fcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MCCq1AIeKXMGUk+k9l/Opmj013LJUPQC31Mm1vW63VU=;
        fh=9hrtqAItpfKsxhV3lbUSa36i36URM4AIybXHvPBCNY8=;
        b=sZwFd3zRY4dIIARce4lS2QdP3B8qpLbFyQNnRehNRUQeiSZchVHOechgZaG9J0UDJ9
         d3Kips14rY/AGe5BbBjko5vhXVONwZ08XZAzgsmzAgbHQf/gfYiV9ITv6E6XkbkSiP7B
         2sR2cvsjMGw6oxbQ3NKXfjYMLrYlZEIWNW7Jrjf/6W7SQaFU6U/2tFg8LdoqGIICJM5l
         RFysTOZ7OaXOv7xI6/1Hho6e5zzjUM3/21nXY5IGb6IuGtJeSrTy8QOFGD1zHiBZlu5z
         ObJ1D+tkbtGxOzmAl00cMeYGPSGZno86yPYHDGtGYujrRSNZ8uK3JBmfzm1RmFNF+5g+
         K5yA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784542061; x=1785146861; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MCCq1AIeKXMGUk+k9l/Opmj013LJUPQC31Mm1vW63VU=;
        b=Wy0K3d4t/kP9gfNr0Js9wo8GQdxbtw0m60JPUHcaUQxpZ4I08BgH5W43icAqZ2bjGv
         Jpp8LdtmxeJQGjtGxX4teDm+I0wnJwLNU8Hy0O6A743Zyam5OX8XEDp/SMiG/ludARyy
         diilEcByllG1+bGKBtLk7lizrzGu+O1pwRQwEcPgsiMxjIa9wcxZy+DiclaALWKqcEiG
         dgiBekeKRzLLZTTY6xd5N7DzWACAPYTMjZsVjuzLPbj3RW1XZ5dw/xBXfoWZKV8Pthke
         tahm1d438FvWU66bSheFcVMkOEpncKSIqKVWu6AO14WktorxqglqVAa+Hp1SPfbzhOle
         V+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784542061; x=1785146861;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MCCq1AIeKXMGUk+k9l/Opmj013LJUPQC31Mm1vW63VU=;
        b=P8Ygzw/bOFRi5HZyOsSnPy6+GwiUQqJsstefcZ3HA8xoxk0MMb3jAVa0dray6q0mfv
         K7fZuF1uuufTRzOjO0kNxI3Z7ylFvx6HCmVCpoN53aRz1ecWAwQAfKaYXiiE5QnUg+lA
         489HXRtZPVRoWyyZplPFOHTWwoVAySGRVv5kAhNLFFuEBQKmkAzS31A7KGBvlUDuNg1i
         tNVJW+/1TNsZBfKWyYdOj0gULK+nsPhaTw4VFHZUpGS6tF/GwyujE5+5SUk4PQuQe32D
         WJ0gDCXvavJsAwMUurzKXwJHplsb+DF6BPqXkzsa0IrDWL2lnW3FoEwqpmCVQX6fOves
         t8Ag==
X-Forwarded-Encrypted: i=1; AHgh+Rpy06IAcEjqUsIWFRY2ftIhlhtcrHSecIgnTtDo/LM+LamQemKCLufm7cPQUXGHgfpQocuJtqk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhPwRbmRMrnx3wI6+zQhre3MbwEHbg++7kuguakyh/EK/148hr
	PW8rtRDrUxWqcMJpc26BCH9qkDdhPbNIbD+vaqtUotSvV52YJOG760QIXJKF4Pkeqq3OfZ7nzZw
	9XyJtq1y0j/PHKBlu19V2IG4WDu5Hp1k=
X-Gm-Gg: AfdE7ckxOF461l2DZvqJjBWOZimj4tYcGiYGCI3XYhFY4Rji9a2KAvpO1U4QMdcWzJ7
	Evq5OA0qP5WiLTxC7rCWPdysnkt3fvM/GfRHsNVEpKOmjXPwDwYa2XxPywN2HCqugju9qlfxpVs
	GGc/nTmuy0qgWRJIXheaB1SWt04t4dvLqU9EDf+e52pxTH0SbgjfJANPNGdzFeDKVYKLAg3DARc
	s46SNKUgDjerc1FikMTf9OFPzgPl9acrPzDThzOezsjyyk8yn/Xg3AMEdQdxnAdP9DhtzFsNQ==
X-Received: by 2002:a05:6938:a087:10b0:c16:7969:12be with SMTP id
 a640c23a62f3a-c16b47c1e4emr338791966b.31.1784542060903; Mon, 20 Jul 2026
 03:07:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720034358.68714-1-john@jagalactic.com> <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
In-Reply-To: <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 20 Jul 2026 12:07:29 +0200
X-Gm-Features: AUfX_mz15n8tVrhQrtGTVlRLA7H7ya2xjAmCYkRT34S0zyePGJ2_WjcXc9IUx7k
Message-ID: <CAOQ4uxiEzP2e=cRw-AiGxtSv6WMSA5yR3cmgrF97s7ggU6wzqg@mail.gmail.com>
Subject: Re: [PATCH V11 0/9] famfs: port into fuse
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <djbw@kernel.org>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
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

On Mon, Jul 20, 2026 at 5:44=E2=80=AFAM John Groves <john@jagalactic.com> w=
rote:
>
> From: John Groves <john@groves.net>
>
> This has been quite a gauntlet so far. Some requests were made but eventu=
ally
> ruled out (e.g. using BPF for fault handling).

I'm sorry John, but this patch set is not what I was hoping to see.
I don't know if we are miscommunicating or if it is something else.
I will try to do my best to explain again.

I say miscommunication when looking at your comment in reply to [1]:
"First, a scope check. This patch touches only the daxdev registration -
GET_FMAP, struct fuse_famfs_fmap_header, and the simple/interleave
extent structs in include/uapi/linux/fuse.h are untouched. I'm reading
that as tacit agreement to GET_FMAP and its ABI. Can you confirm? If so
the large piece is settled and this is really just about how a daxdev
gets registered."

This was a wrong assumption on your part, it was NOT confirmed and
I even responded to it with a mini tantrum.

I feel that you may have not gotten Miklos' second patch [2] at all, becaus=
e
you have not responded to it.
Maybe because it was sent only to your work email?

>
> Concrete requests (demands?) from the fuse community included the followi=
ng:
> - Pass daxdevs into the kernel via an ioctl rather than a new fuse
>   message/response

Look at this patch by Miklos:
[1] https://lore.kernel.org/fuse-devel/20260529134302.1989958-1-mszeredi@re=
dhat.com/

Look more closely at the diffstat:
 7 files changed, 123 insertions(+), 294 deletions(-)

It's not about this ioctl, it's about infrastructure reuse.
It's about the fact that there is NOTHING special about dax_devlist;
and no reason not to manage it via backing_files_map.

The reason you stated was that you want userspace to determine the
daxdev_index/backing_id - fine, no problem - this is why I asked that
you pass it the desired backing_id in the ioctl.
In fact I think that all fuse backing_ids would be better assigned by user =
space
so the extension of padding =3D> backing_id is not unique to famfs.

And the best part is that this request requires no changes to your userspac=
e.
You already bite the bullet and maintain the new/old uapi but changing the
kernel implementation does not require this burden from you, so to be hones=
t
I really don't understand why you did not follow Miklos' suggestion.

> - Lose the famfs interleaved extent format. I have complied with this req=
uest.
>   It makes some things worse, but we'll discuss that later.
>

I am really not aware of a request to lose the interleaved extent format.
How can this patch [2] from Miklos which reimplements this format as a gene=
ric
uapi be mistaken for a request to lose this format?

> There has also been a desire from the fuse community for famfs to use an
> experimental implementation of virtual backing-devs from Darrick. I'm lea=
ving
> this out as a potential future optimization - although Darrick has announ=
ced
> that he (and $employer) intend to abandon that work, so it's not clear wh=
ether
> that will become viable.

Forgive me John, but I am having a hard time following the logic of
this statement.
How are Darrick's future plans about fuse iomap even remotely related?

In this patch Miklos has ALREADY IMPLEMENTED
"striped "virtual" backing devices (idea from Darrick)"
[2] https://lore.kernel.org/linux-fsdevel/20260601152327.2069787-1-mszeredi=
@redhat.com/

An idea does not die when employers change priorities.

The diffstat is also impressive:
 6 files changed, 219 insertions(+), 300 deletions(-)

Especially when considering the fact that the insertions are generic code
that could be useful to fuse passthrough regardless of famfs.

Let me recap the former review requests as I understand them:

1. Use ioctl instead of GET_DAXDEV
2. Use backing files infra for daxdev table
3. Use ioctl instead of GET_FMAP
4. Use backing files infra for fmaps

Request #1 was fulfilled in the v11 patch set.
Other requests were not fulfilled and with no explanation why,
not one that I could find anyway.

Perhaps requests 2-4 were lost in the spam folder and/or lost
in translation, so I will repeat my question from review of [1]:

Are there any other *technical* problems that you can point out
with the patches that Miklos posted (including FUSE_DEV_IOC_STRIPE_OPEN)?

Thanks,
Amir.
