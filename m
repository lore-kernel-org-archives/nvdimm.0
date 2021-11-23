Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A112C88
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 03:59:36 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id q16so1424749pgq.10
        for <nvdimm@lists.linux.dev>; Mon, 22 Nov 2021 19:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=gwTsNrCEoSododJW02pXoG5va8bW6OECitQWc09+sfRQX7sjnk65lMa71jflZhqZ1Z
         86aeuya1xffrx25hqOEdYvOiHJs5SgCPT9ynh1h37Y6R+YK22M+VCRKtE4fEa7B4vmJj
         FgIl1EAn3HVhHAskqaElmROImyfgrhseCNECcArK+N8mGcWyaNrHQ2uUa5SryedQ51xK
         EFHOUqysfj0ZP5ewN50SJI8X536nWAnVKZXIvFxFdkrKxXPVOOjm85CFAu2VFaD2Y1/c
         IkmhJjqPuO4/my+NrNDZVrBhbYZL7tBr4KB5P4Dw+Kdi1tW3eMcLXRLw1g/M1n7CsTvT
         3cxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=T1/JKUoJvzDQbKgGmiSzHuaX3lld8AA+NlrvRC24jcfaXOgQwWFaSswbpTa6FrYyFZ
         k7yE56Y1C7qCACeZDe2bLtozG3/+OAaeJSKtduK4+QVNl2R/4efbVMS6bCY4w4+CiUVy
         pP6dUWZdrxGoxyfthIxNI4eWzbnZRUeE8hQIAersd4q5JdUPOX2n44LAld3t7G+qVz06
         TOQPvjsvfPURBYXnmv/aXMaGkR+sOv7f/ugyD47j3Y/8sq8gaiw9GYT7/xABceJ23gQU
         0xjoFcykTeqTufYFyf4C5cB1IP/zJ6PgAyyjtB+JhZ1WZ9h7FDQjyfnaZPXj70CYm9f4
         3McA==
X-Gm-Message-State: AOAM533kq2tnh8+uMNSZ3nq/V8lgKELvxliAQMle/Sg7ar3PARBnTwT2
	PdKx2ZGhwmLIWWeEEGVnk+fH+qXTEtc/A6Rduy63hA==
X-Google-Smtp-Source: ABdhPJwGHnABHnUK3lJPgD02NSEK0H2EfeyLizUEIRr93I6wp+H8p3N47d3IhUfBHGyYAjrqraEpCA3HamH0r9lHbyI=
X-Received: by 2002:a63:85c6:: with SMTP id u189mr1546658pgd.377.1637639976375;
 Mon, 22 Nov 2021 19:59:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-10-hch@lst.de>
In-Reply-To: <20211109083309.584081-10-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 19:59:25 -0800
Message-ID: <CAPcyv4igxMdMA0XpjZt0aXahef5Worvz663ynd5i4=HeKJAqKw@mail.gmail.com>
Subject: Re: [PATCH 09/29] dm-linear: add a linear_dax_pgoff helper
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
