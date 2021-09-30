Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E972FAE
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 19:11:35 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id s16so5884329pfk.0
        for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 12:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HDyYQLVBGB6V3r29jUFyzq1a/bX2OQKD3OEShl4tilg=;
        b=ZFGUFU2s1UAjgztiWX31JdffgnUkJt4+68p4eFJg8eEfUmLkGRSCaVM34LWjzn7ShG
         VLMAfWwVy15iOQwRQTBDcwBqKiSfcd9Z81dOslTTeXuzEYoRfJ32f+YOyKYYhZArkLVE
         OV21flQP3lAbaWQSCkduuRqTlYa/a4mg961yF+hcZcNVvOpqXTEsjXbkANpv/9PMab03
         l2kg59AOm6sAkpa2SLYC9FMrU7Ww1A8H521Y8tLa7u5eQm5s1j98Eoxe7SDwfACItvw3
         ZubkvqaFQRmQnQRbY2YUhM4G9aRahptQ1NoVndDMX+8ludQJ2NLtJBvJRuF/lCnKCjGa
         MMGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HDyYQLVBGB6V3r29jUFyzq1a/bX2OQKD3OEShl4tilg=;
        b=VOp82GkEzx2Dzke9hnWvAaydiZ298O06ag3AR5Us+76eIj7w9WcBIGh9lwoLZPRPyj
         5dM5+ntVwTpw/StnuAGLO11lz8qbFD+nMJ4ds9I1FOCNvoX8k3TJXoNJ54Pl8VWyDBaq
         G9+XFnlMP0bIS5iDv1gbFbDVALbvisgxPH6rd4sG8I9MQL+vu3qk7J2u11OUpcvToHWN
         ahD504XKeIqU01bHJt5o51VIc5mBF6Vdb9HsSymWx3vHFv9Ytfgc/ysfRDWHXvW80pDu
         uXWW20puhipWVZFnlCANOGk82GexMqwaMPuvAb6LqimACpPcNdJjMfFgXJ7hn/EpW33M
         w5uQ==
X-Gm-Message-State: AOAM532WeFUdbKMt75KFCxROGlBJkPdAJqghU4zTWwPZCLr3OBPtmNck
	tytpYdWLsez2QBcZj9ghb8RUqPtbGLPwZujWXHqFiw==
X-Google-Smtp-Source: ABdhPJyOqGrJZmoGRjA8ZDibfqZO8XEudHGYeFeLBtcJdAR5Vv6FAcp2ddbbqhFf0/x/hy8aC3zDS5xccLXsEf6+Itw=
X-Received: by 2002:a63:1262:: with SMTP id 34mr6249890pgs.356.1633029094878;
 Thu, 30 Sep 2021 12:11:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic> <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic> <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <7183f058-6ac6-5f81-9b46-46cc4e884bef@oracle.com>
In-Reply-To: <7183f058-6ac6-5f81-9b46-46cc4e884bef@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Sep 2021 12:11:24 -0700
Message-ID: <CAPcyv4gvnkDNBNnUdX0YeCoQiJ2BNs40wyy3mMkeYuz=GoUakA@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Luis Chamberlain <mcgrof@suse.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 30, 2021 at 11:15 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> Hi, Dan,
>
> On 9/16/2021 1:33 PM, Dan Williams wrote:
> > The new consideration of
> > whole_page() errors means that the code in nfit_handle_mce() is wrong
> > to assume that the length of the error is just 1 cacheline. When that
> > bug is fixed the badblocks range will cover the entire page in
> > whole_page() notification cases.
>
> Does this explain what I saw a while ago: inject two poisons
> to the same block, and pwrite clears one poison at a time?

Potentially, yes. If you injected poison over 512 bytes then it could
take 2 pwrites() of 256-bytes each to clear that poison. In the DAX
case nothing is enforcing sector aligned I/O for pwrite().
