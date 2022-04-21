Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADB723A0
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 19:25:12 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id q1so4749578plx.13
        for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 12:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qeRjKSXDeJIH0+CQwoCMl5922pNFNUxTvF5aowm8rco=;
        b=n99NELoggPuhcsqKws/Ci4cGpg5aTBJYtQnAe9JU8tBA1qr9ygYOAR+1bDIsNVLV5p
         PzgfBQxai1TPXPdvVFGh9O1CcYKegnrlAPTNYxwYYt07W/JnhKPeV2EssXa5URw7o0Ag
         SbxCXwUC9VpajRWpPiZp096BFjq0Fjh6o1gRqvsaf0QS+Sdy/HmIRHNhWGUZRtzVg3E0
         0z9GCsn/tiJHXCCHr7NILgGmwG4cakwPAGUyQGFLATwnHLGp7l43bBirgfe1702YLJfw
         VHRKT35JWViWbCpUyZM0Orq2vsD7GoyOqWqol0/N/ekRJwk1FNnIIjq8s4maGk+0/XGT
         dCvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qeRjKSXDeJIH0+CQwoCMl5922pNFNUxTvF5aowm8rco=;
        b=jJvUlU9Su19JaR1E9Jk/isv7YaDb2OucJ/Zk/3ZjRRwuwcCgVyn1bXLVrPiS9HNsG5
         Dkrmzli1Uq4SdicVQp5k1QVPiQXixB3x6KptpOUFptalJuqsGedidnULhzPB2dFdp4Nj
         G5nRMuEk79nATaU+dLYwKrsEI3DiFd/qi5c+JAeoDtJz+OsjTb6ol0S+FUPlVvwWR0DX
         f1M7ITtIeGsPFRLQKLQE+1aYBygL01rlXSaEly+1xkKq10cIzPq3xcs/vKEGvyOxcVBt
         HARP07pJWp0XHe/3v+40onMP39mmyHoGVBY7tYZ7ImPe0SEfB3Pwls3eN6mobIidYbiI
         bZaA==
X-Gm-Message-State: AOAM533pkcnRgje1RAwSvRVtiBDKkS1cheOmu1TahwYnbI9hufX1R88B
	rBb9HtkkQRYM3uD1hxatmD7Gub9BxKkM29cJ+poNog==
X-Google-Smtp-Source: ABdhPJyqf0QRE4ybiwrpA4CL2rjYdR9Dfz1kuf/M+oV726c8/KeCCX7M1xEsBCAx988EvXNGhdhdyy5S+lFBAanpVRU=
X-Received: by 2002:a17:90b:4c84:b0:1d2:cadc:4e4d with SMTP id
 my4-20020a17090b4c8400b001d2cadc4e4dmr12075384pjb.8.1650569111988; Thu, 21
 Apr 2022 12:25:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220420020435.90326-1-jane.chu@oracle.com> <20220420020435.90326-2-jane.chu@oracle.com>
In-Reply-To: <20220420020435.90326-2-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Apr 2022 12:25:00 -0700
Message-ID: <CAPcyv4jMNvgWrh5WMY1gFN3-vKLU4eccXW3CDRrn1+=FY7D5jw@mail.gmail.com>
Subject: Re: [PATCH v8 1/7] acpi/nfit: rely on mce->misc to determine poison granularity
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, Christoph Hellwig <hch@infradead.org>, Dave Hansen <dave.hansen@intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, david <david@fromorbit.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 7:05 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> nfit_handle_mec() hardcode poison granularity at L1_CACHE_BYTES.
> Instead, let the driver rely on mce->misc register to determine
> the poison granularity.
>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...I'll add the Fixes: line when applying this.
