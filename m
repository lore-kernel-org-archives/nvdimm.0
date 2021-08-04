Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC12570
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=Mtg1AswyFwxPF9X4tI9/jd6V3tatlrDW5m8cofHfWUw=; b=dlkbK9YGk8If6axFFQUH5ic4HF
	M67pvhar+aIIvNjcQLF87r/U8ZbOp0VYZRifD2yT6ohRQy2Q7Fee4unLa9NMbn1VJbbtlqkJHyXRg
	iGB91UPIMYBQr/QJXGpCYBSNl/bGJBpS4z8WGm7SYlA/k05vu2pcoC4qn2+hXp1l42zkKxQ5fS8sh
	xKinMbclqQw8loUpxNOBwJ4QfHcsHY+SUmYffLA4nAZHX7XCGXEI6XJhLfcT5E57XhjHWUOePLqjz
	qWyA7bAWUbL1OU5kPWrYM6WugfRutbFgzXWZh12mjew9H1zgaXlEXGrEmW4jeNq54C15klUAYqmK+
	YYlkka7w==;
Received: from [2601:1c0:6280:3f0::aa0b]
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mB8yI-005QJb-4e; Wed, 04 Aug 2021 04:57:43 +0000
Subject: Re: [PATCH V7 14/18] memremap_pages: Add memremap.pks_fault_mode
To: ira.weiny@intel.com, Dave Hansen <dave.hansen@linux.intel.com>,
 Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
 Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Fenghua Yu <fenghua.yu@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org
References: <20210804043231.2655537-1-ira.weiny@intel.com>
 <20210804043231.2655537-15-ira.weiny@intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2bbd7ce2-8d16-8724-5505-96a4731c3c45@infradead.org>
Date: Tue, 3 Aug 2021 21:57:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210804043231.2655537-15-ira.weiny@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 8/3/21 9:32 PM, ira.weiny@intel.com wrote:
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index bdb22006f713..7902fce7f1da 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4081,6 +4081,20 @@
>   	pirq=		[SMP,APIC] Manual mp-table setup
>   			See Documentation/x86/i386/IO-APIC.rst.
>   
> +	memremap.pks_fault_mode=	[X86] Control the behavior of page map
> +			protection violations.  Violations may not be an actual
> +			use of the memory but simply an attempt to map it in an
> +			incompatible way.
> +			(depends on CONFIG_DEVMAP_ACCESS_PROTECTION

Missing closing ')' above.

> +
> +			Format: { relaxed | strict }
> +
> +			relaxed - Print a warning, disable the protection and
> +				  continue execution.
> +			strict - Stop kernel execution via BUG_ON or fault
> +
> +			default: relaxed
> +


-- 
~Randy

