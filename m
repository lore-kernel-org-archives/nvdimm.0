Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D9F814
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 22:41:43 +0000 (UTC)
Received: from zn.tnic (p200300ea971561dc329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:61dc:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 60BF61EC0528;
	Tue, 22 Mar 2022 23:41:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1647988891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=oxVBXEGRaZMxVsz03TdTeYV9J4EiFdcLGB4SPDXJ+Y0=;
	b=fu+uBFQHmi4ck26ugJBb44e35FYfvucppGnOJsqbbnRTp2g0SvWTDgLUTVnpZ3qDla8Ozp
	XGeU29dXH7vtua96FxWV8fN6hi2UnHOpluk7Jtxe4FAYK99hP40I5WAx0VgID2gXz0izov
	4uE/G8KDtp8txWZQDyidWmzGZx4qEZ4=
Date: Tue, 22 Mar 2022 23:41:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 2/6] x86/mce: relocate set{clear}_mce_nospec()
 functions
Message-ID: <YjpQlmGCFFQueHS1@zn.tnic>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-3-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220319062833.3136528-3-jane.chu@oracle.com>

On Sat, Mar 19, 2022 at 12:28:29AM -0600, Jane Chu wrote:
> Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
> file where they belong.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/include/asm/set_memory.h | 52 -------------------------------
>  arch/x86/mm/pat/set_memory.c      | 48 ++++++++++++++++++++++++++++
>  include/linux/set_memory.h        |  9 +++---
>  3 files changed, 53 insertions(+), 56 deletions(-)

For the future, please use get_maintainers.pl so that you know who to Cc
on patches. In this particular case, patches touching arch/x86/ should
Cc x86@kernel.org

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
