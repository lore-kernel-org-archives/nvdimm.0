Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6E22EFD95
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 15:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776355022; cv=pass; b=FSPi0nnxtUaEkOyMD7/5TXbgO1qcH9DM+40U71ukjVJmHj7cgPxFYo6Wv3Mm+KeLP8wJ1GUTv0YtAX/5b2R4W/MJNQ2F3eRnkm6BdTrRCsDwPh99ww8KqSWFYBDCYB/ha86uccgX1A7bnicuEGL9+ZacH9gyAiSfQrztFc+txNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776355022; c=relaxed/simple;
	bh=M7gPZRMXwsKZPHEV9eSBHGyZEgE8KrtipqgPUasQvfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H9/rQszG+t/671iMH6Bqf6ajmpDQ9vo5A/vtPGIQf1hJHQywAASFREhk4Hd3C6jOGbfAQ1E2BYZzBhE6gfkVQuo+iSSYqrzDwf2i00nMyIDhj+nkZpv9lpbw0MES+l4CzlTt1jRroNmdQQjRw+wY4i5SC6u83BMTbaZ1ESH4kZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ggADf5WT; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ggADf5WT"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d73352cf2so4269127f8f.1
        for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 08:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776355019; cv=none;
        d=google.com; s=arc-20240605;
        b=NxhZn7fo2nBfOdkxiUvD8MIaF3bCGao+XxqeVXTT+NMZl3MBdboGdSOGTFuEjIoTKP
         bsxlQ9YzW+IYhfqHFwhjPQfZiRaKAMEG5j9+61Z2Vt2X4yewHwmHe0okuC0mQ0myC4UL
         O+3OFP1nJmDJxfHbfXuAzWGxrikULaX87PgPU3JLUEHF545X2kSF6zzkgFGYReezMdcF
         PIFoPo3h5pmVHIsyi3JNhy0WuWhxeguJhYBGpqtB+YenxExM60x5OmIFPs2Kor3ezyls
         ze5y4iV62hIJoQkOY4E1IZtkKsma0XnRbjpvBwu1NRTNO4CNL5kWM1sPo3URZQDVWO0+
         tanQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=csLQ189K8q+dYy5ZW5r++AMtfUplzzeY0yd9HcFl3+w=;
        fh=eIQPjFoWU6EZX82J59svVL7XEecBbvlwiwIYPnzHuY8=;
        b=XLg576GXfrFo5U8GRnM4kz/9AVme+hzXuRXSEyl2oRGwQiQfisJFBCPqa2kOTumTM2
         rPaud90U5adM2ucqhmCjJuSsH1RY9obDdzG5ddSx1sFbZ0YLWdzcbpk11jzKIs+JS/6A
         2PAkBSs9UrpWQmBpdEgKjRu/3XwULvWrjp9xOgojP1IH/Kj1dzLfJAZWwZJMmMSrAJCl
         uQhEdZ3n+jmlQBkcqcVkZA59WuHdUUEwZT7wHfCjaKZC5oUwdNOoM7zEVNY5AAXazjBL
         bfQGA/Iyp853imNMltR0ZOUjzlcTH1pQLnLLSnHd+wr6HQLyy/uz/yZrwijjzB66tp99
         I9jw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776355019; x=1776959819; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csLQ189K8q+dYy5ZW5r++AMtfUplzzeY0yd9HcFl3+w=;
        b=ggADf5WThoN5yhwjhaHTK2Xl19ev8PMzgFnnHfU2XVYi6tw+7oEB3zSnP/jgomeBe+
         eRhJCyvWzfINDR3/oXdx7IRGyrGDKxLJcMlmd0cIFcyzeeOYeFpefH/1aX2VFMD65mNg
         uBK/ZQRiRmONHHRm6qO/BORRk5PE9WMPSWybZKdFMAn7P5fLZvCICBHq4ow0puzSSZkV
         dScnUo/JAfSN23moqfDuIUs5maNpvit39TNRA6VNncBv3ND5ky0edsWsJmpKNzkgQani
         Cgs4o2DlOBPMEX5isM4lHWOBT7/avE2ZAkxE8R/Tv2Bz69ZoznXGNG6dnK9/fJoI3fMu
         IZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776355019; x=1776959819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=csLQ189K8q+dYy5ZW5r++AMtfUplzzeY0yd9HcFl3+w=;
        b=b1JJwuyjMlL4hjHNv1a3FcO0/QQ1wkgHDVXX9GyW9zO37S5N8jGE988WnyvqqNhBS/
         GSQAW51mrNVmYEPDxJCqkMZ6vgHZJzlJqPclF8bukRMPqnGJ4UhaN83MhIOJikhNqCH1
         fSmeUJziWSkndox5CqhQNSIMTPT8JWveu55D+ON+sEJOGFhJufy3/EtKr9S+U5EThNZ5
         VPbWMxLupMMeTbycEq1tLQjUILOCND4jCHKJeyw+bwhDplfKPOxvstQezltr6BvpDdor
         /EtVZoiCm3SQbGyShf9iSMKe9m9JH49FJjmAtIpNtEtAuh7PdCvzWUSSiehvCmQAudID
         M6Ig==
X-Forwarded-Encrypted: i=1; AFNElJ+ao7XXzN2GFscRtcqkBsSFHOF4hFmG22Y7IlOmo8OF0pNbAPFkrbzTNQR6Qg8aOry6mStmN3s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDBHtp3DKDHyowbWg3CnqRG295lxwbAz3TDzik3YgFW0/XB5qb
	41Z0xVs+zT4Xd12DLHWCWbViqiOh775sjPOZR7hCgaIl+YJpuK4uyE0TKV+6NYMmfi5NKzbdvw/
	7LMvPJo5XYafRood96l/G0lkFE351490=
X-Gm-Gg: AeBDiestVkuRdledppDm8veBScKhIRHg6rBjKrHdImwHw2UVyKi2V/RLka9pMXQIY7r
	Nk0c8zDq0849+Luo//Wp33nti7KmR/u3/ZSAlqun3/obtkML8NJcrMrlAvy0knXYU9fvjlk3Fbw
	dQ9ZzsYdhV1Uzi2YFzmUEv514g3lF4J7GMcjE6aS+pjxYRDjGmpBIxEl3BcT4lxg2CAJ03dpVP/
	bClUEKAXbkq5ywltKWnxCheJDedHT8jhU0Jc02s9I5iRNcrJ8+kJmfOJEcCB9OS6TsIlBWma6Vg
	cxablxs5VVs+eG3z
X-Received: by 2002:a05:6000:230e:b0:43b:3b80:6776 with SMTP id
 ffacd0b85a97d-43fe0809ebcmr25499f8f.30.1776355018514; Thu, 16 Apr 2026
 08:56:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net> <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net> <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net> <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com> <ad7Tps4tkNbndd9Z@groves.net>
In-Reply-To: <ad7Tps4tkNbndd9Z@groves.net>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 16 Apr 2026 08:56:46 -0700
X-Gm-Features: AQROBzD6FksXwOQQcM-59dk9RYoRBpTrQTtKbS5KL2H92k939UzapAUDIGOhreU
Message-ID: <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: John Groves <John@groves.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
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

On Tue, Apr 14, 2026 at 5:10=E2=80=AFPM John Groves <John@groves.net> wrote=
:
>
> On 26/04/14 03:13PM, Joanne Koong wrote:
> > On Tue, Apr 14, 2026 at 11:57=E2=80=AFAM Darrick J. Wong <djwong@kernel=
.org> wrote:
> > >
> > > On Tue, Apr 14, 2026 at 08:41:42AM -0500, John Groves wrote:
> > > > On 26/04/14 03:19PM, Miklos Szeredi wrote:
> > > > > On Fri, 10 Apr 2026 at 21:44, Joanne Koong <joannelkoong@gmail.co=
m> wrote:
> > > > >
> > > > > > Overall, my intention with bringing this up is just to make sur=
e we're
> > > > > > at least aware of this alternative before anything is merged an=
d
> > > > > > permanent. If Miklos and you think we should land this series, =
then
> > > > > > I'm on board with that.
> > > > >
> > > > > TBH, I'd prefer not to add the famfs specific mapping interface i=
f not
> > > > > absolutely necessary.  This was the main sticking point originall=
y,
> > > > > but there seemed to be no better alternative.
> > > > >
> > > > > However with the bpf approach this would be gone, which is great.
> > >
> > > Well... you can't get away with having *no* mapping interface at all.
> >
> > Yes but the mapping interface should be *generic*, not one that is so
> > specifically tailored to one server. fuse will have to support this
> > forever.
>
> Mapping interfaces being generic is a nice idea, but I'm no sure it's
> realistic in a generalized sense. But other mitigating comments below.
>
> >
> > > You still have to define a UABI that BPF programs can use to convey
> > > mapping data into fsdax/iomap.  BTF is a nice piece of work that smoo=
ths
> > > over minor fluctuations in struct layout between a running kernel and
> > > a precompiled BPF program, but fundamentally we still need a fuse-nat=
ive
> > > representation.
> > >
> > > That last sentence was an indirect way of saying: No, we're not going
> > > to export struct iomap to userspace.  The fuse-iomap patchset provide=
s
> > > all the UABI pieces we need for regular filesystems (ext4) and hardwa=
re
> > > adjacent filesystems (famfs) to exchange file mapping data with the
> > > kernel.  This has been out for review since last October, but the lac=
k
> > > of engagement with that patchset (or its February resubmission) doesn=
't
> > > leave me with confidence that any of it is going anywhere.
> > >
> > > Note: The reason for bolting BPF atop fuse-iomap is so that famfs can
> > > upload bpf programs to generate interleaved mappings.  It's not so ha=
rd
> > > to convert famfs' iomapping paths to use fuse-iomap, but I haven't
> > > helped him do that because:
> > >
> > > a) I have no idea what Miklos' thoughts are about merging any of the
> > > famfs stuff.
> > >
> > > b) I also have no idea what his thoughts are about fuse-iomap.  The
> > > sparse replies are not encouraging.
> > >
> > > c) It didn't seem fair to John to make him take on a whole new patchs=
et
> > > dependency given (a) and (b).
> > >
> > > d) Nobody ever replied to my reply to the LSFMM thread about "can we =
do
> > > some code review of fuse iomap without waiting three months for LSFMM=
?"
> > > I've literally done nothing with fuse-iomap for two of the three mont=
hs
> > > requested.
> > >
> > > > > So let us please at least have a try at this. I'm not into bpf ye=
t,
> > > > > but willing to learn.
> > >
> > > I sent out the patches to enable exactly this sort of experimentation
> > > two months ago, and have not received any responses:
> > >
> > > https://lore.kernel.org/linux-fsdevel/177188736765.3938194.6770791688=
236041940.stgit@frogsfrogsfrogs/
> > >
> > > I would like to say this as gently as possible: I don't know what the
> > > problem here is, Miklos -- are you uninterested in the work?  Do you
> > > have too many other things to do inside RH that you can't talk about?
> > > Is it too difficult to figure out how the iomap stuff fits into the r=
est
> > > of the fuse codebase?  Do you need help from the rest of us to get
> > > reviews done?  Is there something else with which I could help?
> > >
> > > Because ... over the past few years, many of my team's filesystem
> > > projects have endured monthslong review cycles and often fail to get
> > > merged.  This has led to burnout and frustration among my teammates s=
uch
> > > that many of them chose to move on to other things.  For the remainin=
g
> > > people, it was very difficult to justify continuing headcount when
> > > progress on projects is so slow that individuals cannot achieve even =
one
> > > milestone per quarter on any project.
> > >
> > > There's now nobody left here but me.
> > >
> > > I'm not blaming you (Miklos) for any of this, but that is the current
> > > deplorable state of things.
> > >
> > > > > Thanks,
> > > > > Miklos
> > > >
> > > > Thanks for responding...
> > > >
> > > > My short response: Noooooooooo!!!!!!
> > > >
> > > > I very strongly object to making this a prerequisite to merging. Th=
is
> > > > is an untested idea that will certainly delay us by at least a coup=
le
> > > > of merge windows when products are shipping now, and the existing a=
pproach
> > > > has been in circulation for a long time. It is TOO LATE!!!!!!
> > >
> > > /me notes that has "we're shipping so you have to merge it over peopl=
es'
> > > concerns" rarely carries the day in LKML land, and has never ended we=
ll
> > > in the few cases that it happens.  As Ted is fond of saying, this is =
a
> > > team sport, not an individual effort.  Unfortunately, to abuse your
> > > sports metaphor, we all play for the ******* A's.
> > >
> > > That said, you're clearly pissed at the goalposts changing yet again,
> > > and that's really not fair that we collectively keep moving them.
> > >
> > > It's a rotten situation that I could have even helped you to solve bo=
th
> > > our problems via fuse-iomap, but I just couldn't motivate myself to
> > > entwine our two projects until the technical direction questions got
> > > answered.
> > >
> > > > Famfs is not a science project, it's enablement for actual products=
 and
> > > > early versions are available now!!!
> > > >
> > > > That doesn't mean we couldn't convert later IF THERE ARE NO HIDDEN =
PROBLEMS.
> > >
> > > Heck, the fuse command field is a u32.  There are plenty of numberspa=
ce
> > > left, and the kernel can just *stop issuing them*.
> >
> > I don't think the problem is the command field. As I understand it, if
> > this lands and is converted over later, none of the famfs code in this
> > series can be removed from fuse. If fuse has native non-bpf support
> > for famfs, then it will always need to have that. That's the part that
> > worries me.
>
> I believe this basic premise is completely wrong. Here is why:
>
> There is a FUSE_DAX_FMAP capability that the kernel may advertise or not
> at init time; this capability "is" the famfs GET_FMAP AND GET_DAXDEV
> commands. In the future, if we find a way to use BPF (or some other
> mechanism) to avoid needing those fuse messages, the kernel could be upda=
ted
> to NEVER advertise the FUSE_DAX_FMAP capability. All of the famfs-specifi=
c
> code could be taken out of kernels that never advertise that capability.

I=E2=80=99m not sure the capability bit can be used like that (though I am
hoping it can!). As I understand it, once the kernel advertises a
capability, it must continue supporting it in future kernels else
userspace programs that rely on it will break.

John, with what you have in this series, is there any way we can make
it generalizable so it can be used by any dax-based server? Would you
be open to that?

My main gripe is with the layout encoding for FUSE_GET_FMAP and how it
bakes in famfs-specific layout concepts (simple vs interleaved
extents, file type, strip definitions, etc) into the uapi and forces
the kernel to interpret/process this super-specific encoding in a
hardcoded way. Is it not possible to just move this all to the server
side? Could the famfs server just preprocess the mappings and take
care of the simple vs interleaved extents stuff and do all the logic
that's in [1] in userspace and simply just give the kernel a list of
generic extent mapping information? The kernel could then just cache
this generic mapping per inode and do the lookup on fault with no
famfs-specific logic needed in the kernel. Or is there a reason the
famfs processing logic needs to happen in the kernel? That's the part
I'm unclear about.

I think this is pretty much what Darrick is doing in his iomap
patchset [2] except in his case, the mappings are fetched lazily on
access, whereas I guess for your case that would be too slow so it
needs to be prepopulated at open time. imo that seems fine since
prepopulating mappings would be a useful feature in general. So could
we rename FUSE_GET_FMAP to something like FUSE_IOMAP_GETMAP and have
it just return super generic mapping info? Darrick already adds a
"struct fuse_iomap_io" [3] to the uapi, could we just use that and add
a uint32_t dev_id; to that?

Looking more at Darrick's patchset, his caching [4] uses the b+ tree
and is more performant but imo also more complex, but I don't think
that would be necessary for this series. imo we could just use a basic
interval tree for now for famfs's needs and optimize / converge it
later.

As well, are you open to renaming the FUSE_DAX_FMAP capability and
FUSE_FAMFS_DAX config to a generic FUSE_IOMAP_DAX naming scheme
instead?

Additionally, it would be really nice to replace FUSE_GET_DAXDEV and
add the daxdev config stuff to the generic FUSE_IOMAP_CONFIG Darrick
has for iomap [5], but this one might be more contentious in getting
the config uapi solidified. I think in general though for famfs, it
makes more sense for all the dax devices to be set up upfront all at
once at connection init time instead of discovered lazily on every
file open, which as I understand it,  would make things less complex
server side for famfs too, so even if this doesn't go through
FUSE_IOMAP_CONFIG, maybe it makes sense to have this be on init where
the server sends all the daxdev device information all at once? That
seems less confusing (and better performance-wise) of a flow than
having it be lazily discovered on open, though if I'm misunderstanding
something here please let me know.

I'm not sure how Miklos feels about this, but I think this would get
rid of all the famfs-specific logic in fuse and would be adding
infrastrucutre that other dax-backed servers in the future would use.
On my end, this eases my concerns and would be just as good as what
the bpf approach is trying to accomplish.

There's some ties between your and Darrick's work as you guys are both
using iomap, and maybe/hopefully this aligns with Darrick's thoughts
combining the two, but in my opinion (and maybe Darrick disagrees with
this), to get famfs out the door, we wouldn't need all the code in
Darrick's patchset to land before famfs. In my view, we would only
need to borrow/steal the 'struct fuse_iomap_io' definition in uapi and
hopefully converge on a FUSE_IOMAP_CONFIG uapi format, for famfs to
land, if you agree this direction makes sense. I think we just need to
get the uapi stuff figured out and everything else could be optimized
in the future post-merge. Darrick, do you agree with this assessment?

John, is this a middle ground you think is reasonable? I know this
whole thing has kind of been a mess with the moving goalposts - if the
above would work for famfs but you're slammed with other work and
don't have the bandwidth to make these changes, I'm happy to help out
with the restructuring if that would be useful.

>
> Simple, really. Can't re-use the message opcodes, but as Darrick pointed =
out
> those are not a scarce resource.
>
> >
> > >
> > > > What are the risks of converting to BPF?
> >
> > I think maybe there is a misinterpretation of what the alternative
> > approach entails. From my point of view, the alternative approach is
> > not that different from what is already in this series. The only piece
> > of the famfs logic that would need to use bpf is the logic for
> > finding/computing the extent mappings (which is the famfs-specific
> > logic that would not be applicable to any other server). That famfs
> > bpf code is minimal and already written [1], as it is just the logic
> > that is in patch 6 [2] in this series copied over. No other part of
> > famfs touches bpf. The rest is renaming the functions in
> > fs/fuse/famfs.c to generic fuse_iomap_dax_XXX names (the logic is the
> > same logic in this series, eg invoking the lower-level calls to
> > dax_iomap_rw/fault/etc) and moving the daxdev setup/initialization to
> > connection initialization time where the server passes that daxdev
> > setup info/configs upfront. I don't think this would delay things by
> > several merge windows, as the code is already mostly written. If it
> > would be helpful, I can clean up what's in the prototype and send that
> > out.
> >
> > I think the part that is not clear yet and needs to be verified is
> > whether this approach runs into any technical limitations on famfs's
> > production workloads. For example, does the overhead of using bpf maps
> > lead to a noticeable performance drop on real workloads? In the
> > future, will there be too many extent mappings on high-scale systems
> > to make this feasible? etc. If there are technical reasons why the
> > famfs logic has to be in fuse, then imo we should figure that out and
> > ideally that's the discussion we should be having. I am not a cxl
> > expert so perhaps there is something missing in the approach that
> > makes it not sufficient on production systems. If we don't end up
> > going with the alternative approach, I still think this series should
> > try to make the famfs uapi additions to fuse as generic as possible
> > since that will be irreversible.
> >
> > If we expedited the alternative approach in terms of reviewing and
> > merging, would that suffice? Is the main pushback the timing of it, eg
> > that it would take too long to get reviewed, merged, and shipped?
> >
> > > >
> > > > - I don't know how to do it - so it'll be slow (kinda like my fuse =
learning
> > > >   curve cost about a year because this is not that similar to anyth=
ing
> > > >   else that was already in fuse.
> > >
> > > ...and per above, BPF isn't some magic savior that avoids the expansi=
on
> > > of the UABI.
> >
> > It doesn't avoid the expansion of the UABI but it makes the UABI
> > generic (eg plenty of future servers can/will use the generic iomap
> > layer).
>
> Um, advertised capabilities allow contraction of the UABI-handling code w=
ith
> only some small cruft. Code that is only reachable in the presence of dea=
d
> capability can totally be removed.
>
> >
> > >
> > > > - Those of us who are involved don't fully understand either the se=
curity
> > > >   or performance implications of this. It
> > >
> > > Correct.  I sure think it's swell that people can inject IR programs
> > > that jit/link into the kernel.  Don't ask which secondary connotation=
 of
> > > "swell" I'm talking about.
> >
> > bpf is used elsewhere in the kernel (eg networking, scheduling). If it
> > is the case that it is unsafe (which maybe it is, I don't know), then
> > wouldn't those other areas have the same issues?
>
> See my long comment to Darrick's prior email.
>
> I suspect that this would be the only place BPF has been tried for a vma
> fault handler. That is a special, performance critical path - especially
> for famfs. In discussion with the right people we can probably reason
> through whether this is a non-starter or not.

Yes, I think the bpf overhead is the main uncertainty about whether
this suffices or not for famfs. I understand (from the all caps in
your previous messages :)) that performance is critical. The bpf
overhead could indeed be too much for the special famfs performance
critical path. I'll try to get some time next week to benchmark this.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/0100019d43e79794-0eadcf5e-b659-43=
f7-8fdc-dec9f4ccce14-000000@email.amazonses.com/
[2] https://lore.kernel.org/linux-fsdevel/177188733084.3935219.104005701365=
29869673.stgit@frogsfrogsfrogs/T/#t
[3] https://lore.kernel.org/linux-fsdevel/176169810371.1424854.301019528091=
5622081.stgit@frogsfrogsfrogs/
[4] https://lore.kernel.org/linux-fsdevel/177188735954.3937557.841478048197=
856035.stgit@frogsfrogsfrogs/
[5] https://lore.kernel.org/linux-fsdevel/176169813786.1427432.414564085463=
311156.stgit@frogsfrogsfrogs/

>
> >
> > >
> > > > - Famfs is enabling access to memory and mapping fault handling mus=
t be
> > > >   at "memory speed". We know that BPF walks some data structures wh=
en a
> > > >   program executes. That exposes us to additional serialized L3 cac=
he
> > > >   misses each time we service a mapping fault (any TLB & page table=
 miss).
> > > >   This should be studied side-by-side with the existing approach un=
der
> > > >   multiple loads before being adopted for production.
> > >
> > > Yes, it should.  AFAICT if one switched to a per-inode bpf program, t=
hen
> > > you could do per-inode bpf programs.  Then you don't even need the bp=
f
> > > map, and the ->iomap_begin becomes an indirect call into JITted x86_6=
4
> > > math code.
> > >
> > > (The downside is that dyn code can't be meaningfully signed, requires
> > > clang on the system, and you have to deal with inode eviction issues.=
)
> > >
> > > > - This has never been done in production, and we're throwing it in =
the way
> > > >   of a project that has been soaking for years and needs to support=
 early
> > > >   shipments of products.
> > >
> > > Correct.  I haven't even implemented BPF-iomap for fuse4fs.  This BPF
> > > integration stuff is *highly* experimental code.
> >
> > I think what fuse4fs needs for bpf is significantly more complicated
> > and intensive than what famfs needs. For famfs, the extent mapping
> > logic is straightforward computation.
> >
> > >
> > > > If this is the only path, I'd like to revive famfs as a standalone =
file
> > > > system. I'm still maintaining that and it's still in use.
> > >
> > > Honestly, you should probably just ship that to your users.  As long =
as
> > > the ondisk format doesn't change much, switching the implementation a=
t a
> > > later date is at least still possible.
> >
> > I recognize this is an unfair situation John as you've already spent
> > years working on this and did what the community asked with rewriting
> > it. What I'm hoping to convey is that the approach where the extent
> > computing/finding logic gets moved to bpf is not radically different
> > from the famfs logic already in this patchset. In my view, moving this
> > logic to bpf is more advantageous for both fuse *and* famfs
> > (decoupling famfs releases from kernel releases) - it would be great
> > to consider this on technical merits if expediting the timeline of the
> > alternative approach would suffice.
> >
> > Thanks,
> > Joanne
> >
> > [1] https://github.com/joannekoong/libfuse/blob/444fa27fa9fd2118a0dc332=
933197faf9bbf25aa/example/famfs.bpf.c
> > [2] https://lore.kernel.org/linux-fsdevel/0100019d43e79794-0eadcf5e-b65=
9-43f7-8fdc-dec9f4ccce14-000000@email.amazonses.com/
> >
> > >
> > > --D
>
> Regards,
> John
>
