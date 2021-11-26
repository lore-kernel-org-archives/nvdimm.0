Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07C768
	for <nvdimm@lists.linux.dev>; Fri, 26 Nov 2021 11:03:03 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1637924581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g4btdXn6LCRAN615sbfvmy4KHaxdnAQkd+iKSwrlwvo=;
	b=CirGF0lR9c+ZnkqzgiLiS/rhoR3NJVYyvCNXk6cOsd92JMu3OPQAIyDf7M6U0bYoI12qjo
	RIK4vELWm+OcdAOd5bAnszkMhNU+zCU8hugZCGkraktNyDlneBMWKL2FKGty74V4XShDgA
	qKTxV5ZGhPmFJ1fVMGIFvUG5YNJUOKpNamajvTmiOFpYKDQO/6XeoU45hwHgNtZtX/6x/J
	SFIzuRWWgOeDDF7sz2nxiRNeIRbIfEK/2UeNzkAOvimmuZe+6cW7YFSvfQ1UiULlgIymtc
	sZ2+1PgmliPJSPQhhWoLSg/UkrAY7oKSF4j8jWut3oDVel212OkvzvNVhuHTNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1637924581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g4btdXn6LCRAN615sbfvmy4KHaxdnAQkd+iKSwrlwvo=;
	b=HHWyui7ciCWdpgjGKLwWJUFL0e52YgYQOd4ClF84HmbCDkKNguSV9k+NvMMbGI+Fx+NkLJ
	3SJldidIVzzsgTDg==
To: ira.weiny@intel.com, Dave Hansen <dave.hansen@linux.intel.com>, Dan
 Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Peter Zijlstra <peterz@infradead.org>,
 Fenghua Yu <fenghua.yu@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy
 Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Rick
 Edgecombe <rick.p.edgecombe@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH V7 05/18] x86/pks: Add PKS setup code
In-Reply-To: <87ilwgl10a.ffs@tglx>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
 <20210804043231.2655537-6-ira.weiny@intel.com> <87ilwgl10a.ffs@tglx>
Date: Fri, 26 Nov 2021 12:03:01 +0100
Message-ID: <87o867gowq.ffs@tglx>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Nov 25 2021 at 16:15, Thomas Gleixner wrote:
> On Tue, Aug 03 2021 at 21:32, ira weiny wrote:
> Aside of that, the function which set's up the init value is really
> bogus. As you explained in the cover letter a kernel user has to:
>
>    1) Claim an index in the enum
>    2) Add a default value to the array in that function
>
> Seriously? How is that any better than doing:
>
> #define PKS_KEY0_DEFAULT	PKR_RW_ENABLE
> #define PKS_KEY1_DEFAULT	PKR_ACCESS_DISABLE
> ...
> #define PKS_KEY15_DEFAULT	PKR_ACCESS_DISABLE
>
> and let the compiler construct pkrs_init_value?
>
> TBH, it's not and this function has to be ripped out in case that you
> need a dynamic allocation of keys some day. So what is this buying us
> aside of horrible to read and utterly pointless code?

And as Taoyi confirmed its broken.

It surely takes a reviewer to spot that and an external engineer to run
rdmsr -a to validate that this is not working as expected, right?

Sigh...
