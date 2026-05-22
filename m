Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF21133AD9C
	for <nvdimm@lists.linux.dev>; Fri, 22 May 2026 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779466249; cv=none; b=fYO7Bwq/GMsZpWJG72wWJV5vLtPHkICxSoceNInW5gn42oFsFg5OTKkW19WiUHV9+Q/oEooWUzYKNzB/r8GqeEmIRc1u+BXb+Hrap3REPkU9AYRnuxLEzXbhcJhacbbYzW8KlHbGIb8KWMxV5uKN684Jrpbkcr9oDPAyTxoTUF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779466249; c=relaxed/simple;
	bh=Nw8/YzSBuossF7EbmXFZhKYzfLD+nl6cdvFpFDohfjI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=kkQGzw8eZigRcqPD9MaB9B2lkD2tb5p3zAXTBOPEVSwV4NvkJZg1QHpOa4fpnyJDvSa/dw7BzBwai3dNpriDxxOa6h2iLJHA4XWGj/Gs7Kqgw9sKRFyNZGbJrfKDnnSpzejSyxSemOrDILCAnn2kR+oJ4YCASAYrTXIg4QxVDh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B0EDC32B3;
	Fri, 22 May 2026 16:10:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf02.hostedemail.com (Postfix) with ESMTPA id 1C8888000F;
	Fri, 22 May 2026 16:10:42 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9C178F40069;
	Fri, 22 May 2026 12:10:41 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Fri, 22 May 2026 12:10:41 -0400
X-ME-Sender: <xms:AYAQaqwprjOeg4gI6hnk46GtUEoE7i98-MRKPoGvtUALCUL1zoECTA>
    <xme:AYAQahEat-iTBup1Zhi7L-lxbhSUd94VWF5j1UJG4Ug3npZrIc5h6YPvFMrsjWjhj
    erWt3Yd9xhc7lHeAtZEdeX1gV1c9pvQmAKM7d5-bZsVPv96N6u0DojN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtieduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedflfhohhhn
    ucfirhhovhgvshdfuceojhhohhhnsehgrhhovhgvshdrnhgvtheqnecuggftrfgrthhtvg
    hrnhepgeehgeejfeelgfdvveekveegvdfgfeehfeeugeefleejudehtdduhedvvefhudek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhgrh
    hovhgvshdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiheegudeiledu
    uddqfeefudejtdekkeejqdhjohhhnheppehgrhhovhgvshdrnhgvthesfhgrshhtmhgrih
    hlrdgtohhmpdhnsggprhgtphhtthhopedujedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegrlhhish
    honhdrshgthhhofhhivghlugesihhnthgvlhdrtghomhdprhgtphhtthhopegurghvvgdr
    jhhirghnghesihhnthgvlhdrtghomhdprhgtphhtthhopehvihhshhgrlhdrlhdrvhgvrh
    hmrgesihhnthgvlhdrtghomhdprhgtphhtthhopehjohhhnhesjhgrghgrlhgrtghtihgt
    rdgtohhmpdhrtghpthhtohepsghrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepughjsgifsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehifigvihhnhieskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepjhhitgdvfeeskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:AYAQahXO4lzgfiMxFXEpfMR-Vj4VerkC-0jLgESCjb9ni9xcT3uUaQ>
    <xmx:AYAQaqU4PSC0oSky_Far5dBy0oJjMGSE9_7dbtrFHDX4q_ni1B-Erg>
    <xmx:AYAQasF7sFMZMKt4jKwl4OjMsBsq11hrsllL95dE4pYUSD4r_5_6ZQ>
    <xmx:AYAQamuuWgdXAk8aNeMjg0IrfYEaB40WvZdyQzf3iYfnh0LvsDS7UA>
    <xmx:AYAQavYkq8pKa1IPZ7FiXGUR14pwjLajelNN7pvV4QVIfQDmEKRQjtza>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7500F700065; Fri, 22 May 2026 12:10:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 22 May 2026 11:10:21 -0500
From: "John Groves" <john@groves.net>
To: "Alison Schofield" <alison.schofield@intel.com>,
 "John Groves" <john@jagalactic.com>
Cc: "Dan Williams" <djbw@kernel.org>,
 "John Groves (jgroves)" <jgroves@micron.com>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>, "Matthew Wilcox" <willy@infradead.org>,
 "Jan Kara" <jack@suse.cz>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Miklos Szeredi" <miklos@szeredi.hu>, "Ira Weiny" <iweiny@kernel.org>,
 "Jonathan Cameron" <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Message-Id: <f44d4bb7-b3d0-4ea3-b138-1b3727e70c83@app.fastmail.com>
In-Reply-To: <ag_Nv0QwWPBg6bfk@aschofie-mobl2.lan>
References: <20260518213452.31205-1-john@jagalactic.com>
 <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
 <ag_Nv0QwWPBg6bfk@aschofie-mobl2.lan>
Subject: Re: [PATCH 0/6] Fixes to the previously-merged drivers/dax/fsdev series
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6buzx4sy7s6owqusuw8crkwpu5nfmjq8
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 1C8888000F
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/yJm6IpVkp43WDanlcGdgpjWU7dxqcd38=
X-HE-Tag: 1779466242-446888
X-HE-Meta: U2FsdGVkX1+1RxOXml2yubjfO8S0oci6xvlltj1ml46aVrilXQjz81H/QwuBB8QtETndbPQPgSJdxADH3kxzgVXkRSMLWlHtb3bEho9JIiMrbyzX4qtQ049APOnsWYRuMF4IVAsK3wFqUmWzf0GHNJKaX30ETooriTPne6oPjfUneDrkTvVhYtQ1XhvpKP4SgW+qszXPo+Qd6/icFI4o2hI7oQWVZDR2EQK3k0x584ni7U8E6bxTTAY/PC7X3abVnIidxGjtcQcGYivi15uUzjUXjNUt8/nIXp74K0qT5PsiywIimLAegSSa/HxfAdCEJx7yXjPEVqCGMJHkBayYrZ7lJeG5VUF5AQpcV41EV8AmtcCqOiTKRZRZeVwKg34b



On Thu, May 21, 2026, at 10:30 PM, Alison Schofield wrote:
> On Mon, May 18, 2026 at 09:35:15PM +0000, John Groves wrote:
> > From: John Groves <john@groves.net>
> > 
> > This series applies bug fixes (mostly found via sashiko) to the dax/fsdev
> > series. This has been soaking in the famfs CI pipeline for 2+ weeks and
> 
> I am not able to apply the set to any of 7.1-rc1 through rc4.
> 

Right, that's my bad. Patch inadvertently touched some stuff that isn't
upstream yet.

 Sending v2 shortly.

John
