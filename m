Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF972C83
	for <nvdimm@lists.linux.dev>; Thu, 28 Oct 2021 01:36:23 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id o133so4423714pfg.7
        for <nvdimm@lists.linux.dev>; Wed, 27 Oct 2021 18:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7Igm7cptJn/BPiAKOvXNcYjYvau2fVkwbEBPR40Qac=;
        b=nDN9pMycEij+MvvSNlzKvOXo8vpzX9jkSPwoFJ+o4gm3MZL73HDZVz6xJnzjMcbY/h
         uxqb8I8SZcSxzyFyBYzX7/LIRnqjurLkxyKCXt7vyn4OmQMNyDT08nPuKyqwzm30Iyl3
         YY7ptNRp5CFdB0o2rG3ZcydKtS+P5TBWxjp9noe/kCn6hPByhWq1BSGoPPpBqB7Delwx
         7OpBf+W0FVyg/SVq09iZbg3g6KwhgjDGpF6ftYJKhyxVAQrctr7Lax8JbvRVtA2fECbQ
         ljET309ufBhSYyMPecwX45v0eqgX6tTFFZvO7U3Ppi7VtOy0tKDgD/ePUmL2riKDB8uo
         7IaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7Igm7cptJn/BPiAKOvXNcYjYvau2fVkwbEBPR40Qac=;
        b=2jWJObgsKdIk0o2bGxbo31sDwA/b1OAFb8nxCIs8AZylda7BO8OS/cFpB+e2knkXjm
         hYUnhaWZL140lKT/6/Ftmnp/QgBCMwRXe1UYvS9iZXhNEwTP0mchLHoTGBm+sJMspg9g
         cJpyqwZta+qexPWc/PNdYQy5l8n+23AItRi2MvlWc58n2j6VTNmf3LwbeKjPxOxnPuV9
         0yv2xZWVb1q9Gl8Ug0+tzRCwfBEZbJg8oDqAPP8txVhk3SoNZHxyxxaf9YwkxZ1XDGEL
         J2ocsUElpSeqfSvnzqEw7dnduvivSDvUJk+2gmL/e/FB18vBk/ibLbRGBCCAEMhpHHEG
         KQxg==
X-Gm-Message-State: AOAM531dAmHak4RGArL6ULc9TlPsm5QiZIFDCXr/zYgfY9VCcDO5mv8W
	yyA99tKsHJ/jA/ylHTtnT4S4p8rQQ8XliCH+Jhrkig==
X-Google-Smtp-Source: ABdhPJyDv7rjKjhKzGrFppXBu1eyKYCO/S0EEDW+vfLySK20rv/agORLXNPU8PUP/nGzDZcfnIyFx3qV7wWhC+ogeBA=
X-Received: by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id
 l14-20020a056a00140e00b00444b07751efmr1317245pfu.61.1635384983516; Wed, 27
 Oct 2021 18:36:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de> <20211018044054.1779424-10-hch@lst.de>
In-Reply-To: <20211018044054.1779424-10-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 18:36:11 -0700
Message-ID: <CAPcyv4iaUPEo73+KsBdYhM72WqKqJpshL-YU_iWoujk5jNUhmA@mail.gmail.com>
Subject: Re: [PATCH 09/11] dm-log-writes: add a log_writes_dax_pgoff helper
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>, device-mapper development <dm-devel@redhat.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-erofs@lists.ozlabs.org, linux-ext4 <linux-ext4@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.

Looks good.

Mike, ack?
