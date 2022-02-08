Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422FC2F24
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 20:47:02 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id i186so642637pfe.0
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 12:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EtnqUgSIa3X/cpdmfWa9zlW2f1lwuqSEBAfSPO0aEM8=;
        b=qFbqJVX6C4eNHu4MYEFs0PGNyXPEx1waVEVM8nBKinW0gK8K961vSFpJV0XNEjDxRZ
         Sjmv1Vt1D+QSoPnLs1dUXxGs9hLLTIxbd9jvDxJSnFpIAyhSNrRsYBbCTWozZWNkIhAX
         +P0brg01k5EZSm4PvmZWhzH1JrnqOPMHbJxxTCS313mCWyhnAzu5vJSDV0Q+9R2uCdEE
         Uem16fG+jCk4JjeZUcLuuTIKw0kG65N4uEsGhOwvWme28ogXQo8Zwvjsd95X/0LpsHD2
         HgTk8Itp9fTHKqOrIk9R0yD7VwgkBAW/56faO4HwRRamEhBLvwuGw/XPlp67RusaVgMs
         SJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EtnqUgSIa3X/cpdmfWa9zlW2f1lwuqSEBAfSPO0aEM8=;
        b=UKErj4BfxsYAmMV9k5mwkyxAEPNjVbvGSrEMs2uO/Zf9aAXKJVZhcuMg0qBC/YkBta
         XOjTAUENnmIArt0Lg6tUifjzfT3P712mfKY0NojFPOzGOLoyN4jrGBeDZSWmAJhL9f7A
         HCttUrxBXvdpfyYHp3FrNqhK5LMTUXBWQfryGlFt6ZGJ7YG0+BD4XmWwkDCQ40YqTb23
         G+fVdekOc7Q+J98N/4jAIEFiZ0NvTLLdS3ejJ2BMkyE8lBYs4KEXU0EQUXjsI3EBws8i
         e/hR98S0o2ay6Pv7bCwkR1CerOhIjLicrK1EiEru6wrUGeNARmFaqFaQ8Z113n9LpSXY
         kjmg==
X-Gm-Message-State: AOAM532sNjbaiIKw/M65aOSD1G/NE+QIQf8x7mPP6nbyEhVINugEsaUK
	0SV6pTu3lZuFOKvpeodPMhyFuQxuq1ICIj6pC/oVtQ==
X-Google-Smtp-Source: ABdhPJxtlz9vwgaxefg+HZgHOLCqaC/jJaP2FkkSmJTG56MULfKP//dedb0UIiIO9183wWHyKPvWk5rx7It/XimTRek=
X-Received: by 2002:a63:4717:: with SMTP id u23mr5020649pga.74.1644353221741;
 Tue, 08 Feb 2022 12:47:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1644271559.git.alison.schofield@intel.com> <7d1ebd8316584d065133ab7343e14eba2810f98e.1644271559.git.alison.schofield@intel.com>
In-Reply-To: <7d1ebd8316584d065133ab7343e14eba2810f98e.1644271559.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Feb 2022 12:46:50 -0800
Message-ID: <CAPcyv4hcTto3Aza_BTrczu_y6G7Ffh4F2Mx=ZR1NyOfCwhaHyQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 5/6] libcxl: add interfaces for
 SET_PARTITION_INFO mailbox command
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 7, 2022 at 3:06 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Users may want the ability to change the partition layout of a CXL
> memory device.
>
> Add interfaces to libcxl to allocate and send a SET_PARTITION_INFO
> mailbox command as defined in the CXL 2.0 specification.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/lib/libcxl.txt |  4 ++++
>  cxl/lib/libcxl.c                 | 28 ++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym               |  2 ++
>  cxl/lib/private.h                |  8 ++++++++
>  cxl/libcxl.h                     | 10 ++++++++++
>  5 files changed, 52 insertions(+)
>
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> index a6986ab..301b4d7 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -132,6 +132,8 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
>  int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
>                            size_t offset);
>  struct cxl_cmd *cxl_cmd_new_get_partition(struct cxl_memdev *memdev);
> +struct cxl_cmd *cxl_cmd_new_set_partition(struct cxl_memdev *memdev,
> +                                         unsigned long long volatile_size);

Perhaps a note here about the role of cxl_cmd_partition_set_mode(),
that the default sets the partition for NEXTBOOT, and that IMMEDIATE
support depends on the device being inactive in all regions before the
kernel will allow the change?

Otherwise, looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
