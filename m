Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EBD70
	for <nvdimm@lists.linux.dev>; Fri,  9 Jul 2021 19:01:39 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so8775260pjs.2
        for <nvdimm@lists.linux.dev>; Fri, 09 Jul 2021 12:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n2As/cHDYJne46jbdng0n2D9gYW0Q1fIPBC2w03oUSE=;
        b=aOwDvFEUPpg1Trss2Il+JeALQBiA+1LzhzyWzobHjQz1YE86r7qTCYC9dAd+fpgAU6
         GfivjnKdSyy1fyvtpyjPRcuuBXfmUCoApRgETBaKpUgpOvI3aMdEe4eYVR0h6lQJCl/n
         IhjGQKjIAGNXfQFnUksJ5sed4lpTsOgFMIhxfTotxfTwQ1GyvxYukYLYMhdiBM68+gE9
         bL6hfj8yhznCjP2etJIIh+Ijw9ylAbaHLO5/7FhOs+MuqOiZBRmkh0xaEqZSD9ttUxpQ
         /Km4mXo+KEBBA+PQH+3OsErzKvdDpzholoyeIzOtn+yE9KeT8ZJr/CUBqeIs0m+SxrJd
         wtuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n2As/cHDYJne46jbdng0n2D9gYW0Q1fIPBC2w03oUSE=;
        b=Wos6UJ5GUEwyA8uyOtC5zEz3KeBBgsqpjVIUeJt5vgrEzz4DnLp3Rqin9TuBVRGkEY
         C7Ob7hOTr7f/GUqjSdm0Ji38pob1iVc0JgiHQBWMFXU5R8x6qBaAAFC5zE4YyqJZmMsa
         RlhiImpZG5y5QoSJuV5X7B4Eu+Am2s3A6p7tufTlKiNJtN6znMCmOEagvz0cQmqJr4+O
         5tqe5zaeJ6fxP7VC2BEFyEFbFOUJsvecRqjY9lCFFKs+07UKG41tSiFtF0peyNzggTzS
         aYi/Y9Xr24FznDu4Oh5aa2o1iVNrt7EV6cuMHUwpSn9ZnLg9/DlxW5l6awosuJxzXFEz
         1OoQ==
X-Gm-Message-State: AOAM531ZU71V3cNSDg3GKhRjyIoHUewuYBN033Rcw6ayGpXUu6y0o5J2
	LnQgzKMPVsLf0ax1hbEaV7LJCPTZer4oZVAz6RzJvw==
X-Google-Smtp-Source: ABdhPJy5EdiiEph3NwjJ0+bxCpVXSih9DXcBNVNlY++Rjqfe1plGMmMUY03NieIKNEI/dQJoRXWFvPI0OyOmmD3QZ78=
X-Received: by 2002:a17:902:6bc7:b029:129:20c4:1c33 with SMTP id
 m7-20020a1709026bc7b029012920c41c33mr32251782plt.52.1625857299034; Fri, 09
 Jul 2021 12:01:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
 <CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com> <YOg/vKafc5PJf/GE@angband.pl>
In-Reply-To: <YOg/vKafc5PJf/GE@angband.pl>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jul 2021 12:01:28 -0700
Message-ID: <CAPcyv4jVvr0zBvf4_yf4KGB2CYLX4h_NczM0g+so8EOiL8CyEQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] ndctl: Add pcdctl tool with pcdctl list and
 reconfigure-region commands
To: Adam Borowski <kilobyte@angband.pl>
Cc: James Anandraj <james.sushanth.anandraj@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, jmoyer <jmoyer@redhat.com>, 
	=?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 9, 2021 at 5:23 AM Adam Borowski <kilobyte@angband.pl> wrote:
>
> On Thu, Jul 08, 2021 at 02:24:04PM -0700, Dan Williams wrote:
> > [ add Jeff, Michal, and Adam ]
> >
> > Hey ndctl distro maintainers,
> >
> > Just wanted to highlight this new tool submission for your
> > consideration. The goal here is to have a Linux native provisioning
> > tool that covers the basics of the functionality that is outside of
> > the ACPI specification, and reduce the need for ipmctl outside of
> > exceptional device-specific debug scenarios. [...]
>
> > I will note that CXL moves the region configuration into the base CXL
> > specification so the ndctl project will pick up a "cxl-cli" tool for
> > that purpose. [...]
>
> > Please comment on its suitability for shipping in distros alongside
> > the ndctl tool.
>
> I see no issues with that.
>
> You might want to suggest whether you prefer pcdctl and clx-cli to be
> shipped in a separate binary package.

Yes, that was my expectation that ndctl, daxctl, pcdctl (ipmregion?),
and the 'cxl' tool would each be independent binary packages.
