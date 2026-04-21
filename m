Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FF9145B27
	for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 01:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776736070; cv=none; b=WiQ+igBuxYQjwGugTHud5JCRW41psjXHFkuflHzqGvLrwa/ScZWF8kA1dY9b5KOFWBXpuqh5SUl4IfiUWS1r/3QpYaZvErZNdTtDcQt7NsUVlhRaM5qvuiTnJPTzLY3KGFfjGydTAnAaCqlhFXZ529bv5dtopqO8gURo5M1nF5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776736070; c=relaxed/simple;
	bh=XRNzMUANARx7i2tP7LZttyDGWCCIr/CYGKEOruFdzcY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=GBaJ7nsBUL2b2QLLGXnFm+wXEOw+rhionfm3nicnTk2uG3ZxZ6riC3FRLUteOfR2LobLdja87FolFadjAg5OSYOMCn5Z0GTyA6nZwUB6W5yIh9KSCe9Cj/4dpmInXaUiWiDpt+xPz5wP91jKgzPUzvBpfgsy/Ns6WeoxfXKLKYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=Z6q3rYO7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VSEVasRG; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="Z6q3rYO7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VSEVasRG"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 04B957A01ED;
	Mon, 20 Apr 2026 21:47:45 -0400 (EDT)
Received: from phl-imap-14 ([10.202.2.87])
  by phl-compute-09.internal (MEProxy); Mon, 20 Apr 2026 21:47:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1776736065;
	 x=1776822465; bh=C2CcoEjRgB77iNSGBMM+LE/roPS/F2NbUpqKDbEVoog=; b=
	Z6q3rYO7koq8TYUNOlFt1Ti6FWBX08oeCzfXQ7zgmt4wilY1KTNjFcNt4DM9eqlG
	nfteTrGdgWjKJ0dHxtUc7Dpyz1ME/9IVvdqyiBgYRHa51xR5jKlGLShdqExcdpSV
	4COKcALC27rR8VsNivOjcunRBDGl+xi5Gp5cT6eHjqM6pRkauLmUr8GOfLdxBW7s
	GeplGK4fKl7gF+i3TJjT+p+8RHSGpVLm4fV9fsoWRoZHcub06vSBn+uTZAoaSWo9
	loMJBUJgd7YVXJO4KePBehaHxg/e1vpaRs3x77wVr86MCSKpD5bU1Bk2bMqBHA9K
	eHJPWg4GYUzRID64qwvGRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776736065; x=
	1776822465; bh=C2CcoEjRgB77iNSGBMM+LE/roPS/F2NbUpqKDbEVoog=; b=V
	SEVasRGyTRH+7VVLN98yvK78bZkDoh+ihCw0xE3VlkrT/Aa+E6zIUB9QrXUbddys
	FgFD1Q+Fg/Pn2P8Ti0XVGsRKisPNSIJoTFQs4JSIakkoJ4XPeMfTsdFRlCtsakf7
	Vm+c5yvL6SMHz9xRMDbX3uYBZBaYWdDB6+qYNlj8uaPeW7+a+xDr35AqlQVwqLw/
	Z5PiegLVfI0UjoNYhhgKg6yMaQimEsq5gJGeb+tN8unSN/+K22mfZ82JYCf+6ShI
	9+JyQW60ddOaOoSsJ2Y5dp0deFKWIQ5g0ddZGJaHYRYROgp9gcZtzQ6LrPttB7lm
	ssPLKuK6ShjqnCnR4WbEg==
X-ME-Sender: <xms:P9fmaYyuBleDVlXHpV6xdZ8a6dJgc-cdAN4YWABbO4lFkIw6hNFmBw>
    <xme:P9fmaXHtSDsyDOgYhvQ8ySBKvVF6yJ5cp_7PrEjI4HAoUOS4qGxlTMLTa95KJUAOE
    ElTYnqojgimQ9eGzDrMxcbNMEWOtfDii5ds4mJrLnZcrXm6IeqQMvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeitdduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdflohhhnhcu
    ifhrohhvvghsfdcuoehjghhrohhvvghssehfrghsthhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhepveduieelvedutddvvddvkeeuvefhieefieelfeekiedtkedutdeiteeu
    tefhteegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epjhhgrhhovhgvshesfhgrshhtmhgrihhlrdgtohhmpdhnsggprhgtphhtthhopeefkedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepshhhihhvrghnkhhgsegrmhgurdgtoh
    hmpdhrtghpthhtohepjhgrmhgvshdrmhhorhhsvgesrghrmhdrtghomhdprhgtphhtthho
    pegsshgthhhusggvrhhtseguughnrdgtohhmpdhrtghpthhtoheprghmihhrjeefihhlse
    hgmhgrihhlrdgtohhmpdhrtghpthhtohepsggrghgrshguohhtmhgvsehgmhgrihhlrdgt
    ohhmpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtg
    hpthhtoheprggtkhgvrhhlvgihthhnghesghhoohhglhgvrdgtohhmpdhrtghpthhtohep
    shgvrghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehtrggssggrsehgohhogh
    hlvgdrtghomh
X-ME-Proxy: <xmx:QNfmaZFcKeeB4rNV_hpHJhfq65xKNb4S5aaZXnaw-m179t7nqVPv1Q>
    <xmx:QNfmaRqeBKDw9FXqYySh8A-EXscqIHdVXJO68DCZms9xNHBooyW0OQ>
    <xmx:QNfmafNWMqJOwmAEkLEpez1fD9uj5yQZvRAKfBLk4-OFcSSIzu0ZQg>
    <xmx:QNfmaVehYGCXsKO7eXXQ9wCUguwrmCx7tn3ZdtO5Q9-VmJ7jc95tjQ>
    <xmx:QdfmadqSo-QJhbNj4Nd3gL7MECBTH3QoBASC7x-CWBpSyHYrnZ6IUPQY>
Feedback-ID: if7ae487a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CFDEEC4006E; Mon, 20 Apr 2026 21:47:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 20 Apr 2026 20:47:23 -0500
From: "John Groves" <jgroves@fastmail.com>
To: "Alison Schofield" <alison.schofield@intel.com>,
 "John Groves" <john@jagalactic.com>
Cc: "John Groves" <John@groves.net>, "Miklos Szeredi" <miklos@szeredi.hu>,
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
Message-Id: <497e9e6f-6770-48d7-929b-8543a25172f2@app.fastmail.com>
In-Reply-To: <aeaz9TecrINXaHcR@aschofie-mobl2.lan>
References: 
 <0100019bd34040d9-0b6e9e4c-ecd4-464d-ab9d-88a251215442-000000@email.amazonses.com>
 <20260118223629.92852-1-john@jagalactic.com>
 <0100019bd340cdd5-89036a70-3ef5-4c34-abf8-07a3ea4d9f92-000000@email.amazonses.com>
 <aaD6yQLiyZznfAxr@aschofie-mobl2.lan> <aeaz9TecrINXaHcR@aschofie-mobl2.lan>
Subject: Re: [PATCH V4 1/2] daxctl: Add support for famfs mode
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Apr 20, 2026, at 6:17 PM, Alison Schofield wrote:
> On Thu, Feb 26, 2026 at 06:00:41PM -0800, Alison Schofield wrote:
> > On Sun, Jan 18, 2026 at 10:36:38PM +0000, John Groves wrote:
> > > From: John Groves <John@Groves.net>
> > > 
> 
> Hi John,
> 
> This is where I left off with the actual changes to "daxctl" for FAMFS.
> We need a new rev of this ndctl set that includes both patches rebased
> on ndctl pending and addressing the review comments below for daxctl.
> (Although I've used more recent branches, I haven't looked at whether
> these issues were addressed in the code.)
> 
> With a new rev, I'll take another look at ensuring a dax device is
> available for the unit test.
> 
> Thanks!
> 
> --Alison
> 

Will you be on the DAX call tomorrow? If so, let's work out a plan and assign
my action items as necessary. Not that I need any more action items :D

Thanks!
John

