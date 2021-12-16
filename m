Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D515A29CA
	for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 22:45:35 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id np3so481161pjb.4
        for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 14:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AU5bvcnjro+pUZR0IisP79Qq2ETu+5BdWmCxxNFkA+g=;
        b=kBUkDqiB5vbKn2Ft14KOvH8TMvu6IfB4naFo5DBYOQUoB12EGGyQA/L4GWWzv96NV7
         V9oihq83zEtIGiZ+YhyShqCSPBNkWV1HO2E3rQhELhKgS9fP+uyjs28SPRlKpsDfx0PR
         fTy4+SrZGA/oa3e/Wh3KRAsSrPtWLqbntVuaEsJgMbL1m1o5Txv3WUPaux9hAwn+98Jl
         lP5Cs+gCdlUVzMx63tf3603P0oPBYAMCkeNMSNLitTUp0DTawJibSmVx3Lxhr0V17wA6
         CsV7fzX1pcJQrQcItDNEgc3YIBN/SVZvWtfVgMycCYyZ/W5Nf4FvQalM1hq3PIrc71Ef
         P4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AU5bvcnjro+pUZR0IisP79Qq2ETu+5BdWmCxxNFkA+g=;
        b=53fq4LUArsUn8dQ1aTaZkF0CwaicnOW63paujh4KgehqIXyjNrx9XfaEy4f0n6dHHU
         iW5BohUnJyESwPzlH+FuIfkt94I1BIG6rz99NOnL2hYJTV8/8QDnM4ngw9ik5EVreIVC
         MG8KYIgpm1Rt5rm5/W/bk1Iv8gDQ/8b32sS6ZETDsEDukmBLsch3/IdzqRH88AjGEUXi
         HlRIBdnZuBN3/GqvuJS+k4X3IfdpJft/jAYkdpiqv4aJ3IGAdfW/yoVpYpE6NXWh3RKc
         UPpdgT6x+XrI+KKiqD3FSDAmOncOLTxDQa69rmuj8N79VdQSNsVRK7VhPqVUFZvDEI+g
         8GKQ==
X-Gm-Message-State: AOAM532OTfiisIS3xz+GyRmXqGgvm0IkcdysHO5WMIxD2pi9ZmrjwRcs
	Dk/0618iSqcvByKsJC7g9zdgM28OMCkgSraFwqY3cTJ3sq0=
X-Google-Smtp-Source: ABdhPJxNYStA3tp30agMpifrnW3iu7s2/TZDm7IpBG9gAN3Ut4yiFDlW+dpMdNg2OhVS1BOjGwRRRjV+5Xa4TEoE5hk=
X-Received: by 2002:a17:90a:e7ca:: with SMTP id kb10mr8585327pjb.8.1639694735431;
 Thu, 16 Dec 2021 14:45:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211210223440.3946603-1-vishal.l.verma@intel.com> <20211210223440.3946603-10-vishal.l.verma@intel.com>
In-Reply-To: <20211210223440.3946603-10-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Dec 2021 14:45:26 -0800
Message-ID: <CAPcyv4gXVKSfc2=DBS+91p5fv+HanV_XUoFKzjxa3HKKw3pSpA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 09/11] daxctl/device.c: add an option for getting
 params from a config file
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 10, 2021 at 2:35 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a new option to daxctl-reconfigure-device that allows it to
> comprehend the new global config system in ndctl/daxctl. With this, the
> reconfigure-device command can query the config to match a specific
> device UUID, and operate using the parameters supplied in that INI
> section.
>
> This is in preparation to make daxctl device reconfiguration (usually
> as system-ram) policy based, so that reconfiguration can happen
> automatically on boot.
>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
