Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB09429CA
	for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 15:51:45 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id b14so11905871qtb.0
        for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 08:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wpm3EKcVYyz7LQSzWSg/19JHgrxbG8xZ10fGoXa6mFA=;
        b=DDAhlig91/9XaQ6Ex1B8amqRl4P77Qh6wJzLlL9yX9K0IzUF+p4ztuhhey1yn9bxSZ
         7JjQg3EEvuUO+l34US04F0v5tdxGBcMDi7JTSD/wJqdOcM3/NQFmZrt8c2A0PFTzxm79
         QO81/MGIXBZB/AzZaoUx7lhUFUPTvgfjymY68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wpm3EKcVYyz7LQSzWSg/19JHgrxbG8xZ10fGoXa6mFA=;
        b=04SL80M+PLN7kTF1JdFP0AY2OkL5x3O/D8B6RBaMMl1mJC/6nRyyCvAAtY+9Fyblem
         ewcJzbSY1mUblxMcmvUGbwQ9lThqbzdJjiykLq/RA1ez5apwGvoFwVVxU3kgCpnpPae5
         wwOSD2CUu9AurgBwKTnWOyXV1wzFNt9I9hXaTs8vRTNi8tYZuwwTQKsdPFPdW436dWu4
         unN0TDSuq/XFJSURCXuELjWm0fuu/AJsqK79Sx+WZAET6V1hwLWJ+PhkqH0/hk7Yxkoe
         OjwJt+E+0Sk6z7An+rf2Z6uLfR3NuIPPJUDpAtVlEY6Rr4DPPxhSCV74KlsPfYlR3HHY
         I1oA==
X-Gm-Message-State: AOAM532ga1ORCNYc4B7oHMW9XK9PqPu67iApQE/+eOo+lwmrkn0li/uJ
	7U+yhLMS5KN8B+n/fkpUbh3RQQ==
X-Google-Smtp-Source: ABdhPJyTkD7AX/OAq0MPZ7v+TkEUDhAIH8BSJ3PJuBuMuksD9qKKq6mx7wPMEQfaGXkmHTzYqcy10g==
X-Received: by 2002:a05:622a:1792:: with SMTP id s18mr5472991qtk.136.1631634704548;
        Tue, 14 Sep 2021 08:51:44 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id c20sm7582006qkk.121.2021.09.14.08.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:51:44 -0700 (PDT)
Date: Tue, 14 Sep 2021 11:51:42 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH v4 14/21] cxl/mbox: Add exclusive kernel command support
Message-ID: <20210914155142.sshxiqaorrmoxfna@meerkat.local>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116436926.2460985.1268688593156766623.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210910103348.00005b5c@Huawei.com>
 <CAPcyv4i48AHtHOAJVsDKQ+Zg2QqnvQg1Ur8ekb6qR6cRDbkAzQ@mail.gmail.com>
 <20210914122211.5pm6h3gppwfh763t@meerkat.local>
 <CAPcyv4j5FxmDX0fjgCKs9V4Avn3JD-5JMt4MxNy3_DH_x_tGug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4j5FxmDX0fjgCKs9V4Avn3JD-5JMt4MxNy3_DH_x_tGug@mail.gmail.com>

On Tue, Sep 14, 2021 at 07:39:47AM -0700, Dan Williams wrote:
> > > It would also require a series resend since I can't use the in-place
> > > update in a way that b4 will recognize.
> >
> > BTW, b4 0.7+ can do partial series rerolls. You can just send a single
> > follow-up patch without needing to reroll the whole series, e.g.:
> >
> > [PATCH 1/3]
> > [PATCH 2/3]
> > \- [PATCH v2 2/3]
> > [PATCH 3/3]
> >
> > This is enough for b4 to make a v2 series where only 2/3 is replaced.
> 
> Oh, yes, I use that liberally, istr asking for it originally. What I
> was referring to here was feedback that alluded to injecting another
> patch into the series, ala:
> 
> [PATCH 1/3]
> [PATCH 2/3]
> \- [PATCH v2 2/4]
>  \- [PATCH v2 3/4]
> [PATCH 3/3]   <-- this one would be 4/4
> 
> I don't expect b4 to handle that case, and would expect to re-roll the
> series with the new numbering.

Oooh, yeah, you're right. One option is to download the mbox file and manually
edit the patch subject to be [PATCH v2 4/4].

> > (Yes, I am monitoring all mentions of "b4" on lore.kernel.org/all in a totally
> > non-creepy way, I swear.)
> 
> I still need to do that for my sub-systems.

I'll provide ample docs by the time plumbers rolls around next week.

-K
