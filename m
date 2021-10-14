Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851A32C83
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 23:31:49 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so8064579pjc.3
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 16:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zk117L+WOnl50MYqP7yWKfZsHaGGLpM/r10Mqd0sAuk=;
        b=ophpHfGFARwDPV4GvxNIHeRwXNoCBFTfqfgJufSSbxJ4YULtjTirgd48E5Q4wftQfc
         A27p7dvqhv2GOrprIK8y7XEPZSOWNmW/K2f4iY4euiwvhxdUcFgyZJbZVDLh2/xuzhOY
         yhFAyOnVDnapJRFvqdJ6RJirnSU6xfrUJ2mfBotKI9UheNXkjhvw5wfKUREe/SaPc7vs
         BV3RcYgTAl5CSDUwEL0CZQi6so21oWty04xi0E+hfQVVA0Nh/LRINaOFauxIp1plrnEW
         KrbzxI+6FiZuJaSQR8rGks+smcniV6CNXelg1lA6atRB7CC4aBnLmlVvXnsXCUVlP3DN
         PxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zk117L+WOnl50MYqP7yWKfZsHaGGLpM/r10Mqd0sAuk=;
        b=2V5kFluKcfB2NJ4bbF5vhFcW/tbEaXRKqwTWwhZXszB5ejgssP8F/sxwkRP9gkJPOW
         5D6KntscOv89P54nEQnY971xK/YDp4eVOWN8l2NEcCentNEBs1DvFw11hRQOXHFWD73X
         Zr+EHzL7mDWDQpb127b9TG2hhD20ZBSH7HkHYSrWBzENpcZFqKyeMxUPKPFPeJBnu3vd
         OZ8Ng8GTU/52VHNFdBrwJApBtXEBbmcqrN/gbygC2PmfaJJvgaREw8RUn9c4SMe9jqie
         Jlp2silwMwtYmxkZTvexaWTngrTii4/wSirg2B5+puPcEGmJTiWWPjLLig6rKZNFY0G3
         TQEA==
X-Gm-Message-State: AOAM532DC/c82PM/gSsBR2w25cPQa4J0+LGG1/uaxkt67QZHW+b7luFw
	AINXBo1IkGuc/ApyIGyrHbQ5fdQWFBjyvrtB02ChHQ==
X-Google-Smtp-Source: ABdhPJxRhRJZ5H0p7J/EUNnVP+Vzg7jMAc/Ub1NI7Byv9GdJlXjj+MyGg/Irjg+jGhfLJN7kQqs+hI0Q1/xqXe3ZbEA=
X-Received: by 2002:a17:902:8a97:b0:13e:6e77:af59 with SMTP id
 p23-20020a1709028a9700b0013e6e77af59mr7689537plo.4.1634254308964; Thu, 14 Oct
 2021 16:31:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-15-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-15-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 16:31:38 -0700
Message-ID: <CAPcyv4ia2qeMFNxSRbLbL2+EDEVbiFSj=k-fPmzFdBCa9G9Awg@mail.gmail.com>
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

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> ---
>  Documentation/cxl/lib/cxl_new.txt | 43 +++++++++++++++++++++++
>  Documentation/cxl/lib/libcxl.txt  | 56 +++++++++++++++++++++++++++++
>  configure.ac                      |  1 +
>  Makefile.am                       |  1 +
>  .gitignore                        |  3 ++
>  Documentation/cxl/lib/Makefile.am | 58 +++++++++++++++++++++++++++++++

For the meson conversion I have hopes to be able to unify all these
duplicated custom build rules, but as far as I can see even Meson
requires this duplication and can't share build templates.
