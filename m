Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6F670
	for <nvdimm@lists.linux.dev>; Sat, 10 Jul 2021 01:13:50 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id g24so6662497pji.4
        for <nvdimm@lists.linux.dev>; Fri, 09 Jul 2021 18:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E+bsZUEt7jEa9VtBVO5r71NpsmIkbIckeAP5aRj4V0k=;
        b=aoq5VFBqxzjGvZusosc0RibzR+/NCluyJa3/Dauw7DairhXuPjq0/GiVThRhYcAYYd
         RjLunKQTiB9zhcduUAOgKScNYC0mj05Ih+JRM00F0/4gJSokpW/RsoR56Or0EDFW/bjc
         o8zCJqYSjDHAp3xmf15BBKXXpnZxe8cLMiasQLwcCUQ6fygn+bVPx4YlaEygKgjQ6gme
         39rAuSWLhBGXOfxqSAvMcFzDExmeIGqdkQuGVH3e/07vVHnPjvnV4rS0M77/xLTgjJOk
         GUC4aRWRAH2Q0c1VEVlVhu1Gy4QiBgIEkd3TRB3prO614aLPlYgXMmAdWVjGrIj6ohiQ
         40og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E+bsZUEt7jEa9VtBVO5r71NpsmIkbIckeAP5aRj4V0k=;
        b=BOOmBOdxsoUqgZQb+G8iTn3nGwT763Ecw2aIqLj1Jhic21FMICc/lymmonnBzcZsec
         egMTFFJKq7ni0XtjZWqyDSF/v65DLHZ0k7fvL914cjquaMl/k3qEAoj/qPaKRQXmLO2S
         KOMmonKqXRhep/SkEUo+WQYKCrLNNwWhuLGtjDpMcVgxBUvNJy4jsXOMU3GNs09J2rPE
         cjdisjvBWRVQbGreJGjvarK8mP1aagSDGzYwcoaJqfBnFp/MjoHldamIbgSDV7td8CAO
         Hyf0Mja/J4gp6A2L9zXnc6RhPFS2jNSNLOUsWbFYya/kGjGSZHrigPnof0innjHxhVkZ
         xIDA==
X-Gm-Message-State: AOAM532EtBp1hOYEwTslW4VJYko74CsW05+2bN+YcjPAp70PW6qytxpA
	zugg6uIR7YRBNTeHFC9RC0CfrK/peiH/9RHtHw7c+A==
X-Google-Smtp-Source: ABdhPJw1Pt6X98jWmZ/S4RIkiLdddwL4sIFzXkwHlVH7NCkUn8L9QeVbvkjXOUp7tp7a7ErbNdC2Zu52Q2oYWYOnenk=
X-Received: by 2002:a17:902:6bc7:b029:129:20c4:1c33 with SMTP id
 m7-20020a1709026bc7b029012920c41c33mr33330183plt.52.1625879629987; Fri, 09
 Jul 2021 18:13:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210701201005.3065299-1-vishal.l.verma@intel.com> <20210701201005.3065299-4-vishal.l.verma@intel.com>
In-Reply-To: <20210701201005.3065299-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jul 2021 18:13:39 -0700
Message-ID: <CAPcyv4gsABLaFD0gvQBDjmn2qszXZsMy4GXH-BciUyBBAPEn2Q@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 03/21] cxl: add a local copy of the cxl_mem UAPI header
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org, 
	Ben Widawsky <ben.widawsky@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 1, 2021 at 1:10 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> While CXL functionality is under development, it is useful to have a
> local copy of the UAPI header for cxl_mem definitions. This allows
> building cxl and libcxl on systems where the appropriate kernel headers
> are not installed in the usual locations.
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
