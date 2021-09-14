Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254B53FC4
	for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 12:22:15 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id gs10so3049019qvb.13
        for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 05:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4EfrPUEpZjNfYI9C9dwg47FwF8i42QF8x9451dn0m4k=;
        b=HksAniPk7LVuwk4QXw91xIeDEH63QADXXNCPrzlxfG58hI6T4TKL6ofbJJbK1Cmy31
         bUNdjy3bmOx7A5P8l51h7wl+w8eCfufrBSh10bRXxZY+Mlj2Z9yW1qJ+AvThPBY0j82d
         I1CTpm/Z4MNDRo2KQqSkAdeNaCj6bq9dko9H0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4EfrPUEpZjNfYI9C9dwg47FwF8i42QF8x9451dn0m4k=;
        b=cxbaiH2y6s5GrWV+fiKXJmrOxYHseQ5HNEZ/WNfvwh73m4SU1uqz+obxU9vZFk8V0N
         p4syaxtoRh8SIF2BYxDuvgIGmxsOx4iV4COhnUWIdbPYDpKPiIaeDfdxUvuKdDwI1Jkd
         /DGWTahLZLpMLxiBKDcwLMR2xFF1LyAo89q1fJp7/7cCuxLI5QgttrfeaWZ4kItotoKF
         Wi7wZ83tAzUr1XTT0BPFL3TclYQzulLXAcga8Fr4U5g2SgSplB7mq8v5VtQh15pYCqRn
         /50o7ekRzf9QaJpum2JhHBttVQ83XO3bzeLEckfdgenZb56XDk3Hsvx3f/AMTao2TcwX
         in6A==
X-Gm-Message-State: AOAM530u/YiYWOPoFMNmDmZerfNmpbkwLnKT08rKhZ3oXRyAuDuLcI3x
	dyuRLIyRoi15ZSso1cL577rbNw==
X-Google-Smtp-Source: ABdhPJyvEG2pQ5qGBNdlYnK7urBC3ENhewUIxlVZV2tRwF3c8rp5TYOrYBYYbckZqoPkRVEs7E9ZVQ==
X-Received: by 2002:ad4:522c:: with SMTP id r12mr4831569qvq.17.1631622133662;
        Tue, 14 Sep 2021 05:22:13 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id a22sm5904669qtd.56.2021.09.14.05.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:22:13 -0700 (PDT)
Date: Tue, 14 Sep 2021 08:22:11 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH v4 14/21] cxl/mbox: Add exclusive kernel command support
Message-ID: <20210914122211.5pm6h3gppwfh763t@meerkat.local>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116436926.2460985.1268688593156766623.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210910103348.00005b5c@Huawei.com>
 <CAPcyv4i48AHtHOAJVsDKQ+Zg2QqnvQg1Ur8ekb6qR6cRDbkAzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4i48AHtHOAJVsDKQ+Zg2QqnvQg1Ur8ekb6qR6cRDbkAzQ@mail.gmail.com>

On Mon, Sep 13, 2021 at 04:46:47PM -0700, Dan Williams wrote:
> > In the ideal world I'd like to have seen this as a noop patch going from devm
> > to non devm for cleanup followed by new stuff.  meh, the world isn't ideal
> > and all that sort of nice stuff takes time!
> 
> It would also require a series resend since I can't use the in-place
> update in a way that b4 will recognize.

BTW, b4 0.7+ can do partial series rerolls. You can just send a single
follow-up patch without needing to reroll the whole series, e.g.:

[PATCH 1/3]
[PATCH 2/3]
\- [PATCH v2 2/3]
[PATCH 3/3]

This is enough for b4 to make a v2 series where only 2/3 is replaced.

-K

(Yes, I am monitoring all mentions of "b4" on lore.kernel.org/all in a totally
non-creepy way, I swear.)
