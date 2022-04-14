Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE667B
	for <nvdimm@lists.linux.dev>; Thu, 14 Apr 2022 08:44:39 +0000 (UTC)
Received: from zn.tnic (p2e55d808.dip0.t-ipconnect.de [46.85.216.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AE4521EC059E;
	Thu, 14 Apr 2022 10:44:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1649925873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=XX6I/qqGd1pzt/wiJSFCoDXDtRPwRJSdws5FSZYXUmU=;
	b=DAr1jOmIuANW7nd0yzR+YRwJy3I/J/YwI4fxpfwPHrHEkJUIjGWub1Ij0cpeYNa9JmMX52
	EMOwvk6izI4BPvli7Se2T8KTtgIeBVmLrRVCtAPEiyxE9VuF58cSvG2ZyPqobKTjXNSmnq
	WrPVb0riOoINF+t5+XSKJp7qDutAGfk=
Date: Thu, 14 Apr 2022 10:44:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: "david@fromorbit.com" <david@fromorbit.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@infradead.org" <hch@infradead.org>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v7 1/6] x86/mm: fix comment
Message-ID: <Ylfe9eqCYvl0nSRC@zn.tnic>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-2-jane.chu@oracle.com>
 <YlVMMmTbaTqipwM9@zn.tnic>
 <e0f40cd6-29fd-412d-061d-d52b489e282f@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e0f40cd6-29fd-412d-061d-d52b489e282f@oracle.com>

On Thu, Apr 14, 2022 at 01:00:05AM +0000, Jane Chu wrote:
> This change used to be folded in the mce patch, but for that I received 
> a review comment pointing out that the change is unrelated to the said 
> patch and doesn't belong, hence I pulled it out to stand by itself.  :)

Aha, someone is being very pedantic.

For trivial unrelated changes like that I usually add them to a patch
which already touches that file and put in the commit message:

"While at it, fixup a function name in a comment."

Less patches to handle.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
