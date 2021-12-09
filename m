Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23168
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 21:23:12 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id k64so6560924pfd.11
        for <nvdimm@lists.linux.dev>; Thu, 09 Dec 2021 13:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q1y40vwpY3Sw4jhQ/x9l/XpwpUAS7nPuNQY4dGM2Uu8=;
        b=qTPELtrLYl4Xzl0g6RUqyXacsYXoWWU47N94T17ifwhprPd8JJqOqioL2idvm/UuQV
         pHy3SGMrNFPHjivkxSOU/DfuN6YNE3lpkVSMTM9JchO404NBHlmqBp5SPGNztiD90S1U
         1VSJGHz+yxwK+VEANSr8JFWyA+y8H1REzCZd8BN3x2w5fP8kHkeVWTpCQvZtY3YnZYzu
         k6+4ceaUQA1S728SclIsF1ZJWdWSr68iIinNjq4byRuTEnbzzBnwUsQgpqMDTBI3zFgt
         jTaCCjl4VJ3fRA4fzDL7fbcfrTLl0teDrvh/Y68z7GTqzULfdIIaCb8S6Nupw2+euh0S
         eyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q1y40vwpY3Sw4jhQ/x9l/XpwpUAS7nPuNQY4dGM2Uu8=;
        b=pkgMGbwu373HOytYIk3/nKv6ZF3m1Dcnr5Oe20A1XxioFKQwEJH+MF2YcN4GhDbiZA
         uJ+Jls4kSOvYwRyUoihi6FpGlrxrna0hnWXVo5Tx7E3+/50J014zbUP9F98TN58HiiX6
         H2CjPXDZef4GktG/GP5PiSru5PYXPJBmlsFE+BG4OnNpKowX6AZp4H2nLlXxbvfcD/d+
         l/wOOpTIBfWd/+7l2FnplVdLJqiyrQfhk40P8c/sh7ousZ03w8BlVIJlGi72XwoQJJJR
         oeipa0UYMnnVCzMCpK13zDD3HDBTsI1nnqupvIJVUsBmWj1Iq72XlEK09jKoxad5h4KK
         Ixtg==
X-Gm-Message-State: AOAM533af9HKhJ7aNKMjrWExiMwC6Y/Yfy8LEEoIjy3Pxq9H3Zs/r5J+
	CXQ6Sg5ZvmQ7PIvTtmrfOc+u/o5NAMrc+5CjVA+V0Q==
X-Google-Smtp-Source: ABdhPJzZ/x0UyBdtt+niU/T7RBqziuW2HepFc1nqI6147NhBQiJ35nUZFAUOi/zVO81REM1URaHdaBGqQF3dv6SMrnY=
X-Received: by 2002:a62:7ec4:0:b0:4a3:219b:7008 with SMTP id
 z187-20020a627ec4000000b004a3219b7008mr14211545pfc.3.1639084992380; Thu, 09
 Dec 2021 13:23:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcyv4hMzLsfCoKc7fD5NLNOfaRTddb42BVdhyN50PM3dSDM9w@mail.gmail.com>
 <20211209210909.3520533-1-vishal.l.verma@intel.com>
In-Reply-To: <20211209210909.3520533-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Dec 2021 13:23:01 -0800
Message-ID: <CAPcyv4j5E0QQGLEipqKykc0M9-ormsf-ZWFZdXJp+4PTDzNEiw@mail.gmail.com>
Subject: Re: [ndctl PATCH v7] cxl: add a cxl utility and libcxl library
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ben Widawsky <ben.widawsky@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 9, 2021 at 1:09 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> CXL - or Compute eXpress Link - is a new interconnect that extends PCIe
> to support a wide range of devices, including cache coherent memory
> expanders. As such, these devices can be new sources of 'persistent
> memory', and the 'ndctl' umbrella of tools and libraries needs to be able
> to interact with them.
>
> Add a new utility and library for managing these CXL memory devices. This
> is an initial bring-up for interacting with CXL devices, and only includes
> adding the utility and library infrastructure, parsing device information
> from sysfs for CXL devices, and providing a 'cxl-list' command to
> display this information in JSON formatted output.
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>
> Changes in v7:
> - Update the man page w.r.t the new default behavior (Dan)
> - Use error() and usage_with_options() to fail when no list entities are
>   specified (Dan)

Looks good.
