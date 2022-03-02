Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A9120E9
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 16:36:32 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id t7so985435ybi.8
        for <nvdimm@lists.linux.dev>; Wed, 02 Mar 2022 08:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvGAdBIf+bhILkDwd1RAEBaMeGjQHU2I0tTcLA9pmuw=;
        b=aAyu5bHKJqIp441YF2+QuC3yiYQFcCb1oCHNWez7DsaiiA7c5mNyBbh2KvkB4Y8+Ee
         pnfqzHo3e0UzW587YQEIk6iXMFh+bg0TmoxZt800kdB2iUP2zzBNEw4Q6TrcT6y9UIwU
         sd2Ln1X9Vaa2UM87qy8i5rb8QJDDzhtKIWBYwc/bWnE0Vp8RlLV0u4r9/6wBCu/zYQJS
         CDv9obfQ+YiE2DQrQIchgSxBiN9MF9XkJVuPxg28sfQjkd3lUZ3vBqQBd6WqSHlcjff9
         N6YdfDOXvtBOKfWd6Dy7qNb2AaCAjWl9drulVp6ncGs+xdez7B7NtDtreFNum6YySDR7
         rLnw==
X-Gm-Message-State: AOAM530PCbwOxkl1HKLpjDkxb/QJR9UWI982IRj1whR4NfC7rxWbYjxH
	cNxPNiKoZ3nEzUezG4+RcLIvHrZuNRwH2U6MtpM=
X-Google-Smtp-Source: ABdhPJxn9LMC8lwWO4YmbVkZlEVT1jBmWUWdBg1cMfWRsu7mg1BUeW+rNNGEaSftaTVtMzJb7bwJ16HO+lMGdkKcQfA=
X-Received: by 2002:a25:6649:0:b0:628:a0c0:f0e0 with SMTP id
 z9-20020a256649000000b00628a0c0f0e0mr3022520ybm.81.1646238991427; Wed, 02 Mar
 2022 08:36:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220211110423.22733-1-andriy.shevchenko@linux.intel.com> <Yh+SHs4CEWkiLxAe@smile.fi.intel.com>
In-Reply-To: <Yh+SHs4CEWkiLxAe@smile.fi.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 2 Mar 2022 17:36:20 +0100
Message-ID: <CAJZ5v0g_3a7A5aFab6ZsM8nPDmivoTeNgdSG17Lt71mFKmNxmg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] ACPI: Switch to use list_entry_is_head() helper
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Hui Wang <hui.wang@canonical.com>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, nvdimm@lists.linux.dev, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 2, 2022 at 4:50 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Fri, Feb 11, 2022 at 01:04:23PM +0200, Andy Shevchenko wrote:
> > Since we got list_entry_is_head() helper in the generic header,
> > we may switch the ACPI modules to use it. This eliminates the
> > need in additional variable. In some cases it reduces critical
> > sections as well.
>
> Besides the work required in a couple of cases (LKP) there is an
> ongoing discussion about list loops (and this particular API).
>
> Rafael, what do you think is the best course of action here?

I think the current approach is to do the opposite of what this patch
is attempting to do: avoid using the list iterator outside of the
loop.
