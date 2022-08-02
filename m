Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72357F
	for <nvdimm@lists.linux.dev>; Tue,  2 Aug 2022 10:59:37 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id z22so17119378edd.6
        for <nvdimm@lists.linux.dev>; Tue, 02 Aug 2022 03:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OoOjj2ZKfm+aKI2XCz2uW/zV54aqeuaDJtU0JfcCK5E=;
        b=BQKJG+lMQFqqR5u9jSq85ByIMbXSY75N7rX+qutL9ytJ7mJJUrFj8xY2dqKMpv4Ueq
         HFWQAt1D74J8OAEpzcZ/lQ9hDrybyiihp9wpum6QUR84QziYBdHCVb9BXJi91B0wi3ro
         jFNhoG1Ndj/wB+urRa0WhG1z36rhCiVdQEfQa4+whvEWDNIhvk2bOqdcAVjjEGP1fcmK
         qMVzx1OmJ/aXRVrZSFs3LxLF3k6FJgfouWjS0r63LMuqPPz+WjSpiprlUYbvTEG8hl9t
         UQ5UHnLJFA+XF0iW0fHmFgulmM6uauQxCZk9N90DHVa0PlYNI79yIrSoQCdWctAmg4rc
         n2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OoOjj2ZKfm+aKI2XCz2uW/zV54aqeuaDJtU0JfcCK5E=;
        b=SnTNFSwpjiy/Zv2NdFNVeLPgzhSazyDF1GQ3MHr4NwTAXBCZ+JK5HF2KTwa5eSQp6c
         ADLlJafNqQo4w4yFNObELNoBBX+qLjvAAvhtttVWOQU9uC+p/eZJ1BBFmWVpg6Ud3818
         cMdnMMzOrCO8T+gw4M5dtqBvnMmywXPlPaU3CfxUL2wdQZK98XnzpV/OM9LD3YNry9i0
         BM8+vlyo0/K9so146NhevrM3ZEeZXyIRuanjUd5Z3067SQvn7yblJa5ai6o8a6b/2tIZ
         tR2WTguUm/nat4ieUwTCc40bFFlkF/wF3s1gCwY/aPUGQQoPP2ylADPz0sg7cpUyT2Hs
         1hOg==
X-Gm-Message-State: AJIora8ZTCC0dMv07f2FyYaAB8oZ+sLuAoPF/uVGD5D1j4SwvekRvbfH
	ZgxI2koZH7iNVPdqaHG3Ke0=
X-Google-Smtp-Source: AGRyM1slWsFtBGYQGRf9JsGLxptO6wteWd0849lQuQzFHhHumIbPQkQUQOOt+b/HreL9OuzslVtZvA==
X-Received: by 2002:a05:6402:d05:b0:425:b5c8:faeb with SMTP id eb5-20020a0564020d0500b00425b5c8faebmr19475384edb.273.1659437976136;
        Tue, 02 Aug 2022 03:59:36 -0700 (PDT)
Received: from gmail.com (84-236-113-167.pool.digikabel.hu. [84.236.113.167])
        by smtp.gmail.com with ESMTPSA id a9-20020a50ff09000000b0043d1c639e15sm6718213edu.65.2022.08.02.03.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 03:59:35 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 2 Aug 2022 12:59:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: tony.luck@intel.com, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org,
	linux-edac@vger.kernel.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, hch@lst.de, nvdimm@lists.linux.dev
Subject: Re: [PATCH v6] x86/mce: retrieve poison range from hardware
Message-ID: <YukDlb9SsZ2UlX8o@gmail.com>
References: <20220802000614.3769714-1-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802000614.3769714-1-jane.chu@oracle.com>


* Jane Chu <jane.chu@oracle.com> wrote:

> With Commit 7917f9cdb503 ("acpi/nfit: rely on mce->misc to determine
> poison granularity") that changed nfit_handle_mce() callback to report
> badrange according to 1ULL << MCI_MISC_ADDR_LSB(mce->misc), it's been
> discovered that the mce->misc LSB field is 0x1000 bytes, hence injecting
> 2 back-to-back poisons and the driver ends up logging 8 badblocks,
> because 0x1000 bytes is 8 512-byte.
> 
> Dan Williams noticed that apei_mce_report_mem_error() hardcode
> the LSB field to PAGE_SHIFT instead of consulting the input
> struct cper_sec_mem_err record.  So change to rely on hardware whenever
> support is available.
> 
> Link: https://lore.kernel.org/r/7ed50fd8-521e-cade-77b1-738b8bfb8502@oracle.com
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/kernel/cpu/mce/apei.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mce/apei.c b/arch/x86/kernel/cpu/mce/apei.c
> index 717192915f28..e2439c7872ba 100644
> --- a/arch/x86/kernel/cpu/mce/apei.c
> +++ b/arch/x86/kernel/cpu/mce/apei.c
> @@ -29,15 +29,27 @@
>  void apei_mce_report_mem_error(int severity, struct cper_sec_mem_err *mem_err)
>  {
>  	struct mce m;
> +	int lsb;
>  
>  	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
>  		return;
>  
> +	/*
> +	 * Even if the ->validation_bits are set for address mask,
> +	 * to be extra safe, check and reject an error radius '0',
> +	 * and fallback to the default page size.
> +	 */

speling nit:

  s/fallback/fall back

> +	if (mem_err->validation_bits & CPER_MEM_VALID_PA_MASK)
> +		lsb = find_first_bit((const unsigned long *)
> +			&mem_err->physical_addr_mask, PAGE_SHIFT);

I think we can write this in a shorter form and in a single line:

		lsb = find_first_bit((void *)&mem_err->physical_addr_mask, PAGE_SHIFT);

(Ignore checkpatch if it wants to break the line.)

Untested.

Assuming my suggestion is correct and with those addressed:

  Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
