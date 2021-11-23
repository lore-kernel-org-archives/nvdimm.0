Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F069E2C88
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 04:16:12 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so1052393pja.1
        for <nvdimm@lists.linux.dev>; Mon, 22 Nov 2021 20:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=wbQ/MsU1SlEZ9iPye0o5lHnBo9k9LahEnJdnyRzgTrQak+nTOXkgXVWM7OQWluPbzr
         HkVEy2FdigRG5kYOuK1opEJwN/rn7TguLqcAFU7ncMwpwdXChRFN2sqd+bTf3F8BInaK
         fFwg0qsn775RNQiqooEO5yKgWsV+2wtj+cp01Q2NasJFqL66eojelACeKHvYSEfu8Xag
         ROr6vP/wogp7HYAtlyseVafxuCM7Uz2wx46f9H1VqNuffEtgZng2NeCkac5Ick13DKCh
         KqqsG7JaJle4G2RoQ9CsAKmA2/ICYEEBHwUPSN/D+pEwjOibiGCRqmiwftUbhvO4xY/f
         BPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=5f2nSVPjjGSl0xLrT2MHYgeDSwOangyXDOL1BgvTKYjxtLmcKg9J6pLdJUQ60M0kaL
         6GeRVZqP+pgi8gNjxF4XNtciYSYa5Cmxrdq5E2gf8BXMKPF1rTF8xMDjd0q9X1jnb9Ir
         KEooO4xQcAIxqLu1YC/5ILiYa7GE9WFMEwnBrdTKzWw6LsXnm1smemxRl27+qqNbOXiV
         Qtfs0x11zL2SrJAYiroGaLrDhxHSVAfRPOu3Ih57oDwOncO+hPWDXAa1Cvrn+HIGxA6V
         n+gw+UymxXO17PKZP1n+v9cre3DPV2tUB9qJqb5rjDUCmKAdcl3L0xom2Rha/A8WfFDQ
         XK4Q==
X-Gm-Message-State: AOAM531NGC3ymD8+vr40MRObYhi3pl2XPwT8anrrhNJcPUyGtiDxtU13
	RoENOeZMOdZW791OeikZ/vq6yX/Pn+9AKGXYETP/iA==
X-Google-Smtp-Source: ABdhPJxjpKB9AmBnKHF1Qu0JurlIqhEs9/usKwuqw/rWaPu+iQDfW+wdKRq+mST3BpRIgHuCjkJcQHKsTKAjjneenA4=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr2831805pjb.220.1637640972493;
 Mon, 22 Nov 2021 20:16:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-12-hch@lst.de>
In-Reply-To: <20211109083309.584081-12-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 20:16:01 -0800
Message-ID: <CAPcyv4hG7npC3K-5th7qFNHuNt=dT-atUwvMEwbH_DHqzVhi=Q@mail.gmail.com>
Subject: Re: [PATCH 11/29] dm-stripe: add a stripe_dax_pgoff helper
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Mike Snitzer <snitzer@redhat.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
