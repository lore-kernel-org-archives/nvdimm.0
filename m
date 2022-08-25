Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A15C2F2D
	for <nvdimm@lists.linux.dev>; Thu, 25 Aug 2022 22:53:35 +0000 (UTC)
Received: from zn.tnic (p200300ea971b98f5329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:98f5:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CC97D1EC0559;
	Fri, 26 Aug 2022 00:53:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1661468008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=jW+8OpoivxfthSyTUh2opIqlkm3EYhh8/L9WZPGddVo=;
	b=AKOfeu2Lcan6dJoga4BrOeUCztkFyyoBPV3WpXePKesuaytAFI1vagg2EFKPgxzuYsD/di
	0aFnDEOYbz2ZmSXW8g4g5H6q6drWlI7wW9jM3ciYzZJoREg+uAjQ8a7UnsVp19pshUkNEO
	R8CGJu68c2Uuyb/d/cM73jepp7s0Bzc=
Date: Fri, 26 Aug 2022 00:53:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: "tony.luck@intel.com" <tony.luck@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v7] x86/mce: retrieve poison range from hardware
Message-ID: <Ywf9ZL6zjzSf5pdF@zn.tnic>
References: <20220802195053.3882368-1-jane.chu@oracle.com>
 <YwUFlo3+my6bJHWj@zn.tnic>
 <b3880db6-6731-1d1b-144f-1080a033ad01@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b3880db6-6731-1d1b-144f-1080a033ad01@oracle.com>

On Thu, Aug 25, 2022 at 04:29:47PM +0000, Jane Chu wrote:
> Tony has replied.

Do you really think that I can't look up what field means?

What I said was

"What I'm missing from this text here is... "

IOW, what I'm trying to say is, you should formulate your commit message
better, more human-friendly. Right now it reads like for insiders only.
But that's not its purpose.

Do you catch my drift?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
