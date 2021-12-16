Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D3F29CA
	for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 23:03:41 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so849663pjb.1
        for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 15:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bw0QyROHNPSdp4ix5t9doYl+5Cs5DswGlhUBOeLua9A=;
        b=FDx6FbgThuox+WHY19kVnr8eBsItOyoR4C6/tzN1Reyxe812TdrJcvhx7T0MWTpvu0
         NwjFlhcZIWaHsD01aCJbiOAxksr+1fTUKY3UnkGyCaAEUJ/ADINT7rZcwx4tVKfr3i2C
         LK82hUkK3r/RhvDceIqAgtfFUjARZbjj5f81u4BVHx0FPHuzx2taDJoUUc9ebgE6UCuy
         oeLFGV2WsMjhu5OtVVXF9IrDfsa3xkOJ3AGD+Yz0YR6JQOPhxyNp1ZJz16kby8oVMs1/
         bj1c/aatvhpOp2jrlLCtrgYvRPHd4YCMpwUDSmUwvFcOt59jnRgnvEW23aZ3UPu5CYUM
         sfnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bw0QyROHNPSdp4ix5t9doYl+5Cs5DswGlhUBOeLua9A=;
        b=S1dEohzhOJMmaNpKo1rgAcpCCTvf3S6Svt6Vs9ZyPuQGxXDH4zJlF9wnWo6iOdQH9r
         rJSAvPCUgTg7BVo/DCJwfoXFCaootf/aVghzkg3e6YXcCuFzT966r5JZzaRncS0+OhLK
         uCtAtbQ+e0khpZfmsK4KBaoYn5ZQi0IJDyNgEdXtMvEIpn2tYZ6KnK7XoL74/1ZmlYOq
         wujvzpf2nR10Rvvpj0x7IjxLTKkwiouk4Vj/ZE7uROA+7rK5k7PTgCS/Im2/P/0P2hIf
         5CPzapl0rHY2F3TlZlCIkgeks0fZ4GA2hrrkls+2e85VE4J+wQ8pc8QqL0m07aSs6Zw+
         R7OA==
X-Gm-Message-State: AOAM533EaLsSLTa4f4I2ss5RYO4qQgx2QY67WfLX9fxIp0IasARy7otU
	xqu5Jx+44V+uP9mGC1lf3ph/nd4NZ0NYz0cSf+5UBtNRonE=
X-Google-Smtp-Source: ABdhPJwJWA8hDc5GLT40nyTt39bZyiGk4BN8UKfOF0eV538v9SPOIeYprrikpWyq+HGCdm7lUwEqnJYz4MhJfd3VxdI=
X-Received: by 2002:a17:902:8b85:b0:148:a2e8:2c35 with SMTP id
 ay5-20020a1709028b8500b00148a2e82c35mr240723plb.132.1639695820641; Thu, 16
 Dec 2021 15:03:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211210223440.3946603-1-vishal.l.verma@intel.com> <20211210223440.3946603-11-vishal.l.verma@intel.com>
In-Reply-To: <20211210223440.3946603-11-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Dec 2021 15:03:31 -0800
Message-ID: <CAPcyv4jqfS-xyz+y_u9BE1N24JkE+qA5zo3UoygnS02wececdA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 10/11] daxctl: add systemd service and udev rule
 for automatic reconfiguration
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 10, 2021 at 2:34 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Install a systemd service that calls "daxctl-reconfigure-device
> --check-config"  with a daxctl device passed in to it via the
> environment.
>
> Install a udev rule that is triggered for every daxctl device, and
> triggers the above oneshot systemd service.
>
> On boot, whenever a daxctl device is found, udev triggers a
> device-specific systemd service called, for example:
>
>   daxdev-reconfigure@-dev-dax0.0.service
>
> This initiates a daxctl-reconfigure-device with a config lookup for the
> 'dax0.0' device. If the config has a '[reconfigure-device <unique_id>]'
> section, it uses the information in that to set the operating mode of
> the device.
>
> If any device is in an unexpected status, 'journalctl' can be used to
> view the reconfiguration log for that device, for example:
>
>   journalctl --unit daxdev-reconfigure@-dev-dax0.0.service
>
> Update the RPM spec file to include the newly added files to the RPM
> build.
>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

LGTM. I don't know if udev rule numbering is correct, or not, but I
suspect the distros will tell us or fix it up in the distro package.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
