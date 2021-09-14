Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654283FD0
	for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 14:39:58 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id mi6-20020a17090b4b4600b00199280a31cbso2240456pjb.0
        for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 07:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ny4Iw/l0TNDZfHOBQyHos4VqpRE+iwUzJExGaWbUC7U=;
        b=omfk3IvXikMatIM0j00qarQ9R3UZ/Y5XEH0bPp1nghTcYHaSUQSNBupD7asHAkDqcI
         TQXAhG/jjQ2RPVD0o6LzbRxIEk0ncEAdw9FlrlpQmabIn+U3nsHd2AB2sTe8u7Q4H6FO
         Kpbu2BSMbd/HartxTIV/jEIo/dk0BjzSgWl7lMcHBnJ9+FTg4BwXY1obwH2E/sAOdnX/
         yuW55c35FzxIEbuTONFOB1SNcIAzPcy3ukmCME2g16QVuG4Iu2HHmWDUalaL52Ym1VDx
         doJIZ8EofFknbVdT2hWKtCL7nA4r32UBcw+OzM2iClECS1YF4Gn/pPbGPeyOS1b2ILvi
         ETiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ny4Iw/l0TNDZfHOBQyHos4VqpRE+iwUzJExGaWbUC7U=;
        b=pAOZwIw3N0AZl7lgQcoH9zAOO4HOvzjwZ9H8TRdmZ1/WsgKyDhb+BiH5vR54AkRlAL
         +41o5jYCMsp8kk5sOiUgeSdnFG09P7lmrZF1nPjgoc+F49zZAe3XSqmB1v+rebG3aOkk
         +JxHn9JiFgOSstQIttqP6xTlOu3BMnmvHy0kWkQo7Zfm+I0ScsOyyJv8GGECRh6RCFd5
         Aa+hQrg8cRBO6hQILwejwHSxxTq3XTUTjfEBDHWX/5EK9X4uoV85pvPv1r98Jt4Em/G/
         66xQf3LvokjC13+Z42r2iTEJexcJI70HgOucvDU4CsX+DmgtIEW4QSRNEUHXOZNlxUjW
         oX4A==
X-Gm-Message-State: AOAM532CB/vtQZaWql9ZaZjuE4JqwV0gqIOh9JA2LFVLpgQqaYpAOQHR
	Awnsa8X64sNkeqE9SD8KwH1ro2n4AOH2J9ViJaY57w==
X-Google-Smtp-Source: ABdhPJzBeT9wOUlksnXrdvlW92B8z9km4BViKiA8JlXDrw1CVYIqfsNhP9cJVf3Pdh65XWfSZ6L+DVd4NUNleoPCV70=
X-Received: by 2002:a17:902:cec8:b0:13b:9ce1:b3ef with SMTP id
 d8-20020a170902cec800b0013b9ce1b3efmr6727100plg.4.1631630397857; Tue, 14 Sep
 2021 07:39:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116436926.2460985.1268688593156766623.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210910103348.00005b5c@Huawei.com> <CAPcyv4i48AHtHOAJVsDKQ+Zg2QqnvQg1Ur8ekb6qR6cRDbkAzQ@mail.gmail.com>
 <20210914122211.5pm6h3gppwfh763t@meerkat.local>
In-Reply-To: <20210914122211.5pm6h3gppwfh763t@meerkat.local>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Sep 2021 07:39:47 -0700
Message-ID: <CAPcyv4j5FxmDX0fjgCKs9V4Avn3JD-5JMt4MxNy3_DH_x_tGug@mail.gmail.com>
Subject: Re: [PATCH v4 14/21] cxl/mbox: Add exclusive kernel command support
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-cxl@vger.kernel.org, 
	Ben Widawsky <ben.widawsky@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Schofield, Alison" <alison.schofield@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 14, 2021 at 5:22 AM Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> On Mon, Sep 13, 2021 at 04:46:47PM -0700, Dan Williams wrote:
> > > In the ideal world I'd like to have seen this as a noop patch going from devm
> > > to non devm for cleanup followed by new stuff.  meh, the world isn't ideal
> > > and all that sort of nice stuff takes time!
> >
> > It would also require a series resend since I can't use the in-place
> > update in a way that b4 will recognize.
>
> BTW, b4 0.7+ can do partial series rerolls. You can just send a single
> follow-up patch without needing to reroll the whole series, e.g.:
>
> [PATCH 1/3]
> [PATCH 2/3]
> \- [PATCH v2 2/3]
> [PATCH 3/3]
>
> This is enough for b4 to make a v2 series where only 2/3 is replaced.

Oh, yes, I use that liberally, istr asking for it originally. What I
was referring to here was feedback that alluded to injecting another
patch into the series, ala:

[PATCH 1/3]
[PATCH 2/3]
\- [PATCH v2 2/4]
 \- [PATCH v2 3/4]
[PATCH 3/3]   <-- this one would be 4/4

I don't expect b4 to handle that case, and would expect to re-roll the
series with the new numbering.

>
> -K
>
> (Yes, I am monitoring all mentions of "b4" on lore.kernel.org/all in a totally
> non-creepy way, I swear.)

I still need to do that for my sub-systems.
