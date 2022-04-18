Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35450A41
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 19:15:26 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id k29so20526176pgm.12
        for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 12:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zWar2GmNZVaibXA/7aDZF3/pVr/IWOUF+gi7lSrow2s=;
        b=E9gaPeh+LLtW7pa7BCNF2NCwv4n8NTmXcVbuYMMtKSDloraqVeABaDsvAE1Es5E14i
         4xDRneXhTvTQZmKT0bB94Juyqm3Tynu7EwjI76nV7E2kKBZo/Ld50j4MNmQlfbnsU946
         0KB6ID9pHwyuwO1YLOybK88vNXJhA3S1cRzpdbfUZWl8jyHcR6CvTldUeXRYmPCOpq7J
         TryHisBI1SOpHsmvwqj2gPr+FiAVsi5hlJRLiyOBJSSpoY87BHWUNG3MJ04v+1lTg3Qb
         Y38OyJHaxCjt7SGRPpmc8oA5QXdteraUTwsGbZ/KvBlEVZOzEMVhAGAY7WR6W6/L/YnG
         WeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zWar2GmNZVaibXA/7aDZF3/pVr/IWOUF+gi7lSrow2s=;
        b=cMcvmd5GB2FAUeokKP4YLixM0bAAOd/Vlis3UKXGQnq8dtQeTWOOznUlWl5hMMdoO5
         LGKevhkp4Tt595+uRfLZ3cZSbVhIHJnTDr/dy9FJXVxvtiSfSrAn63rwNsZbAiYdX9Lr
         Ks5h2N6xdBWJtdFyB8OqY9K4rac0uY5/Pgdu1ubNtmnp+zhJz+GH+R88H5f71G0lxWWi
         iDTwUl79ydC0FYV8foZlPKzFYyA45FdZzGPLTfINuZrDc1lr6DBR7JGxI9lPMhuyOLgD
         S1tWfI8EpQW21IvY8ZgsjIei6KcCMKXQVZ95M7kAFewDLfbBmZQkFEOXCwbNz5yt7WUD
         jPxA==
X-Gm-Message-State: AOAM532Z4YaeCv8mWN/z2oyT1QRptjTRCy5J2Q74kErIx00f2/IX2H5N
	Q3GzG/Dgp9vR9avAtblwnJRWtgYWIrhLP60dejau0ZlPFgfWTA==
X-Google-Smtp-Source: ABdhPJwJo/OvIOwa/l1/q/sYlkgo/eZ7a3TataKPWq3zqVRlfO+shBfKE7LT2dbxWbEuGWQJm+CN82yIIqUXjngVKcw=
X-Received: by 2002:a05:6a00:e14:b0:4fe:3cdb:23f with SMTP id
 bq20-20020a056a000e1400b004fe3cdb023fmr13866870pfb.86.1650309325624; Mon, 18
 Apr 2022 12:15:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220418185336.1192330-1-vishal.l.verma@intel.com>
In-Reply-To: <20220418185336.1192330-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Apr 2022 12:15:14 -0700
Message-ID: <CAPcyv4h+r4Oq=y+B9H+E6AASbj8=V+NcdU+5S88-i-yfOUy8_g@mail.gmail.com>
Subject: Re: [ndctl PATCH] daxctl: fix systemd escaping for 90-daxctl-device.rules
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Chunhong Mao <chunhong.mao@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 18, 2022 at 11:54 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Older systemd was more tolerant of how unit names are passed in for
> instantiated services via a udev rule, but of late, systemd flags
> unescaped unit names, with an error such as:
>
>   fedora systemd[1]: Invalid unit name "daxdev-reconfigure@/dev/dax0.0.service"
>   escaped as "daxdev-reconfigure@-dev-dax0.0.service" (maybe you should use
>   systemd-escape?).
>

Does systemd-escape exist on older systemd deployments? Is some new
systemd version detection or 'systemd-escape' detection needed in the
build configuration to select the format of 90-daxctl-device.rules?


> Update the udev rule to pass the 'DEVNAME' from env through an
> appropriate systemd-escape template so that it generates the correctly
> escaped string.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Chunhong Mao <chunhong.mao@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  daxctl/90-daxctl-device.rules | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/daxctl/90-daxctl-device.rules b/daxctl/90-daxctl-device.rules
> index ee0670f..e02e7ec 100644
> --- a/daxctl/90-daxctl-device.rules
> +++ b/daxctl/90-daxctl-device.rules
> @@ -1 +1,3 @@
> -ACTION=="add", SUBSYSTEM=="dax", TAG+="systemd", ENV{SYSTEMD_WANTS}="daxdev-reconfigure@$env{DEVNAME}.service"
> +ACTION=="add", SUBSYSTEM=="dax", TAG+="systemd",\
> +  PROGRAM="/usr/bin/systemd-escape -p --template=daxdev-reconfigure@.service $env{DEVNAME}",\
> +  ENV{SYSTEMD_WANTS}="%c"
>
> base-commit: 97031db9300654260bc2afb45b3600ac01beaeba
> --
> 2.35.1
>
