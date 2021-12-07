Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B30B68
	for <nvdimm@lists.linux.dev>; Tue,  7 Dec 2021 18:24:56 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id g19so137399pfb.8
        for <nvdimm@lists.linux.dev>; Tue, 07 Dec 2021 10:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k14opGzW04vpA8hwMNYzsNtLvPJmhijxj4DBemiaOxo=;
        b=uy7jnDuCr7zkUD7gqH2chSaYW3ca//0v6nBUg099JvaW9XvoIvweVUYu1IGtNmrbjg
         lfh0YNQ+UgCpKeru0C9YQKMP+7dYdc9/M2UpxTFefb3Jgp1Xv0x241h9dWH+70hG3WGq
         B+w/EQXk/3dR/4+Jczex/41YrpfRHLKA9UEIxFAe4BHSdS7Jo2WQuZF3Z9HGir30E5LD
         9OmApN2FW43866qRxvw1AqQVZ5S05jEK19xrbKMo9fDZz/sJMVvvyEZL60NtSN7XWjnf
         NtcQwlFmKbeCqeETSif1jV3wNPDPZK6ybfucTRhpOJe8SWMuwuIjaQv1GIyQ8O+RAAM0
         6tng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k14opGzW04vpA8hwMNYzsNtLvPJmhijxj4DBemiaOxo=;
        b=7AMrkLEazcsqUr6luCIlNo73X/Paj/yZElGpYu5nRouP+rNEVb1yJZ9jDdnyFexi7Y
         F9YfQN+mo73Kn7TjwITSptiaPuws54thvgVA8PL0PRc88fgbfgRxw0+7sS5O34kt+ZCf
         QT9dgu4oSPOq7dNOaLwnOmWsmkOkEpioWWIzKCjrK4vayyVSnvkTOiZsDI8XJG6ex1HT
         1W1yf3Vgh6Sb7/rDNaKOIP9B6BuzOLcLxqlAW2kroDZfk4HOLa62bN+Qi9bADhdy+JgM
         hBDCD/SMjXU6ErGJNps7dVhnc0B3q+Hg4/UMvjEBvwAuHHZbTeP2o8IJ0FP/BxLKIMeY
         TZXg==
X-Gm-Message-State: AOAM5339Nz6RuPH+ar35/WIOx51tNxntjkwp+sAMWQTIlTLwmBiFqbt4
	WsPpojBH4lZe1ChLj9kRrV/0Taf0lDd06Ln70xsDlg==
X-Google-Smtp-Source: ABdhPJwSuwCIglETEx1gfdcAX2yeIYBy5qtpzCYB7X6u6pVWxT3w0rEqzywzhgWR1GvyjJvFvkO3yYe8KggI4XbdZy0=
X-Received: by 2002:a05:6a00:2405:b0:4a8:3294:743e with SMTP id
 z5-20020a056a00240500b004a83294743emr630497pfh.61.1638901495605; Tue, 07 Dec
 2021 10:24:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com> <20211206222830.2266018-2-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Dec 2021 10:24:44 -0800
Message-ID: <CAPcyv4g4cJ_sdRT_cO9T+g_xjMoaboW+ZfHB98KL0NJaJoS1zA@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 01/12] ndctl, util: add iniparser helper
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> From: QI Fuli <qi.fuli@fujitsu.com>
>
> Add iniparser[1] helper for parsing ndctl global configuration files.
> [1] https://github.com/ndevilla/iniparser

Is there a reason this is being copied rather than linked? The ccan
code was copied because no distribution packaged it up into library
form, but iniparser ships in Fedora and Ubuntu. Unless ndctl needs to
maintain a fork I would prefer to link just like json-c is linked.
Even if ndctl needs a fork I would expect that to be called out here
with a plan to eventually get that forked feature into the upstream
iniparser project.
