Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4928B17FE9
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 15:34:00 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1aaff9c93a5so41705015ad.2
        for <nvdimm@lists.linux.dev>; Tue, 09 May 2023 08:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683646440; x=1686238440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0vGxqKgTtdJba+JT4w9Z+FB1d5UBN7wUwHlV8IbLpQ=;
        b=X3j75nOcQoPXR8ecV0DRmJJImcCH/QUUn7pjlIxXCrBWY20Ab3o45ojfnVTVRKFQRQ
         XOUIM/pqvDx5VpZptheJ5zZpXFtkt4p+/unf1YUBfJTvPmOzUdikIPKqT4RYtDY9wbMH
         RgnVJKwmNoPmTBhWXFRdNM+aBsJlFuuzqfQsn6Uq+LGKOjpep6gLtxo2Wp+kfl7TCT+6
         aMjnrVGEKWpSKN3VR+e8dSH+CNOUmHUWlPLm8GorrK9Y44JuBjVUfd2AP1Lr/XSlsb78
         6ew6hc94POQk5zM7GjTM8zFWD2h4K31AHVraYyuwnqvj4s7dhDgACoyhOqH5CJLOGEj1
         Cy9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683646440; x=1686238440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0vGxqKgTtdJba+JT4w9Z+FB1d5UBN7wUwHlV8IbLpQ=;
        b=SxT6BxFfxmkXDZsjg0QgPScryE4sj2oIFN0mUj2gujjVnxz8BkECJSQ0Ue0LWUFIsz
         42e4V5ve1OGXcf6fWO/hc8+P4qSdsATXkpcr2MsQSDvLGXRbwhdo7dPI7/p2Hkuu/kTb
         A7RV+KoZnvI6VCYZeNuBJ9EGa14KAiMHFdY8GHbEsr1j3NZFnZrz6WNMisDrEuN7YyG1
         S8UAHuNEbuQWufxeXZ337Nh9guwqRun7C06qYBuTOyQDOX5pUzgINLOLj+dvsJ2Rao+0
         oh4FDpQsS+5orFp/GtmnoTC+l/XLfjpKBDM9kWifK9oE2S1B8gABoc2PA/k+Ubg+XuLU
         tfmg==
X-Gm-Message-State: AC+VfDyQ1KfiozLquJEk5Q9Fp6KhSHMcyPZH6FfN/x9RVFi2ADXF/9l7
	++JWSzRM/y4M931MEMkGS5k=
X-Google-Smtp-Source: ACHHUZ5Wgicv45Pi3yWn3FCiD1DPy6gM7DeL7KwOdwsq0DyURA19W0EqdJZnpK8egd29KUM4AVZ2yw==
X-Received: by 2002:a17:903:11c3:b0:1ab:160c:526d with SMTP id q3-20020a17090311c300b001ab160c526dmr15521943plh.22.1683646439676;
        Tue, 09 May 2023 08:33:59 -0700 (PDT)
Received: from minwoo-desktop ([1.230.133.98])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902d2ca00b001aaf13db1acsm1714418plc.276.2023.05.09.08.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:33:59 -0700 (PDT)
Date: Wed, 10 May 2023 00:33:54 +0900
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: Yi Zhang <yi.zhang@redhat.com>
Cc: nvdimm@lists.linux.dev, vishal.l.verma@intel.com,
	dan.j.williams@intel.com
Subject: Re: [PATCH ndctl] typo fix: ovewrite -> overwrite
Message-ID: <ZFpn4rNvkePYL78/@minwoo-desktop>
References: <20230509230005.2122950-1-yi.zhang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230509230005.2122950-1-yi.zhang@redhat.com>

On 23-05-10 07:00:04, Yi Zhang wrote:
> Fix typos in Documentation/ndctl/ndctl-sanitize-dimm.txt and ndctl/lib/dimm.c
> 
> Signed-off-by: Yi Zhang <yi.zhang@redhat.com>

Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
