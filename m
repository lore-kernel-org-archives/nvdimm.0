Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156A2C82
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 02:40:50 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id oa4so3696212pjb.2
        for <nvdimm@lists.linux.dev>; Wed, 13 Oct 2021 19:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nb+jCdt1cxdmo1MN1mk7LJYJedlQCBtaKMOVlSOlQEY=;
        b=IDftfOhcW1/zTJ6JjXqN23CPVG9owXVSaWWhhL+uEfJWbdnoRuQV1CHuCEal6bVFXu
         3O0Ogc2F/D57OAgm++rfZzZTtyco0i6PcDZfSVlTlmx7AZer+YMnxLuO2GWBVmZ5d5Yt
         Jy9GtAMV3scDbek5Jtfeu1dr71DUf6P4X89dAujuuL70RmQzIhNnIwksEO5X5pmLCrmb
         LynIhDNH7wUdoMx1Ts4d+TUqTZi2ZzebidofM2TOonuvmAPaux7U2yYASApHmVmwKvND
         58fOoUqI9rA696kFNx3Fe0hSxNiRWmkvSoDeuMmC97QgGS7fMKPXmJ4n80ztQp0d2FdE
         vSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nb+jCdt1cxdmo1MN1mk7LJYJedlQCBtaKMOVlSOlQEY=;
        b=IdUo91x/3auF+jixoSuS3HZggbszrTkcnF7V2qu++k/iO4HUj60Mz+/agunbIoJHJN
         ySkiT+4fTucdwHRn1NqMmiV5a0bH4DAqqrwqdZ+CDW/M4Xgsqo/jDfOD6OpuzUNQ21gW
         KvSFp73jUVxQCV/EtPz63VeG0rR5zqbEBbigB3V5v2SkLdH9phfMlSN8ESsKCY0mGNtl
         TPhzdwLYJUMCBgHC6DcdVz+hl8NAp8G5X8f4Gon4cgNutnKcN+x11gL6e9jB7NKgEraZ
         a1iawI+lLh+kZT7h4Us6PfVg/P4gz/XwWn5CaWxeW185YZ3+CbfMPVDvd7wXBmFt7fBF
         K/YA==
X-Gm-Message-State: AOAM532tv20pFkVtYx3YNAn0faMtJWeXC52S3XiQnY/XzEmNi/Cqna6x
	xzFk6lzFdUPL8E6aaEAQVTfTMKfEPOfmgfErkyS5qg==
X-Google-Smtp-Source: ABdhPJzwO8boQJc+ST6VAWBcIOMUEsww+JngjT3FXpsRAvz/oQSuwQHUk2pAdSoGFRiRjx0ZtMmik3MXoHEpPI8op9A=
X-Received: by 2002:a17:90b:350f:: with SMTP id ls15mr3416080pjb.220.1634179250293;
 Wed, 13 Oct 2021 19:40:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-5-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-5-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Oct 2021 19:40:39 -0700
Message-ID: <CAPcyv4gYeS_1fTJ2bnUFx3vEuGUyW5qdLcndwdV3Z1=vgahf7A@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 04/17] util: add the struct_size() helper from
 the kernel
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add struct_size() from include/linux/overflow.h which calculates the
> size of a struct with a trailing variable length array.
>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
