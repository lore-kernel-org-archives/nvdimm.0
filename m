Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BF21E1C11
	for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 00:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776386683; cv=pass; b=pbHvedbCuokGRLx4yd1U0FlTf6qTXdFpxYl5Egt2hTBembDu6h8THUWiJCNjTjVep8hOel05HM47hkI94kNZCzz7rK1r7cWZqoA/QCR+2sMIixucpgSkAdL0k73izPbjsChjExVzu1XaNZkivmbgGePOY588Od3KOrsNL1wWSxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776386683; c=relaxed/simple;
	bh=tCpq6Jo4S69VtWgQOHfdZhHmPAn9f34q/hcA9ixHo38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iC7KeuVhllD9Bo2v3/RBm52vpV26a2LEWOl8V3Z0cscb3bCa1zIIi5eihIxu0AZnY5hM6d3GfW4GYA7q1gn8dOLkI2Oen8bARpiNYaAEsNiwoH/CddlQzK2kufvg74CoAbD29UuA67tnYWSBinNiMhRHwpnC/3v5phTOpn7BIsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E9NvsMuP; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E9NvsMuP"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43d72875729so36142f8f.3
        for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 17:44:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776386681; cv=none;
        d=google.com; s=arc-20240605;
        b=BqRAsZq23aMjAu0UnXwbZW0L9Kqje7YLY7VY3MecWpCI/yZR6xmlf+ic6ObHzw/Obb
         7Nl7HNS7ByTBuBHItPuV9+/F5fYyJS4tFDVjMxD62F1Mka0/P6Q/cdsQLk8esGVw9TCy
         e3WOT0wHXqT9/9R3tlW0+LxyehAcvloxdbwLRmtca/zQlZCjgDkyJotUcXvtSZtMOcuc
         QH3jmhEPOA5ycJ7S+U5KK2oKkvd/Rl+qY1vrmFWpig2TECSPoFE/wseNL4Di5sgQpq0p
         kVXLOHPMJtv9DfLwRe80hTtJKTevpGfenpuQZ2LjtZLZ5EUw4W0HTz0i5QBTeGqmuHxk
         Hj5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QaHD4Pp5DEt3l7q3lFH627j4dWsMdcfeRieD1J/u6kI=;
        fh=4V08u6u95E+BUBKlkLMueBLLHLiV+VRaEVBHEQpxjpo=;
        b=N8oTDjcZkwsbVpw/lmHYrKQ8vMv1XPzLcYg9UNIbxwOD+MQixqUuIgWs659kKop3Qt
         QDfMXfkGHqumSraFeWuGMAw9XJogUtQnjPUYdfy0S7faAcv5Y9E5EM2OvXKLYttIe4t/
         xgp0Kjj0ukuGMO8QREvawqnVmt3BWovlrzLHvG/lp+7Zh+PtG6kqcPMOiKvTEVf9dfsn
         S87R51u/peeJU6ODRVKswnS2sU0eTNKrs6ZnzGeQyUGkEtUOeJChuFQdL3Tf0KakdZ90
         jkjMMtfT0khigMDaLoikpErlKLyWBvOIXLiuuQjPZte2X16LpqNKrZlT6pZ4lUsuC8l0
         rMYw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776386681; x=1776991481; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QaHD4Pp5DEt3l7q3lFH627j4dWsMdcfeRieD1J/u6kI=;
        b=E9NvsMuPOnK8G6kpaRRk0uNR5UWYW2PDWY0NRAUrHkyV4kTtwFAZgiyT7BVJQtZrQl
         Bw2LO2FTI5MlHooTy4TzFkTGLoY4iIhlRiziszNWbX7QXsZGra/nXngO2pIHBH+kqKvQ
         LL4QN+/LaWGuhnjhjIAXH+BbNGpuEb60kAXqGGxl+HHAeA18iyPP69WGIHhC/DVkC357
         6hJTKuNzhkD+kjB8wq4o1CcTvb62hE7Zhl7LJwk0Zpn2CjhywHyln3ULNqzmuKTPNzis
         uuBt9Kuq4WxRlVM9Qi/XRknA8erk8DxQ9Dxqq1fz3pt8A40JKA7FtO2THYrq7m30lcC0
         8kZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776386681; x=1776991481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QaHD4Pp5DEt3l7q3lFH627j4dWsMdcfeRieD1J/u6kI=;
        b=iGx4Qvb4ZDvLyiFg1MPz0QHnAfXZP5Y7qEUYqzIUuBSC9ihCiZqggJb15911CNv2W5
         sJ1SbRlBL+SmhremwCXnIuULlVpVKfOP7BfsYi/QDzwfjlsW0pNqA/Lb1qcrNVN3VZdB
         q9tTDpw9hhoTbyfOj8XF00xFKu1cfQ8zCIthGpnbZPwgHnLjFfeTRx610UVIUNbrMtvR
         L664P/L9c2MOgCnHKcIYliILDXrbpC0x5Hu4Q780hJ6V2tDTLcCff3nga95/PMkEe2ou
         QzDzJqzEAYtWBnbA3Cf3etDYs4FbXitpfOtX53RHMrBG+jJth24rCwRYT5pc+9v/uWc+
         Go7g==
X-Forwarded-Encrypted: i=1; AFNElJ/sVYWF70mJNWAs0Rf0ZQpQ3OXIjs8+RE67/C+N/UIS5PNm+/e2cLpfIqfygz4eWngZ9+hG8Rs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxB+XjqWFq+icN5LfRqsIcxv/DVhZO9mPJw+m8XWvGjK/l87iQQ
	KiQMq/6s+2cn8lPJ+GfGtTQ0O6xcGeLm6BiBJIqUSTbIS8LFVCVeMUxir+w7IANkfZCJ2ADWrIZ
	RB5UKkUdqTF2o6YV0yqjrusq9Q83q7hw=
X-Gm-Gg: AeBDievHFblNpNgv1Y07rQ1lLgB/NMJqF55TIbs/XwP/ziarcbsEYBsQKNJNX1BXAYe
	7cvUk0icguQw2g1aKEpFnPt0Kg6jET0pC6hOKsPaRtkIU+QFJ5XwGiOsGdkjzFUeDtYcNHFylc2
	Hlb13iwHErx6rZyqZ/xXEJGmLEjo2IVZjN/tzlvPf0z1cU41bcsaUlJu1Xvw+liXJYc+ygvX4D+
	/IP1moDrwBcnxL80AXhTxB9wphUNwlrhKLsBCzVYxAytWy0ha0lGRhHla50LJhzBTQvyo5wmh4r
	o9yp3sH/wD/2VL8S
X-Received: by 2002:a05:6000:18a3:b0:43d:7ba4:6b5a with SMTP id
 ffacd0b85a97d-43fe3df25a7mr841359f8f.22.1776386680466; Thu, 16 Apr 2026
 17:44:40 -0700 (PDT)
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
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F> <43d36427-4629-4712-a262-391e64006eb5@app.fastmail.com>
 <20260416224331.GD114184@frogsfrogsfrogs>
In-Reply-To: <20260416224331.GD114184@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 16 Apr 2026 17:44:28 -0700
X-Gm-Features: AQROBzA3h7bYhqR2C0MA-hMnz-JkcDiwwSJMMG8OlWk7w-ds2Ru8gPIaaDYL4u4
Message-ID: <CAJnrk1Y78UGLyAGVjiQ10PERTz1d2qcimok6bqCquy7jQYaXag@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <djbw@kernel.org>, Gregory Price <gourry@gourry.net>, John Groves <John@groves.net>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan J Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, 
	Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 3:43=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Thu, Apr 16, 2026 at 01:53:27PM -0700, Dan Williams wrote:
> >
> >
> > On Thu, Apr 16, 2026, at 1:14 PM, Gregory Price wrote:
> > > On Thu, Apr 16, 2026 at 08:56:46AM -0700, Joanne Koong wrote:
> > >> On Tue, Apr 14, 2026 at 5:10=E2=80=AFPM John Groves <John@groves.net=
> wrote:
> > >> >
> > >> > There is a FUSE_DAX_FMAP capability that the kernel may advertise =
or not
> > >> > at init time; this capability "is" the famfs GET_FMAP AND GET_DAXD=
EV
> > >> > commands. In the future, if we find a way to use BPF (or some othe=
r
> > >> > mechanism) to avoid needing those fuse messages, the kernel could =
be updated
> > >> > to NEVER advertise the FUSE_DAX_FMAP capability. All of the famfs-=
specific
> > >> > code could be taken out of kernels that never advertise that capab=
ility.
> > >>
> > >> I=E2=80=99m not sure the capability bit can be used like that (thoug=
h I am
> > >> hoping it can!). As I understand it, once the kernel advertises a
> > >> capability, it must continue supporting it in future kernels else
> > >> userspace programs that rely on it will break.
>
> So don't break fuse servers.  If you wanted to (say) get rid of
> GET_FMAP in favor of IOMAP_BEGIN, you could alter libfuse to translate a
> fuse server's ->get_fmap implementation into the equivalent
> ->iomap_begin, and eventually the kernel can stop making GET_FMAP calls
> to userspace.

I don't think it's this simple. We can't assume libfuse is the only
way servers talk to the kernel. Some servers use the /dev/fuse
interface directly. And, as I understand it, this would still break
users who are on older versions of libfuse if they upgrade to a newer
kernel.

My reason for pushing back isn't because I don't want this to work; I
just want to make sure that if we're going to rely on this as a safety
hatch, then we can actually do it.

Going back to what Dan said about using the capability bits for
deprecation, "In some future kernel the famfs native option disappears
after a deprecation period" - what does the deprecation period/process
look like? Do you have to wait a certain amount of time before it can
be fully removed or is it pretty immediate?

>
> The trouble here is that I've also seen half a dozen projects vendoring
> libfuse so that's a nightmare that will have to be dealt with.  But
> maybe that doesn't even matter, because...
>
> > > FUSE_DAX_FMAP is already conditional on CONFIG_FUSE_DAX, the kernel i=
s
> > > not required to continue advertising FUSE_DAX_FMAP in perpetuity.
> > >
> > > Setting CONFIG_FUSE_DAX=3Dn does not mean userland "is broken", this =
would
> > > only be the case if FUSE_DAX_FMAP was advertised but not actually
> > > supported.
>
> ...the memory interleaving is a rather interesting quality of famfs.
> There's no good way to express a formulaic meta-mapping in traditional
> iomap parlance, and famfs needs that to interleave across memory
> controllers/dimm boxen/whatever.  Throwing individual iomaps at the
> kernel is a very inefficient way to do that.  So I don't think there's a
> good reason to get rid of GET_FMAP at this time...

So could we make the interleaving part generic then? Striped /
interleaved layouts are used elsewhere (eg RAID-0, md-stripe, etc.) -
could we add a generic interleave descriptor to the uapi and use that
for what famfs needs?

>
> > > If DAX were removed from the kernel (unlikely, but stick with me) thi=
s
> > > would be equivalent to permanently changing CONFIG_FUSE_DAX to always
> > > off, and there would be no squabbles over whether that particular
> > > change broke userland (there would be much strife over removing dax).
>
> ...however the strongest case (IMO) would be if (having merged famfs) we
> then merge fuse-iomap after famfs.  Then we extend the existing
> fuse-iomap-bpf prototype to allow per-mount and per-inode iomap bpf ops.
> That enables us to analyze thoroughly the performance characteristics of:
>
> a) Using GET_FMAP as-is
>
> b) Uploading raw iomaps (HA)
>
> c) Uploading a single bpf program to make iomaps, exchanging fmap-style
> mapping data into a bpf map, and having the single bpf program walk
> through the map
>
> d) Uploading a custom bpf program per famfs file to make iomaps.  No
> bpfmap required, but the setup and compilation are now much more complex
>
> Then we'll finally know which approach is the best, having broken the
> Gordian Knot of how to merge famfs and fuse-iomap.
>
> If we decide that (c) or (d) are actually better, then guess what?  To
> get any of the iomap functionality, you have to set an inode flag, and
> that (FUSE_CAP_FAMFS && FUSE_CAP_IOMAP && FUSE_ATTR_IOMAP) is the signal
> for "don't call GET_FMAP".  FUSE_CAP_FAMFS && (!FUSE_CAP_IOMAP ||
> !FUSE_ATTR_IOMAP) means "call GET_FMAP".
>
> Yes, we burn a couple of fuse command values to find out, but that's all.
>
> (TBH I still dislike GET_DAXDEV, that really should just be another
> application of backing files, and the backing file id gets passed to
> GET_FMAP.)
>
> What do you all think of doing that?

To be completely honest, this is orthogonal to what I was hoping we
could discuss on this thread. My main concern is the GET_FMAP part.
Can we make it more generic to other interleaved/striped layouts?

Thanks,
Joanne

>
> > > While not a deprecation method, this is what capability bits are
> > > designed for. Same as cpuid capability bits - just because the bit is
> > > there doesn't mean a processor is required to support it in perpetuit=
y.
> > >
> > > They're only required to support it if the bit is turned on.
> > >
> >
> > Right, if the protocol on day one is "user space must ask which method
> > is available", then userspace can not be surprised when one option
> > disappears. So to give time for the bpf approach to mature the kernel
> > can do something like "famfs and bpf  mapping support are available".
> > In some future kernel the famfs native option disappears after a
> > deprecation period.
> >
> > When folks ask 10 years from now why this ever supported optionality
> > the explanation is "oh because famfs enjoyed first mover advantage to
> > prove out fs semantics layered on dax devices", or "turns out there
> > are some cases where bpf is not fast enough but it still stops the
> > proliferation of more in kernel mapping implementations".
>
> Yes.  We're not *capable* of determining the best mechanism unless we
> can start shipping these things to users to get their feedback.  Only
> then can we iterate and make real improvements.
>
> > Something like FUSE_DAX_FMAP is always available but the backend to
> > that is optionally native vs bpf. ...or some other arrangement to make
> > it clear that native might be gone someday.
>
> --D
