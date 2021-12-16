Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B879E2CA7
	for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 21:47:48 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id n8so138597plf.4
        for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 13:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/5QQZVTilidSJESUxfMc6YFEpPcA1P1FBadbp/LbNrQ=;
        b=XVxPzUzw8NsO/FvOCA/67Ns/m3tf6CDm7igi+y/KbTyTiZrE5xJCRW8NPSVP5JmgG/
         gKREe8dPwN+7WXh7mC/0lDVOKs2dbk3gpEUVGOKFgeE43kCCHRisQq+/gibSVxsP0g4M
         hpI9d2REC/rXSQtudQhuqxg+0DKqi37zOho2DgGBVaRJAV2OjIYzhMWI9c8zRnDzlZXP
         JRWzSYvBmSGCeIBV45FM2CRzhmt/MrQjd6xac6Eo7TYQDZfMfvuq0+Kbl6ROFOVYVRuR
         L4FA+/H1s+SKzhJG/g2MyqPvX16nWTDeJ656OSV5eYHC1R653D1Q5Vh/5W7lme/vdMTH
         SsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/5QQZVTilidSJESUxfMc6YFEpPcA1P1FBadbp/LbNrQ=;
        b=uqbqooOnsIoQtnhdPMs9N5v6xQcKFa0P2Yh9QtjCll/k0VP+FqnHUyDw1a1uTaeJ65
         YLck6VAspZc7arpxRoG4cV/Mf3iWUCuN8S8NEpPg1NX2c3AH6TYxoy13+iCkMgmMEEdx
         pjwzRNW3DYm9zSa2XTslWqA9Iy6DvjwPhd/0JIuwrYh3BmiygLVqS0vW9KorgPLSuSl/
         NIuKMTH9BzqR8gasIM2/39CFPApCN8/8r+Cti89KgzgBYJY/P8e43wjNHzgaxzlFIp0u
         MueO+oaxSP5sWhERW+gFz1gI18W00Kc3vwwwV4NFNValzOyM+GaC3qoU2NeK+ZTMehsK
         tWSw==
X-Gm-Message-State: AOAM532Ucnt2O7kpoUzgifb9xB5TzLJNRJg6Z6vasVjfZh7U7h2Z/M6s
	i68Pa36uTMKT5hEAq8gsKevJpKMWjAybswhcymN9tQ==
X-Google-Smtp-Source: ABdhPJypTw+fEBcjbhSJmcga+YUIn8GvXyOjsS9mkj+aIoDdo2xaHq+iPB9AYkhy+ONoWgC92UrgzAUwOJbHaurHJ0w=
X-Received: by 2002:a17:903:41c1:b0:141:f28f:729e with SMTP id
 u1-20020a17090341c100b00141f28f729emr163330ple.34.1639691268288; Thu, 16 Dec
 2021 13:47:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211210223440.3946603-1-vishal.l.verma@intel.com> <20211210223440.3946603-3-vishal.l.verma@intel.com>
In-Reply-To: <20211210223440.3946603-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Dec 2021 13:47:38 -0800
Message-ID: <CAPcyv4j7_Ty=pHDpEC8+r6Tq4R9sVKSXvmid+Rr1LTMFMd3c6Q@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 02/11] ndctl: make ndctl support configuration files
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 10, 2021 at 2:34 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> From: QI Fuli <qi.fuli@fujitsu.com>
>
> Add a 'config_path' to ndctl_ctx for supporting ndctl global configuration
> files. Any file with a .conf suffix under {sysconfdir}/ndctl.conf.d/ will
> be regarded as a global configuration file which can have INI-style config
> sections. Add an ndctl_set_config_path() API for setting the default
> configuration files' path for ndctl. Add an ndctl_get_config_path() API for
> getting ndctl configuration files' path from ndctl_ctx.
>
> Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
