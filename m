Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BBFA41
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 19:52:15 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso242157pju.1
        for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 12:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G2iZR3G5mWvgb0EiuM+eFBFAOPzzm3GLNmOGZsolqsw=;
        b=ZKOzPFki/YDNaP7/ulo6zUcA1+rJRzxmC0UVCcPpxhmM0eVKrwu6+2KuvFW0oGNJdF
         aSy//bfDrVS7sJ8M/oVdjWUZJ9qKNCOQRv5+C8kxOr9TX3Q1n7zGwq+S767fYcFGM+e5
         uyjLFjot8jHeS5aUJuqQXhF3w9owl4YO5Hy18/1cQI376ovUZ/SsC4xZKJiGNset53bl
         dt7pkmUOma0FiGxCDNCb6X4eLlmLAO8FVWP303cVjFx3uJPz8hwkOmK9+dj+L1PbteQH
         014zBd0WbcqqWjRfkr1ukMp8jJuBMiTcmbm+cMJK4rZlby4tdryieYFLP0inMgmfBoLp
         z56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G2iZR3G5mWvgb0EiuM+eFBFAOPzzm3GLNmOGZsolqsw=;
        b=VRlLihUeYANOoszHZbgWAXvLjnBDMab3aOyc+2Sl922UwBltu5DHQLmjDf7ry86IK9
         X++NbgrUCSCSJxPGiGFgnZXZmd11m+Pzf/F1YL+twHO/dw3Nt2qugwnUMmcH3oZ+kCzY
         /47M/uZhNYBoXFiq8zv2mMBhcfrHn0NFswYm1LELNjjZ+e19yWWIkn/9tlAKzxWa4Wke
         lJ522d+MPY6gWmVlZLk1OQKzXpyo8z9R0eM7Ow8+495Xi6iiwn3Pa8TDHF81HZGgdRkm
         SVDCSeVcjiYuCjSocQ51No5ANuZKyIlQJh3a0VVtRkD/GyUWWslefrhTtjzS8x2uPOOE
         kPjA==
X-Gm-Message-State: AOAM5319RlCQK8k8AmyxOSKfgNTT5H+aK0AvkxMk7FglHxxCc+FrcOur
	Kn6WRl/j+wZafKeXdgal9Kxm3377cxmX1uFRJ+jyEg==
X-Google-Smtp-Source: ABdhPJyKD6O2gCu3sd8S0GELv7WPd1P8GI98J4u6MKZC9sR09oWfO4jeuYGQ1jZR6/SgsQ7pY9ovi59w/BvY8cw7QVw=
X-Received: by 2002:a17:90b:4c84:b0:1d2:cadc:4e4d with SMTP id
 my4-20020a17090b4c8400b001d2cadc4e4dmr603755pjb.8.1650311535207; Mon, 18 Apr
 2022 12:52:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220418185336.1192330-1-vishal.l.verma@intel.com>
 <CAPcyv4h+r4Oq=y+B9H+E6AASbj8=V+NcdU+5S88-i-yfOUy8_g@mail.gmail.com> <ba4de425d48d36b9bb116e0ff0c30e9fc1b70d69.camel@intel.com>
In-Reply-To: <ba4de425d48d36b9bb116e0ff0c30e9fc1b70d69.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Apr 2022 12:52:04 -0700
Message-ID: <CAPcyv4imqnOkiSE0rg_Oe_dA1ZLQ20mGSQOc3c-6uJfJV5O6Qw@mail.gmail.com>
Subject: Re: [ndctl PATCH] daxctl: fix systemd escaping for 90-daxctl-device.rules
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Mao, Chunhong" <chunhong.mao@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 18, 2022 at 12:48 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Mon, 2022-04-18 at 12:15 -0700, Dan Williams wrote:
> > On Mon, Apr 18, 2022 at 11:54 AM Vishal Verma
> > <vishal.l.verma@intel.com> wrote:
> > >
> > > Older systemd was more tolerant of how unit names are passed in for
> > > instantiated services via a udev rule, but of late, systemd flags
> > > unescaped unit names, with an error such as:
> > >
> > >   fedora systemd[1]: Invalid unit name "daxdev-
> > > reconfigure@/dev/dax0.0.service"
> > >   escaped as "daxdev-reconfigure@-dev-dax0.0.service" (maybe you
> > > should use
> > >   systemd-escape?).
> > >
> >
> > Does systemd-escape exist on older systemd deployments? Is some new
> > systemd version detection or 'systemd-escape' detection needed in the
> > build configuration to select the format of 90-daxctl-device.rules?
>
> Good point - I think we're okay. systemd-escape was introduced in v216
> back in 2014 [1], and from a quick glance at repology, even the oldest
> distros are at least on v219 [2].
>
> [1]: https://github.com/systemd/systemd/blob/main/NEWS#L10370
> [2]: https://repology.org/project/systemd/versions

Ok, cool, looks good to me then:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
