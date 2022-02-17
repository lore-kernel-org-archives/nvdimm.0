Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326A538E9
	for <nvdimm@lists.linux.dev>; Thu, 17 Feb 2022 01:20:40 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id m7so4144302pjk.0
        for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 17:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i7cadtmmQLWpqnDfNO/7BqDxIT7kznXIolyywHVAbf4=;
        b=sS4wdzZnPrT37CjCYgWCu8TLp11Ei7CFxuIjGDv44Mt2ivHoti/wY6MSdwNP0cKoXs
         Z21zfBugMb1CY2vsjABdEjflXhE4sdqTYSfDLkoAWfYWucbo1M7uHtiAqtTpogLYrl0T
         Bny4tAEmHxEn1N7T6sp5A5zMZsLgdkoxEdNhQMBVzalmJx54O6aDMEOdT2Io7FbEn8kA
         36+YLJcNQWtJzG2nJiiiuLwlw2U0p7FhhKvp6vg923Gz/g7rsu250azpMQiZTwABpqnr
         uPRpauBD6c9T+s5+i/bFlkwQZ/rM3RoYv8gkX6G0ez0kJPNKL/hqyrwrK3Wz+5D7lGGk
         Ol4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i7cadtmmQLWpqnDfNO/7BqDxIT7kznXIolyywHVAbf4=;
        b=NPW7Ij1T5VSccJ9aSfCVStB8xJEK/coSiLrtSEFkMTW+JxQtE+pbMZtBaiSvqe9HeH
         hr/vOozG2aOOIZiXfSiiT0PnfBdlxiW1sVVbUOqUkw5jYQw9ZGcEvTO8+qM392MUYxnz
         lUJ8OdSebBSC+kPaWi/9M6txD2XAAtIFNJmeNEZKwdVY8tN6SSZRPuK4JcaQZ9bev5fl
         dLxC7eftu6BObRQzGPgNpGsllF0dVFdvJ8phwrAl3y7NR8XEn9YJWzB61ONPxZr9vGkE
         jmoFtsoGXkKoAqGf4j5J3YJU5GQWHRaMkaD+nCE4c9V8OEuwZ+ybVucsHBh51OjzqcSl
         KhGA==
X-Gm-Message-State: AOAM5328oJC2gEKOgzSaDIHZNfqcnEYDpL45I8V0RCge6PPyEUONSYHC
	X5ow/Fte7iAqbQOzlpWjkm0s708/Wi6zjJq/Oer5bQ==
X-Google-Smtp-Source: ABdhPJwGogsHvhC8P7qOIe64MKrYPXZoUlX6w2MClweVcGHPqJw7K83Y/KeKSJi0yGjqpvs9L6OgDsIEYrhg9zspKmA=
X-Received: by 2002:a17:90a:f28d:b0:1b9:975f:1a9f with SMTP id
 fs13-20020a17090af28d00b001b9975f1a9fmr598286pjb.220.1645060839612; Wed, 16
 Feb 2022 17:20:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com> <20220128002707.391076-4-ben.widawsky@intel.com>
In-Reply-To: <20220128002707.391076-4-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Feb 2022 17:20:27 -0800
Message-ID: <CAPcyv4idjxVE=U8wQJj+7cZ+ZxP79q6GqCdQG4GQZ8pRX3fb+A@mail.gmail.com>
Subject: Re: [PATCH v3 03/14] cxl/mem: Cache port created by the mem dev
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:27 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> Since region programming sees all components in the topology as a port,
> it's required that endpoints are treated equally. The easiest way to go
> from endpoint to port is to simply cache it at creation time.

As of 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver"),
cxl_endpoint_autoremove() already sets cxlmd drvdata to @endpoint, so
this patch isn't needed.
