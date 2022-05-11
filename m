Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F54B15A2
	for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 08:44:10 +0000 (UTC)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EB3B31EC04EC;
	Wed, 11 May 2022 10:44:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1652258644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=LHg4Oe2iF4hQwykUueN/sjIC2MSSA3VeuKanItkOhY8=;
	b=a19rfyiZ7ZJh9FO3jBzw37rHKqnlvDKwdHQrD0kEkMf3YgjeCGXDBZ/x/EKnxdafGfa8nC
	M0nc98SpgU7g/sJvKdUIAyCzwLXkpPS3bl4N7wX5iKE9qevB90s/pbhVNSep01gVgITLfJ
	bKH3xl7EiDbL15Xnm/j5wq6zCwmEbiE=
Date: Wed, 11 May 2022 10:44:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>, david <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	X86 ML <x86@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Vivek Goyal <vgoyal@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
	Jue Wang <juew@google.com>
Subject: Re: [PATCH v9 3/7] mce: fix set_mce_nospec to always unmap the whole
 page
Message-ID: <Ynt3WlpcJwuqffDX@zn.tnic>
References: <20220422224508.440670-1-jane.chu@oracle.com>
 <20220422224508.440670-4-jane.chu@oracle.com>
 <CAPcyv4i7xi=5O=HSeBEzvoLvsmBB_GdEncbasMmYKf3vATNy0A@mail.gmail.com>
 <CAPcyv4id8AbTFpO7ED_DAPren=eJQHwcdY8Mjx18LhW+u4MdNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4id8AbTFpO7ED_DAPren=eJQHwcdY8Mjx18LhW+u4MdNQ@mail.gmail.com>

On Tue, May 10, 2022 at 08:56:21PM -0700, Dan Williams wrote:
> This is the last patch in this set that needs an x86 maintainer ack.
> Since you have been involved in the history for most of this, mind
> giving it an ack so I can pull it in for v5.19? Let me know if you
> want a resend.

I - just like you - am waiting for Tony to say whether he still needs
this whole_page() thing. I already suggested removing it so I'm fine
with this patch.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
