Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6698870
	for <nvdimm@lists.linux.dev>; Wed,  2 Jun 2021 16:47:11 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id r1so2718752pgk.8
        for <nvdimm@lists.linux.dev>; Wed, 02 Jun 2021 09:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XirRttjcG39/qkr+GuwPNTRMUYyhbdVM15E9hG08o18=;
        b=mJsJG0mdnSHaBDfV6OV5/53+KdPoIIBr440OyD2NZxLXTSoRSoIIKMPGZ2FK6iMNCW
         J+AwOk6Pl4i3bbRBxM/JzhSnKljc2LRivoEsD/mT+XCOqDDHYD2qQP3G1hL0f1PoDfNh
         SJzHJfbhz8rWoj+V2ulZ5EoO1tNuw+QmFN/7aCJEvS+5t6w+p/e3tfLLODsN1jCwoswB
         sOFgFrFeGeNtvvuJUqTZZ4f5Es6b1nIO6Uk5STvRdEx8BV785PDAmC1gOyDEHfn6VAcL
         cCpd88UJkL7s2n9zrg2DIyp8Omkt7E1rGWtUI1g33BgR/6fZ99pfVNet87vLI0e/dA7E
         O3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XirRttjcG39/qkr+GuwPNTRMUYyhbdVM15E9hG08o18=;
        b=b3mfuisjDr0ppHCt+EHMvbtKx2UJaT/LKuJLUum2rbmJy5IvKwABUbwaTkzhtgPeDK
         7MxrVIcGrpkJGY5PGybXjMINtE9///+HiadsBcaq0Y82PhwFydqTMAwA3iPnSf22nRP4
         Uux8kPMaDSqEcUtW0PsZBVhebicRPwuY0nydMv1q8GiGRsUqv1jNCUmGbeVZtAd8w/k3
         loehJzwcTlOH9t0BoAZSHDA1qzUhx0K0gNKM0hy9tSV3Ig+lu/LlCbL87Lc2Oxv0KzLG
         qCEWeXA5Lrb19cMJJNyAqInBFv3+QeTAZAO6nGbjWRYCuVwPIvo9XOKShAWRs80wG/Cq
         /TfQ==
X-Gm-Message-State: AOAM530FfGkKHQgZFWvJqZV4q2+nm+xMrnB+X217Ia6XOqnGD1Shaw+m
	f/Iex4nVlDNFodmkZ3K6V704BKRJMJeHTLXUvIg+WQ==
X-Google-Smtp-Source: ABdhPJytI8Euvl8f2ipgLESNac2gjSRplyjSdYO0BIzw4s4rcoQN7gbyhyFWqZ+EMEjcGUI26zvR/vnEzLlgbJIqi1E=
X-Received: by 2002:a05:6a00:234f:b029:2c4:b8d6:843 with SMTP id
 j15-20020a056a00234fb02902c4b8d60843mr27769991pfj.71.1622652430785; Wed, 02
 Jun 2021 09:47:10 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210516231427.64162-1-qi.fuli@fujitsu.com> <0e2b6f25a3ba8d20604f8c3aa4d8854ade0835c4.camel@intel.com>
In-Reply-To: <0e2b6f25a3ba8d20604f8c3aa4d8854ade0835c4.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 2 Jun 2021 09:47:00 -0700
Message-ID: <CAPcyv4inknvApE1xZOiK8u2xPLejuqixf_XKbS05fPKvno+Yyg@mail.gmail.com>
Subject: Re: [RFC ndctl PATCH 0/3] Rename monitor.conf to ndctl.conf as a
 ndctl global config file
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "fukuri.sai@gmail.com" <fukuri.sai@gmail.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 1, 2021 at 10:31 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> [switching to the new mailing list]
>
> On Mon, 2021-05-17 at 08:14 +0900, QI Fuli wrote:
> > From: QI Fuli <qi.fuli@fujitsu.com>
> >
> > This patch set is to rename monitor.conf to ndctl.conf, and make it a
> > global ndctl configuration file that all ndctl commands can refer to.
> >
> > As this patch set has been pending until now, I would like to know if
> > current idea works or not. If yes, I will finish the documents and test.
> >
> > Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
>
> Hi Qi,
>
> Thanks for picking up on this! The approach generally looks good to me,
> I think we can definitely move forward with this direction.
>
> One thing that stands out is - I don't think we can simply rename the
> existing monitor.conf. We have to keep supporting the 'legacy'
> monitor.conf so that we don't break any deployments. I'd suggest
> keeping the old monitor.conf as is, and continuing to parse it as is,
> but also adding a new ndctl.conf as you have done.
>
> We can indicate that 'monitor.conf' is legacy, and any new features
> will only get added to the new global config to encourage migration to
> the new config. Perhaps we can even provide a helper script to migrate
> the old config to new - but I think it needs to be a user triggered
> action.
>
> This is timely as I also need to go add some config related
> functionality to daxctl, and basing it on this would be perfect, so I'd
> love to get this series merged in soon.

I wonder if ndctl should treat /etc/ndctl like a conf.d directory of
which all files with the .conf suffix are concatenated into one
combined configuration file. I.e. something that maintains legacy, but
also allows for config fragments to be deployed individually.
