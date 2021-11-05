Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311312C9D
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 18:58:24 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id r28so9133055pga.0
        for <nvdimm@lists.linux.dev>; Fri, 05 Nov 2021 11:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mW90X9+gr0PIhSZqkuZE/L6VltlPrLZXEb+Nmd3FqjE=;
        b=Vk9ywDDuUBQjBxz5Bhs82UqvyiI5el74xlzmmTq6IyrpBX075HpWlqo6vczeS+i3Ts
         rmKXQSfHpwhq51JRUnjkAkvRswQDUhclfzc0tzP72GeCl5dylN0cdCuIzv8u1zmQ6D0V
         wTNEspIhh/ABEBZLOXT4HN1mcw5/NxSewyfRL3ZBnczRX77Jz1w2Rg4sDvZLWtZrbMUv
         YS8rMPVlEZ084Dns6saHvYhTeTQTkhP/fuEecw5ghFS5OqG4s64GdNE/jyFccQLWuQhw
         wPpeHAtTyJPj+hx8joyht7rGaZ1UChCLeXDKrfuYtmOBLDzJvpcVXuqcGFmD0+ttntzb
         Gt/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mW90X9+gr0PIhSZqkuZE/L6VltlPrLZXEb+Nmd3FqjE=;
        b=xV6UQVRRQ5LV4bPOan+pn/ivjUyLlRNT+f52z1RTR//RJb+qPKYLn9BsyxscDl/7Q4
         IhL3Blk9tLaB8Lvo1RUJg4tPBDuJREl4wY1nqlToe0nGgjXPvFxWZkmUuyjrjp9mpsVo
         YJC1UASf+YqrV1m+oBbEyj0lwkPG2empEqfwrZ0/Sp+l0VW1poCLuPakBwxUmyFi5z79
         LDxWyOeOkjC24XPKfhI9YEDZm6H0UhzroFHFABnF93SFhB9/F22wKusKGROnuTpc8f4+
         QlH1VCdVGa2LEsPekPpzVGI1mGfZYcD1/mrlriQOkuvl8RezjKY3tjTu3bp4S7AsPQCZ
         vmhQ==
X-Gm-Message-State: AOAM530ud5HmG7J/Iq3+3/tORkEXl3mhrNIZg98Lmgr3f1VLJo3Odj7R
	Q7/10WZwxl8d/v07qTfJ/40L4/uxu2U6ulSGKyxN/04K6wOZdg==
X-Google-Smtp-Source: ABdhPJzqoEa6aN6B4mzzs9jiitxAuljmgujGqpHKF7RPAxB503ycvVs+0OUKX60ZCN+BWDbBSATY0DZXgxiYgekQugQ=
X-Received: by 2002:aa7:8019:0:b0:44d:d761:6f79 with SMTP id
 j25-20020aa78019000000b0044dd7616f79mr61901423pfi.3.1636138704466; Fri, 05
 Nov 2021 11:58:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-15-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-15-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 5 Nov 2021 11:58:15 -0700
Message-ID: <CAPcyv4grwvoGwzhF_bkg_O+uF8bkaODrnwiVhKL=8T8+_ytCdA@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 14/17] Documentation/cxl: add library API documentation
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add library API documentation for libcxl(3) using the existing
> asciidoc(tor) build system. Add a section 3 man page for 'libcxl' that
> provides an overview of the library and its usage, and a man page for
> the 'cxl_new()' API.
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/lib/cxl_new.txt | 43 +++++++++++++++++++++++
>  Documentation/cxl/lib/libcxl.txt  | 56 +++++++++++++++++++++++++++++
>  configure.ac                      |  1 +
>  Makefile.am                       |  1 +
>  .gitignore                        |  3 ++
>  Documentation/cxl/lib/Makefile.am | 58 +++++++++++++++++++++++++++++++
>  6 files changed, 162 insertions(+)
>  create mode 100644 Documentation/cxl/lib/cxl_new.txt
>  create mode 100644 Documentation/cxl/lib/libcxl.txt
>  create mode 100644 Documentation/cxl/lib/Makefile.am
>
> diff --git a/Documentation/cxl/lib/cxl_new.txt b/Documentation/cxl/lib/cxl_new.txt
> new file mode 100644
> index 0000000..d4d5bcb
> --- /dev/null
> +++ b/Documentation/cxl/lib/cxl_new.txt
[..]
> +include::../../copyright.txt[]
[..]
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> new file mode 100644
> index 0000000..47f4cc3
> --- /dev/null
> +++ b/Documentation/cxl/lib/libcxl.txt
[..]
> +include::../../copyright.txt[]

I just noticed that these two man pages list the GPL license even
though the library is LGPL. Even though I think the license is with
respect to the man page I think go ahead and create a LGPL notice for
the library man pages functions just to reduce potential confusion.

The copyright can also be bumped to 2021 now.
