Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EAC3B6348
	for <nvdimm@lists.linux.dev>; Tue, 28 Apr 2026 20:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777406845; cv=none; b=TibZ8uS7bfZLscuojf1V8ENPx2gU+biZrBqnpJ861oy3mkVuNSn18O/P4tov0lw9pqTe7JyMeNq2JNPV7UqbBD7pqs3PJy3gQrV7iIZIu8TOKK3d45sROxAxdFj6vkoSTpyIeDO0uc9bxeEVadVvXo+BJSL134BHxTFnESXWH0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777406845; c=relaxed/simple;
	bh=Q/Zc71eKTdTdLbr93FAxExF+HwAPxrqwA/WEbkEfTJ4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=hT+jC/+K4elp2whlpLZ2Ha6OrMSc3hqmGPk/fMkH8yR8lw9Bm8nENv/Bf++9eNZpNAC5Dt7vXzfGgnfR2EW6FujculAWvHEOBjwAEZi3cZYje9KdHSGA95XsjYX1XHdiIJ+3EZlhzomvZ1ES0MxxnU2j5ArT7YhAyaWeDuj6R54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=WfHQYUYi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XoYrTpDA; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="WfHQYUYi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XoYrTpDA"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9D1E97A0205;
	Tue, 28 Apr 2026 16:07:21 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Tue, 28 Apr 2026 16:07:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1777406841;
	 x=1777493241; bh=h+T5BNJXFum81OyDPpP0uu72do5WYbQzUMyniP5JULY=; b=
	WfHQYUYixWEtG1QhY2qb1i8cok5Vr9M+0k8UPTP+1aNYBaykqKiKZRHZMKcRLYFp
	1KpeD+sh+i4WO6fz+6lCE2BDAXvu8NUIOHNezavZfQpxbAfcP8ioWIbZI2pN0ZAi
	qlLtNA7MNNLhYp5NoBxlzajZno7+YfwGGmMY9UNclPID0/iA2AnM9zSAqahg8jF5
	51xaxGTRmzOliE/gaxJvUvc7Mlcd/m3Q1VonblsangscEOYrz+PPifBTHwsf+uJ/
	KR3WyCx9aawcmbiY1PZ5KxG9FbctfwXnPFbZDadpVPjWv6WrbQMUt72ELjOZW8nB
	+OeOqQDcMWeMkc2qhvwe9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777406841; x=
	1777493241; bh=h+T5BNJXFum81OyDPpP0uu72do5WYbQzUMyniP5JULY=; b=X
	oYrTpDARkjFs3tkWE64JD6BbP0ALg9oufKyvp+m0qI+vb6uamIjoMd39ApWu4e8b
	t3dacgdkGEdEB0Q8+r250IZa8wDJNbAAutOmUpDy+3f72rHYITikfiFkJw3KkhLU
	qKJslrK4tk295sIMJ79VzHd87ju+PpZDZgZeuiYxgC4jjaqMf+B1RdhJLPwns2nH
	2eAg9oCZsKOo/lmaGnGZ42EoX7WgYZ7ky9tJtVNT1rCJ+Zdm/0VjO51MJ2jLMcua
	xclcgU5V18jkarbzl+gPmAn9dcWHMzb8Y83uR6I5v/KRCnE8KZIGBBSFbLbY37KX
	dVzL8+Be3BEmuWlJEVyyA==
X-ME-Sender: <xms:dxPxaZza2h11-PYKXeZ5-5dHbq7l4vMqpfU1Y6ASLdkhA6x6VrSPzA>
    <xme:dxPxaUEQ9gGVjOlp83HzoQYeYGVxJg4eddsfguGnoR4v37Hu4hxXOB3lgu53O4MKw
    gDLRB3YXHyV5N9I1eqv_ak0OEncNRpMno7COtrI13asY1F181fnP5s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekvdegkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdflohhhnhcu
    ifhrohhvvghsfdcuoehjghhrohhvvghssehfrghsthhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhepkeffgeefvdfhffevveegjeegfedvfedvtdfgtdfgvefffffgueeuieeg
    veduteefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epjhhgrhhovhgvshesfhgrshhtmhgrihhlrdgtohhmpdhnsggprhgtphhtthhopeefledp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepshhhihhvrghnkhhgsegrmhgurdgtoh
    hmpdhrtghpthhtohepjhgrmhgvshdrmhhorhhsvgesrghrmhdrtghomhdprhgtphhtthho
    pegsshgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtoheprghmihhrjeefihhlse
    hgmhgrihhlrdgtohhmpdhrtghpthhtohepsggrghgrshguohhtmhgvsehgmhgrihhlrdgt
    ohhmpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtg
    hpthhtoheprggtkhgvrhhlvgihthhnghesghhoohhglhgvrdgtohhmpdhrtghpthhtohep
    shgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehtrggssggrsehgohhogh
    hlvgdrtghomh
X-ME-Proxy: <xmx:dxPxaVpF8GdGM6HhV3daxj-Vq9756pbdO1XTEDJz3oHVUWmfxnAm6w>
    <xmx:dxPxaY7XacatWPK3z25Zn6yiVU6smPSfV1IoJhhyYU2Dam8pJsm0wA>
    <xmx:dxPxafS4tAjgO8Vkm1cBfM0Nxxyuq5gsL6JV-jnPVD_5xXeYv0Wd-Q>
    <xmx:dxPxaT76Mf-Q3m9Sf7MLKxzBzI2Ic_XymAap_yfs2A2dYDU0lNjQ8A>
    <xmx:eRPxafCco4JpHMrhwtAMjqIm3P7GzLfXbfN0c-jq1OkU38Q8NaXd-EwI>
Feedback-ID: if7ae487a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 630F8700065; Tue, 28 Apr 2026 16:07:19 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 28 Apr 2026 15:06:58 -0500
From: "John Groves" <jgroves@fastmail.com>
To: "Ira Weiny" <ira.weiny@intel.com>,
 "Alison Schofield" <alison.schofield@intel.com>,
 "John Groves" <John@groves.net>
Cc: "John Groves" <john@jagalactic.com>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Dan Williams" <dan.j.williams@intel.com>,
 "Bernd Schubert" <bschubert@ddn.com>,
 "John Groves (jgroves)" <jgroves@micron.com>,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "David Hildenbrand" <david@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
 "Stefan Hajnoczi" <shajnocz@redhat.com>,
 "Joanne Koong" <joannelkoong@gmail.com>,
 "Josef Bacik" <josef@toxicpanda.com>,
 "Bagas Sanjaya" <bagasdotme@gmail.com>,
 "James Morse" <james.morse@arm.com>, "Fuad Tabba" <tabba@google.com>,
 "Sean Christopherson" <seanjc@google.com>,
 "Shivank Garg" <shivankg@amd.com>,
 "Ackerley Tng" <ackerleytng@google.com>,
 "Gregory Price" <gourry@gourry.net>,
 "Aravind Ramesh" <arramesh@micron.com>,
 "Ajay Joshi" <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Message-Id: <30fddcd1-ab6b-4512-bcfd-7f6d0de6fd4d@app.fastmail.com>
In-Reply-To: <69f106fd55840_12d928100ca@iweiny-mobl.notmuch>
References: 
 <0100019bd34040d9-0b6e9e4c-ecd4-464d-ab9d-88a251215442-000000@email.amazonses.com>
 <20260118223629.92852-1-john@jagalactic.com>
 <0100019bd340cdd5-89036a70-3ef5-4c34-abf8-07a3ea4d9f92-000000@email.amazonses.com>
 <aaD6yQLiyZznfAxr@aschofie-mobl2.lan> <ae6e9wYqgLkWsS-e@groves.net>
 <afA51WpcRyIMVukX@aschofie-mobl2.lan>
 <69f106fd55840_12d928100ca@iweiny-mobl.notmuch>
Subject: Re: [PATCH V4 1/2] daxctl: Add support for famfs mode
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Tue, Apr 28, 2026, at 2:14 PM, Ira Weiny wrote:
> Alison Schofield wrote:
> > On Sun, Apr 26, 2026 at 06:56:46PM -0500, John Groves wrote:
> > > Maybe I'm overcomplicating things (it's one of the things I do),=20
> > > but I'm still struggling through how to address all these issues.=20
> > > Some comments inline.
> >=20
> >=20
> > Jumping to the part you commented on, which I think was the biggie:
> >=20
> > >=20
> > > On 26/02/26 06:00PM, Alison Schofield wrote:
> > > > On Sun, Jan 18, 2026 at 10:36:38PM +0000, John Groves wrote:
> > > > > From: John Groves <John@Groves.net>
> > > > >=20
> > > > > Putting a daxdev in famfs mode means binding it to fsdev_dax.ko
> > > > > (drivers/dax/fsdev.c). Finding a daxdev bound to fsdev_dax mea=
ns
> > > > > it is in famfs mode.
> > > > >=20
> > > > > The test is added to the destructive test suite since it
> > > > > modifies device modes.
> > > >=20
> > > > Make it clear that it is added in a separate patch. (and assume =
you
> > > > can drop the destructive part too.)
> > > >=20
> > > > >=20
> > > > > With devdax, famfs, and system-ram modes, the previous logic t=
hat assumed
> > > > > 'not in mode X means in mode Y' needed to get slightly more co=
mplicated
> > > > >=20
> > > > > Add explicit mode detection functions:
> > > > > - daxctl_dev_is_famfs_mode(): check if bound to fsdev_dax driv=
er
> > > > > - daxctl_dev_is_devdax_mode(): check if bound to device_dax dr=
iver
> > > >=20
> > > >=20
> > > > The precedence check (ram->famfs->devdax->unknown) now happens i=
n multiple
> > > > places. How about adding a daxctl_dev_get_mode() helper to centr=
alize that.
> > > > It could be private for now, unless you expect external users to=
 need it.
> > > >=20
> > > > daxctl_dev_is_famfs_mode() and _is_devdax_mode() are nearly iden=
tical aside
> > > > from the module name. Refactoring the shared part into a single =
helper will
> > > > also make it easier to add a daxctl_dev_get_mode() without dupli=
cating the
> > > > precedence logic.
> > > >=20
> > > > >=20
> > > > > Fix mode transition logic in device.c:
> > > > > - disable_devdax_device(): verify device is actually in devdax=
 mode
> > > > > - disable_famfs_device(): verify device is actually in famfs m=
ode
> > > > > - All reconfig_mode_*() functions now explicitly check each mo=
de
> > > > > - Handle unknown mode with error instead of wrong assumption
> > > >=20
> > > > Wondering about 'Fix' mode transition logic. Was prior logic bro=
ken and
> > > > should any of these changes be in a precursor patch that is a 'f=
ix'.
> > > >=20
> > > >=20
> > > > >=20
> > > > > Modify json.c to show 'unknown' if device is not in a recogniz=
ed mode.
> > > >=20
> > > > I think this means disabled devices will always look unknown eve=
n when
> > > > the intended mode is devdax or famfs, but disabled. This seems to
> > > > change the meaning of mode from 'configured' to 'active' persona=
lity.
> > > > Can you detect the configured mode even when disabled?
> > > > Perhaps a man page change about this new behavior?
> > >=20
> > > Good point; before famfs mode there were just 2 modes, and=20
> > > not-system-ram =3D=3D devdax mode is the current standard, even if=
 no driver=20
> > > is bound. At some level that's a conflation, but I'll revise and s=
tick=20
> > > with that unless you have a better idea.
> > >=20
> > > Is that how you want it? No driver =3D=3D devdax mode?
> > >=20
> > > Any thoughts?
> > >=20
> >=20
> > I do think we need to introduce "unknown" rather than keep reporting
> > devdax for all non-system-ram devices. With famfs added, that old
> > "not system-ram =3D=3D devdax" shortcut just isn=E2=80=99t true anym=
ore, and in the
> > unbound case we really don=E2=80=99t know if it=E2=80=99s devdax or =
famfs. I=E2=80=99d rather say
> > "unknown" than guess wrong.
>=20
> While I like the explicit nature of 'unknown' we are unfortunately past
> that point now.
>=20
> Current users expect a new device to come up as devdax.  I think a new
> specifier needs to be added to bring a device up as famfs.  Because th=
is
> is the new way of doing things it may be that famfs needs to be specif=
ied
> explicitly somewhere.  I'm not quite sure where right off.
>=20
> But the current behavior needs to be maintained despite it being 'wron=
g'
> or a 'lie'...  It is just the way it was.
>=20
> Ira

I think for famfs it's easier than that. The famfs tools already put it =
in famfs
mode when needed. I don't think it ever needs to have a sticky default
to anything but devdax.

The following famfs operations already check and change the mode=20
if necessary:

- famfs mount
- mkfs.famfs
- famfs fsck /dev/dax0.0=20

So I don't see any problem with preserving the existing quirkiness.

I'll get a patch v5 out asap that continues to mark unbound daxdev as
'devdax' and also 'disabled'. No change to system-ram mode.=20

I think this might be all we need...

<snip>

John
