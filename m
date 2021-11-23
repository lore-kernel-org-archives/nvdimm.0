Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3682C88
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 03:51:27 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso1760336pjb.0
        for <nvdimm@lists.linux.dev>; Mon, 22 Nov 2021 19:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=set6lIbZWt1UwkjEncJQUmHWp82483Zo0VHgKUnBt0w=;
        b=jaUppntJAg9/mAuYY2fdr9gBd/oPSVvQjQU9MV63keKS4G12JP+nEpEbf/XFgQhTnX
         lYhroHBz4A/n/ueNjXRdi4PGz3IaMMWx7LGsyQ+k3PmsLBwgA59MgQmr1YDS9DWkwjiz
         h84Lz9nQApqhFCv5vhWhKtFCwv3whkuknXHpmp6xY5puSg20rPurJJzE+22u3JyTEE6e
         V2urCXYlCDQCwVaaqgneBsM+4H995+ijZVTqf+fHfdEatR6QlNecFf1J/UGHfHqEPUgZ
         uA/eGzna5QhHm2jHR+WAFoVlyr/aaF9uDy12SjgTOzdukRcbvTwMgK4DzpeCeqXvlNDK
         as+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=set6lIbZWt1UwkjEncJQUmHWp82483Zo0VHgKUnBt0w=;
        b=b/7kzjTSif1kB2gR3Pwef7U2o527mi5J3F3mtn6DTpWVQd8bG+GtW1nvuvB74ouJso
         s+eeKhO7jJaGHypCP+5b0llQS22yMbovmw0JnQULyUrkKDHE/Q7r2BLY0kF4+BDm0Blq
         0lDYcmdBLAGkKnyc2/Hc5FSApaj4eIJkp0yAkPCOudtgLmyQsj/QhrFVmHdRAZJO+C0Y
         3oz4USMeQhVW3Zq8caGLamRhJpA0GBe4dFgDzftE/w5N8WyfWGOo0s8RBWjfVfyEHyAT
         F3aH+uYy2LQ2hNhfKFfCXVpU7MvHlMMW1LXmfzsj93bqT2AbCsytjTCHcZTjCVAtBQUA
         XpEQ==
X-Gm-Message-State: AOAM530wuI00wyGFvSALGG62/bxnnEcYJIcVktw3kXYdg92pux6XEcga
	Vb34voxRLChvAsz3h27+vhcwfKi5TwiODsNiddaqWA==
X-Google-Smtp-Source: ABdhPJwgdeM7vJZ2DKKwalEr7KeonINU2K18nZr67CpB7ixzXQKpSb7Eol7dgHhzUPEgLb+CGDYy92xBtwbeaxDZs1M=
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id
 i11-20020a1709026acb00b0014276c3d35fmr2967201plt.89.1637639486743; Mon, 22
 Nov 2021 19:51:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-8-hch@lst.de>
In-Reply-To: <20211109083309.584081-8-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 19:51:15 -0800
Message-ID: <CAPcyv4jnLdFaDwLTeRhJcTzyjd-psZRgWqVDqzOAZr3EGLbF2w@mail.gmail.com>
Subject: Re: [PATCH 07/29] xfs: factor out a xfs_setup_dax_always helper
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	device-mapper development <dm-devel@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Factor out another DAX setup helper to simplify future changes.  Also
> move the experimental warning after the checks to not clutter the log
> too much if the setup failed.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
