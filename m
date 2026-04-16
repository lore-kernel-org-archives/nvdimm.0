Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BC737B03F
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 20:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776372827; cv=none; b=JjmIwYLqRgqB32/Yv0F9skYLctJs6L69P3oyq4S6d2QuZ+230rguSl2g79gwrpA3JT9rw80KJLgPgBNgg9IM1zYNiwCUPAEqMPLqvXFgoOemgJN9+heWnEBUWv8zbLq0EP6ytH1LlhmIsywAR7OEvBIdLyi0NRRi5f1I1vfhZME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776372827; c=relaxed/simple;
	bh=WrSs9D3ajaYKuB8EpBEH6JutRpPV1nePztytUV2eiHs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=TL0/xa1I7EqpZ/Ag2sjgfGHL3nazMGHMS1AYSDoC+Kf2IQoGrTCbWiWWIM3A8xibkqwKAR8GVr0Cd1BoJkflCXDCLif9C+43Ps5u3SQ3jeQ+i046J+jWj/ocRUT2YdP0SKTjeS1PzgaPSEOWRbvPW9VBN2n6IMUlYEifD+ioFDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJnU0Bu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJnU0Bu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6835DC2BCAF;
	Thu, 16 Apr 2026 20:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776372827;
	bh=WrSs9D3ajaYKuB8EpBEH6JutRpPV1nePztytUV2eiHs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=iJnU0Bu9Fp2a4IIR6Uvsn5yEJALrEieeyO07X5igdL3nn6qyrINXnKXSa3sj15F62
	 oA33VKZ2J79rZ5PSVroqNFlwwwfE6HyZ1eQbwxOfexBReNtzIjGYeoLeb8TDckm+35
	 zwU9rlcRGvlYnzQkYay/xjkeyJMsshTM5etYg3la6zc0dnEmJf0u9xUZa3szmd7sJl
	 x9oQfxlQ53kEEZRdoANKMaFiJEzGS+bGYBNLgST69LOP0X8CRXtLnE9j+GcVaGQOAT
	 xZkii60w11Mht5DOBn4/V+ysXrUMpHKn/3BJCGIvP/Y8oLB3TaEf11Dr3J6SIW85c3
	 G8frIdEoqrH8g==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 879EAF40068;
	Thu, 16 Apr 2026 16:53:45 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-02.internal (MEProxy); Thu, 16 Apr 2026 16:53:45 -0400
X-ME-Sender: <xms:WUzhadGIqbMa438SrmTsmjCl787G0xIJFBw-Qfs109qRystEsMhcdQ>
    <xme:WUzhadLaVQq3x-NOPV0-M4W52GGMuR8O3vGFT06GtzhIa47z5SLO1wMNoh-bMbGy0
    zJuRd-9hBTXvfPtQV-jAVs_02CvVZxMChloGmRT5Iuk0-kTD-v3rWo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegkedtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdffrghnucgh
    ihhllhhirghmshdfuceoughjsgifsehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepuedujeffveegleegkeeiteefuefhfeekvedvgfffgeehgfehleejgeejveffgfff
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepughjsg
    ifodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqddujeejvdeftdegheehqdef
    feefleegtdegjedqughjsgifpeepkhgvrhhnvghlrdhorhhgsehfrghsthhmrghilhdrtg
    homhdpnhgspghrtghpthhtohepgedupdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehshhhivhgrnhhkghesrghmugdrtghomhdprhgtphhtthhopehjrghmvghsrdhmohhrsh
    gvsegrrhhmrdgtohhmpdhrtghpthhtohepsggvrhhnugessghssggvrhhnugdrtghomhdp
    rhgtphhtthhopegsshgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtoheprghmih
    hrjeefihhlsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsggrghgrshguohhtmhgvsehg
    mhgrihhlrdgtohhmpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrd
    gtohhmpdhrtghpthhtoheprggtkhgvrhhlvgihthhnghesghhoohhglhgvrdgtohhmpdhr
    tghpthhtohepshgvrghnjhgtsehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:WUzhaUwKZTaAAPCUuJbPycDNZtQTCaP5juc11oOQ_1ue4asARW8VGA>
    <xmx:WUzhacSa6JiaRRPSepxGapcMKy5oSkaT1H4l4bNDaWe8SKtRLa7SUQ>
    <xmx:WUzhaW8ydo5n2xptH7g8nlrQTbCn-CaM0Do_ErMzA688EE0yzRjvKQ>
    <xmx:WUzhaSaB-i6fI32eV4MloL7qa2UnRU28gl_J-sIw6CckXihQQmHOGQ>
    <xmx:WUzhafq-9M3Zbr2c10ckJ_IZsgALgwKX-sf8gzQ9MiuLBfCJrNbpvG_K>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5278B2CC0083; Thu, 16 Apr 2026 16:53:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 16 Apr 2026 13:53:27 -0700
From: "Dan Williams" <djbw@kernel.org>
To: "Gregory Price" <gourry@gourry.net>,
 "Joanne Koong" <joannelkoong@gmail.com>
Cc: "John Groves" <John@groves.net>, "Darrick J. Wong" <djwong@kernel.org>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Bernd Schubert" <bernd@bsbernd.com>,
 "John Groves" <john@jagalactic.com>,
 "Dan J Williams" <dan.j.williams@intel.com>,
 "Bernd Schubert" <bschubert@ddn.com>,
 "Alison Schofield" <alison.schofield@intel.com>,
 "John Groves" <jgroves@micron.com>, "Jonathan Corbet" <corbet@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "David Hildenbrand" <david@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
 "Stefan Hajnoczi" <shajnocz@redhat.com>,
 "Josef Bacik" <josef@toxicpanda.com>,
 "Bagas Sanjaya" <bagasdotme@gmail.com>,
 "Chen Linxuan" <chenlinxuan@uniontech.com>,
 "James Morse" <james.morse@arm.com>, "Fuad Tabba" <tabba@google.com>,
 "Sean Christopherson" <seanjc@google.com>,
 "Shivank Garg" <shivankg@amd.com>,
 "Ackerley Tng" <ackerleytng@google.com>,
 "Aravind Ramesh" <arramesh@micron.com>,
 "Ajay Joshi" <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Message-Id: <43d36427-4629-4712-a262-391e64006eb5@app.fastmail.com>
In-Reply-To: <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
References: <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net> <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net>
 <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Thu, Apr 16, 2026, at 1:14 PM, Gregory Price wrote:
> On Thu, Apr 16, 2026 at 08:56:46AM -0700, Joanne Koong wrote:
>> On Tue, Apr 14, 2026 at 5:10=E2=80=AFPM John Groves <John@groves.net>=
 wrote:
>> >
>> > There is a FUSE_DAX_FMAP capability that the kernel may advertise o=
r not
>> > at init time; this capability "is" the famfs GET_FMAP AND GET_DAXDEV
>> > commands. In the future, if we find a way to use BPF (or some other
>> > mechanism) to avoid needing those fuse messages, the kernel could b=
e updated
>> > to NEVER advertise the FUSE_DAX_FMAP capability. All of the famfs-s=
pecific
>> > code could be taken out of kernels that never advertise that capabi=
lity.
>>=20
>> I=E2=80=99m not sure the capability bit can be used like that (though=
 I am
>> hoping it can!). As I understand it, once the kernel advertises a
>> capability, it must continue supporting it in future kernels else
>> userspace programs that rely on it will break.
>>=20
>
> FUSE_DAX_FMAP is already conditional on CONFIG_FUSE_DAX, the kernel is
> not required to continue advertising FUSE_DAX_FMAP in perpetuity.
>
> Setting CONFIG_FUSE_DAX=3Dn does not mean userland "is broken", this w=
ould
> only be the case if FUSE_DAX_FMAP was advertised but not actually
> supported.
>
> If DAX were removed from the kernel (unlikely, but stick with me) this
> would be equivalent to permanently changing CONFIG_FUSE_DAX to always
> off, and there would be no squabbles over whether that particular
> change broke userland (there would be much strife over removing dax).
>
> While not a deprecation method, this is what capability bits are
> designed for. Same as cpuid capability bits - just because the bit is
> there doesn't mean a processor is required to support it in perpetuity.
>
> They're only required to support it if the bit is turned on.
>

Right, if the protocol on day one is "user space must ask which method i=
s available", then userspace can not be surprised when one option disapp=
ears. So to give time for the bpf approach to mature the kernel can do s=
omething like "famfs and bpf  mapping support are available". In some fu=
ture kernel the famfs native option disappears after a deprecation perio=
d.=20

When folks ask 10 years from now why this ever supported optionality the=
 explanation is "oh because famfs enjoyed first mover advantage to prove=
 out fs semantics layered on dax devices", or "turns out there are some =
cases where bpf is not fast enough but it still stops the proliferation =
of more in kernel mapping implementations".

Something like FUSE_DAX_FMAP is always available but the backend to that=
 is optionally native vs bpf. ...or some other arrangement to make it cl=
ear that native might be gone someday.
