Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from turvaposti.pinus.fi (turvaposti2.pinus.fi [195.10.156.33])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2397D2063E2FB
 for <linux-nvdimm@lists.01.org>; Wed,  2 May 2018 22:31:08 -0700 (PDT)
Subject: Re: [PATCH v2 4/9] x86, memcpy_mcsafe: add write-protection-fault
 handling
References: <152532351517.17218.3583455156840230837.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152532354268.17218.11923624861859552990.stgit@dwillia2-desk3.amr.corp.intel.com>
From: =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <69d19601-df56-687d-730e-d043b2cf7161@nextfour.com>
Date: Thu, 3 May 2018 08:29:46 +0300
MIME-Version: 1.0
In-Reply-To: <152532354268.17218.11923624861859552990.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, x86@kernel.org, hch@lst.de, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/03/2018 07:59 AM, Dan Williams wrote:
> In preparation for using memcpy_mcsafe() to handle user copies it needs
> to be to handle write-protection faults while writing user pages. Add
> MMU-fault handlers alongside the machine-check exception handlers.
> 
> Note that the machine check fault exception handling makes assumptions
> about source buffer alignment and poison alignment. In the write fault
> case, given the destination buffer is arbitrarily aligned, it needs a
> separate / additional fault handling approach. The mcsafe_handle_tail()
> helper is reused. The @limit argument is set to @len since there is no
> safety concern about retriggering an MMU fault, and this simplifies the
> assembly.
> 

> diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
> index 75d3776123cc..9787f5ee0cf9 100644
> --- a/arch/x86/lib/usercopy_64.c
> +++ b/arch/x86/lib/usercopy_64.c
> @@ -75,6 +75,23 @@ copy_user_handle_tail(char *to, char *from, unsigned len)
>  	return len;
>  }
>  
> +/*
> + * Similar to copy_user_handle_tail, probe for the write fault point,
> + * but reuse __memcpy_mcsafe in case a new read error is encountered.
> + * clac() is handled in _copy_to_iter_mcsafe().
> + */
> +__visible unsigned long
> +mcsafe_handle_tail(char *to, char *from, unsigned len)
> +{
> +	for (; len; --len, to++) {
> +		unsigned long rem = memcpy_mcsafe(to, from, 1);
> +


Hmm why not 
	for (; len; --len, from++, to++)



> +		if (rem)
> +			break;
> +	}
> +	return len;
> +}


--Mika

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
