Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDA920EB
	for <nvdimm@lists.linux.dev>; Thu, 19 Oct 2023 04:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a5wBgKjm"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6bcef66f9caso1030725b3a.0
        for <nvdimm@lists.linux.dev>; Wed, 18 Oct 2023 21:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697689830; x=1698294630; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=07TI5lUHbLHzCbfbAfFgFmfomhDjrV2r0S9w2heQhcw=;
        b=a5wBgKjm6rnyUiC5qtdICEad/erU4jfoUtsZT3GPJ2I06XfnWC9TpL6Yr3IMV19jv4
         jx+ZjWLsKLp0l6Lf8cvEPax909ANqS9rseFH7AozBCPGb6wjIQ08gvMmAOKeX+t0wdRj
         f8mMjoAuLMqHv1OEDXkqHYwiEHscZvs4cS07ckBj3tOlb/ao9N20ehwmvSmvqZjRGEkl
         stdLih97D1nD9S6KFT9isgv7IdG501PqWFPLjv65A0AQOIqBh7UydPocoJlSYI2ZJJDk
         aEjz2VJ3LNrPuFqJXFz6kP6xB3igzf9P5amz89MPjmgcREmYmNp7yPJAWDwBh6Bc7kFk
         wpNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697689830; x=1698294630;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=07TI5lUHbLHzCbfbAfFgFmfomhDjrV2r0S9w2heQhcw=;
        b=gndFhhQUd8PSlkQ7Kp+XLkmt5Xl+oJKqUOxuJsaHZltXJ7s5efJceMfZ6NPuFRoGTf
         nXvqpbF/4BbaKJnRUmteqA78xWknVOtd90maLT+4ub/xo/dClMz+SfSMmOsSltPg08NH
         8IGHth9oCUtxa5Ef4ItJ+94XWPxT+NKPtjsKwxVM3h8ECw0NVH9tKdiQ3F/hINwAsHSJ
         RQv1PDq73fxY6O2iDkMDhrP2Usr+r6Zp4arQbn7Jst6w0ECi2GhKXp+BJDVYlXQepCsB
         IGwWrR4NLtMfa+hRzDYypJeOmWrrMZP3VVDaUIvq88qAheiZ0Rkx4enolsh1AJxjEaxl
         wt2w==
X-Gm-Message-State: AOJu0YxfO5xM0vMZ4vM5Ltqi82bgHRi696F27SEBE9RXO8slDy7HnbtR
	1U30Na0OmUpYJc+dNjWgCnI=
X-Google-Smtp-Source: AGHT+IEkWJvFP6rwED1ZbZyuQSYjiy/JNyTa5i4es2xKS+eEA8tiLgNC+CD3rO0KS3qkrixbUcz6ZQ==
X-Received: by 2002:a05:6a21:3286:b0:17a:e03f:38b7 with SMTP id yt6-20020a056a21328600b0017ae03f38b7mr1137611pzb.6.1697689830046;
        Wed, 18 Oct 2023 21:30:30 -0700 (PDT)
Received: from sivslab-System-Product-Name ([140.116.154.65])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902728d00b001c5eb37e92csm745514pll.305.2023.10.18.21.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 21:30:29 -0700 (PDT)
Date: Thu, 19 Oct 2023 12:30:25 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, lenb@kernel.org,
	nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ACPI: NFIT: Optimize nfit_mem_cmp() for efficiency
Message-ID: <20231019043025.GA577714@sivslab-System-Product-Name>
References: <20231012215903.2104652-1-visitorckw@gmail.com>
 <20231013122236.2127269-1-visitorckw@gmail.com>
 <CAJZ5v0gSB_ACBpK1nKu3sbA0HQ1xsk2mn3oc9AjpoFtge9Opdw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0gSB_ACBpK1nKu3sbA0HQ1xsk2mn3oc9AjpoFtge9Opdw@mail.gmail.com>

On Wed, Oct 18, 2023 at 01:17:31PM +0200, Rafael J. Wysocki wrote:
> On Fri, Oct 13, 2023 at 2:22 PM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > The original code used conditional branching in the nfit_mem_cmp
> > function to compare two values and return -1, 1, or 0 based on the
> > result. However, the list_sort comparison function only needs results
> > <0, >0, or =0. This patch optimizes the code to make the comparison
> > branchless, improving efficiency and reducing code size. This change
> > reduces the number of comparison operations from 1-2 to a single
> > subtraction operation, thereby saving the number of instructions.
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > ---
> > v1 -> v2:
> > - Add explicit type cast in case the sizes of u32 and int differ.
> >
> >  drivers/acpi/nfit/core.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index f96bf32cd368..563a32eba888 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -1138,11 +1138,7 @@ static int nfit_mem_cmp(void *priv, const struct list_head *_a,
> >
> >         handleA = __to_nfit_memdev(a)->device_handle;
> >         handleB = __to_nfit_memdev(b)->device_handle;
> > -       if (handleA < handleB)
> > -               return -1;
> > -       else if (handleA > handleB)
> > -               return 1;
> > -       return 0;
> > +       return (int)handleA - (int)handleB;
> 
> Are you sure that you are not losing bits in these conversions?

I believe your concerns are valid. Perhaps this was a stupid mistake I
made. Initially, I proposed this patch because I noticed that other
parts of the Linux kernel, such as the sram_reserve_cmp() function in
drivers/misc/sram.c, directly used subtraction for comparisons
involving u32. However, this approach could potentially lead to issues
when the size of int is 2 bytes instead of 4 bytes. I think maybe we
should consider dropping this patch. I apologize for proposing an
incorrect patch.

Thanks,
Kuan-Wei Chiu
> 
> >  }
> >
> >  static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
> > --
